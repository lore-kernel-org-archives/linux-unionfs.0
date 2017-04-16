From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 07/13] ovl: create helpers for initializing hashed inode
Date: Mon, 17 Apr 2017 02:59:37 +0300
Message-ID: <1492387183-18847-8-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36566 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756830AbdDPX7q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Apr 2017 19:59:46 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

In preparation for hashing all overlay inodes, modify the helper
ovl_inode_init() to hash a new non-dir upper overlay inode.

Use this helper for initializing new upper inode in ovl_instantiate()
instead of ovl_inode_update(), because the implementations for new inode
case and copy up case are going to diverge.

Factor out helpers ovl_inode_data() and ovl_set_inode_data(), that
are going to be used for initializing and hashing overlay inodes.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c   |  2 +-
 fs/overlayfs/inode.c | 31 ++++++++++++++++++++++++-------
 2 files changed, 25 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 6515796..d8b8982 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -175,7 +175,7 @@ static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
 	ovl_dentry_version_inc(dentry->d_parent);
 	ovl_dentry_update(dentry, newdentry);
 	if (!hardlink) {
-		ovl_inode_update(inode, d_inode(newdentry));
+		ovl_inode_init(inode, d_inode(newdentry), true);
 		ovl_copyattr(newdentry->d_inode, inode);
 	} else {
 		WARN_ON(ovl_inode_real(inode, NULL) != d_inode(newdentry));
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 370a015..a6d7c44 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -381,20 +381,37 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 	return inode;
 }
 
+static void *ovl_inode_data(struct inode *realinode, bool is_upper)
+{
+	return (void *)((unsigned long) realinode |
+			(is_upper ? OVL_ISUPPER_MASK : 0));
+}
+
+static void ovl_set_inode_data(struct inode *inode, struct inode *realinode,
+			       bool is_upper)
+{
+	WRITE_ONCE(inode->i_private, ovl_inode_data(realinode, is_upper));
+}
+
+static void ovl_insert_inode_hash(struct inode *inode, struct inode *realinode)
+{
+	WARN_ON(!inode_unhashed(inode));
+	__insert_inode_hash(inode, (unsigned long) realinode);
+}
+
 void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
 {
-	WRITE_ONCE(inode->i_private, (unsigned long) realinode |
-		   (is_upper ? OVL_ISUPPER_MASK : 0));
+	ovl_set_inode_data(inode, realinode, is_upper);
+	if (is_upper && !S_ISDIR(realinode->i_mode))
+		ovl_insert_inode_hash(inode, realinode);
 }
 
 void ovl_inode_update(struct inode *inode, struct inode *upperinode)
 {
 	WARN_ON(!upperinode);
-	WARN_ON(!inode_unhashed(inode));
-	WRITE_ONCE(inode->i_private,
-		   (unsigned long) upperinode | OVL_ISUPPER_MASK);
+	ovl_set_inode_data(inode, upperinode, true);
 	if (!S_ISDIR(upperinode->i_mode))
-		__insert_inode_hash(inode, (unsigned long) upperinode);
+		ovl_insert_inode_hash(inode, upperinode);
 }
 
 static int ovl_inode_test(struct inode *inode, void *data)
@@ -404,7 +421,7 @@ static int ovl_inode_test(struct inode *inode, void *data)
 
 static int ovl_inode_set(struct inode *inode, void *data)
 {
-	inode->i_private = (void *) (((unsigned long) data) | OVL_ISUPPER_MASK);
+	ovl_set_inode_data(inode, data, true);
 	return 0;
 }
 
-- 
2.7.4
