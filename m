Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:40954 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751645AbeDZTKk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 04/31] ovl: During copy up, first copy up metadata and then data
Date: Thu, 26 Apr 2018 15:09:46 -0400
Message-Id: <20180426191013.13219-5-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Just a little re-ordering of code. This helps with next patch where after
copying up metadata, we skip data copying step, if needed.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 4afc97872c2d..7e2dc41ad693 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -536,28 +536,10 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 {
 	int err;
 
-	if (S_ISREG(c->stat.mode)) {
-		struct path upperpath;
-
-		ovl_path_upper(c->dentry, &upperpath);
-		BUG_ON(upperpath.dentry != NULL);
-		upperpath.dentry = temp;
-
-		err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
-		if (err)
-			return err;
-	}
-
 	err = ovl_copy_xattr(c->lowerpath.dentry, temp);
 	if (err)
 		return err;
 
-	inode_lock(temp->d_inode);
-	err = ovl_set_attr(temp, &c->stat);
-	inode_unlock(temp->d_inode);
-	if (err)
-		return err;
-
 	/*
 	 * Store identifier of lower inode in upper inode xattr to
 	 * allow lookup of the copy up origin inode.
@@ -571,7 +553,23 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
-	return 0;
+	if (S_ISREG(c->stat.mode)) {
+		struct path upperpath;
+
+		ovl_path_upper(c->dentry, &upperpath);
+		BUG_ON(upperpath.dentry != NULL);
+		upperpath.dentry = temp;
+
+		err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
+		if (err)
+			return err;
+	}
+
+	inode_lock(temp->d_inode);
+	err = ovl_set_attr(temp, &c->stat);
+	inode_unlock(temp->d_inode);
+
+	return err;
 }
 
 static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
-- 
2.13.6

