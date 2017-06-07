From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 09/20] ovl: move inode helpers to inode.c
Date: Wed,  7 Jun 2017 10:51:13 +0300
Message-ID: <1496821884-5178-10-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35800 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751203AbdFGHv0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:51:26 -0400
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 16 ++++++++++++++++
 fs/overlayfs/overlayfs.h | 31 ++++++++++++++++---------------
 fs/overlayfs/util.c      | 16 ----------------
 3 files changed, 32 insertions(+), 31 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index d613e2c41242..ab394510736e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -451,6 +451,22 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 	return inode;
 }
 
+void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
+{
+	WRITE_ONCE(inode->i_private, (unsigned long) realinode |
+		   (is_upper ? OVL_ISUPPER_MASK : 0));
+}
+
+void ovl_inode_update(struct inode *inode, struct inode *upperinode)
+{
+	WARN_ON(!upperinode);
+	WARN_ON(!inode_unhashed(inode));
+	WRITE_ONCE(inode->i_private,
+		   (unsigned long) upperinode | OVL_ISUPPER_MASK);
+	if (!S_ISDIR(upperinode->i_mode))
+		__insert_inode_hash(inode, (unsigned long) upperinode);
+}
+
 static int ovl_inode_test(struct inode *inode, void *data)
 {
 	return ovl_inode_real(inode, NULL) == data;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 47d62c585c96..c4669b6b0e20 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -64,8 +64,6 @@ struct ovl_fh {
 	u8 fid[0];	/* file identifier */
 } __packed;
 
-#define OVL_ISUPPER_MASK 1UL
-
 static inline int ovl_do_rmdir(struct inode *dir, struct dentry *dentry)
 {
 	int err = vfs_rmdir(dir, dentry);
@@ -179,16 +177,6 @@ static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
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
@@ -218,9 +206,6 @@ bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
-void ovl_inode_init(struct inode *inode, struct inode *realinode,
-		    bool is_upper);
-void ovl_inode_update(struct inode *inode, struct inode *upperinode);
 void ovl_dentry_version_inc(struct dentry *dentry);
 u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
@@ -271,7 +256,23 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
+void ovl_inode_init(struct inode *inode, struct inode *realinode,
+		    bool is_upper);
+void ovl_inode_update(struct inode *inode, struct inode *upperinode);
 struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode);
+
+#define OVL_ISUPPER_MASK 1UL
+
+static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
+{
+	unsigned long x = (unsigned long) READ_ONCE(inode->i_private);
+
+	if (is_upper)
+		*is_upper = x & OVL_ISUPPER_MASK;
+
+	return (struct inode *) (x & ~OVL_ISUPPER_MASK);
+}
+
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6048f204be07..c42eb2eb9313 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -256,22 +256,6 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 	oe->__upperdentry = upperdentry;
 }
 
-void ovl_inode_init(struct inode *inode, struct inode *realinode, bool is_upper)
-{
-	WRITE_ONCE(inode->i_private, (unsigned long) realinode |
-		   (is_upper ? OVL_ISUPPER_MASK : 0));
-}
-
-void ovl_inode_update(struct inode *inode, struct inode *upperinode)
-{
-	WARN_ON(!upperinode);
-	WARN_ON(!inode_unhashed(inode));
-	WRITE_ONCE(inode->i_private,
-		   (unsigned long) upperinode | OVL_ISUPPER_MASK);
-	if (!S_ISDIR(upperinode->i_mode))
-		__insert_inode_hash(inode, (unsigned long) upperinode);
-}
-
 void ovl_dentry_version_inc(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-- 
2.7.4
