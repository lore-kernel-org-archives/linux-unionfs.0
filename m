From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 06/11] ovl: verify directory index entries on mount
Date: Tue, 17 Oct 2017 19:00:17 +0300
Message-ID: <1508256022-10267-7-git-send-email-amir73il@gmail.com>
References: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:48231 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934507AbdJQP75 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:59:57 -0400
Received: by mail-wm0-f67.google.com with SMTP id i124so4806008wmf.3
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:59:56 -0700 (PDT)
In-Reply-To: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Directory index entries should have origin xattr pointing to the
real upper dir. Non-dir index entries are hardlinks to the upper
real inode. For non-dir index, we can read the copy up origin xattr
directly from the index dentry, but for dir index we first need to
decode the upper directory.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 60 +++++++++++++++++++++++++++++++++---------------
 fs/overlayfs/overlayfs.h |  4 ++--
 fs/overlayfs/readdir.c   |  2 +-
 3 files changed, 45 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 1afc6d6e99b9..aba57d31d850 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -391,36 +391,45 @@ int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 	goto out;
 }
 
+/* Get upper dentry from index */
+struct dentry *ovl_index_upper(struct dentry *index, struct vfsmount *mnt)
+{
+	struct path upperpath = { .mnt = mnt };
+	struct path *stack = &upperpath;
+	unsigned int ctr = 0;
+	int err;
+
+	if (!d_is_dir(index))
+		return dget(index);
+
+	err = ovl_check_origin(index, stack, 1, &stack, &ctr);
+	if (!err && !ctr)
+		err = -ENODATA;
+	if (err)
+		return ERR_PTR(err);
+
+	return upperpath.dentry;
+}
+
 /*
  * Verify that an index entry name matches the origin file handle stored in
  * OVL_XATTR_ORIGIN and that origin file handle can be decoded to lower path.
  * Return 0 on match, -ESTALE on mismatch or stale origin, < 0 on error.
  */
-int ovl_verify_index(struct dentry *index, struct path *lowerstack,
-		     unsigned int numlower)
+int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
+		     struct path *lowerstack, unsigned int numlower)
 {
 	struct ovl_fh *fh = NULL;
 	size_t len;
 	struct path origin = { };
 	struct path *stack = &origin;
 	unsigned int ctr = 0;
+	struct dentry *upper = NULL;
 	int err;
 
 	if (!d_inode(index))
 		return 0;
 
-	/*
-	 * Directory index entries are going to be used for looking up
-	 * redirected upper dirs by lower dir fh when decoding an overlay
-	 * file handle of a merge dir.  We don't know the verification rules
-	 * for directory index entries, because they have not been implemented
-	 * yet, so return EROFS if those entries are found to avoid corrupting
-	 * an index that was created by a newer kernel.
-	 */
-	err = -EROFS;
-	if (d_is_dir(index))
-		goto fail;
-
 	err = -EINVAL;
 	if (index->d_name.len < sizeof(struct ovl_fh)*2)
 		goto fail;
@@ -446,23 +455,38 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 	if (ovl_is_whiteout(index))
 		goto out;
 
-	err = ovl_verify_origin_fh(index, fh);
+	/*
+	 * Directory index entries should have origin xattr pointing to the
+	 * real upper dir. Non-dir index entries are hardlinks to the upper
+	 * real inode. For non-dir index, we can read the copy up origin xattr
+	 * directly from the index dentry, but for dir index we first need to
+	 * decode the upper directory.
+	 */
+	upper = ovl_index_upper(index, mnt);
+	if (IS_ERR(upper)) {
+		err = PTR_ERR(upper);
+		if (err)
+			goto fail;
+	}
+
+	err = ovl_verify_origin_fh(upper, fh);
 	if (err)
 		goto fail;
 
-	err = ovl_check_origin(index, lowerstack, numlower, &stack, &ctr);
+	err = ovl_check_origin(upper, lowerstack, numlower, &stack, &ctr);
 	if (!err && !ctr)
 		err = -ESTALE;
 	if (err)
 		goto fail;
 
 	/* Check if index is orphan and don't warn before cleaning it */
-	if (d_inode(index)->i_nlink == 1 &&
+	if (!d_is_dir(index) && d_inode(index)->i_nlink == 1 &&
 	    ovl_get_nlink(index, origin.dentry, 0) == 0)
 		err = -ENOENT;
 
-	dput(origin.dentry);
 out:
+	dput(origin.dentry);
+	dput(upper);
 	kfree(fh);
 	return err;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 35f5452e61e0..e4caad7bae19 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -263,8 +263,8 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 		      bool is_upper, bool set);
-int ovl_verify_index(struct dentry *index, struct path *lowerstack,
-		     unsigned int numlower);
+int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
+		     struct path *lowerstack, unsigned int numlower);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index ba44546ad1ed..479ce47ba411 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1055,7 +1055,7 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			index = NULL;
 			break;
 		}
-		err = ovl_verify_index(index, lowerstack, numlower);
+		err = ovl_verify_index(index, mnt, lowerstack, numlower);
 		if (err) {
 			if (err == -EROFS)
 				break;
-- 
2.7.4
