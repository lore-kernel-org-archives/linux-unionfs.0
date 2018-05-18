Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 4/9] ovl: create helper ovl_create_temp()
Date: Fri, 18 May 2018 11:29:32 +0300
Message-Id: <1526632177-28832-5-git-send-email-amir73il@gmail.com>
In-Reply-To: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Al Viro suggested to simplify callers of ovl_create_real() by
returning the created dentry (or ERR_PTR) from ovl_create_real().
This prep patch makes Al's patch change less callers.

Also used ovl_create_temp() in ovl_create_index() instead of calling
ovl_do_mkdir() directly, so now all callers of ovl_do_mkdir() are routed
through ovl_create_real(), which paves the way for Al's fix for non-hashed
result from vfs_mkdir().

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 26 +++++++-------------------
 fs/overlayfs/dir.c       | 44 +++++++++++++++++++++++++++-----------------
 fs/overlayfs/overlayfs.h |  3 ++-
 3 files changed, 36 insertions(+), 37 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 5f4c78b1bbeb..f3024060be42 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -365,14 +365,10 @@ static int ovl_create_index(struct dentry *dentry, struct dentry *origin,
 	if (err)
 		return err;
 
-	temp = ovl_lookup_temp(indexdir);
+	temp = ovl_create_temp(indexdir, OVL_CATTR(S_IFDIR | 0));
 	if (IS_ERR(temp))
 		goto temp_err;
 
-	err = ovl_do_mkdir(dir, temp, S_IFDIR);
-	if (err)
-		goto out;
-
 	err = ovl_set_upper_fh(upper, temp);
 	if (err)
 		goto out_cleanup;
@@ -500,21 +496,13 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
 	if (new_creds)
 		old_creds = override_creds(new_creds);
 
-	if (c->tmpfile) {
+	if (c->tmpfile)
 		temp = ovl_do_tmpfile(c->workdir, c->stat.mode);
-		if (IS_ERR(temp))
-			goto temp_err;
-	} else {
-		temp = ovl_lookup_temp(c->workdir);
-		if (IS_ERR(temp))
-			goto temp_err;
-
-		err = ovl_create_real(d_inode(c->workdir), temp, &cattr);
-		if (err) {
-			dput(temp);
-			goto out;
-		}
-	}
+	else
+		temp = ovl_create_temp(c->workdir, &cattr);
+	if (IS_ERR(temp))
+		goto temp_err;
+
 	err = 0;
 	*tempp = temp;
 out:
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 4b172faa3d29..41a8940964e3 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -160,6 +160,25 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 	return err;
 }
 
+struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr)
+{
+	struct inode *wdir = workdir->d_inode;
+	struct dentry *temp;
+	int err;
+
+	temp = ovl_lookup_temp(workdir);
+	if (IS_ERR(temp))
+		return temp;
+
+	err = ovl_create_real(wdir, temp, attr);
+	if (err) {
+		dput(temp);
+		return ERR_PTR(err);
+	}
+
+	return temp;
+}
+
 static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
 			       int xerr)
 {
@@ -280,15 +299,11 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (upper->d_parent->d_inode != udir)
 		goto out_unlock;
 
-	opaquedir = ovl_lookup_temp(workdir);
+	opaquedir = ovl_create_temp(workdir, OVL_CATTR(stat.mode));
 	err = PTR_ERR(opaquedir);
 	if (IS_ERR(opaquedir))
 		goto out_unlock;
 
-	err = ovl_create_real(wdir, opaquedir, OVL_CATTR(stat.mode));
-	if (err)
-		goto out_dput;
-
 	err = ovl_copy_xattr(upper, opaquedir);
 	if (err)
 		goto out_cleanup;
@@ -318,7 +333,6 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 
 out_cleanup:
 	ovl_cleanup(wdir, opaquedir);
-out_dput:
 	dput(opaquedir);
 out_unlock:
 	unlock_rename(workdir, upperdir);
@@ -379,20 +393,16 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (err)
 		goto out;
 
-	newdentry = ovl_lookup_temp(workdir);
-	err = PTR_ERR(newdentry);
-	if (IS_ERR(newdentry))
-		goto out_unlock;
-
 	upper = lookup_one_len(dentry->d_name.name, upperdir,
 			       dentry->d_name.len);
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
-		goto out_dput;
+		goto out_unlock;
 
-	err = ovl_create_real(wdir, newdentry, cattr);
-	if (err)
-		goto out_dput2;
+	newdentry = ovl_create_temp(workdir, cattr);
+	err = PTR_ERR(newdentry);
+	if (IS_ERR(newdentry))
+		goto out_dput;
 
 	/*
 	 * mode could have been mutilated due to umask (e.g. sgid directory)
@@ -441,9 +451,9 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	ovl_instantiate(dentry, inode, newdentry, hardlink);
 	newdentry = NULL;
 out_dput2:
-	dput(upper);
-out_dput:
 	dput(newdentry);
+out_dput:
+	dput(upper);
 out_unlock:
 	unlock_rename(workdir, upperdir);
 out:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index fafaf9b255c5..e72eec6d440f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -360,6 +360,7 @@ static inline void ovl_copyflags(struct inode *from, struct inode *to)
 
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
+int ovl_cleanup(struct inode *dir, struct dentry *dentry);
 struct dentry *ovl_lookup_temp(struct dentry *workdir);
 int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
 			     struct dentry *dentry);
@@ -374,7 +375,7 @@ struct ovl_cattr {
 
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct ovl_cattr *attr);
-int ovl_cleanup(struct inode *dir, struct dentry *dentry);
+struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr);
 
 /* file.c */
 extern const struct file_operations ovl_file_operations;
-- 
2.7.4
