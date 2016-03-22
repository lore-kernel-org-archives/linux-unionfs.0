From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 1/2] vfs: export lookup_hash() to modules
Date: Tue, 22 Mar 2016 14:21:03 +0100
Message-ID: <20160322132103.GD11906@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Overlayfs needs lookup without inode_permission() and already has the name
hash (in form of dentry->d_name on overlayfs dentry).  It also doesn't
support filesystems with d_op->d_hash() so basically it only needs
__lookup_hash() from lookup_one_len().

Rename __lookup_hash() to lookup_hash() and export to modules.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/namei.c            |   35 ++++++++++++++++++++++++++---------
 include/linux/namei.h |    2 ++
 2 files changed, 28 insertions(+), 9 deletions(-)

--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1492,8 +1492,24 @@ static struct dentry *lookup_real(struct
 	return dentry;
 }
 
-static struct dentry *__lookup_hash(const struct qstr *name,
-		struct dentry *base, unsigned int flags)
+/**
+ * lookup_hash - lookup single pathname component on already hashed name
+ * @name:	name and hash to lookup
+ * @base:	base directory to lookup from
+ * @flags:	lookup flags
+ *
+ * The name must have been verified and hashed (see lookup_one_len()).  Using
+ * this after just full_name_hash() is unsafe.
+ *
+ * This function also doesn't check for search permission on base directory.
+ *
+ * Use lookup_one_len() or lookup_one_len_unlocked() instead, unless you really
+ * know what you are doing.
+ *
+ * The caller must hold base->i_mutex.
+ */
+struct dentry *lookup_hash(const struct qstr *name,
+			   struct dentry *base, unsigned int flags)
 {
 	struct dentry *dentry = lookup_dcache(name, base, flags);
 
@@ -1506,6 +1522,7 @@ static struct dentry *__lookup_hash(cons
 
 	return lookup_real(base->d_inode, dentry, flags);
 }
+EXPORT_SYMBOL(lookup_hash);
 
 static int lookup_fast(struct nameidata *nd,
 		       struct path *path, struct inode **inode,
@@ -2229,7 +2246,7 @@ struct dentry *kern_path_locked(const ch
 		return ERR_PTR(-EINVAL);
 	}
 	inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
-	d = __lookup_hash(&last, path->dentry, 0);
+	d = lookup_hash(&last, path->dentry, 0);
 	if (IS_ERR(d)) {
 		inode_unlock(path->dentry->d_inode);
 		path_put(path);
@@ -2313,7 +2330,7 @@ struct dentry *lookup_one_len(const char
 	if (err)
 		return ERR_PTR(err);
 
-	return __lookup_hash(&this, base, 0);
+	return lookup_hash(&this, base, 0);
 }
 EXPORT_SYMBOL(lookup_one_len);
 
@@ -3476,7 +3493,7 @@ static struct dentry *filename_create(in
 	 */
 	lookup_flags |= LOOKUP_CREATE | LOOKUP_EXCL;
 	inode_lock_nested(path->dentry->d_inode, I_MUTEX_PARENT);
-	dentry = __lookup_hash(&last, path->dentry, lookup_flags);
+	dentry = lookup_hash(&last, path->dentry, lookup_flags);
 	if (IS_ERR(dentry))
 		goto unlock;
 
@@ -3756,7 +3773,7 @@ static long do_rmdir(int dfd, const char
 		goto exit1;
 
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
-	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
+	dentry = lookup_hash(&last, path.dentry, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (IS_ERR(dentry))
 		goto exit2;
@@ -3878,7 +3895,7 @@ static long do_unlinkat(int dfd, const c
 		goto exit1;
 retry_deleg:
 	inode_lock_nested(path.dentry->d_inode, I_MUTEX_PARENT);
-	dentry = __lookup_hash(&last, path.dentry, lookup_flags);
+	dentry = lookup_hash(&last, path.dentry, lookup_flags);
 	error = PTR_ERR(dentry);
 	if (!IS_ERR(dentry)) {
 		/* Why not before? Because we want correct error value */
@@ -4407,7 +4424,7 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
 retry_deleg:
 	trap = lock_rename(new_path.dentry, old_path.dentry);
 
-	old_dentry = __lookup_hash(&old_last, old_path.dentry, lookup_flags);
+	old_dentry = lookup_hash(&old_last, old_path.dentry, lookup_flags);
 	error = PTR_ERR(old_dentry);
 	if (IS_ERR(old_dentry))
 		goto exit3;
@@ -4415,7 +4432,7 @@ SYSCALL_DEFINE5(renameat2, int, olddfd,
 	error = -ENOENT;
 	if (d_is_negative(old_dentry))
 		goto exit4;
-	new_dentry = __lookup_hash(&new_last, new_path.dentry, lookup_flags | target_flags);
+	new_dentry = lookup_hash(&new_last, new_path.dentry, lookup_flags | target_flags);
 	error = PTR_ERR(new_dentry);
 	if (IS_ERR(new_dentry))
 		goto exit4;
--- a/include/linux/namei.h
+++ b/include/linux/namei.h
@@ -79,6 +79,8 @@ extern int kern_path_mountpoint(int, con
 
 extern struct dentry *lookup_one_len(const char *, struct dentry *, int);
 extern struct dentry *lookup_one_len_unlocked(const char *, struct dentry *, int);
+struct qstr;
+extern struct dentry *lookup_hash(const struct qstr *, struct dentry *, unsigned int);
 
 extern int follow_down_one(struct path *);
 extern int follow_down(struct path *);
