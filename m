From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 03/28] ovl: Provide a mount option metacopy=on/off for metadata copyup
Date: Tue, 29 May 2018 16:45:47 +0200
Message-ID: <20180529144612.16675-4-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

By default metadata only copy up is disabled.  Provide a mount option so
that users can choose one way or other.

Also provide a kernel config and module option to enable/disable metacopy
feature.

metacopy feature requires redirect_dir=on when upper is present.
Otherwise, it requires redirect_dir=follow atleast.

As of now, metacopy does not work with nfs_export=on.  So if both
metacopy=on and nfs_export=on then nfs_export is disabled.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/overlayfs.txt | 30 ++++++++++++++++++++-
 fs/overlayfs/Kconfig                    | 19 ++++++++++++++
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 46 ++++++++++++++++++++++++++++++---
 4 files changed, 92 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index f087bc40c6a5..79be4a77ca08 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -262,6 +262,30 @@ rightmost one and going left.  In the above example lower1 will be the
 top, lower2 the middle and lower3 the bottom layer.
 
 
+Metadata only copy up
+--------------------
+
+When metadata only copy up feature is enabled, overlayfs will only copy
+up metadata (as opposed to whole file), when a metadata specific operation
+like chown/chmod is performed. Full file will be copied up later when
+file is opened for WRITE operation.
+
+In other words, this is delayed data copy up operation and data is copied
+up when there is a need to actually modify data.
+
+There are multiple ways to enable/disable this feature. A config option
+CONFIG_OVERLAY_FS_METACOPY can be set/unset to enable/disable this feature
+by default. Or one can enable/disable it at module load time with module
+parameter metacopy=on/off. Lastly, there is also a per mount option
+metacopy=on/off to enable/disable this feature per mount.
+
+Do not use metacopy=on with untrusted upper/lower directories. Otherwise
+it is possible that an attacker can create an handcrafted file with
+appropriate REDIRECT and METACOPY xattrs, and gain access to file on lower
+pointed by REDIRECT. This should not be possible on local system as setting
+"trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
+for untrusted layers like from a pen drive.
+
 Sharing and copying layers
 --------------------------
 
@@ -280,7 +304,7 @@ though it will not result in a crash or deadlock.
 Mounting an overlay using an upper layer path, where the upper layer path
 was previously used by another mounted overlay in combination with a
 different lower layer path, is allowed, unless the "inodes index" feature
-is enabled.
+or "metadata only copy up" feature is enabled.
 
 With the "inodes index" feature, on the first time mount, an NFS file
 handle of the lower layer root directory, along with the UUID of the lower
@@ -293,6 +317,10 @@ lower root origin, mount will fail with ESTALE.  An overlayfs mount with
 does not support NFS export, lower filesystem does not have a valid UUID or
 if the upper filesystem does not support extended attributes.
 
+For "metadata only copy up" feature there is no verification mechanism at
+mount time. So if same upper is mouted with different set of lower, mount
+probably will succeed but expect the unexpected later on. So don't do it.
+
 It is quite a common practice to copy overlay layers to a different
 directory tree on the same or different underlying filesystem, and even
 to a different machine.  With the "inodes index" feature, trying to mount
diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 5d1d40d745c5..e0a090eca65e 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -64,6 +64,7 @@ config OVERLAY_FS_NFS_EXPORT
 	bool "Overlayfs: turn on NFS export feature by default"
 	depends on OVERLAY_FS
 	depends on OVERLAY_FS_INDEX
+	depends on !OVERLAY_FS_METACOPY
 	help
 	  If this config option is enabled then overlay filesystems will use
 	  the inodes index dir to decode overlay NFS file handles by default.
@@ -124,3 +125,21 @@ config OVERLAY_FS_COPY_UP_SHARED
 	  To get a maximally backward compatible kernel, disable this option.
 
 	  If unsure, say N.
+
+config OVERLAY_FS_METACOPY
+	bool "Overlayfs: turn on metadata only copy up feature by default"
+	depends on OVERLAY_FS
+	select OVERLAY_FS_REDIRECT_DIR
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
+
+	  If unsure, say N.
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 3bea47c63fd9..da65118a0567 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -20,6 +20,7 @@ struct ovl_config {
 	bool nfs_export;
 	bool copy_up_shared;
 	int xino;
+	bool metacopy;
 };
 
 struct ovl_sb {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index cd5c82f105d6..17873b804c04 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -70,6 +70,11 @@ static void ovl_entry_stack_free(struct ovl_entry *oe)
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
@@ -356,6 +361,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ofs->config.copy_up_shared != ovl_copy_up_shared_def)
 		seq_printf(m, ",copy_up_shared=%s",
 			   ofs->config.copy_up_shared ? "on" : "off");
+	if (ofs->config.metacopy != ovl_metacopy_def)
+		seq_printf(m, ",metacopy=%s",
+			   ofs->config.metacopy ? "on" : "off");
 	return 0;
 }
 
@@ -395,6 +403,8 @@ enum {
 	OPT_XINO_AUTO,
 	OPT_COPY_UP_SHARED_ON,
 	OPT_COPY_UP_SHARED_OFF,
+	OPT_METACOPY_ON,
+	OPT_METACOPY_OFF,
 	OPT_ERR,
 };
 
@@ -413,6 +423,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_XINO_AUTO,			"xino=auto"},
 	{OPT_COPY_UP_SHARED_ON,		"copy_up_shared=on"},
 	{OPT_COPY_UP_SHARED_OFF,	"copy_up_shared=off"},
+	{OPT_METACOPY_ON,		"metacopy=on"},
+	{OPT_METACOPY_OFF,		"metacopy=off"},
 	{OPT_ERR,			NULL}
 };
 
@@ -465,6 +477,7 @@ static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
 static int ovl_parse_opt(char *opt, struct ovl_config *config)
 {
 	char *p;
+	int err;
 
 	config->redirect_mode = kstrdup(ovl_redirect_mode_def(), GFP_KERNEL);
 	if (!config->redirect_mode)
@@ -547,6 +560,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->copy_up_shared = false;
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
@@ -561,7 +582,20 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		config->workdir = NULL;
 	}
 
-	return ovl_parse_redirect_mode(config, config->redirect_mode);
+	err = ovl_parse_redirect_mode(config, config->redirect_mode);
+	if (err)
+		return err;
+
+	/* metacopy feature with upper requires redirect_dir=on */
+	if (config->upperdir && config->metacopy && !config->redirect_dir) {
+		pr_warn("overlayfs: metadata only copy up requires \"redirect_dir=on\", falling back to metacopy=off.\n");
+		config->metacopy = false;
+	} else if (config->metacopy && !config->redirect_follow) {
+		pr_warn("overlayfs: metadata only copy up requires \"redirect_dir=follow\" on non-upper mount, falling back to metacopy=off.\n");
+		config->metacopy = false;
+	}
+
+	return 0;
 }
 
 #define OVL_WORKDIR_NAME "work"
@@ -1034,7 +1068,8 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	if (err) {
 		ofs->noxattr = true;
 		ofs->config.index = false;
-		pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off.\n");
+		ofs->config.metacopy = false;
+		pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off and metacopy=off.\n");
 		err = 0;
 	} else {
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
@@ -1056,7 +1091,6 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 		pr_warn("overlayfs: NFS export requires \"index=on\", falling back to nfs_export=off.\n");
 		ofs->config.nfs_export = false;
 	}
-
 out:
 	mnt_drop_write(mnt);
 	return err;
@@ -1368,6 +1402,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
 	ofs->config.copy_up_shared = ovl_copy_up_shared_def;
+	ofs->config.metacopy = ovl_metacopy_def;
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
 		goto out_err;
@@ -1438,6 +1473,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		}
 	}
 
+	if (ofs->config.metacopy && ofs->config.nfs_export) {
+		pr_warn("overlayfs: NFS export is not supported with metadata only copy up, falling back to nfs_export=off.\n");
+		ofs->config.nfs_export = false;
+	}
+
 	if (ofs->config.nfs_export)
 		sb->s_export_op = &ovl_export_operations;
 
-- 
2.14.3
