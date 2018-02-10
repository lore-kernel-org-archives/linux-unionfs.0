From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v10] ovl: Improving syncfs efficiency
Date: Sat, 10 Feb 2018 23:50:07 +0800
Message-ID: <1518277807-124416-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mr11p00im-asmtp003.me.com ([17.110.69.254]:22338 "EHLO
        mr11p00im-asmtp003.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751047AbeBJPuZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Feb 2018 10:50:25 -0500
Received: from process-dkim-sign-daemon.mr11p00im-asmtp003.me.com by
 mr11p00im-asmtp003.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P3X00200WFAPK00@mr11p00im-asmtp003.me.com> for
 linux-unionfs@vger.kernel.org; Sat, 10 Feb 2018 15:50:25 +0000 (GMT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, amir73il@gmail.com, jack@suse.cz
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

Current syncfs(2) call on overlayfs just simply call sync_filesystem()
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
---
Changes since v9:
- Rebase on current latest overlayfs-next tree.
- Calling clear_inode() regardless of having upper inode.

Changes since v8:
- Remove unnecessary blk_start_plug() call in ovl_sync_inodes(). 

Changes since v7:
- Check OVL_EVICT_PENDING flag instead of I_FREEING to recognize
inode which is in eviction process.
- Do not move ovl_inode back to ofs->upper_inodes when inode is in
eviction process.
- Delete unnecessary memory barrier in ovl_evict_inode().

Changes since v6:
- Take/release sb->s_sync_lock bofore/after sync_fs to serialize
concurrent syncfs.
- Change list iterating method to improve code readability.
- Fix typo in commit log and comments.
- Add header comment to sync.c.

Changes since v5:
- Move sync related functions to new file sync.c.
- Introduce OVL_EVICT_PENDING flag to avoid race conditions.
- If ovl inode flag is I_WILL_FREE or I_FREEING then syncfs
will wait until OVL_EVICT_PENDING to be cleared.
- Move inode sync operation into evict_inode from drop_inode.
- Call upper_sb->sync_fs with no-wait after sync dirty upper
inodes.
- Hold s_inode_wblist_lock until deleting item from list.
- Remove write_inode fuction because no more used.

Changes since v4:
- Add syncing operation and deleting from upper_inodes list
during ovl inode destruction.
- Export symbol of inode_wait_for_writeback() for waiting
writeback on ovl inode.
- Reuse I_SYNC flag to avoid race conditions between syncfs
and drop_inode.

Changes since v3:
- Introduce upper_inode list to organize ovl inode which has upper inode.
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

 fs/overlayfs/Makefile    |   2 +-
 fs/overlayfs/overlayfs.h |   7 ++
 fs/overlayfs/ovl_entry.h |   5 +
 fs/overlayfs/super.c     |  44 +++----
 fs/overlayfs/sync.c      | 290 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/util.c      |  23 +++-
 6 files changed, 338 insertions(+), 33 deletions(-)
 create mode 100644 fs/overlayfs/sync.c

diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
index 3080234..5c3e909 100644
--- a/fs/overlayfs/Makefile
+++ b/fs/overlayfs/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_OVERLAY_FS) += overlay.o
 
 overlay-objs := super.o namei.o util.o inode.o dir.o readdir.o copy_up.o \
-		export.o
+		export.o sync.o
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 0df25a9..1f95421 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -35,6 +35,8 @@ enum ovl_inode_flag {
 	/* Non-merge dir that may contain whiteout entries */
 	OVL_WHITEOUTS,
 	OVL_INDEX,
+	/* Set when ovl inode is about to be freed */
+	OVL_EVICT_PENDING,
 };
 
 enum ovl_entry_flag {
@@ -256,6 +258,7 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
+void ovl_detach_upper_inodes_list(struct inode *inode);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
@@ -366,3 +369,7 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 
 /* export.c */
 extern const struct export_operations ovl_export_operations;
+
+/* sync.c */
+void ovl_evict_inode(struct inode *inode);
+int ovl_sync_fs(struct super_block *sb, int wait);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index bfef6ed..3d592ea 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -55,6 +55,9 @@ struct ovl_fs {
 	/* Did we take the inuse lock? */
 	bool upperdir_locked;
 	bool workdir_locked;
+	/* upper inode list and lock */
+	spinlock_t upper_inodes_lock;
+	struct list_head upper_inodes;
 };
 
 /* private information held for every overlayfs dentry */
@@ -87,6 +90,8 @@ struct ovl_inode {
 
 	/* synchronize copy up and more */
 	struct mutex lock;
+	/* upper inodes list */
+	struct list_head upper_inodes_list;
 };
 
 static inline struct ovl_inode *OVL_I(struct inode *inode)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9ee37c7..f771bf5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -200,6 +200,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 	oi->__upperdentry = NULL;
 	oi->lower = NULL;
 	mutex_init(&oi->lock);
+	INIT_LIST_HEAD(&oi->upper_inodes_list);
 
 	return &oi->vfs_inode;
 }
@@ -258,36 +259,6 @@ static void ovl_put_super(struct super_block *sb)
 	ovl_free_fs(ofs);
 }
 
-/* Sync real dirty inodes in upper filesystem (if it exists) */
-static int ovl_sync_fs(struct super_block *sb, int wait)
-{
-	struct ovl_fs *ofs = sb->s_fs_info;
-	struct super_block *upper_sb;
-	int ret;
-
-	if (!ofs->upper_mnt)
-		return 0;
-
-	/*
-	 * If this is a sync(2) call or an emergency sync, all the super blocks
-	 * will be iterated, including upper_sb, so no need to do anything.
-	 *
-	 * If this is a syncfs(2) call, then we do need to call
-	 * sync_filesystem() on upper_sb, but enough if we do it when being
-	 * called with wait == 1.
-	 */
-	if (!wait)
-		return 0;
-
-	upper_sb = ofs->upper_mnt->mnt_sb;
-
-	down_read(&upper_sb->s_umount);
-	ret = sync_filesystem(upper_sb);
-	up_read(&upper_sb->s_umount);
-
-	return ret;
-}
-
 /**
  * ovl_statfs
  * @sb: The overlayfs super block
@@ -363,10 +334,18 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 	return 0;
 }
 
+static int ovl_drop_inode(struct inode *inode)
+{
+	if (ovl_inode_upper(inode))
+		ovl_set_flag(OVL_EVICT_PENDING, inode);
+	return 1;
+}
+
 static const struct super_operations ovl_super_operations = {
 	.alloc_inode	= ovl_alloc_inode,
 	.destroy_inode	= ovl_destroy_inode,
-	.drop_inode	= generic_delete_inode,
+	.drop_inode	= ovl_drop_inode,
+	.evict_inode	= ovl_evict_inode,
 	.put_super	= ovl_put_super,
 	.sync_fs	= ovl_sync_fs,
 	.statfs		= ovl_statfs,
@@ -1257,6 +1236,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ofs)
 		goto out;
 
+	spin_lock_init(&ofs->upper_inodes_lock);
+	INIT_LIST_HEAD(&ofs->upper_inodes);
+
 	ofs->creator_cred = cred = prepare_creds();
 	if (!cred)
 		goto out_err;
diff --git a/fs/overlayfs/sync.c b/fs/overlayfs/sync.c
new file mode 100644
index 0000000..6691222
--- /dev/null
+++ b/fs/overlayfs/sync.c
@@ -0,0 +1,290 @@
+/*
+ * Copyright (C) 2018 Meili Inc. All Rights Reserved.
+ * Author Chengguang Xu <cgxu519@icloud.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/fs.h>
+#include <linux/xattr.h>
+#include <linux/mount.h>
+#include <linux/writeback.h>
+#include <linux/blkdev.h>
+#include "overlayfs.h"
+
+/**
+ * upper_inodes list is used for organizing potential target of syncfs,
+ * ovl inode which has upper inode will be added to this list while
+ * initializing or updating and will be deleted from this list while
+ * evicting.
+ *
+ * Introduce ovl_inode flag "OVL_EVICT_PENDING" to indicate the ovl inode
+ * is in eviction process, syncfs(actually ovl_sync_inodes()) will wait on
+ * evicting inode until the IO to be completed in evict_inode().
+ *
+ * inode state/ovl_inode flags cycle in syncfs context will be as below.
+ * OVL_EVICT_PENDING (ovl_inode->flags) is only marked when inode having
+ * upper inode.
+ *
+ * (allocation)
+ *   |
+ * I_NEW (inode->i_state)
+ *   |
+ * NONE  (inode->i_state)
+ *   |
+ * OVL_EVICT_PENDING (ovl_inode->flags)
+ *   |
+ * I_FREEING (inode->i_state) | OVL_EVICT_PENDING (ovl_inode->flags)
+ *   |
+ * I_FREEING (inode->i_state) | I_CLEAR (inode->i_state)
+ *   |
+ * (destruction)
+ *
+ *
+ * There are five locks in in syncfs contexts:
+ *
+ * upper_sb->s_umount(semaphore)    : avoiding r/o to r/w or vice versa
+ * sb->s_sync_lock(mutex)           : avoiding concorrent syncfs running
+ * ofs->upper_inodes_lock(spinlock) : protecting upper_inodes list
+ * sb->s_inode_wblist_lock(spinlock): protecting s_inodes_wb(sync waiting) list
+ * inode->i_lock(spinlock)          : protecting inode fields
+ *
+ * Lock dependencies in syncfs contexts:
+ *
+ * upper_sb->s_umount
+ * 	sb->s_sync_lock
+ * 		ofs->upper_inodes_lock
+ * 			inode->i_lock
+ *
+ * upper_sb->s_umount
+ * 	sb->s_sync_lock
+ * 		sb->s_inode_wblist_lock
+ *
+ */
+
+void ovl_evict_inode(struct inode *inode)
+{
+	if (ovl_inode_upper(inode)) {
+		write_inode_now(ovl_inode_upper(inode), 1);
+		ovl_detach_upper_inodes_list(inode);
+
+		/*
+		 * ovl_sync_inodes() may wait until
+		 * flag OVL_EVICT_PENDING to be cleared.
+		 */
+		spin_lock(&inode->i_lock);
+		ovl_clear_flag(OVL_EVICT_PENDING, inode);
+		wake_up_bit(&OVL_I(inode)->flags, OVL_EVICT_PENDING);
+		spin_unlock(&inode->i_lock);
+	}
+	clear_inode(inode);
+}
+
+void ovl_wait_evict_pending(struct inode *inode)
+{
+	struct ovl_fs *ofs = inode->i_sb->s_fs_info;
+	struct ovl_inode *oi = OVL_I(inode);
+	DEFINE_WAIT_BIT(wait, &oi->flags, OVL_EVICT_PENDING);
+	wait_queue_head_t *wqh;
+
+	BUG_ON(!ovl_test_flag(OVL_EVICT_PENDING, inode));
+
+	wqh = bit_waitqueue(&oi->flags, OVL_EVICT_PENDING);
+	prepare_to_wait(wqh, &wait.wq_entry, TASK_UNINTERRUPTIBLE);
+	spin_unlock(&inode->i_lock);
+	spin_unlock(&ofs->upper_inodes_lock);
+	schedule();
+	finish_wait(wqh, &wait.wq_entry);
+}
+
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
+	struct inode *inode;
+	struct inode *upper_inode;
+	struct blk_plug plug;
+	LIST_HEAD(sync_tmp_list);
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
+	list_splice_init(&ofs->upper_inodes, &sync_tmp_list);
+
+	while (!list_empty(&sync_tmp_list)) {
+		oi = list_first_entry(&sync_tmp_list, struct ovl_inode,
+						upper_inodes_list);
+		inode = &oi->vfs_inode;
+		spin_lock(&inode->i_lock);
+
+		if (inode->i_state & I_NEW) {
+			list_move_tail(&oi->upper_inodes_list,
+					&ofs->upper_inodes);
+			spin_unlock(&inode->i_lock);
+			continue;
+		}
+
+		/*
+		 * If ovl_inode flags is OVL_EVICT_PENDING,
+		 * left sync operation to the ovl_evict_inode(),
+		 * so wait here until OVL_EVICT_PENDING flag to be cleared.
+		 */
+		if (ovl_test_flag(OVL_EVICT_PENDING, inode)) {
+			ovl_wait_evict_pending(inode);
+			goto next;
+		}
+
+		list_move_tail(&oi->upper_inodes_list,
+				&ofs->upper_inodes);
+		ihold(inode);
+		upper_inode = ovl_inode_upper(inode);
+		spin_unlock(&inode->i_lock);
+		spin_unlock(&ofs->upper_inodes_lock);
+
+		if (!(upper_inode->i_state & I_DIRTY_ALL)) {
+			if (!mapping_tagged(upper_inode->i_mapping,
+						PAGECACHE_TAG_WRITEBACK)) {
+				iput(inode);
+				goto next;
+			}
+		} else {
+			sync_inode(upper_inode, &wbc_for_sync);
+		}
+
+		spin_lock(&sb->s_inode_wblist_lock);
+		list_add_tail(&inode->i_wb_list, &sb->s_inodes_wb);
+		spin_unlock(&sb->s_inode_wblist_lock);
+
+next:
+		cond_resched();
+		spin_lock(&ofs->upper_inodes_lock);
+	}
+	spin_unlock(&ofs->upper_inodes_lock);
+	blk_finish_plug(&plug);
+}
+
+/**
+ * ovl_wait_inodes
+ * @sb: The overlayfs super block
+ *
+ * Waiting writeback inodes which are in s_inodes_wb list,
+ * all the IO that has been issued up to the time this
+ * function is enter is guaranteed to be completed.
+ */
+static void ovl_wait_inodes(struct super_block *sb)
+{
+	LIST_HEAD(sync_wait_list);
+	struct inode *inode;
+	struct inode *upper_inode;
+
+	/*
+	 * ovl inode in sb->s_inodes_wb list has already got inode reference,
+	 * this will avoid silent inode droping during waiting on it.
+	 *
+	 * Splice the sync wait list onto a temporary list to avoid waiting on
+	 * inodes that have started writeback after this point.
+	 */
+	spin_lock(&sb->s_inode_wblist_lock);
+	list_splice_init(&sb->s_inodes_wb, &sync_wait_list);
+
+	while (!list_empty(&sync_wait_list)) {
+		inode = list_first_entry(&sync_wait_list, struct inode,
+							i_wb_list);
+		list_del_init(&inode->i_wb_list);
+		upper_inode = ovl_inode_upper(inode);
+		spin_unlock(&sb->s_inode_wblist_lock);
+
+		if (!mapping_tagged(upper_inode->i_mapping,
+				PAGECACHE_TAG_WRITEBACK)) {
+			goto next;
+		}
+
+		filemap_fdatawait_keep_errors(upper_inode->i_mapping);
+		cond_resched();
+
+next:
+		iput(inode);
+		spin_lock(&sb->s_inode_wblist_lock);
+	}
+	spin_unlock(&sb->s_inode_wblist_lock);
+}
+
+/**
+ * ovl_sync_filesystem
+ * @sb: The overlayfs super block
+ *
+ * Sync underlying dirty inodes in upper filesystem and
+ * wait for completion.
+ */
+static int ovl_sync_filesystem(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct super_block *upper_sb = ofs->upper_mnt->mnt_sb;
+	int ret = 0;
+
+	down_read(&upper_sb->s_umount);
+	if (!sb_rdonly(upper_sb)) {
+		/*
+		 * s_sync_lock is used for serializing concurrent
+		 * syncfs operations.
+		 */
+		mutex_lock(&sb->s_sync_lock);
+		ovl_sync_inodes(sb);
+		/* Calling sync_fs with no-wait for better performance. */
+		if (upper_sb->s_op->sync_fs)
+			upper_sb->s_op->sync_fs(upper_sb, 0);
+
+		ovl_wait_inodes(sb);
+		if (upper_sb->s_op->sync_fs)
+			upper_sb->s_op->sync_fs(upper_sb, 1);
+
+		ret = sync_blockdev(upper_sb->s_bdev);
+		mutex_unlock(&sb->s_sync_lock);
+	}
+	up_read(&upper_sb->s_umount);
+	return ret;
+}
+
+/**
+ * ovl_sync_fs
+ * @sb: The overlayfs super block
+ * @wait: Wait for I/O to complete
+ *
+ * Sync real dirty inodes in upper filesystem (if it exists)
+ */
+int ovl_sync_fs(struct super_block *sb, int wait)
+{
+	/*
+	 * If this is a sync(2) call or an emergency sync,
+	 * all the super blocks will be iterated, including
+	 * upper_sb, so no need to do anything.
+	 *
+	 * If this is a syncfs(2) call, then we do need to
+	 * call sync_inode() on underlying dirty upper inode,
+	 * but enough if we do it when being called with wait == 1.
+	 */
+	if (!wait)
+		return 0;
+
+	return ovl_sync_filesystem(sb);
+}
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 930784a..374627e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -276,11 +276,31 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
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
 		OVL_I(inode)->lower = igrab(d_inode(lowerdentry));
 
@@ -302,6 +322,7 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 		inode->i_private = upperinode;
 		__insert_inode_hash(inode, (unsigned long) upperinode);
 	}
+	ovl_attach_upper_inodes_list(inode);
 }
 
 void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
-- 
1.8.3.1
