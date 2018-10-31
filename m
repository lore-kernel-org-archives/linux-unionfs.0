Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
Date: Wed, 31 Oct 2018 13:10:38 +0200
Message-Id: <20181031111038.20570-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Consider a user who wants to enable metadata only copy-up with metacopy=on.
If this feature can't be enabled, we disable metacopy=off and just leave
a warning in logs. metacopy=on requires redirect_dir=on (for upper dir)
or redirect_dir=follow (for non-upper mount).

As user does not see mount failure, he/she assumes metadata only copy-up
has been enabled but that's not the case.

So instead of disabling metacopy, return an error to user and leave a
message in logs. That will allow user to fix mount options and retry.
This is done only if user specified metacopy=on in mount options. If
metacopy is enabled as default either through module command line or
kernel Kconfig, that's not enforced and it can be disabled automatically
if system configuration does not permit it.

Reported-by: Daniel Walsh <dwalsh@redhat.com>
Suggested-by: Vivek Goyal <vgoyal@redhat.com>
Fixes: d5791044d2e5 ("ovl: Provide a mount option metacopy=on/off...")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos, Vivek,

I think you will find this patch more pleasant to the eye than Vivek's v1.

I am working on followup patches to implicitly enforce the 'strict'
behavior on *all* features if metacopy=on was provided and to add strict
behavior as an opt-in Kconfig/module/mount option regardless of metacopy.

The basic idea used to reduce complexity and increase consistency among
features, is that if user provides the *new* metacopy=on we can safely
enable strict=on on all other features as well without generating backward
compat issues.

I chose to separate this patch from the rest for ease of backporting to
stable.

Thoughts?

Thanks,
Amir.

 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 77 ++++++++++++++++++++++++++++++++--------
 2 files changed, 63 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ec237035333a..fb819aec46c0 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -20,6 +20,7 @@ struct ovl_config {
 	bool nfs_export;
 	int xino;
 	bool metacopy;
+	bool strict;
 };
 
 struct ovl_sb {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 22ffb23ea44d..69ced0aa96de 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -56,6 +56,49 @@ module_param_named(xino_auto, ovl_xino_auto_def, bool, 0644);
 MODULE_PARM_DESC(ovl_xino_auto_def,
 		 "Auto enable xino feature");
 
+static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
+module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
+MODULE_PARM_DESC(ovl_metacopy_def,
+		 "Default to on or off for the metadata only copy up feature");
+
+/*
+ * Check dependencies between features.
+ *
+ * @enabled is a boolean variable that depends on the boolean @required
+ * variable.
+ *
+ * If @strict is false, the feature is disabled when requirement is not met.
+ * If @strict is true, return error when requirement is not met.
+ *
+ * @feature is the name of the feature and @requirement is the description of
+ * the requirement for the error/warning message.
+ */
+static int ovl_bool_feature_requires(bool *enabled, bool required, bool strict,
+				     const char *feature,
+				     const char *requirement)
+{
+	/* If feature is enabled, required condition should be met */
+	if (!*enabled || required)
+		return 0;
+
+	if (strict) {
+		pr_err("overlayfs: %s requires %s.\n", feature, requirement);
+		return -EINVAL;
+	}
+
+	pr_warn("overlayfs: %s requies %s, disabling %s feature.\n", feature,
+		requirement, feature);
+	*enabled = false;
+
+	return 0;
+}
+
+#define ovl_feature_requires(config, type, name, required,	\
+			     feature, requirement)		\
+ovl_##type##_feature_requires(&(config)->name, required,	\
+			      (config)->strict, feature,	\
+			      requirement)
+
 static void ovl_entry_stack_free(struct ovl_entry *oe)
 {
 	unsigned int i;
@@ -64,11 +107,6 @@ static void ovl_entry_stack_free(struct ovl_entry *oe)
 		dput(oe->lowerstack[i].dentry);
 }
 
-static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
-module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
-MODULE_PARM_DESC(ovl_metacopy_def,
-		 "Default to on or off for the metadata only copy up feature");
-
 static void ovl_dentry_release(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -548,6 +586,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 
 		case OPT_METACOPY_ON:
 			config->metacopy = true;
+			config->strict = true;
 			break;
 
 		case OPT_METACOPY_OFF:
@@ -573,15 +612,19 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		return err;
 
 	/* metacopy feature with upper requires redirect_dir=on */
-	if (config->upperdir && config->metacopy && !config->redirect_dir) {
-		pr_warn("overlayfs: metadata only copy up requires \"redirect_dir=on\", falling back to metacopy=off.\n");
-		config->metacopy = false;
-	} else if (config->metacopy && !config->redirect_follow) {
-		pr_warn("overlayfs: metadata only copy up requires \"redirect_dir=follow\" on non-upper mount, falling back to metacopy=off.\n");
-		config->metacopy = false;
+	if (config->upperdir) {
+		err = ovl_feature_requires(config, bool, metacopy,
+					   config->redirect_dir,
+					   "metadata only copy up",
+					   "\"redirect_dir=on\"");
+	} else {
+		err = ovl_feature_requires(config, bool, metacopy,
+					   config->redirect_follow,
+					   "metadata only copy up",
+					   "\"redirect_dir=follow\" on non-upper mount");
 	}
 
-	return 0;
+	return err;
 }
 
 #define OVL_WORKDIR_NAME "work"
@@ -1055,9 +1098,13 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	if (err) {
 		ofs->noxattr = true;
 		ofs->config.index = false;
-		ofs->config.metacopy = false;
-		pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off and metacopy=off.\n");
-		err = 0;
+		pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off.\n");
+		err = ovl_feature_requires(&ofs->config, bool, metacopy,
+					   !ofs->noxattr,
+					   "metadata only copy up",
+					   "upper fs xattr support");
+		if (err)
+			goto out;
 	} else {
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
 	}
-- 
2.17.1
