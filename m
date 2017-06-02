From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 09/17] ovl: allow hashing non upper inodes
Date: Fri,  2 Jun 2017 17:04:36 +0300
Message-ID: <1496412284-4113-10-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36235 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751125AbdFBOEq (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:46 -0400
Received: by mail-wr0-f194.google.com with SMTP id e23so172608wre.3
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:45 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

In preparation for hashing all overlay inodes, pass is_upper to
ovl_get_inode() and the iget5_locked() callbacks, instead of assuming
that the hashed inode is upper.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 11 ++++++-----
 fs/overlayfs/namei.c     |  2 +-
 fs/overlayfs/overlayfs.h |  3 ++-
 3 files changed, 9 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 136c19aff5e0..19df2961f1c4 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -481,22 +481,23 @@ void ovl_inode_update(struct inode *inode, struct inode *upperinode)
 
 static int ovl_inode_test(struct inode *inode, void *data)
 {
-	return ovl_inode_real(inode, NULL) == data;
+	return READ_ONCE(inode->i_private) == data;
 }
 
 static int ovl_inode_set(struct inode *inode, void *data)
 {
-	inode->i_private = ovl_inode_data(data, true);
+	inode->i_private = data;
 	return 0;
 }
 
-struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode)
-
+struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode,
+			    bool is_upper)
 {
 	struct inode *inode;
 
 	inode = iget5_locked(sb, (unsigned long) realinode,
-			     ovl_inode_test, ovl_inode_set, realinode);
+			     ovl_inode_test, ovl_inode_set,
+			     ovl_inode_data(realinode, is_upper));
 	if (inode && inode->i_state & I_NEW) {
 		ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
 		set_nlink(inode, realinode->i_nlink);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b50918b283e7..7bc570f63259 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -525,7 +525,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		err = -ENOMEM;
 		if (upperdentry && !d_is_dir(upperdentry)) {
-			inode = ovl_get_inode(dentry->d_sb, realinode);
+			inode = ovl_get_inode(dentry->d_sb, realinode, true);
 		} else {
 			inode = ovl_new_inode(dentry->d_sb, realinode->i_mode,
 					      realinode->i_rdev);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 21f062611360..b500dee7de69 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -299,7 +299,8 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
 void ovl_inode_update(struct inode *inode, struct inode *upperinode);
-struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode);
+struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode,
+			    bool is_upper);
 
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
-- 
2.7.4
