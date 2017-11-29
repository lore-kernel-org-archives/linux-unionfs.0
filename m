From: Chengguang Xu <cgxu@mykernel.net>
Subject: [PATCH v4] ovl: Sync upper dirty data when sync overlayfs
Date: Wed, 29 Nov 2017 10:01:32 +0800
Message-ID: <1511920892-50942-1-git-send-email-cgxu@mykernel.net>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:21569 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752111AbdK2CDI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 21:03:08 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu@mykernel.net>

When executing filesystem sync or umount on overlayfs,
dirty data does not get synced as expected on upper filesystem.
This patch fixes sync filesystem method to keep data consistency
for overlayfs.

Signed-off-by: Chengguang Xu <cgxu@mykernel.net>
---
Changes since v3:
-Rebase onto overlayfs-next tree.

Changes since v2:
-Fix checkpatch warning.

Changes since v1:
-Call __sync_filesystem() instead of directly calling low level
 syncing functions.

 fs/overlayfs/super.c | 6 ++----
 fs/sync.c            | 3 ++-
 include/linux/fs.h   | 1 +
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index be03578..6173ca9 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -244,6 +244,7 @@ static void ovl_put_super(struct super_block *sb)
 	ovl_free_fs(ofs);
 }
 
+/* Sync real dirty inodes in upper filesystem (if it exists) */
 static int ovl_sync_fs(struct super_block *sb, int wait)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
@@ -253,12 +254,9 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 	if (!ofs->upper_mnt)
 		return 0;
 	upper_sb = ofs->upper_mnt->mnt_sb;
-	if (!upper_sb->s_op->sync_fs)
-		return 0;
 
-	/* real inodes have already been synced by sync_filesystem(ovl_sb) */
 	down_read(&upper_sb->s_umount);
-	ret = upper_sb->s_op->sync_fs(upper_sb, wait);
+	ret = __sync_filesystem(upper_sb, wait);
 	up_read(&upper_sb->s_umount);
 	return ret;
 }
diff --git a/fs/sync.c b/fs/sync.c
index 83ac79a..76c913e 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -28,7 +28,7 @@
  * wait == 1 case since in that case write_inode() functions do
  * sync_dirty_buffer() and thus effectively write one block at a time.
  */
-static int __sync_filesystem(struct super_block *sb, int wait)
+int __sync_filesystem(struct super_block *sb, int wait)
 {
 	if (wait)
 		sync_inodes_sb(sb);
@@ -39,6 +39,7 @@ static int __sync_filesystem(struct super_block *sb, int wait)
 		sb->s_op->sync_fs(sb, wait);
 	return __sync_blockdev(sb->s_bdev, wait);
 }
+EXPORT_SYMBOL(__sync_filesystem);
 
 /*
  * Write out and wait upon all dirty data associated with this
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 885266a..99c2dd40 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2463,6 +2463,7 @@ static inline bool sb_is_blkdev_sb(struct super_block *sb)
 	return false;
 }
 #endif
+extern int __sync_filesystem(struct super_block *sb, int wait);
 extern int sync_filesystem(struct super_block *);
 extern const struct file_operations def_blk_fops;
 extern const struct file_operations def_chr_fops;
-- 
1.8.3.1
