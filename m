Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38230 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752418AbeDZTKk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 08/31] ovl: Use out_err instead of out_nomem
Date: Thu, 26 Apr 2018 15:09:50 -0400
Message-Id: <20180426191013.13219-9-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
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

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/inode.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 8a25bb569bdd..59b1c84076ec 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -778,6 +778,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	int fsid = bylower ? lowerpath->layer->fsid : 0;
 	bool is_dir;
 	unsigned long ino = 0;
+	int err = -ENOMEM;
 
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
@@ -795,7 +796,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 		inode = iget5_locked(sb, (unsigned long) key,
 				     ovl_inode_test, ovl_inode_set, key);
 		if (!inode)
-			goto out_nomem;
+			goto out_err;
 		if (!(inode->i_state & I_NEW)) {
 			/*
 			 * Verify that the underlying files stored in the inode
@@ -804,8 +805,8 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			if (!ovl_verify_inode(inode, lowerdentry, upperdentry,
 					      true)) {
 				iput(inode);
-				inode = ERR_PTR(-ESTALE);
-				goto out;
+				err = -ESTALE;
+				goto out_err;
 			}
 
 			dput(upperdentry);
@@ -821,8 +822,10 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
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
@@ -848,7 +851,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
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

