From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 04/17] ovl: verify index dir matches upper dir
Date: Fri,  2 Jun 2017 17:04:31 +0300
Message-ID: <1496412284-4113-5-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35205 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751201AbdFBOEj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:39 -0400
Received: by mail-wr0-f196.google.com with SMTP id g76so1331596wrd.2
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:39 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
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

When failing to verify upper dir file handle, cleanup existing index
dir and create a new empty one. If the 'verify_lower' mount option was
specified by user, leave the mismatch index dir intact and mount
readonly.

Add an 'is_upper' flag to the overlay file handle encoding and set it
when encoding the upper root file handle. This is not critical for index
dir verification, but it is good practice towards a standard overlayfs
file handle format.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 12 ++++++++++--
 fs/overlayfs/namei.c     |  6 +++---
 fs/overlayfs/overlayfs.h |  6 ++++--
 fs/overlayfs/super.c     | 48 ++++++++++++++++++++++++++++++++++++++++++------
 4 files changed, 59 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 047b2c3fdf6a..95568ec4f1d0 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -239,7 +239,7 @@ bool ovl_can_decode_fh(struct super_block *sb)
 		uuid_be_cmp(*(uuid_be *) &sb->s_uuid, NULL_UUID_BE));
 }
 
-struct ovl_fh *ovl_encode_fh(struct dentry *lower)
+struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
 {
 	struct ovl_fh *fh;
 	int fh_type, fh_len, dwords;
@@ -278,6 +278,14 @@ struct ovl_fh *ovl_encode_fh(struct dentry *lower)
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
@@ -299,7 +307,7 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	 * up and a pure upper inode.
 	 */
 	if (ovl_can_decode_fh(lower->d_sb)) {
-		fh = ovl_encode_fh(lower);
+		fh = ovl_encode_fh(lower, false);
 		if (IS_ERR(fh))
 			return PTR_ERR(fh);
 	}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 4a37f2fc3bbe..f5b49533c0e3 100644
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
@@ -482,7 +482,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (this && upperdentry && !ctr &&
 		    OVL_VERIFY_MERGE(ovl_verify_dir(dentry->d_sb))) {
 			err = ovl_verify_origin(upperdentry, lowerpath.mnt,
-						this);
+						this, false);
 			if (err && err != -ENODATA) {
 				dput(this);
 				break;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 45f1cd605f4d..31920a649a1c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -51,6 +51,8 @@ enum ovl_verify_dir {
 /* CPU byte order required for fid decoding:  */
 #define OVL_FH_FLAG_BIG_ENDIAN	(1 << 0)
 #define OVL_FH_FLAG_ANY_ENDIAN	(1 << 1)
+/* Is the real inode encoded in fid an upper inode? */
+#define OVL_FH_FLAG_PATH_UPPER	(1 << 2)
 
 #define OVL_FH_FLAG_ALL (OVL_FH_FLAG_BIG_ENDIAN | OVL_FH_FLAG_ANY_ENDIAN)
 
@@ -249,7 +251,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
-		      struct dentry *origin);
+		      struct dentry *origin, bool is_upper);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
@@ -309,4 +311,4 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 bool ovl_can_decode_fh(struct super_block *sb);
-struct ovl_fh *ovl_encode_fh(struct dentry *lower);
+struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76d5a8cfa86a..7e3976c34aab 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -439,19 +439,20 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
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
@@ -479,6 +480,7 @@ static struct dentry *ovl_workdir_create(struct super_block *sb,
 {
 	struct vfsmount *mnt = ufs->upper_mnt;
 	struct inode *dir = NULL;
+	struct dentry *upperdir = mnt->mnt_root;
 	struct dentry *work = NULL;
 	int err;
 	bool retried = false;
@@ -503,8 +505,29 @@ static struct dentry *ovl_workdir_create(struct super_block *sb,
 			if (retried)
 				goto out_dput;
 
-			if (persist)
-				goto out_unlock;
+			/*
+			 * Persistent work dir has a stored file handle of upper
+			 * root dir. If we verify the upper root handle matches
+			 * upper root dir, we can use the persistent work dir.
+			 * By default, failure to verify upper root file handle
+			 * will result in re-creating the persistent work dir.
+			 * With the verify_lower mount option, persistent work
+			 * dir will not be cleaned and mounted will fail.
+			 */
+			if (persist) {
+				err = ovl_verify_set_origin(work, mnt, upperdir,
+							    "upper root", true);
+				if (!err)
+					goto out_unlock;
+
+				/* With -o verify_lower, verify must succeed */
+				if (OVL_VERIFY_ROOT(ufs->config.verify_dir))
+					goto out_dput;
+
+				/* Blow away stale persistent work dir */
+				pr_warn("overlayfs: discarding existing directory %s/%s\n",
+					ufs->config.workdir, name);
+			}
 
 			retried = true;
 			ovl_workdir_cleanup(dir, mnt, work, 0);
@@ -518,6 +541,19 @@ static struct dentry *ovl_workdir_create(struct super_block *sb,
 		if (err)
 			goto out_dput;
 
+		if (persist) {
+			/*
+			 * Persistent work dir is associated with an upper dir
+			 * by storing the upper dir root file handle in xattr.
+			 * We use that file handle to verify that the persistent
+			 * work dir is never re-used with another upper dir.
+			 */
+			err = ovl_verify_set_origin(work, mnt, upperdir,
+						    "upper root", true);
+			if (err)
+				goto out_dput;
+		}
+
 		/*
 		 * Try to remove POSIX ACL xattrs from workdir.  We are good if:
 		 *
@@ -1078,7 +1114,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			/* Verify lower root matches origin stored in upper */
 			err = ovl_verify_set_origin(upperpath.dentry, mnt,
 						    mnt->mnt_root,
-						    "lower root");
+						    "lower root", false);
 			if (err)
 				goto out_put_lower_mnt;
 		}
-- 
2.7.4
