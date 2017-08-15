From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: two questiones about overlayfs
Date: Tue, 15 Aug 2017 15:35:54 +0200
Message-ID: <20170815133554.GB29201@veci.piliscsaba.szeredi.hu>
References: <b68bea1b-4b51-8573-cf8a-06da4c41ed00@huawei.com>
 <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:38827 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751122AbdHONf7 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Aug 2017 09:35:59 -0400
Received: by mail-wm0-f47.google.com with SMTP id f15so10023675wmg.1
        for <linux-unionfs@vger.kernel.org>; Tue, 15 Aug 2017 06:35:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiL=Gqy6A=_gKTFG0sQRYkZ37aptdn2fEvcF0phJBmW7Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, miaoxie@huawei.com, Vivek Goyal <vgoyal@redhat.com>

On Tue, Aug 08, 2017 at 07:01:30AM +0200, Amir Goldstein wrote:
> On Mon, Aug 7, 2017 at 9:57 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:

[snip]

> > 2. Chattr will modify lower file's attributes directly.
> > Reproduce:
> > # mkdir lower upper worker merger
> > # touch lower/aa
> > # lsattr -p lower/aa
> >     0 --------------e---- lower/aa
> > # mount -t overlay -o lowerdir=lower,upperdir=upper,workdir=worker overlayfs merger
> > # chattr -p 123 merger/aa             #set project id
> > # lsattr -p lower/aa
> >   123 --------------e---- lower/aa
> >
> > If we try to set "immutable" or any other attributes, the result are consistent.
> > Because chattr open file in RDONLY mode, so it will not trigger copyup, and then,
> > FS_IOC_SETFLAGS ioctl will get the lower inode and modify it.
> 
> Ouch! I guess it's a "known to some" issue.
> Fixing this would be a pain (intercept ioctl and whitelisting readonly
> fs specific ioctls).

Fixing ioctl properly would be a pain.  But we can hack around the issue, and
just deny it for now.

See patch below

(Side note: probably better just add another argument to ->d_real() instead of
trying to cram everyting into the open_flags arg).

Thanks,
Miklos

diff --git a/fs/internal.h b/fs/internal.h
index 9676fe11c093..60cdbcd2887b 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -71,8 +71,10 @@ extern void __init mnt_init(void);
 
 extern int __mnt_want_write(struct vfsmount *);
 extern int __mnt_want_write_file(struct file *);
+extern int mnt_want_write_file_path(struct file *);
 extern void __mnt_drop_write(struct vfsmount *);
 extern void __mnt_drop_write_file(struct file *);
+extern void mnt_drop_write_file_path(struct file *);
 
 /*
  * fs_struct.c
diff --git a/fs/namespace.c b/fs/namespace.c
index f8893dc6a989..22a492332ec4 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -431,13 +431,18 @@ int __mnt_want_write_file(struct file *file)
 }
 
 /**
- * mnt_want_write_file - get write access to a file's mount
+ * mnt_want_write_file_path - get write access to a file's mount
  * @file: the file who's mount on which to take a write
  *
  * This is like mnt_want_write, but it takes a file and can
  * do some optimisations if the file is open for write already
+ *
+ * Called by the vfs for cases when we have an open file at hand, but will do an
+ * inode operation on it (important distinction for files opened on overlayfs,
+ * since the file operations will come from the real underlying file, while
+ * inode operations come from the overlay).
  */
-int mnt_want_write_file(struct file *file)
+int mnt_want_write_file_path(struct file *file)
 {
 	int ret;
 
@@ -447,6 +452,53 @@ int mnt_want_write_file(struct file *file)
 		sb_end_write(file->f_path.mnt->mnt_sb);
 	return ret;
 }
+
+static inline int may_write_real(struct file *file)
+{
+	struct dentry *dentry = file->f_path.dentry;
+	struct dentry *upperdentry;
+
+	/* Writable file? */
+	if (file->f_mode & FMODE_WRITER)
+		return 0;
+
+	/* Not overlayfs? */
+	if (likely(!(dentry->d_flags & DCACHE_OP_REAL)))
+		return 0;
+
+	/* File refers to upper, writable layer? */
+	upperdentry = d_real(dentry, NULL, -2);
+	if (upperdentry && file_inode(file) == d_inode(upperdentry))
+		return 0;
+
+	/* Lower layer: can't write to real file, sorry... */
+	return -EINVAL;
+}
+
+/**
+ * mnt_want_write_file - get write access to a file's mount
+ * @file: the file who's mount on which to take a write
+ *
+ * This is like mnt_want_write, but it takes a file and can
+ * do some optimisations if the file is open for write already
+ *
+ * Mostly called by filesystems from their ioctl operation before performing
+ * modification.  On overlayfs this needs to check if the file is on a read-only
+ * lower layer and deny access in that case.
+ */
+int mnt_want_write_file(struct file *file)
+{
+	int ret;
+
+	ret = may_write_real(file);
+	if (!ret) {
+		sb_start_write(file_inode(file)->i_sb);
+		ret = __mnt_want_write_file(file);
+		if (ret)
+			sb_end_write(file_inode(file)->i_sb);
+	}
+	return ret;
+}
 EXPORT_SYMBOL_GPL(mnt_want_write_file);
 
 /**
@@ -484,10 +536,16 @@ void __mnt_drop_write_file(struct file *file)
 	__mnt_drop_write(file->f_path.mnt);
 }
 
-void mnt_drop_write_file(struct file *file)
+void mnt_drop_write_file_path(struct file *file)
 {
 	mnt_drop_write(file->f_path.mnt);
 }
+
+void mnt_drop_write_file(struct file *file)
+{
+	__mnt_drop_write(file->f_path.mnt);
+	sb_end_write(file_inode(file)->i_sb);
+}
 EXPORT_SYMBOL(mnt_drop_write_file);
 
 static int mnt_make_readonly(struct mount *mnt)
diff --git a/fs/open.c b/fs/open.c
index 35bb784763a4..c53a2315df98 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -670,12 +670,12 @@ SYSCALL_DEFINE3(fchown, unsigned int, fd, uid_t, user, gid_t, group)
 	if (!f.file)
 		goto out;
 
-	error = mnt_want_write_file(f.file);
+	error = mnt_want_write_file_path(f.file);
 	if (error)
 		goto out_fput;
 	audit_file(f.file);
 	error = chown_common(&f.file->f_path, user, group);
-	mnt_drop_write_file(f.file);
+	mnt_drop_write_file_path(f.file);
 out_fput:
 	fdput(f);
 out:
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d86e89f97201..95e1271cc90f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -75,6 +75,10 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	struct dentry *real;
 	int err;
 
+	BUILD_BUG_ON(!((unsigned int) -2 & ~VALID_OPEN_FLAGS));
+	if (open_flags == (unsigned int) -2)
+		return ovl_dentry_upper(dentry);
+
 	if (!d_is_reg(dentry)) {
 		if (!inode || inode == d_inode(dentry))
 			return dentry;
diff --git a/fs/xattr.c b/fs/xattr.c
index 464c94bf65f9..d7c2cf7817bb 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -23,6 +23,7 @@
 #include <linux/posix_acl_xattr.h>
 
 #include <linux/uaccess.h>
+#include "internal.h"
 
 static const char *
 strcmp_prefix(const char *a, const char *a_prefix)
@@ -496,10 +497,10 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 	if (!f.file)
 		return error;
 	audit_file(f.file);
-	error = mnt_want_write_file(f.file);
+	error = mnt_want_write_file_path(f.file);
 	if (!error) {
 		error = setxattr(f.file->f_path.dentry, name, value, size, flags);
-		mnt_drop_write_file(f.file);
+		mnt_drop_write_file_path(f.file);
 	}
 	fdput(f);
 	return error;
@@ -728,10 +729,10 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 	if (!f.file)
 		return error;
 	audit_file(f.file);
-	error = mnt_want_write_file(f.file);
+	error = mnt_want_write_file_path(f.file);
 	if (!error) {
 		error = removexattr(f.file->f_path.dentry, name);
-		mnt_drop_write_file(f.file);
+		mnt_drop_write_file_path(f.file);
 	}
 	fdput(f);
 	return error;
