From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [RFC 5/8] xattr: Add per-inode xattr handlers as a new inode operation
Date: Tue,  3 May 2016 00:45:15 +0200
Message-ID: <1462229118-13123-6-git-send-email-agruenba@redhat.com>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>
List-Id: linux-unionfs@vger.kernel.org

Per-inode xattr handlers allow to mark inodes as bad and dirs as "empty"
in the usual way even when using generic_getxattr, generic_setxattr, and
generic_removexattr.  This brings us one step closer to getting rid of
the getxattr, setxattr, and removexattr inode operations.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bad_inode.c        | 36 +++++++++++++++++++++++-------------
 fs/libfs.c            | 29 +++++++++--------------------
 fs/xattr.c            | 17 ++++++++++-------
 include/linux/fs.h    |  1 +
 include/linux/xattr.h |  6 ++++++
 5 files changed, 49 insertions(+), 40 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 72e35b7..e9227ea2d 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -14,6 +14,7 @@
 #include <linux/time.h>
 #include <linux/namei.h>
 #include <linux/poll.h>
+#include <linux/xattr.h>
 
 static int bad_file_open(struct inode *inode, struct file *filp)
 {
@@ -100,28 +101,36 @@ static int bad_inode_setattr(struct dentry *direntry, struct iattr *attrs)
 	return -EIO;
 }
 
-static int bad_inode_setxattr(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags)
+static ssize_t bad_inode_listxattr(struct dentry *dentry, char *buffer,
+			size_t buffer_size)
 {
 	return -EIO;
 }
 
-static ssize_t bad_inode_getxattr(struct dentry *dentry, struct inode *inode,
-			const char *name, void *buffer, size_t size)
+static int bad_inode_xattr_get(const struct xattr_handler *handler,
+			       struct dentry *dentry, struct inode *inode,
+			       const char *name, void *buffer, size_t size)
 {
 	return -EIO;
 }
 
-static ssize_t bad_inode_listxattr(struct dentry *dentry, char *buffer,
-			size_t buffer_size)
+static int bad_inode_xattr_set(const struct xattr_handler *handler,
+			       struct dentry *dentry, const char *name,
+			       const void *buffer, size_t size, int flags)
 {
 	return -EIO;
 }
 
-static int bad_inode_removexattr(struct dentry *dentry, const char *name)
-{
-	return -EIO;
-}
+static const struct xattr_handler bad_inode_xattr_handler = {
+	.prefix = "",  /* match anything */
+	.get = bad_inode_xattr_get,
+	.set = bad_inode_xattr_set,
+};
+
+static const struct xattr_handler *bad_inode_xattr_handlers[] = {
+	&bad_inode_xattr_handler,
+	NULL
+};
 
 static const struct inode_operations bad_inode_ops =
 {
@@ -142,10 +151,11 @@ static const struct inode_operations bad_inode_ops =
 	.permission	= bad_inode_permission,
 	.getattr	= bad_inode_getattr,
 	.setattr	= bad_inode_setattr,
-	.setxattr	= bad_inode_setxattr,
-	.getxattr	= bad_inode_getxattr,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= bad_inode_listxattr,
-	.removexattr	= bad_inode_removexattr,
+	.removexattr	= generic_removexattr,
+	.xattr		= bad_inode_xattr_handlers,
 };
 
 
diff --git a/fs/libfs.c b/fs/libfs.c
index 2a820bb..a7cea0a 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -15,6 +15,7 @@
 #include <linux/exportfs.h>
 #include <linux/writeback.h>
 #include <linux/buffer_head.h> /* sync_mapping_buffers */
+#include <linux/xattr.h>
 
 #include <asm/uaccess.h>
 
@@ -1122,37 +1123,25 @@ static int empty_dir_setattr(struct dentry *dentry, struct iattr *attr)
 	return -EPERM;
 }
 
-static int empty_dir_setxattr(struct dentry *dentry, const char *name,
-			      const void *value, size_t size, int flags)
-{
-	return -EOPNOTSUPP;
-}
-
-static ssize_t empty_dir_getxattr(struct dentry *dentry, struct inode *inode,
-				  const char *name, void *value, size_t size)
-{
-	return -EOPNOTSUPP;
-}
-
-static int empty_dir_removexattr(struct dentry *dentry, const char *name)
-{
-	return -EOPNOTSUPP;
-}
-
 static ssize_t empty_dir_listxattr(struct dentry *dentry, char *list, size_t size)
 {
 	return -EOPNOTSUPP;
 }
 
+static const struct xattr_handler *empty_dir_xattr_handlers[] = {
+	NULL
+};
+
 static const struct inode_operations empty_dir_inode_operations = {
 	.lookup		= empty_dir_lookup,
 	.permission	= generic_permission,
 	.setattr	= empty_dir_setattr,
 	.getattr	= empty_dir_getattr,
-	.setxattr	= empty_dir_setxattr,
-	.getxattr	= empty_dir_getxattr,
-	.removexattr	= empty_dir_removexattr,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.removexattr	= generic_removexattr,
 	.listxattr	= empty_dir_listxattr,
+	.xattr		= empty_dir_xattr_handlers,
 };
 
 static loff_t empty_dir_llseek(struct file *file, loff_t offset, int whence)
diff --git a/fs/xattr.c b/fs/xattr.c
index b11945e..68e093e 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -649,7 +649,8 @@ strcmp_prefix(const char *a, const char *a_prefix)
  * In order to implement different sets of xattr operations for each xattr
  * prefix with the generic xattr API, a filesystem should create a
  * null-terminated array of struct xattr_handler (one for each prefix) and
- * hang a pointer to it off of the s_xattr field of the superblock.
+ * hang a pointer to it off of the xattr field of the inode operations or
+ * the s_xattr field of the superblock.
  *
  * The generic_fooxattr() functions will use this list to dispatch xattr
  * operations to the correct xattr_handler.
@@ -663,13 +664,14 @@ strcmp_prefix(const char *a, const char *a_prefix)
  * Find the xattr_handler with the matching prefix.
  */
 static const struct xattr_handler *
-xattr_resolve_name(const struct xattr_handler **handlers, const char **name)
+xattr_resolve_name(const struct dentry *dentry, const char **name)
 {
-	const struct xattr_handler *handler;
+	const struct xattr_handler *handler, **handlers;
 
 	if (!*name)
 		return NULL;
 
+	handlers = xattr_handlers(dentry->d_inode);
 	for_each_xattr_handler(handlers, handler) {
 		const char *n;
 
@@ -696,7 +698,7 @@ generic_getxattr(struct dentry *dentry, struct inode *inode,
 {
 	const struct xattr_handler *handler;
 
-	handler = xattr_resolve_name(dentry->d_sb->s_xattr, &name);
+	handler = xattr_resolve_name(dentry, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
 	return handler->get(handler, dentry, inode,
@@ -710,9 +712,10 @@ generic_getxattr(struct dentry *dentry, struct inode *inode,
 ssize_t
 generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 {
-	const struct xattr_handler *handler, **handlers = dentry->d_sb->s_xattr;
+	const struct xattr_handler *handler, **handlers;
 	unsigned int size = 0;
 
+	handlers = xattr_handlers(dentry->d_inode);
 	if (!buffer) {
 		for_each_xattr_handler(handlers, handler) {
 			if (!handler->name ||
@@ -750,7 +753,7 @@ generic_setxattr(struct dentry *dentry, const char *name, const void *value, siz
 
 	if (size == 0)
 		value = "";  /* empty EA, do not remove */
-	handler = xattr_resolve_name(dentry->d_sb->s_xattr, &name);
+	handler = xattr_resolve_name(dentry, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
 	return handler->set(handler, dentry, name, value, size, flags);
@@ -765,7 +768,7 @@ generic_removexattr(struct dentry *dentry, const char *name)
 {
 	const struct xattr_handler *handler;
 
-	handler = xattr_resolve_name(dentry->d_sb->s_xattr, &name);
+	handler = xattr_resolve_name(dentry, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
 	return handler->set(handler, dentry, name, NULL, 0, XATTR_REPLACE);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3489609..4f25cd3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1714,6 +1714,7 @@ struct inode_operations {
 			   umode_t create_mode, int *opened);
 	int (*tmpfile) (struct inode *, struct dentry *, umode_t);
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
+	const struct xattr_handler **xattr;
 } ____cacheline_aligned;
 
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 1cc4c57..2d30a3b 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -14,6 +14,7 @@
 #include <linux/slab.h>
 #include <linux/types.h>
 #include <linux/spinlock.h>
+#include <linux/fs.h>
 #include <uapi/linux/xattr.h>
 
 struct inode;
@@ -64,6 +65,11 @@ static inline const char *xattr_prefix(const struct xattr_handler *handler)
 	return handler->prefix ?: handler->name;
 }
 
+static inline const struct xattr_handler **xattr_handlers(struct inode *inode)
+{
+	return inode->i_op->xattr ?: inode->i_sb->s_xattr;
+}
+
 struct simple_xattrs {
 	struct list_head head;
 	spinlock_t lock;
-- 
2.5.5
