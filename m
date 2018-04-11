Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ovl: adjust memory allocation size for stack in ovl_lookup
Date: Wed, 11 Apr 2018 11:42:13 +0800
Message-Id: <1523418133-93764-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

In ovl_lookup, the number of lowerstack entry is no bigger
than poe->numlower, so adjust memory allocation size for stack.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/overlayfs/namei.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 2dba29e..81dbc3f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -888,7 +888,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (!d.stop && poe->numlower) {
 		err = -ENOMEM;
-		stack = kcalloc(ofs->numlower, sizeof(struct ovl_path),
+		stack = kcalloc(poe->numlower, sizeof(struct ovl_path),
 				GFP_KERNEL);
 		if (!stack)
 			goto out_put_upper;
-- 
1.8.3.1
