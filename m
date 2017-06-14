From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 03/23] ovl: relax same fs constrain for ovl_check_origin()
Date: Wed, 14 Jun 2017 10:26:22 +0300
Message-ID: <1497425202-16270-4-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36027 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754264AbdFNH0i (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:26:38 -0400
Received: by mail-wr0-f196.google.com with SMTP id 77so6376339wrb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:26:37 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

For the case of all layers not on the same fs, try to decode the copy up
origin file handle on any of the lower layers.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 43 +++++++++++++++++++++++++------------------
 1 file changed, 25 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 1ec1499fc672..4ca6061f7bfa 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -272,28 +272,24 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
 			    struct path **stackp, unsigned int *ctrp)
 {
-	struct super_block *same_sb = ovl_same_sb(dentry->d_sb);
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
 	struct vfsmount *mnt;
-	struct dentry *origin;
+	struct dentry *origin = NULL;
+	int i;
 
-	if (!same_sb || !roe->numlower)
-		return 0;
 
-       /*
-	* Since all layers are on the same fs, we use the first layer for
-	* decoding the file handle.  We may get a disconnected dentry,
-	* which is fine, because we only need to hold the origin inode in
-	* cache and use its inode number.  We may even get a connected dentry,
-	* that is not under the first layer's root.  That is also fine for
-	* using it's inode number - it's the same as if we held a reference
-	* to a dentry in first layer that was moved under us.
-	*/
-	mnt = roe->lowerstack[0].mnt;
-
-	origin = ovl_get_origin(upperdentry, mnt);
-	if (IS_ERR_OR_NULL(origin))
-		return PTR_ERR(origin);
+	for (i = 0; i < roe->numlower; i++) {
+		mnt = roe->lowerstack[i].mnt;
+		origin = ovl_get_origin(upperdentry, mnt);
+		if (IS_ERR(origin))
+			return PTR_ERR(origin);
+
+		if (origin)
+			break;
+	}
+
+	if (!origin)
+		return 0;
 
 	BUG_ON(*stackp || *ctrp);
 	*stackp = kmalloc(sizeof(struct path), GFP_TEMPORARY);
@@ -301,6 +297,7 @@ static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
 		dput(origin);
 		return -ENOMEM;
 	}
+
 	**stackp = (struct path) { .dentry = origin, .mnt = mnt };
 	*ctrp = 1;
 
@@ -375,6 +372,16 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 		if (upperdentry && !d.is_dir) {
 			BUG_ON(!d.stop || d.redirect);
+			/*
+			 * Lookup copy up origin by decoding origin file handle.
+			 * We may get a disconnected dentry, which is fine,
+			 * because we only need to hold the origin inode in
+			 * cache and use its inode number.  We may even get a
+			 * connected dentry, that is not under any of the lower
+			 * layers root.  That is also fine for using it's inode
+			 * number - it's the same as if we held a reference
+			 * to a dentry in lower layer that was moved under us.
+			 */
 			err = ovl_check_origin(dentry, upperdentry,
 					       &stack, &ctr);
 			if (err)
-- 
2.7.4
