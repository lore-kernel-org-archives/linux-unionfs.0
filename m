From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 37/39] Partially revert "locks: fix file locking on overlayfs"
Date: Tue, 29 May 2018 16:43:37 +0200
Message-ID: <20180529144339.16538-38-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This partially reverts commit c568d68341be7030f5647def68851e469b21ca11.

Overlayfs files will now automatically get the correct locks, no need to
hack overlay support in VFS.

It is a partial revert, because it leaves the locks_inode() calls in place
and defines locks_inode() to file_inode().  We could revert those as well,
but it would be unnecessary code churn and it makes sense to document that
we are getting the inode for locking purposes.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
---
 fs/locks.c              | 17 ++++++-----------
 fs/overlayfs/super.c    |  2 +-
 include/linux/fs.h      | 13 +------------
 include/uapi/linux/fs.h |  1 -
 4 files changed, 8 insertions(+), 25 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 9c0e5f3da66c..40bcbaaa3f52 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -139,11 +139,6 @@
 #define IS_OFDLCK(fl)	(fl->fl_flags & FL_OFDLCK)
 #define IS_REMOTELCK(fl)	(fl->fl_pid <= 0)
 
-static inline bool is_remote_lock(struct file *filp)
-{
-	return likely(!(filp->f_path.dentry->d_sb->s_flags & SB_NOREMOTELOCK));
-}
-
 static bool lease_breaking(struct file_lock *fl)
 {
 	return fl->fl_flags & (FL_UNLOCK_PENDING | FL_DOWNGRADE_PENDING);
@@ -1875,7 +1870,7 @@ EXPORT_SYMBOL(generic_setlease);
 int
 vfs_setlease(struct file *filp, long arg, struct file_lock **lease, void **priv)
 {
-	if (filp->f_op->setlease && is_remote_lock(filp))
+	if (filp->f_op->setlease)
 		return filp->f_op->setlease(filp, arg, lease, priv);
 	else
 		return generic_setlease(filp, arg, lease, priv);
@@ -2022,7 +2017,7 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
 	if (error)
 		goto out_free;
 
-	if (f.file->f_op->flock && is_remote_lock(f.file))
+	if (f.file->f_op->flock)
 		error = f.file->f_op->flock(f.file,
 					  (can_sleep) ? F_SETLKW : F_SETLK,
 					  lock);
@@ -2048,7 +2043,7 @@ SYSCALL_DEFINE2(flock, unsigned int, fd, unsigned int, cmd)
  */
 int vfs_test_lock(struct file *filp, struct file_lock *fl)
 {
-	if (filp->f_op->lock && is_remote_lock(filp))
+	if (filp->f_op->lock)
 		return filp->f_op->lock(filp, F_GETLK, fl);
 	posix_test_lock(filp, fl);
 	return 0;
@@ -2191,7 +2186,7 @@ int fcntl_getlk(struct file *filp, unsigned int cmd, struct flock *flock)
  */
 int vfs_lock_file(struct file *filp, unsigned int cmd, struct file_lock *fl, struct file_lock *conf)
 {
-	if (filp->f_op->lock && is_remote_lock(filp))
+	if (filp->f_op->lock)
 		return filp->f_op->lock(filp, cmd, fl);
 	else
 		return posix_lock_file(filp, fl, conf);
@@ -2513,7 +2508,7 @@ locks_remove_flock(struct file *filp, struct file_lock_context *flctx)
 	if (list_empty(&flctx->flc_flock))
 		return;
 
-	if (filp->f_op->flock && is_remote_lock(filp))
+	if (filp->f_op->flock)
 		filp->f_op->flock(filp, F_SETLKW, &fl);
 	else
 		flock_lock_inode(inode, &fl);
@@ -2600,7 +2595,7 @@ EXPORT_SYMBOL(posix_unblock_lock);
  */
 int vfs_cancel_lock(struct file *filp, struct file_lock *fl)
 {
-	if (filp->f_op->lock && is_remote_lock(filp))
+	if (filp->f_op->lock)
 		return filp->f_op->lock(filp, F_CANCELLK, fl);
 	return 0;
 }
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4bca84a17c43..d7df69e5b674 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1478,7 +1478,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_op = &ovl_super_operations;
 	sb->s_xattr = ovl_xattr_handlers;
 	sb->s_fs_info = ofs;
-	sb->s_flags |= SB_POSIXACL | SB_NOREMOTELOCK;
+	sb->s_flags |= SB_POSIXACL;
 
 	err = -ENOMEM;
 	root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 797d6f28a8f0..7471a4208fdc 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1050,17 +1050,7 @@ struct file_lock_context {
 
 extern void send_sigio(struct fown_struct *fown, int fd, int band);
 
-/*
- * Return the inode to use for locking
- *
- * For overlayfs this should be the overlay inode, not the real inode returned
- * by file_inode().  For any other fs file_inode(filp) and locks_inode(filp) are
- * equal.
- */
-static inline struct inode *locks_inode(const struct file *f)
-{
-	return f->f_path.dentry->d_inode;
-}
+#define locks_inode(f) file_inode(f)
 
 #ifdef CONFIG_FILE_LOCKING
 extern int fcntl_getlk(struct file *, unsigned int, struct flock *);
@@ -1300,7 +1290,6 @@ extern int send_sigurg(struct fown_struct *fown);
 
 /* These sb flags are internal to the kernel */
 #define SB_SUBMOUNT     (1<<26)
-#define SB_NOREMOTELOCK	(1<<27)
 #define SB_NOSEC	(1<<28)
 #define SB_BORN		(1<<29)
 #define SB_ACTIVE	(1<<30)
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index d2a8313fabd7..2840ddcece73 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -134,7 +134,6 @@ struct inodes_stat_t {
 
 /* These sb flags are internal to the kernel */
 #define MS_SUBMOUNT     (1<<26)
-#define MS_NOREMOTELOCK	(1<<27)
 #define MS_NOSEC	(1<<28)
 #define MS_BORN		(1<<29)
 #define MS_ACTIVE	(1<<30)
-- 
2.14.3
