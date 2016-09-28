From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v5 02/17] jffs2: Remove jffs2_{get,set,remove}xattr macros
Date: Wed, 28 Sep 2016 16:57:48 +0200
Message-ID: <1475074683-26971-3-git-send-email-agruenba@redhat.com>
References: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34208 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932802AbcI1O6U (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 28 Sep 2016 10:58:20 -0400
In-Reply-To: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

When CONFIG_JFFS2_FS_XATTR is off, jffs2_xattr_handlers is defined as
NULL. With sb->s_xattr == NULL, the generic_{get,set,remove}xattr
functions produce the same result as setting the {get,set,remove}xattr
inode operations to NULL, so there is no need for these macros.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/jffs2/dir.c     | 6 +++---
 fs/jffs2/file.c    | 6 +++---
 fs/jffs2/symlink.c | 6 +++---
 fs/jffs2/xattr.h   | 6 ------
 4 files changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 30eb33ff..8aa2f89 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -61,10 +61,10 @@ const struct inode_operations jffs2_dir_inode_operations =
 	.get_acl =	jffs2_get_acl,
 	.set_acl =	jffs2_set_acl,
 	.setattr =	jffs2_setattr,
-	.setxattr =	jffs2_setxattr,
-	.getxattr =	jffs2_getxattr,
+	.setxattr =	generic_setxattr,
+	.getxattr =	generic_getxattr,
 	.listxattr =	jffs2_listxattr,
-	.removexattr =	jffs2_removexattr
+	.removexattr =	generic_removexattr
 };
 
 /***********************************************************************/
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index 0e62dec..fdf9e1c 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -66,10 +66,10 @@ const struct inode_operations jffs2_file_inode_operations =
 	.get_acl =	jffs2_get_acl,
 	.set_acl =	jffs2_set_acl,
 	.setattr =	jffs2_setattr,
-	.setxattr =	jffs2_setxattr,
-	.getxattr =	jffs2_getxattr,
+	.setxattr =	generic_setxattr,
+	.getxattr =	generic_getxattr,
 	.listxattr =	jffs2_listxattr,
-	.removexattr =	jffs2_removexattr
+	.removexattr =	generic_removexattr
 };
 
 const struct address_space_operations jffs2_file_address_operations =
diff --git a/fs/jffs2/symlink.c b/fs/jffs2/symlink.c
index 2cabd64..afe2d75 100644
--- a/fs/jffs2/symlink.c
+++ b/fs/jffs2/symlink.c
@@ -16,8 +16,8 @@ const struct inode_operations jffs2_symlink_inode_operations =
 	.readlink =	generic_readlink,
 	.get_link =	simple_get_link,
 	.setattr =	jffs2_setattr,
-	.setxattr =	jffs2_setxattr,
-	.getxattr =	jffs2_getxattr,
+	.setxattr =	generic_setxattr,
+	.getxattr =	generic_getxattr,
 	.listxattr =	jffs2_listxattr,
-	.removexattr =	jffs2_removexattr
+	.removexattr =	generic_removexattr
 };
diff --git a/fs/jffs2/xattr.h b/fs/jffs2/xattr.h
index 467ff37..720007b 100644
--- a/fs/jffs2/xattr.h
+++ b/fs/jffs2/xattr.h
@@ -99,9 +99,6 @@ extern const struct xattr_handler jffs2_user_xattr_handler;
 extern const struct xattr_handler jffs2_trusted_xattr_handler;
 
 extern ssize_t jffs2_listxattr(struct dentry *, char *, size_t);
-#define jffs2_getxattr		generic_getxattr
-#define jffs2_setxattr		generic_setxattr
-#define jffs2_removexattr	generic_removexattr
 
 #else
 
@@ -116,9 +113,6 @@ extern ssize_t jffs2_listxattr(struct dentry *, char *, size_t);
 
 #define jffs2_xattr_handlers	NULL
 #define jffs2_listxattr		NULL
-#define jffs2_getxattr		NULL
-#define jffs2_setxattr		NULL
-#define jffs2_removexattr	NULL
 
 #endif /* CONFIG_JFFS2_FS_XATTR */
 
-- 
2.7.4
