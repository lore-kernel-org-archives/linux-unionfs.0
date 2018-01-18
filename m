From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v5] ovl: Improving syncfs efficiency
Date: Thu, 18 Jan 2018 14:53:32 +0800
Message-ID: <1516258412-122012-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mr11p00im-asmtp001.me.com ([17.110.69.252]:43907 "EHLO
        mr11p00im-asmtp001.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753812AbeARGxs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 18 Jan 2018 01:53:48 -0500
Received: from process-dkim-sign-daemon.mr11p00im-asmtp001.me.com by
 mr11p00im-asmtp001.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2Q00D00OE7WR00@mr11p00im-asmtp001.me.com> for
 linux-unionfs@vger.kernel.org; Thu, 18 Jan 2018 06:53:47 +0000 (GMT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: jack@suse.cz, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

Currently syncfs(2) call on overlayfs just simply call sync_filesystem()
on upper_sb to synchronize whole dirty inodes in upper filesystem
regardless of the overlay ownership of the inode. In the use case of
container, when multiple containers using the same underlying upper
filesystem, it has some shortcomings as below.

(1) Performance
Synchronization is probably heavy because it actually syncs unnecessary
inodes for target overlayfs.

(2) Interference
Unplanned synchronization will probably impact IO performance of
unrelated container processes on the other overlayfs.

This patch iterates upper inode list in overlayfs to only sync target
dirty inodes and wait for completion. By doing this, It is able to reduce
cost of synchronization and will not seriously impact IO performance of
unrelated processes. In special case, when having very few dirty inodes
and a lot of clean upper inodes in overlayfs, then iteration may waste
time so that synchronization is slower than before, but we think the
potential for performance improvement far surpass the potential for
performance regression in most cases.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
Changes since v4:
- Add syncing operation and deleting from upper_inodes list
during ovl inode destruction.
- Export symbol of inode_wait_for_writeback() for waiting
writeback on ovl inode.
- Reuse I_SYNC flag to avoid race conditions between syncfs
and drop_inode.

Changes since v3:
- Introduce upper_inode list to organize ovl indoe which has upper inode.
- Avoid iput operation inside spin lock.
- Change list iteration method for safety.
- Reuse inode->i_wb_list and sb->s_inodes_wb to save memory.
- Modify commit log and add more comments to the code.

Changes since v2:
- Decoupling with syncfs of upper fs by taking sb->s_sync_lock of
overlayfs.
- Factoring out sync operation to different helpers for easy understanding.

Changes since v1:
- If upper filesystem is readonly mode then skip synchronization.
- Introduce global wait list to replace temporary wait list for
concurrent synchronization.

 fs/fs-writeback.c        |   1 +
 fs/overlayfs/overlayfs.h |   1 +
 fs/overlayfs/ovl_entry.h |   5 +
 fs/overlayfs/super.c     | 270 ++++++++++++++++++++++++++++++++++++++++++++---
 fs/overlayfs/util.c      |  23 +++-
 5 files changed, 283 insertions(+), 17 deletions(-)

diff --git a/fs/fs-writeback.c b/fs/fs-writeback.c
index cea4836..8c58664 100644
--- a/fs/fs-writeback.c
+++ b/fs/fs-writeback.c
@@ -1215,6 +1215,7 @@ void inode_wait_for_writeback(struct inode *inode)
 	__inode_wait_for_writeback(inode);
 	spin_unlock(&inode->i_lock);
 }
+EXPORT_SYMBOL(inode_wait_for_writeback);
 
 /*
  * Sleep until I_SYNC is cleared. This function must be called with i_lock
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b489099..2b65b6a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -241,6 +241,7 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
+void ovl_detach_upper_inodes_list(struct inode *inode);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 9d0bc03..53909ba 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -52,6 +52,9 @@ struct ovl_fs {
 	/* Did we take the inuse lock? */
 	bool upperdir_locked;
 	bool workdir_locked;
+	/* upper inode list and lock */
+	spinlock_t upper_inodes_lock;
+	struct list_head upper_inodes;
 };
 
 /* private information held for every overlayfs dentry */
@@ -80,6 +83,8 @@ struct ovl_inode {
 
 	/* synchronize copy up and more */
 	struct mutex lock;
+	/* upper inodes list */
+	struct list_head upper_inodes_list;
 };
 
 static inline struct ovl_inode *OVL_I(struct inode *inode)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76440fe..2026acf 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -17,6 +17,8 @@
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/writeback.h>
+#include <linux/blkdev.h>
 #include "overlayfs.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
@@ -195,6 +197,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->__upperdentry = NULL;
 	oi->lower = NULL;
 	mutex_init(&oi->lock);
+	INIT_LIST_HEAD(&oi->upper_inodes_list);
 
 	return &oi->vfs_inode;
 }
@@ -252,34 +255,228 @@ static void ovl_put_super(struct super_block *sb)
 	ovl_free_fs(ofs);
 }
 
-/* Sync real dirty inodes in upper filesystem (if it exists) */
-static int ovl_sync_fs(struct super_block *sb, int wait)
+/**
+ * ovl_sync_single_inode
+ * @sb: The overlayfs inode
+ * @detach: Detach from upper inode list when setting true
+ *
+ * Sync and wait for ovl inode which is in the dropping process.
+ */
+static void ovl_sync_single_inode(struct inode *inode, bool detach)
+{
+	struct inode *upper_inode = ovl_inode_upper(inode);
+
+	struct writeback_control wbc = {
+		.sync_mode		= WB_SYNC_ALL,
+		.range_start		= 0,
+		.range_end		= LLONG_MAX,
+		.nr_to_write		= LONG_MAX,
+	};
+
+	if (!list_empty(&upper_inode->i_io_list))
+		sync_inode(upper_inode, &wbc);
+	else if (!list_empty(&upper_inode->i_wb_list))
+		filemap_fdatawait_keep_errors(upper_inode->i_mapping);
+
+	if (detach)
+		ovl_detach_upper_inodes_list(inode);
+}
+/**
+ * ovl_sync_inodes
+ * @sb: The overlayfs super block
+ *
+ * upper_inodes list is used for organizing ovl inode which has upper inode,
+ * by iterating the list to looking for and syncing dirty upper inode.
+ *
+ * When starting syncing inode, we add the inode to wait list explicitly,
+ * in order to save memory we reuse inode->i_wb_list and sb->s_inodes_wb,
+ * so those fields have slightly differnt meanings in overlayfs.
+ */
+static void ovl_sync_inodes(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
-	struct super_block *upper_sb;
-	int ret;
+	struct ovl_inode *oi;
+	struct inode *inode, *iput_inode = NULL;
+	struct inode *upper_inode;
+	struct blk_plug plug;
+
+	struct writeback_control wbc_for_sync = {
+		.sync_mode		= WB_SYNC_ALL,
+		.for_sync		= 1,
+		.range_start		= 0,
+		.range_end		= LLONG_MAX,
+		.nr_to_write		= LONG_MAX,
+	};
+
+	blk_start_plug(&plug);
+	spin_lock(&ofs->upper_inodes_lock);
+	list_for_each_entry(oi, &ofs->upper_inodes, upper_inodes_list) {
+		inode = &oi->vfs_inode;
+		spin_lock(&inode->i_lock);
+
+		if (inode->i_state & I_NEW) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
 
-	if (!ofs->upper_mnt)
-		return 0;
+		/*
+		 * When i_count is 0 ovl inode is in the process of destruction,
+		 * so wait at once after syncing instead of adding inode to the
+		 * waiting list.
+		 */
+		if (!atomic_read(&inode->i_count)) {
+			upper_inode = ovl_inode_upper(inode);
+			if (inode->i_state & I_SYNC) {
+				spin_unlock(&inode->i_lock);
+				igrab(upper_inode);
+				spin_unlock(&ofs->upper_inodes_lock);
+				inode_wait_for_writeback(upper_inode);
+				filemap_fdatawait_keep_errors(upper_inode->i_mapping);
+				iput(upper_inode);
+				goto next;
+			}
+
+			/*
+			 * Reuse I_SYNC flag to avoid race conditions with the
+			 * sync operation in ovl_drop_inode.
+			 */
+			inode->i_state |= I_SYNC;
+			spin_unlock(&inode->i_lock);
+			spin_unlock(&ofs->upper_inodes_lock);
+
+			ovl_sync_single_inode(inode, false);
+
+			spin_lock(&inode->i_lock);
+			inode->i_state &= ~I_SYNC;
+			spin_unlock(&inode->i_lock);
+			goto next;
+		}
+
+		ihold(inode);
+		upper_inode = ovl_inode_upper(inode);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&ofs->upper_inodes_lock);
+
+		if (iput_inode)
+			iput(iput_inode);
+
+		if (list_empty(&upper_inode->i_io_list)) {
+			if (list_empty(&upper_inode->i_wb_list)) {
+				iput_inode = inode;
+				goto next;
+			}
+		} else {
+			sync_inode(upper_inode, &wbc_for_sync);
+		}
+
+		/*
+		 * When ovl inode is not in sb->s_inodes_wb list,
+		 * hold referece until finishing waiting on the inode.
+		 */
+		spin_lock(&sb->s_inode_wblist_lock);
+		if (list_empty(&inode->i_wb_list)) {
+			list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
+			iput_inode = NULL;
+		} else {
+			iput_inode = inode;
+		}
+		spin_unlock(&sb->s_inode_wblist_lock);
+
+next:
+		if (need_resched()) {
+			blk_finish_plug(&plug);
+			cond_resched();
+			blk_start_plug(&plug);
+		}
+		spin_lock(&ofs->upper_inodes_lock);
+	}
+	spin_unlock(&ofs->upper_inodes_lock);
+	blk_finish_plug(&plug);
+
+	if (iput_inode)
+		iput(iput_inode);
+}
+
+static void ovl_wait_inodes(struct super_block *sb)
+{
+	LIST_HEAD(sync_list);
+	struct inode *inode;
+	struct inode *upper_inode;
+
+	/*
+	 * ovl inode in sb->s_inodes_wb list has already got inode reference,
+	 * this will avoid silent droping during waiting on it.
+	 * Splice the sync wait list onto a temporary list to avoid waiting on
+	 * inodes that have started writeback after this point.
+	 */
+	mutex_lock(&sb->s_sync_lock);
+	spin_lock(&sb->s_inode_wblist_lock);
+	list_splice_init(&sb->s_inodes_wb, &sync_list);
+	spin_unlock(&sb->s_inode_wblist_lock);
+
+	while (!list_empty(&sync_list)) {
+		inode = list_first_entry(&sync_list, struct inode, i_wb_list);
+		list_del_init(&inode->i_wb_list);
+		upper_inode = ovl_inode_upper(inode);
+
+		if (!mapping_tagged(upper_inode->i_mapping,
+				PAGECACHE_TAG_WRITEBACK)) {
+			iput(inode);
+			continue;
+		}
+
+		filemap_fdatawait_keep_errors(upper_inode->i_mapping);
 
+		if (need_resched())
+			cond_resched();
+
+		iput(inode);
+	}
+	mutex_unlock(&sb->s_sync_lock);
+}
+
+/**
+ * ovl_sync_filesystem
+ * @sb: The overlayfs super block
+ *
+ * Sync underlying dirty inodes in upper filesystem and wait for completion.
+ */
+static int ovl_sync_filesystem(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct super_block *upper_sb = ofs->upper_mnt->mnt_sb;
+	int ret = 0;
+
+	down_read(&upper_sb->s_umount);
+	if (!sb_rdonly(upper_sb)) {
+
+		ovl_sync_inodes(sb);
+		ovl_wait_inodes(sb);
+
+		if (upper_sb->s_op->sync_fs)
+			upper_sb->s_op->sync_fs(upper_sb, 1);
+
+		ret = sync_blockdev(upper_sb->s_bdev);
+	}
+	up_read(&upper_sb->s_umount);
+	return ret;
+}
+
+/* Sync real dirty inodes in upper filesystem (if it exists) */
+static int ovl_sync_fs(struct super_block *sb, int wait)
+{
 	/*
 	 * If this is a sync(2) call or an emergency sync, all the super blocks
 	 * will be iterated, including upper_sb, so no need to do anything.
 	 *
-	 * If this is a syncfs(2) call, then we do need to call
-	 * sync_filesystem() on upper_sb, but enough if we do it when being
+	 * If this is a syncfs(2) call, then we do need to call sync_inode()
+	 * on underlying dirty upper_inode, but enough if we do it when being
 	 * called with wait == 1.
 	 */
 	if (!wait)
 		return 0;
 
-	upper_sb = ofs->upper_mnt->mnt_sb;
-
-	down_read(&upper_sb->s_umount);
-	ret = sync_filesystem(upper_sb);
-	up_read(&upper_sb->s_umount);
-
-	return ret;
+	return ovl_sync_filesystem(sb);
 }
 
 /**
@@ -354,10 +551,48 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 	return 0;
 }
 
+/**
+ * In the case of memory pressure, ovl inode may drop even having dirty upper
+ * inode, in the process of ovl inode destruction, if inode state if not I_SYNC,
+ * then need call ovl_sync_single_inode to sync and waiting for comletion and
+ * deleting from upper_inodes list.
+ */
+static int ovl_drop_inode(struct inode *inode)
+{
+	if (inode->i_state & I_SYNC) {
+		spin_unlock(&inode->i_lock);
+		ovl_detach_upper_inodes_list(inode);
+		inode_wait_for_writeback(inode);
+		spin_lock(&inode->i_lock);
+		return 1;
+	}
+
+	inode->i_state |= I_SYNC;
+	spin_unlock(&inode->i_lock);
+
+	ovl_sync_single_inode(inode, true);
+
+	spin_lock(&inode->i_lock);
+	inode->i_state &= ~I_SYNC;
+	return 1;
+}
+
+static int ovl_write_inode(struct inode *inode, struct writeback_control *wbc)
+{
+	struct inode *upper_inode = ovl_inode_upper(inode);
+	struct super_block *upper_sb = upper_inode->i_sb;
+
+	if (upper_sb->s_op->write_inode)
+		return upper_sb->s_op->write_inode(upper_inode, wbc);
+
+	return 0;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.alloc_inode	= ovl_alloc_inode,
 	.destroy_inode	= ovl_destroy_inode,
-	.drop_inode	= generic_delete_inode,
+	.drop_inode	= ovl_drop_inode,
+	.write_inode	= ovl_write_inode,
 	.put_super	= ovl_put_super,
 	.sync_fs	= ovl_sync_fs,
 	.statfs		= ovl_statfs,
@@ -1202,6 +1437,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ofs)
 		goto out;
 
+	spin_lock_init(&ofs->upper_inodes_lock);
+	INIT_LIST_HEAD(&ofs->upper_inodes);
+
 	ofs->creator_cred = cred = prepare_creds();
 	if (!cred)
 		goto out_err;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index d6bb1c9..621d5d4 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -251,11 +251,31 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
 	oi->redirect = redirect;
 }
 
+void ovl_attach_upper_inodes_list(struct inode *inode)
+{
+	struct ovl_fs *ofs = inode->i_sb->s_fs_info;
+
+	spin_lock(&ofs->upper_inodes_lock);
+	list_add(&OVL_I(inode)->upper_inodes_list, &ofs->upper_inodes);
+	spin_unlock(&ofs->upper_inodes_lock);
+}
+
+void ovl_detach_upper_inodes_list(struct inode *inode)
+{
+	struct ovl_fs *ofs = inode->i_sb->s_fs_info;
+
+	spin_lock(&ofs->upper_inodes_lock);
+	list_del_init(&OVL_I(inode)->upper_inodes_list);
+	spin_unlock(&ofs->upper_inodes_lock);
+}
+
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 		    struct dentry *lowerdentry)
 {
-	if (upperdentry)
+	if (upperdentry) {
 		OVL_I(inode)->__upperdentry = upperdentry;
+		ovl_attach_upper_inodes_list(inode);
+	}
 	if (lowerdentry)
 		OVL_I(inode)->lower = d_inode(lowerdentry);
 
@@ -277,6 +297,7 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 		inode->i_private = upperinode;
 		__insert_inode_hash(inode, (unsigned long) upperinode);
 	}
+	ovl_attach_upper_inodes_list(inode);
 }
 
 void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
-- 
1.8.3.1
