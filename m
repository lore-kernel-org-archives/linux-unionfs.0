Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 4/6] vfs: add the fadvise() file operation
Date: Mon, 27 Aug 2018 15:56:02 +0300
Message-Id: <1535374564-8257-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
References: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This is going to be used by overlayfs and possibly useful
for other filesystems.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/vfs.txt |  3 ++
 include/linux/fs.h                |  5 +++
 mm/fadvise.c                      | 78 ++++++++++++++++++++++-----------------
 3 files changed, 53 insertions(+), 33 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index e0ace944a0e1..4868fa9c0758 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -885,6 +885,7 @@ struct file_operations {
 	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
 	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
 	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
+	int (*fadvise)(struct file *, loff_t, loff_t, int);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -965,6 +966,8 @@ otherwise noted.
   dedupe_file_range: called by the ioctl(2) system call for FIDEDUPERANGE
 	command.
 
+  fadvise: possibly called by the fadvise64() system call.
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides. When opening a device node
 (character or block special) most filesystems will call special
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 33322702c910..6c0b4a1c22ff 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1763,6 +1763,7 @@ struct file_operations {
 			u64);
 	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t,
 			u64);
+	int (*fadvise)(struct file *, loff_t, loff_t, int);
 } __randomize_layout;
 
 struct inode_operations {
@@ -3459,4 +3460,8 @@ static inline bool dir_relax_shared(struct inode *inode)
 extern bool path_noexec(const struct path *path);
 extern void inode_nohighmem(struct inode *inode);
 
+/* mm/fadvise.c */
+extern int vfs_fadvise(struct file *file, loff_t offset, loff_t len,
+		       int advice);
+
 #endif /* _LINUX_FS_H */
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 2d8376e3c640..2f59bac1cb77 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -27,9 +27,9 @@
  * deactivate the pages and clear PG_Referenced.
  */
 
-int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
+static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
+			   int advice)
 {
-	struct fd f = fdget(fd);
 	struct inode *inode;
 	struct address_space *mapping;
 	struct backing_dev_info *bdi;
@@ -37,22 +37,14 @@ int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
 	pgoff_t start_index;
 	pgoff_t end_index;
 	unsigned long nrpages;
-	int ret = 0;
 
-	if (!f.file)
-		return -EBADF;
+	inode = file_inode(file);
+	if (S_ISFIFO(inode->i_mode))
+		return -ESPIPE;
 
-	inode = file_inode(f.file);
-	if (S_ISFIFO(inode->i_mode)) {
-		ret = -ESPIPE;
-		goto out;
-	}
-
-	mapping = f.file->f_mapping;
-	if (!mapping || len < 0) {
-		ret = -EINVAL;
-		goto out;
-	}
+	mapping = file->f_mapping;
+	if (!mapping || len < 0)
+		return -EINVAL;
 
 	bdi = inode_to_bdi(mapping->host);
 
@@ -67,9 +59,9 @@ int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
 			/* no bad return value, but ignore advice */
 			break;
 		default:
-			ret = -EINVAL;
+			return -EINVAL;
 		}
-		goto out;
+		return 0;
 	}
 
 	/*
@@ -85,21 +77,21 @@ int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
 
 	switch (advice) {
 	case POSIX_FADV_NORMAL:
-		f.file->f_ra.ra_pages = bdi->ra_pages;
-		spin_lock(&f.file->f_lock);
-		f.file->f_mode &= ~FMODE_RANDOM;
-		spin_unlock(&f.file->f_lock);
+		file->f_ra.ra_pages = bdi->ra_pages;
+		spin_lock(&file->f_lock);
+		file->f_mode &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_RANDOM:
-		spin_lock(&f.file->f_lock);
-		f.file->f_mode |= FMODE_RANDOM;
-		spin_unlock(&f.file->f_lock);
+		spin_lock(&file->f_lock);
+		file->f_mode |= FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_SEQUENTIAL:
-		f.file->f_ra.ra_pages = bdi->ra_pages * 2;
-		spin_lock(&f.file->f_lock);
-		f.file->f_mode &= ~FMODE_RANDOM;
-		spin_unlock(&f.file->f_lock);
+		file->f_ra.ra_pages = bdi->ra_pages * 2;
+		spin_lock(&file->f_lock);
+		file->f_mode &= ~FMODE_RANDOM;
+		spin_unlock(&file->f_lock);
 		break;
 	case POSIX_FADV_WILLNEED:
 		/* First and last PARTIAL page! */
@@ -115,8 +107,7 @@ int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
 		 * Ignore return value because fadvise() shall return
 		 * success even if filesystem can't retrieve a hint,
 		 */
-		force_page_cache_readahead(mapping, f.file, start_index,
-					   nrpages);
+		force_page_cache_readahead(mapping, file, start_index, nrpages);
 		break;
 	case POSIX_FADV_NOREUSE:
 		break;
@@ -183,9 +174,30 @@ int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
 		}
 		break;
 	default:
-		ret = -EINVAL;
+		return -EINVAL;
 	}
-out:
+	return 0;
+}
+
+int vfs_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
+{
+	if (file->f_op->fadvise)
+		return file->f_op->fadvise(file, offset, len, advice);
+
+	return generic_fadvise(file, offset, len, advice);
+}
+EXPORT_SYMBOL(vfs_fadvise);
+
+int ksys_fadvise64_64(int fd, loff_t offset, loff_t len, int advice)
+{
+	struct fd f = fdget(fd);
+	int ret;
+
+	if (!f.file)
+		return -EBADF;
+
+	ret = vfs_fadvise(f.file, offset, len, advice);
+
 	fdput(f);
 	return ret;
 }
-- 
2.7.4
