From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 04/11] ovl: struct cattr cleanups
Date: Tue, 29 May 2018 16:41:36 +0200
Message-ID: <20180529144143.16378-5-mszeredi@redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

* Rename to ovl_cattr

* Fold ovl_create_real() hardlink argument into struct ovl_cattr

* Create macro OVL_CATTR() to initialize struct ovl_cattr from mode

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c   |  5 ++---
 fs/overlayfs/dir.c       | 45 +++++++++++++++++++++------------------------
 fs/overlayfs/overlayfs.h |  9 ++++++---
 fs/overlayfs/super.c     |  4 +---
 4 files changed, 30 insertions(+), 33 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a8273dec0fb8..5f4c78b1bbeb 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -486,7 +486,7 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
 	struct dentry *temp;
 	const struct cred *old_creds = NULL;
 	struct cred *new_creds = NULL;
-	struct cattr cattr = {
+	struct ovl_cattr cattr = {
 		/* Can't properly set mode on creation because of the umask */
 		.mode = c->stat.mode & S_IFMT,
 		.rdev = c->stat.rdev,
@@ -509,8 +509,7 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
 		if (IS_ERR(temp))
 			goto temp_err;
 
-		err = ovl_create_real(d_inode(c->workdir), temp, &cattr,
-				      NULL);
+		err = ovl_create_real(d_inode(c->workdir), temp, &cattr);
 		if (err) {
 			dput(temp);
 			goto out;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 4d431a3f7a0a..0fb3ef85f298 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -115,15 +115,15 @@ int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
 }
 
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
-		    struct cattr *attr, struct dentry *hardlink)
+		    struct ovl_cattr *attr)
 {
 	int err;
 
 	if (newdentry->d_inode)
 		return -ESTALE;
 
-	if (hardlink) {
-		err = ovl_do_link(hardlink, dir, newdentry);
+	if (attr->hardlink) {
+		err = ovl_do_link(attr->hardlink, dir, newdentry);
 	} else {
 		switch (attr->mode & S_IFMT) {
 		case S_IFREG:
@@ -213,14 +213,14 @@ static bool ovl_type_origin(struct dentry *dentry)
 }
 
 static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
-			    struct cattr *attr, struct dentry *hardlink)
+			    struct ovl_cattr *attr)
 {
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
 	struct inode *udir = upperdir->d_inode;
 	struct dentry *newdentry;
 	int err;
 
-	if (!hardlink && !IS_POSIXACL(udir))
+	if (!attr->hardlink && !IS_POSIXACL(udir))
 		attr->mode &= ~current_umask();
 
 	inode_lock_nested(udir, I_MUTEX_PARENT);
@@ -229,7 +229,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
 		goto out_unlock;
-	err = ovl_create_real(udir, newdentry, attr, hardlink);
+	err = ovl_create_real(udir, newdentry, attr);
 	if (err)
 		goto out_dput;
 
@@ -238,7 +238,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 		ovl_set_opaque(dentry, newdentry);
 	}
 
-	ovl_instantiate(dentry, inode, newdentry, !!hardlink);
+	ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink);
 	newdentry = NULL;
 out_dput:
 	dput(newdentry);
@@ -285,8 +285,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (IS_ERR(opaquedir))
 		goto out_unlock;
 
-	err = ovl_create_real(wdir, opaquedir,
-			      &(struct cattr){.mode = stat.mode}, NULL);
+	err = ovl_create_real(wdir, opaquedir, OVL_CATTR(stat.mode));
 	if (err)
 		goto out_dput;
 
@@ -354,8 +353,7 @@ static int ovl_set_upper_acl(struct dentry *upperdentry, const char *name,
 }
 
 static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
-				    struct cattr *cattr,
-				    struct dentry *hardlink)
+				    struct ovl_cattr *cattr)
 {
 	struct dentry *workdir = ovl_workdir(dentry);
 	struct inode *wdir = workdir->d_inode;
@@ -365,6 +363,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	struct dentry *newdentry;
 	int err;
 	struct posix_acl *acl, *default_acl;
+	bool hardlink = !!cattr->hardlink;
 
 	if (WARN_ON(!workdir))
 		return -EROFS;
@@ -391,7 +390,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(upper))
 		goto out_dput;
 
-	err = ovl_create_real(wdir, newdentry, cattr, hardlink);
+	err = ovl_create_real(wdir, newdentry, cattr);
 	if (err)
 		goto out_dput2;
 
@@ -439,7 +438,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		if (err)
 			goto out_cleanup;
 	}
-	ovl_instantiate(dentry, inode, newdentry, !!hardlink);
+	ovl_instantiate(dentry, inode, newdentry, hardlink);
 	newdentry = NULL;
 out_dput2:
 	dput(upper);
@@ -460,8 +459,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 }
 
 static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
-			      struct cattr *attr, struct dentry *hardlink,
-			      bool origin)
+			      struct ovl_cattr *attr, bool origin)
 {
 	int err;
 	const struct cred *old_cred;
@@ -489,7 +487,7 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 	if (override_cred) {
 		override_cred->fsuid = inode->i_uid;
 		override_cred->fsgid = inode->i_gid;
-		if (!hardlink) {
+		if (!attr->hardlink) {
 			err = security_dentry_create_files_as(dentry,
 					attr->mode, &dentry->d_name, old_cred,
 					override_cred);
@@ -502,11 +500,9 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		put_cred(override_cred);
 
 		if (!ovl_dentry_is_whiteout(dentry))
-			err = ovl_create_upper(dentry, inode, attr,
-						hardlink);
+			err = ovl_create_upper(dentry, inode, attr);
 		else
-			err = ovl_create_over_whiteout(dentry, inode, attr,
-							hardlink);
+			err = ovl_create_over_whiteout(dentry, inode, attr);
 	}
 out_revert_creds:
 	revert_creds(old_cred);
@@ -518,7 +514,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 {
 	int err;
 	struct inode *inode;
-	struct cattr attr = {
+	struct ovl_cattr attr = {
 		.rdev = rdev,
 		.link = link,
 	};
@@ -535,7 +531,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 	inode_init_owner(inode, dentry->d_parent->d_inode, mode);
 	attr.mode = inode->i_mode;
 
-	err = ovl_create_or_link(dentry, inode, &attr, NULL, false);
+	err = ovl_create_or_link(dentry, inode, &attr, false);
 	if (err)
 		iput(inode);
 
@@ -594,8 +590,9 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	inode = d_inode(old);
 	ihold(inode);
 
-	err = ovl_create_or_link(new, inode, NULL, ovl_dentry_upper(old),
-				 ovl_type_origin(old));
+	err = ovl_create_or_link(new, inode,
+			&(struct ovl_cattr) {.hardlink = ovl_dentry_upper(old)},
+			ovl_type_origin(old));
 	if (err)
 		iput(inode);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1c30d60cc290..aa8286419133 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -349,14 +349,17 @@ extern const struct inode_operations ovl_dir_inode_operations;
 struct dentry *ovl_lookup_temp(struct dentry *workdir);
 int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
 			     struct dentry *dentry);
-struct cattr {
+struct ovl_cattr {
 	dev_t rdev;
 	umode_t mode;
 	const char *link;
+	struct dentry *hardlink;
 };
+
+#define OVL_CATTR(m) (&(struct ovl_cattr) { .mode = (m) })
+
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
-		    struct cattr *attr,
-		    struct dentry *hardlink);
+		    struct ovl_cattr *attr);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
 /* copy_up.c */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 94a7a654b0b8..286d36772e9c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -611,9 +611,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 			goto retry;
 		}
 
-		err = ovl_create_real(dir, work,
-				      &(struct cattr){.mode = S_IFDIR | 0},
-				      NULL);
+		err = ovl_create_real(dir, work, OVL_CATTR(attr.ia_mode));
 		if (err)
 			goto out_dput;
 
-- 
2.14.3
