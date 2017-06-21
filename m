From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 13/25] ovl: store upper/lower real inode in ovl_inode_info
Date: Wed, 21 Jun 2017 15:28:44 +0300
Message-ID: <1498048136-28218-14-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33642 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751839AbdFUM3D (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:29:03 -0400
Received: by mail-wr0-f194.google.com with SMTP id x23so26118336wrb.0
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:29:02 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Introduce ovl_inode_info struct that is embedded in ovl_inode
and contains a reference to lowerinode and/or upperinode.

Storing the upper/lower real inode in ovl_inode_info replaces
the method of storing realinode & ISUPPER flag in vfs inode
i_private field.

This will be used for hashing overlay inodes before copy up.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |  5 +++--
 fs/overlayfs/overlayfs.h | 13 +------------
 fs/overlayfs/ovl_entry.h | 12 ++++++++++++
 fs/overlayfs/super.c     |  1 +
 fs/overlayfs/util.c      | 28 ++++++++++++++++++++++++----
 5 files changed, 41 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b78993abdeea..49492b982726 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -13,6 +13,7 @@
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
 #include "overlayfs.h"
+#include "ovl_entry.h"
 
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -457,12 +458,12 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 
 static int ovl_inode_test(struct inode *inode, void *data)
 {
-	return ovl_inode_real(inode, NULL) == data;
+	return OVL_I_INFO(inode)->__upperinode == data;
 }
 
 static int ovl_inode_set(struct inode *inode, void *data)
 {
-	inode->i_private = (void *) (((unsigned long) data) | OVL_ISUPPER_MASK);
+	OVL_I_INFO(inode)->__upperinode = data;
 	return 0;
 }
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index a92af10fd369..35cefa9e9de6 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -68,8 +68,6 @@ struct ovl_fh {
 	u8 fid[0];	/* file identifier */
 } __packed;
 
-#define OVL_ISUPPER_MASK 1UL
-
 static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_rmdir(dir, dentry);
@@ -183,16 +181,6 @@ static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
 	return ret;
 }
 
-static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
-{
-	unsigned long x = (unsigned long) READ_ONCE(inode->i_private);
-
-	if (is_upper)
-		*is_upper = x & OVL_ISUPPER_MASK;
-
-	return (struct inode *) (x & ~OVL_ISUPPER_MASK);
-}
-
 /* util.c */
 int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
@@ -224,6 +212,7 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
+struct inode *ovl_inode_real(struct inode *inode, bool *is_upper);
 void ovl_inode_update(struct inode *inode, struct inode *upperinode);
 void ovl_dentry_version_inc(struct dentry *dentry);
 u64 ovl_dentry_version_get(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 6c36fa70abe4..6e240bc5ac1d 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -66,9 +66,16 @@ static inline struct dentry *ovl_upperdentry_dereference(struct ovl_entry *oe)
 	return lockless_dereference(oe->__upperdentry);
 }
 
+/* private information embedded in every overlayfs inode */
+struct ovl_inode_info {
+	struct inode *__upperinode;
+	struct inode *lowerinode;
+};
+
 struct ovl_inode {
 	/* keep this first */
 	struct inode vfs_inode;
+	struct ovl_inode_info info;
 	/* synchronize copy up and more */
 	struct mutex oi_lock;
 };
@@ -77,3 +84,8 @@ static inline struct ovl_inode *OVL_I(struct inode *inode)
 {
 	return (struct ovl_inode *) inode;
 }
+
+static inline struct ovl_inode_info *OVL_I_INFO(struct inode *inode)
+{
+	return &OVL_I(inode)->info;
+}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d32ae4c00f9c..33ff179e32d7 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -181,6 +181,7 @@ static struct inode *ovl_alloc_inode(struct super_block *sb)
 		return NULL;
 
 	mutex_init(&OVL_I(inode)->oi_lock);
+	memset(OVL_I_INFO(inode), 0, sizeof(struct ovl_inode_info));
 
 	return inode;
 }
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 9d2f3bb70e61..916d4e5719a8 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -269,16 +269,36 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 
 void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
 {
-	WRITE_ONCE(inode->i_private, (unsigned long) realinode |
-		   (is_upper ? OVL_ISUPPER_MASK : 0));
+	struct ovl_inode_info *oi = OVL_I_INFO(inode);
+
+	if (is_upper) {
+		oi->__upperinode = realinode;
+		oi->lowerinode = NULL;
+	} else {
+		oi->__upperinode = NULL;
+		oi->lowerinode = realinode;
+	}
+}
+
+struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
+{
+	struct ovl_inode_info *oi = OVL_I_INFO(inode);
+	struct inode *realinode;
+
+	realinode = READ_ONCE(oi->__upperinode);
+	if (is_upper)
+		*is_upper = !!realinode;
+	if (!realinode)
+		realinode = oi->lowerinode;
+
+	return realinode;
 }
 
 void ovl_inode_update(struct inode *inode, struct inode *upperinode)
 {
 	WARN_ON(!upperinode);
 	WARN_ON(!inode_unhashed(inode));
-	WRITE_ONCE(inode->i_private,
-		   (unsigned long) upperinode | OVL_ISUPPER_MASK);
+	WRITE_ONCE(OVL_I_INFO(inode)->__upperinode, upperinode);
 	if (!S_ISDIR(upperinode->i_mode))
 		__insert_inode_hash(inode, (unsigned long) upperinode);
 }
-- 
2.7.4
