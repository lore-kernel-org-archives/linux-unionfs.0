From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] ovl: create directories inside merged parent opaque
Date: Mon, 21 Nov 2016 18:57:34 +0200
Message-ID: <1479747454-2273-1-git-send-email-amir73il@gmail.com>
References: <CAJfpegs--UYZrZG4KM8uigs5nL-Q_jD3+ssvQMRRSOK4HPWpsw@mail.gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33281 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754049AbcKUQ6A (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2016 11:58:00 -0500
Received: by mail-wm0-f65.google.com with SMTP id u144so549692wmu.0
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2016 08:57:59 -0800 (PST)
In-Reply-To: <CAJfpegs--UYZrZG4KM8uigs5nL-Q_jD3+ssvQMRRSOK4HPWpsw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

The benefit of making directories opaque on creation
is that lookups can stop short when they reach the
original created directory, instead of continue lookup
the entire depth of parent directory stack.

The best case is overlay with N layers, performing
lookup for first level directory, which exists only in upper.
In that case, there will be only one lookup instead of N.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 51 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 17 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f1794af..c393605 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -128,6 +128,13 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 	return err;
 }
 
+static bool ovl_type_merge_or_lower(struct dentry *dentry)
+{
+	enum ovl_path_type type = ovl_path_type(dentry);
+
+	return OVL_TYPE_MERGE(type) || !OVL_TYPE_UPPER(type);
+}
+
 static int ovl_set_opaque(struct dentry *upperdentry)
 {
 	return ovl_do_setxattr(upperdentry, OVL_XATTR_OPAQUE, "y", 1, 0);
@@ -377,6 +384,8 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	struct dentry *newdentry;
 	int err;
 	struct posix_acl *acl, *default_acl;
+	int is_dir = !hardlink && S_ISDIR(stat->mode);
+	int flags = RENAME_EXCHANGE;
 
 	if (WARN_ON(!workdir))
 		return -EROFS;
@@ -403,6 +412,10 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(upper))
 		goto out_dput;
 
+	/* mkdir can get here with no upper whiteout - adjust exchange flag */
+	if (is_dir && d_is_negative(upper))
+		flags = 0;
+
 	err = ovl_create_real(wdir, newdentry, stat, link, hardlink, true);
 	if (err)
 		goto out_dput2;
@@ -434,17 +447,19 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 			goto out_cleanup;
 	}
 
-	if (!hardlink && S_ISDIR(stat->mode)) {
+	if (is_dir) {
 		err = ovl_set_opaque(newdentry);
 		if (err)
 			goto out_cleanup;
 
-		err = ovl_do_rename(wdir, newdentry, udir, upper,
-				    RENAME_EXCHANGE);
+		err = ovl_do_rename(wdir, newdentry, udir, upper, flags);
 		if (err)
 			goto out_cleanup;
 
-		ovl_cleanup(wdir, upper);
+		if (!d_is_negative(upper))
+			ovl_cleanup(wdir, upper);
+
+		ovl_dentry_set_opaque(dentry, true);
 	} else {
 		err = ovl_do_rename(wdir, newdentry, udir, upper, 0);
 		if (err)
@@ -477,6 +492,7 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 	int err;
 	const struct cred *old_cred;
 	struct cred *override_cred;
+	int is_dir = !hardlink && S_ISDIR(stat->mode);
 
 	err = ovl_copy_up(dentry->d_parent);
 	if (err)
@@ -500,12 +516,14 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		put_cred(override_creds(override_cred));
 		put_cred(override_cred);
 
-		if (!ovl_dentry_is_whiteout(dentry))
-			err = ovl_create_upper(dentry, inode, stat, link,
-						hardlink);
-		else
+		/* Create new directories inside merged parent opaque */
+		if (ovl_dentry_is_whiteout(dentry) ||
+		    (is_dir && ovl_type_merge_or_lower(dentry->d_parent)))
 			err = ovl_create_over_whiteout(dentry, inode, stat,
 							link, hardlink);
+		else
+			err = ovl_create_upper(dentry, inode, stat, link,
+						hardlink);
 	}
 out_revert_creds:
 	revert_creds(old_cred);
@@ -782,13 +800,6 @@ static int ovl_rmdir(struct inode *dir, struct dentry *dentry)
 	return ovl_do_remove(dentry, true);
 }
 
-static bool ovl_type_merge_or_lower(struct dentry *dentry)
-{
-	enum ovl_path_type type = ovl_path_type(dentry);
-
-	return OVL_TYPE_MERGE(type) || !OVL_TYPE_UPPER(type);
-}
-
 static bool ovl_can_move(struct dentry *dentry)
 {
 	return ovl_redirect_dir(dentry->d_sb) ||
@@ -1012,12 +1023,17 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	if (WARN_ON(olddentry->d_inode == newdentry->d_inode))
 		goto out_dput;
 
+	/*
+	 * We need to make sure old/new dir is opaque if it is a pure upper
+	 * that is being moved into a merged directory
+	 */
 	if (is_dir) {
 		if (ovl_type_merge_or_lower(old)) {
 			err = ovl_set_redirect(old, samedir);
 			if (err)
 				goto out_dput;
-		} else if (!old_opaque && ovl_lower_positive(new)) {
+		} else if (!old_opaque &&
+			   ovl_type_merge_or_lower(new->d_parent)) {
 			err = ovl_set_opaque(olddentry);
 			if (err)
 				goto out_dput;
@@ -1029,7 +1045,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			err = ovl_set_redirect(new, samedir);
 			if (err)
 				goto out_dput;
-		} else if (!new_opaque && ovl_lower_positive(old)) {
+		} else if (!new_opaque &&
+			   ovl_type_merge_or_lower(old->d_parent)) {
 			err = ovl_set_opaque(newdentry);
 			if (err)
 				goto out_dput;
-- 
2.7.4
