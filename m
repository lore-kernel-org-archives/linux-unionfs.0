Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 1/9] ovl: remove WARN_ON() real inode attributes mismatch
Date: Fri, 18 May 2018 11:29:29 +0300
Message-Id: <1526632177-28832-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Overlayfs should cope with online changes to underlying layer
without crashing the kernel, which is what xfstest overlay/019
checks.

This test may sometimes trigger WARN_ON() in ovl_create_or_link()
when linking an overlay inode that has been changed on underlying
layer.

Remove those WARN_ON() to prevent the stress test from failing.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 47dc980e8b33..33387c4887b9 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -510,13 +510,6 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 	}
 out_revert_creds:
 	revert_creds(old_cred);
-	if (!err) {
-		struct inode *realinode = d_inode(ovl_dentry_upper(dentry));
-
-		WARN_ON(inode->i_mode != realinode->i_mode);
-		WARN_ON(!uid_eq(inode->i_uid, realinode->i_uid));
-		WARN_ON(!gid_eq(inode->i_gid, realinode->i_gid));
-	}
 	return err;
 }
 
-- 
2.7.4
