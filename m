From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4/9] vfs: intercept reads to overlay files
Date: Fri, 17 Feb 2017 17:09:33 +0100
Message-ID: <1487347778-18596-5-git-send-email-mszeredi@redhat.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

...in order to handle the corner case when the file is copyied up after
being opened read-only.

Can be verified with the following script:

 - 8< - - - - - 8< - - - - - 8< - - - - - 8< - - - -
cd /
rm -rf /tmp/ovl-rorw-test
mkdir /tmp/ovl-rorw-test
cd /tmp/ovl-rorw-test
mkdir -p mnt lower upper work
echo baba > lower/foo
mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work mnt
exec 3< mnt/foo
echo bubu > mnt/foo
cat <&3
exec 3>&-
umount mnt
 - 8< - - - - - 8< - - - - - 8< - - - - - 8< - - - -

Correct output is "bubu", incorrect output is "baba".

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/Makefile                  |  2 +-
 fs/open.c                    |  2 ++
 fs/overlay_util.c            | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h           | 13 +++++++++++++
 include/linux/overlay_util.h | 13 +++++++++++++
 5 files changed, 68 insertions(+), 1 deletion(-)
 create mode 100644 fs/overlay_util.c
 create mode 100644 include/linux/overlay_util.h

diff --git a/fs/Makefile b/fs/Makefile
index 7bbaca9c67b1..8c8f197d7c75 100644
--- a/fs/Makefile
+++ b/fs/Makefile
@@ -11,7 +11,7 @@ obj-y :=	open.o read_write.o file_table.o super.o \
 		attr.o bad_inode.o file.o filesystems.o namespace.o \
 		seq_file.o xattr.o libfs.o fs-writeback.o \
 		pnode.o splice.o sync.o utimes.o \
-		stack.o fs_struct.o statfs.o fs_pin.o nsfs.o
+		stack.o fs_struct.o statfs.o fs_pin.o nsfs.o overlay_util.o
 
 ifeq ($(CONFIG_BLOCK),y)
 obj-y +=	buffer.o block_dev.o direct-io.o mpage.o
diff --git a/fs/open.c b/fs/open.c
index 9921f70bc5ca..4916ccff29f5 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -762,6 +762,8 @@ static int do_dentry_open(struct file *f,
 	if ((f->f_mode & FMODE_WRITE) &&
 	     likely(f->f_op->write || f->f_op->write_iter))
 		f->f_mode |= FMODE_CAN_WRITE;
+	if (unlikely(d_inode(f->f_path.dentry) != inode))
+		f->f_mode |= FMODE_OVERLAY;
 
 	f->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
 
diff --git a/fs/overlay_util.c b/fs/overlay_util.c
new file mode 100644
index 000000000000..0daff19bad0b
--- /dev/null
+++ b/fs/overlay_util.c
@@ -0,0 +1,39 @@
+/*
+ * Copyright (C) 2017 Red Hat, Inc.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+#if IS_ENABLED(CONFIG_OVERLAY_FS)
+
+#include <linux/overlay_util.h>
+#include <linux/fs.h>
+#include <linux/file.h>
+#include "internal.h"
+
+static bool overlay_file_consistent(struct file *file)
+{
+	return d_real_inode(file->f_path.dentry) == file_inode(file);
+}
+
+ssize_t overlay_read_iter(struct file *file, struct kiocb *kio,
+			  struct iov_iter *iter)
+{
+	ssize_t ret;
+
+	if (likely(overlay_file_consistent(file)))
+		return file->f_op->read_iter(kio, iter);
+
+	file = filp_clone_open(file);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	ret = vfs_iter_read(file, iter, &kio->ki_pos);
+	fput(file);
+
+	return ret;
+}
+EXPORT_SYMBOL(overlay_read_iter);
+
+#endif /* IS_ENABLED(CONFIG_OVERLAY_FS) */
diff --git a/include/linux/fs.h b/include/linux/fs.h
index efdaad954b70..d186d5390e99 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -31,6 +31,7 @@
 #include <linux/workqueue.h>
 #include <linux/percpu-rwsem.h>
 #include <linux/delayed_call.h>
+#include <linux/overlay_util.h>
 
 #include <asm/byteorder.h>
 #include <uapi/linux/fs.h>
@@ -143,6 +144,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File was opened by fanotify and shouldn't generate fanotify events */
 #define FMODE_NONOTIFY		((__force fmode_t)0x4000000)
 
+/* File comes from overlay filesystem */
+#define FMODE_OVERLAY		((__force fmode_t)0x8000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
@@ -1712,9 +1716,18 @@ struct inode_operations {
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
 } ____cacheline_aligned;
 
+
+static inline bool is_overlay_file(struct file *file)
+{
+	return IS_ENABLED(CONFIG_OVERLAY_FS) && file->f_mode & FMODE_OVERLAY;
+}
+
 static inline ssize_t call_read_iter(struct file *file, struct kiocb *kio,
 				     struct iov_iter *iter)
 {
+	if (unlikely(is_overlay_file(file)))
+		return overlay_read_iter(file, kio, iter);
+
 	return file->f_op->read_iter(kio, iter);
 }
 
diff --git a/include/linux/overlay_util.h b/include/linux/overlay_util.h
new file mode 100644
index 000000000000..886be9003bf3
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
-- 
2.5.5
