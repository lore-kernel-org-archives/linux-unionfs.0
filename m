From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 07/23] ovl: verify index dir matches upper dir
Date: Wed, 14 Jun 2017 10:26:26 +0300
Message-ID: <1497425202-16270-8-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36112 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754313AbdFNH0n (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:26:43 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so6376997wrb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:26:42 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

An index dir contains persistent hardlinks to files in upper dir.
Therefore, we must never mount an existing index dir with a differnt
upper dir.

Store the upper root dir file handle in index dir inode when index
dir is created and verify the file handle before using an existing
index dir on mount.

Add an 'is_upper' flag to the overlay file handle encoding and set it
when encoding the upper root file handle. This is not critical for index
dir verification, but it is good practice towards a standard overlayfs
file handle format for NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 12 ++++++++++--
 fs/overlayfs/namei.c     |  4 ++--
 fs/overlayfs/overlayfs.h |  6 ++++--
 fs/overlayfs/super.c     | 20 +++++++++++++++-----
 4 files changed, 31 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index ee0b894e1d99..eedc26e15dad 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -233,7 +233,7 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
-struct ovl_fh *ovl_encode_fh(struct dentry *lower)
+struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
 {
 	struct ovl_fh *fh;
 	int fh_type, fh_len, dwords;
@@ -272,6 +272,14 @@ struct ovl_fh *ovl_encode_fh(struct dentry *lower)
 	fh->magic = OVL_FH_MAGIC;
 	fh->type = fh_type;
 	fh->flags = OVL_FH_FLAG_CPU_ENDIAN;
+	/*
+	 * When we will want to decode an overlay dentry from this handle
+	 * and all layers are on the same fs, if we get a disconncted real
+	 * dentry when we decode fid, the only way to tell if we should assign
+	 * it to upperdentry or to lowerstack is by checking this flag.
+	 */
+	if (is_upper)
+		fh->flags |= OVL_FH_FLAG_PATH_UPPER;
 	fh->len = fh_len;
 	fh->uuid = *uuid;
 	memcpy(fh->fid, buf, buflen);
@@ -293,7 +301,7 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	 * up and a pure upper inode.
 	 */
 	if (ovl_can_decode_fh(lower->d_sb)) {
-		fh = ovl_encode_fh(lower);
+		fh = ovl_encode_fh(lower, false);
 		if (IS_ERR(fh))
 			return PTR_ERR(fh);
 	}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 1b8017a57a02..61f4988527f4 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -327,7 +327,7 @@ static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
  * Return 0 on match, -ESTALE on mismatch, < 0 on error.
  */
 int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
-		      struct dentry *origin)
+		      struct dentry *origin, bool is_upper)
 {
 	struct inode *inode = NULL;
 	struct ovl_fh *fh = NULL;
@@ -343,7 +343,7 @@ int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
 		goto fail;
 	}
 
-	fh = ovl_encode_fh(origin);
+	fh = ovl_encode_fh(origin, is_upper);
 	if (IS_ERR(fh)) {
 		err = PTR_ERR(fh);
 		fh = NULL;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1eb8250464be..6fd7c9e748c1 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -38,6 +38,8 @@ enum ovl_path_type {
 /* CPU byte order required for fid decoding:  */
 #define OVL_FH_FLAG_BIG_ENDIAN	(1 << 0)
 #define OVL_FH_FLAG_ANY_ENDIAN	(1 << 1)
+/* Is the real inode encoded in fid an upper inode? */
+#define OVL_FH_FLAG_PATH_UPPER	(1 << 2)
 
 #define OVL_FH_FLAG_ALL (OVL_FH_FLAG_BIG_ENDIAN | OVL_FH_FLAG_ANY_ENDIAN)
 
@@ -236,7 +238,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
-		      struct dentry *origin);
+		      struct dentry *origin, bool is_upper);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
@@ -295,4 +297,4 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
-struct ovl_fh *ovl_encode_fh(struct dentry *lower);
+struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e6e0515525d3..5bbcef1ccf82 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -425,19 +425,20 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
  * If dir has no stored file handle, encode and store origin file handle.
  */
 static int ovl_verify_set_origin(struct dentry *dir, struct vfsmount *mnt,
-				 struct dentry *origin, const char *name)
+				 struct dentry *origin, const char *name,
+				 bool is_upper)
 {
 	const struct ovl_fh *fh = NULL;
 	int err;
 
-	err = ovl_verify_origin(dir, mnt, origin);
+	err = ovl_verify_origin(dir, mnt, origin, is_upper);
 	if (!err)
 		return 0;
 
 	if (err != -ENODATA)
 		goto fail;
 
-	fh = ovl_encode_fh(origin);
+	fh = ovl_encode_fh(origin, is_upper);
 	err = PTR_ERR(fh);
 	if (IS_ERR(fh))
 		goto fail;
@@ -1068,7 +1069,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		/* Verify lower root is upper root origin */
 		err = ovl_verify_set_origin(upperpath.dentry,
 					    ufs->lower_mnt[0], stack[0].dentry,
-					    "lower root");
+					    "lower root", false);
 		if (err)
 			goto out_put_lower_mnt;
 
@@ -1078,8 +1079,17 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (IS_ERR(ufs->indexdir))
 			goto out_put_lower_mnt;
 
-		if (!ufs->indexdir)
+		if (ufs->indexdir) {
+			/* Verify upper root is index dir origin */
+			err = ovl_verify_set_origin(ufs->indexdir,
+						    ufs->upper_mnt,
+						    upperpath.dentry,
+						    "upper root", true);
+			if (err)
+				goto out_put_indexdir;
+		} else {
 			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
+		}
 	}
 
 	/* Show index=off/on in /proc/mounts for any of the reasons above */
-- 
2.7.4
