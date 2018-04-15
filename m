Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v6 1/3] ovl: adjust option parsing for supporting remount
Date: Sun, 15 Apr 2018 11:10:31 +0800
Message-Id: <1523761833-7304-2-git-send-email-cgxu519@gmx.com>
In-Reply-To: <1523761833-7304-1-git-send-email-cgxu519@gmx.com>
References: <1523761833-7304-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Adjust ovl_parse_opt() and ovl_parse_redirect_mode() to support option
parsing in remount.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
Changes since v3:
- Delete redundant argument of ovl_parse_redirect_mode()

Changes since v2:
- Move default initialization of redirect_mode to fill_super()
just before calling parse_opt().
- Move workdir validation check to fill_super().
- Move remount option validation to ovl_remount().

Changes since v1:
- Add remount option validation to parse_opt()

 fs/overlayfs/super.c | 43 ++++++++++++++++++++++++-------------------
 1 file changed, 24 insertions(+), 19 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e8551c9..e99864e 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -455,23 +455,26 @@ static char *ovl_next_opt(char **s)
 	return sbegin;
 }
 
-static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
+static int ovl_parse_redirect_mode(struct ovl_config *config)
 {
-	if (strcmp(mode, "on") == 0) {
+	if (!config->redirect_mode)
+		return 0;
+
+	if (strcmp(config->redirect_mode, "on") == 0) {
 		config->redirect_dir = true;
 		/*
 		 * Does not make sense to have redirect creation without
 		 * redirect following.
 		 */
 		config->redirect_follow = true;
-	} else if (strcmp(mode, "follow") == 0) {
+	} else if (strcmp(config->redirect_mode, "follow") == 0) {
 		config->redirect_follow = true;
-	} else if (strcmp(mode, "off") == 0) {
+	} else if (strcmp(config->redirect_mode, "off") == 0) {
 		if (ovl_redirect_always_follow)
 			config->redirect_follow = true;
-	} else if (strcmp(mode, "nofollow") != 0) {
+	} else if (strcmp(config->redirect_mode, "nofollow") != 0) {
 		pr_err("overlayfs: bad mount option \"redirect_dir=%s\"\n",
-		       mode);
+		       config->redirect_mode);
 		return -EINVAL;
 	}
 
@@ -482,10 +485,6 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 {
 	char *p;
 
-	config->redirect_mode = kstrdup(ovl_redirect_mode_def(), GFP_KERNEL);
-	if (!config->redirect_mode)
-		return -ENOMEM;
-
 	while ((p = ovl_next_opt(&opt)) != NULL) {
 		int token;
 		substring_t args[MAX_OPT_ARGS];
@@ -561,15 +560,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		}
 	}
 
-	/* Workdir is useless in non-upper mount */
-	if (!config->upperdir && config->workdir) {
-		pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
-			config->workdir);
-		kfree(config->workdir);
-		config->workdir = NULL;
-	}
-
-	return ovl_parse_redirect_mode(config, config->redirect_mode);
+	return ovl_parse_redirect_mode(config);
 }
 
 #define OVL_WORKDIR_NAME "work"
@@ -1376,10 +1367,24 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ofs->config.index = ovl_index_def;
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
+
+	ofs->config.redirect_mode = kstrdup(ovl_redirect_mode_def(),
+							GFP_KERNEL);
+	if (!ofs->config.redirect_mode)
+		return -ENOMEM;
+
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
 		goto out_err;
 
+	/* Workdir is useless in non-upper mount */
+	if (!ofs->config.upperdir && ofs->config.workdir) {
+		pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
+			ofs->config.workdir);
+		kfree(ofs->config.workdir);
+		ofs->config.workdir = NULL;
+	}
+
 	err = -EINVAL;
 	if (!ofs->config.lowerdir) {
 		if (!silent)
-- 
1.8.3.1
