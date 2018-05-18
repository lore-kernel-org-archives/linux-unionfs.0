Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 5/9] ovl: make ovl_create_real() cope with vfs_mkdir() safely
Date: Fri, 18 May 2018 11:29:33 +0300
Message-Id: <1526632177-28832-6-git-send-email-amir73il@gmail.com>
In-Reply-To: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

vfs_mkdir() may succeed and leave the dentry passed to it unhashed and
negative.  ovl_create_real() is the last caller breaking when that
happens.

Make ovl_create_real() return the dentry to be used or ERR_PTR(-E...)
in case of error; usually that'll be the dentry passed to it, but
it might be a different one - result of lookup in case of vfs_mkdir()
leaving looking the inode, etc. up to the next lookup to come.

In that case (as well as in case of an error), original dentry is
dropped.  That simplifies the callers.  Moreover, passing ERR_PTR()
as dentry leads to immediate return of the same ERR_PTR().  That
simplifies the callers even more.

[amir: split re-factoring of ovl_create_temp() to prep patch
       add comment about unhashed dir after mkdir
       add pr_warn() if mkdir succeeds and lookup fails]

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 70 +++++++++++++++++++++++++++++-------------------
 fs/overlayfs/overlayfs.h |  4 +--
 fs/overlayfs/super.c     |  7 ++---
 3 files changed, 48 insertions(+), 33 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 41a8940964e3..6f7400be3fc8 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -114,13 +114,18 @@ int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
 	goto out;
 }
 
-int ovl_create_real(struct inode *dir, struct dentry *newdentry,
-		    struct ovl_cattr *attr)
+struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
+			       struct ovl_cattr *attr)
 {
 	int err;
 
-	if (newdentry->d_inode)
-		return -ESTALE;
+	if (IS_ERR(newdentry))
+		return newdentry;
+
+	if (newdentry->d_inode) {
+		dput(newdentry);
+		return ERR_PTR(-ESTALE);
+	}
 
 	if (attr->hardlink) {
 		err = ovl_do_link(attr->hardlink, dir, newdentry);
@@ -132,6 +137,26 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 
 		case S_IFDIR:
 			err = ovl_do_mkdir(dir, newdentry, attr->mode);
+			/*
+			 * vfs_mkdir() may succeed and leave the dentry passed
+			 * to it unhashed and negative. If that happens, try to
+			 * lookup a new hashed and positive dentry.
+			 */
+			if (!err && unlikely(d_unhashed(newdentry))) {
+				struct dentry *d;
+
+				d = lookup_one_len(newdentry->d_name.name,
+						   newdentry->d_parent,
+						   newdentry->d_name.len);
+				dput(newdentry);
+				if (IS_ERR(d)) {
+					err = PTR_ERR(d);
+					pr_warn("overlayfs: failed lookup after mkdir (%pd2, err=%i).\n",
+						newdentry, err);
+					return d;
+				}
+				newdentry = d;
+			}
 			break;
 
 		case S_IFCHR:
@@ -157,26 +182,17 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		 */
 		err = -ENOENT;
 	}
-	return err;
-}
-
-struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr)
-{
-	struct inode *wdir = workdir->d_inode;
-	struct dentry *temp;
-	int err;
-
-	temp = ovl_lookup_temp(workdir);
-	if (IS_ERR(temp))
-		return temp;
-
-	err = ovl_create_real(wdir, temp, attr);
 	if (err) {
-		dput(temp);
+		dput(newdentry);
 		return ERR_PTR(err);
 	}
+	return newdentry;
+}
 
-	return temp;
+struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr)
+{
+	return ovl_create_real(d_inode(workdir), ovl_lookup_temp(workdir),
+			       attr);
 }
 
 static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
@@ -243,14 +259,14 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
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
@@ -258,9 +274,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	}
 
 	ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink);
-	newdentry = NULL;
-out_dput:
-	dput(newdentry);
+	err = 0;
 out_unlock:
 	inode_unlock(udir);
 	return err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e72eec6d440f..4eb04da240b4 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -373,8 +373,8 @@ struct ovl_cattr {
 
 #define OVL_CATTR(m) (&(struct ovl_cattr) { .mode = (m) })
 
-int ovl_create_real(struct inode *dir, struct dentry *newdentry,
-		    struct ovl_cattr *attr);
+struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
+			       struct ovl_cattr *attr);
 struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr);
 
 /* file.c */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ace95319bf1d..cd5c82f105d6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -603,9 +603,10 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
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
2.7.4
