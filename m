From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 11/11] ovl: cleanup stale whiteout index entries on mount
Date: Tue, 17 Oct 2017 19:00:22 +0300
Message-ID: <1508256022-10267-12-git-send-email-amir73il@gmail.com>
References: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:49557 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934507AbdJQQAD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:00:03 -0400
Received: by mail-wm0-f68.google.com with SMTP id b189so4803460wmd.4
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 09:00:02 -0700 (PDT)
In-Reply-To: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Check on mount that whiteout index entries have a name that
resolves to a non-stale file handle.

Do not verify that they have a valid origin fh xattr and do
not verify nlink xattr for orphan index check.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 153 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 97 insertions(+), 56 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 1ec65dfbf1bb..e2b47d6494fd 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -100,9 +100,37 @@ static int ovl_acceptable(void *mnt, struct dentry *dentry)
 	return is_subdir(dentry, ((struct vfsmount *)mnt)->mnt_root);
 }
 
+
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
@@ -115,7 +143,7 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
 	if (res == 0)
 		return NULL;
 
-	fh  = kzalloc(res, GFP_KERNEL);
+	fh = kzalloc(res, GFP_KERNEL);
 	if (!fh)
 		return ERR_PTR(-ENOMEM);
 
@@ -123,20 +151,12 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
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
 
@@ -152,22 +172,17 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
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
@@ -183,22 +198,15 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 		if (origin == ERR_PTR(-ESTALE) &&
 		    !(fh->flags & OVL_FH_FLAG_PATH_UPPER))
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
@@ -303,29 +311,30 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 }
 
 
-static int ovl_check_origin(struct dentry *upperdentry,
-			    struct path *lowerstack, unsigned int numlower,
-			    struct path **stackp, unsigned int *ctrp)
+static int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
+			       struct path *lowerstack, unsigned int numlower,
+			       struct path **stackp)
 {
 	struct vfsmount *mnt;
 	struct dentry *origin = NULL;
 	int i;
 
-
 	for (i = 0; i < numlower; i++) {
 		mnt = lowerstack[i].mnt;
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
 		*stackp = kmalloc(sizeof(struct path), GFP_KERNEL);
 	if (!*stackp) {
@@ -333,9 +342,42 @@ static int ovl_check_origin(struct dentry *upperdentry,
 		return -ENOMEM;
 	}
 	**stackp = (struct path) { .dentry = origin, .mnt = mnt };
-	*ctrp = 1;
 
 	return 0;
+
+invalid:
+	pr_warn_ratelimited("overlayfs: invalid origin (%pd2, ftype=%x, origin ftype=%x).\n",
+			    upperdentry, d_inode(upperdentry)->i_mode & S_IFMT,
+			    d_inode(origin)->i_mode & S_IFMT);
+	dput(origin);
+	return -ESTALE;
+}
+
+static int ovl_check_origin(struct dentry *upperdentry,
+			    struct path *lowerstack, unsigned int numlower,
+			    struct path **stackp, unsigned int *ctrp)
+{
+	struct ovl_fh *fh = ovl_get_origin_fh(upperdentry);
+	int err;
+
+	if (IS_ERR_OR_NULL(fh))
+		return PTR_ERR(fh);
+
+	err = ovl_check_origin_fh(fh, upperdentry, lowerstack, numlower,
+				  stackp);
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
@@ -429,7 +471,6 @@ int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
 	size_t len;
 	struct path origin = { };
 	struct path *stack = &origin;
-	unsigned int ctr = 0;
 	struct dentry *upper = NULL;
 	int err;
 
@@ -447,7 +488,15 @@ int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
 		goto fail;
 
 	err = -EINVAL;
-	if (hex2bin((u8 *)fh, index->d_name.name, len) || len != fh->len)
+	if (hex2bin((u8 *)fh, index->d_name.name, len))
+		goto fail;
+
+	err = ovl_check_fh_len(fh, len);
+	if (err)
+		goto fail;
+
+	err = ovl_check_origin_fh(fh, index, lowerstack, numlower, &stack);
+	if (err)
 		goto fail;
 
 	/*
@@ -455,9 +504,7 @@ int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
 	 * an exported overlay file handle should be treated as stale
 	 * (i.e. after unlink/rmdir of the overlay inode).
 	 * These entries contain no xattr.
-	 * TODO: cleanup stale whiteout index (try to decode index name).
 	 */
-	err = 0;
 	if (ovl_is_whiteout(index))
 		goto out;
 
@@ -487,12 +534,6 @@ int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
 	if (err)
 		goto fail;
 
-	err = ovl_check_origin(upper, lowerstack, numlower, &stack, &ctr);
-	if (!err && !ctr)
-		err = -ESTALE;
-	if (err)
-		goto fail;
-
 	/* Check if index is orphan and don't warn before cleaning it */
 	if (!d_is_dir(index) && d_inode(index)->i_nlink == 1 &&
 	    ovl_get_nlink(index, origin.dentry, 0) == 0)
-- 
2.7.4
