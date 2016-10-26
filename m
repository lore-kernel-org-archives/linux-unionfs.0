From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] ovl: update S_ISGID when setting posix ACLs
Date: Wed, 26 Oct 2016 21:30:16 +0300
Message-ID: <1477506616-14061-1-git-send-email-amir73il@gmail.com>
References: <1477501840-25066-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36842 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753643AbcJZSar (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Oct 2016 14:30:47 -0400
In-Reply-To: <1477501840-25066-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Since operations on upper are performed using mounter's credentials,
we need to call posix_acl_update_mode() with current credentials on
overlay inode to possibly copy-up and clear setgid bit, before setting
posix ACLs on upper inode.

Also wrap posix acl handlers with #ifdef CONFIG_FS_POSIX_ACL to
avoid compiler warning for implicit declaration of function
'posix_acl_update_mode' on build without that config option.

This change fixes xfstest generic/375, which failed to clear the
setgid bit in the following test case over overlayfs:

  touch $testfile
  chown 100:100 $testfile
  chmod 2755 $testfile
  _runas -u 100 -g 101 -- setfacl -m u::rwx,g::rwx,o::rwx $testfile

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 30263a5..7071790 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -523,6 +523,22 @@ static unsigned int ovl_split_lowerdirs(char *str)
 }
 
 static int __maybe_unused
+ovl_set_mode(struct dentry *dentry, umode_t mode)
+{
+	struct iattr iattr;
+
+	if (mode == d_inode(dentry)->i_mode)
+		return 0;
+
+	iattr.ia_valid = ATTR_MODE | ATTR_CTIME;
+	iattr.ia_mode = mode;
+	iattr.ia_ctime = current_time(d_inode(dentry));
+
+	return ovl_setattr(dentry, &iattr);
+}
+
+#ifdef CONFIG_FS_POSIX_ACL
+static int __maybe_unused
 ovl_posix_acl_xattr_get(const struct xattr_handler *handler,
 			struct dentry *dentry, struct inode *inode,
 			const char *name, void *buffer, size_t size)
@@ -560,6 +576,18 @@ ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
 	if (!inode_owner_or_capable(inode))
 		goto out_acl_release;
 
+	if (handler->flags == ACL_TYPE_ACCESS) {
+		umode_t mode;
+		struct posix_acl *newacl = acl;
+
+		err = posix_acl_update_mode(inode, &mode, &newacl);
+		if (err)
+			goto out_acl_release;
+		err = ovl_set_mode(dentry, mode);
+		if (err)
+			goto out_acl_release;
+	}
+
 	posix_acl_release(acl);
 
 	err = ovl_xattr_set(dentry, handler->name, value, size, flags);
@@ -572,6 +600,7 @@ ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
 	posix_acl_release(acl);
 	return err;
 }
+#endif
 
 static int ovl_own_xattr_get(const struct xattr_handler *handler,
 			     struct dentry *dentry, struct inode *inode,
@@ -603,6 +632,7 @@ static int ovl_other_xattr_set(const struct xattr_handler *handler,
 	return ovl_xattr_set(dentry, name, value, size, flags);
 }
 
+#ifdef CONFIG_FS_POSIX_ACL
 static const struct xattr_handler __maybe_unused
 ovl_posix_acl_access_xattr_handler = {
 	.name = XATTR_NAME_POSIX_ACL_ACCESS,
@@ -618,6 +648,7 @@ ovl_posix_acl_default_xattr_handler = {
 	.get = ovl_posix_acl_xattr_get,
 	.set = ovl_posix_acl_xattr_set,
 };
+#endif
 
 static const struct xattr_handler ovl_own_xattr_handler = {
 	.prefix	= OVL_XATTR_PREFIX,
-- 
2.7.4
