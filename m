From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 11/23] ovl: verify directory index entries on mount
Date: Thu,  4 Jan 2018 18:40:06 +0200
Message-ID: <1515084018-25134-12-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:37444 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753385AbeADQjl (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:41 -0500
Received: by mail-wm0-f66.google.com with SMTP id f140so4440664wmd.2
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:41 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Directory index entries should have origin xattr pointing to the real
upper dir. Verifying that the upper dir file handle is not stale is
expensive, so only verify stale directory index entries on mount if
the "verify" feature is enabled.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/dcache.c          |  1 +
 fs/overlayfs/namei.c | 95 +++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 73 insertions(+), 23 deletions(-)

diff --git a/fs/dcache.c b/fs/dcache.c
index 5c7df1df81ff..b5d5ea984ac4 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3527,6 +3527,7 @@ bool is_subdir(struct dentry *new_dentry, struct dentry *old_dentry)
 
 	return result;
 }
+EXPORT_SYMBOL(is_subdir);
 
 static enum d_walk_ret d_genocide_kill(void *data, struct dentry *dentry)
 {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b481bc4e79d9..e53c54ecb7cc 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -84,7 +84,19 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 
 static int ovl_acceptable(void *ctx, struct dentry *dentry)
 {
-	return 1;
+	/*
+	 * A non-dir origin may be disconnected, which is fine, because
+	 * we only need it for its unique inode number.
+	 */
+	if (!d_is_dir(dentry))
+		return 1;
+
+	/* Don't decode a deleted empty directory */
+	if (d_unhashed(dentry))
+		return 0;
+
+	/* Check if directory belongs to the layer we are decoding from */
+	return is_subdir(dentry, ((struct vfsmount *)ctx)->mnt_root);
 }
 
 /*
@@ -173,7 +185,7 @@ static struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt)
 	bytes = (fh->len - offsetof(struct ovl_fh, fid));
 	origin = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
 				    bytes >> 2, (int)fh->type,
-				    ovl_acceptable, NULL);
+				    ovl_acceptable, mnt);
 	if (IS_ERR(origin)) {
 		/* Treat stale file handle as "origin unknown" */
 		if (origin == ERR_PTR(-ESTALE))
@@ -416,6 +428,30 @@ int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 	goto out;
 }
 
+/* Get upper dentry from index */
+static struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
+{
+	struct ovl_fh *fh;
+	struct ovl_layer layer = { .mnt = ofs->upper_mnt };
+	struct ovl_path upper = { .layer = &layer };
+	struct ovl_path *stack = &upper;
+	int err;
+
+	if (!d_is_dir(index))
+		return dget(index);
+
+	fh = ovl_get_origin_fh(index);
+	if (IS_ERR_OR_NULL(fh))
+		return ERR_CAST(fh);
+
+	err = ovl_check_origin_fh(fh, index, &layer, 1, &stack);
+	kfree(fh);
+	if (err)
+		return ERR_PTR(err);
+
+	return upper.dentry;
+}
+
 /*
  * Verify that an index entry name matches the origin file handle stored in
  * OVL_XATTR_ORIGIN and that origin file handle can be decoded to lower path.
@@ -427,23 +463,13 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 	size_t len;
 	struct ovl_path origin = { };
 	struct ovl_path *stack = &origin;
+	struct dentry *upper = NULL;
 	int err;
 
 	if (!d_inode(index))
 		return 0;
 
-	/*
-	 * Directory index entries are going to be used for looking up
-	 * redirected upper dirs by lower dir fh when decoding an overlay
-	 * file handle of a merge dir.  We don't know the verification rules
-	 * for directory index entries, because they have not been implemented
-	 * yet, so return EINVAL if those entries are found to abort the mount
-	 * and to avoid corrupting an index that was created by a newer kernel.
-	 */
 	err = -EINVAL;
-	if (d_is_dir(index))
-		goto fail;
-
 	if (index->d_name.len < sizeof(struct ovl_fh)*2)
 		goto fail;
 
@@ -469,22 +495,45 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 	if (ovl_is_whiteout(index))
 		goto out;
 
-	err = ovl_verify_origin_fh(index, fh);
-	if (err)
-		goto fail;
+	/*
+	 * verifying directory index entries are not stale is expensive, so
+	 * only verify stale dir index if 'verify' feature is enabled.
+	 */
+	if (d_is_dir(index) && !ofs->config.verify)
+		goto out;
 
-	err = ovl_check_origin_fh(fh, index, ofs->lower_layers,
-				  ofs->numlower, &stack);
+	/*
+	 * Directory index entries should have origin xattr pointing to the
+	 * real upper dir. Non-dir index entries are hardlinks to the upper
+	 * real inode. For non-dir index, we can read the copy up origin xattr
+	 * directly from the index dentry, but for dir index we first need to
+	 * decode the upper directory.
+	 */
+	upper = ovl_index_upper(ofs, index);
+	if (IS_ERR(upper)) {
+		err = PTR_ERR(upper);
+		if (err)
+			goto fail;
+	}
+
+	err = ovl_verify_origin_fh(upper, fh);
+	dput(upper);
 	if (err)
 		goto fail;
 
-	/* Check if index is orphan and don't warn before cleaning it */
-	if (d_inode(index)->i_nlink == 1 &&
-	    ovl_get_nlink(origin.dentry, index, 0) == 0)
-		err = -ENOENT;
+	/* Check if non-dir index is orphan and don't warn before cleaning it */
+	if (!d_is_dir(index) && d_inode(index)->i_nlink == 1) {
+		err = ovl_check_origin_fh(fh, index, ofs->lower_layers,
+					  ofs->numlower, &stack);
+		if (err)
+			goto fail;
+
+		if (ovl_get_nlink(origin.dentry, index, 0) == 0)
+			err = -ENOENT;
+	}
 
-	dput(origin.dentry);
 out:
+	dput(origin.dentry);
 	kfree(fh);
 	return err;
 
-- 
2.7.4
