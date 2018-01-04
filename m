From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 04/23] ovl: factor out ovl_check_origin_fh()
Date: Thu,  4 Jan 2018 18:39:59 +0200
Message-ID: <1515084018-25134-5-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:38535 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753395AbeADQjd (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:33 -0500
Received: by mail-wr0-f195.google.com with SMTP id y9so2015529wrb.5
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:33 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Re-factor ovl_check_origin() and ovl_get_origin(), so origin fh xattr is
read from upper inode only once during lookup with multiple lower layers
and only once when verifying index entry origin.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 142 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 92 insertions(+), 50 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a48ee02c4524..4cc8fb64c879 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -87,9 +87,36 @@ static int ovl_acceptable(void *ctx, struct dentry *dentry)
 	return 1;
 }
 
+/*
+ * Check validity of an overlay file handle buffer.
+ *
+ * Return 0 for a valid file handle.
+ * Return -ENODATA for "origin unknown".
+ * Return <0 for an invalid file handle.
+ */
+static int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
+{
+	if (fh_len < sizeof(struct ovl_fh) || fh_len < fh->len)
+		return -EINVAL;
+
+	if (fh->magic != OVL_FH_MAGIC)
+		return -EINVAL;
+
+	/* Treat larger version and unknown flags as "origin unknown" */
+	if (fh->version > OVL_FH_VERSION || fh->flags & ~OVL_FH_FLAG_ALL)
+		return -ENODATA;
+
+	/* Treat endianness mismatch as "origin unknown" */
+	if (!(fh->flags & OVL_FH_FLAG_ANY_ENDIAN) &&
+	    (fh->flags & OVL_FH_FLAG_BIG_ENDIAN) != OVL_FH_FLAG_CPU_ENDIAN)
+		return -ENODATA;
+
+	return 0;
+}
+
 static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
 {
-	int res;
+	int res, err;
 	struct ovl_fh *fh = NULL;
 
 	res = vfs_getxattr(dentry, OVL_XATTR_ORIGIN, NULL, 0);
@@ -102,7 +129,7 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
 	if (res == 0)
 		return NULL;
 
-	fh  = kzalloc(res, GFP_KERNEL);
+	fh = kzalloc(res, GFP_KERNEL);
 	if (!fh)
 		return ERR_PTR(-ENOMEM);
 
@@ -110,20 +137,12 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
 	if (res < 0)
 		goto fail;
 
-	if (res < sizeof(struct ovl_fh) || res < fh->len)
-		goto invalid;
-
-	if (fh->magic != OVL_FH_MAGIC)
+	err = ovl_check_fh_len(fh, res);
+	if (err < 0) {
+		if (err == -ENODATA)
+			goto out;
 		goto invalid;
-
-	/* Treat larger version and unknown flags as "origin unknown" */
-	if (fh->version > OVL_FH_VERSION || fh->flags & ~OVL_FH_FLAG_ALL)
-		goto out;
-
-	/* Treat endianness mismatch as "origin unknown" */
-	if (!(fh->flags & OVL_FH_FLAG_ANY_ENDIAN) &&
-	    (fh->flags & OVL_FH_FLAG_BIG_ENDIAN) != OVL_FH_FLAG_CPU_ENDIAN)
-		goto out;
+	}
 
 	return fh;
 
@@ -139,22 +158,17 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
 	goto out;
 }
 
-static struct dentry *ovl_get_origin(struct dentry *dentry,
-				     struct vfsmount *mnt)
+static struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt)
 {
-	struct dentry *origin = NULL;
-	struct ovl_fh *fh = ovl_get_origin_fh(dentry);
+	struct dentry *origin;
 	int bytes;
 
-	if (IS_ERR_OR_NULL(fh))
-		return (struct dentry *)fh;
-
 	/*
 	 * Make sure that the stored uuid matches the uuid of the lower
 	 * layer where file handle will be decoded.
 	 */
 	if (!uuid_equal(&fh->uuid, &mnt->mnt_sb->s_uuid))
-		goto out;
+		return NULL;
 
 	bytes = (fh->len - offsetof(struct ovl_fh, fid));
 	origin = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
@@ -164,22 +178,15 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 		/* Treat stale file handle as "origin unknown" */
 		if (origin == ERR_PTR(-ESTALE))
 			origin = NULL;
-		goto out;
+		return origin;
 	}
 
-	if (ovl_dentry_weird(origin) ||
-	    ((d_inode(origin)->i_mode ^ d_inode(dentry)->i_mode) & S_IFMT))
-		goto invalid;
+	if (ovl_dentry_weird(origin)) {
+		dput(origin);
+		return NULL;
+	}
 
-out:
-	kfree(fh);
 	return origin;
-
-invalid:
-	pr_warn_ratelimited("overlayfs: invalid origin (%pd2)\n", origin);
-	dput(origin);
-	origin = NULL;
-	goto out;
 }
 
 static bool ovl_is_opaquedir(struct dentry *dentry)
@@ -284,9 +291,9 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 }
 
 
-static int ovl_check_origin(struct dentry *upperdentry,
-			    struct ovl_path *lower, unsigned int numlower,
-			    struct ovl_path **stackp, unsigned int *ctrp)
+static int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
+			       struct ovl_path *lower, unsigned int numlower,
+			       struct ovl_path **stackp)
 {
 	struct vfsmount *mnt;
 	struct dentry *origin = NULL;
@@ -294,18 +301,20 @@ static int ovl_check_origin(struct dentry *upperdentry,
 
 	for (i = 0; i < numlower; i++) {
 		mnt = lower[i].layer->mnt;
-		origin = ovl_get_origin(upperdentry, mnt);
-		if (IS_ERR(origin))
-			return PTR_ERR(origin);
-
+		origin = ovl_decode_fh(fh, mnt);
 		if (origin)
 			break;
 	}
 
 	if (!origin)
-		return 0;
+		return -ESTALE;
+	else if (IS_ERR(origin))
+		return PTR_ERR(origin);
+
+	if (!ovl_is_whiteout(upperdentry) &&
+	    ((d_inode(origin)->i_mode ^ d_inode(upperdentry)->i_mode) & S_IFMT))
+		goto invalid;
 
-	BUG_ON(*ctrp);
 	if (!*stackp)
 		*stackp = kmalloc(sizeof(struct ovl_path), GFP_KERNEL);
 	if (!*stackp) {
@@ -313,9 +322,41 @@ static int ovl_check_origin(struct dentry *upperdentry,
 		return -ENOMEM;
 	}
 	**stackp = (struct ovl_path){.dentry = origin, .layer = lower[i].layer};
-	*ctrp = 1;
 
 	return 0;
+
+invalid:
+	pr_warn_ratelimited("overlayfs: invalid origin (%pd2, ftype=%x, origin ftype=%x).\n",
+			    upperdentry, d_inode(upperdentry)->i_mode & S_IFMT,
+			    d_inode(origin)->i_mode & S_IFMT);
+	dput(origin);
+	return -EIO;
+}
+
+static int ovl_check_origin(struct dentry *upperdentry,
+			    struct ovl_path *lower, unsigned int numlower,
+			    struct ovl_path **stackp, unsigned int *ctrp)
+{
+	struct ovl_fh *fh = ovl_get_origin_fh(upperdentry);
+	int err;
+
+	if (IS_ERR_OR_NULL(fh))
+		return PTR_ERR(fh);
+
+	err = ovl_check_origin_fh(fh, upperdentry, lower, numlower, stackp);
+	kfree(fh);
+
+	if (err) {
+		if (err == -ESTALE)
+			return 0;
+		return err;
+	}
+
+	if (WARN_ON(*ctrp))
+		return -EIO;
+
+	*ctrp = 1;
+	return 0;
 }
 
 /*
@@ -389,7 +430,6 @@ int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
 	size_t len;
 	struct ovl_path origin = { };
 	struct ovl_path *stack = &origin;
-	unsigned int ctr = 0;
 	int err;
 
 	if (!d_inode(index))
@@ -420,16 +460,18 @@ int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
 		goto fail;
 
 	err = -EINVAL;
-	if (hex2bin((u8 *)fh, index->d_name.name, len) || len != fh->len)
+	if (hex2bin((u8 *)fh, index->d_name.name, len))
+		goto fail;
+
+	err = ovl_check_fh_len(fh, len);
+	if (err)
 		goto fail;
 
 	err = ovl_verify_origin_fh(index, fh);
 	if (err)
 		goto fail;
 
-	err = ovl_check_origin(index, lower, numlower, &stack, &ctr);
-	if (!err && !ctr)
-		err = -ESTALE;
+	err = ovl_check_origin_fh(fh, index, lower, numlower, &stack);
 	if (err)
 		goto fail;
 
-- 
2.7.4
