Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33938 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751216AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 24/28] ovl: Do not error if REDIRECT XATTR is missing
Date: Thu, 29 Mar 2018 15:38:50 -0400
Message-Id: <20180329193854.13814-25-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Currently we first call vfs_getxattr() to get size of REDIRECT xatttr and
then make another call vfs_getxattr() to read the xattr in buffer.

This is all part of ovl_lookup() and we do not have ovl_inode->lock. That
means it is possible that inode got copied up on another cpu and is not
a metacopy inode anymore. And that also means REDIRECT xattr got removed.
And that means that while first call to vfs_getxattr() succeeded, second
call can fail with -ENODATA.

Do not error out if -ENODATA is received from second call. With metacopy
enabled, it is not an error case anymore.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/namei.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index a7a9588f64b7..a97666245726 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -47,8 +47,15 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 		goto invalid;
 
 	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, buf, res);
-	if (res < 0)
+	if (res < 0) {
+		/*
+		 * Redirect xattr can be removed if a parallel data
+		 * copy up took place.
+		 */
+		if (res == -ENODATA)
+			goto err_free;
 		goto fail;
+	}
 	if (res == 0)
 		goto invalid;
 	if (buf[0] == '/') {
-- 
2.13.6

