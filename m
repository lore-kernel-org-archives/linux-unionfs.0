From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 09/13] ovl: inherit overlay inode ino/generation from real inode
Date: Mon, 17 Apr 2017 02:59:39 +0300
Message-ID: <1492387183-18847-10-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:34651 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756845AbdDPX7t (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Apr 2017 19:59:49 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When all layers are on same fs, initialize overlay inode with
ino/generation of a real inode.

Move initialization of overlay inode ino from ovl_fill_inode()
to when real inode is available, but before a new inode is inserted
to hash.

This does not affect the result of stat(2) of an overlay file,
which always returns the current real inode number.

The overlay ino is going to be used for overlay inodes lookup
by stable inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 9a429ed..f7d89cf 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -340,7 +340,6 @@ static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
 
 static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
 {
-	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
 	inode->i_flags |= S_NOCMTIME;
 #ifdef CONFIG_FS_POSIX_ACL
@@ -393,6 +392,16 @@ static void ovl_set_inode_data(struct inode *inode, struct inode *realinode,
 	WRITE_ONCE(inode->i_private, ovl_inode_data(realinode, is_upper));
 }
 
+static void ovl_inode_init_ino(struct inode *inode, struct inode *realinode)
+{
+	if (ovl_same_sb(inode->i_sb)) {
+		inode->i_ino = realinode->i_ino;
+		inode->i_generation = realinode->i_generation;
+	} else {
+		inode->i_ino = get_next_ino();
+	}
+}
+
 static void ovl_insert_inode_hash(struct inode *inode, struct inode *realinode)
 {
 	WARN_ON(!inode_unhashed(inode));
@@ -401,6 +410,7 @@ static void ovl_insert_inode_hash(struct inode *inode, struct inode *realinode)
 
 void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
 {
+	ovl_inode_init_ino(inode, realinode);
 	ovl_set_inode_data(inode, realinode, is_upper);
 	if (is_upper && !S_ISDIR(realinode->i_mode))
 		ovl_insert_inode_hash(inode, realinode);
@@ -421,6 +431,7 @@ static int ovl_inode_test(struct inode *inode, void *data)
 
 static int ovl_inode_set(struct inode *inode, void *data)
 {
+	ovl_inode_init_ino(inode, OVL_INODE_REAL(data));
 	WRITE_ONCE(inode->i_private, data);
 	return 0;
 }
-- 
2.7.4
