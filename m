From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 03/11] ovl: strip debug argument from ovl_do_ helpers
Date: Tue, 29 May 2018 16:41:35 +0200
Message-ID: <20180529144143.16378-4-mszeredi@redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

It did not prove to be useful.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c   |  9 ++++-----
 fs/overlayfs/dir.c       | 20 ++++++++++----------
 fs/overlayfs/overlayfs.h | 42 ++++++++++++++++++------------------------
 fs/overlayfs/super.c     |  2 +-
 4 files changed, 33 insertions(+), 40 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8bede0742619..a8273dec0fb8 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -369,7 +369,7 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 	if (IS_ERR(temp))
 		goto temp_err;
 
-	err = ovl_do_mkdir(dir, temp, S_IFDIR, true);
+	err = ovl_do_mkdir(dir, temp, S_IFDIR);
 	if (err)
 		goto out;
 
@@ -439,8 +439,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 			       c->dentry->d_name.len);
 	err = PTR_ERR(upper);
 	if (!IS_ERR(upper)) {
-		err = ovl_do_link(ovl_dentry_upper(c->dentry), udir, upper,
-				  true);
+		err = ovl_do_link(ovl_dentry_upper(c->dentry), udir, upper);
 		dput(upper);
 
 		if (!err) {
@@ -470,7 +469,7 @@ static int ovl_install_temp(struct ovl_copy_up_ctx *c, struct dentry *temp,
 		return PTR_ERR(upper);
 
 	if (c->tmpfile)
-		err = ovl_do_link(temp, udir, upper, true);
+		err = ovl_do_link(temp, udir, upper);
 	else
 		err = ovl_do_rename(d_inode(c->workdir), temp, udir, upper, 0);
 
@@ -511,7 +510,7 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
 			goto temp_err;
 
 		err = ovl_create_real(d_inode(c->workdir), temp, &cattr,
-				      NULL, true);
+				      NULL);
 		if (err) {
 			dput(temp);
 			goto out;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 01902adc7153..4d431a3f7a0a 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -115,7 +115,7 @@ int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
 }
 
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
-		    struct cattr *attr, struct dentry *hardlink, bool debug)
+		    struct cattr *attr, struct dentry *hardlink)
 {
 	int err;
 
@@ -123,27 +123,27 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		return -ESTALE;
 
 	if (hardlink) {
-		err = ovl_do_link(hardlink, dir, newdentry, debug);
+		err = ovl_do_link(hardlink, dir, newdentry);
 	} else {
 		switch (attr->mode & S_IFMT) {
 		case S_IFREG:
-			err = ovl_do_create(dir, newdentry, attr->mode, debug);
+			err = ovl_do_create(dir, newdentry, attr->mode);
 			break;
 
 		case S_IFDIR:
-			err = ovl_do_mkdir(dir, newdentry, attr->mode, debug);
+			err = ovl_do_mkdir(dir, newdentry, attr->mode);
 			break;
 
 		case S_IFCHR:
 		case S_IFBLK:
 		case S_IFIFO:
 		case S_IFSOCK:
-			err = ovl_do_mknod(dir, newdentry,
-					   attr->mode, attr->rdev, debug);
+			err = ovl_do_mknod(dir, newdentry, attr->mode,
+					   attr->rdev);
 			break;
 
 		case S_IFLNK:
-			err = ovl_do_symlink(dir, newdentry, attr->link, debug);
+			err = ovl_do_symlink(dir, newdentry, attr->link);
 			break;
 
 		default:
@@ -229,7 +229,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
 		goto out_unlock;
-	err = ovl_create_real(udir, newdentry, attr, hardlink, false);
+	err = ovl_create_real(udir, newdentry, attr, hardlink);
 	if (err)
 		goto out_dput;
 
@@ -286,7 +286,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 		goto out_unlock;
 
 	err = ovl_create_real(wdir, opaquedir,
-			      &(struct cattr){.mode = stat.mode}, NULL, true);
+			      &(struct cattr){.mode = stat.mode}, NULL);
 	if (err)
 		goto out_dput;
 
@@ -391,7 +391,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(upper))
 		goto out_dput;
 
-	err = ovl_create_real(wdir, newdentry, cattr, hardlink, true);
+	err = ovl_create_real(wdir, newdentry, cattr, hardlink);
 	if (err)
 		goto out_dput2;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e0b7de799f6b..1c30d60cc290 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -86,6 +86,7 @@ struct ovl_fh {
 static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_rmdir(dir, dentry);
+
 	pr_debug("rmdir(%pd2) = %i\n", dentry, err);
 	return err;
 }
@@ -93,56 +94,52 @@ static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 static inline int ovl_do_unlink(struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_unlink(dir, dentry, NULL);
+
 	pr_debug("unlink(%pd2) = %i\n", dentry, err);
 	return err;
 }
 
 static inline int ovl_do_link(struct dentry *old_dentry, struct inode *dir,
-			      struct dentry *new_dentry, bool debug)
+			      struct dentry *new_dentry)
 {
 	int err = vfs_link(old_dentry, dir, new_dentry, NULL);
-	if (debug) {
-		pr_debug("link(%pd2, %pd2) = %i\n",
-			 old_dentry, new_dentry, err);
-	}
+
+	pr_debug("link(%pd2, %pd2) = %i\n", old_dentry, new_dentry, err);
 	return err;
 }
 
 static inline int ovl_do_create(struct inode *dir, struct dentry *dentry,
-			     umode_t mode, bool debug)
+				umode_t mode)
 {
 	int err = vfs_create(dir, dentry, mode, true);
-	if (debug)
-		pr_debug("create(%pd2, 0%o) = %i\n", dentry, mode, err);
+
+	pr_debug("create(%pd2, 0%o) = %i\n", dentry, mode, err);
 	return err;
 }
 
 static inline int ovl_do_mkdir(struct inode *dir, struct dentry *dentry,
-			       umode_t mode, bool debug)
+			       umode_t mode)
 {
 	int err = vfs_mkdir(dir, dentry, mode);
-	if (debug)
-		pr_debug("mkdir(%pd2, 0%o) = %i\n", dentry, mode, err);
+	pr_debug("mkdir(%pd2, 0%o) = %i\n", dentry, mode, err);
 	return err;
 }
 
 static inline int ovl_do_mknod(struct inode *dir, struct dentry *dentry,
-			       umode_t mode, dev_t dev, bool debug)
+			       umode_t mode, dev_t dev)
 {
 	int err = vfs_mknod(dir, dentry, mode, dev);
-	if (debug) {
-		pr_debug("mknod(%pd2, 0%o, 0%o) = %i\n",
-			 dentry, mode, dev, err);
-	}
+
+	pr_debug("mknod(%pd2, 0%o, 0%o) = %i\n", dentry, mode, dev, err);
 	return err;
 }
 
 static inline int ovl_do_symlink(struct inode *dir, struct dentry *dentry,
-				 const char *oldname, bool debug)
+				 const char *oldname)
 {
 	int err = vfs_symlink(dir, dentry, oldname);
-	if (debug)
-		pr_debug("symlink(\"%s\", %pd2) = %i\n", oldname, dentry, err);
+
+	pr_debug("symlink(\"%s\", %pd2) = %i\n", oldname, dentry, err);
 	return err;
 }
 
@@ -168,11 +165,8 @@ static inline int ovl_do_rename(struct inode *olddir, struct dentry *olddentry,
 {
 	int err;
 
-	pr_debug("rename(%pd2, %pd2, 0x%x)\n",
-		 olddentry, newdentry, flags);
-
+	pr_debug("rename(%pd2, %pd2, 0x%x)\n", olddentry, newdentry, flags);
 	err = vfs_rename(olddir, olddentry, newdir, newdentry, NULL, flags);
-
 	if (err) {
 		pr_debug("...rename(%pd2, %pd2, ...) = %i\n",
 			 olddentry, newdentry, err);
@@ -362,7 +356,7 @@ struct cattr {
 };
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct cattr *attr,
-		    struct dentry *hardlink, bool debug);
+		    struct dentry *hardlink);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
 /* copy_up.c */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e8551c97de51..94a7a654b0b8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -613,7 +613,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 
 		err = ovl_create_real(dir, work,
 				      &(struct cattr){.mode = S_IFDIR | 0},
-				      NULL, true);
+				      NULL);
 		if (err)
 			goto out_dput;
 
-- 
2.14.3
