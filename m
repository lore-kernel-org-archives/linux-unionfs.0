From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 39/39] vfs: remove open_flags from d_real()
Date: Tue, 29 May 2018 16:43:39 +0200
Message-ID: <20180529144339.16538-40-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Opening regular files on overlayfs is now handled via ovl_open().  Remove
the now unused "open_flags" argument from d_op->d_real() and the d_real()
helper.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/Locking |  3 +--
 Documentation/filesystems/vfs.txt | 16 ++++------------
 fs/overlayfs/super.c              | 36 +++---------------------------------
 include/linux/dcache.h            | 11 ++++-------
 include/linux/fs.h                |  2 +-
 5 files changed, 13 insertions(+), 55 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index a4afe96f0112..e1d7e43d302c 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -21,8 +21,7 @@ prototypes:
 	char *(*d_dname)((struct dentry *dentry, char *buffer, int buflen);
 	struct vfsmount *(*d_automount)(struct path *path);
 	int (*d_manage)(const struct path *, bool);
-	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int);
+	struct dentry *(*d_real)(struct dentry *, const struct inode *);
 
 locking rules:
 		rename_lock	->d_lock	may block	rcu-walk
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index af54d3651ff8..8b03c5e675bf 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -990,8 +990,7 @@ struct dentry_operations {
 	char *(*d_dname)(struct dentry *, char *, int);
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(const struct path *, bool);
-	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int);
+	struct dentry *(*d_real)(struct dentry *, const struct inode *);
 };
 
   d_revalidate: called when the VFS needs to revalidate a dentry. This
@@ -1125,22 +1124,15 @@ struct dentry_operations {
 	dentry being transited from.
 
   d_real: overlay/union type filesystems implement this method to return one of
-	the underlying dentries hidden by the overlay.  It is used in three
+	the underlying dentries hidden by the overlay.  It is used in two
 	different modes:
 
-	Called from open it may need to copy-up the file depending on the
-	supplied open flags.  This mode is selected with a non-zero flags
-	argument.  In this mode the d_real method can return an error.
-
 	Called from file_dentry() it returns the real dentry matching the inode
 	argument.  The real dentry may be from a lower layer already copied up,
 	but still referenced from the file.  This mode is selected with a
-	non-NULL inode argument.  This will always succeed.
-
-	With NULL inode and zero flags the topmost real underlying dentry is
-	returned.  This will always succeed.
+	non-NULL inode argument.
 
-	This method is never called with both non-NULL inode and non-zero flags.
+	With NULL inode the topmost real underlying dentry is returned.
 
 Each dentry has a pointer to its parent dentry, as well as a hash list
 of child dentries. Child dentries are basically like files in a
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d7df69e5b674..cd5c82f105d6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -80,28 +80,10 @@ static void ovl_dentry_release(struct dentry *dentry)
 	}
 }
 
-static int ovl_check_append_only(struct inode *inode, int flag)
-{
-	/*
-	 * This test was moot in vfs may_open() because overlay inode does
-	 * not have the S_APPEND flag, so re-check on real upper inode
-	 */
-	if (IS_APPEND(inode)) {
-		if  ((flag & O_ACCMODE) != O_RDONLY && !(flag & O_APPEND))
-			return -EPERM;
-		if (flag & O_TRUNC)
-			return -EPERM;
-	}
-
-	return 0;
-}
-
 static struct dentry *ovl_d_real(struct dentry *dentry,
-				 const struct inode *inode,
-				 unsigned int open_flags)
+				 const struct inode *inode)
 {
 	struct dentry *real;
-	int err;
 
 	/* It's an overlay file */
 	if (inode && d_inode(dentry) == inode)
@@ -113,28 +95,16 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 		goto bug;
 	}
 
-	if (open_flags) {
-		err = ovl_open_maybe_copy_up(dentry, open_flags);
-		if (err)
-			return ERR_PTR(err);
-	}
-
 	real = ovl_dentry_upper(dentry);
-	if (real && (!inode || inode == d_inode(real))) {
-		if (!inode) {
-			err = ovl_check_append_only(d_inode(real), open_flags);
-			if (err)
-				return ERR_PTR(err);
-		}
+	if (real && (!inode || inode == d_inode(real)))
 		return real;
-	}
 
 	real = ovl_dentry_lower(dentry);
 	if (!real)
 		goto bug;
 
 	/* Handle recursion */
-	real = d_real(real, inode, open_flags);
+	real = d_real(real, inode);
 
 	if (!inode || inode == d_inode(real))
 		return real;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 8fe4efa94af6..78cea80423a3 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -145,8 +145,7 @@ struct dentry_operations {
 	char *(*d_dname)(struct dentry *, char *, int);
 	struct vfsmount *(*d_automount)(struct path *);
 	int (*d_manage)(const struct path *, bool);
-	struct dentry *(*d_real)(struct dentry *, const struct inode *,
-				 unsigned int);
+	struct dentry *(*d_real)(struct dentry *, const struct inode *);
 } ____cacheline_aligned;
 
 /*
@@ -568,7 +567,6 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
  * d_real - Return the real dentry
  * @dentry: the dentry to query
  * @inode: inode to select the dentry from multiple layers (can be NULL)
- * @flags: open flags to control copy-up behavior
  *
  * If dentry is on a union/overlay, then return the underlying, real dentry.
  * Otherwise return the dentry itself.
@@ -576,11 +574,10 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
  * See also: Documentation/filesystems/vfs.txt
  */
 static inline struct dentry *d_real(struct dentry *dentry,
-				    const struct inode *inode,
-				    unsigned int flags)
+				    const struct inode *inode)
 {
 	if (unlikely(dentry->d_flags & DCACHE_OP_REAL))
-		return dentry->d_op->d_real(dentry, inode, flags);
+		return dentry->d_op->d_real(dentry, inode);
 	else
 		return dentry;
 }
@@ -595,7 +592,7 @@ static inline struct dentry *d_real(struct dentry *dentry,
 static inline struct inode *d_real_inode(const struct dentry *dentry)
 {
 	/* This usage of d_real() results in const dentry */
-	return d_backing_inode(d_real((struct dentry *) dentry, NULL, 0));
+	return d_backing_inode(d_real((struct dentry *) dentry, NULL));
 }
 
 struct name_snapshot {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 7471a4208fdc..eb4c189d34ba 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1234,7 +1234,7 @@ static inline struct inode *file_inode(const struct file *f)
 
 static inline struct dentry *file_dentry(const struct file *file)
 {
-	return d_real(file->f_path.dentry, file_inode(file), 0);
+	return d_real(file->f_path.dentry, file_inode(file));
 }
 
 static inline int locks_lock_file_wait(struct file *filp, struct file_lock *fl)
-- 
2.14.3
