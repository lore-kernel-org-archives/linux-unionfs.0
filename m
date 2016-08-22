From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH 3/4] ovl: Switch to generic_removexattr
Date: Mon, 22 Aug 2016 20:06:33 +0200
Message-ID: <1471889194-31218-4-git-send-email-agruenba@redhat.com>
References: <1471889194-31218-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39090 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755849AbcHVSGn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Aug 2016 14:06:43 -0400
In-Reply-To: <1471889194-31218-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, Andreas Gruenbacher <agruenba@redhat.com>

Commit d837a49b switches from iop->setxattr from ovl_setxattr to
generic_setxattr, so switch from ovl_removexattr to generic_removexattr
as well.  As far as permission checking goes, the same rules should
apply in either case.

While doing that, rename ovl_setxattr to ovl_xattr_set to indicate that
this is not an iop->setxattr implementation and remove the unused inode
argument.

Move ovl_other_xattr_set above ovl_own_xattr_set so that they match the
order of handlers in ovl_xattr_handlers.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/overlayfs/dir.c       |  2 +-
 fs/overlayfs/inode.c     | 65 ++++++++++++++++--------------------------------
 fs/overlayfs/overlayfs.h |  6 ++---
 fs/overlayfs/super.c     | 18 +++++++-------
 4 files changed, 33 insertions(+), 58 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 12bcd07..7823480 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -952,7 +952,7 @@ const struct inode_operations ovl_dir_inode_operations = {
 	.setxattr	= generic_setxattr,
 	.getxattr	= ovl_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= ovl_removexattr,
+	.removexattr	= generic_removexattr,
 	.get_acl	= ovl_get_acl,
 	.update_time	= ovl_update_time,
 };
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 859e42c..4f348ca 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -197,25 +197,38 @@ static bool ovl_is_private_xattr(const char *name)
 		       sizeof(OVL_XATTR_PREFIX) - 1) == 0;
 }
 
-int ovl_setxattr(struct dentry *dentry, struct inode *inode,
-		 const char *name, const void *value,
-		 size_t size, int flags)
+int ovl_xattr_set(struct dentry *dentry, const char *name, const void *value,
+		  size_t size, int flags)
 {
 	int err;
-	struct dentry *upperdentry;
+	struct path realpath;
+	enum ovl_path_type type = ovl_path_real(dentry, &realpath);
 	const struct cred *old_cred;
 
 	err = ovl_want_write(dentry);
 	if (err)
 		goto out;
 
+	if (!value && !OVL_TYPE_UPPER(type)) {
+		err = vfs_getxattr(realpath.dentry, name, NULL, 0);
+		if (err < 0)
+			goto out_drop_write;
+	}
+
 	err = ovl_copy_up(dentry);
 	if (err)
 		goto out_drop_write;
 
-	upperdentry = ovl_dentry_upper(dentry);
+	if (!OVL_TYPE_UPPER(type))
+		ovl_path_upper(dentry, &realpath);
+
 	old_cred = ovl_override_creds(dentry->d_sb);
-	err = vfs_setxattr(upperdentry, name, value, size, flags);
+	if (value)
+		err = vfs_setxattr(realpath.dentry, name, value, size, flags);
+	else {
+		BUG_ON(flags != XATTR_REPLACE);
+		err = vfs_removexattr(realpath.dentry, name);
+	}
 	revert_creds(old_cred);
 
 out_drop_write:
@@ -271,42 +284,6 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 	return res;
 }
 
-int ovl_removexattr(struct dentry *dentry, const char *name)
-{
-	int err;
-	struct path realpath;
-	enum ovl_path_type type = ovl_path_real(dentry, &realpath);
-	const struct cred *old_cred;
-
-	err = ovl_want_write(dentry);
-	if (err)
-		goto out;
-
-	err = -ENODATA;
-	if (ovl_is_private_xattr(name))
-		goto out_drop_write;
-
-	if (!OVL_TYPE_UPPER(type)) {
-		err = vfs_getxattr(realpath.dentry, name, NULL, 0);
-		if (err < 0)
-			goto out_drop_write;
-
-		err = ovl_copy_up(dentry);
-		if (err)
-			goto out_drop_write;
-
-		ovl_path_upper(dentry, &realpath);
-	}
-
-	old_cred = ovl_override_creds(dentry->d_sb);
-	err = vfs_removexattr(realpath.dentry, name);
-	revert_creds(old_cred);
-out_drop_write:
-	ovl_drop_write(dentry);
-out:
-	return err;
-}
-
 struct posix_acl *ovl_get_acl(struct inode *inode, int type)
 {
 	struct inode *realinode = ovl_inode_real(inode, NULL);
@@ -392,7 +369,7 @@ static const struct inode_operations ovl_file_inode_operations = {
 	.setxattr	= generic_setxattr,
 	.getxattr	= ovl_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= ovl_removexattr,
+	.removexattr	= generic_removexattr,
 	.get_acl	= ovl_get_acl,
 	.update_time	= ovl_update_time,
 };
@@ -405,7 +382,7 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.setxattr	= generic_setxattr,
 	.getxattr	= ovl_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= ovl_removexattr,
+	.removexattr	= generic_removexattr,
 	.update_time	= ovl_update_time,
 };
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 77fd667..951c8f5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -183,13 +183,11 @@ int ovl_check_d_type_supported(struct path *realpath);
 /* inode.c */
 int ovl_setattr(struct dentry *dentry, struct iattr *attr);
 int ovl_permission(struct inode *inode, int mask);
-int ovl_setxattr(struct dentry *dentry, struct inode *inode,
-		 const char *name, const void *value,
-		 size_t size, int flags);
+int ovl_xattr_set(struct dentry *dentry, const char *name, const void *value,
+		  size_t size, int flags);
 ssize_t ovl_getxattr(struct dentry *dentry, struct inode *inode,
 		     const char *name, void *value, size_t size);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
-int ovl_removexattr(struct dentry *dentry, const char *name);
 struct posix_acl *ovl_get_acl(struct inode *inode, int type);
 int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e2b555d..9eb3f82 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -999,21 +999,13 @@ ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
 
 	posix_acl_release(acl);
 
-	return ovl_setxattr(dentry, inode, handler->name, value, size, flags);
+	return ovl_xattr_set(dentry, handler->name, value, size, flags);
 
 out_acl_release:
 	posix_acl_release(acl);
 	return err;
 }
 
-static int ovl_other_xattr_set(const struct xattr_handler *handler,
-			       struct dentry *dentry, struct inode *inode,
-			       const char *name, const void *value,
-			       size_t size, int flags)
-{
-	return ovl_setxattr(dentry, inode, name, value, size, flags);
-}
-
 static int ovl_own_xattr_set(const struct xattr_handler *handler,
 			     struct dentry *dentry, struct inode *inode,
 			     const char *name, const void *value,
@@ -1022,6 +1014,14 @@ static int ovl_own_xattr_set(const struct xattr_handler *handler,
 	return -EPERM;
 }
 
+static int ovl_other_xattr_set(const struct xattr_handler *handler,
+			       struct dentry *dentry, struct inode *inode,
+			       const char *name, const void *value,
+			       size_t size, int flags)
+{
+	return ovl_xattr_set(dentry, name, value, size, flags);
+}
+
 static const struct xattr_handler __maybe_unused
 ovl_posix_acl_access_xattr_handler = {
 	.name = XATTR_NAME_POSIX_ACL_ACCESS,
-- 
2.7.4
