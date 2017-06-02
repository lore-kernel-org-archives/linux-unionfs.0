From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 06/17] ovl: move inode helpers to inode.c
Date: Fri,  2 Jun 2017 17:04:33 +0300
Message-ID: <1496412284-4113-7-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33104 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBOEm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:42 -0400
Received: by mail-wm0-f65.google.com with SMTP id b84so19205148wmh.0
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:41 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 16 ++++++++++++++++
 fs/overlayfs/overlayfs.h |  7 ++++---
 fs/overlayfs/util.c      | 16 ----------------
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5f285c179bbd..753d4d4c0ad5 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -457,6 +457,22 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
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
index 7ddb3a26a3da..37e3b3902e13 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -228,9 +228,6 @@ bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
-void ovl_inode_init(struct inode *inode, struct inode *realinode,
-		    bool is_upper);
-void ovl_inode_update(struct inode *inode, struct inode *upperinode);
 void ovl_dentry_version_inc(struct dentry *dentry);
 u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
@@ -282,7 +279,11 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
+void ovl_inode_init(struct inode *inode, struct inode *realinode,
+		    bool is_upper);
+void ovl_inode_update(struct inode *inode, struct inode *upperinode);
 struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode);
+
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 53c2fdb10e36..fab76415c8eb 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -244,22 +244,6 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
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
