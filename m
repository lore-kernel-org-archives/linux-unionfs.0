From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 05/13] ovl: During copy up, first copy up metadata and then data
Date: Wed, 25 Oct 2017 15:09:27 -0400
Message-ID: <1508958575-14086-6-git-send-email-vgoyal@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:60424 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932162AbdJYTJn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2017 15:09:43 -0400
In-Reply-To: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

Just a little re-ordering of code. This helps with next patch where after
copying up metadata, we skip data copying step, if needed.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 33 ++++++++++++++++-----------------
 1 file changed, 16 insertions(+), 17 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8a8f538..4f580ec 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -445,6 +445,21 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 {
 	int err;
 
+	err = ovl_copy_xattr(c->lowerpath.dentry, temp);
+	if (err)
+		return err;
+
+	/*
+	 * Store identifier of lower inode in upper inode xattr to
+	 * allow lookup of the copy up origin inode.
+	 *
+	 */
+	if (c->origin) {
+		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
+		if (err)
+			return err;
+	}
+
 	if (S_ISREG(c->stat.mode)) {
 		struct path upperpath;
 
@@ -457,27 +472,11 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
-	err = ovl_copy_xattr(c->lowerpath.dentry, temp);
-	if (err)
-		return err;
-
 	inode_lock(temp->d_inode);
 	err = ovl_set_attr(temp, &c->stat);
 	inode_unlock(temp->d_inode);
-	if (err)
-		return err;
-
-	/*
-	 * Store identifier of lower inode in upper inode xattr to
-	 * allow lookup of the copy up origin inode.
-	 */
-	if (c->origin) {
-		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
-		if (err)
-			return err;
-	}
 
-	return 0;
+	return err;
 }
 
 static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
-- 
2.5.5
