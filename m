From: David Howells <dhowells@redhat.com>
Subject: [PATCH 3/4] Overlayfs: Wrap accesses to ->d_inode on subordinate
 filesystems
Date: Thu, 16 Apr 2015 15:43:09 +0100
Message-ID: <20150416144309.12620.38093.stgit@warthog.procyon.org.uk>
References: <20150416144241.12620.85836.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20150416144241.12620.85836.stgit@warthog.procyon.org.uk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Convert ->d_inode to d_backing_inode() or d_is_xxx() when it is being used to
access an inode on a subordinate filesystem of an overlay - even if that
subordinate is itself an overlay.

Accesses to an overlay's own inodes should be accessed using d_inode() and
d_really_is_positive/negative().

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/copy_up.c |   18 ++++++++---------
 fs/overlayfs/dir.c     |   52 ++++++++++++++++++++++++------------------------
 fs/overlayfs/inode.c   |   12 ++++++-----
 fs/overlayfs/readdir.c |    6 +++---
 fs/overlayfs/super.c   |   21 ++++++++++---------
 5 files changed, 55 insertions(+), 54 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 24f640441bd9..217c604b7b81 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -26,8 +26,8 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 	char *buf, *name, *value;
 	int error;
 
-	if (!old->d_inode->i_op->getxattr ||
-	    !new->d_inode->i_op->getxattr)
+	if (!d_backing_inode(old)->i_op->getxattr ||
+	    !d_backing_inode(new)->i_op->getxattr)
 		return 0;
 
 	list_size = vfs_listxattr(old, NULL, 0);
@@ -126,7 +126,7 @@ static char *ovl_read_symlink(struct dentry *realdentry)
 {
 	int res;
 	char *buf;
-	struct inode *inode = realdentry->d_inode;
+	struct inode *inode = d_backing_inode(realdentry);
 	mm_segment_t old_fs;
 
 	res = -EINVAL;
@@ -198,8 +198,8 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 			      struct kstat *stat, struct iattr *attr,
 			      const char *link)
 {
-	struct inode *wdir = workdir->d_inode;
-	struct inode *udir = upperdir->d_inode;
+	struct inode *wdir = d_backing_inode(workdir);
+	struct inode *udir = d_backing_inode(upperdir);
 	struct dentry *newdentry = NULL;
 	struct dentry *upper = NULL;
 	umode_t mode = stat->mode;
@@ -238,11 +238,11 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out_cleanup;
 
-	mutex_lock(&newdentry->d_inode->i_mutex);
+	mutex_lock(&d_backing_inode(newdentry)->i_mutex);
 	err = ovl_set_attr(newdentry, stat);
 	if (!err && attr)
 		err = notify_change(newdentry, attr, NULL);
-	mutex_unlock(&newdentry->d_inode->i_mutex);
+	mutex_unlock(&d_backing_inode(newdentry)->i_mutex);
 	if (err)
 		goto out_cleanup;
 
@@ -346,9 +346,9 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		err = 0;
 		/* Raced with another copy-up?  Do the setattr here */
 		if (attr) {
-			mutex_lock(&upperdentry->d_inode->i_mutex);
+			mutex_lock(&d_backing_inode(upperdentry)->i_mutex);
 			err = notify_change(upperdentry, attr, NULL);
-			mutex_unlock(&upperdentry->d_inode->i_mutex);
+			mutex_unlock(&d_backing_inode(upperdentry)->i_mutex);
 		}
 		goto out_put_cred;
 	}
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 7b15d88d704e..ff4d90e482cd 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -39,7 +39,7 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir, struct dentry *dentry)
 	snprintf(name, sizeof(name), "#%lx", (unsigned long) dentry);
 
 	temp = lookup_one_len(name, workdir, strlen(name));
-	if (!IS_ERR(temp) && temp->d_inode) {
+	if (!IS_ERR(temp) && d_is_positive(temp)) {
 		pr_err("overlayfs: workdir/%s already exists\n", name);
 		dput(temp);
 		temp = ERR_PTR(-EIO);
@@ -164,7 +164,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 			    struct dentry *hardlink)
 {
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
-	struct inode *udir = upperdir->d_inode;
+	struct inode *udir = d_backing_inode(upperdir);
 	struct dentry *newdentry;
 	int err;
 
@@ -180,7 +180,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 
 	ovl_dentry_version_inc(dentry->d_parent);
 	ovl_dentry_update(dentry, newdentry);
-	ovl_copyattr(newdentry->d_inode, inode);
+	ovl_copyattr(d_backing_inode(newdentry), inode);
 	d_instantiate(dentry, inode);
 	newdentry = NULL;
 out_dput:
@@ -214,9 +214,9 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 				      struct list_head *list)
 {
 	struct dentry *workdir = ovl_workdir(dentry);
-	struct inode *wdir = workdir->d_inode;
+	struct inode *wdir = d_backing_inode(workdir);
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
-	struct inode *udir = upperdir->d_inode;
+	struct inode *udir = d_backing_inode(upperdir);
 	struct path upperpath;
 	struct dentry *upper;
 	struct dentry *opaquedir;
@@ -236,7 +236,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (!S_ISDIR(stat.mode))
 		goto out_unlock;
 	upper = upperpath.dentry;
-	if (upper->d_parent->d_inode != udir)
+	if (d_backing_inode(upper->d_parent) != udir)
 		goto out_unlock;
 
 	opaquedir = ovl_lookup_temp(workdir, dentry);
@@ -256,9 +256,9 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (err)
 		goto out_cleanup;
 
-	mutex_lock(&opaquedir->d_inode->i_mutex);
+	mutex_lock(&d_backing_inode(opaquedir)->i_mutex);
 	err = ovl_set_attr(opaquedir, &stat);
-	mutex_unlock(&opaquedir->d_inode->i_mutex);
+	mutex_unlock(&d_backing_inode(opaquedir)->i_mutex);
 	if (err)
 		goto out_cleanup;
 
@@ -316,9 +316,9 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 				    struct dentry *hardlink)
 {
 	struct dentry *workdir = ovl_workdir(dentry);
-	struct inode *wdir = workdir->d_inode;
+	struct inode *wdir = d_backing_inode(workdir);
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
-	struct inode *udir = upperdir->d_inode;
+	struct inode *udir = d_backing_inode(upperdir);
 	struct dentry *upper;
 	struct dentry *newdentry;
 	int err;
@@ -360,7 +360,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	}
 	ovl_dentry_version_inc(dentry->d_parent);
 	ovl_dentry_update(dentry, newdentry);
-	ovl_copyattr(newdentry->d_inode, inode);
+	ovl_copyattr(d_backing_inode(newdentry), inode);
 	d_instantiate(dentry, inode);
 	newdentry = NULL;
 out_dput2:
@@ -488,7 +488,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 		goto out_drop_write;
 
 	upper = ovl_dentry_upper(old);
-	err = ovl_create_or_link(new, upper->d_inode->i_mode, 0, NULL, upper);
+	err = ovl_create_or_link(new, d_backing_inode(upper)->i_mode, 0, NULL, upper);
 
 out_drop_write:
 	ovl_drop_write(old);
@@ -499,9 +499,9 @@ out:
 static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 {
 	struct dentry *workdir = ovl_workdir(dentry);
-	struct inode *wdir = workdir->d_inode;
+	struct inode *wdir = d_backing_inode(workdir);
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
-	struct inode *udir = upperdir->d_inode;
+	struct inode *udir = d_backing_inode(upperdir);
 	struct dentry *whiteout;
 	struct dentry *upper;
 	struct dentry *opaquedir = NULL;
@@ -573,7 +573,7 @@ kill_whiteout:
 static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 {
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
-	struct inode *dir = upperdir->d_inode;
+	struct inode *dir = d_backing_inode(upperdir);
 	struct dentry *upper = ovl_dentry_upper(dentry);
 	int err;
 
@@ -604,8 +604,8 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 
 static inline int ovl_check_sticky(struct dentry *dentry)
 {
-	struct inode *dir = ovl_dentry_real(dentry->d_parent)->d_inode;
-	struct inode *inode = ovl_dentry_real(dentry)->d_inode;
+	struct inode *dir = d_backing_inode(ovl_dentry_real(dentry->d_parent));
+	struct inode *inode = d_backing_inode(ovl_dentry_real(dentry));
 
 	if (check_sticky(dir, inode))
 		return -EPERM;
@@ -731,13 +731,13 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 
 		err = 0;
 		if (!OVL_TYPE_UPPER(new_type) && !OVL_TYPE_UPPER(old_type)) {
-			if (ovl_dentry_lower(old)->d_inode ==
-			    ovl_dentry_lower(new)->d_inode)
+			if (d_backing_inode(ovl_dentry_lower(old)) ==
+			    d_backing_inode(ovl_dentry_lower(new)))
 				goto out;
 		}
 		if (OVL_TYPE_UPPER(new_type) && OVL_TYPE_UPPER(old_type)) {
-			if (ovl_dentry_upper(old)->d_inode ==
-			    ovl_dentry_upper(new)->d_inode)
+			if (d_backing_inode(ovl_dentry_upper(old)) ==
+			    d_backing_inode(ovl_dentry_upper(new)))
 				goto out;
 		}
 	} else {
@@ -857,14 +857,14 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 	}
 
 	if (old_opaque || new_opaque) {
-		err = ovl_do_rename(old_upperdir->d_inode, olddentry,
-				    new_upperdir->d_inode, newdentry,
+		err = ovl_do_rename(d_backing_inode(old_upperdir), olddentry,
+				    d_backing_inode(new_upperdir), newdentry,
 				    flags);
 	} else {
 		/* No debug for the plain case */
 		BUG_ON(flags & ~RENAME_EXCHANGE);
-		err = vfs_rename(old_upperdir->d_inode, olddentry,
-				 new_upperdir->d_inode, newdentry,
+		err = vfs_rename(d_backing_inode(old_upperdir), olddentry,
+				 d_backing_inode(new_upperdir), newdentry,
 				 NULL, flags);
 	}
 
@@ -888,7 +888,7 @@ static int ovl_rename2(struct inode *olddir, struct dentry *old,
 	}
 
 	if (cleanup_whiteout)
-		ovl_cleanup(old_upperdir->d_inode, newdentry);
+		ovl_cleanup(d_backing_inode(old_upperdir), newdentry);
 
 	ovl_dentry_version_inc(old->d_parent);
 	ovl_dentry_version_inc(new->d_parent);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 8c8f024edcc0..ead6a7a6fe9d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -51,9 +51,9 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 
 	upperdentry = ovl_dentry_upper(dentry);
 	if (upperdentry) {
-		mutex_lock(&upperdentry->d_inode->i_mutex);
+		mutex_lock(&d_backing_inode(upperdentry)->i_mutex);
 		err = notify_change(upperdentry, attr, NULL);
-		mutex_unlock(&upperdentry->d_inode->i_mutex);
+		mutex_unlock(&d_backing_inode(upperdentry)->i_mutex);
 	} else {
 		err = ovl_copy_up_last(dentry, attr, false);
 	}
@@ -147,7 +147,7 @@ static void *ovl_follow_link(struct dentry *dentry, struct nameidata *nd)
 	struct inode *realinode;
 
 	realdentry = ovl_dentry_real(dentry);
-	realinode = realdentry->d_inode;
+	realinode = d_backing_inode(realdentry);
 
 	if (WARN_ON(!realinode->i_op->follow_link))
 		return ERR_PTR(-EPERM);
@@ -181,7 +181,7 @@ static void ovl_put_link(struct dentry *dentry, struct nameidata *nd, void *c)
 	if (!data)
 		return;
 
-	realinode = data->realdentry->d_inode;
+	realinode = d_backing_inode(data->realdentry);
 	realinode->i_op->put_link(data->realdentry, nd, data->cookie);
 	kfree(data);
 }
@@ -192,7 +192,7 @@ static int ovl_readlink(struct dentry *dentry, char __user *buf, int bufsiz)
 	struct inode *realinode;
 
 	ovl_path_real(dentry, &realpath);
-	realinode = realpath.dentry->d_inode;
+	realinode = d_backing_inode(realpath.dentry);
 
 	if (!realinode->i_op->readlink)
 		return -EINVAL;
@@ -327,7 +327,7 @@ static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
 	if (OVL_TYPE_UPPER(type))
 		return false;
 
-	if (special_file(realdentry->d_inode->i_mode))
+	if (d_is_special(realdentry))
 		return false;
 
 	if (!(OPEN_FMODE(flags) & FMODE_WRITE) && !(flags & O_TRUNC))
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 907870e81a72..af175de51bad 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -536,7 +536,7 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list)
 {
 	struct ovl_cache_entry *p;
 
-	mutex_lock_nested(&upper->d_inode->i_mutex, I_MUTEX_CHILD);
+	mutex_lock_nested(&d_backing_inode(upper)->i_mutex, I_MUTEX_CHILD);
 	list_for_each_entry(p, list, l_node) {
 		struct dentry *dentry;
 
@@ -550,8 +550,8 @@ void ovl_cleanup_whiteouts(struct dentry *upper, struct list_head *list)
 			       (int) PTR_ERR(dentry));
 			continue;
 		}
-		ovl_cleanup(upper->d_inode, dentry);
+		ovl_cleanup(d_backing_inode(upper), dentry);
 		dput(dentry);
 	}
-	mutex_unlock(&upper->d_inode->i_mutex);
+	mutex_unlock(&d_backing_inode(upper)->i_mutex);
 }
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c1ae2b5e1f4e..fc6057557201 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -209,9 +209,9 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	WARN_ON(!mutex_is_locked(&upperdentry->d_parent->d_inode->i_mutex));
+	WARN_ON(!mutex_is_locked(&d_backing_inode(upperdentry->d_parent)->i_mutex));
 	WARN_ON(oe->__upperdentry);
-	BUG_ON(!upperdentry->d_inode);
+	BUG_ON(!d_backing_inode(upperdentry));
 	/*
 	 * Make sure upperdentry is consistent before making it visible to
 	 * ovl_upperdentry_dereference().
@@ -293,14 +293,14 @@ static inline struct dentry *ovl_lookup_real(struct dentry *dir,
 {
 	struct dentry *dentry;
 
-	mutex_lock(&dir->d_inode->i_mutex);
+	mutex_lock(&d_backing_inode(dir)->i_mutex);
 	dentry = lookup_one_len(name->name, dir, name->len);
-	mutex_unlock(&dir->d_inode->i_mutex);
+	mutex_unlock(&d_backing_inode(dir)->i_mutex);
 
 	if (IS_ERR(dentry)) {
 		if (PTR_ERR(dentry) == -ENOENT)
 			dentry = NULL;
-	} else if (!dentry->d_inode) {
+	} else if (d_is_miss(dentry)) {
 		dput(dentry);
 		dentry = NULL;
 	}
@@ -427,15 +427,16 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (upperdentry || ctr) {
 		struct dentry *realdentry;
+		struct inode *realinode;
 
 		realdentry = upperdentry ? upperdentry : stack[0].dentry;
+		realinode = d_backing_inode(realdentry);
 
 		err = -ENOMEM;
-		inode = ovl_new_inode(dentry->d_sb, realdentry->d_inode->i_mode,
-				      oe);
+		inode = ovl_new_inode(dentry->d_sb, realinode->i_mode, oe);
 		if (!inode)
 			goto out_free_oe;
-		ovl_copyattr(realdentry->d_inode, inode);
+		ovl_copyattr(realinode, inode);
 	}
 
 	oe->opaque = upperopaque;
@@ -635,7 +636,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
 					 struct dentry *dentry)
 {
-	struct inode *dir = dentry->d_inode;
+	struct inode *dir = d_backing_inode(dentry);
 	struct dentry *work;
 	int err;
 	bool retried = false;
@@ -654,7 +655,7 @@ retry:
 			.mode = S_IFDIR | 0,
 		};
 
-		if (work->d_inode) {
+		if (d_backing_inode(work)) {
 			err = -EEXIST;
 			if (retried)
 				goto out_dput;

