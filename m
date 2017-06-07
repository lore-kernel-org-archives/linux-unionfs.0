From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 06/20] ovl: verify upper root dir matches lower root dir
Date: Wed,  7 Jun 2017 10:51:10 +0300
Message-ID: <1496821884-5178-7-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

When inodes index feature is enabled, verify that the file handle stored
in upper root dir matches the lower root dir or fail to mount.

If upper root dir has no stored file handle, encode and store the lower
root dir file handle in overlay.origin xattr.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  2 +-
 fs/overlayfs/namei.c     | 84 +++++++++++++++++++++++++++++++++++++++++-------
 fs/overlayfs/overlayfs.h |  3 ++
 fs/overlayfs/super.c     | 42 ++++++++++++++++++++++++
 4 files changed, 119 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d3047fdc0377..ee0b894e1d99 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -233,7 +233,7 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
-static struct ovl_fh *ovl_encode_fh(struct dentry *lower)
+struct ovl_fh *ovl_encode_fh(struct dentry *lower)
 {
 	struct ovl_fh *fh;
 	int fh_type, fh_len, dwords;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 4ca6061f7bfa..1b8017a57a02 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -88,13 +88,11 @@ static int ovl_acceptable(void *ctx, struct dentry *dentry)
 	return 1;
 }
 
-static struct dentry *ovl_get_origin(struct dentry *dentry,
-				     struct vfsmount *mnt)
+static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry,
+					struct vfsmount *mnt)
 {
 	int res;
 	struct ovl_fh *fh = NULL;
-	struct dentry *origin = NULL;
-	int bytes;
 
 	res = vfs_getxattr(dentry, OVL_XATTR_ORIGIN, NULL, 0);
 	if (res < 0) {
@@ -106,7 +104,7 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	if (res == 0)
 		return NULL;
 
-	fh  = kzalloc(res, GFP_TEMPORARY);
+	fh = kzalloc(res, GFP_TEMPORARY);
 	if (!fh)
 		return ERR_PTR(-ENOMEM);
 
@@ -129,8 +127,6 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	    (fh->flags & OVL_FH_FLAG_BIG_ENDIAN) != OVL_FH_FLAG_CPU_ENDIAN)
 		goto out;
 
-	bytes = (fh->len - offsetof(struct ovl_fh, fid));
-
 	/*
 	 * Make sure that the stored uuid matches the uuid of the lower
 	 * layer where file handle will be decoded.
@@ -138,6 +134,31 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	if (uuid_be_cmp(fh->uuid, *(uuid_be *) &mnt->mnt_sb->s_uuid))
 		goto out;
 
+	return fh;
+
+out:
+	kfree(fh);
+	return NULL;
+
+fail:
+	pr_warn_ratelimited("overlayfs: failed to get origin (%i)\n", res);
+	goto out;
+invalid:
+	pr_warn_ratelimited("overlayfs: invalid origin (%*phN)\n", res, fh);
+	goto out;
+}
+
+static struct dentry *ovl_get_origin(struct dentry *dentry,
+				     struct vfsmount *mnt)
+{
+	struct dentry *origin = NULL;
+	struct ovl_fh *fh = ovl_get_origin_fh(dentry, mnt);
+	int bytes;
+
+	if (!fh)
+		return NULL;
+
+	bytes = (fh->len - offsetof(struct ovl_fh, fid));
 	origin = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
 				    bytes >> 2, (int)fh->type,
 				    ovl_acceptable, NULL);
@@ -159,11 +180,8 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	kfree(fh);
 	return origin;
 
-fail:
-	pr_warn_ratelimited("overlayfs: failed to get origin (%i)\n", res);
-	goto out;
 invalid:
-	pr_warn_ratelimited("overlayfs: invalid origin (%*phN)\n", res, fh);
+	pr_warn_ratelimited("overlayfs: invalid origin (%*phN)\n", fh->len, fh);
 	goto out;
 }
 
@@ -305,6 +323,50 @@ static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
 }
 
 /*
+ * Verify that an inode matches the origin file handle stored in upper inode.
+ * Return 0 on match, -ESTALE on mismatch, < 0 on error.
+ */
+int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
+		      struct dentry *origin)
+{
+	struct inode *inode = NULL;
+	struct ovl_fh *fh = NULL;
+	struct ovl_fh *ofh = ovl_get_origin_fh(dentry, mnt);
+	int err;
+
+	/* Fail verification with no warning if no valid origin fh */
+	if (!ofh)
+		return -ENODATA;
+
+	if (IS_ERR(ofh)) {
+		err = PTR_ERR(ofh);
+		goto fail;
+	}
+
+	fh = ovl_encode_fh(origin);
+	if (IS_ERR(fh)) {
+		err = PTR_ERR(fh);
+		fh = NULL;
+		goto fail;
+	} else if (fh->len != ofh->len || memcmp(fh, ofh, fh->len)) {
+		err = -ESTALE;
+		goto fail;
+	}
+
+	err = 0;
+out:
+	kfree(ofh);
+	kfree(fh);
+	return err;
+
+fail:
+	inode = d_inode(origin);
+	pr_warn_ratelimited("overlayfs: failed to verify origin (ino=%lu, err=%i) - were layers copied?\n",
+			    inode ? inode->i_ino : 0, err);
+	goto out;
+}
+
+/*
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
  */
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 9ec93063c3a8..1eb8250464be 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -235,6 +235,8 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 
 /* namei.c */
+int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
+		      struct dentry *origin);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
@@ -293,3 +295,4 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
+struct ovl_fh *ovl_encode_fh(struct dentry *lower);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 02edc5ab1df3..137371419657 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -414,6 +414,41 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 	return 0;
 }
 
+/*
+ * Verify that stored file handle in dir matches origin.
+ * If dir has no stored file handle, encode and store origin file handle.
+ */
+static int ovl_verify_set_origin(struct dentry *dir, struct vfsmount *mnt,
+				 struct dentry *origin, const char *name)
+{
+	const struct ovl_fh *fh = NULL;
+	int err;
+
+	err = ovl_verify_origin(dir, mnt, origin);
+	if (!err)
+		return 0;
+
+	if (err != -ENODATA)
+		goto fail;
+
+	fh = ovl_encode_fh(origin);
+	err = PTR_ERR(fh);
+	if (IS_ERR(fh))
+		goto fail;
+	err = ovl_do_setxattr(dir, OVL_XATTR_ORIGIN, fh, fh->len, 0);
+	if (err)
+		goto fail;
+
+out:
+	kfree(fh);
+	return err;
+
+fail:
+	pr_err("overlayfs: failed to verify %s dir. (err=%i)\n",
+	       name, err);
+	goto out;
+}
+
 #define OVL_WORKDIR_NAME "work"
 #define OVL_INDEXDIR_NAME "index"
 
@@ -1024,6 +1059,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		ufs->same_sb = NULL;
 
 	if (!(sb->s_flags & MS_RDONLY) && ufs->config.index) {
+		/* Verify lower root is upper root origin */
+		err = ovl_verify_set_origin(upperpath.dentry,
+					    ufs->lower_mnt[0], stack[0].dentry,
+					    "lower root");
+		if (err)
+			goto out_put_lower_mnt;
+
 		ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
 						   OVL_INDEXDIR_NAME, true);
 		err = PTR_ERR(ufs->indexdir);
-- 
2.7.4
