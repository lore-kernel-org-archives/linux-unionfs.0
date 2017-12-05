From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [RFC PATCH] ovl: don't follow redirects if redirect_dir=off
Date: Tue, 5 Dec 2017 14:37:07 +0100
Message-ID: <20171205133707.GA24303@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:39742 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbdLENhQ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Dec 2017 08:37:16 -0500
Received: by mail-wm0-f66.google.com with SMTP id i11so1292388wmf.4
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Dec 2017 05:37:15 -0800 (PST)
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
 fs/overlayfs/Kconfig     |   18 ++++++++++++++++++
 fs/overlayfs/namei.c     |   16 ++++++++++++++++
 fs/overlayfs/ovl_entry.h |    1 +
 fs/overlayfs/super.c     |   17 ++++++++++++++++-
 4 files changed, 51 insertions(+), 1 deletion(-)

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
@@ -24,6 +24,24 @@ config OVERLAY_FS_REDIRECT_DIR
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
+	  In previous kernels which contain directory redirect support, or if
+	  this this option is turned on, then overlay filesystems will follow
+	  redirects, regardless of whether redirection is turned on or off (even
+	  if OVERLAY_FS_REDIRECT_DIR config option is disabled)
+
+	  If this config option is disabled, then overlay filesystems will only
+	  follow redirects if they are turned on explicitly with
+	  "redirect_dir=on" or "redirect_dir=follow" or are on by default (in
+	  which case following can still be turned off with "redirect_dir=off").
+
 config OVERLAY_FS_INDEX
 	bool "Overlayfs: turn on inodes index feature by default"
 	depends on OVERLAY_FS
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -14,6 +14,7 @@ struct ovl_config {
 	char *workdir;
 	bool default_permissions;
 	bool redirect_dir;
+	bool redirect_follow;
 	bool index;
 };
 
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -33,6 +33,9 @@ module_param_named(redirect_dir, ovl_red
 MODULE_PARM_DESC(ovl_redirect_dir_def,
 		 "Default to on or off for the redirect_dir feature");
 
+static const bool ovl_redirect_follow_def =
+	IS_ENABLED(CONFIG_OVERLAY_FS_REDIRECT_ALWAYS_FOLLOW);
+
 static bool ovl_index_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX);
 module_param_named(index, ovl_index_def, bool, 0644);
 MODULE_PARM_DESC(ovl_index_def,
@@ -315,7 +318,8 @@ static int ovl_show_options(struct seq_f
 		seq_puts(m, ",default_permissions");
 	if (ofs->config.redirect_dir != ovl_redirect_dir_def)
 		seq_printf(m, ",redirect_dir=%s",
-			   ofs->config.redirect_dir ? "on" : "off");
+			   ofs->config.redirect_dir ? "on" :
+			   (ofs->config.redirect_follow ? "follow" : "off"));
 	if (ofs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s",
 			   ofs->config.index ? "on" : "off");
@@ -349,6 +353,7 @@ enum {
 	OPT_WORKDIR,
 	OPT_DEFAULT_PERMISSIONS,
 	OPT_REDIRECT_DIR_ON,
+	OPT_REDIRECT_DIR_FOLLOW,
 	OPT_REDIRECT_DIR_OFF,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
@@ -361,6 +366,7 @@ static const match_table_t ovl_tokens =
 	{OPT_WORKDIR,			"workdir=%s"},
 	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
 	{OPT_REDIRECT_DIR_ON,		"redirect_dir=on"},
+	{OPT_REDIRECT_DIR_FOLLOW,	"redirect_dir=follow"},
 	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
@@ -430,10 +436,17 @@ static int ovl_parse_opt(char *opt, stru
 
 		case OPT_REDIRECT_DIR_ON:
 			config->redirect_dir = true;
+			config->redirect_follow = true;
+			break;
+
+		case OPT_REDIRECT_DIR_FOLLOW:
+			config->redirect_dir = false;
+			config->redirect_follow = true;
 			break;
 
 		case OPT_REDIRECT_DIR_OFF:
 			config->redirect_dir = false;
+			config->redirect_follow = ovl_redirect_follow_def;
 			break;
 
 		case OPT_INDEX_ON:
@@ -1161,6 +1174,8 @@ static int ovl_fill_super(struct super_b
 		goto out_err;
 
 	ofs->config.redirect_dir = ovl_redirect_dir_def;
+	ofs->config.redirect_follow =
+		ovl_redirect_follow_def || ofs->config.redirect_dir;
 	ofs->config.index = ovl_index_def;
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
