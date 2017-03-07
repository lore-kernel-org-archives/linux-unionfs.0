From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/9] overlay: fix inconsistency of ro file after copy-up
Date: Tue, 7 Mar 2017 17:26:43 +0100
Message-ID: <20170307162643.GC30961@veci.piliscsaba.szeredi.hu>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
 <20170219091430.GL29622@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170219091430.GL29622@ZenIV.linux.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Miklos Szeredi <mszeredi@redhat.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Sun, Feb 19, 2017 at 09:14:41AM +0000, Al Viro wrote:
> On Fri, Feb 17, 2017 at 05:09:29PM +0100, Miklos Szeredi wrote:
> > A file is opened for read-only, opened read-write (resulting in a copy up)
> > and modified.  The data read back from the the read-only fd will be stale
> > in this case (the read-only file descriptor still refers to the lower,
> > unmodified file).
> > 
> > This patchset fixes issues related to this corner case.  This is a
> > requirement from various parties for accepting overlayfs as a "POSIX"
> > filesystem.
> > 
> > When an operation (read, mmap, fsync) is done on an overlay fd opened
> > read-only that is referring to a lower file, check if it has been copied up
> > in the mean time.  If so, open the upper file and use that for the operation.
> > 
> > To make the performance impact minimal for non-overlay case, use a flag in
> > file->f_mode to indicate that this is an overlay file.
> 
> This is one hell of a DoS vector - it's really easy to eat tons of struct
> file that way.  Preparatory parts of that series make sense on their own,
> but your "let's allocate a struct file, call ->open() and schedule that
> struct file for closing upon the exit to userland on each kernel_read()"
> is not.

How about this?  Do you see a problem with calling __fput() synchronously here?

Thanks,
Miklos

---
 fs/Makefile                  |    2 -
 fs/file_table.c              |    2 -
 fs/internal.h                |    1 
 fs/overlay_util.c            |   53 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h           |   11 ++++++++
 include/linux/overlay_util.h |   13 ++++++++++
 6 files changed, 80 insertions(+), 2 deletions(-)

--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -31,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/delayed_call.h>
+#include <linux/overlay_util.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -1721,9 +1722,19 @@ struct inode_operations {
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
 } ____cacheline_aligned;
 
+
+static inline bool overlay_file_inconsistent(struct file *file)
+{
+	return unlikely(file->f_path.dentry->d_flags & DCACHE_OP_REAL) &&
+		unlikely(d_real_inode(file->f_path.dentry) != file_inode(file));
+}
+
 static inline ssize_t call_read_iter(struct file *file, struct kiocb *kio,
 				     struct iov_iter *iter)
 {
+	if (overlay_file_inconsistent(file))
+		return overlay_read_iter(file, kio, iter);
+
 	return file->f_op->read_iter(kio, iter);
 }
 
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o fs_pin.o nsfs.o
+		stack.o fs_struct.o statfs.o fs_pin.o nsfs.o overlay_util.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o block_dev.o direct-io.o mpage.o
--- /dev/null
+++ b/fs/overlay_util.c
@@ -0,0 +1,53 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/overlay_util.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include "internal.h"
+
+static struct file *overlay_clone_file(struct file *file)
+{
+	file = filp_clone_open(file);
+	if (!IS_ERR(file))
+		file->f_mode |= FMODE_NONOTIFY;
+
+	return file;
+}
+
+/*
+ * Do the release synchronously.  Otherwise we'd have a DoS problem when doing
+ * multiple reads (e.g. through kernel_read()) and only releasing the cloned
+ * files when returning to userspace.
+ *
+ * There's no risk of final dput or final mntput happening, since caller holds
+ * ref to both through the original file.
+ */
+static void overlay_put_cloned_file(struct file *file)
+{
+	if (WARN_ON(!atomic_long_dec_and_test(&file->f_count)))
+		return;
+
+	__fput(file);
+}
+
+ssize_t overlay_read_iter(struct file *file, struct kiocb *kio,
+			  struct iov_iter *iter)
+{
+	ssize_t ret;
+
+	file = overlay_clone_file(file);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	ret = vfs_iter_read(file, iter, &kio->ki_pos);
+	overlay_put_cloned_file(file);
+
+	return ret;
+}
+EXPORT_SYMBOL(overlay_read_iter);
--- /dev/null
+++ b/include/linux/overlay_util.h
@@ -0,0 +1,13 @@
+#ifndef _LINUX_OVERLAY_FS_H
+#define _LINUX_OVERLAY_FS_H
+
+#include <linux/types.h>
+
+struct file;
+struct kiocb;
+struct iov_iter;
+
+extern ssize_t overlay_read_iter(struct file *file, struct kiocb *kio,
+				 struct iov_iter *iter);
+
+#endif /* _LINUX_OVERLAY_FS_H */
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -184,7 +184,7 @@ EXPORT_SYMBOL(alloc_file);
 
 /* the real guts of fput() - releasing the last reference to file
  */
-static void __fput(struct file *file)
+void __fput(struct file *file)
 {
 	struct dentry *dentry = file->f_path.dentry;
 	struct vfsmount *mnt = file->f_path.mnt;
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -83,6 +83,7 @@ extern void chroot_fs_refs(const struct
  * file_table.c
  */
 extern struct file *get_empty_filp(void);
+extern void __fput(struct file *);
 
 /*
  * super.c
