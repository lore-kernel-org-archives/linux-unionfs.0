From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [RFC PATCH v2] ovl: don't follow redirects if redirect_dir=off
Date: Wed, 6 Dec 2017 16:03:33 +0100
Message-ID: <20171206150333.GB24303@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:37700 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752126AbdLFPDj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 10:03:39 -0500
Received: by mail-wr0-f194.google.com with SMTP id k61so4229470wrc.4
        for <linux-unionfs@vger.kernel.org>; Wed, 06 Dec 2017 07:03:38 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: David Howells <dhowells@redhat.com>, Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>

Overlayfs is following redirects even when redirects are disabled. If this
is unintentional (probably the majority of cases) then this can be a
problem.  E.g. upper layer comes from untrusted USB drive, and attacker
crafts a redirect to enable read access to otherwise unreadable
directories.

If "redirect=off", then turn off following as well as creation of
redirects.  If "redirect=follow", then turn on following, but turn off
creation of redirects (which is what "redirect=off" does now).

This is a backward incompatible change, so make it dependent on a config
option.

Reported-by: David Howells <dhowells@redhat.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
v2:
 - added module option for always following (defaulting to Kconfig)
 - added mount option "nofollow" to force not following even if default is to
   always follow
 - fixed .show_options()
 - added more documentation to overlayfs.txt and removed some from Kconfig

 Documentation/filesystems/overlayfs.txt |   34 +++++++++++++++++++
 fs/overlayfs/Kconfig                    |   10 +++++
 fs/overlayfs/namei.c                    |   16 +++++++++
 fs/overlayfs/ovl_entry.h                |    2 +
 fs/overlayfs/super.c                    |   56 ++++++++++++++++++++++----------
 5 files changed, 102 insertions(+), 16 deletions(-)

--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -681,6 +681,22 @@ struct dentry *ovl_lookup(struct inode *
 		if (d.stop)
 			break;
 
+		/*
+		 * Following redirects can have security consequences: it's like
+		 * a symlink into the lower layer without the permission checks.
+		 * This is only a problem if the upper layer is untrusted (e.g
+		 * comes from an USB drive).  This can allow a non-readable file
+		 * or directory to become readable.
+		 *
+		 * Only following redirects when redirects are enabled disables
+		 * this attack vector when not necessary.
+		 */
+		err = -EPERM;
+		if (d.redirect && !ofs->config.redirect_follow) {
+			pr_warn_ratelimited("overlay: refusing to follow redirect for (%pd2)\n", dentry);
+			goto out_put;
+		}
+
 		if (d.redirect && d.redirect[0] == '/' && poe != roe) {
 			poe = roe;
 
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -24,6 +24,16 @@ config OVERLAY_FS_REDIRECT_DIR
 	  an overlay which has redirects on a kernel that doesn't support this
 	  feature will have unexpected results.
 
+config OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW
+	bool "Overlayfs: follow redirects even if redirects are turned off"
+	default y
+	depends on OVERLAY_FS
+	help
+	  Disable this to get a possibly more secure configuration, but that
+	  might not be backward compatible with previous kernels.
+
+	  For more information, see Documentation/filesystems/overlayfs.txt
+
 config OVERLAY_FS_INDEX
 	bool "Overlayfs: turn on inodes index feature by default"
 	depends on OVERLAY_FS
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -14,6 +14,8 @@ struct ovl_config {
 	char *workdir;
 	bool default_permissions;
 	bool redirect_dir;
+	bool redirect_follow;
+	const char *redirect_mode;
 	bool index;
 };
 
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -33,6 +33,13 @@ module_param_named(redirect_dir, ovl_red
 MODULE_PARM_DESC(ovl_redirect_dir_def,
 		 "Default to on or off for the redirect_dir feature");
 
+static bool ovl_redirect_always_follow =
+	IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW);
+module_param_named(redirect_always_follow, ovl_redirect_always_follow,
+		   bool, 0644);
+MODULE_PARM_DESC(ovl_redirect_always_follow,
+		 "Follow redirects even if redirect_dir feature is turned off");
+
 static bool ovl_index_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX);
 module_param_named(index, ovl_index_def, bool, 0644);
 MODULE_PARM_DESC(ovl_index_def,
@@ -232,6 +239,7 @@ static void ovl_free_fs(struct ovl_fs *o
 	kfree(ofs->config.lowerdir);
 	kfree(ofs->config.upperdir);
 	kfree(ofs->config.workdir);
+	kfree(ofs->config.redirect_mode);
 	if (ofs->creator_cred)
 		put_cred(ofs->creator_cred);
 	kfree(ofs);
@@ -295,6 +303,11 @@ static bool ovl_force_readonly(struct ov
 	return (!ofs->upper_mnt || !ofs->workdir);
 }
 
+static const char *ovl_def_mode_str(void)
+{
+	return ovl_redirect_dir_def ? "on" : "off";
+}
+
 /**
  * ovl_show_options
  *
@@ -313,12 +326,10 @@ static int ovl_show_options(struct seq_f
 	}
 	if (ofs->config.default_permissions)
 		seq_puts(m, ",default_permissions");
-	if (ofs->config.redirect_dir != ovl_redirect_dir_def)
-		seq_printf(m, ",redirect_dir=%s",
-			   ofs->config.redirect_dir ? "on" : "off");
+	if (strcmp(ofs->config.redirect_mode, ovl_def_mode_str()) != 0)
+		seq_printf(m, ",redirect_dir=%s", ofs->config.redirect_mode);
 	if (ofs->config.index != ovl_index_def)
-		seq_printf(m, ",index=%s",
-			   ofs->config.index ? "on" : "off");
+		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
 	return 0;
 }
 
@@ -348,8 +359,7 @@ enum {
 	OPT_UPPERDIR,
 	OPT_WORKDIR,
 	OPT_DEFAULT_PERMISSIONS,
-	OPT_REDIRECT_DIR_ON,
-	OPT_REDIRECT_DIR_OFF,
+	OPT_REDIRECT_DIR,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
 	OPT_ERR,
@@ -360,8 +370,7 @@ static const match_table_t ovl_tokens =
 	{OPT_UPPERDIR,			"upperdir=%s"},
 	{OPT_WORKDIR,			"workdir=%s"},
 	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
-	{OPT_REDIRECT_DIR_ON,		"redirect_dir=on"},
-	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
+	{OPT_REDIRECT_DIR,		"redirect_dir=%s"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
 	{OPT_ERR,			NULL}
@@ -428,12 +437,11 @@ static int ovl_parse_opt(char *opt, stru
 			config->default_permissions = true;
 			break;
 
-		case OPT_REDIRECT_DIR_ON:
-			config->redirect_dir = true;
-			break;
-
-		case OPT_REDIRECT_DIR_OFF:
-			config->redirect_dir = false;
+		case OPT_REDIRECT_DIR:
+			kfree(config->redirect_mode);
+			config->redirect_mode = match_strdup(&args[0]);
+			if (!config->redirect_mode)
+				return -ENOMEM;
 			break;
 
 		case OPT_INDEX_ON:
@@ -1160,12 +1168,28 @@ static int ovl_fill_super(struct super_b
 	if (!cred)
 		goto out_err;
 
-	ofs->config.redirect_dir = ovl_redirect_dir_def;
+	ofs->config.redirect_mode = kstrdup(ovl_def_mode_str(), GFP_KERNEL);
+	if (!ofs->config.redirect_mode)
+		goto out_err;
+
 	ofs->config.index = ovl_index_def;
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
 		goto out_err;
 
+	if (strcmp(ofs->config.redirect_mode, "on") == 0) {
+		ofs->config.redirect_dir = true;
+		ofs->config.redirect_follow = true;
+	} else if (strcmp(ofs->config.redirect_mode, "follow") == 0) {
+		ofs->config.redirect_follow = true;
+	} else if (strcmp(ofs->config.redirect_mode, "off") == 0) {
+		if (ovl_redirect_always_follow)
+			ofs->config.redirect_follow = true;
+	} else if (strcmp(ofs->config.redirect_mode, "nofollow") != 0) {
+		pr_err("overlayfs: bad mount option \"redirect_dir=%s\"\n",
+			ofs->config.redirect_mode);
+	}
+
 	err = -EINVAL;
 	if (!ofs->config.lowerdir) {
 		if (!silent)
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -156,6 +156,40 @@ directory was not created on the upper l
    root of the overlay.  Finally the directory is moved to the new
    location.
 
+There are several ways to tune the "redirect_dir" feature.
+
+Kernel config options:
+
+- OVERLAY_FS_REDIRECT_DIR:
+    If this is enabled, then redirect_dir is turned on by  default.
+- OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW:
+    If this is enabled, then redirects are always followed by default. Enabling
+    this results in a less secure configuration.  Enable this option only when
+    worried about backward compatibility with kernels that have the redirect_dir
+    feature and follow redirects even if turned off.
+
+Module options (can also be changed through /sys/module/overlay/parameters/*):
+
+- "redirect_dir=BOOL":
+    See OVERLAY_FS_REDIRECT_DIR kernel config option above.
+- "redirect_always_follow=BOOL":
+    See OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW kernel config option above.
+- "redirect_max=NUM":
+    The maximum number of bytes in an absolute redirect (default is 256).
+
+Mount options:
+
+- "redirect_dir=on":
+    Redirects are enabled.
+- "redirect_dir=follow":
+    Redirects are not created, but followed.
+- "redirect_dir=off":
+    Redirects are not created and only followed if "redirect_always_follow"
+    feature is enabled in the kernel/module config.
+- "redirect_dir=nofollow":
+    Redirects are not created and not followed (equivalent to "redirect_dir=off"
+    if "redirect_always_follow" feature is not enabled).
+
 Non-directories
 ---------------
 
