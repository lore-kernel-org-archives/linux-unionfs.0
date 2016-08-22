From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v4 02/20] ovl: Get rid of ovl_xattr_noacl_handlers array
Date: Mon, 22 Aug 2016 23:21:50 +0200
Message-ID: <1471900928-21588-3-git-send-email-agruenba@redhat.com>
References: <1471900928-21588-1-git-send-email-agruenba@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755546AbcHVVW1 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 22 Aug 2016 17:22:27 -0400
In-Reply-To: <1471900928-21588-1-git-send-email-agruenba@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>

Use an ordinary #ifdef to conditionally include the POSIX ACL handlers
in ovl_xattr_handlers, like the other filesystems do.  Flag the code
that is now only used conditionally with __maybe_unused.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/overlayfs/super.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4036132..e2b555d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -967,10 +967,11 @@ static unsigned int ovl_split_lowerdirs(char *str)
 	return ctr;
 }
 
-static int ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
-				   struct dentry *dentry, struct inode *inode,
-				   const char *name, const void *value,
-				   size_t size, int flags)
+static int __maybe_unused
+ovl_posix_acl_xattr_set(const struct xattr_handler *handler,
+			struct dentry *dentry, struct inode *inode,
+			const char *name, const void *value,
+			size_t size, int flags)
 {
 	struct dentry *workdir = ovl_workdir(dentry);
 	struct inode *realinode = ovl_inode_real(inode, NULL);
@@ -1021,13 +1022,15 @@ static int ovl_own_xattr_set(const struct xattr_handler *handler,
 	return -EPERM;
 }
 
-static const struct xattr_handler ovl_posix_acl_access_xattr_handler = {
+static const struct xattr_handler __maybe_unused
+ovl_posix_acl_access_xattr_handler = {
 	.name = XATTR_NAME_POSIX_ACL_ACCESS,
 	.flags = ACL_TYPE_ACCESS,
 	.set = ovl_posix_acl_xattr_set,
 };
 
-static const struct xattr_handler ovl_posix_acl_default_xattr_handler = {
+static const struct xattr_handler __maybe_unused
+ovl_posix_acl_default_xattr_handler = {
 	.name = XATTR_NAME_POSIX_ACL_DEFAULT,
 	.flags = ACL_TYPE_DEFAULT,
 	.set = ovl_posix_acl_xattr_set,
@@ -1044,19 +1047,15 @@ static const struct xattr_handler ovl_other_xattr_handler = {
 };
 
 static const struct xattr_handler *ovl_xattr_handlers[] = {
+#ifdef CONFIG_FS_POSIX_ACL
 	&ovl_posix_acl_access_xattr_handler,
 	&ovl_posix_acl_default_xattr_handler,
+#endif
 	&ovl_own_xattr_handler,
 	&ovl_other_xattr_handler,
 	NULL
 };
 
-static const struct xattr_handler *ovl_xattr_noacl_handlers[] = {
-	&ovl_own_xattr_handler,
-	&ovl_other_xattr_handler,
-	NULL,
-};
-
 static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct path upperpath = { NULL, NULL };
@@ -1269,10 +1268,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
 	sb->s_op = &ovl_super_operations;
-	if (IS_ENABLED(CONFIG_FS_POSIX_ACL))
-		sb->s_xattr = ovl_xattr_handlers;
-	else
-		sb->s_xattr = ovl_xattr_noacl_handlers;
+	sb->s_xattr = ovl_xattr_handlers;
 	sb->s_root = root_dentry;
 	sb->s_fs_info = ufs;
 	sb->s_flags |= MS_POSIXACL;
-- 
2.7.4
