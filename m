From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: create all new directories opaque
Date: Mon, 21 Nov 2016 15:04:05 +0200
Message-ID: <1479733445-15795-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36356 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753271AbcKUNEc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 21 Nov 2016 08:04:32 -0500
Received: by mail-wm0-f68.google.com with SMTP id m203so1806513wma.3
        for <linux-unionfs@vger.kernel.org>; Mon, 21 Nov 2016 05:04:32 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

There is really no good reason why not to make all
directories opaque from birth.

The benefit of making directiories opaque on creation
is that lookups can stop short when they reach the
original created directory.

The best case is overlay with N layers, performing
lookup for first level directory, which exists only in upper.
In that case, there will be only one lookup instead of N.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f1794af..cebcec0 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -377,6 +377,8 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	struct dentry *newdentry;
 	int err;
 	struct posix_acl *acl, *default_acl;
+	int is_dir = !hardlink && S_ISDIR(stat->mode);
+	int flags = RENAME_EXCHANGE;
 
 	if (WARN_ON(!workdir))
 		return -EROFS;
@@ -403,6 +405,10 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(upper))
 		goto out_dput;
 
+	/* mkdir can gets here with no upper whiteout - adjust exchange flag */
+	if (is_dir && d_is_negative(upper))
+		flags = 0;
+
 	err = ovl_create_real(wdir, newdentry, stat, link, hardlink, true);
 	if (err)
 		goto out_dput2;
@@ -434,23 +440,26 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
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
 	} else {
 		err = ovl_do_rename(wdir, newdentry, udir, upper, 0);
 		if (err)
 			goto out_cleanup;
 	}
 	ovl_instantiate(dentry, inode, newdentry, !!hardlink);
+	/* All directories are created opaque */
+	if (is_dir)
+		ovl_dentry_set_opaque(dentry, true);
 	newdentry = NULL;
 out_dput2:
 	dput(upper);
@@ -477,6 +486,7 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 	int err;
 	const struct cred *old_cred;
 	struct cred *override_cred;
+	int is_dir = !hardlink && S_ISDIR(stat->mode);
 
 	err = ovl_copy_up(dentry->d_parent);
 	if (err)
@@ -500,7 +510,8 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		put_cred(override_creds(override_cred));
 		put_cred(override_cred);
 
-		if (!ovl_dentry_is_whiteout(dentry))
+		/* Always create new directories opaque */
+		if (!ovl_dentry_is_whiteout(dentry) && !is_dir)
 			err = ovl_create_upper(dentry, inode, stat, link,
 						hardlink);
 		else
@@ -1017,7 +1028,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			err = ovl_set_redirect(old, samedir);
 			if (err)
 				goto out_dput;
-		} else if (!old_opaque && ovl_lower_positive(new)) {
+		} else if (!old_opaque) {
 			err = ovl_set_opaque(olddentry);
 			if (err)
 				goto out_dput;
@@ -1029,7 +1040,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			err = ovl_set_redirect(new, samedir);
 			if (err)
 				goto out_dput;
-		} else if (!new_opaque && ovl_lower_positive(old)) {
+		} else if (!new_opaque) {
 			err = ovl_set_opaque(newdentry);
 			if (err)
 				goto out_dput;
-- 
2.7.4
