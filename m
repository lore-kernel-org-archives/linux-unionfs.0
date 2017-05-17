From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] ovl: potential Oops in ovl_rename()
Date: Wed, 17 May 2017 22:29:03 +0300
Message-ID: <20170517192903.eccqpknwlpd7axqb@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:22170 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751558AbdEQT3P (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 May 2017 15:29:15 -0400
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
Cc: linux-unionfs@vger.kernel.org, kernel-janitors@vger.kernel.org

We can't do a "goto out_dput;" because "newdentry" isn't initialized
yet.

Fixes: 02cac3227a28 ("ovl: mark upper dir with type origin entries "impure"")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 5ad6ccf2159e..9b221cf50cb7 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -973,13 +973,13 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		if (ovl_type_origin(old) && !ovl_type_merge(new->d_parent)) {
 			err = ovl_set_impure(new->d_parent, new_upperdir);
 			if (err)
-				goto out_dput;
+				goto out_revert_creds;
 		}
 		if (!overwrite && ovl_type_origin(new) &&
 		    !ovl_type_merge(old->d_parent)) {
 			err = ovl_set_impure(old->d_parent, old_upperdir);
 			if (err)
-				goto out_dput;
+				goto out_revert_creds;
 		}
 	}
 
