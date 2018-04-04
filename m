Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v2 2/2] ovl: return error when specifying unchangeable options in remount
Date: Wed,  4 Apr 2018 17:27:16 +0800
Message-Id: <1522834036-132136-2-git-send-email-cgxu519@gmx.com>
In-Reply-To: <1522834036-132136-1-git-send-email-cgxu519@gmx.com>
References: <1522834036-132136-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Check remount options and return error if there is any unchangeable
option.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---

Changes since v1:
- Refactor ovl_free_fs(), move config freeing operations to ovl_free_config()

 fs/overlayfs/super.c | 65 ++++++++++++++++++++++++++++++++--------------------
 1 file changed, 40 insertions(+), 25 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4112720..731c3e5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -224,6 +224,14 @@ static void ovl_destroy_inode(struct inode *inode)
 	call_rcu(&inode->i_rcu, ovl_i_callback);
 }
 
+static void ovl_free_config(struct ovl_config *config)
+{
+	kfree(config->lowerdir);
+	kfree(config->upperdir);
+	kfree(config->workdir);
+	kfree(config->redirect_mode);
+}
+
 static void ovl_free_fs(struct ovl_fs *ofs)
 {
 	unsigned i;
@@ -242,10 +250,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	}
 	kfree(ofs->lower_layers);
 
-	kfree(ofs->config.lowerdir);
-	kfree(ofs->config.upperdir);
-	kfree(ofs->config.workdir);
-	kfree(ofs->config.redirect_mode);
+	ovl_free_config(&ofs->config);
 	if (ofs->creator_cred)
 		put_cred(ofs->creator_cred);
 	kfree(ofs);
@@ -353,27 +358,6 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
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
@@ -649,6 +633,37 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config,
 	return ovl_parse_redirect_mode(config, config->redirect_mode);
 }
 
+static int ovl_remount(struct super_block *sb, int *flags, char *data)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct ovl_config *old_config = &ofs->config;
+	struct ovl_config *new_config;
+	int err;
+
+	if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
+		return -EROFS;
+
+	new_config = kzalloc(sizeof(struct ovl_config), GFP_KERNEL);
+	if (!new_config)
+		return -ENOMEM;
+
+	err = ovl_parse_opt((char *)data, new_config, old_config);
+	ovl_free_config(new_config);
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
