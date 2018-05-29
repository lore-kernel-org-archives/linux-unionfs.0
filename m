From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 05/39] vfs: optionally don't account file in nr_files
Date: Tue, 29 May 2018 16:43:05 +0200
Message-ID: <20180529144339.16538-6-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Stacking file operations in overlay will store an extra open file for each
overlay file opened.

The overhead is just that of "struct file" which is about 256bytes, because
overlay already pins an extra dentry and inode when the file is open, which
add up to a much larger overhead.

For fear of breaking working setups, don't start accounting the extra file.

The implementation adds a bool argument to path_open() to control whether
the returned file is to be accounted or not.  If the file is not accounted,
f_mode will contain FMODE_NOACCOUNT, so that when freeing the file the
count is not decremented.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/file_table.c    | 13 +++++++++----
 fs/internal.h      |  7 ++++++-
 fs/open.c          | 10 +++++-----
 include/linux/fs.h |  5 ++++-
 4 files changed, 24 insertions(+), 11 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 7ec0b3e5f05d..60376bfa04cf 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -51,7 +51,8 @@ static void file_free_rcu(struct rcu_head *head)
 
 static inline void file_free(struct file *f)
 {
-	percpu_counter_dec(&nr_files);
+	if (!(f->f_mode & FMODE_NOACCOUNT))
+		percpu_counter_dec(&nr_files);
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
 }
 
@@ -100,7 +101,7 @@ int proc_nr_files(struct ctl_table *table, int write,
  * done, you will imbalance int the mount's writer count
  * and a warning at __fput() time.
  */
-struct file *get_empty_filp(void)
+struct file *__get_empty_filp(bool account)
 {
 	const struct cred *cred = current_cred();
 	static long old_max;
@@ -110,7 +111,8 @@ struct file *get_empty_filp(void)
 	/*
 	 * Privileged users can go above max_files
 	 */
-	if (get_nr_files() >= files_stat.max_files && !capable(CAP_SYS_ADMIN)) {
+	if (account &&
+	    get_nr_files() >= files_stat.max_files && !capable(CAP_SYS_ADMIN)) {
 		/*
 		 * percpu_counters are inaccurate.  Do an expensive check before
 		 * we go and fail.
@@ -123,7 +125,10 @@ struct file *get_empty_filp(void)
 	if (unlikely(!f))
 		return ERR_PTR(-ENOMEM);
 
-	percpu_counter_inc(&nr_files);
+	if (account)
+		percpu_counter_inc(&nr_files);
+	else
+		f->f_mode = FMODE_NOACCOUNT;
 	f->f_cred = get_cred(cred);
 	error = security_file_alloc(f);
 	if (unlikely(error)) {
diff --git a/fs/internal.h b/fs/internal.h
index e08972db0303..b82725ba3054 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -93,7 +93,12 @@ extern void chroot_fs_refs(const struct path *, const struct path *);
 /*
  * file_table.c
  */
-extern struct file *get_empty_filp(void);
+extern struct file *__get_empty_filp(bool account);
+
+static inline struct file *get_empty_filp(void)
+{
+	return __get_empty_filp(true);
+}
 
 /*
  * super.c
diff --git a/fs/open.c b/fs/open.c
index d0bf7f061a1a..6e52fd6fea7c 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -732,8 +732,8 @@ static int do_dentry_open(struct file *f,
 	static const struct file_operations empty_fops = {};
 	int error;
 
-	f->f_mode = OPEN_FMODE(f->f_flags) | FMODE_LSEEK |
-				FMODE_PREAD | FMODE_PWRITE;
+	f->f_mode = (f->f_mode & FMODE_NOACCOUNT) | OPEN_FMODE(f->f_flags) |
+		FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
 
 	path_get(&f->f_path);
 	f->f_inode = inode;
@@ -743,7 +743,7 @@ static int do_dentry_open(struct file *f,
 	f->f_wb_err = filemap_sample_wb_err(f->f_mapping);
 
 	if (unlikely(f->f_flags & O_PATH)) {
-		f->f_mode = FMODE_PATH;
+		f->f_mode = (f->f_mode & FMODE_NOACCOUNT) | FMODE_PATH;
 		f->f_op = &empty_fops;
 		goto done;
 	}
@@ -917,12 +917,12 @@ int vfs_open(const struct path *path, struct file *file,
  * Return: A pointer to a struct file or an IS_ERR pointer.  Cannot return NULL.
  */
 struct file *path_open(const struct path *path, int flags, struct inode *inode,
-		       const struct cred *cred)
+		       const struct cred *cred, bool account)
 {
 	struct file *file;
 	int retval;
 
-	file = get_empty_filp();
+	file = __get_empty_filp(account);
 	if (IS_ERR(file))
 		return file;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 9473e68280d0..ecc854c75611 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -153,6 +153,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File is capable of returning -EAGAIN if I/O will block */
 #define FMODE_NOWAIT	((__force fmode_t)0x8000000)
 
+/* File does not contribute to nr_files count */
+#define FMODE_NOACCOUNT	((__force fmode_t)0x10000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
@@ -2402,7 +2405,7 @@ extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int, umode_t);
 extern struct file * dentry_open(const struct path *, int, const struct cred *);
 extern struct file *path_open(const struct path *, int, struct inode *,
-			      const struct cred *);
+			      const struct cred *, bool);
 extern int filp_close(struct file *, fl_owner_t id);
 
 extern struct filename *getname_flags(const char __user *, int, int *);
-- 
2.14.3
