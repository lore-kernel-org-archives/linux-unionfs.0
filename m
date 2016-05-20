From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 09/18] fuse: Switch to generic xattr handlers
Date: Fri, 20 May 2016 13:14:26 +0200
Message-ID: <1463742875-9836-10-git-send-email-agruenba@redhat.com>
References: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/fuse/dir.c    | 49 ++++++++++++++++++++++++++++++++++++++++---------
 fs/fuse/fuse_i.h |  2 ++
 fs/fuse/inode.c  |  1 +
 3 files changed, 43 insertions(+), 9 deletions(-)

diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index b941905..6fe29b6 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -13,6 +13,7 @@
 #include <linux/sched.h>
 #include <linux/namei.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 
 static bool fuse_use_readdirplus(struct inode *dir, struct dir_context *ctx)
 {
@@ -1879,10 +1880,10 @@ static const struct inode_operations fuse_dir_inode_operations = {
 	.mknod		= fuse_mknod,
 	.permission	= fuse_permission,
 	.getattr	= fuse_getattr,
-	.setxattr	= fuse_setxattr,
-	.getxattr	= fuse_getxattr,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= fuse_listxattr,
-	.removexattr	= fuse_removexattr,
+	.removexattr	= generic_removexattr,
 };
 
 static const struct file_operations fuse_dir_operations = {
@@ -1900,10 +1901,10 @@ static const struct inode_operations fuse_common_inode_operations = {
 	.setattr	= fuse_setattr,
 	.permission	= fuse_permission,
 	.getattr	= fuse_getattr,
-	.setxattr	= fuse_setxattr,
-	.getxattr	= fuse_getxattr,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= fuse_listxattr,
-	.removexattr	= fuse_removexattr,
+	.removexattr	= generic_removexattr,
 };
 
 static const struct inode_operations fuse_symlink_inode_operations = {
@@ -1911,10 +1912,10 @@ static const struct inode_operations fuse_symlink_inode_operations = {
 	.get_link	= fuse_get_link,
 	.readlink	= generic_readlink,
 	.getattr	= fuse_getattr,
-	.setxattr	= fuse_setxattr,
-	.getxattr	= fuse_getxattr,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= fuse_listxattr,
-	.removexattr	= fuse_removexattr,
+	.removexattr	= generic_removexattr,
 };
 
 void fuse_init_common(struct inode *inode)
@@ -1932,3 +1933,33 @@ void fuse_init_symlink(struct inode *inode)
 {
 	inode->i_op = &fuse_symlink_inode_operations;
 }
+
+static int fuse_xattr_get(const struct xattr_handler *handler,
+		          struct dentry *dentry, struct inode *inode,
+		          const char *name, void *buffer, size_t size)
+{
+       return fuse_getxattr(dentry, inode, name, buffer, size);
+}
+
+static int fuse_xattr_set(const struct xattr_handler *handler,
+		          struct dentry *dentry, const char *name,
+		          const void *value, size_t size, int flags)
+{
+       if (value)
+		return fuse_setxattr(dentry, name, value, size, flags);
+       else {
+		BUG_ON(flags != XATTR_REPLACE);
+		return fuse_removexattr(dentry, name);
+       }
+}
+
+const struct xattr_handler fuse_xattr_handler = {
+       .prefix = "",  /* match anything */
+       .get = fuse_xattr_get,
+       .set = fuse_xattr_set,
+};
+
+const struct xattr_handler *fuse_xattr_handlers[] = {
+       &fuse_xattr_handler,
+       NULL
+};
diff --git a/fs/fuse/fuse_i.h b/fs/fuse/fuse_i.h
index eddbe02..acf3481 100644
--- a/fs/fuse/fuse_i.h
+++ b/fs/fuse/fuse_i.h
@@ -956,4 +956,6 @@ int fuse_do_setattr(struct inode *inode, struct iattr *attr,
 
 void fuse_set_initialized(struct fuse_conn *fc);
 
+extern const struct xattr_handler *fuse_xattr_handlers[];
+
 #endif /* _FS_FUSE_I_H */
diff --git a/fs/fuse/inode.c b/fs/fuse/inode.c
index 1ce6766..0a6ec20 100644
--- a/fs/fuse/inode.c
+++ b/fs/fuse/inode.c
@@ -1058,6 +1058,7 @@ static int fuse_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	sb->s_magic = FUSE_SUPER_MAGIC;
 	sb->s_op = &fuse_super_operations;
+	sb->s_xattr = fuse_xattr_handlers;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	sb->s_time_gran = 1;
 	sb->s_export_op = &fuse_export_operations;
-- 
2.5.5
