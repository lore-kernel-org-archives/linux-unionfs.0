From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v7 04/14] ovl: Provide a mount option metacopy=on/off for metadata copyup
Date: Thu, 16 Nov 2017 17:03:25 -0500
Message-ID: <20171116220335.13448-5-vgoyal@redhat.com>
References: <20171116220335.13448-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58550 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S935754AbdKPWDo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Nov 2017 17:03:44 -0500
In-Reply-To: <20171116220335.13448-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: vgoyal@redhat.com, amir73il@gmail.com, miklos@szeredi.hu

By default metadata only copy up is disabled. Provide a mount option so
that users can choose one way or other.

Also provide a kernel config and module option to enable/disable
metacopy feature.

Like index feature, we verify on mount that upper root is not being
reused with a different lower root. This hopes to get the configuration
right and detect the copied layers use case. But this does only so
much as we don't verify all the lowers. So it is possible that a lower is
missing and later data copy up fails.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/Kconfig     |  8 ++++++++
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 40 +++++++++++++++++++++++++++++++++++++---
 3 files changed, 46 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index cbfc196e5dc5..17a0b17ad14c 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -43,3 +43,11 @@ config OVERLAY_FS_INDEX
 	  outcomes.  However, mounting the same overlay with an old kernel
 	  read-write and then mounting it again with a new kernel, will have
 	  unexpected results.
+
+config OVERLAY_FS_METACOPY
+	bool "Overlayfs: turn on metadata only copy up feature by default"
+	depends on OVERLAY_FS
+	help
+	  If this config option is enabled then overlay filesystems will
+	  copy up only metadata where appropriate and data copy up will
+	  happen when a file is opended for WRITE operation.
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 93eb6a044dd2..2720ed21ad53 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -15,6 +15,7 @@ struct ovl_config {
 	bool default_permissions;
 	bool redirect_dir;
 	bool index;
+	bool metacopy;
 };
 
 struct ovl_layer {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ee41bde87b14..d8b6b4d80d78 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -46,6 +46,11 @@ static void ovl_entry_stack_free(struct ovl_entry *oe)
 		dput(oe->lowerstack[i].dentry);
 }
 
+static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
+module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
+MODULE_PARM_DESC(ovl_metacopy_def,
+		 "Default to on or off for the metadata only copy up feature");
+
 static void ovl_dentry_release(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -319,6 +324,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ofs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s",
 			   ofs->config.index ? "on" : "off");
+	if (ofs->config.metacopy != ovl_metacopy_def)
+		seq_printf(m, ",metacopy=%s",
+			   ofs->config.metacopy ? "on" : "off");
 	return 0;
 }
 
@@ -352,6 +360,8 @@ enum {
 	OPT_REDIRECT_DIR_OFF,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
+	OPT_METACOPY_ON,
+	OPT_METACOPY_OFF,
 	OPT_ERR,
 };
 
@@ -364,6 +374,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
+	{OPT_METACOPY_ON,		"metacopy=on"},
+	{OPT_METACOPY_OFF,		"metacopy=off"},
 	{OPT_ERR,			NULL}
 };
 
@@ -444,6 +456,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->index = false;
 			break;
 
+		case OPT_METACOPY_ON:
+			config->metacopy = true;
+			break;
+
+		case OPT_METACOPY_OFF:
+			config->metacopy = false;
+			break;
+
 		default:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
@@ -657,9 +677,11 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	 * The inodes index feature needs to encode and decode file
 	 * handles, so it requires that all layers support them.
 	 */
-	if (ofs->config.index && !ovl_can_decode_fh(path->dentry->d_sb)) {
+	if ((ofs->config.index || ofs->config.metacopy) &&
+	     !ovl_can_decode_fh(path->dentry->d_sb)) {
+		pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off and metacopy=off.\n", name);
 		ofs->config.index = false;
-		pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
+		ofs->config.metacopy = false;
 	}
 
 	return 0;
@@ -923,7 +945,8 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 		ofs->noxattr = true;
 		ofs->config.redirect_dir = false;
 		ofs->config.index = false;
-		pr_warn("overlayfs: upper fs does not support xattr, falling back to redirect_dir=off, index=off and no opaque dir.\n");
+		ofs->config.metacopy = false;
+		pr_warn("overlayfs: upper fs does not support xattr, falling back to redirect_dir=off, index=off, metacopy=off and no opaque dir.\n");
 	} else {
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
 	}
@@ -1164,6 +1187,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	ofs->config.redirect_dir = ovl_redirect_dir_def;
 	ofs->config.index = ovl_index_def;
+	ofs->config.metacopy = ovl_metacopy_def;
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
 		goto out_err;
@@ -1209,6 +1233,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ofs->upper_mnt->mnt_sb != ofs->same_sb)
 		ofs->same_sb = NULL;
 
+	if (!(ovl_force_readonly(ofs)) && ofs->config.metacopy) {
+		/* Verify lower root is upper root origin */
+		err = ovl_verify_origin(upperpath.dentry,
+					oe->lowerstack[0].dentry, false, true);
+		if (err) {
+			pr_err("overlayfs: failed to verify upper root origin\n");
+                        goto out_free_oe;
+		}
+	}
+
 	if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
 		err = ovl_get_indexdir(ofs, oe, &upperpath);
 		if (err)
-- 
2.13.6
