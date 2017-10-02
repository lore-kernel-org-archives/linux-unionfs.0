From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 2/7] ovl: During copy up, first copy up metadata and then data
Date: Mon,  2 Oct 2017 09:40:00 -0400
Message-ID: <1506951605-31440-3-git-send-email-vgoyal@redhat.com>
References: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50396 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751065AbdJBNkO (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 2 Oct 2017 09:40:14 -0400
In-Reply-To: <1506951605-31440-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

This just helps with later patches where after copying up metadata, we
skip data copying step, if needed.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f1b15e5c37d3..cdc4d79a1249 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -445,18 +445,6 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
@@ -480,6 +468,18 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
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
 	return 0;
 }
 
-- 
2.13.5
