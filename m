From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v8 04/15] ovl: Create origin xattr on copy up for all files
Date: Tue, 28 Nov 2017 10:59:48 -0500
Message-ID: <20171128155959.20114-5-vgoyal@redhat.com>
References: <20171128155959.20114-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58992 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753923AbdK1QAJ (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:00:09 -0500
In-Reply-To: <20171128155959.20114-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

Right now my understanding is that origin xattr is created for all copied
up files if index=on. And if index=off, then we create it for all type
of files except hardlinks (nlink != 1).

With metadata only copy up, I will still require origin xattr to copy up
data later, so create it even for hardlinks even with index=off.

Given ->origin is always true now, get rid of this field from
"struct ovl_copy_up_ctx".

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index eb3b8d39fb61..f55bece3688e 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -326,7 +326,6 @@ struct ovl_copy_up_ctx {
 	struct qstr destname;
 	struct dentry *workdir;
 	bool tmpfile;
-	bool origin;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -469,15 +468,10 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	/*
 	 * Store identifier of lower inode in upper inode xattr to
 	 * allow lookup of the copy up origin inode.
-	 *
-	 * Don't set origin when we are breaking the association with a lower
-	 * hard link.
 	 */
-	if (c->origin) {
-		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
-		if (err)
-			return err;
-	}
+	err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
+	if (err)
+		return err;
 
 	return 0;
 }
@@ -542,9 +536,6 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 	    c->stat.nlink > 1)
 		indexed = true;
 
-	if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || indexed)
-		c->origin = true;
-
 	if (indexed) {
 		c->destdir = ovl_indexdir(c->dentry->d_sb);
 		err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
-- 
2.13.6
