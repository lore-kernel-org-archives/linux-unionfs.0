From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v4] ovl: Improving syncfs efficiency
Date: Mon, 15 Jan 2018 15:33:14 +0800
Message-ID: <1516001594-226478-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mr11p00im-asmtp003.me.com ([17.110.69.254]:22337 "EHLO
        mr11p00im-asmtp003.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752172AbeAOHdq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 15 Jan 2018 02:33:46 -0500
Received: from process-dkim-sign-daemon.mr11p00im-asmtp003.me.com by
 mr11p00im-asmtp003.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2L00G0060PVZ00@mr11p00im-asmtp003.me.com> for
 linux-unionfs@vger.kernel.org; Mon, 15 Jan 2018 07:33:46 +0000 (GMT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: jack@suse.cz, amir73il@gmail.com
Cc: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

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
irrelative container processes on the other overlayfs.

This patch iterates upper inode list in overlayfs to only sync target
dirty inodes and wait for completion. By doing this, It is able to reduce
cost of synchronization and will not seriously impact IO performance of
irrelative processes. In special case, when having very few dirty inodes
and a lot of clean upper inodes in overlayfs, then iteration may waste
time so that synchronization is slower than before, but we think the
potential for performance improvement far surpass the potential for
performance regression in most cases.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
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

 fs/overlayfs/ovl_entry.h |   5 ++
 fs/overlayfs/super.c     | 167 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/util.c      |  13 +++-
 3 files changed, 181 insertions(+), 4 deletions(-)

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
index 76440fe..39fb331 100644
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
@@ -252,6 +255,159 @@ static void ovl_put_super(struct super_block *sb)
 	ovl_free_fs(ofs);
 }
 
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
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct ovl_inode *oi;
+	struct inode *inode, *iput_inode = NULL;
+	struct inode *upper_inode;
+	struct blk_plug plug;
+
+	struct writeback_control wbc = {
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
+
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
+
+		if (!atomic_read(&inode->i_count)) {
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
+
+		ihold(inode);
+		upper_inode = ovl_inode_upper(inode);
+		spin_unlock(&inode->i_lock);
+
+		spin_lock(&upper_inode->i_lock);
+		if (!(upper_inode->i_state & I_DIRTY_ALL)) {
+			iput_inode = inode;
+			spin_unlock(&upper_inode->i_lock);
+			continue;
+		}
+		spin_unlock(&upper_inode->i_lock);
+		spin_unlock(&ofs->upper_inodes_lock);
+
+		if (iput_inode)
+			iput(iput_inode);
+
+		sync_inode(upper_inode, &wbc);
+
+		spin_lock(&sb->s_inode_wblist_lock);
+		if (list_empty(&inode->i_wb_list)) {
+			list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
+		/*
+		 * Hold referece of ovl inode
+		 * until finishing waiting on the inode.
+		 */
+			iput_inode = NULL;
+		} else
+			iput_inode = inode;
+		spin_unlock(&sb->s_inode_wblist_lock);
+
+		if (need_resched()) {
+			blk_finish_plug(&plug);
+			cond_resched();
+			blk_start_plug(&plug);
+		}
+
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
+	mutex_lock(&sb->s_sync_lock);
+	/*
+	 * Splice the sync wait list onto a temporary list to avoid waiting on
+	 * inodes that have started writeback after this point.
+	 */
+	spin_lock(&sb->s_inode_wblist_lock);
+	list_splice_init(&sb->s_inodes_wb, &sync_list);
+	spin_unlock(&sb->s_inode_wblist_lock);
+
+	while (!list_empty(&sync_list)) {
+		inode = list_first_entry(&sync_list, struct inode, i_wb_list);
+		list_del_init(&inode->i_wb_list);
+
+		spin_lock(&inode->i_lock);
+		if (inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) {
+			spin_unlock(&inode->i_lock);
+			iput(inode);
+			continue;
+		}
+
+		upper_inode = ovl_inode_upper(inode);
+		spin_unlock(&inode->i_lock);
+
+		if (!mapping_tagged(upper_inode->i_mapping,
+				PAGECACHE_TAG_WRITEBACK)) {
+			iput(inode);
+			continue;
+		}
+
+		filemap_fdatawait_keep_errors(upper_inode->i_mapping);
+
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
+
+	ovl_sync_inodes(sb);
+	ovl_wait_inodes(sb);
+
+	if (upper_sb->s_op->sync_fs)
+		upper_sb->s_op->sync_fs(upper_sb, 1);
+
+	return sync_blockdev(upper_sb->s_bdev);
+}
+
 /* Sync real dirty inodes in upper filesystem (if it exists) */
 static int ovl_sync_fs(struct super_block *sb, int wait)
 {
@@ -266,17 +422,19 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
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
 
 	upper_sb = ofs->upper_mnt->mnt_sb;
+	if (sb_rdonly(upper_sb))
+		return 0;
 
 	down_read(&upper_sb->s_umount);
-	ret = sync_filesystem(upper_sb);
+	ret = ovl_sync_filesystem(sb);
 	up_read(&upper_sb->s_umount);
 
 	return ret;
@@ -1202,6 +1360,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ofs)
 		goto out;
 
+	spin_lock_init(&ofs->upper_inodes_lock);
+	INIT_LIST_HEAD(&ofs->upper_inodes);
+
 	ofs->creator_cred = cred = prepare_creds();
 	if (!cred)
 		goto out_err;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index d6bb1c9..4d0521a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -254,8 +254,14 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 		    struct dentry *lowerdentry)
 {
-	if (upperdentry)
+	struct ovl_fs *ofs = inode->i_sb->s_fs_info;
+
+	if (upperdentry) {
 		OVL_I(inode)->__upperdentry = upperdentry;
+		spin_lock(&ofs->upper_inodes_lock);
+		list_add(&OVL_I(inode)->upper_inodes_list, &ofs->upper_inodes);
+		spin_unlock(&ofs->upper_inodes_lock);
+	}
 	if (lowerdentry)
 		OVL_I(inode)->lower = d_inode(lowerdentry);
 
@@ -265,6 +271,7 @@ void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 {
 	struct inode *upperinode = d_inode(upperdentry);
+	struct ovl_fs *ofs = inode->i_sb->s_fs_info;
 
 	WARN_ON(OVL_I(inode)->__upperdentry);
 
@@ -277,6 +284,10 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 		inode->i_private = upperinode;
 		__insert_inode_hash(inode, (unsigned long) upperinode);
 	}
+
+	spin_lock(&ofs->upper_inodes_lock);
+	list_add(&OVL_I(inode)->upper_inodes_list, &ofs->upper_inodes);
+	spin_unlock(&ofs->upper_inodes_lock);
 }
 
 void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
-- 
1.8.3.1
