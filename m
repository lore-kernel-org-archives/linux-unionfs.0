From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 10/17] ovl: allow hashing inodes by arbitrary key
Date: Fri,  2 Jun 2017 17:04:37 +0300
Message-ID: <1496412284-4113-11-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34377 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750955AbdFBOEr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:47 -0400
Received: by mail-wm0-f67.google.com with SMTP id d127so19134313wmf.1
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:47 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

In preparation for hashing all overlay inodes, pass realinode to
ovl_get_inode() as explicit hashval argument, instead of implicitly
assuming that overlay inodes are hashed by the realinode address.

realinode is also passed to ovl_get_inode() as an independent argument,
that is used as the context to the iget5_locked() test/set callbacks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 7 +++----
 fs/overlayfs/namei.c     | 4 +++-
 fs/overlayfs/overlayfs.h | 4 ++--
 3 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 19df2961f1c4..1e89885d5304 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -490,13 +490,12 @@ static int ovl_inode_set(struct inode *inode, void *data)
 	return 0;
 }
 
-struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode,
-			    bool is_upper)
+struct inode *ovl_get_inode(struct super_block *sb, unsigned long hashval,
+			    struct inode *realinode, bool is_upper)
 {
 	struct inode *inode;
 
-	inode = iget5_locked(sb, (unsigned long) realinode,
-			     ovl_inode_test, ovl_inode_set,
+	inode = iget5_locked(sb, hashval, ovl_inode_test, ovl_inode_set,
 			     ovl_inode_data(realinode, is_upper));
 	if (inode && inode->i_state & I_NEW) {
 		ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 7bc570f63259..615fb23fcba5 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -525,7 +525,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		err = -ENOMEM;
 		if (upperdentry && !d_is_dir(upperdentry)) {
-			inode = ovl_get_inode(dentry->d_sb, realinode, true);
+			inode = ovl_get_inode(dentry->d_sb,
+					      (unsigned long) realinode,
+					      realinode, true);
 		} else {
 			inode = ovl_new_inode(dentry->d_sb, realinode->i_mode,
 					      realinode->i_rdev);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b500dee7de69..db3c7641efe6 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -299,8 +299,8 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
 void ovl_inode_update(struct inode *inode, struct inode *upperinode);
-struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode,
-			    bool is_upper);
+struct inode *ovl_get_inode(struct super_block *sb, unsigned long hashval,
+			    struct inode *realinode, bool is_upper);
 
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
-- 
2.7.4
