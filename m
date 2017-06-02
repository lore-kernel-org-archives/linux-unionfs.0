From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 07/17] ovl: create helpers for initializing hashed inode
Date: Fri,  2 Jun 2017 17:04:34 +0300
Message-ID: <1496412284-4113-8-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35228 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751189AbdFBOEs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:48 -0400
Received: by mail-wr0-f196.google.com with SMTP id g76so1331762wrd.2
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:48 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

In preparation for hashing all overlay inodes, factor out helpers
ovl_inode_data(), ovl_inode_data_is_upper() and ovl_inode_data_real()
to set and test overlay inode i_private data content.

Those helpers are going to be used for hashing overlay inodes.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |  8 +++-----
 fs/overlayfs/overlayfs.h | 25 +++++++++++++++++++++----
 2 files changed, 24 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 753d4d4c0ad5..cfcefeb88a32 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -459,16 +459,14 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 
 void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
 {
-	WRITE_ONCE(inode->i_private, (unsigned long) realinode |
-		   (is_upper ? OVL_ISUPPER_MASK : 0));
+	WRITE_ONCE(inode->i_private, ovl_inode_data(realinode, is_upper));
 }
 
 void ovl_inode_update(struct inode *inode, struct inode *upperinode)
 {
 	WARN_ON(!upperinode);
 	WARN_ON(!inode_unhashed(inode));
-	WRITE_ONCE(inode->i_private,
-		   (unsigned long) upperinode | OVL_ISUPPER_MASK);
+	WRITE_ONCE(inode->i_private, ovl_inode_data(upperinode, true));
 	if (!S_ISDIR(upperinode->i_mode))
 		__insert_inode_hash(inode, (unsigned long) upperinode);
 }
@@ -480,7 +478,7 @@ static int ovl_inode_test(struct inode *inode, void *data)
 
 static int ovl_inode_set(struct inode *inode, void *data)
 {
-	inode->i_private = (void *) (((unsigned long) data) | OVL_ISUPPER_MASK);
+	inode->i_private = ovl_inode_data(data, true);
 	return 0;
 }
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 37e3b3902e13..21f062611360 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -75,7 +75,6 @@ struct ovl_fh {
 	u8 fid[0];	/* file identifier */
 } __packed;
 
-#define OVL_ISUPPER_MASK 1UL
 
 static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 {
@@ -190,14 +189,32 @@ static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
 	return ret;
 }
 
+#define OVL_INODE_ISUPPER_MASK 1UL
+
+static inline void *ovl_inode_data(struct inode *realinode, bool is_upper)
+{
+	return (void *)((unsigned long) realinode |
+			(is_upper ? OVL_INODE_ISUPPER_MASK : 0));
+}
+
+static inline bool ovl_inode_data_is_upper(void *data)
+{
+	return ((unsigned long)data & OVL_INODE_ISUPPER_MASK);
+}
+
+static inline struct inode *ovl_inode_data_real(void *data)
+{
+	return (struct inode *) ((unsigned long)data & ~OVL_INODE_ISUPPER_MASK);
+}
+
 static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
 {
-	unsigned long x = (unsigned long) READ_ONCE(inode->i_private);
+	void *data = READ_ONCE(inode->i_private);
 
 	if (is_upper)
-		*is_upper = x & OVL_ISUPPER_MASK;
+		*is_upper = ovl_inode_data_is_upper(data);
 
-	return (struct inode *) (x & ~OVL_ISUPPER_MASK);
+	return ovl_inode_data_real(data);
 }
 
 /* util.c */
-- 
2.7.4
