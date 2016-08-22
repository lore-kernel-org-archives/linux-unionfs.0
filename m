From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v4 10/20] sockfs: Get rid of getxattr iop
Date: Mon, 22 Aug 2016 23:21:58 +0200
Message-ID: <1471900928-21588-11-git-send-email-agruenba@redhat.com>
References: <1471900928-21588-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1471900928-21588-1-git-send-email-agruenba@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

If we allow pseudo-filesystems created with mount_pseudo to have xattr
handlers, we can replace sockfs_getxattr with a sockfs_xattr_get handler
to use the xattr handler name parsing.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/libfs.c         |  7 ++++---
 include/linux/fs.h | 17 +++++++++++++----
 net/socket.c       | 50 ++++++++++++++++++++++++++++++--------------------
 3 files changed, 47 insertions(+), 27 deletions(-)

diff --git a/fs/libfs.c b/fs/libfs.c
index 74dc8b9..cfa9576 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -236,8 +236,8 @@ static const struct super_operations simple_super_operations = {
  * Common helper for pseudo-filesystems (sockfs, pipefs, bdev - stuff that
  * will never be mountable)
  */
-struct dentry *mount_pseudo(struct file_system_type *fs_type, char *name,
-	const struct super_operations *ops,
+struct dentry *mount_pseudo_xattr(struct file_system_type *fs_type, char *name,
+	const struct super_operations *ops, const struct xattr_handler **xattr,
 	const struct dentry_operations *dops, unsigned long magic)
 {
 	struct super_block *s;
@@ -254,6 +254,7 @@ struct dentry *mount_pseudo(struct file_system_type *fs_type, char *name,
 	s->s_blocksize_bits = PAGE_SHIFT;
 	s->s_magic = magic;
 	s->s_op = ops ? ops : &simple_super_operations;
+	s->s_xattr = xattr;
 	s->s_time_gran = 1;
 	root = new_inode(s);
 	if (!root)
@@ -281,7 +282,7 @@ Enomem:
 	deactivate_locked_super(s);
 	return ERR_PTR(-ENOMEM);
 }
-EXPORT_SYMBOL(mount_pseudo);
+EXPORT_SYMBOL(mount_pseudo_xattr);
 
 int simple_open(struct inode *inode, struct file *file)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 3523bf6..022aa88 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2074,10 +2074,19 @@ struct super_block *sget(struct file_system_type *type,
 			int (*test)(struct super_block *,void *),
 			int (*set)(struct super_block *,void *),
 			int flags, void *data);
-extern struct dentry *mount_pseudo(struct file_system_type *, char *,
-	const struct super_operations *ops,
-	const struct dentry_operations *dops,
-	unsigned long);
+extern struct dentry *mount_pseudo_xattr(struct file_system_type *, char *,
+					 const struct super_operations *ops,
+					 const struct xattr_handler **xattr,
+					 const struct dentry_operations *dops,
+					 unsigned long);
+
+static inline struct dentry *
+mount_pseudo(struct file_system_type *fs_type, char *name,
+	     const struct super_operations *ops,
+	     const struct dentry_operations *dops, unsigned long magic)
+{
+	return mount_pseudo_xattr(fs_type, name, ops, NULL, dops, magic);
+}
 
 /* Alas, no aliases. Too much hassle with bringing module.h everywhere */
 #define fops_get(fops) \
diff --git a/net/socket.c b/net/socket.c
index 9b3dca6..976f7324 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -320,11 +320,38 @@ static const struct dentry_operations sockfs_dentry_operations = {
 	.d_dname  = sockfs_dname,
 };
 
+static int sockfs_xattr_get(const struct xattr_handler *handler,
+			    struct dentry *dentry, struct inode *inode,
+			    const char *suffix, void *value, size_t size)
+{
+	if (value) {
+		if (dentry->d_name.len + 1 > size)
+			return -ERANGE;
+		memcpy(value, dentry->d_name.name, dentry->d_name.len + 1);
+	}
+	return dentry->d_name.len + 1;
+}
+
+#define XATTR_SOCKPROTONAME_SUFFIX "sockprotoname"
+#define XATTR_NAME_SOCKPROTONAME (XATTR_SYSTEM_PREFIX XATTR_SOCKPROTONAME_SUFFIX)
+#define XATTR_NAME_SOCKPROTONAME_LEN (sizeof(XATTR_NAME_SOCKPROTONAME)-1)
+
+static const struct xattr_handler sockfs_xattr_handler = {
+	.name = XATTR_NAME_SOCKPROTONAME,
+	.get = sockfs_xattr_get,
+};
+
+static const struct xattr_handler *sockfs_xattr_handlers[] = {
+	&sockfs_xattr_handler,
+	NULL
+};
+
 static struct dentry *sockfs_mount(struct file_system_type *fs_type,
 			 int flags, const char *dev_name, void *data)
 {
-	return mount_pseudo(fs_type, "socket:", &sockfs_ops,
-		&sockfs_dentry_operations, SOCKFS_MAGIC);
+	return mount_pseudo_xattr(fs_type, "socket:", &sockfs_ops,
+				  sockfs_xattr_handlers,
+				  &sockfs_dentry_operations, SOCKFS_MAGIC);
 }
 
 static struct vfsmount *sock_mnt __read_mostly;
@@ -463,23 +490,6 @@ static struct socket *sockfd_lookup_light(int fd, int *err, int *fput_needed)
 	return NULL;
 }
 
-#define XATTR_SOCKPROTONAME_SUFFIX "sockprotoname"
-#define XATTR_NAME_SOCKPROTONAME (XATTR_SYSTEM_PREFIX XATTR_SOCKPROTONAME_SUFFIX)
-#define XATTR_NAME_SOCKPROTONAME_LEN (sizeof(XATTR_NAME_SOCKPROTONAME)-1)
-static ssize_t sockfs_getxattr(struct dentry *dentry, struct inode *inode,
-			       const char *name, void *value, size_t size)
-{
-	if (!strcmp(name, XATTR_NAME_SOCKPROTONAME)) {
-		if (value) {
-			if (dentry->d_name.len + 1 > size)
-				return -ERANGE;
-			memcpy(value, dentry->d_name.name, dentry->d_name.len + 1);
-		}
-		return dentry->d_name.len + 1;
-	}
-	return -EOPNOTSUPP;
-}
-
 static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
 				size_t size)
 {
@@ -509,7 +519,7 @@ static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
 }
 
 static const struct inode_operations sockfs_inode_ops = {
-	.getxattr = sockfs_getxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = sockfs_listxattr,
 };
 
-- 
2.7.4

