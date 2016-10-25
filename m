From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 3/3] ovl: redirect on rename-dir
Date: Tue, 25 Oct 2016 09:34:47 +0200
Message-ID: <1477380887-21333-4-git-send-email-mszeredi@redhat.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Current code returns EXDEV when a directory would need to be copied up to
move.  We could copy up the directory tree in this case, but there's
another solution: point to old lower directory from moved upper directory.

This is achieved with a "trusted.overlay.redirect" xattr storing the path
relative to the root of the overlay.  After such attribute has been set,
the directory can be moved without further actions required.

This is a backward incompatible feature, old kernels won't be able to
correctly mount an overlay containing redirected directories.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/overlayfs.txt | 21 ++++++-
 fs/overlayfs/copy_up.c                  | 20 ++-----
 fs/overlayfs/dir.c                      | 86 +++++++++++++++++++---------
 fs/overlayfs/namei.c                    | 99 ++++++++++++++++++++++++++++++---
 fs/overlayfs/overlayfs.h                |  4 ++
 fs/overlayfs/ovl_entry.h                |  4 ++
 fs/overlayfs/super.c                    | 25 +++++----
 fs/overlayfs/util.c                     | 19 +++++++
 8 files changed, 217 insertions(+), 61 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 5108425157ac..fae48ab3b36b 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -130,6 +130,23 @@ directory.
 Readdir on directories that are not merged is simply handled by the
 underlying directory (upper or lower).
 
+renaming directories
+--------------------
+
+When renaming a directory that is on the lower layer or merged (i.e. the
+directory was not created on the upper layer to start with) overlayfs can
+handle it in two different ways:
+
+1) return EXDEV error: this error is returned by rename(2) when trying to
+   move a file or directory across filesystem boundaries.  Hence
+   applications are usually prepared to hande this error (mv(1) for example
+   recursively copies the directory tree).  This is the default behavior.
+
+2) If the "redirect_dir" feature is enabled, then the directory will be
+   copied up (but not the contents).  Then the "trusted.overlay.redirect"
+   extended attribute is set to the path of the original location from the
+   root of the overlay.  Finally the directory is moved to the new
+   location.
 
 Non-directories
 ---------------
@@ -201,8 +218,8 @@ If a file with multiple hard links is copied up, then this will
 "break" the link.  Changes will not be propagated to other names
 referring to the same inode.
 
-Directory trees are not copied up.  If rename(2) is performed on a directory
-which is on the lower layer or is merged, then -EXDEV will be returned.
+Unless "redirect_dir" feature is enabled, rename(2) on a lower or merged
+directory will fail with EXDEV.
 
 Changes to underlying filesystems
 ---------------------------------
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 49f6158bb04c..0d7075208099 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -323,17 +323,11 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 /*
  * Copy up a single dentry
  *
- * Directory renames only allowed on "pure upper" (already created on
- * upper filesystem, never copied up).  Directories which are on lower or
- * are merged may not be renamed.  For these -EXDEV is returned and
- * userspace has to deal with it.  This means, when copying up a
- * directory we can rely on it and ancestors being stable.
- *
- * Non-directory renames start with copy up of source if necessary.  The
- * actual rename will only proceed once the copy up was successful.  Copy
- * up uses upper parent i_mutex for exclusion.  Since rename can change
- * d_parent it is possible that the copy up will lock the old parent.  At
- * that point the file will have already been copied up anyway.
+ * All renames start with copy up of source if necessary.  The actual
+ * rename will only proceed once the copy up was successful.  Copy up uses
+ * upper parent i_mutex for exclusion.  Since rename can change d_parent it
+ * is possible that the copy up will lock the old parent.  At that point
+ * the file will have already been copied up anyway.
  */
 int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		    struct path *lowerpath, struct kstat *stat)
@@ -345,7 +339,6 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	struct path parentpath;
 	struct dentry *lowerdentry = lowerpath->dentry;
 	struct dentry *upperdir;
-	struct dentry *upperdentry;
 	const char *link = NULL;
 
 	if (WARN_ON(!workdir))
@@ -371,8 +364,7 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		pr_err("overlayfs: failed to lock workdir+upperdir\n");
 		goto out_unlock;
 	}
-	upperdentry = ovl_dentry_upper(dentry);
-	if (upperdentry) {
+	if (ovl_dentry_upper(dentry)) {
 		/* Raced with another copy-up?  Nothing to do, then... */
 		err = 0;
 		goto out_unlock;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 2c1057d747cb..065e0211f9b6 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -757,6 +757,40 @@ static bool ovl_type_merge_or_lower(struct dentry *dentry)
 	return OVL_TYPE_MERGE(type) || !OVL_TYPE_UPPER(type);
 }
 
+static bool ovl_can_move(struct dentry *dentry)
+{
+	return ovl_redirect_dir(dentry->d_sb) ||
+		!d_is_dir(dentry) || !ovl_type_merge_or_lower(dentry);
+}
+
+static int ovl_set_redirect(struct dentry *dentry)
+{
+	char *buf;
+	char *path;
+	int err;
+
+	if (ovl_dentry_is_redirect(dentry))
+		return 0;
+
+	buf = __getname();
+	if (!buf)
+		return -ENOMEM;
+
+	path = dentry_path_raw(dentry, buf, PATH_MAX);
+	err = PTR_ERR(path);
+	if (IS_ERR(path))
+		goto putname;
+
+	err = ovl_do_setxattr(ovl_dentry_upper(dentry), OVL_XATTR_REDIRECT,
+			      path, strlen(path), 0);
+putname:
+	__putname(buf);
+	if (!err)
+		ovl_dentry_set_redirect(dentry);
+
+	return err;
+}
+
 static int ovl_rename(struct inode *olddir, struct dentry *old,
 		      struct inode *newdir, struct dentry *new,
 		      unsigned int flags)
@@ -784,9 +818,9 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 
 	/* Don't copy up directory trees */
 	err = -EXDEV;
-	if (is_dir && ovl_type_merge_or_lower(old))
+	if (!ovl_can_move(old))
 		goto out;
-	if (!overwrite && new_is_dir && ovl_type_merge_or_lower(new))
+	if (!overwrite && !ovl_can_move(new))
 		goto out;
 
 	err = ovl_want_write(old);
@@ -837,7 +871,6 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 
 	trap = lock_rename(new_upperdir, old_upperdir);
 
-
 	olddentry = lookup_one_len(old->d_name.name, old_upperdir,
 				   old->d_name.len);
 	err = PTR_ERR(olddentry);
@@ -880,31 +913,34 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	if (WARN_ON(olddentry->d_inode == newdentry->d_inode))
 		goto out_dput;
 
-	if (is_dir && !old_opaque && ovl_lower_positive(new)) {
-		err = ovl_set_opaque(olddentry);
-		if (err)
-			goto out_dput;
-		ovl_dentry_set_opaque(old, true);
+	if (is_dir) {
+		if (ovl_type_merge_or_lower(old)) {
+			err = ovl_set_redirect(old);
+			if (err)
+				goto out_dput;
+		} else if (!old_opaque && ovl_lower_positive(new)) {
+			err = ovl_set_opaque(olddentry);
+			if (err)
+				goto out_dput;
+			ovl_dentry_set_opaque(old, true);
+		}
 	}
-	if (!overwrite &&
-	    new_is_dir && !new_opaque && ovl_lower_positive(old)) {
-		err = ovl_set_opaque(newdentry);
-		if (err)
-			goto out_dput;
-		ovl_dentry_set_opaque(new, true);
+	if (!overwrite && new_is_dir) {
+		if (ovl_type_merge_or_lower(new)) {
+			err = ovl_set_redirect(new);
+			if (err)
+				goto out_dput;
+		} else if (!new_opaque && ovl_lower_positive(old)) {
+			err = ovl_set_opaque(newdentry);
+			if (err)
+				goto out_dput;
+			ovl_dentry_set_opaque(new, true);
+		}
 	}
 
-	if (old_opaque || new_opaque) {
-		err = ovl_do_rename(old_upperdir->d_inode, olddentry,
-				    new_upperdir->d_inode, newdentry,
-				    flags);
-	} else {
-		/* No debug for the plain case */
-		BUG_ON(flags & ~RENAME_EXCHANGE);
-		err = vfs_rename(old_upperdir->d_inode, olddentry,
-				 new_upperdir->d_inode, newdentry,
-				 NULL, flags);
-	}
+	err = ovl_do_rename(old_upperdir->d_inode, olddentry,
+			    new_upperdir->d_inode, newdentry,
+			    flags);
 	if (err)
 		goto out_dput;
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index f4057fcb0246..c7cacbb8ce09 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/xattr.h>
 #include "overlayfs.h"
@@ -48,6 +49,28 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
 	return false;
 }
 
+static int ovl_check_redirect(struct dentry *dentry, char **bufp)
+{
+	int res;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, NULL, 0);
+	if (res > 0) {
+		char *buf = kzalloc(res + 1, GFP_KERNEL);
+
+		if (!buf)
+			return -ENOMEM;
+
+		res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, buf, res);
+		if (res < 0)
+			return res;
+
+		kfree(*bufp);
+		*bufp = buf;
+	}
+
+	return 0;
+}
+
 /*
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
@@ -80,11 +103,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	unsigned int ctr = 0;
 	struct inode *inode = NULL;
 	bool upperopaque = false;
+	bool upperredirect = false;
 	bool stop = false;
 	bool isdir = false;
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	char *redirect = NULL;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	upperdir = ovl_upperdentry_dereference(poe);
@@ -110,11 +135,23 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 				isdir = true;
 				if (poe->numlower && ovl_is_opaquedir(this))
 					stop = upperopaque = true;
+				else if (ovl_redirect_dir(dentry->d_sb)) {
+					err = ovl_check_redirect(this,
+								 &redirect);
+					if (err)
+						goto out;
+
+					if (redirect)
+						upperredirect = true;
+				}
 			}
 		}
 		upperdentry = this;
 	}
 
+	if (redirect)
+		poe = dentry->d_sb->s_root->d_fsdata;
+
 	if (!stop && poe->numlower) {
 		err = -ENOMEM;
 		stack = kcalloc(poe->numlower, sizeof(struct path), GFP_KERNEL);
@@ -125,15 +162,39 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	for (i = 0; !stop && i < poe->numlower; i++) {
 		struct path lowerpath = poe->lowerstack[i];
 
-		this = ovl_lookup_real(lowerpath.dentry, &dentry->d_name);
-		err = PTR_ERR(this);
-		if (IS_ERR(this)) {
-			/*
-			 * If it's positive, then treat ENAMETOOLONG as ENOENT.
-			 */
-			if (err == -ENAMETOOLONG && (upperdentry || ctr))
-				continue;
-			goto out_put;
+		if (!redirect) {
+			this = ovl_lookup_real(lowerpath.dentry, &dentry->d_name);
+			err = PTR_ERR(this);
+			if (IS_ERR(this)) {
+				/*
+				 * If it's positive, then treat ENAMETOOLONG as ENOENT.
+				 */
+				if (err == -ENAMETOOLONG && (upperdentry || ctr))
+					continue;
+				goto out_put;
+			}
+		} else {
+			struct path thispath;
+
+			err = vfs_path_lookup(lowerpath.dentry, lowerpath.mnt,
+					      redirect, 0, &thispath);
+
+			if (err) {
+				if (err == -ENOENT || err == -ENAMETOOLONG)
+					this = NULL;
+			} else {
+				this = thispath.dentry;
+				mntput(thispath.mnt);
+				if (!this->d_inode) {
+					dput(this);
+					this = NULL;
+				} else if (ovl_dentry_weird(this)) {
+					dput(this);
+					err = -EREMOTE;
+				}
+			}
+			if (err)
+				goto out_put;
 		}
 		if (!this)
 			continue;
@@ -162,6 +223,23 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		stack[ctr].dentry = this;
 		stack[ctr].mnt = lowerpath.mnt;
 		ctr++;
+
+		if (!stop && i != poe->numlower - 1 &&
+		    d_is_dir(this) && ovl_redirect_dir(dentry->d_sb)) {
+			err = ovl_check_redirect(this, &redirect);
+			if (err)
+				goto out_put;
+
+			if (redirect && poe != dentry->d_sb->s_root->d_fsdata) {
+				poe = dentry->d_sb->s_root->d_fsdata;
+
+				for (i = 0; i < poe->numlower; i++)
+					if (poe->lowerstack[i].mnt == lowerpath.mnt)
+						break;
+				if (WARN_ON(i == poe->numlower))
+					break;
+			}
+		}
 	}
 
 	oe = ovl_alloc_entry(ctr);
@@ -192,9 +270,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	revert_creds(old_cred);
 	oe->opaque = upperopaque;
+	oe->redirect = upperredirect;
 	oe->__upperdentry = upperdentry;
 	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
 	kfree(stack);
+	kfree(redirect);
 	dentry->d_fsdata = oe;
 	d_add(dentry, inode);
 
@@ -209,6 +289,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 out_put_upper:
 	dput(upperdentry);
 out:
+	kfree(redirect);
 	revert_creds(old_cred);
 	return ERR_PTR(err);
 }
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d61d5b9d0d91..9d80ce367ad8 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -20,6 +20,7 @@ enum ovl_path_type {
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
 #define OVL_XATTR_FEATURES OVL_XATTR_PREFIX "features"
+#define OVL_XATTR_REDIRECT OVL_XATTR_PREFIX "redirect"
 
 #define OVL_ISUPPER_MASK 1UL
 
@@ -157,6 +158,9 @@ void ovl_set_dir_cache(struct dentry *dentry, struct ovl_dir_cache *cache);
 bool ovl_dentry_is_opaque(struct dentry *dentry);
 bool ovl_dentry_is_whiteout(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry, bool opaque);
+bool ovl_redirect_dir(struct super_block *sb);
+bool ovl_dentry_is_redirect(struct dentry *dentry);
+void ovl_dentry_set_redirect(struct dentry *dentry);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 3b7ba59ad27e..2b22645535ff 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -26,6 +26,9 @@ struct ovl_fs {
 	struct ovl_config config;
 	/* creds of process who forced instantiation of super block */
 	const struct cred *creator_cred;
+
+	/* Check for "redirect" on directories */
+	bool redirect_dir;
 };
 
 /* private information held for every overlayfs dentry */
@@ -36,6 +39,7 @@ struct ovl_entry {
 		struct {
 			u64 version;
 			bool opaque;
+			bool redirect;
 		};
 		struct rcu_head rcu;
 	};
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d6dc8d905d00..fc22a8a2e0d0 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -397,7 +397,7 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
 	goto out_unlock;
 }
 
-static int ovl_check_features(struct dentry *root)
+static int ovl_check_features(struct ovl_fs *ufs, struct dentry *root)
 {
 	int res;
 	char *buf, *tmp, *p;
@@ -421,8 +421,12 @@ static int ovl_check_features(struct dentry *root)
 	res = 0;
 	tmp = buf;
 	while ((p = strsep(&tmp, ",")) != NULL) {
-		res = -EINVAL;
-		pr_err("overlayfs: feature '%s' not supported\n", p);
+		if (strcmp(p, "redirect_dir") == 0) {
+			ufs->redirect_dir = true;
+		} else {
+			res = -EINVAL;
+			pr_err("overlayfs: feature '%s' not supported\n", p);
+		}
 	}
 out_free:
 	kfree(buf);
@@ -494,8 +498,8 @@ static int ovl_mount_dir(const char *name, struct path *path)
 	return err;
 }
 
-static int ovl_lower_dir(const char *name, struct path *path, long *namelen,
-			 int *stack_depth, bool *remote)
+static int ovl_lower_dir(const char *name, struct path *path,
+			 struct ovl_fs *ufs, int *stack_depth, bool *remote)
 {
 	int err;
 	struct kstatfs statfs;
@@ -504,7 +508,7 @@ static int ovl_lower_dir(const char *name, struct path *path, long *namelen,
 	if (err)
 		goto out;
 
-	err = ovl_check_features(path->dentry);
+	err = ovl_check_features(ufs, path->dentry);
 	if (err)
 		goto out_put;
 
@@ -513,7 +517,7 @@ static int ovl_lower_dir(const char *name, struct path *path, long *namelen,
 		pr_err("overlayfs: statfs failed on '%s'\n", name);
 		goto out_put;
 	}
-	*namelen = max(*namelen, statfs.f_namelen);
+	ufs->lower_namelen = max(ufs->lower_namelen, statfs.f_namelen);
 	*stack_depth = max(*stack_depth, path->mnt->mnt_sb->s_stack_depth);
 
 	if (ovl_dentry_remote(path->dentry))
@@ -730,7 +734,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			goto out_put_upperpath;
 		}
 
-		err = ovl_check_features(upperpath.dentry);
+		err = ovl_check_features(ufs, upperpath.dentry);
 		if (err)
 			goto out_put_upperpath;
 
@@ -771,9 +775,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	lower = lowertmp;
 	for (numlower = 0; numlower < stacklen; numlower++) {
-		err = ovl_lower_dir(lower, &stack[numlower],
-				    &ufs->lower_namelen, &sb->s_stack_depth,
-				    &remote);
+		err = ovl_lower_dir(lower, &stack[numlower], ufs,
+				    &sb->s_stack_depth, &remote);
 		if (err)
 			goto out_put_lowerpath;
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 0d45a84468d2..06dae4cabd53 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -176,6 +176,25 @@ void ovl_dentry_set_opaque(struct dentry *dentry, bool opaque)
 	oe->opaque = opaque;
 }
 
+bool ovl_redirect_dir(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->redirect_dir;
+}
+
+bool ovl_dentry_is_redirect(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+	return oe->redirect;
+}
+
+void ovl_dentry_set_redirect(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+	oe->redirect = true;
+}
+
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-- 
2.5.5

