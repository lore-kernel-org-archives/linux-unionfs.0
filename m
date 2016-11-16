From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix nested overlayfs mount
Date: Wed, 16 Nov 2016 11:22:39 +0200
Message-ID: <1479288159-20396-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33270 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752360AbcKPJXG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 16 Nov 2016 04:23:06 -0500
Received: by mail-wm0-f67.google.com with SMTP id u144so8981298wmu.0
        for <linux-unionfs@vger.kernel.org>; Wed, 16 Nov 2016 01:23:06 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

The introduction of overlayfs features broke nested mounting
of overlayfs as lowerdir of another overlayfs mount.

When the upper overlayfs checks overlayfs features xattr
on the underlying overlayfs mount, it gets -EPERM and aborts.

Fix this by returning -ENODATA instead of -EPERM from
ovl_own_xattr_get().  This behavior is consistent with the
behavior of ovl_listxattr(), which filters out the private
overlayfs xattrs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 625fa705..9815f1b 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -592,7 +592,7 @@ static int ovl_own_xattr_get(const struct xattr_handler *handler,
 			     struct dentry *dentry, struct inode *inode,
 			     const char *name, void *buffer, size_t size)
 {
-	return -EPERM;
+	return -ENODATA;
 }
 
 static int ovl_own_xattr_set(const struct xattr_handler *handler,
-- 
2.7.4
