From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 06/25] ovl: verify upper root dir matches lower root dir
Date: Wed, 21 Jun 2017 15:28:37 +0300
Message-ID: <1498048136-28218-7-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34810 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdFUM2w (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:28:52 -0400
Received: by mail-wr0-f194.google.com with SMTP id y25so23906609wrd.1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:28:51 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When inodes index feature is enabled, verify that the file handle stored
in upper root dir matches the lower root dir or fail to mount.

If upper root dir has no stored file handle, encode and store the lower
root dir file handle in overlay.origin xattr.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |   2 +-
 fs/overlayfs/namei.c     | 103 ++++++++++++++++++++++++++++++++++++++++-------
 fs/overlayfs/overlayfs.h |   3 ++
 fs/overlayfs/super.c     |   8 ++++
 4 files changed, 101 insertions(+), 15 deletions(-)

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
index 4ca6061f7bfa..c08e334c879c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -88,13 +88,10 @@ static int ovl_acceptable(void *ctx, struct dentry *dentry)
 	return 1;
 }
 
-static struct dentry *ovl_get_origin(struct dentry *dentry,
-				     struct vfsmount *mnt)
+static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
 {
 	int res;
 	struct ovl_fh *fh = NULL;
-	struct dentry *origin = NULL;
-	int bytes;
 
 	res = vfs_getxattr(dentry, OVL_XATTR_ORIGIN, NULL, 0);
 	if (res < 0) {
@@ -106,7 +103,7 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	if (res == 0)
 		return NULL;
 
-	fh  = kzalloc(res, GFP_TEMPORARY);
+	fh = kzalloc(res, GFP_TEMPORARY);
 	if (!fh)
 		return ERR_PTR(-ENOMEM);
 
@@ -129,7 +126,29 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	    (fh->flags & OVL_FH_FLAG_BIG_ENDIAN) != OVL_FH_FLAG_CPU_ENDIAN)
 		goto out;
 
-	bytes = (fh->len - offsetof(struct ovl_fh, fid));
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
+	struct ovl_fh *fh = ovl_get_origin_fh(dentry);
+	int bytes;
+
+	if (IS_ERR_OR_NULL(fh))
+		return (struct dentry *)fh;
 
 	/*
 	 * Make sure that the stored uuid matches the uuid of the lower
@@ -138,6 +157,7 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	if (uuid_be_cmp(fh->uuid, *(uuid_be *) &mnt->mnt_sb->s_uuid))
 		goto out;
 
+	bytes = (fh->len - offsetof(struct ovl_fh, fid));
 	origin = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
 				    bytes >> 2, (int)fh->type,
 				    ovl_acceptable, NULL);
@@ -149,21 +169,17 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	}
 
 	if (ovl_dentry_weird(origin) ||
-	    ((d_inode(origin)->i_mode ^ d_inode(dentry)->i_mode) & S_IFMT)) {
-		dput(origin);
-		origin = NULL;
+	    ((d_inode(origin)->i_mode ^ d_inode(dentry)->i_mode) & S_IFMT))
 		goto invalid;
-	}
 
 out:
 	kfree(fh);
 	return origin;
 
-fail:
-	pr_warn_ratelimited("overlayfs: failed to get origin (%i)\n", res);
-	goto out;
 invalid:
-	pr_warn_ratelimited("overlayfs: invalid origin (%*phN)\n", res, fh);
+	pr_warn_ratelimited("overlayfs: invalid origin (%pd2)\n", origin);
+	dput(origin);
+	origin = NULL;
 	goto out;
 }
 
@@ -305,6 +321,65 @@ static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
 }
 
 /*
+ * Verify that @fh matches the origin file handle stored in OVL_XATTR_ORIGIN.
+ * Return 0 on match, -ESTALE on mismatch, < 0 on error.
+ */
+static int ovl_verify_origin_fh(struct dentry *dentry, struct ovl_fh *fh)
+{
+	struct ovl_fh *ofh = ovl_get_origin_fh(dentry);
+	int err = 0;
+
+	if (!ofh)
+		return -ENODATA;
+
+	if (IS_ERR(ofh))
+		return PTR_ERR(ofh);
+
+	if (fh->len != ofh->len || memcmp(fh, ofh, fh->len))
+		err = -ESTALE;
+
+	kfree(ofh);
+	return err;
+}
+
+/*
+ * Verify that an inode matches the origin file handle stored in upper inode.
+ *
+ * If @set is true and there is no stored file handle, encode and store origin
+ * file handle in OVL_XATTR_ORIGIN.
+ *
+ * Return 0 on match, -ESTALE on mismatch, < 0 on error.
+ */
+int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
+		      struct dentry *origin, bool set)
+{
+	struct inode *inode = NULL;
+	struct ovl_fh *fh = NULL;
+	int err;
+
+	fh = ovl_encode_fh(origin);
+	err = PTR_ERR(fh);
+	if (IS_ERR(fh))
+		goto fail;
+
+	err = ovl_verify_origin_fh(dentry, fh);
+	if (set && err == -ENODATA)
+		err = ovl_do_setxattr(dentry, OVL_XATTR_ORIGIN, fh, fh->len, 0);
+	if (err)
+		goto fail;
+
+out:
+	kfree(fh);
+	return err;
+
+fail:
+	inode = d_inode(origin);
+	pr_warn_ratelimited("overlayfs: failed to verify origin (%pd2, ino=%lu, err=%i)\n",
+			    origin, inode ? inode->i_ino : 0, err);
+	goto out;
+}
+
+/*
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
  */
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 9ec93063c3a8..12d96a77c217 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -235,6 +235,8 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 
 /* namei.c */
+int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
+		      struct dentry *origin, bool set);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
@@ -293,3 +295,4 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
+struct ovl_fh *ovl_encode_fh(struct dentry *lower);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d92c7486bdf2..7c621bb265db 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1030,6 +1030,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		ufs->same_sb = NULL;
 
 	if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
+		/* Verify lower root is upper root origin */
+		err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
+					stack[0].dentry, true);
+		if (err) {
+			pr_err("overlayfs: failed to verify upper root origin\n");
+			goto out_put_lower_mnt;
+		}
+
 		ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
 						   OVL_INDEXDIR_NAME, true);
 		err = PTR_ERR(ufs->indexdir);
-- 
2.7.4
