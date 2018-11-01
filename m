Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm1-f67.google.com ([209.85.128.67]:39761 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbeKAJtH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Nov 2018 05:49:07 -0400
Received: by mail-wm1-f67.google.com with SMTP id u13-v6so10991wmc.4
        for <linux-unionfs@vger.kernel.org>; Wed, 31 Oct 2018 17:48:28 -0700 (PDT)
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 5/5] ovl: enforce 'strict' upper fs and feature requirements with strict=on
Date: Thu,  1 Nov 2018 02:48:13 +0200
Message-Id: <20181101004813.31349-6-amir73il@gmail.com>
In-Reply-To: <20181101004813.31349-1-amir73il@gmail.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Overlayfs works sub-optimally with upper fs that has no
xattr/d_type/O_TMPFILE/RENAME_WHITEOUT support. We should basically
deprecate support for those filesystems, but so far, we only issue a
warning and don't fail the mount for the sake of backward compat.
Some features are already being disabled with no xattr support in upper
fs and with no file handle support in underlying fs.

when user asks explicitly via Kconfig/module/mount option to enable
strict feature requirements, we do not need to worry about backward
compatibility and we can fail the mount if upper fs is a sub-optimal
filesystem or if any of the feature requirements are not met.

So far, the 'strict' behavior was enabled implicitly for metacopy=on.
With that change, the 'strcit' behavior can be enabled regardless of
metacopy=on and can be relaxed even with metacopy, with mount options
"metacopy=on,strict=off" (order is important).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Kconfig | 23 +++++++++++++++++++++++
 fs/overlayfs/super.c | 20 ++++++++++++++++++++
 2 files changed, 43 insertions(+)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 2ef91be2a04e..620e379959c2 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -109,6 +109,7 @@ config OVERLAY_FS_METACOPY
 	bool "Overlayfs: turn on metadata only copy up feature by default"
 	depends on OVERLAY_FS
 	select OVERLAY_FS_REDIRECT_DIR
+	select OVERLAY_FS_STRICT
 	help
 	  If this config option is enabled then overlay filesystems will
 	  copy up only metadata where appropriate and data copy up will
@@ -122,3 +123,25 @@ config OVERLAY_FS_METACOPY
 	  that doesn't support this feature will have unexpected results.
 
 	  If unsure, say N.
+
+config OVERLAY_FS_STRICT
+	bool "Overlayfs: turn on strict requirements by default"
+	depends on OVERLAY_FS
+	help
+	  The overlayfs filesystem is fully functional and optimal when the
+	  underlying filesystems support extended attributes, d_type values
+	  in readdir, O_TMPFILE and RENAME_WHITEOUT.  In addition, some
+	  overlay filesystem features require that underlying filesystems
+	  support exporting NFS file handles.
+
+	  If this config option is enabled, then overlay filesystem mount
+	  will fail if any of the requirements from underlying filesystems
+	  are not met.  When strict requirements are enabled, overlay filesystem
+	  mount will also fail if any of the mount options are conflicting,
+	  for example: "nfs_export=on,metacopy=on".
+
+	  If this config option is enabled, it is still possible to turn off
+	  strict requirements globally with the "strict=off" module option or
+	  on a filesystem instance basis with the "strict=off" mount option.
+
+	  If unsure, say N.
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d848112f4fc9..b6fd86b0a1c8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -61,6 +61,11 @@ module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
 MODULE_PARM_DESC(ovl_metacopy_def,
 		 "Default to on or off for the metadata only copy up feature");
 
+static bool ovl_strict_def = IS_ENABLED(CONFIG_OVERLAY_FS_STRICT);
+module_param_named(strict, ovl_strict_def, bool, 0644);
+MODULE_PARM_DESC(ovl_strict_def,
+		 "Default to on or off for strict feature requirements");
+
 static int ovl_feature_requires(struct ovl_config *config, const char *feature,
 				const char *requirement)
 {
@@ -401,6 +406,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ofs->config.metacopy != ovl_metacopy_def)
 		seq_printf(m, ",metacopy=%s",
 			   ofs->config.metacopy ? "on" : "off");
+	if (ofs->config.strict != ovl_strict_def)
+		seq_printf(m, ",strict=%s", ofs->config.strict ? "on" : "off");
 	return 0;
 }
 
@@ -440,6 +447,8 @@ enum {
 	OPT_XINO_AUTO,
 	OPT_METACOPY_ON,
 	OPT_METACOPY_OFF,
+	OPT_STRICT_ON,
+	OPT_STRICT_OFF,
 	OPT_ERR,
 };
 
@@ -458,6 +467,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_XINO_AUTO,			"xino=auto"},
 	{OPT_METACOPY_ON,		"metacopy=on"},
 	{OPT_METACOPY_OFF,		"metacopy=off"},
+	{OPT_STRICT_ON,			"strict=on"},
+	{OPT_STRICT_OFF,		"strict=off"},
 	{OPT_ERR,			NULL}
 };
 
@@ -594,6 +605,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->metacopy = false;
 			break;
 
+		case OPT_STRICT_ON:
+			config->strict = true;
+			break;
+
+		case OPT_STRICT_OFF:
+			config->strict = false;
+			break;
+
 		default:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
@@ -1533,6 +1552,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
 	ofs->config.metacopy = ovl_metacopy_def;
+	ofs->config.strict = ovl_strict_def;
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
 		goto out_err;
-- 
2.17.1
