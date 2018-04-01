Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 2/2] ovl: return error when specifying unchangeable options in remount
Date: Sun,  1 Apr 2018 12:57:55 +0800
Message-Id: <1522558675-70756-2-git-send-email-cgxu519@gmx.com>
In-Reply-To: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Check remount options and return error if there is any unchangeable
option.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/overlayfs/super.c | 110 +++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 89 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5c8944b..ba00295 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -353,27 +353,6 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
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
@@ -534,6 +513,95 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config, bool remount)
 	return ovl_parse_redirect_mode(config, config->redirect_mode);
 }
 
+static bool ovl_string_option_equal(const char *new, const char *old)
+{
+	if (new) {
+		if (old) {
+			if (!strcmp(new, old))
+				return true;
+			else
+				return false;
+		} else {
+			return false;
+		}
+	} else {
+		if (old)
+			return false;
+		else
+			return true;
+	}
+}
+
+static int ovl_remount(struct super_block *sb, int *flags, char *data)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct ovl_config *old_config = &ofs->config;
+	struct ovl_config *new_config;
+	bool remount = true;
+	int err;
+
+	if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
+		return -EROFS;
+
+	new_config = kzalloc(sizeof(struct ovl_config), GFP_KERNEL);
+	if (!new_config)
+		return -ENOMEM;
+
+	new_config->index = old_config->index;
+	new_config->nfs_export = old_config->nfs_export;
+
+	err = ovl_parse_opt((char *)data, new_config, remount);
+	if (err)
+		goto out_err;
+
+	err = -EINVAL;
+	if (new_config->lowerdir &&
+			!ovl_string_option_equal(new_config->lowerdir,
+					old_config->lowerdir))
+		goto out_err;
+
+	if (new_config->upperdir &&
+			!ovl_string_option_equal(new_config->upperdir,
+					old_config->upperdir))
+		goto out_err;
+
+	if (new_config->workdir &&
+			!ovl_string_option_equal(new_config->workdir,
+					old_config->workdir))
+		goto out_err;
+
+	if (new_config->redirect_mode &&
+		!ovl_string_option_equal(new_config->redirect_mode,
+					old_config->redirect_mode))
+		goto out_err;
+
+	if (new_config->index != old_config->index)
+		goto out_err;
+
+	if (new_config->nfs_export != old_config->nfs_export)
+		goto out_err;
+
+	return 0;
+out_err:
+	kfree(new_config->lowerdir);
+	kfree(new_config->upperdir);
+	kfree(new_config->workdir);
+	kfree(new_config->redirect_mode);
+	kfree(new_config);
+	return err;
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
