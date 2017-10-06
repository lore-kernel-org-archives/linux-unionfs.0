From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/8] ovl: During copy up, first copy up metadata and then data
Date: Fri,  6 Oct 2017 13:47:11 -0400
Message-ID: <1507312037-30909-3-git-send-email-vgoyal@redhat.com>
References: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42408 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752155AbdJFRrX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:47:23 -0400
In-Reply-To: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

This just helps with later patches where after copying up metadata, we
skip data copying step, if needed.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 34 +++++++++++++++++-----------------
 1 file changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index aad97b30d5e6..00e8ae8bb9aa 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -445,6 +445,23 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
+	 * Don't set origin when we are breaking the association with a lower
+	 * hard link.
+	 */
+	if (c->origin) {
+		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
+		if (err)
+			return err;
+	}
+
 	if (S_ISREG(c->stat.mode)) {
 		struct path upperpath;
 
@@ -457,29 +474,12 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
-	err = ovl_copy_xattr(c->lowerpath.dentry, temp);
-	if (err)
-		return err;
-
 	inode_lock(temp->d_inode);
 	err = ovl_set_attr(temp, &c->stat);
 	inode_unlock(temp->d_inode);
 	if (err)
 		return err;
 
-	/*
-	 * Store identifier of lower inode in upper inode xattr to
-	 * allow lookup of the copy up origin inode.
-	 *
-	 * Don't set origin when we are breaking the association with a lower
-	 * hard link.
-	 */
-	if (c->origin) {
-		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
-		if (err)
-			return err;
-	}
-
 	return 0;
 }
 
-- 
2.13.5
