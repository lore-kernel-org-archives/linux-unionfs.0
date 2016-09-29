From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v6 04/16] kernfs: Switch to generic xattr handlers
Date: Thu, 29 Sep 2016 17:48:33 +0200
Message-ID: <1475164125-28635-5-git-send-email-agruenba@redhat.com>
References: <1475164125-28635-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33508 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755085AbcI2PtM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Sep 2016 11:49:12 -0400
In-Reply-To: <1475164125-28635-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Acked-by: Tejun Heo <tj@kernel.org>
---
 fs/kernfs/dir.c             |   6 +-
 fs/kernfs/inode.c           | 158 +++++++++++++++++++++++---------------------
 fs/kernfs/kernfs-internal.h |   7 +-
 fs/kernfs/mount.c           |   1 +
 fs/kernfs/symlink.c         |   6 +-
 5 files changed, 92 insertions(+), 86 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index e57174d..a6e430a 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1126,9 +1126,9 @@ const struct inode_operations kernfs_dir_iops = {
 	.permission	= kernfs_iop_permission,
 	.setattr	= kernfs_iop_setattr,
 	.getattr	= kernfs_iop_getattr,
-	.setxattr	= kernfs_iop_setxattr,
-	.removexattr	= kernfs_iop_removexattr,
-	.getxattr	= kernfs_iop_getxattr,
+	.setxattr	= generic_setxattr,
+	.removexattr	= generic_removexattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= kernfs_iop_listxattr,
 
 	.mkdir		= kernfs_iop_mkdir,
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 63b925d..6bc8754 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -28,9 +28,9 @@ static const struct inode_operations kernfs_iops = {
 	.permission	= kernfs_iop_permission,
 	.setattr	= kernfs_iop_setattr,
 	.getattr	= kernfs_iop_getattr,
-	.setxattr	= kernfs_iop_setxattr,
-	.removexattr	= kernfs_iop_removexattr,
-	.getxattr	= kernfs_iop_getxattr,
+	.setxattr	= generic_setxattr,
+	.removexattr	= generic_removexattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= kernfs_iop_listxattr,
 };
 
@@ -138,17 +138,12 @@ out:
 	return error;
 }
 
-static int kernfs_node_setsecdata(struct kernfs_node *kn, void **secdata,
+static int kernfs_node_setsecdata(struct kernfs_iattrs *attrs, void **secdata,
 				  u32 *secdata_len)
 {
-	struct kernfs_iattrs *attrs;
 	void *old_secdata;
 	size_t old_secdata_len;
 
-	attrs = kernfs_iattrs(kn);
-	if (!attrs)
-		return -ENOMEM;
-
 	old_secdata = attrs->ia_secdata;
 	old_secdata_len = attrs->ia_secdata_len;
 
@@ -160,71 +155,6 @@ static int kernfs_node_setsecdata(struct kernfs_node *kn, void **secdata,
 	return 0;
 }
 
-int kernfs_iop_setxattr(struct dentry *unused, struct inode *inode,
-			const char *name, const void *value,
-			size_t size, int flags)
-{
-	struct kernfs_node *kn = inode->i_private;
-	struct kernfs_iattrs *attrs;
-	void *secdata;
-	int error;
-	u32 secdata_len = 0;
-
-	attrs = kernfs_iattrs(kn);
-	if (!attrs)
-		return -ENOMEM;
-
-	if (!strncmp(name, XATTR_SECURITY_PREFIX, XATTR_SECURITY_PREFIX_LEN)) {
-		const char *suffix = name + XATTR_SECURITY_PREFIX_LEN;
-		error = security_inode_setsecurity(inode, suffix,
-						value, size, flags);
-		if (error)
-			return error;
-		error = security_inode_getsecctx(inode,
-						&secdata, &secdata_len);
-		if (error)
-			return error;
-
-		mutex_lock(&kernfs_mutex);
-		error = kernfs_node_setsecdata(kn, &secdata, &secdata_len);
-		mutex_unlock(&kernfs_mutex);
-
-		if (secdata)
-			security_release_secctx(secdata, secdata_len);
-		return error;
-	} else if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN)) {
-		return simple_xattr_set(&attrs->xattrs, name, value, size,
-					flags);
-	}
-
-	return -EINVAL;
-}
-
-int kernfs_iop_removexattr(struct dentry *dentry, const char *name)
-{
-	struct kernfs_node *kn = dentry->d_fsdata;
-	struct kernfs_iattrs *attrs;
-
-	attrs = kernfs_iattrs(kn);
-	if (!attrs)
-		return -ENOMEM;
-
-	return simple_xattr_set(&attrs->xattrs, name, NULL, 0, XATTR_REPLACE);
-}
-
-ssize_t kernfs_iop_getxattr(struct dentry *unused, struct inode *inode,
-			    const char *name, void *buf, size_t size)
-{
-	struct kernfs_node *kn = inode->i_private;
-	struct kernfs_iattrs *attrs;
-
-	attrs = kernfs_iattrs(kn);
-	if (!attrs)
-		return -ENOMEM;
-
-	return simple_xattr_get(&attrs->xattrs, name, buf, size);
-}
-
 ssize_t kernfs_iop_listxattr(struct dentry *dentry, char *buf, size_t size)
 {
 	struct kernfs_node *kn = dentry->d_fsdata;
@@ -376,3 +306,83 @@ int kernfs_iop_permission(struct inode *inode, int mask)
 
 	return generic_permission(inode, mask);
 }
+
+static int kernfs_xattr_get(const struct xattr_handler *handler,
+			    struct dentry *unused, struct inode *inode,
+			    const char *suffix, void *value, size_t size)
+{
+	const char *name = xattr_full_name(handler, suffix);
+	struct kernfs_node *kn = inode->i_private;
+	struct kernfs_iattrs *attrs;
+
+	attrs = kernfs_iattrs(kn);
+	if (!attrs)
+		return -ENOMEM;
+
+	return simple_xattr_get(&attrs->xattrs, name, value, size);
+}
+
+static int kernfs_xattr_set(const struct xattr_handler *handler,
+			    struct dentry *unused, struct inode *inode,
+			    const char *suffix, const void *value,
+			    size_t size, int flags)
+{
+	const char *name = xattr_full_name(handler, suffix);
+	struct kernfs_node *kn = inode->i_private;
+	struct kernfs_iattrs *attrs;
+
+	attrs = kernfs_iattrs(kn);
+	if (!attrs)
+		return -ENOMEM;
+
+	return simple_xattr_set(&attrs->xattrs, name, value, size, flags);
+}
+
+const struct xattr_handler kernfs_trusted_xattr_handler = {
+	.prefix = XATTR_TRUSTED_PREFIX,
+	.get = kernfs_xattr_get,
+	.set = kernfs_xattr_set,
+};
+
+static int kernfs_security_xattr_set(const struct xattr_handler *handler,
+				     struct dentry *unused, struct inode *inode,
+				     const char *suffix, const void *value,
+				     size_t size, int flags)
+{
+	struct kernfs_node *kn = inode->i_private;
+	struct kernfs_iattrs *attrs;
+	void *secdata;
+	u32 secdata_len = 0;
+	int error;
+
+	attrs = kernfs_iattrs(kn);
+	if (!attrs)
+		return -ENOMEM;
+
+	error = security_inode_setsecurity(inode, suffix, value, size, flags);
+	if (error)
+		return error;
+	error = security_inode_getsecctx(inode, &secdata, &secdata_len);
+	if (error)
+		return error;
+
+	mutex_lock(&kernfs_mutex);
+	error = kernfs_node_setsecdata(attrs, &secdata, &secdata_len);
+	mutex_unlock(&kernfs_mutex);
+
+	if (secdata)
+		security_release_secctx(secdata, secdata_len);
+	return error;
+}
+
+const struct xattr_handler kernfs_security_xattr_handler = {
+	.prefix = XATTR_SECURITY_PREFIX,
+	.get = kernfs_xattr_get,
+	.set = kernfs_security_xattr_set,
+};
+
+const struct xattr_handler *kernfs_xattr_handlers[] = {
+	&kernfs_trusted_xattr_handler,
+	&kernfs_security_xattr_handler,
+	NULL
+};
diff --git a/fs/kernfs/kernfs-internal.h b/fs/kernfs/kernfs-internal.h
index 3715923..bfd551b 100644
--- a/fs/kernfs/kernfs-internal.h
+++ b/fs/kernfs/kernfs-internal.h
@@ -76,17 +76,12 @@ extern struct kmem_cache *kernfs_node_cache;
 /*
  * inode.c
  */
+extern const struct xattr_handler *kernfs_xattr_handlers[];
 void kernfs_evict_inode(struct inode *inode);
 int kernfs_iop_permission(struct inode *inode, int mask);
 int kernfs_iop_setattr(struct dentry *dentry, struct iattr *iattr);
 int kernfs_iop_getattr(struct vfsmount *mnt, struct dentry *dentry,
 		       struct kstat *stat);
-int kernfs_iop_setxattr(struct dentry *dentry, struct inode *inode,
-			const char *name, const void *value,
-			size_t size, int flags);
-int kernfs_iop_removexattr(struct dentry *dentry, const char *name);
-ssize_t kernfs_iop_getxattr(struct dentry *dentry, struct inode *inode,
-			    const char *name, void *buf, size_t size);
 ssize_t kernfs_iop_listxattr(struct dentry *dentry, char *buf, size_t size);
 
 /*
diff --git a/fs/kernfs/mount.c b/fs/kernfs/mount.c
index b3d73ad..d5b149a 100644
--- a/fs/kernfs/mount.c
+++ b/fs/kernfs/mount.c
@@ -158,6 +158,7 @@ static int kernfs_fill_super(struct super_block *sb, unsigned long magic)
 	sb->s_blocksize_bits = PAGE_SHIFT;
 	sb->s_magic = magic;
 	sb->s_op = &kernfs_sops;
+	sb->s_xattr = kernfs_xattr_handlers;
 	sb->s_time_gran = 1;
 
 	/* get root inode, initialize and unlock it */
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index 117b8b3..549a14c7 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -134,9 +134,9 @@ static const char *kernfs_iop_get_link(struct dentry *dentry,
 }
 
 const struct inode_operations kernfs_symlink_iops = {
-	.setxattr	= kernfs_iop_setxattr,
-	.removexattr	= kernfs_iop_removexattr,
-	.getxattr	= kernfs_iop_getxattr,
+	.setxattr	= generic_setxattr,
+	.removexattr	= generic_removexattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= kernfs_iop_listxattr,
 	.readlink	= generic_readlink,
 	.get_link	= kernfs_iop_get_link,
-- 
2.7.4
