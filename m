From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 08/17] ovl: decode lower non-dir file handles
Date: Thu,  4 Jan 2018 19:20:40 +0200
Message-ID: <1515086449-26563-9-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33652 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751798AbeADRUs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:48 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Decoding a lower non-dir file handle is done by decoding the lower dentry
from underlying lower fs, finding or allocating an overlay inode that is
hashed by the real lower inode and instantiating an overlay dentry with
that inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 53 +++++++++++++++++++++++++++++++++++++++---------
 fs/overlayfs/namei.c     |  8 ++++----
 fs/overlayfs/overlayfs.h |  3 +++
 3 files changed, 50 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 0b4ad8693b29..6b359f968c01 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -174,15 +174,16 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 				       struct dentry *upper,
 				       struct ovl_path *lowerpath)
 {
-	struct inode *inode;
+	struct dentry *lower = lowerpath ? lowerpath->dentry : NULL;
 	struct dentry *dentry;
+	struct inode *inode;
 	struct ovl_entry *oe;
 
-	/* TODO: obtain non pure-upper */
-	if (lowerpath)
+	/* TODO: obtain an indexed non-dir upper with origin */
+	if (lower && (upper || d_is_dir(lower)))
 		return ERR_PTR(-EIO);
 
-	inode = ovl_get_inode(sb, dget(upper), NULL, NULL, 0);
+	inode = ovl_get_inode(sb, dget(upper), lower, NULL, !!lower);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);
@@ -192,14 +193,19 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	if (IS_ERR(dentry) || dentry->d_fsdata)
 		return dentry;
 
-	oe = ovl_alloc_entry(0);
+	oe = ovl_alloc_entry(!!lower);
 	if (!oe) {
 		dput(dentry);
 		return ERR_PTR(-ENOMEM);
 	}
 
 	dentry->d_fsdata = oe;
-	ovl_dentry_set_upper_alias(dentry);
+	if (upper)
+		ovl_dentry_set_upper_alias(dentry);
+	if (lower) {
+		oe->lowerstack->dentry = dget(lower);
+		oe->lowerstack->layer = lowerpath->layer;
+	}
 
 	return dentry;
 }
@@ -321,7 +327,14 @@ static struct dentry *ovl_get_dentry(struct super_block *sb,
 				     struct dentry *upper,
 				     struct ovl_path *lowerpath)
 {
-	/* TODO: get non-upper dentry */
+	/*
+	 * Obtain a disconnected overlay dentry from a disconnected non-dir
+	 * real lower dentry.
+	 */
+	if (!upper && !d_is_dir(lowerpath->dentry))
+		return ovl_obtain_alias(sb, NULL, lowerpath);
+
+	/* TODO: lookup connected dir from real lower dir */
 	if (!upper)
 		return ERR_PTR(-EACCES);
 
@@ -363,6 +376,26 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
 	return dentry;
 }
 
+static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
+					struct ovl_fh *fh)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct ovl_path origin = { };
+	struct ovl_path *stack = &origin;
+	struct dentry *dentry = NULL;
+	int err;
+
+	err = ovl_check_origin_fh(fh, NULL, ofs->lower_layers, ofs->numlower,
+				  &stack);
+	if (err)
+		return ERR_PTR(err);
+
+	dentry = ovl_get_dentry(sb, NULL, &origin);
+	dput(origin.dentry);
+
+	return dentry;
+}
+
 static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
 				       int fh_len, int fh_type)
 {
@@ -380,10 +413,10 @@ static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	if (err)
 		goto out_err;
 
-	/* TODO: decode non-upper */
 	flags = fh->flags;
-	if (flags & OVL_FH_FLAG_PATH_UPPER)
-		dentry = ovl_upper_fh_to_d(sb, fh);
+	dentry = (flags & OVL_FH_FLAG_PATH_UPPER) ?
+		 ovl_upper_fh_to_d(sb, fh) :
+		 ovl_lower_fh_to_d(sb, fh);
 	err = PTR_ERR(dentry);
 	if (IS_ERR(dentry) && err != -ESTALE)
 		goto out_err;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 87d39384dc55..638ff196da93 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -310,9 +310,9 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 }
 
 
-static int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
-			       struct ovl_layer *layers, unsigned int numlayers,
-			       struct ovl_path **stackp)
+int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
+			struct ovl_layer *layers, unsigned int numlayers,
+			struct ovl_path **stackp)
 {
 	struct dentry *origin = NULL;
 	int i;
@@ -328,7 +328,7 @@ static int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
 	else if (IS_ERR(origin))
 		return PTR_ERR(origin);
 
-	if (!ovl_is_whiteout(upperdentry) &&
+	if (upperdentry && !ovl_is_whiteout(upperdentry) &&
 	    ((d_inode(origin)->i_mode ^ d_inode(upperdentry)->i_mode) & S_IFMT))
 		goto invalid;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index c4f8e98e209e..2ddd74043b5f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -260,6 +260,9 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 /* namei.c */
 int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
 struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt);
+int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
+			struct ovl_layer *layers, unsigned int numlayers,
+			struct ovl_path **stackp);
 int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 		      bool is_upper, bool set);
 int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
-- 
2.7.4
