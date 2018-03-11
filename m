Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/3] ovl: do not try to reconnect a disconnected origin dentry
Date: Sun, 11 Mar 2018 13:22:53 +0200
Message-Id: <1520767374-19374-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1520767374-19374-1-git-send-email-amir73il@gmail.com>
References: <1520767374-19374-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On lookup of non directory, we try to decode the origin file handle
stored in upper inode. The origin file handle is supposed to be decoded
to a disconnected non-dir dentry, which is fine, because we only need
the lower inode of a copy up origin.

However, if the origin file handle somehow turns out to be a directory
we pay the expensive cost of reconnecting the directory dentry, only to
get a mismatch file type and drop the dentry.

Optimize this case by explicitly opting out of reconnecting the dentry.
Opting-out of reconnect is done by passing a NULL acceptable callback
to exportfs_decode_fh().

While the case described above is a strange corner case that does not
really need to be optimized, the API added for this optimization will
be used by a following patch to optimize a more common case of decoding
an overlayfs file handle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/exportfs/expfs.c      |  9 +++++++++
 fs/overlayfs/export.c    |  4 ++--
 fs/overlayfs/namei.c     | 16 +++++++++-------
 fs/overlayfs/overlayfs.h |  5 +++--
 4 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/fs/exportfs/expfs.c b/fs/exportfs/expfs.c
index 329a5d103846..645158dc33f1 100644
--- a/fs/exportfs/expfs.c
+++ b/fs/exportfs/expfs.c
@@ -435,6 +435,15 @@ struct dentry *exportfs_decode_fh(struct vfsmount *mnt, struct fid *fid,
 	if (IS_ERR_OR_NULL(result))
 		return ERR_PTR(-ESTALE);
 
+	/*
+	 * If no acceptance criteria was specified by caller, a disconnected
+	 * dentry is also accepatable. Callers may use this mode to query if
+	 * file handle is stale or to get a reference to an inode without
+	 * risking the high overhead caused by directory reconnect.
+	 */
+	if (!acceptable)
+		return result;
+
 	if (d_is_dir(result)) {
 		/*
 		 * This request is for a directory.
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index e688cf019460..15411350a7a1 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -685,7 +685,7 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
 	if (!ofs->upper_mnt)
 		return ERR_PTR(-EACCES);
 
-	upper = ovl_decode_real_fh(fh, ofs->upper_mnt);
+	upper = ovl_decode_real_fh(fh, ofs->upper_mnt, true);
 	if (IS_ERR_OR_NULL(upper))
 		return upper;
 
@@ -735,7 +735,7 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 	}
 
 	/* Then lookup origin by fh */
-	err = ovl_check_origin_fh(ofs, fh, NULL, &stack);
+	err = ovl_check_origin_fh(ofs, fh, true, NULL, &stack);
 	if (err) {
 		goto out_err;
 	} else if (index) {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 6e31a4f9e47f..e62e06c735ef 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -179,7 +179,8 @@ static struct ovl_fh *ovl_get_fh(struct dentry *dentry, const char *name)
 	goto out;
 }
 
-struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt)
+struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
+				  bool connected)
 {
 	struct dentry *real;
 	int bytes;
@@ -194,7 +195,7 @@ struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt)
 	bytes = (fh->len - offsetof(struct ovl_fh, fid));
 	real = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
 				  bytes >> 2, (int)fh->type,
-				  ovl_acceptable, mnt);
+				  connected ? ovl_acceptable : NULL, mnt);
 	if (IS_ERR(real)) {
 		/*
 		 * Treat stale file handle to lower file as "origin unknown".
@@ -320,14 +321,15 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 }
 
 
-int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
+int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 			struct dentry *upperdentry, struct ovl_path **stackp)
 {
 	struct dentry *origin = NULL;
 	int i;
 
 	for (i = 0; i < ofs->numlower; i++) {
-		origin = ovl_decode_real_fh(fh, ofs->lower_layers[i].mnt);
+		origin = ovl_decode_real_fh(fh, ofs->lower_layers[i].mnt,
+					    connected);
 		if (origin)
 			break;
 	}
@@ -371,7 +373,7 @@ static int ovl_check_origin(struct ovl_fs *ofs, struct dentry *upperdentry,
 	if (IS_ERR_OR_NULL(fh))
 		return PTR_ERR(fh);
 
-	err = ovl_check_origin_fh(ofs, fh, upperdentry, stackp);
+	err = ovl_check_origin_fh(ofs, fh, false, upperdentry, stackp);
 	kfree(fh);
 
 	if (err) {
@@ -461,7 +463,7 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
 	if (IS_ERR_OR_NULL(fh))
 		return ERR_CAST(fh);
 
-	upper = ovl_decode_real_fh(fh, ofs->upper_mnt);
+	upper = ovl_decode_real_fh(fh, ofs->upper_mnt, true);
 	kfree(fh);
 
 	if (IS_ERR_OR_NULL(upper))
@@ -568,7 +570,7 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 
 	/* Check if non-dir index is orphan and don't warn before cleaning it */
 	if (!d_is_dir(index) && d_inode(index)->i_nlink == 1) {
-		err = ovl_check_origin_fh(ofs, fh, index, &stack);
+		err = ovl_check_origin_fh(ofs, fh, false, index, &stack);
 		if (err)
 			goto fail;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index dd6c10e5a7db..b51613b355c5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -266,8 +266,9 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 /* namei.c */
 int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
-struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt);
-int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
+struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
+				  bool connected);
+int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 			struct dentry *upperdentry, struct ovl_path **stackp);
 int ovl_verify_set_fh(struct dentry *dentry, const char *name,
 		      struct dentry *real, bool is_upper, bool set);
-- 
2.7.4
