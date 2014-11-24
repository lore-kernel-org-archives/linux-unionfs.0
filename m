From: hujianyang <hujianyang@huawei.com>
Subject: [PATCH] ovl: Use macros to present ovl_xattr
Date: Mon, 24 Nov 2014 18:25:21 +0800
Message-ID: <54730791.2020901@huawei.com>
References: <54730565.4040308@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga02-in.huawei.com ([119.145.14.65]:20646 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337AbaKXKZc (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 24 Nov 2014 05:25:32 -0500
In-Reply-To: <54730565.4040308@huawei.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org

This patch adds two macros:

OVL_XATTR_PRE_NAME and OVL_XATTR_PRE_LEN

to present ovl_xattr name prefix and its length. Also, a
new macro OVL_XATTR_OPAQUE is introduced to replace old
*ovl_opaque_xattr*.

Fix the length of "trusted.overlay." to *16*.

Signed-off-by: hujianyang <hujianyang@huawei.com>
---
 fs/overlayfs/dir.c       |    4 ++--
 fs/overlayfs/inode.c     |    2 +-
 fs/overlayfs/overlayfs.h |    4 +++-
 fs/overlayfs/super.c     |    5 +----
 4 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 8ffc4b9..7da3f17 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -118,14 +118,14 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,

 static int ovl_set_opaque(struct dentry *upperdentry)
 {
-	return ovl_do_setxattr(upperdentry, ovl_opaque_xattr, "y", 1, 0);
+	return ovl_do_setxattr(upperdentry, OVL_XATTR_OPAQUE, "y", 1, 0);
 }

 static void ovl_remove_opaque(struct dentry *upperdentry)
 {
 	int err;

-	err = ovl_do_removexattr(upperdentry, ovl_opaque_xattr);
+	err = ovl_do_removexattr(upperdentry, OVL_XATTR_OPAQUE);
 	if (err) {
 		pr_warn("overlayfs: failed to remove opaque from '%s' (%i)\n",
 			upperdentry->d_name.name, err);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 07d74b2..b072fb5 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -205,7 +205,7 @@ static int ovl_readlink(struct dentry *dentry, char __user *buf, int bufsiz)

 static bool ovl_is_private_xattr(const char *name)
 {
-	return strncmp(name, "trusted.overlay.", 14) == 0;
+	return strncmp(name, OVL_XATTR_PRE_NAME, OVL_XATTR_PRE_LEN) == 0;
 }

 int ovl_setxattr(struct dentry *dentry, const char *name,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 814bed3..285994f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -18,7 +18,9 @@ enum ovl_path_type {
 	OVL_PATH_LOWER,
 };

-extern const char *ovl_opaque_xattr;
+#define OVL_XATTR_PRE_NAME "trusted.overlay."
+#define OVL_XATTR_PRE_LEN  16
+#define OVL_XATTR_OPAQUE   OVL_XATTR_PRE_NAME"opaque"

 static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f16d318..80afc7f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -58,9 +58,6 @@ struct ovl_entry {
 	};
 };

-const char *ovl_opaque_xattr = "trusted.overlay.opaque";
-
-
 enum ovl_path_type ovl_path_type(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -249,7 +246,7 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
 	if (!S_ISDIR(inode->i_mode) || !inode->i_op->getxattr)
 		return false;

-	res = inode->i_op->getxattr(dentry, ovl_opaque_xattr, &val, 1);
+	res = inode->i_op->getxattr(dentry, OVL_XATTR_OPAQUE, &val, 1);
 	if (res == 1 && val == 'y')
 		return true;

-- 
1.6.0.2

