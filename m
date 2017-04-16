From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 10/13] ovl: hash overlay inodes by stable inode
Date: Mon, 17 Apr 2017 02:59:40 +0300
Message-ID: <1492387183-18847-11-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:32903 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756875AbdDPX7u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Apr 2017 19:59:50 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Non directory pure upper overlay inodes are hashed
by the address of the upper real inode.

When redirect_fh feature is enabled, hash all overlay inodes
by the address of the 'stable' real inode.
The stable real inode is the pre copy up inode if it stored
in overlay.fh xattr or the pure upper real inode otherwise.

This is going to be used for looking up an overlay inode
from a real stable inode for exportfs operations.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 18 +++++++++++++++---
 fs/overlayfs/namei.c | 13 ++++++++++++-
 2 files changed, 27 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index f7d89cf..42fa243 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -412,7 +412,8 @@ void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
 {
 	ovl_inode_init_ino(inode, realinode);
 	ovl_set_inode_data(inode, realinode, is_upper);
-	if (is_upper && !S_ISDIR(realinode->i_mode))
+	if (ovl_redirect_fh(inode->i_sb) ||
+	    (is_upper && !S_ISDIR(realinode->i_mode)))
 		ovl_insert_inode_hash(inode, realinode);
 }
 
@@ -420,13 +421,24 @@ void ovl_inode_update(struct inode *inode, struct inode *upperinode)
 {
 	WARN_ON(!upperinode);
 	ovl_set_inode_data(inode, upperinode, true);
-	if (!S_ISDIR(upperinode->i_mode))
+	if (!S_ISDIR(upperinode->i_mode) && !ovl_redirect_fh(inode->i_sb))
 		ovl_insert_inode_hash(inode, upperinode);
 }
 
 static int ovl_inode_test(struct inode *inode, void *data)
 {
-	return ovl_inode_real(inode, NULL) == OVL_INODE_REAL(data);
+	struct inode *realinode = OVL_INODE_REAL(data);
+
+	/*
+	 * When all layers on same fs, compare by ino/generation of stable
+	 * real inode, because i_private may get updated on copy up, but
+	 * overlay inode ino/generation does not get updated.
+	 */
+	if (ovl_same_sb(inode->i_sb))
+		return (inode->i_ino == realinode->i_ino &&
+			inode->i_generation == realinode->i_generation);
+	else
+		return ovl_inode_real(inode, NULL) == realinode;
 }
 
 static int ovl_inode_set(struct inode *inode, void *data)
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 9569ded..7aaff83 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -469,7 +469,18 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		realinode = d_inode(realdentry);
 
 		err = -ENOMEM;
-		if (upperdentry && !d_is_dir(upperdentry)) {
+		/* When redirect_fh is enabled, hash inodes by stable inode */
+		if (ofs->config.redirect_fh) {
+			struct dentry *stable = ctr ? stack[0].dentry :
+						upperdentry;
+
+			inode = ovl_get_inode(dentry->d_sb, d_inode(stable),
+					      !!upperdentry);
+			/* ovl_inode_real() may not be the stable inode */
+			if (realinode != d_inode(stable))
+				ovl_inode_update(inode, realinode);
+
+		} else if (upperdentry && !d_is_dir(upperdentry)) {
 			inode = ovl_get_inode(dentry->d_sb, realinode, true);
 		} else {
 			inode = ovl_new_inode(dentry->d_sb, realinode->i_mode,
-- 
2.7.4
