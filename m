From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 05/11] ovl: return dentry from ovl_create_real()
Date: Tue, 29 May 2018 16:41:37 +0200
Message-ID: <20180529144143.16378-6-mszeredi@redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Al Viro suggested to simplify callers of ovl_create_real() by
returning the created dentry (or ERR_PTR) from ovl_create_real().
This prep patch makes Al's patch change less callers.

Also used ovl_create_temp() in ovl_create_index() instead of calling
ovl_do_mkdir() directly, so now all callers of ovl_do_mkdir() are routed
through ovl_create_real(), which paves the way for Al's fix for non-hashed
result from vfs_mkdir().

Suggested-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c   | 15 ++++--------
 fs/overlayfs/dir.c       | 62 +++++++++++++++++++++++-------------------------
 fs/overlayfs/overlayfs.h |  4 ++--
 fs/overlayfs/super.c     |  7 +++---
 4 files changed, 40 insertions(+), 48 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 5f4c78b1bbeb..d3e9c1eeb7a4 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -502,19 +502,12 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
 
 	if (c->tmpfile) {
 		temp = ovl_do_tmpfile(c->workdir, c->stat.mode);
-		if (IS_ERR(temp))
-			goto temp_err;
 	} else {
-		temp = ovl_lookup_temp(c->workdir);
-		if (IS_ERR(temp))
-			goto temp_err;
-
-		err = ovl_create_real(d_inode(c->workdir), temp, &cattr);
-		if (err) {
-			dput(temp);
-			goto out;
-		}
+		temp = ovl_create_real(d_inode(c->workdir),
+				       ovl_lookup_temp(c->workdir), &cattr);
 	}
+	if (IS_ERR(temp))
+		goto temp_err;
 	err = 0;
 	*tempp = temp;
 out:
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 0fb3ef85f298..425ddb098c4a 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -114,13 +114,17 @@ int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
 	goto out;
 }
 
-int ovl_create_real(struct inode *dir, struct dentry *newdentry,
-		    struct ovl_cattr *attr)
+struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
+			       struct ovl_cattr *attr)
 {
 	int err;
 
+	if (IS_ERR(newdentry))
+		return newdentry;
+
+	err = -ESTALE;
 	if (newdentry->d_inode)
-		return -ESTALE;
+		goto out;
 
 	if (attr->hardlink) {
 		err = ovl_do_link(attr->hardlink, dir, newdentry);
@@ -157,7 +161,12 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		 */
 		err = -ENOENT;
 	}
-	return err;
+out:
+	if (err) {
+		dput(newdentry);
+		return ERR_PTR(err);
+	}
+	return newdentry;
 }
 
 static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
@@ -224,14 +233,14 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 		attr->mode &= ~current_umask();
 
 	inode_lock_nested(udir, I_MUTEX_PARENT);
-	newdentry = lookup_one_len(dentry->d_name.name, upperdir,
-				   dentry->d_name.len);
+	newdentry = ovl_create_real(udir,
+				    lookup_one_len(dentry->d_name.name,
+						   upperdir,
+						   dentry->d_name.len),
+				    attr);
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
 		goto out_unlock;
-	err = ovl_create_real(udir, newdentry, attr);
-	if (err)
-		goto out_dput;
 
 	if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry)) {
 		/* Setting opaque here is just an optimization, allow to fail */
@@ -239,9 +248,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	}
 
 	ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink);
-	newdentry = NULL;
-out_dput:
-	dput(newdentry);
+	err = 0;
 out_unlock:
 	inode_unlock(udir);
 	return err;
@@ -280,15 +287,12 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (upper->d_parent->d_inode != udir)
 		goto out_unlock;
 
-	opaquedir = ovl_lookup_temp(workdir);
+	opaquedir = ovl_create_real(wdir, ovl_lookup_temp(workdir),
+				    OVL_CATTR(stat.mode));
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
@@ -318,7 +322,6 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 
 out_cleanup:
 	ovl_cleanup(wdir, opaquedir);
-out_dput:
 	dput(opaquedir);
 out_unlock:
 	unlock_rename(workdir, upperdir);
@@ -379,20 +382,16 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
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
+	newdentry = ovl_create_real(wdir, ovl_lookup_temp(workdir), cattr);
+	err = PTR_ERR(newdentry);
+	if (IS_ERR(newdentry))
+		goto out_dput;
 
 	/*
 	 * mode could have been mutilated due to umask (e.g. sgid directory)
@@ -439,11 +438,9 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 			goto out_cleanup;
 	}
 	ovl_instantiate(dentry, inode, newdentry, hardlink);
-	newdentry = NULL;
-out_dput2:
-	dput(upper);
+	err = 0;
 out_dput:
-	dput(newdentry);
+	dput(upper);
 out_unlock:
 	unlock_rename(workdir, upperdir);
 out:
@@ -455,7 +452,8 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 
 out_cleanup:
 	ovl_cleanup(wdir, newdentry);
-	goto out_dput2;
+	dput(newdentry);
+	goto out_dput;
 }
 
 static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index aa8286419133..6bbde513e068 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -358,8 +358,8 @@ struct ovl_cattr {
 
 #define OVL_CATTR(m) (&(struct ovl_cattr) { .mode = (m) })
 
-int ovl_create_real(struct inode *dir, struct dentry *newdentry,
-		    struct ovl_cattr *attr);
+struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
+			       struct ovl_cattr *attr);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
 /* copy_up.c */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 286d36772e9c..704b37311467 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -611,9 +611,10 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 			goto retry;
 		}
 
-		err = ovl_create_real(dir, work, OVL_CATTR(attr.ia_mode));
-		if (err)
-			goto out_dput;
+		work = ovl_create_real(dir, work, OVL_CATTR(attr.ia_mode));
+		err = PTR_ERR(work);
+		if (IS_ERR(work))
+			goto out_err;
 
 		/*
 		 * Try to remove POSIX ACL xattrs from workdir.  We are good if:
-- 
2.14.3
