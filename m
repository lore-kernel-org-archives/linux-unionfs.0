From: hujianyang <hujianyang@huawei.com>
Subject: [PATCH] ovl: Enable opauqe setting an removing in userspace
Date: Mon, 24 Nov 2014 18:30:20 +0800
Message-ID: <547308BC.2000401@huawei.com>
References: <54730565.4040308@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <54730565.4040308@huawei.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: miklos@szeredi.hu
Cc: "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This patch is an attempt to enbale opauqe setting and removing
in userspace. It may lead to some race conditions.

Signed-off-by: hujianyang <hujianyang@huawei.com>
---
 fs/overlayfs/inode.c |   17 +++++++++--------
 1 files changed, 9 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b072fb5..f9e3642 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -208,18 +208,25 @@ static bool ovl_is_private_xattr(const char *name)
 	return strncmp(name, OVL_XATTR_PRE_NAME, OVL_XATTR_PRE_LEN) == 0;
 }

+static bool ovl_need_xattr_filter(struct dentry *dentry,
+				  enum ovl_path_type type)
+{
+	return type == OVL_PATH_UPPER && S_ISDIR(dentry->d_inode->i_mode);
+}
+
 int ovl_setxattr(struct dentry *dentry, const char *name,
 		 const void *value, size_t size, int flags)
 {
 	int err;
 	struct dentry *upperdentry;
+	enum ovl_path_type type = ovl_path_type(dentry);

 	err = ovl_want_write(dentry);
 	if (err)
 		goto out;

 	err = -EPERM;
-	if (ovl_is_private_xattr(name))
+	if (ovl_need_xattr_filter(dentry, type) && ovl_is_private_xattr(name))
 		goto out_drop_write;

 	err = ovl_copy_up(dentry);
@@ -235,12 +242,6 @@ out:
 	return err;
 }

-static bool ovl_need_xattr_filter(struct dentry *dentry,
-				  enum ovl_path_type type)
-{
-	return type == OVL_PATH_UPPER && S_ISDIR(dentry->d_inode->i_mode);
-}
-
 ssize_t ovl_getxattr(struct dentry *dentry, const char *name,
 		     void *value, size_t size)
 {
@@ -296,7 +297,7 @@ int ovl_removexattr(struct dentry *dentry, const char *name)
 		goto out;

 	err = -ENODATA;
-	if (ovl_need_xattr_filter(dentry, type) && ovl_is_private_xattr(name))
+	if (!ovl_need_xattr_filter(dentry, type) && ovl_is_private_xattr(name))
 		goto out_drop_write;

 	if (type == OVL_PATH_LOWER) {
-- 
1.6.0.2


