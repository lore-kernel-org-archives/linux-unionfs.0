From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 07/14] ovl: decode pure-upper connectable file handles
Date: Tue, 17 Oct 2017 19:44:24 +0300
Message-ID: <1508258671-10800-8-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:43693 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937037AbdJQQoH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:44:07 -0400
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Implement fh_to_parent() and get_parent() operations to reconnect
a pure upper overlay dentry.

This fixes a variant of xfstest test generic/426 which creates a
directory, encodes its file handle, drops caches and decodes it.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 53 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/overlayfs/namei.c     |  5 -----
 fs/overlayfs/overlayfs.h |  5 +++++
 3 files changed, 53 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 263415dd929b..9ec2fe659e38 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -138,7 +138,7 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	}
 
 	dentry = d_obtain_alias(inode);
-	if (IS_ERR(dentry))
+	if (IS_ERR(dentry) || dentry == dentry->d_sb->s_root)
 		return dentry;
 
 	if (dentry->d_fsdata) {
@@ -159,26 +159,33 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 
 	dentry->d_fsdata = oe;
 	ovl_dentry_set_upper_alias(dentry);
+	if (d_is_dir(upper) && ovl_is_opaquedir(upper))
+		ovl_dentry_set_opaque(dentry);
 
 	return dentry;
 
 }
 
-static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
-				       int fh_len, int fh_type)
+static struct dentry *ovl_fh_to_d(struct super_block *sb, struct fid *fid,
+				  int fh_len, int fh_type, bool to_parent)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
 	struct vfsmount *mnt = ofs->upper_mnt;
 	const struct export_operations *real_op;
+	struct dentry *(*fh_to_d)(struct super_block *, struct fid *, int, int);
 	struct dentry *upper;
 
 	/* TODO: handle decoding of non pure upper */
-	if (!mnt)
+	if (!mnt || !mnt->mnt_sb->s_export_op)
 		return NULL;
 
 	real_op = mnt->mnt_sb->s_export_op;
+	fh_to_d = to_parent ? real_op->fh_to_parent : real_op->fh_to_dentry;
+	if (!fh_to_d)
+		return NULL;
+
 	/* TODO: decode ovl_fh format file handle */
-	upper = real_op->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fh_type);
+	upper = fh_to_d(mnt->mnt_sb, fid, fh_len, fh_type);
 	if (IS_ERR_OR_NULL(upper))
 		return upper;
 
@@ -186,7 +193,43 @@ static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	return ovl_obtain_alias(sb, upper, NULL);
 }
 
+static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type)
+{
+	return ovl_fh_to_d(sb, fid, fh_len, fh_type, false);
+}
+
+static struct dentry *ovl_fh_to_parent(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type)
+{
+	return ovl_fh_to_d(sb, fid, fh_len, fh_type, true);
+}
+
+static struct dentry *ovl_get_parent(struct dentry *dentry)
+{
+	const struct export_operations *real_op;
+	struct dentry *upper;
+
+	/* TODO: handle connecting of non pure upper */
+	if (ovl_dentry_lower(dentry))
+		return ERR_PTR(-EACCES);
+
+	upper = ovl_dentry_upper(dentry);
+	real_op = upper->d_sb->s_export_op;
+	if (!real_op || !real_op->get_parent)
+		return ERR_PTR(-EACCES);
+
+	upper = real_op->get_parent(upper);
+	if (IS_ERR(upper))
+		return upper;
+
+	/* Find or instantiate a pure upper dentry */
+	return ovl_obtain_alias(dentry->d_sb, upper, NULL);
+}
+
 const struct export_operations ovl_export_operations = {
 	.encode_fh      = ovl_encode_inode_fh,
 	.fh_to_dentry	= ovl_fh_to_dentry,
+	.fh_to_parent	= ovl_fh_to_parent,
+	.get_parent	= ovl_get_parent,
 };
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ce3d4930a721..d5313fb02e73 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -209,11 +209,6 @@ static struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt)
 	return origin;
 }
 
-static bool ovl_is_opaquedir(struct dentry *dentry)
-{
-	return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
-}
-
 static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 			     const char *name, unsigned int namelen,
 			     size_t prelen, const char *post,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8ad3110a9b48..66a6447a0c2a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -259,6 +259,11 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 	return ovl_check_dir_xattr(dentry, OVL_XATTR_IMPURE);
 }
 
+static inline bool ovl_is_opaquedir(struct dentry *dentry)
+{
+	return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
+}
+
 
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
-- 
2.7.4
