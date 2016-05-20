From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 17/18] xattr: Stop calling {get,set,remove}xattr inode operations
Date: Fri, 20 May 2016 13:14:34 +0200
Message-ID: <1463742875-9836-18-git-send-email-agruenba@redhat.com>
References: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

All filesystems that support xattrs by now do so via xattr handlers.
They all define sb->s_xattr, and their getxattr, setxattr, and
removexattr inode operations use the generic inode operations.  On
filesystems that don't support xattrs, the xattr inode operations are
all NULL, and sb->s_xattr is also NULL.

This means that we can remove the getxattr, setxattr, and removexattr
inode operations and directly call the generic handlers, or better,
inline expand those handlers into fs/xattr.c.

Filesystems that do not support xattrs on some inodes should clear the
IOP_XATTR i_opflags flag in those inodes.  (Right now, some filesystems
have checks to disable xattrs on some inodes in the ->list, ->get, and
->set xattr handler operations instead.)  The IOP_XATTR flag is
automatically cleared in inodes of filesystems that don't have xattr
support.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 Documentation/filesystems/Locking | 24 +++++++++++++-----
 Documentation/filesystems/vfs.txt | 45 ++++++++++++++++++++++------------
 fs/xattr.c                        | 51 ++++++++++++++++++++++++---------------
 3 files changed, 80 insertions(+), 40 deletions(-)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 75eea7c..9cb941e 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -56,10 +56,7 @@ prototypes:
 	int (*get_acl)(struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *, struct dentry *, struct kstat *);
-	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
-	int (*removexattr) (struct dentry *, const char *);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start, u64 len);
 	void (*update_time)(struct inode *, struct timespec *, int);
 	int (*atomic_open)(struct inode *, struct dentry *,
@@ -87,16 +84,14 @@ setattr:	yes
 permission:	no (may not block if called in rcu-walk mode)
 get_acl:	no
 getattr:	no
-setxattr:	yes
-getxattr:	no
 listxattr:	no
-removexattr:	yes
 fiemap:		no
 update_time:	no
 atomic_open:	yes
 tmpfile:	no
 dentry_open:	no
 
+
 	Additionally, ->rmdir(), ->unlink() and ->rename() have ->i_mutex on
 victim.
 	cross-directory ->rename() and rename2() has (per-superblock)
@@ -105,6 +100,23 @@ victim.
 See Documentation/filesystems/directory-locking for more detailed discussion
 of the locking scheme for directory operations.
 
+----------------------- xattr_handler operations -----------------------
+protoypes:
+	bool (*list)(struct dentry *dentry);
+	int (*get)(const struct xattr_handler *handler, struct dentry *dentry,
+		   struct inode *inode, const char *name, void *buffer,
+		   size_t size);
+	int (*set)(const struct xattr_handler *handler, struct dentry *dentry,
+		   const char *name, const void *buffer, size_t size,
+		   int flags);
+
+locking rules:
+	all may block
+		i_mutex(inode)
+list:		no
+get:		no
+set:		yes
+
 --------------------------- super_operations ---------------------------
 prototypes:
 	struct inode *(*alloc_inode)(struct super_block *sb);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index c61a223..65988f7 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -323,6 +323,35 @@ Whoever sets up the inode is responsible for filling in the "i_op" field. This
 is a pointer to a "struct inode_operations" which describes the methods that
 can be performed on individual inodes.
 
+struct xattr_handlers
+---------------------
+
+On filesystems that support extended attributes (xattrs), the s_xattr
+superblock field points to a NULL-terminated array of xattr handlers.  Extended
+attributes are name:value pairs.
+
+  name: Indicates that the handler matches attributes with the specified name
+	(such as "system.posix_acl_access"); the prefix field must be NULL.
+
+  prefix: Indicates that the handler matches all attributes with the specified
+	name prefix (such as "user."); the name field must be NULL.
+
+  list: Determine if attributes matching this xattr handler should be listed
+	for a particular dentry.  Used by some listxattr implementations like
+	generic_listxattr.
+
+  get: Called by the VFS to get the value of a particular extended attribute.
+	This method is called by the getxattr(2) system call.
+
+  set: Called by the VFS to set the value of a particular extended attribute.
+	When the new value is NULL, called to remove a particular extended
+	attribute.  This method is called by the the setxattr(2) and
+	removexattr(2) system calls.
+
+When none of the xattr handlers of a filesystem match the specified attribute
+name or when a filesystem doesn't support extended attributes, the various
+*xattr(2) system calls return -EOPNOTSUPP.
+
 
 The Inode Object
 ================
@@ -356,10 +385,7 @@ struct inode_operations {
 	int (*get_acl)(struct inode *, int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
-	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-	ssize_t (*getxattr) (struct dentry *, const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
-	int (*removexattr) (struct dentry *, const char *);
 	void (*update_time)(struct inode *, struct timespec *, int);
 	int (*atomic_open)(struct inode *, struct dentry *, struct file *,
 			unsigned open_flag, umode_t create_mode, int *opened);
@@ -464,19 +490,8 @@ otherwise noted.
   getattr: called by the VFS to get attributes of a file. This method
   	is called by stat(2) and related system calls.
 
-  setxattr: called by the VFS to set an extended attribute for a file.
-  	Extended attribute is a name:value pair associated with an
-  	inode. This method is called by setxattr(2) system call.
-
-  getxattr: called by the VFS to retrieve the value of an extended
-  	attribute name. This method is called by getxattr(2) function
-  	call.
-
   listxattr: called by the VFS to list all extended attributes for a
-  	given file. This method is called by listxattr(2) system call.
-
-  removexattr: called by the VFS to remove an extended attribute from
-  	a file. This method is called by removexattr(2) system call.
+	given file. This method is called by the listxattr(2) system call.
 
   update_time: called by the VFS to update a specific time or the i_version of
   	an inode.  If this is not defined the VFS will update the inode itself
diff --git a/fs/xattr.c b/fs/xattr.c
index e9fc705..f70917b 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -36,12 +36,9 @@ strcmp_prefix(const char *a, const char *a_prefix)
 
 /*
  * In order to implement different sets of xattr operations for each xattr
- * prefix with the generic xattr API, a filesystem should create a
- * null-terminated array of struct xattr_handler (one for each prefix) and
- * hang a pointer to it off of the s_xattr field of the superblock.
- *
- * The generic_fooxattr() functions will use this list to dispatch xattr
- * operations to the correct xattr_handler.
+ * prefix, a filesystem should create a null-terminated array of struct
+ * xattr_handler (one for each prefix) and hang a pointer to it off of the
+ * s_xattr field of the superblock.
  */
 #define for_each_xattr_handler(handlers, handler)		\
 		for ((handler) = *(handlers)++;			\
@@ -132,11 +129,16 @@ int
 __vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 	       size_t size, int flags)
 {
-	struct inode *inode = dentry->d_inode;
+	const struct xattr_handler *handler;
 
-	if (!inode->i_op->setxattr)
+	handler = xattr_resolve_name(d_inode(dentry), &name);
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
 
@@ -166,7 +168,7 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
 
 	if (issec)
 		inode->i_flags &= ~S_NOSEC;
-	if (inode->i_op->setxattr) {
+	if (inode->i_opflags & IOP_XATTR) {
 		error = __vfs_setxattr(dentry, name, value, size, flags);
 		if (!error) {
 			fsnotify_xattr(dentry);
@@ -251,6 +253,7 @@ ssize_t
 vfs_getxattr_alloc(struct dentry *dentry, const char *name, char **xattr_value,
 		   size_t xattr_size, gfp_t flags)
 {
+	const struct xattr_handler *handler;
 	struct inode *inode = dentry->d_inode;
 	char *value = *xattr_value;
 	int error;
@@ -259,10 +262,12 @@ vfs_getxattr_alloc(struct dentry *dentry, const char *name, char **xattr_value,
 	if (error)
 		return error;
 
-	if (!inode->i_op->getxattr)
+	handler = xattr_resolve_name(inode, &name);
+	if (IS_ERR(handler))
+		return PTR_ERR(handler);
+	if (!handler->get)
 		return -EOPNOTSUPP;
-
-	error = inode->i_op->getxattr(dentry, inode, name, NULL, 0);
+	error = handler->get(handler, dentry, inode, name, NULL, 0);
 	if (error < 0)
 		return error;
 
@@ -273,7 +278,7 @@ vfs_getxattr_alloc(struct dentry *dentry, const char *name, char **xattr_value,
 		memset(value, 0, error + 1);
 	}
 
-	error = inode->i_op->getxattr(dentry, inode, name, value, error);
+	error = handler->get(handler, dentry, inode, name, value, error);
 	*xattr_value = value;
 	return error;
 }
@@ -282,9 +287,14 @@ ssize_t
 __vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
 	       void *value, size_t size)
 {
-	if (!inode->i_op->getxattr)
+	const struct xattr_handler *handler;
+
+	handler = xattr_resolve_name(inode, &name);
+	if (IS_ERR(handler))
+		return PTR_ERR(handler);
+	if (!handler->get)
 		return -EOPNOTSUPP;
-	return inode->i_op->getxattr(dentry, inode, name, value, size);
+	return handler->get(handler, dentry, inode, name, value, size);
 }
 EXPORT_SYMBOL(__vfs_getxattr);
 
@@ -343,11 +353,14 @@ EXPORT_SYMBOL_GPL(vfs_listxattr);
 int
 __vfs_removexattr(struct dentry *dentry, const char *name)
 {
-	struct inode *inode = dentry->d_inode;
+	const struct xattr_handler *handler;
 
-	if (!inode->i_op->removexattr)
+	handler = xattr_resolve_name(d_inode(dentry), &name);
+	if (IS_ERR(handler))
+		return PTR_ERR(handler);
+	if (!handler->set)
 		return -EOPNOTSUPP;
-	return inode->i_op->removexattr(dentry, name);
+	return handler->set(handler, dentry, name, NULL, 0, XATTR_REPLACE);
 }
 EXPORT_SYMBOL(__vfs_removexattr);
 
-- 
2.5.5
