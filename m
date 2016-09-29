From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v6 07/16] ecryptfs: Switch to generic xattr handlers
Date: Thu, 29 Sep 2016 17:48:36 +0200
Message-ID: <1475164125-28635-8-git-send-email-agruenba@redhat.com>
References: <1475164125-28635-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1475164125-28635-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |  2 ++
 fs/ecryptfs/inode.c           | 62 +++++++++++++++++++++++++++++++++----------
 fs/ecryptfs/main.c            |  1 +
 3 files changed, 51 insertions(+), 14 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 4ba1547..599a292 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -715,4 +715,6 @@ int ecryptfs_set_f_namelen(long *namelen, long lower_namelen,
 int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
 		       loff_t offset);
 
+extern const struct xattr_handler *ecryptfs_xattr_handlers[];
+
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 9d153b6..cef32cc 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1066,19 +1066,22 @@ out:
 	return rc;
 }
 
-static int ecryptfs_removexattr(struct dentry *dentry, const char *name)
+static int ecryptfs_removexattr(struct dentry *dentry, struct inode *inode,
+				const char *name)
 {
 	int rc = 0;
 	struct dentry *lower_dentry;
+	struct inode *lower_inode;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	if (!d_inode(lower_dentry)->i_op->removexattr) {
+	lower_inode = ecryptfs_inode_to_lower(inode);
+	if (!lower_inode->i_op->removexattr) {
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
-	inode_lock(d_inode(lower_dentry));
-	rc = d_inode(lower_dentry)->i_op->removexattr(lower_dentry, name);
-	inode_unlock(d_inode(lower_dentry));
+	inode_lock(lower_inode);
+	rc = lower_inode->i_op->removexattr(lower_dentry, name);
+	inode_unlock(lower_inode);
 out:
 	return rc;
 }
@@ -1089,10 +1092,10 @@ const struct inode_operations ecryptfs_symlink_iops = {
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
@@ -1107,18 +1110,49 @@ const struct inode_operations ecryptfs_dir_iops = {
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
+			      struct dentry *dentry, struct inode *inode,
+			      const char *name, const void *value, size_t size,
+			      int flags)
+{
+	if (value)
+		return ecryptfs_setxattr(dentry, inode, name, value, size, flags);
+	else {
+		BUG_ON(flags != XATTR_REPLACE);
+		return ecryptfs_removexattr(dentry, inode, name);
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
index 6120044..151872d 100644
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
2.7.4
