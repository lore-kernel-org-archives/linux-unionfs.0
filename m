From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 07/18] ecryptfs: Switch to generic xattr handlers
Date: Fri, 20 May 2016 13:14:24 +0200
Message-ID: <1463742875-9836-8-git-send-email-agruenba@redhat.com>
References: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45067 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932455AbcETLPi (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 20 May 2016 07:15:38 -0400
In-Reply-To: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/ecryptfs/ecryptfs_kernel.h |  2 ++
 fs/ecryptfs/inode.c           | 48 +++++++++++++++++++++++++++++++++++--------
 fs/ecryptfs/main.c            |  1 +
 3 files changed, 42 insertions(+), 9 deletions(-)

diff --git a/fs/ecryptfs/ecryptfs_kernel.h b/fs/ecryptfs/ecryptfs_kernel.h
index 3ec495d..38b84ea 100644
--- a/fs/ecryptfs/ecryptfs_kernel.h
+++ b/fs/ecryptfs/ecryptfs_kernel.h
@@ -715,4 +715,6 @@ int ecryptfs_set_f_namelen(long *namelen, long lower_namelen,
 int ecryptfs_derive_iv(char *iv, struct ecryptfs_crypt_stat *crypt_stat,
 		       loff_t offset);
 
+extern const struct xattr_handler *ecryptfs_xattr_handlers[];
+
 #endif /* #ifndef ECRYPTFS_KERNEL_H */
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 318b046..4129233 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1088,10 +1088,10 @@ const struct inode_operations ecryptfs_symlink_iops = {
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
@@ -1106,18 +1106,48 @@ const struct inode_operations ecryptfs_dir_iops = {
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
index 1698132..44ee3e2 100644
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
