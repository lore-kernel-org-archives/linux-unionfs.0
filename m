From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: do not set overlay.opaque on non-dir create
Date: Mon, 24 Apr 2017 22:26:40 +0300
Message-ID: <1493062000-10208-1-git-send-email-amir73il@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 10" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

The optimization for opaque dir create was wrongly being applied
also to non-dir create.

Fixes: 97c684cc9110 ("ovl: create directories inside merged parent opaque")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Cc: <stable@vger.kernel.org> # v4.10
---
 fs/overlayfs/dir.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 6ef35e8..5d64550 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -228,7 +228,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	if (err)
 		goto out_dput;
 
-	if (ovl_type_merge(dentry->d_parent)) {
+	if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry)) {
 		/* Setting opaque here is just an optimization, allow to fail */
 		ovl_set_opaque(dentry, newdentry);
 	}
-- 
2.7.4
