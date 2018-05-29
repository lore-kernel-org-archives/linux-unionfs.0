From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 02/11] ovl: remove WARN_ON() real inode attributes mismatch
Date: Tue, 29 May 2018 16:41:34 +0200
Message-ID: <20180529144143.16378-3-mszeredi@redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Overlayfs should cope with online changes to underlying layer
without crashing the kernel, which is what xfstest overlay/019
checks.

This test may sometimes trigger WARN_ON() in ovl_create_or_link()
when linking an overlay inode that has been changed on underlying
layer.

Remove those WARN_ON() to prevent the stress test from failing.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 839709c7803a..01902adc7153 100644
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
2.14.3
