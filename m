From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 10/20] ovl: use ovl_inode_init() for initializing new inode
Date: Wed,  7 Jun 2017 10:51:14 +0300
Message-ID: <1496821884-5178-11-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36610 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdFGHv1 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:51:27 -0400
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

In preparation for hashing all overlay inodes, modify the helper
ovl_inode_init() to hash a new non-dir upper overlay inode.

Use this helper for initializing new upper inode in ovl_instantiate()
instead of ovl_inode_update(), because the implementations for new inode
case and copy up case are going to diverge.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c   |  2 +-
 fs/overlayfs/inode.c | 22 +++++++++++++++++-----
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a63a71656e9b..4f0096fee276 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -156,7 +156,7 @@ static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
 	ovl_dentry_version_inc(dentry->d_parent);
 	ovl_dentry_update(dentry, newdentry);
 	if (!hardlink) {
-		ovl_inode_update(inode, d_inode(newdentry));
+		ovl_inode_init(inode, d_inode(newdentry), true);
 		ovl_copyattr(newdentry->d_inode, inode);
 	} else {
 		WARN_ON(ovl_inode_real(inode, NULL) != d_inode(newdentry));
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ab394510736e..55f4df8c3cf1 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -451,20 +451,32 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 	return inode;
 }
 
-void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
+static void ovl_insert_inode_hash(struct inode *inode, struct inode *realinode)
+{
+	WARN_ON(!inode_unhashed(inode));
+	__insert_inode_hash(inode, (unsigned long) realinode);
+}
+
+static void ovl_inode_set_real(struct inode *inode, struct inode *realinode,
+			       bool is_upper)
 {
 	WRITE_ONCE(inode->i_private, (unsigned long) realinode |
 		   (is_upper ? OVL_ISUPPER_MASK : 0));
 }
 
+void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
+{
+	ovl_inode_set_real(inode, realinode, is_upper);
+	if (is_upper && !S_ISDIR(realinode->i_mode))
+		ovl_insert_inode_hash(inode, realinode);
+}
+
 void ovl_inode_update(struct inode *inode, struct inode *upperinode)
 {
 	WARN_ON(!upperinode);
-	WARN_ON(!inode_unhashed(inode));
-	WRITE_ONCE(inode->i_private,
-		   (unsigned long) upperinode | OVL_ISUPPER_MASK);
+	ovl_inode_set_real(inode, upperinode, true);
 	if (!S_ISDIR(upperinode->i_mode))
-		__insert_inode_hash(inode, (unsigned long) upperinode);
+		ovl_insert_inode_hash(inode, upperinode);
 }
 
 static int ovl_inode_test(struct inode *inode, void *data)
-- 
2.7.4
