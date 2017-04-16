From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 06/13] ovl: move inode helpers to inode.c
Date: Mon, 17 Apr 2017 02:59:36 +0300
Message-ID: <1492387183-18847-7-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 16 ++++++++++++++++
 fs/overlayfs/overlayfs.h |  7 ++++---
 fs/overlayfs/util.c      | 16 ----------------
 3 files changed, 20 insertions(+), 19 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 17b8418..370a015 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -381,6 +381,22 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
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
index 6257c5b..f9d2d77 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -188,9 +188,6 @@ bool ovl_redirect_fh(struct super_block *sb);
 void ovl_clear_redirect_fh(struct super_block *sb);
 bool ovl_redirect_fh_ok(const char *redirect, size_t size);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
-void ovl_inode_init(struct inode *inode, struct inode *realinode,
-		    bool is_upper);
-void ovl_inode_update(struct inode *inode, struct inode *upperinode);
 void ovl_dentry_version_inc(struct dentry *dentry);
 u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
@@ -226,7 +223,11 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
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
index 6538ec5..d202f28 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -257,22 +257,6 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
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
