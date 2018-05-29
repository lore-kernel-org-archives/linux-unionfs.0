From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 06/11] ovl: create helper ovl_create_temp()
Date: Tue, 29 May 2018 16:41:38 +0200
Message-ID: <20180529144143.16378-7-mszeredi@redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Also used ovl_create_temp() in ovl_create_index() instead of calling
ovl_do_mkdir() directly, so now all callers of ovl_do_mkdir() are routed
through ovl_create_real(), which paves the way for Al's fix for non-hashed
result from vfs_mkdir().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c   | 14 ++++----------
 fs/overlayfs/dir.c       | 13 +++++++++----
 fs/overlayfs/overlayfs.h |  2 +-
 3 files changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d3e9c1eeb7a4..1b442c14c531 100644
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
@@ -500,12 +496,10 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
 	if (new_creds)
 		old_creds = override_creds(new_creds);
 
-	if (c->tmpfile) {
+	if (c->tmpfile)
 		temp = ovl_do_tmpfile(c->workdir, c->stat.mode);
-	} else {
-		temp = ovl_create_real(d_inode(c->workdir),
-				       ovl_lookup_temp(c->workdir), &cattr);
-	}
+	else
+		temp = ovl_create_temp(c->workdir, &cattr);
 	if (IS_ERR(temp))
 		goto temp_err;
 	err = 0;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 425ddb098c4a..1b181292a624 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -43,7 +43,7 @@ int ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
 	return err;
 }
 
-struct dentry *ovl_lookup_temp(struct dentry *workdir)
+static struct dentry *ovl_lookup_temp(struct dentry *workdir)
 {
 	struct dentry *temp;
 	char name[20];
@@ -169,6 +169,12 @@ struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 	return newdentry;
 }
 
+struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr)
+{
+	return ovl_create_real(d_inode(workdir), ovl_lookup_temp(workdir),
+			       attr);
+}
+
 static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
 			       int xerr)
 {
@@ -287,8 +293,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (upper->d_parent->d_inode != udir)
 		goto out_unlock;
 
-	opaquedir = ovl_create_real(wdir, ovl_lookup_temp(workdir),
-				    OVL_CATTR(stat.mode));
+	opaquedir = ovl_create_temp(workdir, OVL_CATTR(stat.mode));
 	err = PTR_ERR(opaquedir);
 	if (IS_ERR(opaquedir))
 		goto out_unlock;
@@ -388,7 +393,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(upper))
 		goto out_unlock;
 
-	newdentry = ovl_create_real(wdir, ovl_lookup_temp(workdir), cattr);
+	newdentry = ovl_create_temp(workdir, cattr);
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
 		goto out_dput;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6bbde513e068..3f13d0965e03 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -346,7 +346,6 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
-struct dentry *ovl_lookup_temp(struct dentry *workdir);
 int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
 			     struct dentry *dentry);
 struct ovl_cattr {
@@ -361,6 +360,7 @@ struct ovl_cattr {
 struct dentry *ovl_create_real(struct inode *dir, struct dentry *newdentry,
 			       struct ovl_cattr *attr);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
+struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
-- 
2.14.3
