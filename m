Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v5 2/3] ovl: move the code of ovl_remount() to behind ovl_parse_opt()
Date: Sat, 14 Apr 2018 14:35:43 +0800
Message-Id: <1523687744-10103-3-git-send-email-cgxu519@gmx.com>
In-Reply-To: <1523687744-10103-1-git-send-email-cgxu519@gmx.com>
References: <1523687744-10103-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Move the code of ovl_remount() around without any functional change,
so that ovl_remount() can call ovl_parse_opt() without explicit
statement.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/overlayfs/super.c | 42 +++++++++++++++++++++---------------------
 1 file changed, 21 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e99864e..0293635a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -379,27 +379,6 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	return 0;
 }
 
-static int ovl_remount(struct super_block *sb, int *flags, char *data)
-{
-	struct ovl_fs *ofs = sb->s_fs_info;
-
-	if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
-		return -EROFS;
-
-	return 0;
-}
-
-static const struct super_operations ovl_super_operations = {
-	.alloc_inode	= ovl_alloc_inode,
-	.destroy_inode	= ovl_destroy_inode,
-	.drop_inode	= generic_delete_inode,
-	.put_super	= ovl_put_super,
-	.sync_fs	= ovl_sync_fs,
-	.statfs		= ovl_statfs,
-	.show_options	= ovl_show_options,
-	.remount_fs	= ovl_remount,
-};
-
 enum {
 	OPT_LOWERDIR,
 	OPT_UPPERDIR,
@@ -563,6 +542,27 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 	return ovl_parse_redirect_mode(config);
 }
 
+static int ovl_remount(struct super_block *sb, int *flags, char *data)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
+		return -EROFS;
+
+	return 0;
+}
+
+static const struct super_operations ovl_super_operations = {
+	.alloc_inode	= ovl_alloc_inode,
+	.destroy_inode	= ovl_destroy_inode,
+	.drop_inode	= generic_delete_inode,
+	.put_super	= ovl_put_super,
+	.sync_fs	= ovl_sync_fs,
+	.statfs		= ovl_statfs,
+	.show_options	= ovl_show_options,
+	.remount_fs	= ovl_remount,
+};
+
 #define OVL_WORKDIR_NAME "work"
 #define OVL_INDEXDIR_NAME "index"
 
-- 
1.8.3.1
