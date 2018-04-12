Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH v3 1/2] ovl: adjust option parsing for supporting remount
Date: Thu, 12 Apr 2018 23:36:45 +0800
Message-Id: <1523547406-67046-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

Some overlayfs mount options cannot be changed via remount,
but remount does not return error even if we specify different
value to unchangeable options.

This patch adjusts option parsing to support remount, so we
can recogonize unchangeable options in remount.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
Changes since v2:
- Move default initialization of redirect_mode to fill_super()
just before calling parse_opt().
- Move workdir validation check to fill_super().
- Move remount option validation to ovl_remount().

Changes since v1:
- Add remount option validation to parse_opt()

 fs/overlayfs/super.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e8551c9..a2a7b7a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -457,6 +457,9 @@ static char *ovl_next_opt(char **s)
 
 static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
 {
+	if (!mode)
+		return 0;
+
 	if (strcmp(mode, "on") == 0) {
 		config->redirect_dir = true;
 		/*
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
@@ -561,14 +560,6 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
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
 	return ovl_parse_redirect_mode(config, config->redirect_mode);
 }
 
@@ -1376,10 +1367,24 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ofs->config.index = ovl_index_def;
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
+
+	ofs->config.redirect_mode = kstrdup(ovl_redirect_mode_def(),
+							GFP_KERNEL);
+	if (!ofs->config.redirect_mode)
+		goto out_err;
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
