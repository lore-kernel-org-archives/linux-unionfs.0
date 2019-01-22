Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH v2 3/5] ovl: lazy copy up of data on first data access
Date: Tue, 22 Jan 2019 14:34:55 +0200
Message-Id: <20190122123457.10600-4-amir73il@gmail.com>
In-Reply-To: <20190122123457.10600-1-amir73il@gmail.com>
References: <20190122123457.10600-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

When metacopy feature is enabled and filemap operations supported,
copy up only metadata when opening a file O_RDWR and defer copy up
of data until the first data access file operation.

Copy up on first page fault will be handled by a followup patch.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  5 +---
 fs/overlayfs/file.c      | 63 +++++++++++++++++++++++++++++++++++-----
 fs/overlayfs/overlayfs.h | 10 ++++++-
 fs/overlayfs/util.c      |  4 +--
 4 files changed, 68 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 05f853c7db0d..92a27ba65c78 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -731,10 +731,7 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 	if (!S_ISREG(mode))
 		return false;
 
-	if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
-		return false;
-
-	return true;
+	return !ovl_open_flags_need_data_copy_up(flags);
 }
 
 /* Copy up data of an inode which was copied up metadata only in the past. */
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 5f648979adbf..e02b61af9488 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -90,10 +90,24 @@ static int ovl_real_fdget_meta(const struct file *file, struct fd *real,
 {
 	struct inode *inode = file_inode(file);
 	struct inode *realinode;
+	int err;
 
 	real->flags = 0;
 	real->file = file->private_data;
 
+	/*
+	 * Lazy copy up caches the meta copy upper file on open O_RDWR.
+	 * We need to promote upper inode to full data copy up before
+	 * we allow access to real file data on a writable file, otherwise
+	 * we may try to open a lower file O_RDWR or perform data operations
+	 * (e.g. fallocate) on the metacopy inode.
+	 */
+	if (!allow_meta) {
+		err = ovl_maybe_copy_up(file_dentry(file), file->f_flags);
+		if (err)
+			return err;
+	}
+
 	if (allow_meta)
 		realinode = ovl_inode_real(inode);
 	else
@@ -127,11 +141,34 @@ static bool ovl_filemap_support(struct file *file)
 	return ofs->upper_mnt && ovl_aops.writepage;
 }
 
-static bool ovl_should_use_filemap(struct file *file)
+static bool ovl_should_use_filemap_meta(struct file *file, bool meta_only)
 {
+	int err;
+
 	if (!ovl_filemap_support(file))
 		return false;
 
+	/*
+	 * If file was opened O_RDWR with lazy copy up of data, the first
+	 * data access file operation will trigger data copy up. If file was
+	 * opened O_RDWR and @meta_only is true, we use overlay inode filemap
+	 * operations, but defer data copy up further.
+	 *
+	 * For example, mmap() and fsync() are metadata only operations that
+	 * do not trigger lazy copy up of data, but read() (on a file open for
+	 * write) is a data access operation that does trigger data copy up.
+	 */
+	if (!meta_only) {
+		err = ovl_maybe_copy_up(file_dentry(file), file->f_flags);
+		if (err) {
+			pr_warn_ratelimited("overlayfs: failed lazy copy up data (%pd2, err=%i)\n",
+					    file_dentry(file), err);
+			return false;
+		}
+	} else if (file->f_mode & FMODE_WRITE) {
+		return true;
+	}
+
 	/*
 	 * Use overlay inode page cache for all inodes that could be dirty,
 	 * including pure upper inodes, so ovl_sync_fs() can sync all dirty
@@ -140,9 +177,14 @@ static bool ovl_should_use_filemap(struct file *file)
 	return ovl_has_upperdata(file_inode(file));
 }
 
+static bool ovl_should_use_filemap(struct file *file)
+{
+	return ovl_should_use_filemap_meta(file, false);
+}
+
 static int ovl_flush_filemap(struct file *file, loff_t offset, loff_t len)
 {
-	if (!ovl_should_use_filemap(file))
+	if (!ovl_should_use_filemap_meta(file, true))
 		return 0;
 
 	return filemap_write_and_wait_range(file_inode(file)->i_mapping,
@@ -152,16 +194,23 @@ static int ovl_flush_filemap(struct file *file, loff_t offset, loff_t len)
 static int ovl_open(struct inode *inode, struct file *file)
 {
 	struct file *realfile;
+	int metacopy = 0;
 	int err;
 
-	err = ovl_maybe_copy_up(file_dentry(file), file->f_flags);
+	/* (O_RDWR | O_WRONLY) signals that we want meta copy up */
+	if (ovl_filemap_support(file) && (file->f_flags & O_ACCMODE) == O_RDWR)
+		metacopy = (O_RDWR | O_WRONLY);
+
+	/* Allow to copy up meta and defer copy up data to first data access */
+	err = ovl_maybe_copy_up(file_dentry(file), file->f_flags | metacopy);
 	if (err)
 		return err;
 
 	/* No longer need these flags, so don't pass them on to underlying fs */
 	file->f_flags &= ~(O_CREAT | O_EXCL | O_NOCTTY | O_TRUNC);
 
-	realfile = ovl_open_realfile(file, ovl_inode_realdata(inode));
+	realfile = ovl_open_realfile(file, metacopy ? ovl_inode_real(inode) :
+				     ovl_inode_realdata(inode));
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
@@ -337,7 +386,7 @@ static int ovl_real_fsync(struct file *file, loff_t start, loff_t end,
 
 static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
-	if (ovl_should_use_filemap(file))
+	if (ovl_should_use_filemap_meta(file, true))
 		return __generic_file_fsync(file, start, end, datasync);
 
 	return ovl_real_fsync(file, start, end, datasync);
@@ -381,7 +430,7 @@ static int ovl_real_mmap(struct file *file, struct vm_area_struct *vma)
 
 static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if (ovl_should_use_filemap(file))
+	if (ovl_should_use_filemap_meta(file, true))
 		generic_file_mmap(file, vma);
 
 	return ovl_real_mmap(file, vma);
@@ -441,7 +490,7 @@ extern int generic_fadvise(struct file *file, loff_t offset, loff_t len,
 
 static int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
 {
-	if (ovl_should_use_filemap(file))
+	if (ovl_should_use_filemap_meta(file, true))
 		return generic_fadvise(file, offset, len, advice);
 
 	/* XXX: Should we allow messing with lower shared page cache? */
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index ab61c07e8583..6baa3460c173 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -195,14 +195,22 @@ static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
 	return ret;
 }
 
-static inline bool ovl_open_flags_need_copy_up(int flags)
+static inline bool ovl_open_flags_need_data_copy_up(int flags)
 {
 	if (!flags)
 		return false;
 
+	/* Either O_RDWR or O_WRONLY will trigger data copy up */
 	return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
 }
 
+static inline bool ovl_open_flags_need_copy_up(int flags)
+{
+	/* O_RDWR|O_WRONLY together will trigger meta copy up */
+	return (flags & O_ACCMODE) == (O_RDWR | O_WRONLY) ||
+		ovl_open_flags_need_data_copy_up(flags);
+}
+
 /* util.c */
 int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7c01327b1852..df6d13185f40 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -367,7 +367,7 @@ void ovl_set_upperdata(struct inode *inode)
 /* Caller should hold ovl_inode->lock */
 bool ovl_dentry_needs_data_copy_up_locked(struct dentry *dentry, int flags)
 {
-	if (!ovl_open_flags_need_copy_up(flags))
+	if (!ovl_open_flags_need_data_copy_up(flags))
 		return false;
 
 	return !ovl_test_flag(OVL_UPPERDATA, d_inode(dentry));
@@ -375,7 +375,7 @@ bool ovl_dentry_needs_data_copy_up_locked(struct dentry *dentry, int flags)
 
 bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags)
 {
-	if (!ovl_open_flags_need_copy_up(flags))
+	if (!ovl_open_flags_need_data_copy_up(flags))
 		return false;
 
 	return !ovl_has_upperdata(d_inode(dentry));
-- 
2.17.1
