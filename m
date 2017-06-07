From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 15/20] ovl: factor out ovl_copy_up_inode() helper
Date: Wed,  7 Jun 2017 10:51:19 +0300
Message-ID: <1496821884-5178-16-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36059 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbdFGHvf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:51:35 -0400
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Factor out helper for copying lower inode data and metadata to temp
upper inode, that is common to copy up using O_TMPFILE and workdir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 64 +++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f6570bc127e7..e642a51f3be4 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -316,6 +316,42 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	return err;
 }
 
+static int ovl_copy_up_inode(struct dentry *dentry, struct dentry *temp,
+			     struct path *lowerpath, struct kstat *stat)
+{
+	int err;
+
+	if (S_ISREG(stat->mode)) {
+		struct path upperpath;
+
+		ovl_path_upper(dentry, &upperpath);
+		BUG_ON(upperpath.dentry != NULL);
+		upperpath.dentry = temp;
+
+		err = ovl_copy_up_data(lowerpath, &upperpath, stat->size);
+		if (err)
+			return err;
+	}
+
+	err = ovl_copy_xattr(lowerpath->dentry, temp);
+	if (err)
+		return err;
+
+	inode_lock(temp->d_inode);
+	err = ovl_set_attr(temp, stat);
+	inode_unlock(temp->d_inode);
+	if (err)
+		return err;
+
+	/*
+	 * Store identifier of lower inode in upper inode xattr to
+	 * allow lookup of the copy up origin inode.
+	 */
+	err = ovl_set_origin(dentry, lowerpath->dentry, temp);
+
+	return err;
+}
+
 static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 			      struct dentry *dentry, struct path *lowerpath,
 			      struct kstat *stat, const char *link,
@@ -375,33 +411,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out2;
 
-	if (S_ISREG(stat->mode)) {
-		struct path upperpath;
-
-		ovl_path_upper(dentry, &upperpath);
-		BUG_ON(upperpath.dentry != NULL);
-		upperpath.dentry = temp;
-
-		err = ovl_copy_up_data(lowerpath, &upperpath, stat->size);
-		if (err)
-			goto out_cleanup;
-	}
-
-	err = ovl_copy_xattr(lowerpath->dentry, temp);
-	if (err)
-		goto out_cleanup;
-
-	inode_lock(temp->d_inode);
-	err = ovl_set_attr(temp, stat);
-	inode_unlock(temp->d_inode);
-	if (err)
-		goto out_cleanup;
-
-	/*
-	 * Store identifier of lower inode in upper inode xattr to
-	 * allow lookup of the copy up origin inode.
-	 */
-	err = ovl_set_origin(dentry, lowerpath->dentry, temp);
+	err = ovl_copy_up_inode(dentry, temp, lowerpath, stat);
 	if (err)
 		goto out_cleanup;
 
-- 
2.7.4
