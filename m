From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 3/3] ovl: don't allow writing ioctl on lower layer
Date: Tue,  5 Sep 2017 09:46:36 +0200
Message-ID: <1504597596-17994-4-git-send-email-mszeredi@redhat.com>
References: <1504597596-17994-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f169.google.com ([209.85.128.169]:35908 "EHLO
        mail-wr0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751451AbdIEHqo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Sep 2017 03:46:44 -0400
Received: by mail-wr0-f169.google.com with SMTP id p14so4688459wrg.3
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Sep 2017 00:46:43 -0700 (PDT)
In-Reply-To: <1504597596-17994-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org

Problem with ioctl() is that it's a file operation, yet often used as an
inode operation (i.e. modify the inode despite the file being opened for
read-only).

mnt_want_write_file() is used by filesystems in such cases to get write
access on an arbitrary open file.

Since overlayfs lets filesystems do all file operations, including ioctl,
this can lead to mnt_want_write_file() returning OK for a lower file and
modification of that lower file.

This patch prevents modification by checking if the file is from an
overlayfs lower layer and returning EPERM in that case.

Need to introduce a mnt_want_write_file_path() variant that still does the
old thing for inode operations that can do the copy up + modification
correctly in such cases (fchown, fsetxattr, fremovexattr).

This does not address the correctness of such ioctls on overlayfs (the
correct way would be to copy up and attempt to perform ioctl on upper
file).

In theory this could be a regression.  We very much hope that nobody is
relying on such a hack in any sane setup.

While this patch meddles in VFS code, it has no effect on non-overlayfs
filesystems.

Reported-by: "zhangyi (F)" <yi.zhang@huawei.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/internal.h          |  2 ++
 fs/namespace.c         | 64 +++++++++++++++++++++++++++++++++++++++++++++++---
 fs/open.c              |  4 ++--
 fs/overlayfs/super.c   |  3 +++
 fs/xattr.c             |  9 +++----
 include/linux/dcache.h |  1 +
 6 files changed, 74 insertions(+), 9 deletions(-)

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
index f8893dc6a989..df0f7521979a 100644
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
+	upperdentry = d_real(dentry, NULL, 0, D_REAL_UPPER);
+	if (upperdentry && file_inode(file) == d_inode(upperdentry))
+		return 0;
+
+	/* Lower layer: can't write to real file, sorry... */
+	return -EPERM;
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
index 6d5c9a9b8c8d..7ea118471dce 100644
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
index 059ee2f19361..0d53373b2ffc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -78,6 +78,9 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	if (flags & D_REAL_ALL)
 		return ovl_dentry_real(dentry);
 
+	if (flags & D_REAL_UPPER)
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
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 9594ef3382ff..bf5b7d57414b 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -564,6 +564,7 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
 
 /* d_real() flags */
 #define D_REAL_ALL	0x1	/* return real dentry for all file types */
+#define D_REAL_UPPER	0x2	/* return upper dentry or NULL if non-upper */
 
 /**
  * d_real - Return the real dentry
-- 
2.5.5
