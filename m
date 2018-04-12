From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 09/35] ovl: stack file ops
Date: Thu, 12 Apr 2018 17:08:00 +0200
Message-ID: <20180412150826.20988-10-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Implement file operations on a regular overlay file.  The underlying file
is opened separately and cached in ->private_data.

It might be worth making an exception for such files when accounting in
nr_file to confirm to userspace expectations.  We are only adding a small
overhead (248bytes for the struct file) since the real inode and dentry are
pinned by overlayfs anyway.

This patch doesn't have any effect, since the vfs will use d_real() to find
the real underlying file to open.  The patch at the end of the series will
actually enable this functionality.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/Makefile    |  4 +--
 fs/overlayfs/file.c      | 76 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c     |  1 +
 fs/overlayfs/overlayfs.h |  3 ++
 4 files changed, 82 insertions(+), 2 deletions(-)
 create mode 100644 fs/overlayfs/file.c

diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
index 30802347a020..46e1ff8ac056 100644
--- a/fs/overlayfs/Makefile
+++ b/fs/overlayfs/Makefile
@@ -4,5 +4,5 @@
 
 obj-$(CONFIG_OVERLAY_FS) += overlay.o
 
-overlay-objs := super.o namei.o util.o inode.o dir.o readdir.o copy_up.o \
-		export.o
+overlay-objs := super.o namei.o util.o inode.o file.o dir.o readdir.o \
+		copy_up.o export.o
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
new file mode 100644
index 000000000000..a0b606885c41
--- /dev/null
+++ b/fs/overlayfs/file.c
@@ -0,0 +1,76 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/cred.h>
+#include <linux/file.h>
+#include <linux/xattr.h>
+#include "overlayfs.h"
+
+static struct file *ovl_open_realfile(const struct file *file)
+{
+	struct inode *inode = file_inode(file);
+	struct inode *upperinode = ovl_inode_upper(inode);
+	struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
+	struct file *realfile;
+	const struct cred *old_cred;
+
+	old_cred = ovl_override_creds(inode->i_sb);
+	realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
+			     realinode, current_cred(), false);
+	revert_creds(old_cred);
+
+	pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
+		 file, file, upperinode ? 'u' : 'l', file->f_flags,
+		 realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
+
+	return realfile;
+}
+
+static int ovl_open(struct inode *inode, struct file *file)
+{
+	struct dentry *dentry = file_dentry(file);
+	struct file *realfile;
+	int err;
+
+	err = ovl_open_maybe_copy_up(dentry, file->f_flags);
+	if (err)
+		return err;
+
+	/* No longer need these flags, so don't pass them on to underlying fs */
+	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
+
+	realfile = ovl_open_realfile(file);
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	file->private_data = realfile;
+
+	return 0;
+}
+
+static int ovl_release(struct inode *inode, struct file *file)
+{
+	fput(file->private_data);
+
+	return 0;
+}
+
+static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *realinode = ovl_inode_real(file_inode(file));
+
+	return generic_file_llseek_size(file, offset, whence,
+					realinode->i_sb->s_maxbytes,
+					i_size_read(realinode));
+}
+
+const struct file_operations ovl_file_operations = {
+	.open		= ovl_open,
+	.release	= ovl_release,
+	.llseek		= ovl_llseek,
+};
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index e213bb9823ec..3b996639e1ad 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -542,6 +542,7 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev,
 	switch (mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &ovl_file_inode_operations;
+		inode->i_fop = &ovl_file_operations;
 		break;
 
 	case S_IFDIR:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 10f5f3bf9d96..b29c1688f372 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -381,6 +381,9 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct dentry *hardlink, bool debug);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
+/* file.c */
+extern const struct file_operations ovl_file_operations;
+
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
-- 
2.14.3
