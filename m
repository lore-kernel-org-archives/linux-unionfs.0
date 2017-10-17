From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 08/14] ovl: encode/decode struct ovl_fh format file handles
Date: Tue, 17 Oct 2017 19:44:25 +0300
Message-ID: <1508258671-10800-9-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:50727 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937034AbdJQQoI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:44:08 -0400
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Encode an overlay inode as struct ovl_fh encoding of the real inode.
Pure upper file handles are explicitly marked with a flag in ovl_fh
header.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 18 +++++-----
 fs/overlayfs/export.c    | 86 +++++++++++++++++++++++++++++++++---------------
 fs/overlayfs/namei.c     | 12 ++++---
 fs/overlayfs/overlayfs.h | 10 +++++-
 4 files changed, 85 insertions(+), 41 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 0a2c2c3743b1..9af3a6b62038 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -233,25 +233,21 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
-struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
+struct ovl_fh *ovl_encode_fh(struct dentry *dentry, bool is_upper,
+			     bool connectable)
 {
 	struct ovl_fh *fh;
 	int fh_type, fh_len, dwords;
 	void *buf;
 	int buflen = MAX_HANDLE_SZ;
-	uuid_t *uuid = &lower->d_sb->s_uuid;
+	uuid_t *uuid = &dentry->d_sb->s_uuid;
 
 	buf = kmalloc(buflen, GFP_KERNEL);
 	if (!buf)
 		return ERR_PTR(-ENOMEM);
 
-	/*
-	 * We encode a non-connectable file handle for non-dir, because we
-	 * only need to find the lower inode number and we don't want to pay
-	 * the price or reconnecting the dentry.
-	 */
 	dwords = buflen >> 2;
-	fh_type = exportfs_encode_fh(lower, buf, &dwords, 0);
+	fh_type = exportfs_encode_fh(dentry, buf, &dwords, connectable);
 	buflen = (dwords << 2);
 
 	fh = ERR_PTR(-EIO);
@@ -296,12 +292,16 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *origin,
 	int err;
 
 	/*
+	 * We encode a non-connectable file handle for non-dir, because we
+	 * only need to find the lower inode number and we don't want to pay
+	 * the price of reconnecting the dentry on lookup.
+	 *
 	 * When lower layer doesn't support export operations store a 'null' fh,
 	 * so we can use the overlay.origin xattr to distignuish between a copy
 	 * up and a pure upper inode.
 	 */
 	if (ovl_can_decode_fh(origin->d_sb)) {
-		fh = ovl_encode_fh(origin, is_upper);
+		fh = ovl_encode_fh(origin, is_upper, false);
 		if (IS_ERR(fh))
 			return PTR_ERR(fh);
 	}
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 9ec2fe659e38..47ef0302dbd3 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -41,7 +41,8 @@ static bool ovl_is_pure_upper_or_root(struct dentry *dentry, int connectable)
 static int ovl_dentry_to_fh(struct dentry *dentry, struct fid *fid,
 			    int *max_len, int connectable)
 {
-	int type;
+	const struct ovl_fh *fh;
+	int len = *max_len << 2;
 
 	/*
 	 * Overlay root dir inode is hashed and encoded as pure upper, because
@@ -49,20 +50,27 @@ static int ovl_dentry_to_fh(struct dentry *dentry, struct fid *fid,
 	 * that root dir is not indexed, because root dentry is pinned to cache.
 	 *
 	 * TODO: handle encoding of non pure upper.
+	 *       Parent and child may not be on the same layer, so encode
+	 *       connectable file handle as an array of self ovl_fh and
+	 *       parent ovl_fh (type OVL_FILEID_WITH_PARENT).
 	 */
 	if (!ovl_is_pure_upper_or_root(dentry, connectable))
 		return FILEID_INVALID;
 
-	/*
-	 * Ask real fs to encode the inode of the real upper dentry.
-	 * When decoding we ask real fs for the upper dentry and use
-	 * the real inode to get the overlay inode.
-	 */
-	type = exportfs_encode_fh(ovl_dentry_upper(dentry), fid, max_len,
-				  connectable);
+	fh = ovl_encode_fh(ovl_dentry_upper(dentry), true, connectable);
+	if (IS_ERR(fh))
+		return FILEID_INVALID;
 
-	/* TODO: encode an ovl_fh struct and return OVL file handle type */
-	return type;
+	if (fh->len > len) {
+		kfree(fh);
+		return FILEID_INVALID;
+	}
+
+	memcpy((char *)fid, (char *)fh, len);
+	*max_len = len >> 2;
+	kfree(fh);
+
+	return OVL_FILEID_WITHOUT_PARENT;
 }
 
 /* Find an alias of inode. If @dir is non NULL, find a child alias */
@@ -171,24 +179,44 @@ static struct dentry *ovl_fh_to_d(struct super_block *sb, struct fid *fid,
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
 	struct vfsmount *mnt = ofs->upper_mnt;
-	const struct export_operations *real_op;
-	struct dentry *(*fh_to_d)(struct super_block *, struct fid *, int, int);
 	struct dentry *upper;
+	struct ovl_fh *fh = (struct ovl_fh *) fid;
+	int err;
 
-	/* TODO: handle decoding of non pure upper */
-	if (!mnt || !mnt->mnt_sb->s_export_op)
-		return NULL;
+	/* TODO: handle file handle with parent from different layer */
+	if (fh_type != OVL_FILEID_WITHOUT_PARENT)
+		return ERR_PTR(-EINVAL);
+
+	err = ovl_check_fh_len(fh, fh_len << 2);
+	if (err)
+		return ERR_PTR(err);
 
-	real_op = mnt->mnt_sb->s_export_op;
-	fh_to_d = to_parent ? real_op->fh_to_parent : real_op->fh_to_dentry;
-	if (!fh_to_d)
+	/* TODO: handle decoding of non pure upper */
+	if (!mnt || !(fh->flags & OVL_FH_FLAG_PATH_UPPER))
 		return NULL;
 
-	/* TODO: decode ovl_fh format file handle */
-	upper = fh_to_d(mnt->mnt_sb, fid, fh_len, fh_type);
+	upper = ovl_decode_fh(fh, mnt);
 	if (IS_ERR_OR_NULL(upper))
 		return upper;
 
+	/*
+	 * ovl_decode_fh() will return a connected dentry if the encoded real
+	 * file handle was connectable (the case of pure upper ancestry).
+	 * fh_to_parent() needs to instantiate an overlay dentry from real
+	 * upper parent in that case.
+	 */
+	if (to_parent) {
+		struct dentry *parent;
+
+		if (upper->d_flags & DCACHE_DISCONNECTED) {
+			dput(upper);
+			return NULL;
+		}
+		parent = dget_parent(upper);
+		dput(upper);
+		upper = parent;
+	}
+
 	/* Find or instantiate a pure upper dentry */
 	return ovl_obtain_alias(sb, upper, NULL);
 }
@@ -207,21 +235,25 @@ static struct dentry *ovl_fh_to_parent(struct super_block *sb, struct fid *fid,
 
 static struct dentry *ovl_get_parent(struct dentry *dentry)
 {
-	const struct export_operations *real_op;
 	struct dentry *upper;
 
 	/* TODO: handle connecting of non pure upper */
 	if (ovl_dentry_lower(dentry))
 		return ERR_PTR(-EACCES);
 
+	/*
+	 * When ovl_fh_to_d() returns an overlay dentry, its real upper
+	 * dentry should be positive and connected. The reconnecting of
+	 * the upper dentry is done by ovl_decode_fh() when decoding the
+	 * real upper file handle, so here we have the upper dentry parent
+	 * and we need to instantiate an overlay dentry with upper dentry
+	 * parent.
+	 */
 	upper = ovl_dentry_upper(dentry);
-	real_op = upper->d_sb->s_export_op;
-	if (!real_op || !real_op->get_parent)
-		return ERR_PTR(-EACCES);
+	if (!upper || (upper->d_flags & DCACHE_DISCONNECTED))
+		return ERR_PTR(-ESTALE);
 
-	upper = real_op->get_parent(upper);
-	if (IS_ERR(upper))
-		return upper;
+	upper = dget_parent(upper);
 
 	/* Find or instantiate a pure upper dentry */
 	return ovl_obtain_alias(dentry->d_sb, upper, NULL);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index d5313fb02e73..4f20af22bd0b 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -108,7 +108,7 @@ static int ovl_acceptable(void *mnt, struct dentry *dentry)
  * Return -ENODATA for "origin unknown".
  * Return <0 for an invalid file handle.
  */
-static int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
+int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
 {
 	if (fh_len < sizeof(struct ovl_fh) || fh_len < fh->len)
 		return -EINVAL;
@@ -172,7 +172,7 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
 	goto out;
 }
 
-static struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt)
+struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt)
 {
 	struct dentry *origin;
 	int bytes;
@@ -412,7 +412,7 @@ int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 	struct ovl_fh *fh;
 	int err;
 
-	fh = ovl_encode_fh(origin, is_upper);
+	fh = ovl_encode_fh(origin, is_upper, false);
 	err = PTR_ERR(fh);
 	if (IS_ERR(fh))
 		goto fail;
@@ -574,7 +574,11 @@ int ovl_get_index_name(struct dentry *origin, struct qstr *name)
 	struct ovl_fh *fh;
 	char *n, *s;
 
-	fh = ovl_encode_fh(origin, false);
+	/*
+	 * We encode a non-connectable file handle for index, because the index
+	 * must be unqiue and invariant of lower hardlink aliases.
+	 */
+	fh = ovl_encode_fh(origin, false, false);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 66a6447a0c2a..75a8b10d4e10 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -72,6 +72,11 @@ enum ovl_index {
 #error Endianness not defined
 #endif
 
+/* The type returned by overlay encode_fh when encoding an ovl_fh handle */
+#define OVL_FILEID_WITHOUT_PARENT	0xf1
+/* The type returned by overlay encode_fh when encoding two ovl_fh handles */
+#define OVL_FILEID_WITH_PARENT		0xf2
+
 /* On-disk and in-memeory format for redirect by file handle */
 struct ovl_fh {
 	u8 version;	/* 0 */
@@ -266,6 +271,8 @@ static inline bool ovl_is_opaquedir(struct dentry *dentry)
 
 
 /* namei.c */
+int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
+struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt);
 int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 		      bool is_upper, bool set);
 int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
@@ -341,7 +348,8 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
-struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
+struct ovl_fh *ovl_encode_fh(struct dentry *dentry, bool is_upper,
+			     bool connectable);
 
 /* export.c */
 extern const struct export_operations ovl_export_operations;
-- 
2.7.4
