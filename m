From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 16/23] ovl: factor out ovl_copy_up_inode() helper
Date: Wed, 14 Jun 2017 10:26:35 +0300
Message-ID: <1497425202-16270-17-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32949 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754278AbdFNH0y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:26:54 -0400
Received: by mail-wr0-f194.google.com with SMTP id v104so36664636wrb.0
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:26:53 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
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
