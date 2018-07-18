From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH] vfs: make open_with_fake_path() not contribute to nr_files
Date: Wed, 18 Jul 2018 17:46:37 +0200
Message-ID: <20180718154637.31878-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Stacking file operations in overlay will store an extra open file for each
overlay file opened.

The overhead is just that of "struct file" which is about 256bytes, because
overlay already pins an extra dentry and inode when the file is open, which
add up to a much larger overhead.

For fear of breaking working setups, don't start accounting the extra file.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/file_table.c    | 69 +++++++++++++++++++++++++++++++++++++-----------------
 fs/internal.h      |  1 +
 fs/open.c          |  2 +-
 include/linux/fs.h |  3 +++
 4 files changed, 53 insertions(+), 22 deletions(-)

diff --git a/fs/file_table.c b/fs/file_table.c
index 9b70ed2bbc4e..0cc7bea6b51a 100644
--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -52,7 +52,8 @@ static void file_free_rcu(struct rcu_head *head)
 static inline void file_free(struct file *f)
 {
 	security_file_free(f);
-	percpu_counter_dec(&nr_files);
+	if (!(f->f_mode & FMODE_NOACCOUNT))
+		percpu_counter_dec(&nr_files);
 	call_rcu(&f->f_u.fu_rcuhead, file_free_rcu);
 }
 
@@ -91,6 +92,34 @@ int proc_nr_files(struct ctl_table *table, int write,
 }
 #endif
 
+static struct file *__alloc_file(int flags, const struct cred *cred)
+{
+	struct file *f;
+	int error;
+
+	f = kmem_cache_zalloc(filp_cachep, GFP_KERNEL);
+	if (unlikely(!f))
+		return ERR_PTR(-ENOMEM);
+
+	f->f_cred = get_cred(cred);
+	error = security_file_alloc(f);
+	if (unlikely(error)) {
+		file_free_rcu(&f->f_u.fu_rcuhead);
+		return ERR_PTR(error);
+	}
+
+	atomic_long_set(&f->f_count, 1);
+	rwlock_init(&f->f_owner.lock);
+	spin_lock_init(&f->f_lock);
+	mutex_init(&f->f_pos_lock);
+	eventpoll_init_file(f);
+	f->f_flags = flags;
+	f->f_mode = OPEN_FMODE(flags);
+	/* f->f_version: 0 */
+
+	return f;
+}
+
 /* Find an unused file structure and return a pointer to it.
  * Returns an error pointer if some error happend e.g. we over file
  * structures limit, run out of memory or operation is not permitted.
@@ -105,7 +134,6 @@ struct file *alloc_empty_file(int flags, const struct cred *cred)
 {
 	static long old_max;
 	struct file *f;
-	int error;
 
 	/*
 	 * Privileged users can go above max_files
@@ -119,26 +147,10 @@ struct file *alloc_empty_file(int flags, const struct cred *cred)
 			goto over;
 	}
 
-	f = kmem_cache_zalloc(filp_cachep, GFP_KERNEL);
-	if (unlikely(!f))
-		return ERR_PTR(-ENOMEM);
-
-	f->f_cred = get_cred(cred);
-	error = security_file_alloc(f);
-	if (unlikely(error)) {
-		file_free_rcu(&f->f_u.fu_rcuhead);
-		return ERR_PTR(error);
-	}
+	f = __alloc_file(flags, cred);
+	if (!IS_ERR(f))
+		percpu_counter_inc(&nr_files);
 
-	atomic_long_set(&f->f_count, 1);
-	rwlock_init(&f->f_owner.lock);
-	spin_lock_init(&f->f_lock);
-	mutex_init(&f->f_pos_lock);
-	eventpoll_init_file(f);
-	f->f_flags = flags;
-	f->f_mode = OPEN_FMODE(flags);
-	/* f->f_version: 0 */
-	percpu_counter_inc(&nr_files);
 	return f;
 
 over:
@@ -150,6 +162,21 @@ struct file *alloc_empty_file(int flags, const struct cred *cred)
 	return ERR_PTR(-ENFILE);
 }
 
+/*
+ * Variant of alloc_empty_file() that doesn't check and modify nr_files.
+ *
+ * Should not be used unless there's a very good reason to do so.
+ */
+struct file *alloc_empty_file_noaccount(int flags, const struct cred *cred)
+{
+	struct file *f = __alloc_file(flags, cred);
+
+	if (!IS_ERR(f))
+		f->f_mode |= FMODE_NOACCOUNT;
+
+	return f;
+}
+
 /**
  * alloc_file - allocate and initialize a 'struct file'
  *
diff --git a/fs/internal.h b/fs/internal.h
index 52a346903748..442098fa0a84 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -94,6 +94,7 @@ extern void chroot_fs_refs(const struct path *, const struct path *);
  * file_table.c
  */
 extern struct file *alloc_empty_file(int, const struct cred *);
+extern struct file *alloc_empty_file_noaccount(int, const struct cred *);
 
 /*
  * super.c
diff --git a/fs/open.c b/fs/open.c
index dd15711eb658..9c6617dbb2c0 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -928,7 +928,7 @@ EXPORT_SYMBOL(dentry_open);
 struct file *open_with_fake_path(const struct path *path, int flags,
 				struct inode *inode, const struct cred *cred)
 {
-	struct file *f = alloc_empty_file(flags, cred);
+	struct file *f = alloc_empty_file_noaccount(flags, cred);
 	if (!IS_ERR(f)) {
 		int error;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 5ce2b413abc6..e1884840d556 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -156,6 +156,9 @@ typedef int (dio_iodone_t)(struct kiocb *iocb, loff_t offset,
 /* File is capable of returning -EAGAIN if I/O will block */
 #define FMODE_NOWAIT	((__force fmode_t)0x8000000)
 
+/* File does not contribute to nr_files count */
+#define FMODE_NOACCOUNT	((__force fmode_t)0x20000000)
+
 /*
  * Flag for rw_copy_check_uvector and compat_rw_copy_check_uvector
  * that indicates that they should check the contents of the iovec are
-- 
2.14.3
