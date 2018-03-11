Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/3] ovl: disambiguate ovl_encode_fh()
Date: Sun, 11 Mar 2018 13:22:52 +0200
Message-Id: <1520767374-19374-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1520767374-19374-1-git-send-email-amir73il@gmail.com>
References: <1520767374-19374-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Rename ovl_encode_fh() to ovl_encode_real_fh() to differentiate from the
exportfs function ovl_encode_inode_fh() and change the latter to
ovl_encode_fh() to match the exportfs method name.

Rename ovl_decode_fh() to ovl_decode_real_fh() for consistency.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  6 +++---
 fs/overlayfs/export.c    | 12 ++++++------
 fs/overlayfs/namei.c     | 10 +++++-----
 fs/overlayfs/overlayfs.h |  4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d855f508fa20..8bede0742619 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -232,7 +232,7 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
-struct ovl_fh *ovl_encode_fh(struct dentry *real, bool is_upper)
+struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
 {
 	struct ovl_fh *fh;
 	int fh_type, fh_len, dwords;
@@ -300,7 +300,7 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	 * up and a pure upper inode.
 	 */
 	if (ovl_can_decode_fh(lower->d_sb)) {
-		fh = ovl_encode_fh(lower, false);
+		fh = ovl_encode_real_fh(lower, false);
 		if (IS_ERR(fh))
 			return PTR_ERR(fh);
 	}
@@ -321,7 +321,7 @@ static int ovl_set_upper_fh(struct dentry *upper, struct dentry *index)
 	const struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_fh(upper, true);
+	fh = ovl_encode_real_fh(upper, true);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 87bd4148f4fb..e688cf019460 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -228,8 +228,8 @@ static int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
 		goto fail;
 
 	/* Encode an upper or lower file handle */
-	fh = ovl_encode_fh(enc_lower ? ovl_dentry_lower(dentry) :
-				       ovl_dentry_upper(dentry), !enc_lower);
+	fh = ovl_encode_real_fh(enc_lower ? ovl_dentry_lower(dentry) :
+				ovl_dentry_upper(dentry), !enc_lower);
 	err = PTR_ERR(fh);
 	if (IS_ERR(fh))
 		goto fail;
@@ -267,8 +267,8 @@ static int ovl_dentry_to_fh(struct dentry *dentry, u32 *fid, int *max_len)
 	return OVL_FILEID;
 }
 
-static int ovl_encode_inode_fh(struct inode *inode, u32 *fid, int *max_len,
-			       struct inode *parent)
+static int ovl_encode_fh(struct inode *inode, u32 *fid, int *max_len,
+			 struct inode *parent)
 {
 	struct dentry *dentry;
 	int type;
@@ -685,7 +685,7 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
 	if (!ofs->upper_mnt)
 		return ERR_PTR(-EACCES);
 
-	upper = ovl_decode_fh(fh, ofs->upper_mnt);
+	upper = ovl_decode_real_fh(fh, ofs->upper_mnt);
 	if (IS_ERR_OR_NULL(upper))
 		return upper;
 
@@ -829,7 +829,7 @@ static struct dentry *ovl_get_parent(struct dentry *dentry)
 }
 
 const struct export_operations ovl_export_operations = {
-	.encode_fh	= ovl_encode_inode_fh,
+	.encode_fh	= ovl_encode_fh,
 	.fh_to_dentry	= ovl_fh_to_dentry,
 	.fh_to_parent	= ovl_fh_to_parent,
 	.get_name	= ovl_get_name,
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 87d8bf2c09c6..6e31a4f9e47f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -179,7 +179,7 @@ static struct ovl_fh *ovl_get_fh(struct dentry *dentry, const char *name)
 	goto out;
 }
 
-struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt)
+struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt)
 {
 	struct dentry *real;
 	int bytes;
@@ -327,7 +327,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
 	int i;
 
 	for (i = 0; i < ofs->numlower; i++) {
-		origin = ovl_decode_fh(fh, ofs->lower_layers[i].mnt);
+		origin = ovl_decode_real_fh(fh, ofs->lower_layers[i].mnt);
 		if (origin)
 			break;
 	}
@@ -425,7 +425,7 @@ int ovl_verify_set_fh(struct dentry *dentry, const char *name,
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_fh(real, is_upper);
+	fh = ovl_encode_real_fh(real, is_upper);
 	err = PTR_ERR(fh);
 	if (IS_ERR(fh))
 		goto fail;
@@ -461,7 +461,7 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
 	if (IS_ERR_OR_NULL(fh))
 		return ERR_CAST(fh);
 
-	upper = ovl_decode_fh(fh, ofs->upper_mnt);
+	upper = ovl_decode_real_fh(fh, ofs->upper_mnt);
 	kfree(fh);
 
 	if (IS_ERR_OR_NULL(upper))
@@ -629,7 +629,7 @@ int ovl_get_index_name(struct dentry *origin, struct qstr *name)
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_fh(origin, false);
+	fh = ovl_encode_real_fh(origin, false);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 225ff1171147..dd6c10e5a7db 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -266,7 +266,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 /* namei.c */
 int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
-struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt);
+struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt);
 int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh,
 			struct dentry *upperdentry, struct ovl_path **stackp);
 int ovl_verify_set_fh(struct dentry *dentry, const char *name,
@@ -361,7 +361,7 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
-struct ovl_fh *ovl_encode_fh(struct dentry *real, bool is_upper);
+struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper);
 int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 		   struct dentry *upper);
 
-- 
2.7.4
