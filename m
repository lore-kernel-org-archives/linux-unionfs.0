From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 12/18] vfs: Add IOP_XATTR inode operations flag
Date: Fri, 20 May 2016 13:14:29 +0200
Message-ID: <1463742875-9836-13-git-send-email-agruenba@redhat.com>
References: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

The IOP_XATTR inode operations flag in inode->i_opflags indicates that
the inode has xattr support.  The flag is automatically set by
new_inode() on filesystems with xattr support (where sb->s_xattr is
defined), and cleared otherwise.  Filesystems can explicitly clear it
for inodes that should not have xattr support.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/inode.c         |  2 ++
 fs/xattr.c         | 12 ++++++++----
 include/linux/fs.h |  1 +
 3 files changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4ccbc21..aaad9b2 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -140,6 +140,8 @@ int inode_init_always(struct super_block *sb, struct inode *inode)
 	inode->i_fop = &no_open_fops;
 	inode->__i_nlink = 1;
 	inode->i_opflags = 0;
+	if (sb->s_xattr)
+		inode->i_opflags |= IOP_XATTR;
 	i_uid_write(inode, 0);
 	i_gid_write(inode, 0);
 	atomic_set(&inode->i_writecount, 0);
diff --git a/fs/xattr.c b/fs/xattr.c
index 179dd03..5a3b3e4 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -52,10 +52,13 @@ strcmp_prefix(const char *a, const char *a_prefix)
  * Find the xattr_handler with the matching prefix.
  */
 static const struct xattr_handler *
-xattr_resolve_name(const struct xattr_handler **handlers, const char **name)
+xattr_resolve_name(struct inode *inode, const char **name)
 {
+	const struct xattr_handler **handlers = inode->i_sb->s_xattr;
 	const struct xattr_handler *handler;
 
+	if (!(inode->i_opflags & IOP_XATTR))
+		return ERR_PTR(-EOPNOTSUPP);
 	for_each_xattr_handler(handlers, handler) {
 		const char *n;
 
@@ -290,6 +293,7 @@ nolsm:
 		error = -EOPNOTSUPP;
 
 	return error;
+
 }
 EXPORT_SYMBOL_GPL(vfs_getxattr);
 
@@ -692,7 +696,7 @@ generic_getxattr(struct dentry *dentry, struct inode *inode,
 {
 	const struct xattr_handler *handler;
 
-	handler = xattr_resolve_name(dentry->d_sb->s_xattr, &name);
+	handler = xattr_resolve_name(inode, &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
 	return handler->get(handler, dentry, inode,
@@ -746,7 +750,7 @@ generic_setxattr(struct dentry *dentry, const char *name, const void *value, siz
 
 	if (size == 0)
 		value = "";  /* empty EA, do not remove */
-	handler = xattr_resolve_name(dentry->d_sb->s_xattr, &name);
+	handler = xattr_resolve_name(d_inode(dentry), &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
 	return handler->set(handler, dentry, name, value, size, flags);
@@ -761,7 +765,7 @@ generic_removexattr(struct dentry *dentry, const char *name)
 {
 	const struct xattr_handler *handler;
 
-	handler = xattr_resolve_name(dentry->d_sb->s_xattr, &name);
+	handler = xattr_resolve_name(d_inode(dentry), &name);
 	if (IS_ERR(handler))
 		return PTR_ERR(handler);
 	return handler->set(handler, dentry, name, NULL, 0, XATTR_REPLACE);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index b0c2f76..e80594f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -594,6 +594,7 @@ is_uncached_acl(struct posix_acl *acl)
 #define IOP_FASTPERM	0x0001
 #define IOP_LOOKUP	0x0002
 #define IOP_NOFOLLOW	0x0004
+#define IOP_XATTR	0x0008
 
 /*
  * Keep mostly read-only and often accessed (especially for
-- 
2.5.5
