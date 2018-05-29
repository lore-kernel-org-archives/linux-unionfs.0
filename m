From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 26/39] ovl: copy-up on MAP_SHARED
Date: Tue, 29 May 2018 16:43:26 +0200
Message-ID: <20180529144339.16538-27-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

A corner case of a corner case is when

 - file opened for O_RDONLY
 - which is then memory mapped SHARED
 - file opened for O_WRONLY
 - contents modified
 - contents read back though the shared mapping

Unfortunately it looks very difficult to do anything about the established
shared map after the file is copied up.

Instead, when a read-only file is mapped shared, copy up the file before
actually doing the map.  This may result in unnecessary copy-ups (but so
may copy-up on open(O_RDWR) for exampe).

We can revisit this later if it turns out to be a performance problem in
real life.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/Kconfig     | 21 +++++++++++++++++++++
 fs/overlayfs/file.c      | 22 ++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  7 +++++++
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 22 ++++++++++++++++++++++
 5 files changed, 73 insertions(+)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 17032631c5cf..5d1d40d745c5 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -103,3 +103,24 @@ config OVERLAY_FS_XINO_AUTO
 	  For more information, see Documentation/filesystems/overlayfs.txt
 
 	  If unsure, say N.
+
+config OVERLAY_FS_COPY_UP_SHARED
+	bool "Overlayfs: copy up when mapping a file shared"
+	default n
+	depends on OVERLAY_FS
+	help
+	  If this option is enabled then on mapping a file with MAP_SHARED
+	  overlayfs copies up the file in anticipation of it being modified
+	  (just like we copy up the file on O_WRONLY and O_RDWR in anticipation
+	  of modification).  This does not interfere with shared library
+	  loading, as that uses MAP_PRIVATE.  But there might be use cases out
+	  there where this impacts performance and disk usage.
+
+	  This just selects the default, the feature can also be enabled or
+	  disabled in the running kernel or individually on each overlay mount.
+
+	  To get maximally standard compliant behavior, enable this option.
+
+	  To get a maximally backward compatible kernel, disable this option.
+
+	  If unsure, say N.
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index ef4bcc80572f..266692ce9a9a 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -10,6 +10,7 @@
 #include <linux/file.h>
 #include <linux/mount.h>
 #include <linux/xattr.h>
+#include <linux/mman.h>
 #include <linux/uio.h>
 #include "overlayfs.h"
 
@@ -259,6 +260,26 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return ret;
 }
 
+static int ovl_pre_mmap(struct file *file, unsigned long prot,
+			unsigned long flag)
+{
+	int err = 0;
+
+	/*
+	 * Take MAP_SHARED as hint about future writes to the file (through
+	 * another file descriptor).  Caller might not have had such an intent,
+	 * but we hope MAP_PRIVATE will be used in most such cases.
+	 *
+	 * If we don't copy up now and the file is modified, it becomes really
+	 * difficult to change the mapping to match that of the file's content
+	 * later.
+	 */
+	if ((flag & MAP_SHARED) && ovl_copy_up_shared(file_inode(file)->i_sb))
+		err = ovl_copy_up(file_dentry(file));
+
+	return err;
+}
+
 static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct fd real;
@@ -476,6 +497,7 @@ const struct file_operations ovl_file_operations = {
 	.read_iter	= ovl_read_iter,
 	.write_iter	= ovl_write_iter,
 	.fsync		= ovl_fsync,
+	.pre_mmap	= ovl_pre_mmap,
 	.mmap		= ovl_mmap,
 	.fallocate	= ovl_fallocate,
 	.unlocked_ioctl	= ovl_ioctl,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 3f6e39a2f51e..be4f1664f662 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -266,6 +266,13 @@ static inline unsigned int ovl_xino_bits(struct super_block *sb)
 	return ofs->xino_bits;
 }
 
+static inline bool ovl_copy_up_shared(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return !(sb->s_flags & SB_RDONLY) && ofs->config.copy_up_shared;
+}
+
 
 /* namei.c */
 int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 41655a7d6894..3bea47c63fd9 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -18,6 +18,7 @@ struct ovl_config {
 	const char *redirect_mode;
 	bool index;
 	bool nfs_export;
+	bool copy_up_shared;
 	int xino;
 };
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 211975921a90..900ed4c39919 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -56,6 +56,12 @@ module_param_named(xino_auto, ovl_xino_auto_def, bool, 0644);
 MODULE_PARM_DESC(ovl_xino_auto_def,
 		 "Auto enable xino feature");
 
+static bool ovl_copy_up_shared_def =
+	IS_ENABLED(CONFIG_OVERLAY_FS_COPY_UP_SHARED);
+module_param_named(copy_up_shared, ovl_copy_up_shared_def, bool, 0644);
+MODULE_PARM_DESC(ovl_copy_up_shared_def,
+		 "Copy up when mapping a file shared");
+
 static void ovl_entry_stack_free(struct ovl_entry *oe)
 {
 	unsigned int i;
@@ -380,6 +386,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 						"on" : "off");
 	if (ofs->config.xino != ovl_xino_def())
 		seq_printf(m, ",xino=%s", ovl_xino_str[ofs->config.xino]);
+	if (ofs->config.copy_up_shared != ovl_copy_up_shared_def)
+		seq_printf(m, ",copy_up_shared=%s",
+			   ofs->config.copy_up_shared ? "on" : "off");
 	return 0;
 }
 
@@ -417,6 +426,8 @@ enum {
 	OPT_XINO_ON,
 	OPT_XINO_OFF,
 	OPT_XINO_AUTO,
+	OPT_COPY_UP_SHARED_ON,
+	OPT_COPY_UP_SHARED_OFF,
 	OPT_ERR,
 };
 
@@ -433,6 +444,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_XINO_ON,			"xino=on"},
 	{OPT_XINO_OFF,			"xino=off"},
 	{OPT_XINO_AUTO,			"xino=auto"},
+	{OPT_COPY_UP_SHARED_ON,		"copy_up_shared=on"},
+	{OPT_COPY_UP_SHARED_OFF,	"copy_up_shared=off"},
 	{OPT_ERR,			NULL}
 };
 
@@ -559,6 +572,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->xino = OVL_XINO_AUTO;
 			break;
 
+		case OPT_COPY_UP_SHARED_ON:
+			config->copy_up_shared = true;
+			break;
+
+		case OPT_COPY_UP_SHARED_OFF:
+			config->copy_up_shared = false;
+			break;
+
 		default:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
@@ -1379,6 +1400,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ofs->config.index = ovl_index_def;
 	ofs->config.nfs_export = ovl_nfs_export_def;
 	ofs->config.xino = ovl_xino_def();
+	ofs->config.copy_up_shared = ovl_copy_up_shared_def;
 	err = ovl_parse_opt((char *) data, &ofs->config);
 	if (err)
 		goto out_err;
-- 
2.14.3
