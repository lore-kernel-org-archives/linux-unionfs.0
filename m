From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [RFC 1/8] ecryptfs: Switch to generic xattr handlers
Date: Tue,  3 May 2016 00:45:11 +0200
Message-ID: <1462229118-13123-2-git-send-email-agruenba@redhat.com>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |  2 ++
 fs/ecryptfs/inode.c           | 48 +++++++++++++++++++++++++++++++++++--------
 fs/ecryptfs/main.c            |  1 +
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 6ff907f..706e1a4 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -716,4 +716,6 @@ int ecryptfs_set_f_namelen(long *namelen, long lower_namelen,
 int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
 		       loff_t offset);
 
+extern const struct xattr_handler *ecryptfs_xattr_handlers[];
+
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 1ac631c..b6d9ce7 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1100,10 +1100,10 @@ const struct inode_operations ecryptfs_symlink_iops = {
 	.permission = ecryptfs_permission,
 	.setattr = ecryptfs_setattr,
 	.getattr = ecryptfs_getattr_link,
-	.setxattr = ecryptfs_setxattr,
-	.getxattr = ecryptfs_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = ecryptfs_listxattr,
-	.removexattr = ecryptfs_removexattr
+	.removexattr = generic_removexattr
 };
 
 const struct inode_operations ecryptfs_dir_iops = {
@@ -1118,18 +1118,48 @@ const struct inode_operations ecryptfs_dir_iops = {
 	.rename = ecryptfs_rename,
 	.permission = ecryptfs_permission,
 	.setattr = ecryptfs_setattr,
-	.setxattr = ecryptfs_setxattr,
-	.getxattr = ecryptfs_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = ecryptfs_listxattr,
-	.removexattr = ecryptfs_removexattr
+	.removexattr = generic_removexattr
 };
 
 const struct inode_operations ecryptfs_main_iops = {
 	.permission = ecryptfs_permission,
 	.setattr = ecryptfs_setattr,
 	.getattr = ecryptfs_getattr,
-	.setxattr = ecryptfs_setxattr,
-	.getxattr = ecryptfs_getxattr,
+	.setxattr = generic_setxattr,
+	.getxattr = generic_getxattr,
 	.listxattr = ecryptfs_listxattr,
-	.removexattr = ecryptfs_removexattr
+	.removexattr = generic_removexattr
+};
+
+static int ecryptfs_xattr_get(const struct xattr_handler *handler,
+			      struct dentry *dentry, struct inode *inode,
+			      const char *name, void *buffer, size_t size)
+{
+	return ecryptfs_getxattr(dentry, inode, name, buffer, size);
+}
+
+static int ecryptfs_xattr_set(const struct xattr_handler *handler,
+			      struct dentry *dentry, const char *name,
+			      const void *value, size_t size, int flags)
+{
+	if (value)
+		return ecryptfs_setxattr(dentry, name, value, size, flags);
+	else {
+		BUG_ON(flags != XATTR_REPLACE);
+		return ecryptfs_removexattr(dentry, name);
+	}
+}
+
+const struct xattr_handler ecryptfs_xattr_handler = {
+	.prefix = "",  /* match anything */
+	.get = ecryptfs_xattr_get,
+	.set = ecryptfs_xattr_set,
+};
+
+const struct xattr_handler *ecryptfs_xattr_handlers[] = {
+	&ecryptfs_xattr_handler,
+	NULL
 };
diff --git a/fs/ecryptfs/main.c b/fs/ecryptfs/main.c
index 8b0b4a7..eb55f48 100644
--- a/fs/ecryptfs/main.c
+++ b/fs/ecryptfs/main.c
@@ -529,6 +529,7 @@ static struct dentry *ecryptfs_mount(struct file_system_type *fs_type, int flags
 	/* ->kill_sb() will take care of sbi after that point */
 	sbi = NULL;
 	s->s_op = &ecryptfs_sops;
+	s->s_xattr = ecryptfs_xattr_handlers;
 	s->s_d_op = &ecryptfs_dops;
 
 	err = "Reading sb failed";
-- 
2.5.5
