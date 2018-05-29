From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 08/28] ovl: Use out_err instead of out_nomem
Date: Tue, 29 May 2018 16:45:52 +0200
Message-ID: <20180529144612.16675-9-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Right now we use goto out_nomem which assumes error code is -ENOMEM.  But
there are other errors returned like -ESTALE as well.  So instead of
out_nomem, use out_err which will do ERR_PTR(err).  That way one can put
error code in err and jump to out_err.

This just code reorganization and no change of functionality.

I am about to add more code and this organization helps laying more code
and error paths on top of it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 60c88a09a3f3..0d5615b80422 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -782,6 +782,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
 	bool is_dir;
 	unsigned long ino = 0;
+	int err = -ENOMEM;
 
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
@@ -798,7 +799,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 
 		inode = ovl_iget5(sb, oip->newinode, key);
 		if (!inode)
-			goto out_nomem;
+			goto out_err;
 		if (!(inode->i_state & I_NEW)) {
 			/*
 			 * Verify that the underlying files stored in the inode
@@ -807,8 +808,8 @@ struct inode *ovl_get_inode(struct super_block *sb,
 			if (!ovl_verify_inode(inode, lowerdentry, upperdentry,
 					      true)) {
 				iput(inode);
-				inode = ERR_PTR(-ESTALE);
-				goto out;
+				err = -ESTALE;
+				goto out_err;
 			}
 
 			dput(upperdentry);
@@ -824,8 +825,10 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	} else {
 		/* Lower hardlink that will be broken on copy up */
 		inode = new_inode(sb);
-		if (!inode)
-			goto out_nomem;
+		if (!inode) {
+			err = -ENOMEM;
+			goto out_err;
+		}
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
 	ovl_inode_init(inode, upperdentry, lowerdentry);
@@ -851,7 +854,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 out:
 	return inode;
 
-out_nomem:
-	inode = ERR_PTR(-ENOMEM);
+out_err:
+	inode = ERR_PTR(err);
 	goto out;
 }
-- 
2.14.3
