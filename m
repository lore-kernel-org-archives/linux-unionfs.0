From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v2] ovl: Improving syncfs efficiency
Date: Wed, 10 Jan 2018 20:32:11 +0800
Message-ID: <1515587531-33474-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mr11p00im-asmtp002.me.com ([17.110.69.253]:45352 "EHLO
        mr11p00im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933673AbeAJMcg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 07:32:36 -0500
Received: from process-dkim-sign-daemon.mr11p00im-asmtp002.me.com by
 mr11p00im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2C007009G0BC00@mr11p00im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Wed, 10 Jan 2018 12:32:29 +0000 (GMT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

Currently syncfs(2) call on overlayfs just simply call sync_filesystem()
on upper_sb to synchronize whole dirty inodes in upper filesystem
regardless of the overlay ownership of the inode. It has obvious
shortcomings as below.

(1) Performance
Synchronization is probably heavy in most cases, especially when upper
filesystem is not dedicated to target overlayfs.

(2) Interference
Unplanned synchronization will probably impact IO performance of the
processes which use other overlayfs on same upper filesystem or directly
use upper filesystem.

This patch iterates overlay inodes to only sync target dirty inodes in
upper filesystem. By doing this, It is able to reduce cost of synchronization
and will not seriously impact IO performance of irrelative processes.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
Changes since v1:
- If upper filesystem is readonly mode then skip synchronization.
- Introduce global wait list to replace temporary wait list for
concurrent synchronization.

 fs/overlayfs/ovl_entry.h |   5 +++
 fs/overlayfs/super.c     | 105 +++++++++++++++++++++++++++++++++++++++++++++--
 2 files changed, 107 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 9d0bc03..ff935da 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -52,6 +52,9 @@ struct ovl_fs {
 	/* Did we take the inuse lock? */
 	bool upperdir_locked;
 	bool workdir_locked;
+	/* ovl inode sync list and lock */
+	spinlock_t  ovl_sync_list_lock;
+	struct list_head ovl_sync_list;
 };
 
 /* private information held for every overlayfs dentry */
@@ -80,6 +83,8 @@ struct ovl_inode {
 
 	/* synchronize copy up and more */
 	struct mutex lock;
+	/* ovl inode sync list */
+	struct list_head sync_list;
 };
 
 static inline struct ovl_inode *OVL_I(struct inode *inode)
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76440fe..c7b788b 100644
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
+	INIT_LIST_HEAD(&oi->sync_list);
 
 	return &oi->vfs_inode;
 }
@@ -252,6 +255,97 @@ static void ovl_put_super(struct super_block *sb)
 	ovl_free_fs(ofs);
 }
 
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
+	struct ovl_inode *oi, *oi_next;
+	struct inode *inode, *i_next;
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
+	spin_lock(&sb->s_inode_list_lock);
+	list_for_each_entry_safe(inode, i_next, &sb->s_inodes, i_sb_list) {
+		upper_inode = ovl_inode_upper(inode);
+		if (!upper_inode)
+			continue;
+
+		spin_lock(&upper_inode->i_lock);
+		if (upper_inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE) ||
+			list_empty(&upper_inode->i_io_list)) {
+			spin_unlock(&upper_inode->i_lock);
+			continue;
+		}
+		spin_unlock(&upper_inode->i_lock);
+
+		if (!igrab(inode))
+			continue;
+
+		if (!igrab(upper_inode)) {
+			iput(inode);
+			continue;
+		}
+		spin_unlock(&sb->s_inode_list_lock);
+
+		sync_inode(upper_inode, &wbc);
+		spin_lock(&ofs->ovl_sync_list_lock);
+		if (list_empty(&OVL_I(inode)->sync_list))
+			list_add(&OVL_I(inode)->sync_list, &ofs->ovl_sync_list);
+		else {
+			iput(upper_inode);
+			iput(inode);
+		}
+		spin_unlock(&ofs->ovl_sync_list_lock);
+
+		if (need_resched()) {
+			blk_finish_plug(&plug);
+			cond_resched();
+			blk_start_plug(&plug);
+		}
+		spin_lock(&sb->s_inode_list_lock);
+	}
+	spin_unlock(&sb->s_inode_list_lock);
+	blk_finish_plug(&plug);
+
+	mutex_lock(&upper_sb->s_sync_lock);
+	spin_lock(&ofs->ovl_sync_list_lock);
+	list_for_each_entry_safe(oi, oi_next, &ofs->ovl_sync_list, sync_list) {
+		upper_inode = ovl_inode_upper(&oi->vfs_inode);
+		spin_unlock(&ofs->ovl_sync_list_lock);
+
+		filemap_fdatawait_keep_errors(upper_inode->i_mapping);
+		list_del_init(&oi->sync_list);
+		iput(upper_inode);
+		iput(&oi->vfs_inode);
+
+		if (need_resched())
+			cond_resched();
+		spin_lock(&ofs->ovl_sync_list_lock);
+	}
+	spin_unlock(&ofs->ovl_sync_list_lock);
+	mutex_unlock(&upper_sb->s_sync_lock);
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
@@ -266,17 +360,19 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
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
@@ -1206,6 +1302,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!cred)
 		goto out_err;
 
+	spin_lock_init(&ofs->ovl_sync_list_lock);
+	INIT_LIST_HEAD(&ofs->ovl_sync_list);
+
 	ofs->config.index = ovl_index_def;
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
-- 
1.8.3.1
