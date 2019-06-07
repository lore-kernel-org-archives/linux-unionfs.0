Return-Path: <mcoffin13@gmail.com>
Return-Path: <mcoffin13@gmail.com>
From: Matt Coffin <mcoffin13@gmail.com>
Subject: [PATCH v2] overlay: allow config override of metacopy/redirect defaults
Date: Fri,  7 Jun 2019 14:51:05 -0600
Message-Id: <20190607205105.21858-1-mcoffin13@gmail.com>
In-Reply-To: <20190607010431.11868-1-mcoffin13@gmail.com>
References: <20190607010431.11868-1-mcoffin13@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: linux-unionfs@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>, Matt Coffin <mcoffin13@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

[Why]
Currently, if the redirect_dir option is set as a kernel or module
parameter, then even if metacopy is only enabled config, then both
metacopy and redirect_dir will be enabled when one creates a mount
point. This is not desirable because /sys/module/overlay/parameters will
still report that redirect_dir is not enabled, and there will be no
redirect_dir=on line in the mount options in /proc/mounts. The behavior
of setting redirect_dir globally for overlay is likely a common pattern
on docker workstations, as redirect_dir makes for slower building of
docker images.

[How]
This patch adds similar logic to that already in place for parsing mount
parameters. If the user explicitly sets redirect_dir via a kernel or
module parameter, then metacopy will become disabled, unless it was also
specified that way. Obviously, mount options still take precedence over
this process, so this logic only kicks in when neither redirect_dir or
metacopy were specified in the mount options.

[Related]
This undesirable logic was introduced by the commit that introduced the
mount option handling logic: d47748e5ae5af6572e520cc9767bbe70c22ea498

[v2]
Clean up some formatting on lines that were too long
---
 fs/overlayfs/super.c | 49 ++++++++++++++++++++++++++++++++++++--------
 1 file changed, 40 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5ec4fc2f5d7e..bd1a1329aa70 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -30,10 +30,16 @@ struct ovl_dir_cache;
 #define OVL_MAX_STACK 500
 
 static bool ovl_redirect_dir_def = IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_DIR);
-module_param_named(redirect_dir, ovl_redirect_dir_def, bool, 0644);
-MODULE_PARM_DESC(ovl_redirect_dir_def,
+static bool ovl_redirect_dir_param = IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_DIR);
+module_param_named(redirect_dir, ovl_redirect_dir_param, bool, 0644);
+MODULE_PARM_DESC(ovl_redirect_dir_param,
 		 "Default to on or off for the redirect_dir feature");
 
+static inline bool ovl_redirect_dir_module_overrides_kernel(void)
+{
+	return (ovl_redirect_dir_def != ovl_redirect_dir_param);
+}
+
 static bool ovl_redirect_always_follow =
 	IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW);
 module_param_named(redirect_always_follow, ovl_redirect_always_follow,
@@ -65,10 +71,16 @@ static void ovl_entry_stack_free(struct ovl_entry *oe)
 }
 
 static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
-module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
-MODULE_PARM_DESC(ovl_metacopy_def,
+static bool ovl_metacopy_param = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
+module_param_named(metacopy, ovl_metacopy_param, bool, 0644);
+MODULE_PARM_DESC(ovl_metacopy_param,
 		 "Default to on or off for the metadata only copy up feature");
 
+static inline bool ovl_metacopy_module_overrides_kernel(void)
+{
+	return (ovl_metacopy_def != ovl_metacopy_param);
+}
+
 static void ovl_dentry_release(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -310,7 +322,7 @@ static bool ovl_force_readonly(struct ovl_fs *ofs)
 
 static const char *ovl_redirect_mode_def(void)
 {
-	return ovl_redirect_dir_def ? "on" : "off";
+	return ovl_redirect_dir_param ? "on" : "off";
 }
 
 enum {
@@ -357,7 +369,7 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 						"on" : "off");
 	if (ofs->config.xino != ovl_xino_def())
 		seq_printf(m, ",xino=%s", ovl_xino_str[ofs->config.xino]);
-	if (ofs->config.metacopy != ovl_metacopy_def)
+	if (ofs->config.metacopy != ovl_metacopy_param)
 		seq_printf(m, ",metacopy=%s",
 			   ofs->config.metacopy ? "on" : "off");
 	return 0;
@@ -456,6 +468,7 @@ static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
 	} else if (strcmp(mode, "follow") == 0) {
 		config->redirect_follow = true;
 	} else if (strcmp(mode, "off") == 0) {
+		config->redirect_dir = false;
 		if (ovl_redirect_always_follow)
 			config->redirect_follow = true;
 	} else if (strcmp(mode, "nofollow") != 0) {
@@ -472,6 +485,8 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 	char *p;
 	int err;
 	bool metacopy_opt = false, redirect_opt = false;
+	bool metacopy_override = ovl_metacopy_module_overrides_kernel();
+	bool redirect_override = ovl_redirect_dir_module_overrides_kernel();
 
 	config->redirect_mode = kstrdup(ovl_redirect_mode_def(), GFP_KERNEL);
 	if (!config->redirect_mode)
@@ -597,8 +612,24 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 				config->redirect_mode);
 			config->metacopy = false;
 		} else {
-			/* Automatically enable redirect otherwise. */
-			config->redirect_follow = config->redirect_dir = true;
+			if (metacopy_override && redirect_override) {
+				pr_err("overlayfs: conflicting module params: metacopy=on,redirect_dir=%s\n",
+					config->redirect_mode);
+				return -EINVAL;
+			}
+			if (redirect_override) {
+				/*
+				 * There was an explicit redirect_dir=...
+				 * that resulted in this conflict (module param)
+				 */
+				pr_info("overlayfs: disabling metacopy due to module param redirect_dir=%s\n",
+					config->redirect_mode);
+				config->metacopy = false;
+			} else {
+				/* Automatically enable redirect otherwise. */
+				config->redirect_follow =
+					config->redirect_dir = true;
+			}
 		}
 	}
 
@@ -1438,7 +1469,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ofs->config.index = ovl_index_def;
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
-	ofs->config.metacopy = ovl_metacopy_def;
+	ofs->config.metacopy = ovl_metacopy_param;
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
 		goto out_err;
-- 
2.21.0
