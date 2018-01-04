From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 09/17] ovl: decode indexed non-dir file handles
Date: Thu,  4 Jan 2018 19:20:41 +0200
Message-ID: <1515086449-26563-10-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Decoding an indexed non-dir file handle is similar to decoding a lower
non-dir file handle, but additionally, we lookup the file handle in index
dir by name to find the real upper inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 72 +++++++++++++++++++++++++++++++++------------------
 1 file changed, 47 insertions(+), 25 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 6b359f968c01..602bada474ba 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -168,22 +168,24 @@ static int ovl_encode_inode_fh(struct inode *inode, u32 *fid, int *max_len,
 }
 
 /*
- * Find or instantiate an overlay dentry from real dentries.
+ * Find or instantiate an overlay dentry from real dentries and index.
  */
 static struct dentry *ovl_obtain_alias(struct super_block *sb,
-				       struct dentry *upper,
-				       struct ovl_path *lowerpath)
+				       struct dentry *upper_alias,
+				       struct ovl_path *lowerpath,
+				       struct dentry *index)
 {
 	struct dentry *lower = lowerpath ? lowerpath->dentry : NULL;
+	struct dentry *upper = upper_alias ?: index;
 	struct dentry *dentry;
 	struct inode *inode;
 	struct ovl_entry *oe;
 
-	/* TODO: obtain an indexed non-dir upper with origin */
-	if (lower && (upper || d_is_dir(lower)))
+	/* We get overlay directory dentries with ovl_lookup_real() */
+	if (d_is_dir(upper ?: lower))
 		return ERR_PTR(-EIO);
 
-	inode = ovl_get_inode(sb, dget(upper), lower, NULL, !!lower);
+	inode = ovl_get_inode(sb, dget(upper), lower, index, !!lower);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);
@@ -200,13 +202,16 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	}
 
 	dentry->d_fsdata = oe;
-	if (upper)
+	if (upper_alias)
 		ovl_dentry_set_upper_alias(dentry);
 	if (lower) {
 		oe->lowerstack->dentry = dget(lower);
 		oe->lowerstack->layer = lowerpath->layer;
 	}
 
+	if (index)
+		ovl_set_flag(OVL_INDEX, inode);
+
 	return dentry;
 }
 
@@ -321,30 +326,26 @@ static struct dentry *ovl_lookup_real(struct super_block *sb,
 }
 
 /*
- * Get an overlay dentry from upper/lower real dentries.
+ * Get an overlay dentry from upper/lower real dentries and index.
  */
 static struct dentry *ovl_get_dentry(struct super_block *sb,
 				     struct dentry *upper,
-				     struct ovl_path *lowerpath)
+				     struct ovl_path *lowerpath,
+				     struct dentry *index)
 {
+	struct dentry *real = upper ?: (index ?: lowerpath->dentry);
+
 	/*
-	 * Obtain a disconnected overlay dentry from a disconnected non-dir
-	 * real lower dentry.
+	 * Obtain a disconnected overlay dentry from a non-dir real dentry
+	 * and index.
 	 */
-	if (!upper && !d_is_dir(lowerpath->dentry))
-		return ovl_obtain_alias(sb, NULL, lowerpath);
+	if (!d_is_dir(real))
+		return ovl_obtain_alias(sb, upper, lowerpath, index);
 
 	/* TODO: lookup connected dir from real lower dir */
 	if (!upper)
 		return ERR_PTR(-EACCES);
 
-	/*
-	 * Obtain a disconnected overlay dentry from a non-dir real upper
-	 * dentry.
-	 */
-	if (!d_is_dir(upper))
-		return ovl_obtain_alias(sb, upper, NULL);
-
 	/* Removed empty directory? */
 	if ((upper->d_flags & DCACHE_DISCONNECTED) || d_unhashed(upper))
 		return ERR_PTR(-ENOENT);
@@ -370,7 +371,7 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
 	if (IS_ERR_OR_NULL(upper))
 		return upper;
 
-	dentry = ovl_get_dentry(sb, upper, NULL);
+	dentry = ovl_get_dentry(sb, upper, NULL, NULL);
 	dput(upper);
 
 	return dentry;
@@ -383,17 +384,38 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 	struct ovl_path origin = { };
 	struct ovl_path *stack = &origin;
 	struct dentry *dentry = NULL;
+	struct dentry *index = NULL;
 	int err;
 
+	/* First lookup indexed upper by fh */
+	index = ovl_get_index_fh(ofs, fh);
+	err = PTR_ERR(index);
+	if (IS_ERR(index))
+		return ERR_PTR(err);
+
+	/* Then lookup origin by fh */
 	err = ovl_check_origin_fh(fh, NULL, ofs->lower_layers, ofs->numlower,
 				  &stack);
-	if (err)
-		return ERR_PTR(err);
+	if (err) {
+		goto out_err;
+	} else if (!index && !origin.dentry) {
+		return NULL;
+	} else if (index && origin.dentry) {
+		err = ovl_verify_origin(index, origin.dentry, false, false);
+		if (err)
+			goto out_err;
+	}
 
-	dentry = ovl_get_dentry(sb, NULL, &origin);
-	dput(origin.dentry);
+	dentry = ovl_get_dentry(sb, NULL, &origin, index);
 
+out:
+	dput(origin.dentry);
+	dput(index);
 	return dentry;
+
+out_err:
+	dentry = ERR_PTR(err);
+	goto out;
 }
 
 static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
-- 
2.7.4
