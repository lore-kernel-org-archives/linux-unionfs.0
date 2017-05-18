From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] ovl: fix ovl_rename error handling
Date: Thu, 18 May 2017 15:34:40 +0200
Message-ID: <20170518133500.1890143-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Arnd Bergmann <arnd@arndb.de>, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

We try to clean up two objects before they got initialized:

fs/overlayfs/dir.c: In function 'ovl_rename':
fs/overlayfs/dir.c:1060:2: error: 'newdentry' may be used uninitialized in this function [-Werror=maybe-uninitialized]
fs/overlayfs/dir.c:891:17: note: 'newdentry' was declared here
fs/overlayfs/dir.c:1062:2: error: 'olddentry' may be used uninitialized in this function [-Werror=maybe-uninitialized]
fs/overlayfs/dir.c:890:17: note: 'olddentry' was declared here

Assuming that no special cleanup is required for the new code, the correct
branch target should be "out_revert_creds" to clean up everything that
got initialized up to then.

Fixes: 02cac3227a28 ("ovl: mark upper dir with type origin entries "impure"")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 fs/overlayfs/dir.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

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
 
-- 
2.9.0
