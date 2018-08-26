Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/6] vfs: add helper to get "real" overlayfs file
Date: Sun, 26 Aug 2018 19:25:12 +0300
Message-Id: <1535300717-26686-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
References: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

We recently got rid of most VFS "hacks" that made VFS be aware of
overlayfs real underlying dentries. Due to collateral damage of
removing these hacks, we now need to make VFS be aware of overlayfs
real underlying files. Hopefully, the end result will be fewer places
where VFS is aware of overlayfs quirks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c |  1 +
 include/linux/fs.h  | 27 +++++++++++++++++++++++++++
 2 files changed, 28 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 32e9282893c9..24c9e0d70c3b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -135,6 +135,7 @@ static int ovl_open(struct inode *inode, struct file *file)
 	file->f_mapping = realfile->f_mapping;
 
 	file->private_data = realfile;
+	file->f_mode |= FMODE_STACKED;
 
 	return 0;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 33322702c910..51c5d167498f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -161,6 +161,12 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 
 /* File does not contribute to nr_files count */
 #define FMODE_NOACCOUNT	((__force fmode_t)0x20000000)
+/*
+ * File is stacked over a "real" file that is used for the actual io
+ * operations. This is set by overlayfs and tested by file_real() in VFS code.
+ * Not every "stacked" filesystem needs to set this flag.
+ */
+#define FMODE_STACKED	((__force fmode_t)0x40000000)
 
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
@@ -2450,6 +2456,27 @@ static inline struct file *file_clone_open(struct file *file)
 }
 extern int filp_close(struct file *, fl_owner_t id);
 
+/**
+ * file_real - Return the real file of a stacked file
+ * @file: The file to query
+ *
+ * If @file is on a union/overlay, then return the underlying, real file.
+ * Otherwise return @file.
+ */
+static inline struct file *file_real(struct file *file)
+{
+	/*
+	 * XXX: Instead of pretending we have a variaty of stacked filesystems
+	 * and implement a f_op->real() operation, just open code the simple
+	 * overlayfs implementation and if we ever need something more fancy,
+	 * we can add the f_op->real() then.
+	 */
+	if (unlikely(file->f_mode & FMODE_STACKED))
+		return (struct file *)file->private_data;
+	else
+		return file;
+}
+
 extern struct filename *getname_flags(const char __user *, int, int *);
 extern struct filename *getname(const char __user *);
 extern struct filename *getname_kernel(const char *);
-- 
2.7.4
