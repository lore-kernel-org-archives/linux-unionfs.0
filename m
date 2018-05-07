Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:59020 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752272AbeEGRlM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 13:41:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 09/30] ovl: Use out_err instead of out_nomem
Date: Mon,  7 May 2018 13:40:41 -0400
Message-Id: <20180507174102.24086-10-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
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
index daab9358db07..c128d5d54d0f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -772,6 +772,7 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
 	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
 	bool is_dir;
 	unsigned long ino = 0;
+	int err = -ENOMEM;
 
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
@@ -789,7 +790,7 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
 		inode = iget5_locked(oip->sb, (unsigned long) key,
 				     ovl_inode_test, ovl_inode_set, key);
 		if (!inode)
-			goto out_nomem;
+			goto out_err;
 		if (!(inode->i_state & I_NEW)) {
 			/*
 			 * Verify that the underlying files stored in the inode
@@ -798,8 +799,8 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
 			if (!ovl_verify_inode(inode, lowerdentry, upperdentry,
 					      true)) {
 				iput(inode);
-				inode = ERR_PTR(-ESTALE);
-				goto out;
+				err = -ESTALE;
+				goto out_err;
 			}
 
 			dput(upperdentry);
@@ -815,8 +816,10 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
 	} else {
 		/* Lower hardlink that will be broken on copy up */
 		inode = new_inode(oip->sb);
-		if (!inode)
-			goto out_nomem;
+		if (!inode) {
+			err = -ENOMEM;
+			goto out_err;
+		}
 	}
 	ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev, ino, fsid);
 	ovl_inode_init(inode, upperdentry, lowerdentry);
@@ -842,7 +845,7 @@ struct inode *ovl_get_inode(struct ovl_inode_params *oip)
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

