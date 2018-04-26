Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:41006 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753371AbeDZTKm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:42 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 23/31] ovl: Set redirect on metacopy files upon rename
Date: Thu, 26 Apr 2018 15:10:05 -0400
Message-Id: <20180426191013.13219-24-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Set redirect on metacopy files upon rename. This will help find data dentry
in lower dirs.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/dir.c | 54 ++++++++++++++++++++++++++++++++++++++----------------
 1 file changed, 38 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 34745ccea682..1acea6887b05 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -890,6 +890,30 @@ static int ovl_set_redirect(struct dentry *dentry, bool samedir)
 	return err;
 }
 
+static bool ovl_rel_redirect(struct dentry *dentry, bool samedir)
+{
+	struct dentry *lowerdentry;
+
+	if (d_is_dir(dentry) || !samedir)
+		return samedir;
+
+	/*
+	 * For non-dir hardlinked files, we need absolute redirects
+	 * in general as two upper hardlinks could be in different
+	 * dirs. We could put a relative redirect now and convert
+	 * it to absolute redirect later. But when nlink > 1 and
+	 * indexing is on, that means relative redirect needs to be
+	 * converted to absolute during copy up of another lower
+	 * hardllink as well.
+	 *
+	 * So without optimizing too much, just check if lower is
+	 * a hard link or not. If lower is hard link, put absolute
+	 * redirect.
+	 */
+	lowerdentry = ovl_dentry_lower(dentry);
+	return (d_inode(lowerdentry)->i_nlink > 1 ? false : true);
+}
+
 static int ovl_rename(struct inode *olddir, struct dentry *old,
 		      struct inode *newdir, struct dentry *new,
 		      unsigned int flags)
@@ -1045,22 +1069,20 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		goto out_dput;
 
 	err = 0;
-	if (is_dir) {
-		if (ovl_type_merge_or_lower(old))
-			err = ovl_set_redirect(old, samedir);
-		else if (!old_opaque && ovl_type_merge(new->d_parent))
-			err = ovl_set_opaque_xerr(old, olddentry, -EXDEV);
-		if (err)
-			goto out_dput;
-	}
-	if (!overwrite && new_is_dir) {
-		if (ovl_type_merge_or_lower(new))
-			err = ovl_set_redirect(new, samedir);
-		else if (!new_opaque && ovl_type_merge(old->d_parent))
-			err = ovl_set_opaque_xerr(new, newdentry, -EXDEV);
-		if (err)
-			goto out_dput;
-	}
+	if (ovl_type_merge_or_lower(old))
+		err = ovl_set_redirect(old, ovl_rel_redirect(old, samedir));
+	else if (is_dir && !old_opaque && ovl_type_merge(new->d_parent))
+		err = ovl_set_opaque_xerr(old, olddentry, -EXDEV);
+	if (err)
+		goto out_dput;
+
+	if (!overwrite && ovl_type_merge_or_lower(new))
+		err = ovl_set_redirect(new, ovl_rel_redirect(new, samedir));
+	else if (!overwrite && new_is_dir && !new_opaque &&
+		 ovl_type_merge(old->d_parent))
+		err = ovl_set_opaque_xerr(new, newdentry, -EXDEV);
+	if (err)
+		goto out_dput;
 
 	err = ovl_do_rename(old_upperdir->d_inode, olddentry,
 			    new_upperdir->d_inode, newdentry, flags);
-- 
2.13.6

