From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 31/39] Revert "ovl: don't allow writing ioctl on lower layer"
Date: Tue, 29 May 2018 16:43:31 +0200
Message-ID: <20180529144339.16538-32-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This reverts commit 7c6893e3c9abf6a9676e060a1e35e5caca673d57.

Overlayfs no longer relies on the vfs for checking writability of files.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/internal.h  |  2 --
 fs/namespace.c | 64 +++-------------------------------------------------------
 fs/open.c      |  4 ++--
 fs/xattr.c     |  9 ++++-----
 4 files changed, 9 insertions(+), 70 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index 6821cf475fc6..29c9a2fab592 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -80,10 +80,8 @@ extern void __init mnt_init(void);
 
 extern int __mnt_want_write(struct vfsmount *);
 extern int __mnt_want_write_file(struct file *);
-extern int mnt_want_write_file_path(struct file *);
 extern void __mnt_drop_write(struct vfsmount *);
 extern void __mnt_drop_write_file(struct file *);
-extern void mnt_drop_write_file_path(struct file *);
 
 /*
  * fs_struct.c
diff --git a/fs/namespace.c b/fs/namespace.c
index c3f7152a8419..5286c5313e67 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -431,18 +431,13 @@ int __mnt_want_write_file(struct file *file)
 }
 
 /**
- * mnt_want_write_file_path - get write access to a file's mount
+ * mnt_want_write_file - get write access to a file's mount
  * @file: the file who's mount on which to take a write
  *
  * This is like mnt_want_write, but it takes a file and can
  * do some optimisations if the file is open for write already
- *
- * Called by the vfs for cases when we have an open file at hand, but will do an
- * inode operation on it (important distinction for files opened on overlayfs,
- * since the file operations will come from the real underlying file, while
- * inode operations come from the overlay).
  */
-int mnt_want_write_file_path(struct file *file)
+int mnt_want_write_file(struct file *file)
 {
 	int ret;
 
@@ -452,53 +447,6 @@ int mnt_want_write_file_path(struct file *file)
 		sb_end_write(file->f_path.mnt->mnt_sb);
 	return ret;
 }
-
-static inline int may_write_real(struct file *file)
-{
-	struct dentry *dentry = file->f_path.dentry;
-	struct dentry *upperdentry;
-
-	/* Writable file? */
-	if (file->f_mode & FMODE_WRITER)
-		return 0;
-
-	/* Not overlayfs? */
-	if (likely(!(dentry->d_flags & DCACHE_OP_REAL)))
-		return 0;
-
-	/* File refers to upper, writable layer? */
-	upperdentry = d_real(dentry, NULL, 0, D_REAL_UPPER);
-	if (upperdentry && file_inode(file) == d_inode(upperdentry))
-		return 0;
-
-	/* Lower layer: can't write to real file, sorry... */
-	return -EPERM;
-}
-
-/**
- * mnt_want_write_file - get write access to a file's mount
- * @file: the file who's mount on which to take a write
- *
- * This is like mnt_want_write, but it takes a file and can
- * do some optimisations if the file is open for write already
- *
- * Mostly called by filesystems from their ioctl operation before performing
- * modification.  On overlayfs this needs to check if the file is on a read-only
- * lower layer and deny access in that case.
- */
-int mnt_want_write_file(struct file *file)
-{
-	int ret;
-
-	ret = may_write_real(file);
-	if (!ret) {
-		sb_start_write(file_inode(file)->i_sb);
-		ret = __mnt_want_write_file(file);
-		if (ret)
-			sb_end_write(file_inode(file)->i_sb);
-	}
-	return ret;
-}
 EXPORT_SYMBOL_GPL(mnt_want_write_file);
 
 /**
@@ -536,15 +484,9 @@ void __mnt_drop_write_file(struct file *file)
 	__mnt_drop_write(file->f_path.mnt);
 }
 
-void mnt_drop_write_file_path(struct file *file)
-{
-	mnt_drop_write(file->f_path.mnt);
-}
-
 void mnt_drop_write_file(struct file *file)
 {
-	__mnt_drop_write(file->f_path.mnt);
-	sb_end_write(file_inode(file)->i_sb);
+	mnt_drop_write(file->f_path.mnt);
 }
 EXPORT_SYMBOL(mnt_drop_write_file);
 
diff --git a/fs/open.c b/fs/open.c
index 1d4bc541c619..2db39216c393 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -707,12 +707,12 @@ int ksys_fchown(unsigned int fd, uid_t user, gid_t group)
 	if (!f.file)
 		goto out;
 
-	error = mnt_want_write_file_path(f.file);
+	error = mnt_want_write_file(f.file);
 	if (error)
 		goto out_fput;
 	audit_file(f.file);
 	error = chown_common(&f.file->f_path, user, group);
-	mnt_drop_write_file_path(f.file);
+	mnt_drop_write_file(f.file);
 out_fput:
 	fdput(f);
 out:
diff --git a/fs/xattr.c b/fs/xattr.c
index 61cd28ba25f3..78eaffbdbee0 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -23,7 +23,6 @@
 #include <linux/posix_acl_xattr.h>
 
 #include <linux/uaccess.h>
-#include "internal.h"
 
 static const char *
 strcmp_prefix(const char *a, const char *a_prefix)
@@ -503,10 +502,10 @@ SYSCALL_DEFINE5(fsetxattr, int, fd, const char __user *, name,
 	if (!f.file)
 		return error;
 	audit_file(f.file);
-	error = mnt_want_write_file_path(f.file);
+	error = mnt_want_write_file(f.file);
 	if (!error) {
 		error = setxattr(f.file->f_path.dentry, name, value, size, flags);
-		mnt_drop_write_file_path(f.file);
+		mnt_drop_write_file(f.file);
 	}
 	fdput(f);
 	return error;
@@ -735,10 +734,10 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 	if (!f.file)
 		return error;
 	audit_file(f.file);
-	error = mnt_want_write_file_path(f.file);
+	error = mnt_want_write_file(f.file);
 	if (!error) {
 		error = removexattr(f.file->f_path.dentry, name);
-		mnt_drop_write_file_path(f.file);
+		mnt_drop_write_file(f.file);
 	}
 	fdput(f);
 	return error;
-- 
2.14.3
