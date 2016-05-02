From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [RFC 7/8] xattr: Stop calling {get,set,remove}xattr inode operations
Date: Tue,  3 May 2016 00:45:17 +0200
Message-ID: <1462229118-13123-8-git-send-email-agruenba@redhat.com>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932162AbcEBWqS (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 2 May 2016 18:46:18 -0400
In-Reply-To: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>

All filesystems that support xattrs now do so via xattr handlers.  They
all define sb->s_xattr or iop->xattr, and their getxattr, setxattr, and
removexattr inode operations use the generic methods.

On filesystems that don't support xattrs, the getxattr, setxattr, and
removexattr inode operations are still NULL, and sb->s_xattr and
iop->xattr are also NULL.

This means that we can now remove the getxattr, setxattr, and
removexattr inode operations and directly call the generic handlers, or
better, inline expand those handlers into fs/xattr.c.

Instead of checking if the {get,set,remove}xattr inode operation is
defined in __vfs_{get,set,removexattr}, respectively, use
xattr_resolve_name to find the matching handler and then check if the
requested operation (->get or ->set) is defined in that handler.  We
need to check for NULL handlers in xattr_resolve_name now; so far,
xattr_resolve_name could just assume that sb->s_xattr is defined.

Unlike with the generic_{get,set,remove}xattr inode operations, it's now
possible to define get and set operations in some xattr handlers but not
in others.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/xattr.c | 151 +++++++++++++++++++++++++++++++++----------------------------
 1 file changed, 83 insertions(+), 68 deletions(-)

diff --git a/fs/xattr.c b/fs/xattr.c
index f899196..a3fa123 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -24,6 +24,60 @@
 
 #include <asm/uaccess.h>
 
+static const char *
+strcmp_prefix(const char *a, const char *a_prefix)
+{
+	while (*a_prefix && *a == *a_prefix) {
+		a++;
+		a_prefix++;
+	}
+	return *a_prefix ? NULL : a;
+}
+
+/*
+ * In order to implement different sets of xattr operations for each xattr
+ * prefix with the generic xattr API, a filesystem should create a
+ * null-terminated array of struct xattr_handler (one for each prefix) and
+ * hang a pointer to it off of the xattr field of the inode operations or
+ * the s_xattr field of the superblock.
+ *
+ * The generic_fooxattr() functions will use this list to dispatch xattr
+ * operations to the correct xattr_handler.
+ */
+#define for_each_xattr_handler(handlers, handler)		\
+		for ((handler) = *(handlers)++;			\
+			(handler) != NULL;			\
+			(handler) = *(handlers)++)
+
+/*
+ * Find the xattr_handler with the matching prefix.
+ */
+static const struct xattr_handler *
+xattr_resolve_name(const struct dentry *dentry, const char **name)
+{
+	const struct xattr_handler *handler, **handlers;
+
+	if (!*name)
+		return NULL;
+
+	handlers = xattr_handlers(dentry->d_inode);
+	for_each_xattr_handler(handlers, handler) {
+		const char *n;
+
+		n = strcmp_prefix(*name, xattr_prefix(handler));
+		if (n) {
+			if (!handler->prefix ^ !*n) {
+				if (*n)
+					continue;
+				return ERR_PTR(-EINVAL);
+			}
+			*name = n;
+			return handler;
+		}
+	}
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
 /*
  * Check permissions for extended attribute access.  This is a bit complicated
  * because different namespaces have very different rules.
@@ -77,11 +131,16 @@ int
 __vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	       size_t size, int flags)
 {
-	struct inode *inode = dentry->d_inode;
+	const struct xattr_handler *handler;
 
-	if (!inode->i_op->setxattr)
+	handler = xattr_resolve_name(dentry, &name);
+	if (IS_ERR(handler))
+		return PTR_ERR(handler);
+	if (!handler->set)
 		return -EOPNOTSUPP;
-	return inode->i_op->setxattr(dentry, name, value, size, flags);
+	if (size == 0)
+		value = "";  /* empty EA, do not remove */
+	return handler->set(handler, dentry, name, value, size, flags);
 }
 EXPORT_SYMBOL(__vfs_setxattr);
 
@@ -111,7 +170,7 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
 
 	if (issec)
 		inode->i_flags &= ~S_NOSEC;
-	if (inode->i_op->setxattr) {
+	if (xattr_handlers(inode)) {
 		error = __vfs_setxattr(dentry, name, value, size, flags);
 		if (!error) {
 			fsnotify_xattr(dentry);
@@ -193,6 +252,7 @@ ssize_t
 vfs_getxattr_alloc(struct dentry *dentry, const char *name, char **xattr_value,
 		   size_t xattr_size, gfp_t flags)
 {
+	const struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
 	char *value = *xattr_value;
 	int error;
@@ -201,10 +261,12 @@ vfs_getxattr_alloc(struct dentry *dentry, const char *name, char **xattr_value,
 	if (error)
 		return error;
 
-	if (!inode->i_op->getxattr)
+	handler = xattr_resolve_name(dentry, &name);
+	if (IS_ERR(handler))
+		return PTR_ERR(handler);
+	if (!handler->get)
 		return -EOPNOTSUPP;
-
-	error = inode->i_op->getxattr(dentry, inode, name, NULL, 0);
+	error = handler->get(handler, dentry, inode, name, NULL, 0);
 	if (error < 0)
 		return error;
 
@@ -215,7 +277,7 @@ vfs_getxattr_alloc(struct dentry *dentry, const char *name, char **xattr_value,
 		memset(value, 0, error + 1);
 	}
 
-	error = inode->i_op->getxattr(dentry, inode, name, value, error);
+	error = handler->get(handler, dentry, inode, name, value, error);
 	*xattr_value = value;
 	return error;
 }
@@ -224,9 +286,14 @@ ssize_t
 __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
 	       void *value, size_t size)
 {
-	if (!inode->i_op->getxattr)
+	const struct xattr_handler *handler;
+
+	handler = xattr_resolve_name(dentry, &name);
+	if (IS_ERR(handler))
+		return PTR_ERR(handler);
+	if (!handler->get)
 		return -EOPNOTSUPP;
-	return inode->i_op->getxattr(dentry, inode, name, value, size);
+	return handler->get(handler, dentry, inode, name, value, size);
 }
 EXPORT_SYMBOL(__vfs_getxattr);
 
@@ -284,11 +351,14 @@ EXPORT_SYMBOL_GPL(vfs_listxattr);
 int
 __vfs_removexattr(struct dentry *dentry, const char *name)
 {
-	struct inode *inode = dentry->d_inode;
+	const struct xattr_handler *handler;
 
-	if (!inode->i_op->removexattr)
+	handler = xattr_resolve_name(dentry, &name);
+	if (IS_ERR(handler))
+		return PTR_ERR(handler);
+	if (!handler->set)
 		return -EOPNOTSUPP;
-	return inode->i_op->removexattr(dentry, name);
+	return handler->set(handler, dentry, name, NULL, 0, XATTR_REPLACE);
 }
 EXPORT_SYMBOL(__vfs_removexattr);
 
@@ -659,61 +729,6 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 	return error;
 }
 
-
-static const char *
-strcmp_prefix(const char *a, const char *a_prefix)
-{
-	while (*a_prefix && *a == *a_prefix) {
-		a++;
-		a_prefix++;
-	}
-	return *a_prefix ? NULL : a;
-}
-
-/*
- * In order to implement different sets of xattr operations for each xattr
- * prefix with the generic xattr API, a filesystem should create a
- * null-terminated array of struct xattr_handler (one for each prefix) and
- * hang a pointer to it off of the xattr field of the inode operations or
- * the s_xattr field of the superblock.
- *
- * The generic_fooxattr() functions will use this list to dispatch xattr
- * operations to the correct xattr_handler.
- */
-#define for_each_xattr_handler(handlers, handler)		\
-		for ((handler) = *(handlers)++;			\
-			(handler) != NULL;			\
-			(handler) = *(handlers)++)
-
-/*
- * Find the xattr_handler with the matching prefix.
- */
-static const struct xattr_handler *
-xattr_resolve_name(const struct dentry *dentry, const char **name)
-{
-	const struct xattr_handler *handler, **handlers;
-
-	if (!*name)
-		return NULL;
-
-	handlers = xattr_handlers(dentry->d_inode);
-	for_each_xattr_handler(handlers, handler) {
-		const char *n;
-
-		n = strcmp_prefix(*name, xattr_prefix(handler));
-		if (n) {
-			if (!handler->prefix ^ !*n) {
-				if (*n)
-					continue;
-				return ERR_PTR(-EINVAL);
-			}
-			*name = n;
-			return handler;
-		}
-	}
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
 /*
  * Find the handler for the prefix and dispatch its get() operation.
  */
-- 
2.5.5
