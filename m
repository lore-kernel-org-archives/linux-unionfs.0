From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 03/17] ovl: decode pure upper file handles
Date: Thu,  4 Jan 2018 19:20:35 +0200
Message-ID: <1515086449-26563-4-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:44432 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbeADRUm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:42 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Decoding an upper file handle is done by decoding the upper dentry from
underlying upper fs, finding or allocating an overlay inode that is
hashed by the real upper inode and instantiating an overlay dentry with
that inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 91 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/namei.c     |  4 +--
 fs/overlayfs/overlayfs.h |  2 ++
 3 files changed, 95 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 58c4f5e8a67e..5c72784a0b4d 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -93,6 +93,97 @@ static int ovl_encode_inode_fh(struct inode *inode, u32 *fid, int *max_len,
 	return type;
 }
 
+/*
+ * Find or instantiate an overlay dentry from real dentries.
+ */
+static struct dentry *ovl_obtain_alias(struct super_block *sb,
+				       struct dentry *upper,
+				       struct ovl_path *lowerpath)
+{
+	struct inode *inode;
+	struct dentry *dentry;
+	struct ovl_entry *oe;
+
+	/* TODO: obtain non pure-upper */
+	if (lowerpath)
+		return ERR_PTR(-EIO);
+
+	inode = ovl_get_inode(sb, dget(upper), NULL, NULL, 0);
+	if (IS_ERR(inode)) {
+		dput(upper);
+		return ERR_CAST(inode);
+	}
+
+	dentry = d_obtain_alias(inode);
+	if (IS_ERR(dentry) || dentry->d_fsdata)
+		return dentry;
+
+	oe = ovl_alloc_entry(0);
+	if (!oe) {
+		dput(dentry);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	dentry->d_fsdata = oe;
+	ovl_dentry_set_upper_alias(dentry);
+
+	return dentry;
+}
+
+static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
+					struct ovl_fh *fh)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct dentry *dentry;
+	struct dentry *upper;
+
+	if (!ofs->upper_mnt)
+		return ERR_PTR(-EACCES);
+
+	upper = ovl_decode_fh(fh, ofs->upper_mnt);
+	if (IS_ERR_OR_NULL(upper))
+		return upper;
+
+	dentry = ovl_obtain_alias(sb, upper, NULL);
+	dput(upper);
+
+	return dentry;
+}
+
+static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type)
+{
+	struct dentry *dentry = NULL;
+	struct ovl_fh *fh = (struct ovl_fh *) fid;
+	int len = fh_len << 2;
+	unsigned int flags = 0;
+	int err;
+
+	err = -EINVAL;
+	if (fh_type != OVL_FILEID)
+		goto out_err;
+
+	err = ovl_check_fh_len(fh, len);
+	if (err)
+		goto out_err;
+
+	/* TODO: decode non-upper */
+	flags = fh->flags;
+	if (flags & OVL_FH_FLAG_PATH_UPPER)
+		dentry = ovl_upper_fh_to_d(sb, fh);
+	err = PTR_ERR(dentry);
+	if (IS_ERR(dentry) && err != -ESTALE)
+		goto out_err;
+
+	return dentry;
+
+out_err:
+	pr_warn_ratelimited("overlayfs: failed to decode file handle (len=%d, type=%d, flags=%x, err=%i)\n",
+			    len, fh_type, flags, err);
+	return ERR_PTR(err);
+}
+
 const struct export_operations ovl_export_operations = {
 	.encode_fh      = ovl_encode_inode_fh,
+	.fh_to_dentry	= ovl_fh_to_dentry,
 };
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a69cedf06000..87d39384dc55 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -107,7 +107,7 @@ static int ovl_acceptable(void *ctx, struct dentry *dentry)
  * Return -ENODATA for "origin unknown".
  * Return <0 for an invalid file handle.
  */
-static int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
+int ovl_check_fh_len(struct ovl_fh *fh, int fh_len)
 {
 	if (fh_len < sizeof(struct ovl_fh) || fh_len < fh->len)
 		return -EINVAL;
@@ -171,7 +171,7 @@ static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
 	goto out;
 }
 
-static struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt)
+struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt)
 {
 	struct dentry *origin;
 	int bytes;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f6fd999cb98e..c4f8e98e209e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -258,6 +258,8 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 
 /* namei.c */
+int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
+struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt);
 int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 		      bool is_upper, bool set);
 int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
-- 
2.7.4
