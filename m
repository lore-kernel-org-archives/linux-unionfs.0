From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 04/28] ovl: During copy up, first copy up metadata and then data
Date: Tue, 29 May 2018 16:45:48 +0200
Message-ID: <20180529144612.16675-5-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Just a little re-ordering of code.  This helps with next patch where after
copying up metadata, we skip data copying step, if needed.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c | 36 +++++++++++++++++-------------------
 1 file changed, 17 insertions(+), 19 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 91b3b668482b..c072a4c0cf08 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -490,28 +490,10 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
@@ -525,7 +507,23 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
2.14.3
