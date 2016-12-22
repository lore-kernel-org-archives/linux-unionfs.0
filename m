From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 1/4] vfs: add RENAME_VFS_DTYPE vfs_rename() flag
Date: Thu, 22 Dec 2016 19:25:32 +0200
Message-ID: <1482427535-12801-2-git-send-email-amir73il@gmail.com>
References: <1482427535-12801-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35165 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S941680AbcLVRZ5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 22 Dec 2016 12:25:57 -0500
Received: by mail-wm0-f66.google.com with SMTP id l2so11814077wml.2
        for <linux-unionfs@vger.kernel.org>; Thu, 22 Dec 2016 09:25:56 -0800 (PST)
In-Reply-To: <1482427535-12801-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Add support for extra rename flags that can be passed to
vfs_rename() from kernel code.

Define a new internal vfs flag RENAME_VFS_DTYPE.
This flag indicates that caller would like fs to set the dtype
of the target entry to a specified value.  The dtype value to use
is specified on the S_IFMT mask bits (12..15) of the rename flags.

For example, code can call vfs_rename(..., RENAME_DT_WHT) to set
the target dir entry type to DT_WHT, regardless of the value
of inode->i_mode.

File systems that supports the new RENAME_VFS_DTYPE flag would
check for (flags & RENAME_VFS_DTYPE) and use RENAME_DT_MODE(flags)
instead of inode->i_mode to determine the value of dtype to store
in the directory entry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 include/linux/fs.h      | 30 ++++++++++++++++++++++++++++++
 include/uapi/linux/fs.h |  4 ++++
 2 files changed, 34 insertions(+)

diff --git a/include/linux/fs.h b/include/linux/fs.h
index 8f1580d..82ce8ca 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1559,6 +1559,36 @@ extern int vfs_symlink(struct inode *, struct dentry *, const char *);
 extern int vfs_link(struct dentry *, struct inode *, struct dentry *, struct inode **);
 extern int vfs_rmdir(struct inode *, struct dentry *);
 extern int vfs_unlink(struct inode *, struct dentry *, struct inode **);
+
+/* vfs_rename() extra flags */
+#define RENAME_VFS_FLAG(i)	(1 << (RENAME_UAPI_BITS + (i)))
+#define RENAME_VFS_DTYPE	RENAME_VFS_FLAG(0)	/* Set dest dtype */
+
+#define RENAME_VFS_FLAG_BITS	1
+
+#define RENAME_FLAGS_BITS	(RENAME_UAPI_BITS + RENAME_VFS_FLAG_BITS)
+#define RENAME_FLAGS_MASK	((1 << RENAME_FLAGS_BITS) - 1)
+
+/*
+ * S_IFMT bits (12..15) carry the dtype value to set for RENAME_VFS_DTYPE.
+ *
+ * For example, code can call vfs_rename(..., RENAME_DT_WHT) to set the
+ * target dir entry type to DT_WHT, regardless of inode->i_mode.
+ * file systems that supports the new RENAME_VFS_DTYPE flag, would check
+ * for (flags & RENAME_VFS_DTYPE) and use RENAME_DT_MODE(flags) instead
+ * of inode->i_mode to determine the dtype to store in the directory entry.
+ */
+#define RENAME_DT_BITS		4
+#define RENAME_DT_SHIFT		12
+#define RENAME_DT_MASK		S_IFMT
+#define RENAME_DT(dt)		(((dt) << RENAME_DT_SHIFT) | RENAME_VFS_DTYPE)
+#define RENAME_DT_UNKNOWN	RENAME_DT(DT_UNKNOWN)
+#define RENAME_DT_WHT		RENAME_DT(DT_WHT)
+/* mode to use instead of i_mode when setting dtype */
+#define RENAME_DT_MODE(f)	((f) & RENAME_DT_MASK)
+
+#define RENAME_VFS_MASK		(RENAME_FLAGS_MASK | RENAME_DT_MASK)
+
 extern int vfs_rename(struct inode *, struct dentry *, struct inode *, struct dentry *, struct inode **, unsigned int);
 extern int vfs_whiteout(struct inode *, struct dentry *);
 
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 36da93f..11f0c6b 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -38,10 +38,14 @@
 #define SEEK_HOLE	4	/* seek to the next hole */
 #define SEEK_MAX	SEEK_HOLE
 
+/* renameat2(2) user api flags */
 #define RENAME_NOREPLACE	(1 << 0)	/* Don't overwrite target */
 #define RENAME_EXCHANGE		(1 << 1)	/* Exchange source and dest */
 #define RENAME_WHITEOUT		(1 << 2)	/* Whiteout source */
 
+#define RENAME_UAPI_BITS	3
+#define RENAME_UAPI_MASK	((1 << RENAME_UAPI_BITS) - 1)
+
 struct file_clone_range {
 	__s64 src_fd;
 	__u64 src_offset;
-- 
2.7.4
