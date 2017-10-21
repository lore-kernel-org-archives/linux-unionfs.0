From: Nicolas Belouin <nicolas@belouin.fr>
Subject: [RFC PATCH 2/2] fs: Grant CAP_TRUSTED rw access to trusted xattrs
Date: Sat, 21 Oct 2017 15:45:58 +0200
Message-ID: <20171021134558.21195-2-nicolas__32236.7715220482$1508594269$gmane$org@belouin.fr>
References: <20171021134558.21195-1-nicolas@belouin.fr>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtp-sh2.infomaniak.ch ([128.65.195.6]:42230 "EHLO
        smtp-sh2.infomaniak.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932085AbdJUN5p (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 21 Oct 2017 09:57:45 -0400
In-Reply-To: <20171021134558.21195-1-nicolas@belouin.fr>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Jan Kara <jack@suse.com>, Theodore Ts'o <tytso@mit.edu>, Andreas Dilger <adilger.kernel@dilger.ca>, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>, David Woodhouse <dwmw2@infradead.org>, Dave Kleikamp <shaggy@kernel.org>, Mark Fasheh <mfasheh@versity.com>, Joel Becker <jlbec@evilplan.org>, Miklos Szeredi <miklos@szeredi.hu>, Phillip Lougher <phillip@squashfs.org.uk>, Richard Weinberger <richard@nod.at>, Artem Bityutskiy <dedekind1@gmail.com>, Adrian Hunter <adrian.hunter@intel.com>, Alexander Viro <viro@zeniv.linux.org.uk>, Serge Hallyn <serge@hallyn.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, James Morris <james.l.morris@oracle.com>, linux-ext4@vger.kernel
Cc: Nicolas Belouin <nicolas@belouin.fr>

The trusted xattrs read/write access is the perfect use case for
CAP_TRUSTED.

Signed-off-by: Nicolas Belouin <nicolas@belouin.fr>
---
 fs/ext2/xattr_trusted.c     |  2 +-
 fs/ext4/xattr_trusted.c     |  2 +-
 fs/f2fs/xattr.c             |  6 +++---
 fs/hfsplus/xattr.c          |  2 +-
 fs/jffs2/xattr_trusted.c    |  2 +-
 fs/jfs/xattr.c              |  3 ++-
 fs/ocfs2/xattr.c            |  2 +-
 fs/overlayfs/inode.c        |  3 ++-
 fs/reiserfs/xattr_trusted.c | 11 ++++++++---
 fs/squashfs/xattr.c         |  2 +-
 fs/ubifs/xattr.c            |  3 ++-
 fs/xattr.c                  |  4 ++--
 12 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/ext2/xattr_trusted.c b/fs/ext2/xattr_trusted.c
index 65049b71af13..8006c24f8ee0 100644
--- a/fs/ext2/xattr_trusted.c
+++ b/fs/ext2/xattr_trusted.c
@@ -11,7 +11,7 @@
 static bool
 ext2_xattr_trusted_list(struct dentry *dentry)
 {
-	return capable(CAP_SYS_ADMIN);
+	return capable(CAP_SYS_ADMIN) || capable(CAP_TRUSTED);
 }
 
 static int
diff --git a/fs/ext4/xattr_trusted.c b/fs/ext4/xattr_trusted.c
index c7765c735714..9849d1e0ebb9 100644
--- a/fs/ext4/xattr_trusted.c
+++ b/fs/ext4/xattr_trusted.c
@@ -15,7 +15,7 @@
 static bool
 ext4_xattr_trusted_list(struct dentry *dentry)
 {
-	return capable(CAP_SYS_ADMIN);
+	return capable(CAP_SYS_ADMIN) || capable(CAP_TRUSTED);
 }
 
 static int
diff --git a/fs/f2fs/xattr.c b/fs/f2fs/xattr.c
index 7c65540148f8..ef572464deca 100644
--- a/fs/f2fs/xattr.c
+++ b/fs/f2fs/xattr.c
@@ -37,7 +37,7 @@ static int f2fs_xattr_generic_get(const struct xattr_handler *handler,
 			return -EOPNOTSUPP;
 		break;
 	case F2FS_XATTR_INDEX_TRUSTED:
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_TRUSTED))
 			return -EPERM;
 		break;
 	case F2FS_XATTR_INDEX_SECURITY:
@@ -62,7 +62,7 @@ static int f2fs_xattr_generic_set(const struct xattr_handler *handler,
 			return -EOPNOTSUPP;
 		break;
 	case F2FS_XATTR_INDEX_TRUSTED:
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_TRUSTED))
 			return -EPERM;
 		break;
 	case F2FS_XATTR_INDEX_SECURITY:
@@ -83,7 +83,7 @@ static bool f2fs_xattr_user_list(struct dentry *dentry)
 
 static bool f2fs_xattr_trusted_list(struct dentry *dentry)
 {
-	return capable(CAP_SYS_ADMIN);
+	return capable(CAP_SYS_ADMIN) || capable(CAP_TRUSTED);
 }
 
 static int f2fs_xattr_advise_get(const struct xattr_handler *handler,
diff --git a/fs/hfsplus/xattr.c b/fs/hfsplus/xattr.c
index ae03a19196ef..0ec6d02ee7e9 100644
--- a/fs/hfsplus/xattr.c
+++ b/fs/hfsplus/xattr.c
@@ -606,7 +606,7 @@ static inline int can_list(const char *xattr_name)
 
 	return !strncmp(xattr_name, XATTR_TRUSTED_PREFIX,
 			XATTR_TRUSTED_PREFIX_LEN) ||
-				capable(CAP_SYS_ADMIN);
+				capable(CAP_SYS_ADMIN) || capable(CAP_TRUSTED);
 }
 
 static ssize_t hfsplus_listxattr_finder_info(struct dentry *dentry,
diff --git a/fs/jffs2/xattr_trusted.c b/fs/jffs2/xattr_trusted.c
index 5d6030826c52..3c7ae98e4525 100644
--- a/fs/jffs2/xattr_trusted.c
+++ b/fs/jffs2/xattr_trusted.c
@@ -35,7 +35,7 @@ static int jffs2_trusted_setxattr(const struct xattr_handler *handler,
 
 static bool jffs2_trusted_listxattr(struct dentry *dentry)
 {
-	return capable(CAP_SYS_ADMIN);
+	return capable(CAP_SYS_ADMIN) || capable(CAP_TRUSTED);
 }
 
 const struct xattr_handler jffs2_trusted_xattr_handler = {
diff --git a/fs/jfs/xattr.c b/fs/jfs/xattr.c
index 1c46573a96ed..e4f44f5133a1 100644
--- a/fs/jfs/xattr.c
+++ b/fs/jfs/xattr.c
@@ -859,7 +859,8 @@ ssize_t __jfs_getxattr(struct inode *inode, const char *name, void *data,
 static inline int can_list(struct jfs_ea *ea)
 {
 	return (!strncmp(ea->name, XATTR_TRUSTED_PREFIX,
-			 XATTR_TRUSTED_PREFIX_LEN) || capable(CAP_SYS_ADMIN));
+			 XATTR_TRUSTED_PREFIX_LEN) ||
+		capable(CAP_SYS_ADMIN) || capable(CAP_TRUSTED));
 }
 
 ssize_t jfs_listxattr(struct dentry * dentry, char *data, size_t buf_size)
diff --git a/fs/ocfs2/xattr.c b/fs/ocfs2/xattr.c
index 5fdf269ba82e..2b3994d192c6 100644
--- a/fs/ocfs2/xattr.c
+++ b/fs/ocfs2/xattr.c
@@ -906,7 +906,7 @@ static int ocfs2_xattr_list_entry(struct super_block *sb,
 		break;
 
 	case OCFS2_XATTR_INDEX_TRUSTED:
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_TRUSTED))
 			return 0;
 		break;
 	}
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a619addecafc..c627003d3a74 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -264,7 +264,8 @@ static bool ovl_can_list(const char *s)
 		return true;
 
 	/* Never list trusted.overlay, list other trusted for superuser only */
-	return !ovl_is_private_xattr(s) && capable(CAP_SYS_ADMIN);
+	return !ovl_is_private_xattr(s) &&
+		(capable(CAP_SYS_ADMIN) || capable(CAP_TRUSTED));
 }
 
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
diff --git a/fs/reiserfs/xattr_trusted.c b/fs/reiserfs/xattr_trusted.c
index f15a5f9e84ce..6f3fa0db8272 100644
--- a/fs/reiserfs/xattr_trusted.c
+++ b/fs/reiserfs/xattr_trusted.c
@@ -7,11 +7,16 @@
 #include "xattr.h"
 #include <linux/uaccess.h>
 
+inline bool trusted_capable(void)
+{
+	return capable(CAP_SYS_ADMIN) || capable(CAP_TRUSTED);
+}
+
 static int
 trusted_get(const struct xattr_handler *handler, struct dentry *unused,
 	    struct inode *inode, const char *name, void *buffer, size_t size)
 {
-	if (!capable(CAP_SYS_ADMIN) || IS_PRIVATE(inode))
+	if (!trusted_capable() || IS_PRIVATE(inode))
 		return -EPERM;
 
 	return reiserfs_xattr_get(inode, xattr_full_name(handler, name),
@@ -23,7 +28,7 @@ trusted_set(const struct xattr_handler *handler, struct dentry *unused,
 	    struct inode *inode, const char *name, const void *buffer,
 	    size_t size, int flags)
 {
-	if (!capable(CAP_SYS_ADMIN) || IS_PRIVATE(inode))
+	if (!trusted_capable() || IS_PRIVATE(inode))
 		return -EPERM;
 
 	return reiserfs_xattr_set(inode,
@@ -33,7 +38,7 @@ trusted_set(const struct xattr_handler *handler, struct dentry *unused,
 
 static bool trusted_list(struct dentry *dentry)
 {
-	return capable(CAP_SYS_ADMIN) && !IS_PRIVATE(d_inode(dentry));
+	return trusted_capable() && !IS_PRIVATE(d_inode(dentry));
 }
 
 const struct xattr_handler reiserfs_xattr_trusted_handler = {
diff --git a/fs/squashfs/xattr.c b/fs/squashfs/xattr.c
index 1548b3784548..e0a285ab1f7e 100644
--- a/fs/squashfs/xattr.c
+++ b/fs/squashfs/xattr.c
@@ -237,7 +237,7 @@ static const struct xattr_handler squashfs_xattr_user_handler = {
  */
 static bool squashfs_trusted_xattr_handler_list(struct dentry *d)
 {
-	return capable(CAP_SYS_ADMIN);
+	return capable(CAP_SYS_ADMIN) || capable(CAP_TRUSTED);
 }
 
 static const struct xattr_handler squashfs_xattr_trusted_handler = {
diff --git a/fs/ubifs/xattr.c b/fs/ubifs/xattr.c
index c13eae819cbc..f3aa8be72a66 100644
--- a/fs/ubifs/xattr.c
+++ b/fs/ubifs/xattr.c
@@ -406,7 +406,8 @@ static bool xattr_visible(const char *name)
 
 	/* Show trusted namespace only for "power" users */
 	if (strncmp(name, XATTR_TRUSTED_PREFIX,
-		    XATTR_TRUSTED_PREFIX_LEN) == 0 && !capable(CAP_SYS_ADMIN))
+		    XATTR_TRUSTED_PREFIX_LEN) == 0 &&
+	    !capable(CAP_SYS_ADMIN) && !capable(CAP_TRUSTED))
 		return false;
 
 	return true;
diff --git a/fs/xattr.c b/fs/xattr.c
index 61cd28ba25f3..d9e9a0083dbb 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -113,7 +113,7 @@ xattr_permission(struct inode *inode, const char *name, int mask)
 	 * The trusted.* namespace can only be accessed by privileged users.
 	 */
 	if (!strncmp(name, XATTR_TRUSTED_PREFIX, XATTR_TRUSTED_PREFIX_LEN)) {
-		if (!capable(CAP_SYS_ADMIN))
+		if (!capable(CAP_SYS_ADMIN) && !capable(CAP_TRUSTED))
 			return (mask & MAY_WRITE) ? -EPERM : -ENODATA;
 		return 0;
 	}
@@ -945,7 +945,7 @@ static int xattr_list_one(char **buffer, ssize_t *remaining_size,
 ssize_t simple_xattr_list(struct inode *inode, struct simple_xattrs *xattrs,
 			  char *buffer, size_t size)
 {
-	bool trusted = capable(CAP_SYS_ADMIN);
+	bool trusted = capable(CAP_SYS_ADMIN) || capable(CAP_TRUSTED);
 	struct simple_xattr *xattr;
 	ssize_t remaining_size = size;
 	int err = 0;
-- 
2.14.2
