From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 05/11] ovl: lookup index for directories
Date: Tue, 17 Oct 2017 19:00:16 +0300
Message-ID: <1508256022-10267-6-git-send-email-amir73il@gmail.com>
References: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:57093 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936666AbdJQP74 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:59:56 -0400
Received: by mail-wm0-f65.google.com with SMTP id l68so4905607wmd.5
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:59:55 -0700 (PDT)
In-Reply-To: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

A directory index is a directory type entry in index dir
with a "trusted.overlay.origin" xattr containing an encoded ovl_fh
of the merge directory upper dir.

On lookup of non-dir files, lower file is followed by origin file handle.
On lookup of dir entries, lower dir is found by name and then compared
to origin file handle. We only trust dir index if we verified that lower
dir matches origin file handle, otherwise index is inconsistent and we
ignore it.

Directory index entries are going to be used for NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 52 +++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 39 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c73f490695c6..1afc6d6e99b9 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -518,6 +518,7 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 	struct dentry *index;
 	struct inode *inode;
 	struct qstr name;
+	bool is_dir = d_is_dir(origin);
 	int err;
 
 	err = ovl_get_index_name(origin, &name);
@@ -540,15 +541,11 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 
 	inode = d_inode(index);
 	if (d_is_negative(index)) {
-		if (upper && d_inode(origin)->i_nlink > 1) {
+		if (!is_dir && upper && d_inode(origin)->i_nlink > 1) {
 			pr_warn_ratelimited("overlayfs: hard link with origin but no index (%pd2).\n",
 					    upper);
 		}
 		goto out_dput;
-	} else if (upper && d_inode(upper) != inode) {
-		pr_warn_ratelimited("overlayfs: broken hard link - ignoring index (%pd2).\n",
-				    upper);
-		goto out_dput;
 	} else if (ovl_dentry_weird(index) || ovl_is_whiteout(index) ||
 		   ((inode->i_mode ^ d_inode(origin)->i_mode) & S_IFMT)) {
 		/*
@@ -562,8 +559,16 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 				    index, d_inode(index)->i_mode & S_IFMT,
 				    d_inode(origin)->i_mode & S_IFMT);
 		goto fail;
+	} else if (upper && is_dir) {
+		/* Verify that dir index origin points to upper dir */
+		err = ovl_verify_origin(index, upper, true, false);
+		if (err)
+			goto fail;
+	} else if (upper && d_inode(upper) != inode) {
+		pr_warn_ratelimited("overlayfs: broken hard link - ignoring index (%pd2).\n",
+				    upper);
+		goto out_dput;
 	}
-
 out:
 	kfree(name.name);
 	return index;
@@ -613,6 +618,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
 	struct path *stack = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
+	struct dentry *origin = NULL;
 	struct dentry *index = NULL;
 	unsigned int ctr = 0;
 	struct inode *inode = NULL;
@@ -659,6 +665,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			 */
 			err = ovl_check_origin(upperdentry, roe->lowerstack,
 					       roe->numlower, &stack, &ctr);
+			if (ctr)
+				origin = stack[0].dentry;
 			if (err)
 				goto out;
 		}
@@ -692,15 +700,26 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (!this)
 			continue;
 
+		if (!ctr)
+			origin = this;
+
 		/*
 		 * Verify that uppermost lower matches the copy up origin fh.
 		 * If no origin fh is stored in upper, store fh of lower dir.
+		 * If origin fh exists and does not match lower dir, depending
+		 * on verify_dir config, we either not merge this lower or we
+		 * merge it, but we do not use it as index key.
 		 */
 		if (this && upperdentry && !ctr) {
 			err = ovl_verify_origin(upperdentry, this, false, true);
-			if (err && ovl_verify_dir(dentry->d_sb)) {
-				dput(this);
-				break;
+			if (err) {
+				if (ovl_verify_dir(dentry->d_sb)) {
+					/* Don't merge with unverified lower */
+					dput(this);
+					break;
+				}
+				/* Don't use unverified lower as index key */
+				origin = NULL;
 			}
 		}
 
@@ -733,6 +752,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 				       roe->numlower, &stack, &ctr);
 		if (err)
 			goto out_put;
+
+		origin = stack[0].dentry;
 		/*
 		 * XXX: We do not continue layers lookup from decoded origin for
 		 * more than a single lower layer. This would require setting
@@ -742,10 +763,15 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 */
 	}
 
-	/* Lookup index by lower inode and verify it matches upper inode */
-	if (ctr && !d.is_dir && ovl_indexdir(dentry->d_sb)) {
-		struct dentry *origin = stack[0].dentry;
-
+	/*
+	 * Lookup index by lower inode and verify it matches upper inode.
+	 * We only trust dir index if we verified that lower dir matches
+	 * origin, otherwise index is inconsistent and we ignore it.
+	 *
+	 * TODO: update origin and index in case lower dir has changed and
+	 *       store new generation number xattr in index for NFS export.
+	 */
+	if (ctr && ovl_indexdir(dentry->d_sb) && origin) {
 		index = ovl_lookup_index(dentry, upperdentry, origin);
 		if (IS_ERR(index)) {
 			err = PTR_ERR(index);
-- 
2.7.4
