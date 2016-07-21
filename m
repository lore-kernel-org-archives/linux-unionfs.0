From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH v2 1/3] locks: fix file locking on overlayfs
Date: Thu, 21 Jul 2016 15:53:34 +0200
Message-ID: <1469109216-24353-2-git-send-email-mszeredi@redhat.com>
References: <1469109216-24353-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1469109216-24353-1-git-send-email-mszeredi@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This patch allows flock, posix locks, ofd locks and leases to work
correctly on overlayfs.

Instead of using the underlying inode for storing lock context use the
overlay inode.  This allows locks to be persistent across copy-up.

This is done by introducing locks_inode() helper and using it instead of
file_inode() to get the inode in locking code.  For non-overlayfs the two
are equivalent, except for an extra pointer dereference in locks_inode().

Since lock operations are in "struct file_operations" we must also make
sure not to call underlying filesystem's lock operations.  Introcude a
super block flag MS_NOREMOTELOCK to this effect.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/locks.c              | 50 +++++++++++++++++++++++++++----------------------
 fs/namespace.c          |  2 +-
 fs/open.c               |  2 +-
 fs/overlayfs/super.c    |  2 +-
 include/linux/fs.h      | 16 ++++++++++++++--
 include/uapi/linux/fs.h |  1 +
 6 files changed, 46 insertions(+), 27 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index ee1b15f6fc13..c1656cff53ee 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -139,6 +139,11 @@
 #define IS_LEASE(fl)	(fl->fl_flags & (FL_LEASE|FL_DELEG|FL_LAYOUT))
 #define IS_OFDLCK(fl)	(fl->fl_flags & FL_OFDLCK)
 
+static inline bool is_remote_lock(struct file *filp)
+{
+	return likely(!(filp->f_path.dentry->d_sb->s_flags & MS_NOREMOTELOCK));
+}
+
 static bool lease_breaking(struct file_lock *fl)
 {
 	return fl->fl_flags & (FL_UNLOCK_PENDING | FL_DOWNGRADE_PENDING);
@@ -791,7 +796,7 @@ posix_test_lock(struct file *filp, struct file_lock *fl)
 {
 	struct file_lock *cfl;
 	struct file_lock_context *ctx;
-	struct inode *inode = file_inode(filp);
+	struct inode *inode = locks_inode(filp);
 
 	ctx = smp_load_acquire(&inode->i_flctx);
 	if (!ctx || list_empty_careful(&ctx->flc_posix)) {
@@ -1192,7 +1197,7 @@ static int posix_lock_inode(struct inode *inode, struct file_lock *request,
 int posix_lock_file(struct file *filp, struct file_lock *fl,
 			struct file_lock *conflock)
 {
-	return posix_lock_inode(file_inode(filp), fl, conflock);
+	return posix_lock_inode(locks_inode(filp), fl, conflock);
 }
 EXPORT_SYMBOL(posix_lock_file);
 
@@ -1232,7 +1237,7 @@ static int posix_lock_inode_wait(struct inode *inode, struct file_lock *fl)
 int locks_mandatory_locked(struct file *file)
 {
 	int ret;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = locks_inode(file);
 	struct file_lock_context *ctx;
 	struct file_lock *fl;
 
@@ -1572,7 +1577,7 @@ EXPORT_SYMBOL(lease_get_mtime);
 int fcntl_getlease(struct file *filp)
 {
 	struct file_lock *fl;
-	struct inode *inode = file_inode(filp);
+	struct inode *inode = locks_inode(filp);
 	struct file_lock_context *ctx;
 	int type = F_UNLCK;
 	LIST_HEAD(dispose);
@@ -1580,7 +1585,7 @@ int fcntl_getlease(struct file *filp)
 	ctx = smp_load_acquire(&inode->i_flctx);
 	if (ctx && !list_empty_careful(&ctx->flc_lease)) {
 		spin_lock(&ctx->flc_lock);
-		time_out_leases(file_inode(filp), &dispose);
+		time_out_leases(inode, &dispose);
 		list_for_each_entry(fl, &ctx->flc_lease, fl_list) {
 			if (fl->fl_file != filp)
 				continue;
@@ -1628,7 +1633,7 @@ generic_add_lease(struct file *filp, long arg, struct file_lock **flp, void **pr
 {
 	struct file_lock *fl, *my_fl = NULL, *lease;
 	struct dentry *dentry = filp->f_path.dentry;
-	struct inode *inode = file_inode(filp);
+	struct inode *inode = dentry->d_inode;
 	struct file_lock_context *ctx;
 	bool is_deleg = (*flp)->fl_flags & FL_DELEG;
 	int error;
@@ -1742,7 +1747,7 @@ static int generic_delete_lease(struct file *filp, void *owner)
 {
 	int error = -EAGAIN;
 	struct file_lock *fl, *victim = NULL;
-	struct inode *inode = file_inode(filp);
+	struct inode *inode = locks_inode(filp);
 	struct file_lock_context *ctx;
 	LIST_HEAD(dispose);
 
@@ -1782,7 +1787,7 @@ static int generic_delete_lease(struct file *filp, void *owner)
 int generic_setlease(struct file *filp, long arg, struct file_lock **flp,
 			void **priv)
 {
-	struct inode *inode = file_inode(filp);
+	struct inode *inode = locks_inode(filp);
 	int error;
 
 	if ((!uid_eq(current_fsuid(), inode->i_uid)) && !capable(CAP_LEASE))
@@ -1830,7 +1835,7 @@ EXPORT_SYMBOL(generic_setlease);
 int
 vfs_setlease(struct file *filp, long arg, struct file_lock **lease, void **priv)
 {
-	if (filp->f_op->setlease)
+	if (filp->f_op->setlease && is_remote_lock(filp))
 		return filp->f_op->setlease(filp, arg, lease, priv);
 	else
 		return generic_setlease(filp, arg, lease, priv);
@@ -1979,7 +1984,7 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
 	if (error)
 		goto out_free;
 
-	if (f.file->f_op->flock)
+	if (f.file->f_op->flock && is_remote_lock(f.file))
 		error = f.file->f_op->flock(f.file,
 					  (can_sleep) ? F_SETLKW : F_SETLK,
 					  lock);
@@ -2005,7 +2010,7 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
  */
 int vfs_test_lock(struct file *filp, struct file_lock *fl)
 {
-	if (filp->f_op->lock)
+	if (filp->f_op->lock && is_remote_lock(filp))
 		return filp->f_op->lock(filp, F_GETLK, fl);
 	posix_test_lock(filp, fl);
 	return 0;
@@ -2129,7 +2134,7 @@ out:
  */
 int vfs_lock_file(struct file *filp, unsigned int cmd, struct file_lock *fl, struct file_lock *conf)
 {
-	if (filp->f_op->lock)
+	if (filp->f_op->lock && is_remote_lock(filp))
 		return filp->f_op->lock(filp, cmd, fl);
 	else
 		return posix_lock_file(filp, fl, conf);
@@ -2191,7 +2196,7 @@ int fcntl_setlk(unsigned int fd, struct file *filp, unsigned int cmd,
 	if (file_lock == NULL)
 		return -ENOLCK;
 
-	inode = file_inode(filp);
+	inode = locks_inode(filp);
 
 	/*
 	 * This might block, so we do it before checking the inode.
@@ -2343,7 +2348,7 @@ int fcntl_setlk64(unsigned int fd, struct file *filp, unsigned int cmd,
 	if (copy_from_user(&flock, l, sizeof(flock)))
 		goto out;
 
-	inode = file_inode(filp);
+	inode = locks_inode(filp);
 
 	/* Don't allow mandatory locks on files that may be memory mapped
 	 * and shared.
@@ -2426,6 +2431,7 @@ out:
 void locks_remove_posix(struct file *filp, fl_owner_t owner)
 {
 	int error;
+	struct inode *inode = locks_inode(filp);
 	struct file_lock lock;
 	struct file_lock_context *ctx;
 
@@ -2434,7 +2440,7 @@ void locks_remove_posix(struct file *filp, fl_owner_t owner)
 	 * posix_lock_file().  Another process could be setting a lock on this
 	 * file at the same time, but we wouldn't remove that lock anyway.
 	 */
-	ctx =  smp_load_acquire(&file_inode(filp)->i_flctx);
+	ctx =  smp_load_acquire(&inode->i_flctx);
 	if (!ctx || list_empty(&ctx->flc_posix))
 		return;
 
@@ -2452,7 +2458,7 @@ void locks_remove_posix(struct file *filp, fl_owner_t owner)
 
 	if (lock.fl_ops && lock.fl_ops->fl_release_private)
 		lock.fl_ops->fl_release_private(&lock);
-	trace_locks_remove_posix(file_inode(filp), &lock, error);
+	trace_locks_remove_posix(inode, &lock, error);
 }
 
 EXPORT_SYMBOL(locks_remove_posix);
@@ -2469,12 +2475,12 @@ locks_remove_flock(struct file *filp, struct file_lock_context *flctx)
 		.fl_type = F_UNLCK,
 		.fl_end = OFFSET_MAX,
 	};
-	struct inode *inode = file_inode(filp);
+	struct inode *inode = locks_inode(filp);
 
 	if (list_empty(&flctx->flc_flock))
 		return;
 
-	if (filp->f_op->flock)
+	if (filp->f_op->flock && is_remote_lock(filp))
 		filp->f_op->flock(filp, F_SETLKW, &fl);
 	else
 		flock_lock_inode(inode, &fl);
@@ -2508,7 +2514,7 @@ void locks_remove_file(struct file *filp)
 {
 	struct file_lock_context *ctx;
 
-	ctx = smp_load_acquire(&file_inode(filp)->i_flctx);
+	ctx = smp_load_acquire(&locks_inode(filp)->i_flctx);
 	if (!ctx)
 		return;
 
@@ -2552,7 +2558,7 @@ EXPORT_SYMBOL(posix_unblock_lock);
  */
 int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
 {
-	if (filp->f_op->lock)
+	if (filp->f_op->lock && is_remote_lock(filp))
 		return filp->f_op->lock(filp, F_CANCELLK, fl);
 	return 0;
 }
@@ -2580,7 +2586,7 @@ static void lock_get_status(struct seq_file *f, struct file_lock *fl,
 		fl_pid = fl->fl_pid;
 
 	if (fl->fl_file != NULL)
-		inode = file_inode(fl->fl_file);
+		inode = locks_inode(fl->fl_file);
 
 	seq_printf(f, "%lld:%s ", id, pfx);
 	if (IS_POSIX(fl)) {
@@ -2682,7 +2688,7 @@ static void __show_fd_locks(struct seq_file *f,
 void show_fd_locks(struct seq_file *f,
 		  struct file *filp, struct files_struct *files)
 {
-	struct inode *inode = file_inode(filp);
+	struct inode *inode = locks_inode(filp);
 	struct file_lock_context *ctx;
 	int id = 0;
 
diff --git a/fs/namespace.c b/fs/namespace.c
index 419f746d851d..05daf3f98d86 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -2722,7 +2722,7 @@ long do_mount(const char *dev_name, const char __user *dir_name,
 
 	flags &= ~(MS_NOSUID | MS_NOEXEC | MS_NODEV | MS_ACTIVE | MS_BORN |
 		   MS_NOATIME | MS_NODIRATIME | MS_RELATIME| MS_KERNMOUNT |
-		   MS_STRICTATIME);
+		   MS_STRICTATIME | MS_NOREMOTELOCK);
 
 	if (flags & MS_REMOUNT)
 		retval = do_remount(&path, flags & ~MS_REMOUNT, mnt_flags,
diff --git a/fs/open.c b/fs/open.c
index bf66cf1a9f5c..451fed14a843 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -726,7 +726,7 @@ static int do_dentry_open(struct file *f,
 	if (error)
 		goto cleanup_all;
 
-	error = break_lease(inode, f->f_flags);
+	error = break_lease(locks_inode(f), f->f_flags);
 	if (error)
 		goto cleanup_all;
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ed4aa34211a6..4c91d9ed4689 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1280,7 +1280,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_xattr = ovl_xattr_noacl_handlers;
 	sb->s_root = root_dentry;
 	sb->s_fs_info = ufs;
-	sb->s_flags |= MS_POSIXACL;
+	sb->s_flags |= MS_POSIXACL | MS_NOREMOTELOCK;
 
 	return 0;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bacc0733663c..58657f56ca02 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1090,6 +1090,18 @@ struct file_lock_context {
 
 extern void send_sigio(struct fown_struct *fown, int fd, int band);
 
+/*
+ * Return the inode to use for locking
+ *
+ * For overlayfs this should be the overlay inode, not the real inode returned
+ * by file_inode().  For any other fs file_inode(filp) and locks_inode(filp) are
+ * equal.
+ */
+static inline struct inode *locks_inode(const struct file *f)
+{
+	return f->f_path.dentry->d_inode;
+}
+
 #ifdef CONFIG_FILE_LOCKING
 extern int fcntl_getlk(struct file *, unsigned int, struct flock __user *);
 extern int fcntl_setlk(unsigned int, struct file *, unsigned int,
@@ -1277,7 +1289,7 @@ static inline struct dentry *file_dentry(const struct file *file)
 
 static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
 {
-	return locks_lock_inode_wait(file_inode(filp), fl);
+	return locks_lock_inode_wait(locks_inode(filp), fl);
 }
 
 struct fasync_struct {
@@ -2132,7 +2144,7 @@ static inline int mandatory_lock(struct inode *ino)
 
 static inline int locks_verify_locked(struct file *file)
 {
-	if (mandatory_lock(file_inode(file)))
+	if (mandatory_lock(locks_inode(file)))
 		return locks_mandatory_locked(file);
 	return 0;
 }
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 3b00f7c8943f..2473272169f2 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -132,6 +132,7 @@ struct inodes_stat_t {
 #define MS_LAZYTIME	(1<<25) /* Update the on-disk [acm]times lazily */
 
 /* These sb flags are internal to the kernel */
+#define MS_NOREMOTELOCK	(1<<27)
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
-- 
2.5.5

