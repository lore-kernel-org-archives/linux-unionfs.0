Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 25/28] ovl: Use out_err insteada of out_nomem
Date: Thu, 29 Mar 2018 15:38:51 -0400
Message-Id: <20180329193854.13814-26-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Right now we use goto out_nomem which assumes error code is -ENOMEM. But
there are other errors returned like -ESTALE as well. So instead of out_nomem,
use out_err which will do ERR_PTR(err). That way one can putt error code
in err and jump to out_err.

This just code reorganization and no change of functionality.

I am about to add more code and this organization helps laying more code
and error paths on top of it.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index cd03f3e642fd..3dccfa1ee123 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -693,6 +693,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	struct inode *inode;
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
 	bool is_dir, metacopy = false;
+	int err = -ENOMEM;
 
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
@@ -710,7 +711,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 		inode = iget5_locked(sb, (unsigned long) key,
 				     ovl_inode_test, ovl_inode_set, key);
 		if (!inode)
-			goto out_nomem;
+			goto out_err;
 		if (!(inode->i_state & I_NEW)) {
 			/*
 			 * Verify that the underlying files stored in the inode
@@ -719,8 +720,8 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			if (!ovl_verify_inode(inode, lowerdentry, upperdentry,
 					      true)) {
 				iput(inode);
-				inode = ERR_PTR(-ESTALE);
-				goto out;
+				err = -ESTALE;
+				goto out_err;
 			}
 
 			dput(upperdentry);
@@ -735,8 +736,10 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
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
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
 	ovl_inode_init(inode, upperdentry, lowerdentry);
@@ -766,7 +769,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 out:
 	return inode;
 
-out_nomem:
-	inode = ERR_PTR(-ENOMEM);
+out_err:
+	inode = ERR_PTR(err);
 	goto out;
 }
-- 
2.13.6
