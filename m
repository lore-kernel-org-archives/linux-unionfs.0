Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH v2 8/9] ovl: force mount underlying layers which have feature sets
Date: Tue, 31 Jul 2018 17:37:26 +0800
Message-ID: <20180731093727.26855-9-yi.zhang@huawei.com>
In-Reply-To: <20180731093727.26855-1-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Now, overlay try its best to add feature bitset to the upper layer's
root directory, but it still cannot guarantee the feature set are
consistent for compatibility check.

 - Some features in the feature set xattr or the whole xattr may be
   missing if some features have already been set by the old kernel.
 - Although we don't set lower layer's feature set xattr directly
   (it inherit from previous mount when it was upper layer), but the
   whole feature set xattr may be lost or corrupt when user change the
   underlying layers.

So, feature set xattr are optionally for overlayfs now, but we should
be able to ensure the consistency of feature set for backward
compatibility check accurately.

After we introduce mkfs.overlay and fsck.overlay tools, we can use
these tools to add, check and fix feature set xattr. So it's time to
add options to enforce kernel to mount overlayfs with the base on the
layers that must have feature set xattr, even if it is empty.

After this patch, we refer the underlying layer which have feature set
xattr as on-disk format v2, and the layer that don't have as on-disk
format v1. We introduce two Kconfig options: OVERLAY_FS_V2 and
OVERLAY_FS_UPPER_V2, and the counterpart module and mount options
"overlayfs_v2=<off/on/upper>".

If "OVERLAY_FS_V2=n" or "-o overlayfs_v2=off", feature set xattr is not
required, the underlying layers can be either on-disk format v1 or v2.
If "OVERLAY_FS_V2=y" or "-o overlayfs_v2=on", all underlying layers of
overlayfs must be on-disk format v2, kernel will refuse to mount if
not. If "OVELRAY_FS_UPPER_V2=y" or "-o overlayfs=upper", relax the
requirement for declaring lower layers feature set, only the upper
layer have feature set is enough (this is useful for the case of lower
layer is read-only).

Note that the feature set xattr create by old kernel before this patch
or if "OVERLAY_FS_V2=n" may inconsistent, fsck.overlay is required
before mount with "OVERLAY_FS_V2=y" or "OVERLAY_FS_UPPER_V2=y" next
time.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Kconfig     | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/feature.c   | 20 +++++++++++++++++++-
 fs/overlayfs/ovl_entry.h |  7 +++++++
 fs/overlayfs/super.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 109 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 9384164253ac..1d7f7bfa5165 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -103,3 +103,43 @@ config OVERLAY_FS_XINO_AUTO
 	  For more information, see Documentation/filesystems/overlayfs.txt
 
 	  If unsure, say N.
+
+config OVERLAY_FS_V2
+	bool "Overlayfs: overlayfs v2 (force all layers have feature sets)"
+	default n
+	depends on OVERLAY_FS
+	help
+	  If this config option is enabled then overlay feature sets are
+	  necessary for each underlying layer, which is created by mkfs.overlay
+	  or fsck.overlay. In this case it is still possible to turn off with
+	  the "overlayfs_v2=off" module option or on a filesystem instance
+	  basis with the "overlayfs_v2=off" mount option.
+
+	  Note, kernel will refuse to mount overlayfs without feature set in
+	  any one of the underlying layers, so must run mkfs.overlay before
+	  the first mount or run fsck.overlay to tune overlayfs image form v1
+	  to v2 (init feature sets).
+
+	  For more information, see Documentation/filesystems/overlayfs.txt
+
+	  If unsure or don't have the mkfs.overlay and mkfs.overlay tools,
+	  say N.
+
+config OVERLAY_FS_UPPER_V2
+	bool "Overlayfs: upper v2 only (release requirement of the lower layers)"
+	default n
+	depends on OVERLAY_FS_V2
+	help
+	  If this config option is enabled then overlay feature sets are
+	  necessary for the upper layer only, feature sets are optional for
+	  each lower layer. This option is useful for read-only lower layer
+	  which cannot init feature set by mkfs.overlay and fsck.overlay.
+
+	  Note, the lower layers may contain unmarked incompatible features,
+	  mounting an overlay with these lower layers on a kernel that doesn't
+	  support these features will have unexpected results.
+
+	  For more information, see Documentation/filesystems/overlayfs.txt
+
+	  If unsure or don't have the mkfs.overlay and mkfs.overlay tools,
+	  say N.
diff --git a/fs/overlayfs/feature.c b/fs/overlayfs/feature.c
index 7c66e71bdd98..fffa79ee9b15 100644
--- a/fs/overlayfs/feature.c
+++ b/fs/overlayfs/feature.c
@@ -117,6 +117,10 @@ int ovl_set_upper_feature(struct ovl_fs *ofs,
 	if (!upper_layer)
 		return -EINVAL;
 
+	if (WARN_ON_ONCE((ofs->config.format != OVL_FS_V1) &&
+			 !(upper_layer->feature)))
+		return -ESTALE;
+
 	switch (type) {
 	case OVL_FEATURE_COMPAT:
 		features = &upper_layer->compat;
@@ -148,7 +152,9 @@ int ovl_set_upper_feature(struct ovl_fs *ofs,
 }
 
 /*
- * Get features from each underlying root dir.
+ * Get features from each underlying root dir. Feature set is not
+ * necessary for v1 underlying layers, but is necessary for v2
+ * underlying layers.
  *
  * @ofs: overlay filesystem information
  * @oe: overlay lower stack
@@ -175,6 +181,12 @@ int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe)
 			upper_layer->feature = true;
 			kfree(odf);
 		} else {
+			/* Force upper on-disk format v2 */
+			if (ofs->config.format != OVL_FS_V1) {
+				pr_warn("overlayfs: upper layer feature set missing, "
+					"running fsck.overlay is recommended\n");
+				return -ESTALE;
+			}
 			upper_layer->feature = false;
 		}
 	}
@@ -189,6 +201,12 @@ int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe)
 			return PTR_ERR(odf);
 
 		if (!odf) {
+			/* Force lower on-disk format v2 */
+			if (ofs->config.format == OVL_FS_V2) {
+				pr_warn("overlayfs: lower layer %i feature set missing, "
+					"running fsck.overlay is recommended\n", i);
+				return -ESTALE;
+			}
 			lower_layer->feature = false;
 			continue;
 		}
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 8a28e24dd149..19885be7705c 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -8,6 +8,12 @@
  * the Free Software Foundation.
  */
 
+enum ovl_format {
+	OVL_FS_V1,
+	OVL_FS_UPPER_V2,
+	OVL_FS_V2,
+};
+
 struct ovl_config {
 	char *lowerdir;
 	char *upperdir;
@@ -19,6 +25,7 @@ struct ovl_config {
 	bool index;
 	bool nfs_export;
 	int xino;
+	enum ovl_format format;
 };
 
 struct ovl_sb {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 860a533ae5a9..1e81d2c6766a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -56,6 +56,16 @@ module_param_named(xino_auto, ovl_xino_auto_def, bool, 0644);
 MODULE_PARM_DESC(ovl_xino_auto_def,
 		 "Auto enable xino feature");
 
+static bool ovl_ovlfs_v2_def = IS_ENABLED(CONFIG_OVERLAY_FS_V2);
+module_param_named(ovl_ovlfs_v2, ovl_ovlfs_v2_def, bool, 0644);
+MODULE_PARM_DESC(ovl_ovlfs_v2_def,
+		 "Default to on or off to force mount overlay v2 layers");
+
+static bool ovl_ovlfs_upper_v2_def = IS_ENABLED(CONFIG_OVERLAY_FS_UPPER_V2);
+module_param_named(ovl_ovlfs_upper_v2, ovl_ovlfs_upper_v2_def, bool, 0644);
+MODULE_PARM_DESC(ovl_ovlfs_upper_v2_def,
+		 "Force mount overlay v2 upper layer only");
+
 static void ovl_entry_stack_free(struct ovl_entry *oe)
 {
 	unsigned int i;
@@ -351,6 +361,18 @@ static inline int ovl_xino_def(void)
 	return ovl_xino_auto_def ? OVL_XINO_AUTO : OVL_XINO_OFF;
 }
 
+static const char * const ovl_format_str[] = {
+	"off",		/* OVL_FS_V1 */
+	"upper",	/* OVL_FS_UPPER_V2 */
+	"on",		/* OVL_FS_V2 */
+};
+
+static inline int ovl_format_def(void)
+{
+	return !ovl_ovlfs_v2_def ? OVL_FS_V1 :
+		(ovl_ovlfs_upper_v2_def ? OVL_FS_UPPER_V2 : OVL_FS_V2);
+}
+
 /**
  * ovl_show_options
  *
@@ -378,6 +400,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 						"on" : "off");
 	if (ofs->config.xino != ovl_xino_def())
 		seq_printf(m, ",xino=%s", ovl_xino_str[ofs->config.xino]);
+	if (ofs->config.format != ovl_format_def())
+		seq_printf(m, ",overlayfs_v2=%s", ovl_format_str[ofs->config.format]);
 	return 0;
 }
 
@@ -416,6 +440,9 @@ enum {
 	OPT_XINO_ON,
 	OPT_XINO_OFF,
 	OPT_XINO_AUTO,
+	OPT_OVERLAYFS_V2_ON,
+	OPT_OVERLAYFS_V2_UPPER,
+	OPT_OVERLAYFS_V2_OFF,
 	OPT_ERR,
 };
 
@@ -432,6 +459,9 @@ static const match_table_t ovl_tokens = {
 	{OPT_XINO_ON,			"xino=on"},
 	{OPT_XINO_OFF,			"xino=off"},
 	{OPT_XINO_AUTO,			"xino=auto"},
+	{OPT_OVERLAYFS_V2_ON,		"overlayfs_v2=on"},
+	{OPT_OVERLAYFS_V2_UPPER,	"overlayfs_v2=upper"},
+	{OPT_OVERLAYFS_V2_OFF,		"overlayfs_v2=off"},
 	{OPT_ERR,			NULL}
 };
 
@@ -558,6 +588,18 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->xino = OVL_XINO_AUTO;
 			break;
 
+		case OPT_OVERLAYFS_V2_ON:
+			config->format = OVL_FS_V2;
+			break;
+
+		case OPT_OVERLAYFS_V2_UPPER:
+			config->format = OVL_FS_UPPER_V2;
+			break;
+
+		case OPT_OVERLAYFS_V2_OFF:
+			config->format = OVL_FS_V1;
+			break;
+
 		default:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
@@ -1386,6 +1428,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ofs->config.index = ovl_index_def;
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
+	ofs->config.format = ovl_format_def();
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
 		goto out_err;
-- 
2.13.6
