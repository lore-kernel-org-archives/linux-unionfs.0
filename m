From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 08/13] ovl: allow hashing non upper inodes
Date: Mon, 17 Apr 2017 02:59:38 +0300
Message-ID: <1492387183-18847-9-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36571 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756758AbdDPX7s (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Apr 2017 19:59:48 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

As preparation for hashing all overlay inodes, pass is_upper to
ovl_get_inode() and the iget5_locked() callbacks, instead of assuming
that the hashed inode is upper.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 11 ++++++-----
 fs/overlayfs/namei.c     |  2 +-
 fs/overlayfs/overlayfs.h |  7 +++++--
 3 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a6d7c44..9a429ed 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -416,22 +416,23 @@ void ovl_inode_update(struct inode *inode, struct inode *upperinode)
 
 static int ovl_inode_test(struct inode *inode, void *data)
 {
-	return ovl_inode_real(inode, NULL) == data;
+	return ovl_inode_real(inode, NULL) == OVL_INODE_REAL(data);
 }
 
 static int ovl_inode_set(struct inode *inode, void *data)
 {
-	ovl_set_inode_data(inode, data, true);
+	WRITE_ONCE(inode->i_private, data);
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
index 42b6030..9569ded 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -470,7 +470,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		err = -ENOMEM;
 		if (upperdentry && !d_is_dir(upperdentry)) {
-			inode = ovl_get_inode(dentry->d_sb, realinode);
+			inode = ovl_get_inode(dentry->d_sb, realinode, true);
 		} else {
 			inode = ovl_new_inode(dentry->d_sb, realinode->i_mode,
 					      realinode->i_rdev);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f9d2d77..dacee9e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -23,6 +23,8 @@ enum ovl_path_type {
 #define OVL_XATTR_FH OVL_XATTR_PREFIX "fh"
 
 #define OVL_ISUPPER_MASK 1UL
+#define OVL_INODE_REAL(x) ((struct inode *) \
+			   ((unsigned long)x & ~OVL_ISUPPER_MASK))
 
 static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 {
@@ -144,7 +146,7 @@ static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
 	if (is_upper)
 		*is_upper = x & OVL_ISUPPER_MASK;
 
-	return (struct inode *) (x & ~OVL_ISUPPER_MASK);
+	return OVL_INODE_REAL(x);
 }
 
 /* redirect data format for redirect by file handle */
@@ -226,7 +228,8 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
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
