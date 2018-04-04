Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v2 1/2] ovl: add option parsing support for remount
Date: Wed,  4 Apr 2018 17:27:15 +0800
Message-Id: <1522834036-132136-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Some overlayfs mount options cannot be changed via remount,
but remount operation does not return proper error even if
we specify different value to unchangeable options.

This patch add option parsing support for remount so we can
recogonize unchangeable options in remount.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---

Changes since v1:
- Add remount option validation to parse_opt()

 fs/overlayfs/super.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 127 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7c24619..4112720 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -425,6 +425,16 @@ static char *ovl_next_opt(char **s)
 
 static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
 {
+
+	if (!mode) {
+		config->redirect_mode = kstrdup(ovl_redirect_mode_def(),
+							GFP_KERNEL);
+		if (!config->redirect_mode)
+			return -ENOMEM;
+
+		mode = config->redirect_mode;
+	}
+
 	if (strcmp(mode, "on") == 0) {
 		config->redirect_dir = true;
 		/*
@@ -446,13 +456,49 @@ static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
 	return 0;
 }
 
-static int ovl_parse_opt(char *opt, struct ovl_config *config)
+static char *ovl_token_to_string(int token)
 {
-	char *p;
+	switch (token) {
+	case OPT_UPPERDIR: return "upperdir";
+	case OPT_LOWERDIR: return "lowerdir";
+	case OPT_WORKDIR: return "workdir";
+	case OPT_DEFAULT_PERMISSIONS: return "default_permissions";
+	case OPT_REDIRECT_DIR: return "redirect_dir";
+	case OPT_INDEX_ON:
+	case OPT_INDEX_OFF: return "index";
+	case OPT_NFS_EXPORT_ON:
+	case OPT_NFS_EXPORT_OFF: return "nfs_export";
+	default: return "???";
+	}
+}
 
-	config->redirect_mode = kstrdup(ovl_redirect_mode_def(), GFP_KERNEL);
-	if (!config->redirect_mode)
-		return -ENOMEM;
+static int ovl_valid_remount_string_option(int token, const char *new,
+						const char *old)
+{
+	if (!old || strcmp(new, old)) {
+		pr_err("overlayfs: option %s cannot be changed on remount.\n",
+				ovl_token_to_string(token));
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int ovl_valid_remount_bool_option(int token, const bool new,
+						const bool old)
+{
+	if (new != old) {
+		pr_err("overlayfs: option %s cannot be changed on remount.\n",
+				ovl_token_to_string(token));
+		return -EINVAL;
+	}
+	return 0;
+}
+
+static int ovl_parse_opt(char *opt, struct ovl_config *config,
+					struct ovl_config *old_config)
+{
+	char *p;
+	int err;
 
 	while ((p = ovl_next_opt(&opt)) != NULL) {
 		int token;
@@ -468,6 +514,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->upperdir = match_strdup(&args[0]);
 			if (!config->upperdir)
 				return -ENOMEM;
+			if (old_config) {
+				err = ovl_valid_remount_string_option(
+					token,
+					config->upperdir,
+					old_config->upperdir);
+				if (err)
+					return err;
+			}
 			break;
 
 		case OPT_LOWERDIR:
@@ -475,6 +529,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->lowerdir = match_strdup(&args[0]);
 			if (!config->lowerdir)
 				return -ENOMEM;
+			if (old_config) {
+				err = ovl_valid_remount_string_option(
+					token,
+					config->lowerdir,
+					old_config->lowerdir);
+				if (err)
+					return err;
+			}
 			break;
 
 		case OPT_WORKDIR:
@@ -482,10 +544,26 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->workdir = match_strdup(&args[0]);
 			if (!config->workdir)
 				return -ENOMEM;
+			if (old_config) {
+				err = ovl_valid_remount_string_option(
+					token,
+					config->workdir,
+					old_config->workdir);
+				if (err)
+					return err;
+			}
 			break;
 
 		case OPT_DEFAULT_PERMISSIONS:
 			config->default_permissions = true;
+			if (old_config) {
+				err = ovl_valid_remount_bool_option(
+					token,
+					config->default_permissions,
+					old_config->default_permissions);
+				if (err)
+					return err;
+			}
 			break;
 
 		case OPT_REDIRECT_DIR:
@@ -493,22 +571,62 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->redirect_mode = match_strdup(&args[0]);
 			if (!config->redirect_mode)
 				return -ENOMEM;
+			if (old_config) {
+				err = ovl_valid_remount_string_option(
+					token,
+					config->redirect_mode,
+					old_config->redirect_mode);
+				if (err)
+					return err;
+			}
 			break;
 
 		case OPT_INDEX_ON:
 			config->index = true;
+			if (old_config) {
+				err = ovl_valid_remount_bool_option(
+					token,
+					config->index,
+					old_config->index);
+				if (err)
+					return err;
+			}
 			break;
 
 		case OPT_INDEX_OFF:
 			config->index = false;
+			if (old_config) {
+				err = ovl_valid_remount_bool_option(
+					token,
+					config->index,
+					old_config->index);
+				if (err)
+					return err;
+			}
 			break;
 
 		case OPT_NFS_EXPORT_ON:
 			config->nfs_export = true;
+			if (old_config) {
+				err = ovl_valid_remount_bool_option(
+					token,
+					config->nfs_export,
+					old_config->nfs_export);
+				if (err)
+					return err;
+			}
 			break;
 
 		case OPT_NFS_EXPORT_OFF:
 			config->nfs_export = false;
+			if (old_config) {
+				err = ovl_valid_remount_bool_option(
+					token,
+					config->nfs_export,
+					old_config->nfs_export);
+				if (err)
+					return err;
+			}
 			break;
 
 		default:
@@ -517,6 +635,9 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		}
 	}
 
+	if (old_config)
+		return 0;
+
 	/* Workdir is useless in non-upper mount */
 	if (!config->upperdir && config->workdir) {
 		pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
@@ -1263,7 +1384,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	ofs->config.index = ovl_index_def;
 	ofs->config.nfs_export = ovl_nfs_export_def;
-	err = ovl_parse_opt((char *) data, &ofs->config);
+	err = ovl_parse_opt((char *) data, &ofs->config, NULL);
 	if (err)
 		goto out_err;
 
-- 
1.8.3.1
