From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 13/18] vfs: Use IOP_XATTR flag for bad-inode handling
Date: Fri, 20 May 2016 13:14:30 +0200
Message-ID: <1463742875-9836-14-git-send-email-agruenba@redhat.com>
References: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46142 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932244AbcETLQW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 May 2016 07:16:22 -0400
In-Reply-To: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

With this change, all the xattr handler based operations will produce an
-EIO result for bad inodes, and we no longer only depend on inode->i_op
to be set to bad_inode_ops.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/bad_inode.c | 21 +--------------------
 fs/xattr.c     |  8 +++++++-
 2 files changed, 8 insertions(+), 21 deletions(-)

diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index 72e35b7..7bb153c 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -100,29 +100,12 @@ static int bad_inode_setattr(struct dentry *direntry, struct iattr *attrs)
 	return -EIO;
 }
 
-static int bad_inode_setxattr(struct dentry *dentry, const char *name,
-		const void *value, size_t size, int flags)
-{
-	return -EIO;
-}
-
-static ssize_t bad_inode_getxattr(struct dentry *dentry, struct inode *inode,
-			const char *name, void *buffer, size_t size)
-{
-	return -EIO;
-}
-
 static ssize_t bad_inode_listxattr(struct dentry *dentry, char *buffer,
 			size_t buffer_size)
 {
 	return -EIO;
 }
 
-static int bad_inode_removexattr(struct dentry *dentry, const char *name)
-{
-	return -EIO;
-}
-
 static const struct inode_operations bad_inode_ops =
 {
 	.create		= bad_inode_create,
@@ -142,10 +125,7 @@ static const struct inode_operations bad_inode_ops =
 	.permission	= bad_inode_permission,
 	.getattr	= bad_inode_getattr,
 	.setattr	= bad_inode_setattr,
-	.setxattr	= bad_inode_setxattr,
-	.getxattr	= bad_inode_getxattr,
 	.listxattr	= bad_inode_listxattr,
-	.removexattr	= bad_inode_removexattr,
 };
 
 
@@ -175,6 +155,7 @@ void make_bad_inode(struct inode *inode)
 	inode->i_atime = inode->i_mtime = inode->i_ctime =
 		current_fs_time(inode->i_sb);
 	inode->i_op = &bad_inode_ops;	
+	inode->i_opflags &= ~IOP_XATTR;
 	inode->i_fop = &bad_file_ops;	
 }
 EXPORT_SYMBOL(make_bad_inode);
diff --git a/fs/xattr.c b/fs/xattr.c
index 5a3b3e4..ff151ff 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -57,8 +57,11 @@ xattr_resolve_name(struct inode *inode, const char **name)
 	const struct xattr_handler **handlers = inode->i_sb->s_xattr;
 	const struct xattr_handler *handler;
 
-	if (!(inode->i_opflags & IOP_XATTR))
+	if (!(inode->i_opflags & IOP_XATTR)) {
+		if (unlikely(is_bad_inode(inode)))
+			return ERR_PTR(-EIO);
 		return ERR_PTR(-EOPNOTSUPP);
+	}
 	for_each_xattr_handler(handlers, handler) {
 		const char *n;
 
@@ -160,6 +163,9 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
 		}
 	} else if (issec) {
 		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
+
+		if (unlikely(is_bad_inode(inode)))
+			return -EIO;
 		error = security_inode_setsecurity(inode, suffix, value,
 						   size, flags);
 		if (!error)
-- 
2.5.5
