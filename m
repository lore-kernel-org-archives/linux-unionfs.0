From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v2 15/18] xattr: Add __vfs_{get,set,remove}xattr helpers
Date: Fri, 20 May 2016 13:14:32 +0200
Message-ID: <1463742875-9836-16-git-send-email-agruenba@redhat.com>
References: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1463742875-9836-1-git-send-email-agruenba@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

Right now, various places in the kernel check for the existence of
getxattr, setxattr, and removexattr inode operations and directly call
those operations.  Switch to helper functions and test for the IOP_XATTR
flag instead.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/cachefiles/bind.c                  |  4 +--
 fs/cachefiles/namei.c                 |  4 +--
 fs/ecryptfs/inode.c                   | 18 ++++++--------
 fs/ecryptfs/mmap.c                    | 11 ++++-----
 fs/overlayfs/copy_up.c                |  4 +--
 fs/overlayfs/super.c                  |  4 +--
 fs/xattr.c                            | 46 ++++++++++++++++++++++++++---------
 include/linux/xattr.h                 |  3 +++
 security/commoncap.c                  | 25 ++++++++-----------
 security/integrity/evm/evm_crypto.c   |  8 +++---
 security/integrity/evm/evm_main.c     |  4 +--
 security/integrity/ima/ima_appraise.c | 21 ++++++++--------
 security/selinux/hooks.c              | 19 ++++++---------
 security/smack/smack_lsm.c            | 12 ++++-----
 14 files changed, 98 insertions(+), 85 deletions(-)

diff --git a/fs/cachefiles/bind.c b/fs/cachefiles/bind.c
index 6af790f..3ff867f 100644
--- a/fs/cachefiles/bind.c
+++ b/fs/cachefiles/bind.c
@@ -20,6 +20,7 @@
 #include <linux/mount.h>
 #include <linux/statfs.h>
 #include <linux/ctype.h>
+#include <linux/xattr.h>
 #include "internal.h"
 
 static int cachefiles_daemon_add_cache(struct cachefiles_cache *caches);
@@ -126,8 +127,7 @@ static int cachefiles_daemon_add_cache(struct cachefiles_cache *cache)
 	if (d_is_negative(root) ||
 	    !d_backing_inode(root)->i_op->lookup ||
 	    !d_backing_inode(root)->i_op->mkdir ||
-	    !d_backing_inode(root)->i_op->setxattr ||
-	    !d_backing_inode(root)->i_op->getxattr ||
+	    !(d_backing_inode(root)->i_opflags & IOP_XATTR) ||
 	    !root->d_sb->s_op->statfs ||
 	    !root->d_sb->s_op->sync_fs)
 		goto error_unsupported;
diff --git a/fs/cachefiles/namei.c b/fs/cachefiles/namei.c
index 4ae7500..0d8ca89 100644
--- a/fs/cachefiles/namei.c
+++ b/fs/cachefiles/namei.c
@@ -20,6 +20,7 @@
 #include <linux/namei.h>
 #include <linux/security.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 #include "internal.h"
 
 #define CACHEFILES_KEYBUF_SIZE 512
@@ -798,8 +799,7 @@ struct dentry *cachefiles_get_directory(struct cachefiles_cache *cache,
 	}
 
 	ret = -EPERM;
-	if (!d_backing_inode(subdir)->i_op->setxattr ||
-	    !d_backing_inode(subdir)->i_op->getxattr ||
+	if (!(d_backing_inode(subdir)->i_opflags & IOP_XATTR) ||
 	    !d_backing_inode(subdir)->i_op->lookup ||
 	    !d_backing_inode(subdir)->i_op->mkdir ||
 	    !d_backing_inode(subdir)->i_op->create ||
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 4129233..f283fa6 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1004,15 +1004,14 @@ int
 ecryptfs_setxattr(struct dentry *dentry, const char *name, const void *value,
 		  size_t size, int flags)
 {
-	int rc = 0;
+	int rc;
 	struct dentry *lower_dentry;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	if (!d_inode(lower_dentry)->i_op->setxattr) {
+	if (!(d_inode(lower_dentry)->i_opflags & IOP_XATTR)) {
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
-
 	rc = vfs_setxattr(lower_dentry, name, value, size, flags);
 	if (!rc && d_really_is_positive(dentry))
 		fsstack_copy_attr_all(d_inode(dentry), d_inode(lower_dentry));
@@ -1024,15 +1023,14 @@ ssize_t
 ecryptfs_getxattr_lower(struct dentry *lower_dentry, struct inode *lower_inode,
 			const char *name, void *value, size_t size)
 {
-	int rc = 0;
+	int rc;
 
-	if (!lower_inode->i_op->getxattr) {
+	if (!(lower_inode->i_opflags & IOP_XATTR)) {
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
 	inode_lock(lower_inode);
-	rc = lower_inode->i_op->getxattr(lower_dentry, lower_inode,
-					 name, value, size);
+	rc = __vfs_getxattr(lower_dentry, lower_inode, name, value, size);
 	inode_unlock(lower_inode);
 out:
 	return rc;
@@ -1067,16 +1065,16 @@ out:
 
 static int ecryptfs_removexattr(struct dentry *dentry, const char *name)
 {
-	int rc = 0;
+	int rc;
 	struct dentry *lower_dentry;
 
 	lower_dentry = ecryptfs_dentry_to_lower(dentry);
-	if (!d_inode(lower_dentry)->i_op->removexattr) {
+	if (!(d_inode(lower_dentry)->i_opflags & IOP_XATTR)) {
 		rc = -EOPNOTSUPP;
 		goto out;
 	}
 	inode_lock(d_inode(lower_dentry));
-	rc = d_inode(lower_dentry)->i_op->removexattr(lower_dentry, name);
+	rc = __vfs_removexattr(lower_dentry, name);
 	inode_unlock(d_inode(lower_dentry));
 out:
 	return rc;
diff --git a/fs/ecryptfs/mmap.c b/fs/ecryptfs/mmap.c
index 148d11b..e08154a 100644
--- a/fs/ecryptfs/mmap.c
+++ b/fs/ecryptfs/mmap.c
@@ -32,6 +32,7 @@
 #include <linux/file.h>
 #include <linux/scatterlist.h>
 #include <linux/slab.h>
+#include <linux/xattr.h>
 #include <asm/unaligned.h>
 #include "ecryptfs_kernel.h"
 
@@ -422,7 +423,7 @@ static int ecryptfs_write_inode_size_to_xattr(struct inode *ecryptfs_inode)
 	struct inode *lower_inode = d_inode(lower_dentry);
 	int rc;
 
-	if (!lower_inode->i_op->getxattr || !lower_inode->i_op->setxattr) {
+	if (!(lower_inode->i_opflags & IOP_XATTR)) {
 		printk(KERN_WARNING
 		       "No support for setting xattr in lower filesystem\n");
 		rc = -ENOSYS;
@@ -436,14 +437,12 @@ static int ecryptfs_write_inode_size_to_xattr(struct inode *ecryptfs_inode)
 		goto out;
 	}
 	inode_lock(lower_inode);
-	size = lower_inode->i_op->getxattr(lower_dentry, lower_inode,
-					   ECRYPTFS_XATTR_NAME,
-					   xattr_virt, PAGE_SIZE);
+	size = __vfs_getxattr(lower_dentry, lower_inode, ECRYPTFS_XATTR_NAME,
+			      xattr_virt, PAGE_SIZE);
 	if (size < 0)
 		size = 8;
 	put_unaligned_be64(i_size_read(ecryptfs_inode), xattr_virt);
-	rc = lower_inode->i_op->setxattr(lower_dentry, ECRYPTFS_XATTR_NAME,
-					 xattr_virt, size, 0);
+	rc = __vfs_setxattr(lower_dentry, ECRYPTFS_XATTR_NAME, xattr_virt, size, 0);
 	inode_unlock(lower_inode);
 	if (rc)
 		printk(KERN_ERR "Error whilst attempting to write inode size "
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index cc514da..4e43569 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -58,8 +58,8 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 	char *buf, *name, *value = NULL;
 	int uninitialized_var(error);
 
-	if (!old->d_inode->i_op->getxattr ||
-	    !new->d_inode->i_op->getxattr)
+	if (!(old->d_inode->i_opflags & IOP_XATTR) ||
+	    !(new->d_inode->i_opflags & IOP_XATTR))
 		return 0;
 
 	list_size = vfs_listxattr(old, NULL, 0);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index bb4fb00..2b3f448 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -271,10 +271,10 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
 	char val;
 	struct inode *inode = dentry->d_inode;
 
-	if (!S_ISDIR(inode->i_mode) || !inode->i_op->getxattr)
+	if (!S_ISDIR(inode->i_mode) || !(inode->i_opflags & IOP_XATTR))
 		return false;
 
-	res = inode->i_op->getxattr(dentry, inode, OVL_XATTR_OPAQUE, &val, 1);
+	res = __vfs_getxattr(dentry, inode, OVL_XATTR_OPAQUE, &val, 1);
 	if (res == 1 && val == 'y')
 		return true;
 
diff --git a/fs/xattr.c b/fs/xattr.c
index ff151ff..5579ace 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -128,6 +128,18 @@ xattr_permission(struct inode *inode, const char *name, int mask)
 	return inode_permission(inode, mask);
 }
 
+int
+__vfs_setxattr(struct dentry *dentry, const char *name, const void *value,
+	       size_t size, int flags)
+{
+	struct inode *inode = dentry->d_inode;
+
+	if (!inode->i_op->setxattr)
+		return -EOPNOTSUPP;
+	return inode->i_op->setxattr(dentry, name, value, size, flags);
+}
+EXPORT_SYMBOL(__vfs_setxattr);
+
 /**
  *  __vfs_setxattr_noperm - perform setxattr operation without performing
  *  permission checks.
@@ -155,7 +167,7 @@ int __vfs_setxattr_noperm(struct dentry *dentry, const char *name,
 	if (issec)
 		inode->i_flags &= ~S_NOSEC;
 	if (inode->i_op->setxattr) {
-		error = inode->i_op->setxattr(dentry, name, value, size, flags);
+		error = __vfs_setxattr(dentry, name, value, size, flags);
 		if (!error) {
 			fsnotify_xattr(dentry);
 			security_inode_post_setxattr(dentry, name, value,
@@ -267,6 +279,16 @@ vfs_getxattr_alloc(struct dentry *dentry, const char *name, char **xattr_value,
 }
 
 ssize_t
+__vfs_getxattr(struct dentry *dentry, struct inode *inode, const char *name,
+	       void *value, size_t size)
+{
+	if (!inode->i_op->getxattr)
+		return -EOPNOTSUPP;
+	return inode->i_op->getxattr(dentry, inode, name, value, size);
+}
+EXPORT_SYMBOL(__vfs_getxattr);
+
+ssize_t
 vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
 {
 	struct inode *inode = dentry->d_inode;
@@ -293,13 +315,7 @@ vfs_getxattr(struct dentry *dentry, const char *name, void *value, size_t size)
 		return ret;
 	}
 nolsm:
-	if (inode->i_op->getxattr)
-		error = inode->i_op->getxattr(dentry, inode, name, value, size);
-	else
-		error = -EOPNOTSUPP;
-
-	return error;
-
+	return __vfs_getxattr(dentry, inode, name, value, size);
 }
 EXPORT_SYMBOL_GPL(vfs_getxattr);
 
@@ -324,13 +340,21 @@ vfs_listxattr(struct dentry *d, char *list, size_t size)
 EXPORT_SYMBOL_GPL(vfs_listxattr);
 
 int
-vfs_removexattr(struct dentry *dentry, const char *name)
+__vfs_removexattr(struct dentry *dentry, const char *name)
 {
 	struct inode *inode = dentry->d_inode;
-	int error;
 
 	if (!inode->i_op->removexattr)
 		return -EOPNOTSUPP;
+	return inode->i_op->removexattr(dentry, name);
+}
+EXPORT_SYMBOL(__vfs_removexattr);
+
+int
+vfs_removexattr(struct dentry *dentry, const char *name)
+{
+	struct inode *inode = dentry->d_inode;
+	int error;
 
 	error = xattr_permission(inode, name, MAY_WRITE);
 	if (error)
@@ -341,7 +365,7 @@ vfs_removexattr(struct dentry *dentry, const char *name)
 	if (error)
 		goto out;
 
-	error = inode->i_op->removexattr(dentry, name);
+	error = __vfs_removexattr(dentry, name);
 
 	if (!error) {
 		fsnotify_xattr(dentry);
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 1cc4c57..59271a4 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -46,10 +46,13 @@ struct xattr {
 };
 
 ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
+ssize_t __vfs_getxattr(struct dentry *, struct inode *, const char *, void *, size_t);
 ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
 ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
+int __vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
 int __vfs_setxattr_noperm(struct dentry *, const char *, const void *, size_t, int);
 int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
+int __vfs_removexattr(struct dentry *, const char *);
 int vfs_removexattr(struct dentry *, const char *);
 
 ssize_t generic_getxattr(struct dentry *dentry, struct inode *inode, const char *name, void *buffer, size_t size);
diff --git a/security/commoncap.c b/security/commoncap.c
index e7fadde..b878d77 100644
--- a/security/commoncap.c
+++ b/security/commoncap.c
@@ -310,13 +310,8 @@ int cap_inode_need_killpriv(struct dentry *dentry)
 	struct inode *inode = d_backing_inode(dentry);
 	int error;
 
-	if (!inode->i_op->getxattr)
-	       return 0;
-
-	error = inode->i_op->getxattr(dentry, inode, XATTR_NAME_CAPS, NULL, 0);
-	if (error <= 0)
-		return 0;
-	return 1;
+	error = __vfs_getxattr(dentry, inode, XATTR_NAME_CAPS, NULL, 0);
+	return error > 0;
 }
 
 /**
@@ -329,12 +324,12 @@ int cap_inode_need_killpriv(struct dentry *dentry)
  */
 int cap_inode_killpriv(struct dentry *dentry)
 {
-	struct inode *inode = d_backing_inode(dentry);
-
-	if (!inode->i_op->removexattr)
-	       return 0;
+	int error;
 
-	return inode->i_op->removexattr(dentry, XATTR_NAME_CAPS);
+	error = __vfs_removexattr(dentry, XATTR_NAME_CAPS);
+	if (error == -EOPNOTSUPP)
+		error = 0;
+	return error;
 }
 
 /*
@@ -394,11 +389,11 @@ int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data
 
 	memset(cpu_caps, 0, sizeof(struct cpu_vfs_cap_data));
 
-	if (!inode || !inode->i_op->getxattr)
+	if (!inode)
 		return -ENODATA;
 
-	size = inode->i_op->getxattr((struct dentry *)dentry, inode,
-				     XATTR_NAME_CAPS, &caps, XATTR_CAPS_SZ);
+	size = __vfs_getxattr((struct dentry *)dentry, inode,
+			      XATTR_NAME_CAPS, &caps, XATTR_CAPS_SZ);
 	if (size == -ENODATA || size == -EOPNOTSUPP)
 		/* no data, that's ok */
 		return -ENODATA;
diff --git a/security/integrity/evm/evm_crypto.c b/security/integrity/evm/evm_crypto.c
index 3ac6407..a9cbeb6 100644
--- a/security/integrity/evm/evm_crypto.c
+++ b/security/integrity/evm/evm_crypto.c
@@ -182,8 +182,9 @@ static int evm_calc_hmac_or_hash(struct dentry *dentry,
 	int error;
 	int size;
 
-	if (!inode->i_op->getxattr)
+	if (!(inode->i_opflags & IOP_XATTR))
 		return -EOPNOTSUPP;
+
 	desc = init_desc(type);
 	if (IS_ERR(desc))
 		return PTR_ERR(desc);
@@ -242,7 +243,6 @@ int evm_calc_hash(struct dentry *dentry, const char *req_xattr_name,
 void evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 			 const char *xattr_value, size_t xattr_value_len)
 {
-	struct inode *inode = d_backing_inode(dentry);
 	struct evm_ima_xattr_data xattr_data;
 	int rc;
 
@@ -252,8 +252,8 @@ void evm_update_evmxattr(struct dentry *dentry, const char *xattr_name,
 		xattr_data.type = EVM_XATTR_HMAC;
 		__vfs_setxattr_noperm(dentry, XATTR_NAME_EVM, &xattr_data,
 				      sizeof(xattr_data), 0);
-	} else if (rc == -ENODATA && inode->i_op->removexattr) {
-		inode->i_op->removexattr(dentry, XATTR_NAME_EVM);
+	} else if (rc == -ENODATA) {
+		__vfs_removexattr(dentry, XATTR_NAME_EVM);
 	}
 }
 
diff --git a/security/integrity/evm/evm_main.c b/security/integrity/evm/evm_main.c
index b9e2628..ba86155 100644
--- a/security/integrity/evm/evm_main.c
+++ b/security/integrity/evm/evm_main.c
@@ -78,11 +78,11 @@ static int evm_find_protected_xattrs(struct dentry *dentry)
 	int error;
 	int count = 0;
 
-	if (!inode->i_op->getxattr)
+	if (!(inode->i_opflags & IOP_XATTR))
 		return -EOPNOTSUPP;
 
 	for (xattr = evm_config_xattrnames; *xattr != NULL; xattr++) {
-		error = inode->i_op->getxattr(dentry, inode, *xattr, NULL, 0);
+		error = __vfs_getxattr(dentry, inode, *xattr, NULL, 0);
 		if (error < 0) {
 			if (error == -ENODATA)
 				continue;
diff --git a/security/integrity/ima/ima_appraise.c b/security/integrity/ima/ima_appraise.c
index 1bcbc12..6886f68 100644
--- a/security/integrity/ima/ima_appraise.c
+++ b/security/integrity/ima/ima_appraise.c
@@ -165,13 +165,13 @@ enum hash_algo ima_get_hash_algo(struct evm_ima_xattr_data *xattr_value,
 int ima_read_xattr(struct dentry *dentry,
 		   struct evm_ima_xattr_data **xattr_value)
 {
-	struct inode *inode = d_backing_inode(dentry);
-
-	if (!inode->i_op->getxattr)
-		return 0;
+	ssize_t ret;
 
-	return vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)xattr_value,
-				  0, GFP_NOFS);
+	ret = vfs_getxattr_alloc(dentry, XATTR_NAME_IMA, (char **)xattr_value,
+				 0, GFP_NOFS);
+	if (ret == -EOPNOTSUPP)
+		ret = 0;
+	return ret;
 }
 
 /*
@@ -195,7 +195,7 @@ int ima_appraise_measurement(enum ima_hooks func,
 	enum integrity_status status = INTEGRITY_UNKNOWN;
 	int rc = xattr_len, hash_start = 0;
 
-	if (!inode->i_op->getxattr)
+	if (!(inode->i_opflags & IOP_XATTR))
 		return INTEGRITY_UNKNOWN;
 
 	if (rc <= 0) {
@@ -322,10 +322,10 @@ void ima_inode_post_setattr(struct dentry *dentry)
 {
 	struct inode *inode = d_backing_inode(dentry);
 	struct integrity_iint_cache *iint;
-	int must_appraise, rc;
+	int must_appraise;
 
 	if (!(ima_policy_flag & IMA_APPRAISE) || !S_ISREG(inode->i_mode)
-	    || !inode->i_op->removexattr)
+	    || !(inode->i_opflags & IOP_XATTR))
 		return;
 
 	must_appraise = ima_must_appraise(inode, MAY_ACCESS, POST_SETATTR);
@@ -338,8 +338,7 @@ void ima_inode_post_setattr(struct dentry *dentry)
 			iint->flags |= IMA_APPRAISE;
 	}
 	if (!must_appraise)
-		rc = inode->i_op->removexattr(dentry, XATTR_NAME_IMA);
-	return;
+		__vfs_removexattr(dentry, XATTR_NAME_IMA);
 }
 
 /*
diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
index a86d537..f11b444 100644
--- a/security/selinux/hooks.c
+++ b/security/selinux/hooks.c
@@ -507,14 +507,14 @@ static int sb_finish_set_opts(struct super_block *sb)
 		   the root directory.  -ENODATA is ok, as this may be
 		   the first boot of the SELinux kernel before we have
 		   assigned xattr values to the filesystem. */
-		if (!root_inode->i_op->getxattr) {
+		if (!(root_inode->i_opflags & IOP_XATTR)) {
 			printk(KERN_WARNING "SELinux: (dev %s, type %s) has no "
 			       "xattr support\n", sb->s_id, sb->s_type->name);
 			rc = -EOPNOTSUPP;
 			goto out;
 		}
-		rc = root_inode->i_op->getxattr(root, root_inode,
-						XATTR_NAME_SELINUX, NULL, 0);
+
+		rc = __vfs_getxattr(root, root_inode, XATTR_NAME_SELINUX, NULL, 0);
 		if (rc < 0 && rc != -ENODATA) {
 			if (rc == -EOPNOTSUPP)
 				printk(KERN_WARNING "SELinux: (dev %s, type "
@@ -1387,11 +1387,10 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 	case SECURITY_FS_USE_NATIVE:
 		break;
 	case SECURITY_FS_USE_XATTR:
-		if (!inode->i_op->getxattr) {
+		if (!(inode->i_opflags & IOP_XATTR)) {
 			isec->sid = sbsec->def_sid;
 			break;
 		}
-
 		/* Need a dentry, since the xattr API requires one.
 		   Life would be simpler if we could just pass the inode. */
 		if (opt_dentry) {
@@ -1422,14 +1421,12 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 			goto out_unlock;
 		}
 		context[len] = '\0';
-		rc = inode->i_op->getxattr(dentry, inode, XATTR_NAME_SELINUX,
-					   context, len);
+		rc = __vfs_getxattr(dentry, inode, XATTR_NAME_SELINUX, context, len);
 		if (rc == -ERANGE) {
 			kfree(context);
 
 			/* Need a larger buffer.  Query for the right size. */
-			rc = inode->i_op->getxattr(dentry, inode, XATTR_NAME_SELINUX,
-						   NULL, 0);
+			rc = __vfs_getxattr(dentry, inode, XATTR_NAME_SELINUX, NULL, 0);
 			if (rc < 0) {
 				dput(dentry);
 				goto out_unlock;
@@ -1442,9 +1439,7 @@ static int inode_doinit_with_dentry(struct inode *inode, struct dentry *opt_dent
 				goto out_unlock;
 			}
 			context[len] = '\0';
-			rc = inode->i_op->getxattr(dentry, inode,
-						   XATTR_NAME_SELINUX,
-						   context, len);
+			rc = __vfs_getxattr(dentry, inode, XATTR_NAME_SELINUX, context, len);
 		}
 		dput(dentry);
 		if (rc < 0) {
diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
index ff2b8c3..472985d 100644
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -265,14 +265,14 @@ static struct smack_known *smk_fetch(const char *name, struct inode *ip,
 	char *buffer;
 	struct smack_known *skp = NULL;
 
-	if (ip->i_op->getxattr == NULL)
+	if (!(ip->i_opflags & IOP_XATTR))
 		return ERR_PTR(-EOPNOTSUPP);
 
 	buffer = kzalloc(SMK_LONGLABEL, GFP_KERNEL);
 	if (buffer == NULL)
 		return ERR_PTR(-ENOMEM);
 
-	rc = ip->i_op->getxattr(dp, ip, name, buffer, SMK_LONGLABEL);
+	rc = __vfs_getxattr(dp, ip, name, buffer, SMK_LONGLABEL);
 	if (rc < 0)
 		skp = ERR_PTR(rc);
 	else if (rc == 0)
@@ -3489,8 +3489,8 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 		 * It would be curious if the label of the task
 		 * does not match that assigned.
 		 */
-		if (inode->i_op->getxattr == NULL)
-			break;
+		if (!(inode->i_opflags & IOP_XATTR))
+		        break;
 		/*
 		 * Get the dentry for xattr.
 		 */
@@ -3514,12 +3514,12 @@ static void smack_d_instantiate(struct dentry *opt_dentry, struct inode *inode)
 			 */
 			if (isp->smk_flags & SMK_INODE_CHANGED) {
 				isp->smk_flags &= ~SMK_INODE_CHANGED;
-				rc = inode->i_op->setxattr(dp,
+				rc = __vfs_setxattr(dp,
 					XATTR_NAME_SMACKTRANSMUTE,
 					TRANS_TRUE, TRANS_TRUE_SIZE,
 					0);
 			} else {
-				rc = inode->i_op->getxattr(dp, inode,
+				rc = __vfs_getxattr(dp, inode,
 					XATTR_NAME_SMACKTRANSMUTE, trattr,
 					TRANS_TRUE_SIZE);
 				if (rc >= 0 && strncmp(trattr, TRANS_TRUE,
-- 
2.5.5

