From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 08/17] ovl: use ovl_inode_init() for initializing new inode
Date: Fri,  2 Jun 2017 17:04:35 +0300
Message-ID: <1496412284-4113-9-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33121 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdFBOEu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:50 -0400
Received: by mail-wm0-f65.google.com with SMTP id b84so19205263wmh.0
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:44 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

In preparation for hashing all overlay inodes, modify the helper
ovl_inode_init() to hash a new non-dir upper overlay inode.

Use this helper for initializing new upper inode in ovl_instantiate()
instead of ovl_inode_update(), because the implementations for new inode
case and copy up case are going to diverge.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c   |  2 +-
 fs/overlayfs/inode.c | 12 ++++++++++--
 2 files changed, 11 insertions(+), 3 deletions(-)

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
index cfcefeb88a32..136c19aff5e0 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -457,18 +457,26 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 	return inode;
 }
 
+static void ovl_insert_inode_hash(struct inode *inode, struct inode *realinode)
+{
+	WARN_ON(!inode_unhashed(inode));
+	__insert_inode_hash(inode, (unsigned long) realinode);
+}
+
 void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
 {
+
 	WRITE_ONCE(inode->i_private, ovl_inode_data(realinode, is_upper));
+	if (is_upper && !S_ISDIR(realinode->i_mode))
+		ovl_insert_inode_hash(inode, realinode);
 }
 
 void ovl_inode_update(struct inode *inode, struct inode *upperinode)
 {
 	WARN_ON(!upperinode);
-	WARN_ON(!inode_unhashed(inode));
 	WRITE_ONCE(inode->i_private, ovl_inode_data(upperinode, true));
 	if (!S_ISDIR(upperinode->i_mode))
-		__insert_inode_hash(inode, (unsigned long) upperinode);
+		ovl_insert_inode_hash(inode, upperinode);
 }
 
 static int ovl_inode_test(struct inode *inode, void *data)
-- 
2.7.4
