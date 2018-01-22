From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v10 04/18] ovl: Provide a mount option metacopy=on/off for metadata copyup
Date: Mon, 22 Jan 2018 13:39:50 -0500
Message-ID: <20180122184004.26026-5-vgoyal@redhat.com>
References: <20180122184004.26026-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53062 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751125AbeAVSkN (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Jan 2018 13:40:13 -0500
In-Reply-To: <20180122184004.26026-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

By default metadata only copy up is disabled. Provide a mount option so
that users can choose one way or other.

Also provide a kernel config and module option to enable/disable
metacopy feature.

Like index feature, we verify on mount that upper root is not being
reused with a different lower root. This hopes to get the configuration
right and detect the copied layers use case. But this does only so
much as we don't verify all the lowers. So it is possible that a lower is
missing and later data copy up fails.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 Documentation/filesystems/overlayfs.txt | 54 ++++++++++++++++++++++++---------
 fs/overlayfs/Kconfig                    | 15 +++++++++
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 40 ++++++++++++++++++++++--
 4 files changed, 93 insertions(+), 17 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index e6a5f4912b6d..43743d1121b8 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -235,6 +235,30 @@ rightmost one and going left.  In the above example lower1 will be the
 top, lower2 the middle and lower3 the bottom layer.
 
 
+Metadata only copyup
+--------------------
+
+When metadata only copy up feature is enabled, overlayfs will only copy
+up metadata (as opposed to whole file), when a metadata specific operation
+like chown/chmod is performed. Full file will be copied up later when
+file is opened for WRITE operation.
+
+IOW, this is delayed data copy up operation and data is copied up when
+there is a need to actually modify data.
+
+There are multiple ways to enable/disable this feature. A config option
+CONFIG_OVERLAY_FS_METACOPY can be set/unset to enable/disable this feature
+by default. Or one can enable/disable it at module load time with module
+parameter metacopy=on/off. Lastly, there is also a per mount option
+metacopy=on/off to enable/disable this feature per mount.
+
+Do not use metacopy=on with untrusted upper/lower directories. Otherwise
+it is possible that an attacker can create an handcrafted file with
+appropriate ORIGIN and METACOPY xattrs, and gain access to file on lower
+pointed by ORIGIN. This should not be possible on local system as setting
+"trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
+for untrusted layers like from a pen drive.
+
 Sharing and copying layers
 --------------------------
 
@@ -253,23 +277,25 @@ though it will not result in a crash or deadlock.
 Mounting an overlay using an upper layer path, where the upper layer path
 was previously used by another mounted overlay in combination with a
 different lower layer path, is allowed, unless the "inodes index" feature
-is enabled.
-
-With the "inodes index" feature, on the first time mount, an NFS file
-handle of the lower layer root directory, along with the UUID of the lower
-filesystem, are encoded and stored in the "trusted.overlay.origin" extended
-attribute on the upper layer root directory.  On subsequent mount attempts,
-the lower root directory file handle and lower filesystem UUID are compared
-to the stored origin in upper root directory.  On failure to verify the
-lower root origin, mount will fail with ESTALE.  An overlayfs mount with
-"inodes index" enabled will fail with EOPNOTSUPP if the lower filesystem
-does not support NFS export, lower filesystem does not have a valid UUID or
-if the upper filesystem does not support extended attributes.
+or "metadata only copyup" feature is enabled.
+
+With the "inodes index" or "metadata only copyup" feature, on the first time
+mount, an NFS file handle of the lower layer root directory, along with the
+UUID of the lower filesystem, are encoded and stored in the
+"trusted.overlay.origin" extended attribute on the upper layer root
+directory.  On subsequent mount attempts, the lower root directory file
+handle and lower filesystem UUID are compared to the stored origin in upper
+root directory.  On failure to verify the lower root origin, mount will fail
+with ESTALE.  An overlayfs mount with "inodes index" enabled will fail with
+EOPNOTSUPP if the lower filesystem does not support NFS export, lower
+filesystem does not have a valid UUID or if the upper filesystem does not
+support extended attributes.
 
 It is quite a common practice to copy overlay layers to a different
 directory tree on the same or different underlying filesystem, and even
-to a different machine.  With the "inodes index" feature, trying to mount
-the copied layers will fail the verification of the lower root file handle.
+to a different machine.  With the "inodes index" or "metadata only copyup"
+feature, trying to mount the copied layers will fail the verification of the
+lower root file handle.
 
 
 Non-standard behavior
diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 5ac415466861..176546dfc49a 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -53,3 +53,18 @@ config OVERLAY_FS_INDEX
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
+	  happen when a file is opended for WRITE operation. It is still
+	  possible to turn off this feature globally with the "metacopy=off"
+	  module option or on a filesystem instance basis with the
+	  "metacopy=off" mount option.
+
+	  Note, that this feature is not backward compatible.  That is,
+	  mounting an overlay which has metacopy only inodes on a kernel
+	  that doesn't support this feature will have unexpected results.
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 9d0bc03bf6e4..92a4db0bd18c 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -17,6 +17,7 @@ struct ovl_config {
 	bool redirect_follow;
 	const char *redirect_mode;
 	bool index;
+	bool metacopy;
 };
 
 struct ovl_layer {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e9419faaa156..73cb90eeda0f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -53,6 +53,11 @@ static void ovl_entry_stack_free(struct ovl_entry *oe)
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
@@ -341,6 +346,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 		seq_printf(m, ",redirect_dir=%s", ofs->config.redirect_mode);
 	if (ofs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s", ofs->config.index ? "on" : "off");
+	if (ofs->config.metacopy != ovl_metacopy_def)
+		seq_printf(m, ",metacopy=%s",
+			   ofs->config.metacopy ? "on" : "off");
 	return 0;
 }
 
@@ -373,6 +381,8 @@ enum {
 	OPT_REDIRECT_DIR,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
+	OPT_METACOPY_ON,
+	OPT_METACOPY_OFF,
 	OPT_ERR,
 };
 
@@ -384,6 +394,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_REDIRECT_DIR,		"redirect_dir=%s"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
+	{OPT_METACOPY_ON,		"metacopy=on"},
+	{OPT_METACOPY_OFF,		"metacopy=off"},
 	{OPT_ERR,			NULL}
 };
 
@@ -490,6 +502,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
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
@@ -703,9 +723,11 @@ static int ovl_lower_dir(const char *name, struct path *path,
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
@@ -969,7 +991,8 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 		ofs->noxattr = true;
 		ofs->config.redirect_dir = false;
 		ofs->config.index = false;
-		pr_warn("overlayfs: upper fs does not support xattr, falling back to redirect_dir=off, index=off and no opaque dir.\n");
+		ofs->config.metacopy = false;
+		pr_warn("overlayfs: upper fs does not support xattr, falling back to redirect_dir=off, index=off, metacopy=off and no opaque dir.\n");
 	} else {
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
 	}
@@ -1209,6 +1232,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_err;
 
 	ofs->config.index = ovl_index_def;
+	ofs->config.metacopy = ovl_metacopy_def;
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
 		goto out_err;
@@ -1254,6 +1278,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ofs->upper_mnt->mnt_sb != ofs->same_sb)
 		ofs->same_sb = NULL;
 
+	if (ofs->upper_mnt && ofs->config.metacopy) {
+		/* Verify lower root is upper root origin */
+		err = ovl_verify_origin(upperpath.dentry,
+					oe->lowerstack[0].dentry, false, true);
+		if (err) {
+			pr_err("overlayfs: failed to verify upper root origin\n");
+			goto out_free_oe;
+		}
+	}
+
 	if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
 		err = ovl_get_indexdir(ofs, oe, &upperpath);
 		if (err)
-- 
2.13.6
