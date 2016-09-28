From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v5 03/17] hfs: Switch to generic xattr handlers
Date: Wed, 28 Sep 2016 16:57:49 +0200
Message-ID: <1475074683-26971-4-git-send-email-agruenba@redhat.com>
References: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/hfs/attr.c   | 83 +++++++++++++++++++++++++++++++++++++++------------------
 fs/hfs/hfs_fs.h |  6 +----
 fs/hfs/inode.c  |  7 ++---
 fs/hfs/super.c  |  1 +
 4 files changed, 63 insertions(+), 34 deletions(-)

diff --git a/fs/hfs/attr.c b/fs/hfs/attr.c
index d9a8691..0933600 100644
--- a/fs/hfs/attr.c
+++ b/fs/hfs/attr.c
@@ -13,9 +13,13 @@
 #include "hfs_fs.h"
 #include "btree.h"
 
-int hfs_setxattr(struct dentry *unused, struct inode *inode,
-		 const char *name, const void *value,
-		 size_t size, int flags)
+enum hfs_xattr_type {
+	HFS_TYPE,
+	HFS_CREATOR,
+};
+
+static int __hfs_setxattr(struct inode *inode, enum hfs_xattr_type type,
+			  const void *value, size_t size, int flags)
 {
 	struct hfs_find_data fd;
 	hfs_cat_rec rec;
@@ -36,18 +40,22 @@ int hfs_setxattr(struct dentry *unused, struct inode *inode,
 			sizeof(struct hfs_cat_file));
 	file = &rec.file;
 
-	if (!strcmp(name, "hfs.type")) {
+	switch (type) {
+	case HFS_TYPE:
 		if (size == 4)
 			memcpy(&file->UsrWds.fdType, value, 4);
 		else
 			res = -ERANGE;
-	} else if (!strcmp(name, "hfs.creator")) {
+		break;
+
+	case HFS_CREATOR:
 		if (size == 4)
 			memcpy(&file->UsrWds.fdCreator, value, 4);
 		else
 			res = -ERANGE;
-	} else
-		res = -EOPNOTSUPP;
+		break;
+	}
+
 	if (!res)
 		hfs_bnode_write(fd.bnode, &rec, fd.entryoffset,
 				sizeof(struct hfs_cat_file));
@@ -56,8 +64,8 @@ out:
 	return res;
 }
 
-ssize_t hfs_getxattr(struct dentry *unused, struct inode *inode,
-		     const char *name, void *value, size_t size)
+static ssize_t __hfs_getxattr(struct inode *inode, enum hfs_xattr_type type,
+			      void *value, size_t size)
 {
 	struct hfs_find_data fd;
 	hfs_cat_rec rec;
@@ -80,41 +88,64 @@ ssize_t hfs_getxattr(struct dentry *unused, struct inode *inode,
 	}
 	file = &rec.file;
 
-	if (!strcmp(name, "hfs.type")) {
+	switch (type) {
+	case HFS_TYPE:
 		if (size >= 4) {
 			memcpy(value, &file->UsrWds.fdType, 4);
 			res = 4;
 		} else
 			res = size ? -ERANGE : 4;
-	} else if (!strcmp(name, "hfs.creator")) {
+		break;
+
+	case HFS_CREATOR:
 		if (size >= 4) {
 			memcpy(value, &file->UsrWds.fdCreator, 4);
 			res = 4;
 		} else
 			res = size ? -ERANGE : 4;
-	} else
-		res = -ENODATA;
+		break;
+	}
+
 out:
 	if (size)
 		hfs_find_exit(&fd);
 	return res;
 }
 
-#define HFS_ATTRLIST_SIZE (sizeof("hfs.creator")+sizeof("hfs.type"))
-
-ssize_t hfs_listxattr(struct dentry *dentry, char *buffer, size_t size)
+static int hfs_xattr_get(const struct xattr_handler *handler,
+			 struct dentry *unused, struct inode *inode,
+			 const char *name, void *value, size_t size)
 {
-	struct inode *inode = d_inode(dentry);
+	return __hfs_getxattr(inode, handler->flags, value, size);
+}
 
-	if (!S_ISREG(inode->i_mode) || HFS_IS_RSRC(inode))
+static int hfs_xattr_set(const struct xattr_handler *handler,
+			 struct dentry *unused, struct inode *inode,
+			 const char *name, const void *value, size_t size,
+			 int flags)
+{
+	if (!value)
 		return -EOPNOTSUPP;
 
-	if (!buffer || !size)
-		return HFS_ATTRLIST_SIZE;
-	if (size < HFS_ATTRLIST_SIZE)
-		return -ERANGE;
-	strcpy(buffer, "hfs.type");
-	strcpy(buffer + sizeof("hfs.type"), "hfs.creator");
-
-	return HFS_ATTRLIST_SIZE;
+	return __hfs_setxattr(inode, handler->flags, value, size, flags);
 }
+
+static const struct xattr_handler hfs_creator_handler = {
+	.name = "hfs.creator",
+	.flags = HFS_CREATOR,
+	.get = hfs_xattr_get,
+	.set = hfs_xattr_set,
+};
+
+static const struct xattr_handler hfs_type_handler = {
+	.name = "hfs.type",
+	.flags = HFS_TYPE,
+	.get = hfs_xattr_get,
+	.set = hfs_xattr_set,
+};
+
+const struct xattr_handler *hfs_xattr_handlers[] = {
+	&hfs_creator_handler,
+	&hfs_type_handler,
+	NULL
+};
diff --git a/fs/hfs/hfs_fs.h b/fs/hfs/hfs_fs.h
index 16f5172..4cdec5a 100644
--- a/fs/hfs/hfs_fs.h
+++ b/fs/hfs/hfs_fs.h
@@ -212,11 +212,7 @@ extern void hfs_evict_inode(struct inode *);
 extern void hfs_delete_inode(struct inode *);
 
 /* attr.c */
-extern int hfs_setxattr(struct dentry *dentry, struct inode *inode, const char *name,
-			const void *value, size_t size, int flags);
-extern ssize_t hfs_getxattr(struct dentry *dentry, struct inode *inode,
-			    const char *name, void *value, size_t size);
-extern ssize_t hfs_listxattr(struct dentry *dentry, char *buffer, size_t size);
+extern const struct xattr_handler *hfs_xattr_handlers[];
 
 /* mdb.c */
 extern int hfs_mdb_get(struct super_block *);
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index c6a3241..7f44f1a 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -15,6 +15,7 @@
 #include <linux/mpage.h>
 #include <linux/sched.h>
 #include <linux/uio.h>
+#include <linux/xattr.h>
 
 #include "hfs_fs.h"
 #include "btree.h"
@@ -687,7 +688,7 @@ static const struct file_operations hfs_file_operations = {
 static const struct inode_operations hfs_file_inode_operations = {
 	.lookup		= hfs_file_lookup,
 	.setattr	= hfs_inode_setattr,
-	.setxattr	= hfs_setxattr,
-	.getxattr	= hfs_getxattr,
-	.listxattr	= hfs_listxattr,
+	.setxattr	= generic_setxattr,
+	.getxattr	= generic_getxattr,
+	.listxattr	= generic_listxattr,
 };
diff --git a/fs/hfs/super.c b/fs/hfs/super.c
index 1ca95c2..bf6304a 100644
--- a/fs/hfs/super.c
+++ b/fs/hfs/super.c
@@ -406,6 +406,7 @@ static int hfs_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	sb->s_op = &hfs_super_operations;
+	sb->s_xattr = hfs_xattr_handlers;
 	sb->s_flags |= MS_NODIRATIME;
 	mutex_init(&sbi->bitmap_lock);
 
-- 
2.7.4
