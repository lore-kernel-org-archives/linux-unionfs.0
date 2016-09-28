From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v5 09/17] lustre: Switch to generic xattr handlers
Date: Wed, 28 Sep 2016 16:57:55 +0200
Message-ID: <1475074683-26971-10-git-send-email-agruenba@redhat.com>
References: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 drivers/staging/lustre/lustre/llite/file.c         |  3 --
 .../staging/lustre/lustre/llite/llite_internal.h   |  7 ++--
 drivers/staging/lustre/lustre/llite/llite_lib.c    |  1 +
 drivers/staging/lustre/lustre/llite/namei.c        |  6 ----
 drivers/staging/lustre/lustre/llite/symlink.c      |  3 --
 drivers/staging/lustre/lustre/llite/xattr.c        | 42 +++++++++++++++++++---
 6 files changed, 40 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/lustre/lustre/llite/file.c b/drivers/staging/lustre/lustre/llite/file.c
index 57281b9..e8c81e8 100644
--- a/drivers/staging/lustre/lustre/llite/file.c
+++ b/drivers/staging/lustre/lustre/llite/file.c
@@ -3213,10 +3213,7 @@ const struct inode_operations ll_file_inode_operations = {
 	.setattr	= ll_setattr,
 	.getattr	= ll_getattr,
 	.permission	= ll_inode_permission,
-	.setxattr	= ll_setxattr,
-	.getxattr	= ll_getxattr,
 	.listxattr	= ll_listxattr,
-	.removexattr	= ll_removexattr,
 	.fiemap		= ll_fiemap,
 	.get_acl	= ll_get_acl,
 };
diff --git a/drivers/staging/lustre/lustre/llite/llite_internal.h b/drivers/staging/lustre/lustre/llite/llite_internal.h
index 4d6d589..8695aca 100644
--- a/drivers/staging/lustre/lustre/llite/llite_internal.h
+++ b/drivers/staging/lustre/lustre/llite/llite_internal.h
@@ -933,12 +933,9 @@ static inline __u64 ll_file_maxbytes(struct inode *inode)
 }
 
 /* llite/xattr.c */
-int ll_setxattr(struct dentry *dentry, struct inode *inode,
-		const char *name, const void *value, size_t size, int flags);
-ssize_t ll_getxattr(struct dentry *dentry, struct inode *inode,
-		    const char *name, void *buffer, size_t size);
+struct xattr_handler;
+extern const struct xattr_handler *lustre_xattr_handlers[];
 ssize_t ll_listxattr(struct dentry *dentry, char *buffer, size_t size);
-int ll_removexattr(struct dentry *dentry, const char *name);
 
 /**
  * Common IO arguments for various VFS I/O interfaces.
diff --git a/drivers/staging/lustre/lustre/llite/llite_lib.c b/drivers/staging/lustre/lustre/llite/llite_lib.c
index 546063e..81f4fe9 100644
--- a/drivers/staging/lustre/lustre/llite/llite_lib.c
+++ b/drivers/staging/lustre/lustre/llite/llite_lib.c
@@ -421,6 +421,7 @@ static int client_common_fill_super(struct super_block *sb, char *md, char *dt,
 #if THREAD_SIZE >= 8192 /*b=17630*/
 	sb->s_export_op = &lustre_export_operations;
 #endif
+	sb->s_xattr = lustre_xattr_handlers;
 
 	/* make root inode
 	 * XXX: move this to after cbd setup?
diff --git a/drivers/staging/lustre/lustre/llite/namei.c b/drivers/staging/lustre/lustre/llite/namei.c
index 2c4dc69..f9822403 100644
--- a/drivers/staging/lustre/lustre/llite/namei.c
+++ b/drivers/staging/lustre/lustre/llite/namei.c
@@ -1106,10 +1106,7 @@ const struct inode_operations ll_dir_inode_operations = {
 	.setattr	    = ll_setattr,
 	.getattr	    = ll_getattr,
 	.permission	 = ll_inode_permission,
-	.setxattr	   = ll_setxattr,
-	.getxattr	   = ll_getxattr,
 	.listxattr	  = ll_listxattr,
-	.removexattr	= ll_removexattr,
 	.get_acl	    = ll_get_acl,
 };
 
@@ -1117,9 +1114,6 @@ const struct inode_operations ll_special_inode_operations = {
 	.setattr	= ll_setattr,
 	.getattr	= ll_getattr,
 	.permission     = ll_inode_permission,
-	.setxattr       = ll_setxattr,
-	.getxattr       = ll_getxattr,
 	.listxattr      = ll_listxattr,
-	.removexattr    = ll_removexattr,
 	.get_acl	    = ll_get_acl,
 };
diff --git a/drivers/staging/lustre/lustre/llite/symlink.c b/drivers/staging/lustre/lustre/llite/symlink.c
index 8c8bdfe..d82dab2 100644
--- a/drivers/staging/lustre/lustre/llite/symlink.c
+++ b/drivers/staging/lustre/lustre/llite/symlink.c
@@ -155,8 +155,5 @@ const struct inode_operations ll_fast_symlink_inode_operations = {
 	.get_link	= ll_get_link,
 	.getattr	= ll_getattr,
 	.permission	= ll_inode_permission,
-	.setxattr	= ll_setxattr,
-	.getxattr	= ll_getxattr,
 	.listxattr	= ll_listxattr,
-	.removexattr	= ll_removexattr,
 };
diff --git a/drivers/staging/lustre/lustre/llite/xattr.c b/drivers/staging/lustre/lustre/llite/xattr.c
index 98303cf..f43f523 100644
--- a/drivers/staging/lustre/lustre/llite/xattr.c
+++ b/drivers/staging/lustre/lustre/llite/xattr.c
@@ -34,6 +34,7 @@
 #include <linux/sched.h>
 #include <linux/mm.h>
 #include <linux/selinux.h>
+#include <linux/xattr.h>
 
 #define DEBUG_SUBSYSTEM S_LLITE
 
@@ -149,8 +150,9 @@ int ll_setxattr_common(struct inode *inode, const char *name,
 	return 0;
 }
 
-int ll_setxattr(struct dentry *dentry, struct inode *inode,
-		const char *name, const void *value, size_t size, int flags)
+static int ll_setxattr(struct dentry *dentry, struct inode *inode,
+		       const char *name, const void *value, size_t size,
+		       int flags)
 {
 	LASSERT(inode);
 	LASSERT(name);
@@ -202,7 +204,7 @@ int ll_setxattr(struct dentry *dentry, struct inode *inode,
 				  OBD_MD_FLXATTR);
 }
 
-int ll_removexattr(struct dentry *dentry, const char *name)
+static int ll_removexattr(struct dentry *dentry, const char *name)
 {
 	struct inode *inode = d_inode(dentry);
 
@@ -351,8 +353,8 @@ out:
 	return rc;
 }
 
-ssize_t ll_getxattr(struct dentry *dentry, struct inode *inode,
-		    const char *name, void *buffer, size_t size)
+static ssize_t ll_getxattr(struct dentry *dentry, struct inode *inode,
+			   const char *name, void *buffer, size_t size)
 {
 	LASSERT(inode);
 	LASSERT(name);
@@ -518,3 +520,33 @@ out:
 
 	return rc;
 }
+
+static int lustre_xattr_get(const struct xattr_handler *handler,
+			    struct dentry *dentry, struct inode *inode,
+			    const char *name, void *buffer, size_t size)
+{
+	return ll_getxattr(dentry, inode, name, buffer, size);
+}
+
+static int lustre_xattr_set(const struct xattr_handler *handler,
+			    struct dentry *dentry, struct inode *inode,
+			    const char *name, const void *value, size_t size,
+			    int flags)
+{
+	if (!value) {
+		BUG_ON(flags != XATTR_REPLACE);
+		return ll_removexattr(dentry, name);
+	}
+	return ll_setxattr(dentry, inode, name, value, size, flags);
+}
+
+const struct xattr_handler lustre_xattr_handler = {
+	.prefix = "",  /* match anything */
+	.get = lustre_xattr_get,
+	.set = lustre_xattr_set,
+};
+
+const struct xattr_handler *lustre_xattr_handlers[] = {
+	&lustre_xattr_handler,
+	NULL
+};
-- 
2.7.4
