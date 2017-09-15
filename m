From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [experimental PATCH] ovl: get rid of d_real()
Date: Fri, 15 Sep 2017 15:58:05 +0200
Message-ID: <20170915135805.GD19278@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f181.google.com ([209.85.128.181]:50975 "EHLO
        mail-wr0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751303AbdION6K (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 15 Sep 2017 09:58:10 -0400
Received: by mail-wr0-f181.google.com with SMTP id w12so1900491wrc.7
        for <linux-unionfs@vger.kernel.org>; Fri, 15 Sep 2017 06:58:09 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Fri, Sep 15, 2017 at 10:06:24AM +0200, Miklos Szeredi wrote:
> And, btw. I also hate all the hacks we need to do in the VFS for the
> sake of overlayfs.  It may actually end up all being removed and all
> the stacking moved to overlayfs; that's something I'd really like to
> look at.   All of these hacks are there because overlayfs lets the
> open file be owned by the underlying filesystem, which is good for
> performance and results in simpler code in overlayfs, but may not
> actually be worth it.

And here's the prototype.  Poof, d_real() is gone.

It definitely has got problems, but just maybe it can be made better than the
current mess.  It *does* solve the ro-rw inconsistency for normal reads (not
mmaps).

Thanks,
Miklos

---
 fs/overlayfs/Makefile    |    2 
 fs/overlayfs/file.c      |  167 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c     |    1 
 fs/overlayfs/overlayfs.h |    5 +
 fs/overlayfs/super.c     |   65 ------------------
 5 files changed, 174 insertions(+), 66 deletions(-)

--- a/fs/overlayfs/Makefile
+++ b/fs/overlayfs/Makefile
@@ -4,4 +4,4 @@
 
 obj-$(CONFIG_OVERLAY_FS) += overlay.o
 
-overlay-objs := super.o namei.o util.o inode.o dir.o readdir.o copy_up.o
+overlay-objs := super.o namei.o util.o inode.o dir.o file.o readdir.o copy_up.o
--- /dev/null
+++ b/fs/overlayfs/file.c
@@ -0,0 +1,167 @@
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
+#include "overlayfs.h"
+
+static int ovl_check_append_only(struct inode *inode, int flag)
+{
+	/*
+	 * This test was moot in vfs may_open() because overlay inode does
+	 * not have the S_APPEND flag, so re-check on real upper inode
+	 */
+	if (IS_APPEND(inode)) {
+		if  ((flag & O_ACCMODE) != O_RDONLY && !(flag & O_APPEND))
+			return -EPERM;
+		if (flag & O_TRUNC)
+			return -EPERM;
+	}
+
+	return 0;
+}
+
+static int ovl_open(struct inode *inode, struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	int err;
+
+	err = ovl_open_maybe_copy_up(dentry, file->f_flags);
+	if (!err)
+		err = ovl_check_append_only(d_inode(ovl_dentry_real(dentry)),
+					    file->f_flags);
+
+	return err;
+}
+
+static rwf_t ovl_iocb_to_rwf(struct kiocb *iocb)
+{
+	int ifl = iocb->ki_flags;
+	rwf_t flags = 0;
+
+	if (ifl & IOCB_NOWAIT)
+		flags |= RWF_NOWAIT;
+	if (ifl & IOCB_HIPRI)
+		flags |= RWF_HIPRI;
+	if (ifl & IOCB_DSYNC)
+		flags |= RWF_DSYNC;
+	if (ifl & IOCB_SYNC)
+		flags |= RWF_SYNC;
+
+	return flags;
+}
+
+static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+	struct path realpath;
+	struct file *realfile;
+	ssize_t ret;
+
+	ovl_path_real(file->f_path.dentry, &realpath);
+	realfile = dentry_open(&realpath, file->f_flags, current_cred());
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	ret = vfs_iter_read(realfile, iter, &iocb->ki_pos,
+			    ovl_iocb_to_rwf(iocb));
+
+	fput(realfile);
+
+	return ret;
+}
+
+static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+	struct path realpath;
+	struct file *realfile;
+	ssize_t ret;
+
+	ovl_path_real(file->f_path.dentry, &realpath);
+	realfile = dentry_open(&realpath, file->f_flags, current_cred());
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	ret = vfs_iter_write(realfile, iter, &iocb->ki_pos,
+			     ovl_iocb_to_rwf(iocb));
+
+	fput(realfile);
+
+	return ret;
+}
+
+static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	struct path realpath;
+	struct file *realfile;
+	int ret;
+
+	ovl_path_real(file->f_path.dentry, &realpath);
+	realfile = dentry_open(&realpath, file->f_flags, current_cred());
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	ret = vfs_fsync_range(realfile, start, end, datasync);
+
+	fput(realfile);
+
+	return ret;
+}
+
+static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
+{
+	struct inode *realinode = d_inode(ovl_dentry_real(file->f_path.dentry));
+
+	return generic_file_llseek_size(file, offset, whence,
+					realinode->i_sb->s_maxbytes,
+					i_size_read(realinode));
+}
+
+static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct inode *inode = file_inode(file);
+	struct path realpath;
+	struct file *realfile;
+	struct inode *realinode;
+	int err;
+
+	ovl_path_real(file->f_path.dentry, &realpath);
+	realinode = d_inode(realpath.dentry);
+
+	realfile = dentry_open(&realpath, file->f_flags, current_cred());
+	if (IS_ERR(realfile))
+		return PTR_ERR(realfile);
+
+	err = -ENODEV;
+	if (!realfile->f_op->mmap)
+		goto out;
+
+	file->f_mapping = realfile->f_mapping;
+	if (inode->i_mapping == &inode->i_data)
+		inode->i_mapping = realinode->i_mapping;
+
+	err = -EBUSY;
+	if (inode->i_mapping != realinode->i_mapping)
+		goto out;
+
+	err = call_mmap(realfile, vma);
+out:
+	fput(realfile);
+
+	return err;
+}
+
+const struct file_operations ovl_file_operations = {
+	.open		= ovl_open,
+	.read_iter	= ovl_read_iter,
+	.write_iter	= ovl_write_iter,
+	.fsync		= ovl_fsync,
+	.llseek		= ovl_llseek,
+	.mmap		= ovl_mmap,
+};
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -436,6 +436,7 @@ static void ovl_fill_inode(struct inode
 	switch (mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &ovl_file_inode_operations;
+		inode->i_fop = &ovl_file_operations;
 		break;
 
 	case S_IFDIR:
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -9,6 +9,8 @@
 
 #include <linux/kernel.h>
 #include <linux/uuid.h>
+#include <linux/xattr.h>
+#include <linux/fs.h>
 
 enum ovl_path_type {
 	__OVL_PATH_UPPER	= (1 << 0),
@@ -309,6 +311,9 @@ int ovl_create_real(struct inode *dir, s
 		    struct dentry *hardlink, bool debug);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
+/* file.c */
+extern const struct file_operations ovl_file_operations;
+
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -52,69 +52,6 @@ static void ovl_dentry_release(struct de
 	}
 }
 
-static int ovl_check_append_only(struct inode *inode, int flag)
-{
-	/*
-	 * This test was moot in vfs may_open() because overlay inode does
-	 * not have the S_APPEND flag, so re-check on real upper inode
-	 */
-	if (IS_APPEND(inode)) {
-		if  ((flag & O_ACCMODE) != O_RDONLY && !(flag & O_APPEND))
-			return -EPERM;
-		if (flag & O_TRUNC)
-			return -EPERM;
-	}
-
-	return 0;
-}
-
-static struct dentry *ovl_d_real(struct dentry *dentry,
-				 const struct inode *inode,
-				 unsigned int open_flags, unsigned int flags)
-{
-	struct dentry *real;
-	int err;
-
-	if (flags & D_REAL_UPPER)
-		return ovl_dentry_upper(dentry);
-
-	if (!d_is_reg(dentry)) {
-		if (!inode || inode == d_inode(dentry))
-			return dentry;
-		goto bug;
-	}
-
-	if (open_flags) {
-		err = ovl_open_maybe_copy_up(dentry, open_flags);
-		if (err)
-			return ERR_PTR(err);
-	}
-
-	real = ovl_dentry_upper(dentry);
-	if (real && (!inode || inode == d_inode(real))) {
-		if (!inode) {
-			err = ovl_check_append_only(d_inode(real), open_flags);
-			if (err)
-				return ERR_PTR(err);
-		}
-		return real;
-	}
-
-	real = ovl_dentry_lower(dentry);
-	if (!real)
-		goto bug;
-
-	/* Handle recursion */
-	real = d_real(real, inode, open_flags, 0);
-
-	if (!inode || inode == d_inode(real))
-		return real;
-bug:
-	WARN(1, "ovl_d_real(%pd4, %s:%lu): real dentry not found\n", dentry,
-	     inode ? inode->i_sb->s_id : "NULL", inode ? inode->i_ino : 0);
-	return dentry;
-}
-
 static int ovl_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -158,12 +95,10 @@ static int ovl_dentry_weak_revalidate(st
 
 static const struct dentry_operations ovl_dentry_operations = {
 	.d_release = ovl_dentry_release,
-	.d_real = ovl_d_real,
 };
 
 static const struct dentry_operations ovl_reval_dentry_operations = {
 	.d_release = ovl_dentry_release,
-	.d_real = ovl_d_real,
 	.d_revalidate = ovl_dentry_revalidate,
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
 };
