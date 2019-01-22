Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH v2 2/5] ovl: prepare for generic filemap file operations
Date: Tue, 22 Jan 2019 14:34:54 +0200
Message-Id: <20190122123457.10600-3-amir73il@gmail.com>
In-Reply-To: <20190122123457.10600-1-amir73il@gmail.com>
References: <20190122123457.10600-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Implement a variant of overlay file operations using generic
filemap helpers.  This implementation will be enabled for copied up
files after overlay address space operations are implemented.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c      | 118 +++++++++++++++++++++++++++++++++++++--
 fs/overlayfs/inode.c     |   5 --
 fs/overlayfs/overlayfs.h |   1 +
 mm/fadvise.c             |   4 +-
 4 files changed, 115 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 50e4407398d8..5f648979adbf 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -11,6 +11,11 @@
 #include <linux/mount.h>
 #include <linux/xattr.h>
 #include <linux/uio.h>
+#include <linux/mm.h>
+#include <linux/iomap.h>
+#include <linux/pagemap.h>
+#include <linux/writeback.h>
+#include <linux/ratelimit.h>
 #include "overlayfs.h"
 
 static char ovl_whatisit(struct inode *inode, struct inode *realinode)
@@ -114,6 +119,36 @@ static int ovl_real_fdget(const struct file *file, struct fd *real)
 	return ovl_real_fdget_meta(file, real, false);
 }
 
+static bool ovl_filemap_support(struct file *file)
+{
+	struct ovl_fs *ofs = file_inode(file)->i_sb->s_fs_info;
+
+	/* TODO: implement aops to upper inode data */
+	return ofs->upper_mnt && ovl_aops.writepage;
+}
+
+static bool ovl_should_use_filemap(struct file *file)
+{
+	if (!ovl_filemap_support(file))
+		return false;
+
+	/*
+	 * Use overlay inode page cache for all inodes that could be dirty,
+	 * including pure upper inodes, so ovl_sync_fs() can sync all dirty
+	 * overlay inodes without having to sync all upper fs dirty inodes.
+	 */
+	return ovl_has_upperdata(file_inode(file));
+}
+
+static int ovl_flush_filemap(struct file *file, loff_t offset, loff_t len)
+{
+	if (!ovl_should_use_filemap(file))
+		return 0;
+
+	return filemap_write_and_wait_range(file_inode(file)->i_mapping,
+					    offset, len);
+}
+
 static int ovl_open(struct inode *inode, struct file *file)
 {
 	struct file *realfile;
@@ -190,7 +225,7 @@ static rwf_t ovl_iocb_to_rwf(struct kiocb *iocb)
 	return flags;
 }
 
-static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+static ssize_t ovl_real_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct fd real;
@@ -216,7 +251,17 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	return ret;
 }
 
-static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
+static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+
+	if (ovl_should_use_filemap(file))
+		return generic_file_read_iter(iocb, iter);
+
+	return ovl_real_read_iter(iocb, iter);
+}
+
+static ssize_t ovl_real_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 {
 	struct file *file = iocb->ki_filp;
 	struct inode *inode = file_inode(file);
@@ -256,7 +301,19 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	return ret;
 }
 
-static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+
+	if (ovl_should_use_filemap(file))
+		return generic_file_write_iter(iocb, iter);
+
+	return ovl_real_write_iter(iocb, iter);
+}
+
+
+static int ovl_real_fsync(struct file *file, loff_t start, loff_t end,
+			  int datasync)
 {
 	struct fd real;
 	const struct cred *old_cred;
@@ -278,7 +335,20 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return ret;
 }
 
-static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
+static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	if (ovl_should_use_filemap(file))
+		return __generic_file_fsync(file, start, end, datasync);
+
+	return ovl_real_fsync(file, start, end, datasync);
+}
+
+const struct address_space_operations ovl_aops = {
+	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
+	.direct_IO		= noop_direct_IO,
+};
+
+static int ovl_real_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct file *realfile = file->private_data;
 	const struct cred *old_cred;
@@ -309,13 +379,27 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 	return ret;
 }
 
-static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
+static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	if (ovl_should_use_filemap(file))
+		generic_file_mmap(file, vma);
+
+	return ovl_real_mmap(file, vma);
+}
+
+static long ovl_fallocate(struct file *file, int mode, loff_t offset,
+			  loff_t len)
 {
 	struct inode *inode = file_inode(file);
 	struct fd real;
 	const struct cred *old_cred;
 	int ret;
 
+	/* XXX: Different modes need to flush different ranges... */
+	ret = ovl_flush_filemap(file, 0, LLONG_MAX);
+	if (ret)
+		return ret;
+
 	ret = ovl_real_fdget(file, &real);
 	if (ret)
 		return ret;
@@ -332,7 +416,8 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 	return ret;
 }
 
-static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
+static int ovl_real_fadvise(struct file *file, loff_t offset, loff_t len,
+			    int advice)
 {
 	struct fd real;
 	const struct cred *old_cred;
@@ -351,6 +436,18 @@ static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 	return ret;
 }
 
+extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
+			   int advice);
+
+static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
+{
+	if (ovl_should_use_filemap(file))
+		return generic_fadvise(file, offset, len, advice);
+
+	/* XXX: Should we allow messing with lower shared page cache? */
+	return ovl_real_fadvise(file, offset, len, advice);
+}
+
 static long ovl_real_ioctl(struct file *file, unsigned int cmd,
 			   unsigned long arg)
 {
@@ -442,6 +539,15 @@ static loff_t ovl_copyfile(struct file *file_in, loff_t pos_in,
 	const struct cred *old_cred;
 	loff_t ret;
 
+	/* XXX: For some ops zero length means EOF... */
+	ret = ovl_flush_filemap(file_out, pos_out, len ?: LLONG_MAX);
+	if (ret)
+		return ret;
+
+	ret = ovl_flush_filemap(file_in, pos_in, len ?: LLONG_MAX);
+	if (ret)
+		return ret;
+
 	ret = ovl_real_fdget(file_out, &real_out);
 	if (ret)
 		return ret;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3b7ed5d2279c..526ff8d503b0 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -504,11 +504,6 @@ static const struct inode_operations ovl_special_inode_operations = {
 	.update_time	= ovl_update_time,
 };
 
-static const struct address_space_operations ovl_aops = {
-	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
-	.direct_IO		= noop_direct_IO,
-};
-
 /*
  * It is possible to stack overlayfs instance on top of another
  * overlayfs instance as lower layer. We need to annonate the
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 767eeaf73bf1..ab61c07e8583 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -414,6 +414,7 @@ struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr);
 
 /* file.c */
 extern const struct file_operations ovl_file_operations;
+extern const struct address_space_operations ovl_aops;
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
diff --git a/mm/fadvise.c b/mm/fadvise.c
index 467bcd032037..4f17c83db575 100644
--- a/mm/fadvise.c
+++ b/mm/fadvise.c
@@ -27,8 +27,7 @@
  * deactivate the pages and clear PG_Referenced.
  */
 
-static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
-			   int advice)
+int generic_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 {
 	struct inode *inode;
 	struct address_space *mapping;
@@ -178,6 +177,7 @@ static int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 	}
 	return 0;
 }
+EXPORT_SYMBOL(generic_fadvise);
 
 int vfs_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 {
-- 
2.17.1
