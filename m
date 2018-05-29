From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 35/39] Revert "vfs: add flags to d_real()"
Date: Tue, 29 May 2018 16:43:35 +0200
Message-ID: <20180529144339.16538-36-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This reverts commit 495e642939114478a5237a7d91661ba93b76f15a.

No user of "flags" argument of d_real() remain.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/Locking |  2 +-
 Documentation/filesystems/vfs.txt |  2 +-
 fs/open.c                         |  2 +-
 fs/overlayfs/super.c              |  4 ++--
 include/linux/dcache.h            | 11 +++++------
 include/linux/fs.h                |  2 +-
 6 files changed, 11 insertions(+), 12 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 60e76060baff..a4afe96f0112 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -22,7 +22,7 @@ prototypes:
 	struct vfsmount *(*d_automount)(struct path *path);
 	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int, unsigned int);
+				 unsigned int);
 
 locking rules:
 		rename_lock	->d_lock	may block	rcu-walk
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 2bc77ea8aef4..af54d3651ff8 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -991,7 +991,7 @@ struct dentry_operations {
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int, unsigned int);
+				 unsigned int);
 };
 
   d_revalidate: called when the VFS needs to revalidate a dentry. This
diff --git a/fs/open.c b/fs/open.c
index 2db39216c393..127b49819afb 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -96,7 +96,7 @@ long vfs_truncate(const struct path *path, loff_t length)
 	 * write access on the upper inode, not on the overlay inode.  For
 	 * non-overlay filesystems d_real() is an identity function.
 	 */
-	upperdentry = d_real(path->dentry, NULL, O_WRONLY, 0);
+	upperdentry = d_real(path->dentry, NULL, O_WRONLY);
 	error = PTR_ERR(upperdentry);
 	if (IS_ERR(upperdentry))
 		goto mnt_drop_write_and_out;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 65ec661c60e6..4bca84a17c43 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -98,7 +98,7 @@ static int ovl_check_append_only(struct inode *inode, int flag)
 
 static struct dentry *ovl_d_real(struct dentry *dentry,
 				 const struct inode *inode,
-				 unsigned int open_flags, unsigned int flags)
+				 unsigned int open_flags)
 {
 	struct dentry *real;
 	int err;
@@ -134,7 +134,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 		goto bug;
 
 	/* Handle recursion */
-	real = d_real(real, inode, open_flags, 0);
+	real = d_real(real, inode, open_flags);
 
 	if (!inode || inode == d_inode(real))
 		return real;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index ddae4103d324..8fe4efa94af6 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -146,7 +146,7 @@ struct dentry_operations {
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(const struct path *, bool);
 	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int, unsigned int);
+				 unsigned int);
 } ____cacheline_aligned;
 
 /*
@@ -568,8 +568,7 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
  * d_real - Return the real dentry
  * @dentry: the dentry to query
  * @inode: inode to select the dentry from multiple layers (can be NULL)
- * @open_flags: open flags to control copy-up behavior
- * @flags: flags to control what is returned by this function
+ * @flags: open flags to control copy-up behavior
  *
  * If dentry is on a union/overlay, then return the underlying, real dentry.
  * Otherwise return the dentry itself.
@@ -578,10 +577,10 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
  */
 static inline struct dentry *d_real(struct dentry *dentry,
 				    const struct inode *inode,
-				    unsigned int open_flags, unsigned int flags)
+				    unsigned int flags)
 {
 	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
-		return dentry->d_op->d_real(dentry, inode, open_flags, flags);
+		return dentry->d_op->d_real(dentry, inode, flags);
 	else
 		return dentry;
 }
@@ -596,7 +595,7 @@ static inline struct dentry *d_real(struct dentry *dentry,
 static inline struct inode *d_real_inode(const struct dentry *dentry)
 {
 	/* This usage of d_real() results in const dentry */
-	return d_backing_inode(d_real((struct dentry *) dentry, NULL, 0, 0));
+	return d_backing_inode(d_real((struct dentry *) dentry, NULL, 0));
 }
 
 struct name_snapshot {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 96a4b9fd1f5f..797d6f28a8f0 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1244,7 +1244,7 @@ static inline struct inode *file_inode(const struct file *f)
 
 static inline struct dentry *file_dentry(const struct file *file)
 {
-	return d_real(file->f_path.dentry, file_inode(file), 0, 0);
+	return d_real(file->f_path.dentry, file_inode(file), 0);
 }
 
 static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
-- 
2.14.3
