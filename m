From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v8 06/15] ovl: During copy up, first copy up metadata and then data
Date: Tue, 28 Nov 2017 10:59:50 -0500
Message-ID: <20171128155959.20114-7-vgoyal@redhat.com>
References: <20171128155959.20114-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753166AbdK1QAK (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:00:10 -0500
In-Reply-To: <20171128155959.20114-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

Just a little re-ordering of code. This helps with next patch where after
copying up metadata, we skip data copying step, if needed.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 29 ++++++++++++++---------------
 1 file changed, 14 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f55bece3688e..303794bb9127 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -443,6 +443,19 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
+	err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
+	if (err)
+		return err;
+
 	if (S_ISREG(c->stat.mode)) {
 		struct path upperpath;
 
@@ -455,25 +468,11 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
-	err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
-	if (err)
-		return err;
 
-	return 0;
+	return err;
 }
 
 static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
-- 
2.13.6
