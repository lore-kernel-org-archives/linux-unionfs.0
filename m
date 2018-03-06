Return-Path: <yangerkun@huawei.com>
From: yangerkun <yangerkun@huawei.com>
Subject: [PATCH] overlay: ovl_get_inode should treat file and dir as same while no upper_mnt
Date: Tue, 6 Mar 2018 12:02:23 +0800
Message-ID: <20180306040223.2970-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, zhaohongjiang@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

When there is no upper_mnt, lower multi hardlink should not construct 
multi inode for overlay since there won't copyup.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/overlayfs/inode.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index fcd97b783fa1..fb0a8eff1d8c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -696,7 +696,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	 * Hash non-indexed dir by upper inode for NFS export.
 	 */
 	is_dir = S_ISDIR(realinode->i_mode);
-	if (is_dir && (indexed || !sb->s_export_op || !ofs->upper_mnt))
+	if (!ofs->upper_mnt || (is_dir && !sb->s_export_op))
 		origin = lowerdentry;
 
 	if (upperdentry || origin) {
-- 
2.13.6
