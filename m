From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 05/17] ovl: encode non-indexed upper file handles
Date: Thu,  4 Jan 2018 19:20:37 +0200
Message-ID: <1515086449-26563-6-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38488 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751682AbeADRUo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:44 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

We only need to encode origin if there is a chance that the same object was
encoded pre copy up and then we need to stay consistent with the same
encoding also after copy up.

In case a non-pure upper is not indexed, then it was copied up before NFS
export support was enabled. In that case, we don't need to worry about
staying consistent with pre copy up encoding and we encode an upper file
handle.

This mitigates the problem that with no index, we cannot find an upper
inode from origin inode, so we cannot decode a non-indexed upper from
origin file handle.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 28 +++++++++++++++++++++++-----
 1 file changed, 23 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 48ae02f3acb8..919d43aaa387 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -19,6 +19,28 @@
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
 
+/*
+ * We only need to encode origin if there is a chance that the same object was
+ * encoded pre copy up and then we need to stay consistent with the same
+ * encoding also after copy up. If non-pure upper is not indexed, then it was
+ * copied up before NFS export was enabled. In that case we don't need to worry
+ * about staying consistent with pre copy up encoding and we encode an upper
+ * file handle.
+ */
+static bool ovl_should_encode_origin(struct dentry *dentry)
+{
+	/* Root dentry was born upper */
+	if (dentry == dentry->d_sb->s_root)
+		return false;
+
+	/* Decoding a non-indexed upper from origin is not implemented */
+	if (ovl_dentry_upper(dentry) &&
+	    !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
+		return false;
+
+	return true;
+}
+
 int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
 {
 	struct dentry *upper = ovl_dentry_upper(dentry);
@@ -26,11 +48,7 @@ int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
 	struct ovl_fh *fh = NULL;
 	int err;
 
-	/*
-	 * Overlay root dir inode is encoded as an upper file handle upper,
-	 * because root dir dentry is born upper and not indexed.
-	 */
-	if (dentry == dentry->d_sb->s_root)
+	if (!ovl_should_encode_origin(dentry))
 		origin = NULL;
 
 	err = -EACCES;
-- 
2.7.4
