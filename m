From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v4 04/20] ovl: Switch to generic_getxattr
Date: Mon, 22 Aug 2016 23:21:52 +0200
Message-ID: <1471900928-21588-5-git-send-email-agruenba@redhat.com>
References: <1471900928-21588-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1471900928-21588-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

Now that overlayfs has xattr handlers for iop->{set,remove}xattr, use
those same handlers for iop->getxattr as well.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/overlayfs/dir.c       |  2 +-
 fs/overlayfs/inode.c     | 20 ++------------------
 fs/overlayfs/overlayfs.h |  2 --
 fs/overlayfs/super.c     | 25 +++++++++++++++++++++++++
 4 files changed, 28 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 7823480..a5ade8a 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -950,7 +950,7 @@ const struct inode_operations ovl_dir_inode_operations = {
 	.permission	= ovl_permission,
 	.getattr	= ovl_dir_getattr,
 	.setxattr	= generic_setxattr,
-	.getxattr	= ovl_getxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
 	.removexattr	= generic_removexattr,
 	.get_acl	= ovl_get_acl,
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 4f348ca..a699ff9 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -237,22 +237,6 @@ out:
 	return err;
 }
 
-ssize_t ovl_getxattr(struct dentry *dentry, struct inode *inode,
-		     const char *name, void *value, size_t size)
-{
-	struct dentry *realdentry = ovl_dentry_real(dentry);
-	ssize_t res;
-	const struct cred *old_cred;
-
-	if (ovl_is_private_xattr(name))
-		return -ENODATA;
-
-	old_cred = ovl_override_creds(dentry->d_sb);
-	res = vfs_getxattr(realdentry, name, value, size);
-	revert_creds(old_cred);
-	return res;
-}
-
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
 {
 	struct dentry *realdentry = ovl_dentry_real(dentry);
@@ -367,7 +351,7 @@ static const struct inode_operations ovl_file_inode_operations = {
 	.permission	= ovl_permission,
 	.getattr	= ovl_getattr,
 	.setxattr	= generic_setxattr,
-	.getxattr	= ovl_getxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
 	.removexattr	= generic_removexattr,
 	.get_acl	= ovl_get_acl,
@@ -380,7 +364,7 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.readlink	= ovl_readlink,
 	.getattr	= ovl_getattr,
 	.setxattr	= generic_setxattr,
-	.getxattr	= ovl_getxattr,
+	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
 	.removexattr	= generic_removexattr,
 	.update_time	= ovl_update_time,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 951c8f5..5df6fd1 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -185,8 +185,6 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr);
 int ovl_permission(struct inode *inode, int mask);
 int ovl_xattr_set(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags);
-ssize_t ovl_getxattr(struct dentry *dentry, struct inode *inode,
-		     const char *name, void *value, size_t size);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
 struct posix_acl *ovl_get_acl(struct inode *inode, int type);
 int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9eb3f82..762f3ad 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -967,6 +967,20 @@ static unsigned int ovl_split_lowerdirs(char *str)
 	return ctr;
 }
 
+static int ovl_xattr_get(const struct xattr_handler *handler,
+			 struct dentry *dentry, struct inode *inode,
+			 const char *name, void *buffer, size_t size)
+{
+	struct dentry *realdentry = ovl_dentry_real(dentry);
+	const struct cred *old_cred;
+	ssize_t err;
+
+	old_cred = ovl_override_creds(dentry->d_sb);
+	err = vfs_getxattr(realdentry, name, buffer, size);
+	revert_creds(old_cred);
+	return err;
+}
+
 static int __maybe_unused
 ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
 			struct dentry *dentry, struct inode *inode,
@@ -1006,6 +1020,13 @@ out_acl_release:
 	return err;
 }
 
+static int ovl_own_xattr_get(const struct xattr_handler *handler,
+			     struct dentry *dentry, struct inode *inode,
+			     const char *name, void *buffer, size_t size)
+{
+	return -EPERM;
+}
+
 static int ovl_own_xattr_set(const struct xattr_handler *handler,
 			     struct dentry *dentry, struct inode *inode,
 			     const char *name, const void *value,
@@ -1026,6 +1047,7 @@ static const struct xattr_handler __maybe_unused
 ovl_posix_acl_access_xattr_handler = {
 	.name = XATTR_NAME_POSIX_ACL_ACCESS,
 	.flags = ACL_TYPE_ACCESS,
+	.get = ovl_xattr_get,
 	.set = ovl_posix_acl_xattr_set,
 };
 
@@ -1033,16 +1055,19 @@ static const struct xattr_handler __maybe_unused
 ovl_posix_acl_default_xattr_handler = {
 	.name = XATTR_NAME_POSIX_ACL_DEFAULT,
 	.flags = ACL_TYPE_DEFAULT,
+	.get = ovl_xattr_get,
 	.set = ovl_posix_acl_xattr_set,
 };
 
 static const struct xattr_handler ovl_own_xattr_handler = {
 	.prefix	= OVL_XATTR_PREFIX,
+	.get = ovl_own_xattr_get,
 	.set = ovl_own_xattr_set,
 };
 
 static const struct xattr_handler ovl_other_xattr_handler = {
 	.prefix	= "", /* catch all */
+	.get = ovl_xattr_get,
 	.set = ovl_other_xattr_set,
 };
 
-- 
2.7.4
