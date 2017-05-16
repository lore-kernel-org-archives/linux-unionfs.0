From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/3] ovl: handle rename when upper doesn't supports xattr
Date: Wed, 17 May 2017 00:12:41 +0300
Message-ID: <1494969161-30267-4-git-send-email-amir73il@gmail.com>
References: <1494969161-30267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33743 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752875AbdEPVMk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 17:12:40 -0400
Received: by mail-wm0-f66.google.com with SMTP id y10so40908326wmh.0
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2017 14:12:34 -0700 (PDT)
In-Reply-To: <1494969161-30267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On failure to set opaque/redirect xattr on rename, skip setting xattr and
return -EXDEV. Do not fail rename on failure to set impure xattr.

On failure to set opaque xattr when creating a new directory, -EIO is
returned instead of -EOPNOTSUPP.

Any failure to set those xattr will be recorded in super block and
then setting any xattr on upper won't be attempted again.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c  | 29 +++++++++++++++++++++++------
 fs/overlayfs/util.c |  2 +-
 2 files changed, 24 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 9b221cf..3f40afc 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -127,22 +127,39 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 	return err;
 }
 
-static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
+static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
+			       int xerr)
 {
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	int err;
 
-	err = ovl_do_setxattr(upperdentry, OVL_XATTR_OPAQUE, "y", 1, 0);
+	err = ovl_check_setxattr(ofs, upper, OVL_XATTR_OPAQUE, "y", 1, xerr);
 	if (!err)
 		ovl_dentry_set_opaque(dentry);
 
 	return err;
 }
 
+static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
+{
+	/*
+	 * Fail with -EIO when trying to create opaque dir and upper doesn't
+	 * support xattrs. ovl_rename() calls ovl_set_opaque_xerr(-EXDEV) to
+	 * return a specific error for noxattr case.
+	 */
+	return ovl_set_opaque_xerr(dentry, upperdentry, -EIO);
+}
+
 static int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 {
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	int err;
 
-	err = ovl_do_setxattr(upperdentry, OVL_XATTR_IMPURE, "y", 1, 0);
+	/*
+	 * Do not fail when upper doesn't support xattrs.
+	 * Upper inodes won't have origin nor redirect xattr anyway.
+	 */
+	err = ovl_check_setxattr(ofs, upperdentry, OVL_XATTR_IMPURE, "y", 1, 0);
 	if (!err)
 		ovl_dentry_set_impure(dentry);
 
@@ -959,7 +976,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	old_upperdir = ovl_dentry_upper(old->d_parent);
 	new_upperdir = ovl_dentry_upper(new->d_parent);
 
-	if (!samedir) {
+	if (!samedir && !ovl_noxattr(old->d_sb)) {
 		/*
 		 * When moving a merge dir or non-dir with copy up origin into
 		 * a non-merge upper dir (a.k.a pure upper dir), we are making
@@ -1032,7 +1049,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		if (ovl_type_merge_or_lower(old))
 			err = ovl_set_redirect(old, samedir);
 		else if (!old_opaque && ovl_type_merge(new->d_parent))
-			err = ovl_set_opaque(old, olddentry);
+			err = ovl_set_opaque_xerr(old, olddentry, -EXDEV);
 		if (err)
 			goto out_dput;
 	}
@@ -1040,7 +1057,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		if (ovl_type_merge_or_lower(new))
 			err = ovl_set_redirect(new, samedir);
 		else if (!new_opaque && ovl_type_merge(old->d_parent))
-			err = ovl_set_opaque(new, newdentry);
+			err = ovl_set_opaque_xerr(new, newdentry, -EXDEV);
 		if (err)
 			goto out_dput;
 	}
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index ce37cf4..c5136c5 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -212,7 +212,7 @@ bool ovl_redirect_dir(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
 
-	return ofs->config.redirect_dir;
+	return ofs->config.redirect_dir && !ofs->noxattr;
 }
 
 void ovl_clear_redirect_dir(struct super_block *sb)
-- 
2.7.4
