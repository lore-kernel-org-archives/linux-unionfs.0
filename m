Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH] ovl: using posix_acl_xattr_size() to get size instead of posix_acl_to_xattr()
Date: Fri, 22 Jun 2018 09:49:36 +0800
Message-Id: <20180622014936.28464-1-cgxu519@gmx.com>
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

There is no functional change but it seems better to get size by calling
posix_acl_xattr_size() instead of calling posix_acl_to_xattr() with
NULL buffer argument. Additionally, remove unnecessary assignments.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/overlayfs/dir.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f480b1a2cd2e..51c0ae62da0d 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -412,13 +412,12 @@ static int ovl_set_upper_acl(struct dentry *upperdentry, const char *name,
 	if (!IS_ENABLED(CONFIG_FS_POSIX_ACL) || !acl)
 		return 0;
 
-	size = posix_acl_to_xattr(NULL, acl, NULL, 0);
+	size = posix_acl_xattr_size(acl->a_count);
 	buffer = kmalloc(size, GFP_KERNEL);
 	if (!buffer)
 		return -ENOMEM;
 
-	size = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
-	err = size;
+	err = posix_acl_to_xattr(&init_user_ns, acl, buffer, size);
 	if (err < 0)
 		goto out_free;
 
-- 
2.17.1
