Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: set lower layer st_dev only if setting lower st_ino
Date: Wed, 11 Apr 2018 20:09:29 +0300
Message-Id: <1523466569-11765-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

For broken hardlinks, we do not return lower st_ino, so we should
also not return lower pseudo st_dev.

Fixes: a0c5ad307ac0 ("ovl: relax same fs constraint for constant st_ino")
Cc: <stable@vger.kernel.org> #v4.15
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

Miklos,

This fixes a very obvious (to me) bug.

I have a WIP unionmount-testsuite check for this.
Will sort it out and push it to my tree later.

Also pushed ovl-xino branch rebased on this bug fix.

Thanks,
Amir.

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index c95336611f83..29069f29b3a6 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -118,13 +118,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			 */
 			if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) ||
 			    (!ovl_verify_lower(dentry->d_sb) &&
-			     (is_dir || lowerstat.nlink == 1)))
+			     (is_dir || lowerstat.nlink == 1))) {
 				stat->ino = lowerstat.ino;
-
-			if (samefs)
-				WARN_ON_ONCE(stat->dev != lowerstat.dev);
-			else
 				stat->dev = ovl_get_pseudo_dev(dentry);
+			}
 		}
 		if (samefs) {
 			/*
-- 
2.7.4
