From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 1/3] vfs: add flags to d_real()
Date: Tue,  5 Sep 2017 09:46:34 +0200
Message-ID: <1504597596-17994-2-git-send-email-mszeredi@redhat.com>
References: <1504597596-17994-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1504597596-17994-1-git-send-email-mszeredi@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Add a separate flags argument (in addition to the open flags) to control
the behavior of d_real().

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/Locking |  2 +-
 Documentation/filesystems/vfs.txt |  2 +-
 fs/open.c                         |  4 ++--
 fs/overlayfs/super.c              |  4 ++--
 include/linux/dcache.h            | 11 ++++++-----
 include/linux/fs.h                |  2 +-
 6 files changed, 13 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index fe25787ff6d4..75d2d57e2c44 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -22,7 +22,7 @@ prototypes:
 	struct vfsmount *(*d_automount)(struct path *path);
 	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int);
+				 unsigned int, unsigned int);
 
 locking rules:
 		rename_lock	->d_lock	may block	rcu-walk
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 73e7d91f03dc..7f20c1bdfb67 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -990,7 +990,7 @@ struct dentry_operations {
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int);
+				 unsigned int, unsigned int);
 };
 
   d_revalidate: called when the VFS needs to revalidate a dentry. This
diff --git a/fs/open.c b/fs/open.c
index 35bb784763a4..6d5c9a9b8c8d 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -96,7 +96,7 @@ long vfs_truncate(const struct path *path, loff_t length)
 	 * write access on the upper inode, not on the overlay inode.  For
 	 * non-overlay filesystems d_real() is an identity function.
 	 */
-	upperdentry = d_real(path->dentry, NULL, O_WRONLY);
+	upperdentry = d_real(path->dentry, NULL, O_WRONLY, 0);
 	error = PTR_ERR(upperdentry);
 	if (IS_ERR(upperdentry))
 		goto mnt_drop_write_and_out;
@@ -857,7 +857,7 @@ EXPORT_SYMBOL(file_path);
 int vfs_open(const struct path *path, struct file *file,
 	     const struct cred *cred)
 {
-	struct dentry *dentry = d_real(path->dentry, NULL, file->f_flags);
+	struct dentry *dentry = d_real(path->dentry, NULL, file->f_flags, 0);
 
 	if (IS_ERR(dentry))
 		return PTR_ERR(dentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c0c02cca776b..19e89ce39017 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -70,7 +70,7 @@ static int ovl_check_append_only(struct inode *inode, int flag)
 
 static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode,
-				 unsigned int open_flags)
+				 unsigned int open_flags, unsigned int flags)
 {
 	struct dentry *real;
 	int err;
@@ -102,7 +102,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 		goto bug;
 
 	/* Handle recursion */
-	real = d_real(real, inode, open_flags);
+	real = d_real(real, inode, open_flags, 0);
 
 	if (!inode || inode == d_inode(real))
 		return real;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index aae1cdb76851..fd0721e520f4 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -147,7 +147,7 @@ struct dentry_operations {
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int);
+				 unsigned int, unsigned int);
 } ____cacheline_aligned;
 
 /*
@@ -566,7 +566,8 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
  * d_real - Return the real dentry
  * @dentry: the dentry to query
  * @inode: inode to select the dentry from multiple layers (can be NULL)
- * @flags: open flags to control copy-up behavior
+ * @open_flags: open flags to control copy-up behavior
+ * @flags: flags to control what is returned by this function
  *
  * If dentry is on a union/overlay, then return the underlying, real dentry.
  * Otherwise return the dentry itself.
@@ -575,10 +576,10 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
  */
 static inline struct dentry *d_real(struct dentry *dentry,
 				    const struct inode *inode,
-				    unsigned int flags)
+				    unsigned int open_flags, unsigned int flags)
 {
 	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
-		return dentry->d_op->d_real(dentry, inode, flags);
+		return dentry->d_op->d_real(dentry, inode, open_flags, flags);
 	else
 		return dentry;
 }
@@ -593,7 +594,7 @@ static inline struct dentry *d_real(struct dentry *dentry,
 static inline struct inode *d_real_inode(const struct dentry *dentry)
 {
 	/* This usage of d_real() results in const dentry */
-	return d_backing_inode(d_real((struct dentry *) dentry, NULL, 0));
+	return d_backing_inode(d_real((struct dentry *) dentry, NULL, 0, 0));
 }
 
 struct name_snapshot {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6e1fd5d21248..ee1db83c39cb 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1233,7 +1233,7 @@ static inline struct inode *file_inode(const struct file *f)
 
 static inline struct dentry *file_dentry(const struct file *file)
 {
-	return d_real(file->f_path.dentry, file_inode(file), 0);
+	return d_real(file->f_path.dentry, file_inode(file), 0, 0);
 }
 
 static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
-- 
2.5.5
