Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/3] ovl: compact nested ovl_fh
Date: Mon,  3 Sep 2018 09:12:11 +0300
Message-Id: <20180903061211.20830-4-amir73il@gmail.com>
In-Reply-To: <20180903061211.20830-1-amir73il@gmail.com>
References: <20180903061211.20830-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

When encoding a file handle from lower nested overlayfs, prepending
another ovl_fh header for nested overlay file handle adds no new
information for decoding.  Instead, we just set a 'nested' flag in ovl_fh
header for nested file handle, so we know to distinguish between real
upper file handle that should be decoded from real upper layer and
nested upper file handle that should be decoded from nested lower layer.
For the maximum allowed overlay nesting depth of 1, one bit is enough.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 20 +++++++++++++++++++-
 fs/overlayfs/export.c    | 15 +++++++++++++--
 fs/overlayfs/namei.c     | 34 +++++++++++++++++++++++++---------
 fs/overlayfs/overlayfs.h |  8 +++++---
 fs/overlayfs/super.c     |  6 +++---
 fs/overlayfs/util.c      | 11 ++++++++++-
 6 files changed, 75 insertions(+), 19 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 296037afecdb..8330a982b3ca 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -254,6 +254,24 @@ struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper)
 	    WARN_ON(fh_type == FILEID_INVALID))
 		goto out;
 
+	/*
+	 * Prepending another ovl_fh header for nested overlay file handle adds
+	 * no new information for decoding. If we got a valid ovl_fh from lower
+	 * overlay, pass it up to nested overlay with the 'nested' flag.
+	 */
+	fh = ERR_PTR(-EINVAL);
+	if (ovl_is_overlay_fs(real->d_sb)) {
+		fh = buf;
+		if (WARN_ON(is_upper) ||
+		    WARN_ON(fh_type != OVL_FILEID) ||
+		    WARN_ON(fh->flags & OVL_FH_FLAG_PATH_NESTED) ||
+		    WARN_ON(ovl_check_fh_len(buf, buflen)))
+			goto out;
+
+		fh->flags |= OVL_FH_FLAG_PATH_NESTED;
+		return fh;
+	}
+
 	BUILD_BUG_ON(MAX_HANDLE_SZ + offsetof(struct ovl_fh, fid) > 255);
 	fh_len = offsetof(struct ovl_fh, fid) + buflen;
 	fh = kmalloc(fh_len, GFP_KERNEL);
@@ -294,7 +312,7 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	 * so we can use the overlay.origin xattr to distignuish between a copy
 	 * up and a pure upper inode.
 	 */
-	if (ovl_can_decode_fh(lower->d_sb)) {
+	if (ovl_can_decode_real_fh(lower->d_sb)) {
 		fh = ovl_encode_real_fh(lower, false);
 		if (IS_ERR(fh))
 			return PTR_ERR(fh);
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 8fa37cd7818a..90411c221519 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -691,7 +691,7 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
 	if (!ofs->upper_mnt)
 		return ERR_PTR(-EACCES);
 
-	upper = ovl_decode_real_fh(fh, ofs->upper_mnt, true);
+	upper = ovl_decode_real_fh(fh, ofs->upper_mnt, true, false);
 	if (IS_ERR_OR_NULL(upper))
 		return upper;
 
@@ -788,6 +788,7 @@ static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	struct ovl_fh *fh = (struct ovl_fh *) fid;
 	int len = fh_len << 2;
 	unsigned int flags = 0;
+	bool nested;
 	int err;
 
 	err = -EINVAL;
@@ -798,8 +799,18 @@ static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	if (err)
 		goto out_err;
 
+	/*
+	 * Do not try to decode nested upper from upper_mnt. Decode nested file
+	 * handle only from lower overlayfs.
+	 */
 	flags = fh->flags;
-	dentry = (flags & OVL_FH_FLAG_PATH_UPPER) ?
+	nested = flags & OVL_FH_FLAG_PATH_NESTED;
+
+	err = -ESTALE;
+	if (nested && !ovl_is_overlay_fs(ovl_dentry_lower(sb->s_root)->d_sb))
+		goto out_err;
+
+	dentry = ((flags & OVL_FH_FLAG_PATH_UPPER) && !nested) ?
 		 ovl_upper_fh_to_d(sb, fh) :
 		 ovl_lower_fh_to_d(sb, fh);
 	err = PTR_ERR(dentry);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index f28711846dd6..8d605fc16557 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -151,21 +151,33 @@ static struct ovl_fh *ovl_get_fh(struct dentry *dentry, const char *name)
 }
 
 struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
-				  bool connected)
+				  bool connected, bool nested)
 {
 	struct dentry *real;
-	int bytes;
+	int bytes, type;
+	void *fid;
 
 	/*
 	 * Make sure that the stored uuid matches the uuid of the lower
-	 * layer where file handle will be decoded.
+	 * layer where file handle will be decoded. Pass nested ovl_fh to
+	 * lower overlay that will match uuid to its own layers.
 	 */
-	if (!uuid_equal(&fh->uuid, &mnt->mnt_sb->s_uuid))
+	if (ovl_is_overlay_fs(mnt->mnt_sb)) {
+		if (!nested)
+			return NULL;
+		fid = fh;
+		type = OVL_FILEID;
+		bytes = fh->len;
+		fh->flags &= ~OVL_FH_FLAG_PATH_NESTED;
+	} else if (uuid_equal(&fh->uuid, &mnt->mnt_sb->s_uuid)) {
+		fid = fh->fid;
+		type = fh->type;
+		bytes = (fh->len - offsetof(struct ovl_fh, fid));
+	} else {
 		return NULL;
+	}
 
-	bytes = (fh->len - offsetof(struct ovl_fh, fid));
-	real = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
-				  bytes >> 2, (int)fh->type,
+	real = exportfs_decode_fh(mnt, fid, (bytes + 3) >> 2, type,
 				  connected ? ovl_acceptable : NULL, mnt);
 	if (IS_ERR(real)) {
 		/*
@@ -319,10 +331,11 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 {
 	struct dentry *origin = NULL;
 	int i;
+	u8 nested = fh->flags & OVL_FH_FLAG_PATH_NESTED;
 
 	for (i = 0; i < ofs->numlower; i++) {
 		origin = ovl_decode_real_fh(fh, ofs->lower_layers[i].mnt,
-					    connected);
+					    connected, nested);
 		if (origin)
 			break;
 	}
@@ -347,6 +360,9 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 		.layer = &ofs->lower_layers[i]
 	};
 
+	/* Restore nested flag - ovl_lower_fh_to_d() is not done with fh */
+	fh->flags |= nested;
+
 	return 0;
 
 invalid:
@@ -456,7 +472,7 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
 	if (IS_ERR_OR_NULL(fh))
 		return ERR_CAST(fh);
 
-	upper = ovl_decode_real_fh(fh, ofs->upper_mnt, true);
+	upper = ovl_decode_real_fh(fh, ofs->upper_mnt, true, false);
 	kfree(fh);
 
 	if (IS_ERR_OR_NULL(upper))
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d32fe09a222f..0664a0ca3423 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -62,9 +62,11 @@ enum ovl_entry_flag {
 #define OVL_FH_FLAG_ANY_ENDIAN	(1 << 1)
 /* Is the real inode encoded in fid an upper inode? */
 #define OVL_FH_FLAG_PATH_UPPER	(1 << 2)
+/* File handle from nested (lower) overlayfs */
+#define OVL_FH_FLAG_PATH_NESTED	(1 << 3)
 
 #define OVL_FH_FLAG_ALL (OVL_FH_FLAG_BIG_ENDIAN | OVL_FH_FLAG_ANY_ENDIAN | \
-			 OVL_FH_FLAG_PATH_UPPER)
+			 OVL_FH_FLAG_PATH_UPPER | OVL_FH_FLAG_PATH_NESTED)
 
 #if defined(__LITTLE_ENDIAN)
 #define OVL_FH_FLAG_CPU_ENDIAN 0
@@ -209,7 +211,7 @@ void ovl_drop_write(struct dentry *dentry);
 struct dentry *ovl_workdir(struct dentry *dentry);
 const struct cred *ovl_override_creds(struct super_block *sb);
 struct super_block *ovl_same_sb(struct super_block *sb);
-int ovl_can_decode_fh(struct super_block *sb);
+int ovl_can_decode_real_fh(struct super_block *sb);
 struct dentry *ovl_indexdir(struct super_block *sb);
 bool ovl_index_all(struct super_block *sb);
 bool ovl_verify_lower(struct super_block *sb);
@@ -294,7 +296,7 @@ static inline unsigned int ovl_xino_bits(struct super_block *sb)
 /* namei.c */
 int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
 struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
-				  bool connected);
+				  bool connected, bool nested);
 int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 			struct dentry *upperdentry, struct ovl_path **stackp);
 int ovl_verify_set_fh(struct dentry *dentry, const char *name,
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b6a0211dc75c..60f33705fe4e 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -777,7 +777,7 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	 * file handles, so they require that all layers support them.
 	 */
 	real_sb = path->dentry->d_sb;
-	fh_type = ovl_can_decode_fh(real_sb);
+	fh_type = ovl_can_decode_real_fh(real_sb);
 	if ((ofs->config.nfs_export ||
 	     (ofs->config.index && ofs->config.upperdir)) && !fh_type) {
 		ofs->config.index = false;
@@ -790,7 +790,7 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	if (ofs->config.xino != OVL_XINO_OFF && ovl_is_overlay_fs(real_sb)) {
 		real_sb = ovl_same_sb(real_sb);
 		if (real_sb) {
-			fh_type = ovl_can_decode_fh(real_sb);
+			fh_type = ovl_can_decode_real_fh(real_sb);
 		} else {
 			pr_warn("overlayfs: nested xino not supported, falling back to xino=off.\n");
 			ofs->config.xino = OVL_XINO_OFF;
@@ -1075,7 +1075,7 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	}
 
 	/* Check if upper/work fs supports file handles */
-	fh_type = ovl_can_decode_fh(ofs->workdir->d_sb);
+	fh_type = ovl_can_decode_real_fh(ofs->workdir->d_sb);
 	if (ofs->config.index && !fh_type) {
 		ofs->config.index = false;
 		pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6eabe7cf9652..7f81c771bc63 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -63,11 +63,20 @@ struct super_block *ovl_same_sb(struct super_block *sb)
  * Return 1 (FILEID_INO32_GEN) if fs uses the default 32bit inode encoding.
  * Return -1 if fs uses a non default encoding with unknown inode size.
  */
-int ovl_can_decode_fh(struct super_block *sb)
+int ovl_can_decode_real_fh(struct super_block *sb)
 {
 	if (!sb->s_export_op || !sb->s_export_op->fh_to_dentry)
 		return 0;
 
+	/*
+	 * In case FILESYSTEM_MAX_STACK_DEPTH ever grows, we only support
+	 * one level of nesting in ovl_fh. This test should be optimized out
+	 * at build time.
+	 */
+	if (FILESYSTEM_MAX_STACK_DEPTH > 2 &&
+	    ovl_is_overlay_fs(sb) && sb->s_stack_depth > 1)
+		return 0;
+
 	return sb->s_export_op->encode_fh ? -1 : FILEID_INO32_GEN;
 }
 
-- 
2.17.1
