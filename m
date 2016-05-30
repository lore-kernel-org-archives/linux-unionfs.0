From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v3 08/17] overlayfs: Switch to generic xattr handlers
Date: Mon, 30 May 2016 10:57:24 +0200
Message-ID: <1464598653-3656-9-git-send-email-agruenba@redhat.com>
References: <1464598653-3656-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1464598653-3656-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/overlayfs/dir.c       |  6 +++---
 fs/overlayfs/inode.c     | 54 +++++++++++++++++++++++++++++++++++++-----------
 fs/overlayfs/overlayfs.h |  7 +------
 fs/overlayfs/super.c     |  1 +
 4 files changed, 47 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 22f0253..450bc74 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -910,8 +910,8 @@ const struct inode_operations ovl_dir_inode_operations = {
 	.mknod		= ovl_mknod,
 	.permission	= ovl_permission,
 	.getattr	= ovl_dir_getattr,
-	.setxattr	= ovl_setxattr,
-	.getxattr	= ovl_getxattr,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= ovl_removexattr,
+	.removexattr	= generic_removexattr,
 };
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 0ed7c40..6c9f1fb 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -210,9 +210,8 @@ static bool ovl_is_private_xattr(const char *name)
 	return strncmp(name, OVL_XATTR_PRE_NAME, OVL_XATTR_PRE_LEN) == 0;
 }
 
-int ovl_setxattr(struct dentry *dentry, struct inode *inode,
-		 const char *name, const void *value,
-		 size_t size, int flags)
+static int ovl_setxattr(struct dentry *dentry, const char *name,
+			const void *value, size_t size, int flags)
 {
 	int err;
 	struct dentry *upperdentry;
@@ -247,8 +246,8 @@ static bool ovl_need_xattr_filter(struct dentry *dentry,
 		return false;
 }
 
-ssize_t ovl_getxattr(struct dentry *dentry, struct inode *inode,
-		     const char *name, void *value, size_t size)
+static ssize_t ovl_getxattr(struct dentry *dentry, struct inode *inode,
+			    const char *name, void *value, size_t size)
 {
 	struct path realpath;
 	enum ovl_path_type type = ovl_path_real(dentry, &realpath);
@@ -291,7 +290,7 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 	return res;
 }
 
-int ovl_removexattr(struct dentry *dentry, const char *name)
+static int ovl_removexattr(struct dentry *dentry, const char *name)
 {
 	int err;
 	struct path realpath;
@@ -375,10 +374,10 @@ static const struct inode_operations ovl_file_inode_operations = {
 	.setattr	= ovl_setattr,
 	.permission	= ovl_permission,
 	.getattr	= ovl_getattr,
-	.setxattr	= ovl_setxattr,
-	.getxattr	= ovl_getxattr,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= ovl_removexattr,
+	.removexattr	= generic_removexattr,
 };
 
 static const struct inode_operations ovl_symlink_inode_operations = {
@@ -386,10 +385,10 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.get_link	= ovl_get_link,
 	.readlink	= ovl_readlink,
 	.getattr	= ovl_getattr,
-	.setxattr	= ovl_setxattr,
-	.getxattr	= ovl_getxattr,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= ovl_removexattr,
+	.removexattr	= generic_removexattr,
 };
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
@@ -434,3 +433,34 @@ struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
 
 	return inode;
 }
+
+static int ovl_xattr_get(const struct xattr_handler *handler,
+			 struct dentry *dentry, struct inode *inode,
+			 const char *name, void *buffer, size_t size)
+{
+	return ovl_getxattr(dentry, inode, name, buffer, size);
+}
+
+static int ovl_xattr_set(const struct xattr_handler *handler,
+			 struct dentry *dentry, struct inode *inode,
+			 const char *name, const void *value, size_t size,
+			 int flags)
+{
+	if (value)
+		return ovl_setxattr(dentry, name, value, size, flags);
+	else {
+		BUG_ON(flags != XATTR_REPLACE);
+		return ovl_removexattr(dentry, name);
+	}
+}
+
+const struct xattr_handler ovl_xattr_handler = {
+	.prefix = "",  /* match anything */
+	.get = ovl_xattr_get,
+	.set = ovl_xattr_set,
+};
+
+const struct xattr_handler *ovl_xattr_handlers[] = {
+	&ovl_xattr_handler,
+	NULL
+};
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 4bd9b5b..20e1990 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -172,13 +172,7 @@ int ovl_check_d_type_supported(struct path *realpath);
 /* inode.c */
 int ovl_setattr(struct dentry *dentry, struct iattr *attr);
 int ovl_permission(struct inode *inode, int mask);
-int ovl_setxattr(struct dentry *dentry, struct inode *inode,
-		 const char *name, const void *value,
-		 size_t size, int flags);
-ssize_t ovl_getxattr(struct dentry *dentry, struct inode *inode,
-		     const char *name, void *value, size_t size);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
-int ovl_removexattr(struct dentry *dentry, const char *name);
 struct inode *ovl_d_select_inode(struct dentry *dentry, unsigned file_flags);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
@@ -188,6 +182,7 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 	to->i_uid = from->i_uid;
 	to->i_gid = from->i_gid;
 }
+extern const struct xattr_handler *ovl_xattr_handlers[];
 
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index ce02f46..dab5301a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1154,6 +1154,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
 	sb->s_op = &ovl_super_operations;
+	sb->s_xattr = ovl_xattr_handlers;
 	sb->s_root = root_dentry;
 	sb->s_fs_info = ufs;
 
-- 
2.5.5
