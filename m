From: Chengguang Xu <cgxu@mykernel.net>
Subject: [PATCH] ovl: Sync upper dirty data when sync overlayfs
Date: Tue, 28 Nov 2017 12:40:26 +0800
Message-ID: <1511844026-12765-1-git-send-email-cgxu@mykernel.net>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:11565 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751704AbdK1ElS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 27 Nov 2017 23:41:18 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: amir73il@gmail.com, miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, suyue@meili-inc.com, Chengguang Xu <cgxu@mykernel.net>

Executes filesystem sync or umount on overlayfs, dirty data does not be synced as expected on upper filesystem.
This patch fixes sync filesystem method to keep data consistency for overlayfs.

Signed-off-by: Chengguang Xu <cgxu@mykernel.net>
---
 fs/overlayfs/super.c | 24 ++++++++++++++++++++----
 1 file changed, 20 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f5738e9..9c54345 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -17,6 +17,7 @@
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/writeback.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -231,6 +232,7 @@ static void ovl_put_super(struct super_block *sb)
 	kfree(ufs);
 }
 
+/* Sync real dirty inodes in upper filesystem (if it exists) */
 static int ovl_sync_fs(struct super_block *sb, int wait)
 {
 	struct ovl_fs *ufs = sb->s_fs_info;
@@ -240,12 +242,26 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 	if (!ufs->upper_mnt)
 		return 0;
 	upper_sb = ufs->upper_mnt->mnt_sb;
-	if (!upper_sb->s_op->sync_fs)
-		return 0;
 
-	/* real inodes have already been synced by sync_filesystem(ovl_sb) */
 	down_read(&upper_sb->s_umount);
-	ret = upper_sb->s_op->sync_fs(upper_sb, wait);
+	if (wait)
+		sync_inodes_sb(upper_sb);
+	else
+		writeback_inodes_sb(upper_sb, WB_REASON_SYNC);
+
+	if (upper_sb->s_op->sync_fs)
+		upper_sb->s_op->sync_fs(upper_sb, wait);
+
+	if (!upper_sb->s_bdev) {
+		up_read(&upper_sb->s_umount);
+		return 0;
+	}
+
+	if (wait)
+		ret = filemap_write_and_wait(upper_sb->s_bdev->bd_inode->i_mapping);
+	else
+		ret = filemap_flush(upper_sb->s_bdev->bd_inode->i_mapping);
+
 	up_read(&upper_sb->s_umount);
 	return ret;
 }
-- 
1.8.3.1
