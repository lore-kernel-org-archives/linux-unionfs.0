From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 13/17] ovl: factor out ovl_copy_up_inode() helper
Date: Fri,  2 Jun 2017 17:04:40 +0300
Message-ID: <1496412284-4113-14-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34426 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751214AbdFBOFG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:05:06 -0400
Received: by mail-wm0-f67.google.com with SMTP id d127so19134646wmf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:05:06 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Factor out helper for copying lower inode data and metadata to temp
upper inode, that is common to copy up using O_TMPFILE and workdir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 64 +++++++++++++++++++++++++++++---------------------
 1 file changed, 37 insertions(+), 27 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 1fd73e4fa380..44985d9b3c8d 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -322,6 +322,42 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
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
@@ -381,33 +417,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
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
