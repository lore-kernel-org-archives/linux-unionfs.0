From: Quorum Laval <quorum.laval@gmail.com>
Subject: [PATCH 1/2] ovl: use kernel facility for copying attributes
Date: Tue, 15 Nov 2016 17:54:53 +0100
Message-ID: <1479228894-10533-1-git-send-email-quorum.laval@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36236 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752090AbcKOQzH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 15 Nov 2016 11:55:07 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: Quorum Laval <quorum.laval@gmail.com>, linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org

Replace ovl_copyattr() by fsstack_copy_attr_all() and drop the definition of
the former.

Signed-off-by: Quorum Laval <quorum.laval@gmail.com>
---
 fs/overlayfs/dir.c       | 3 ++-
 fs/overlayfs/inode.c     | 3 ++-
 fs/overlayfs/overlayfs.h | 9 ---------
 fs/overlayfs/super.c     | 7 ++++---
 4 files changed, 8 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 306b6c1..dbe0153 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -15,6 +15,7 @@
 #include <linux/posix_acl.h>
 #include <linux/posix_acl_xattr.h>
 #include <linux/atomic.h>
+#include <linux/fs_stack.h>
 #include "overlayfs.h"
 
 void ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
@@ -174,7 +175,7 @@ static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
 	ovl_dentry_update(dentry, newdentry);
 	if (!hardlink) {
 		ovl_inode_update(inode, d_inode(newdentry));
-		ovl_copyattr(newdentry->d_inode, inode);
+		fsstack_copy_attr_all(inode, newdentry->d_inode);
 	} else {
 		WARN_ON(ovl_inode_real(inode, NULL) != d_inode(newdentry));
 		inc_nlink(inode);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 7fb53d0..540caa6 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
+#include <linux/fs_stack.h>
 #include "overlayfs.h"
 
 static int ovl_copy_up_truncate(struct dentry *dentry)
@@ -93,7 +94,7 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 		err = notify_change(upperdentry, attr, NULL);
 		revert_creds(old_cred);
 		if (!err)
-			ovl_copyattr(upperdentry->d_inode, dentry->d_inode);
+			fsstack_copy_attr_all(dentry->d_inode, upperdentry->d_inode);
 		inode_unlock(upperdentry->d_inode);
 
 		if (winode)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e218e74..9f15785 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -197,15 +197,6 @@ bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode);
 struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode);
-static inline void ovl_copyattr(struct inode *from, struct inode *to)
-{
-	to->i_uid = from->i_uid;
-	to->i_gid = from->i_gid;
-	to->i_mode = from->i_mode;
-	to->i_atime = from->i_atime;
-	to->i_mtime = from->i_mtime;
-	to->i_ctime = from->i_ctime;
-}
 
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index edd46a0..91a3a60 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -20,6 +20,7 @@
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/fs_stack.h>
 #include "overlayfs.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
@@ -581,7 +582,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 		if (!inode)
 			goto out_free_oe;
-		ovl_copyattr(realdentry->d_inode, inode);
+		fsstack_copy_attr_all(inode, realdentry->d_inode);
 	}
 
 	revert_creds(old_cred);
@@ -1054,7 +1055,7 @@ ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
 
 	err = ovl_xattr_set(dentry, handler->name, value, size, flags);
 	if (!err)
-		ovl_copyattr(ovl_inode_real(inode, NULL), inode);
+		fsstack_copy_attr_all(inode, ovl_inode_real(inode, NULL));
 
 	return err;
 
@@ -1345,7 +1346,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	realinode = d_inode(ovl_dentry_real(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), realinode, !!upperpath.dentry);
-	ovl_copyattr(realinode, d_inode(root_dentry));
+	fsstack_copy_attr_all(d_inode(root_dentry), realinode);
 
 	sb->s_root = root_dentry;
 
-- 
2.7.4
