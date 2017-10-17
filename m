From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 05/14] ovl: encode/decode pure-upper non-connectable file handles
Date: Tue, 17 Oct 2017 19:44:22 +0300
Message-ID: <1508258671-10800-6-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:53043 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S937029AbdJQQoF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:44:05 -0400
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Implement basic exportfs operations for pure upper files as
the ground floor of full exportfs support.

In this basic implementation, encoding an overlay file handle is
implemented by asking the underlying fs to encode the real upper inode.
Decoding is done by getting the upper dentry from underlying upper fs
and finding/creating an overlay inode in cache that is hashed by the
real upper inode.

This simplied case of exporting pure upper non-connectable file handles
is sufficient to pass xfstest generic/426 which creates files, encodes
file handles, drops caches and decodes the file handles.

Following patches will implement exportfs support for less trivial
cases.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Makefile    |   3 +-
 fs/overlayfs/export.c    | 140 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c     |  13 ++---
 fs/overlayfs/namei.c     |   2 +-
 fs/overlayfs/overlayfs.h |   7 ++-
 5 files changed, 154 insertions(+), 11 deletions(-)
 create mode 100644 fs/overlayfs/export.c

diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
index 99373bbc1478..30802347a020 100644
--- a/fs/overlayfs/Makefile
+++ b/fs/overlayfs/Makefile
@@ -4,4 +4,5 @@
 
 obj-$(CONFIG_OVERLAY_FS) += overlay.o
 
-overlay-objs := super.o namei.o util.o inode.o dir.o readdir.o copy_up.o
+overlay-objs := super.o namei.o util.o inode.o dir.o readdir.o copy_up.o \
+		export.o
diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
new file mode 100644
index 000000000000..33914f23530e
--- /dev/null
+++ b/fs/overlayfs/export.c
@@ -0,0 +1,140 @@
+/*
+ * Overlayfs NFS export support.
+ *
+ * Amir Goldstein <amir73il@gmail.com>
+ *
+ * Copyright (C) 2017 CTERA Networks. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/fs.h>
+#include <linux/mount.h>
+#include <linux/xattr.h>
+#include <linux/exportfs.h>
+#include "overlayfs.h"
+#include "ovl_entry.h"
+
+/* TODO: add export_operations method dentry_to_fh() ??? */
+static int ovl_dentry_to_fh(struct dentry *dentry, struct fid *fid,
+			    int *max_len, int connectable)
+{
+	struct dentry *lower = ovl_dentry_lower(dentry);
+	int type;
+
+	/* TODO: handle encoding of non pure upper */
+	if (lower)
+		return FILEID_INVALID;
+
+	/*
+	 * Ask real fs to encode the inode of the real upper dentry.
+	 * When decoding we ask real fs for the upper dentry and use
+	 * the real inode to get the overlay inode.
+	 */
+	type = exportfs_encode_fh(ovl_dentry_upper(dentry), fid, max_len,
+				  connectable);
+
+	/* TODO: encode an ovl_fh struct and return OVL file handle type */
+	return type;
+}
+
+static int ovl_encode_inode_fh(struct inode *inode, u32 *fh, int *max_len,
+			       struct inode *parent)
+{
+	struct dentry *dentry = d_find_alias(inode);
+	int type;
+
+	if (!dentry)
+		return FILEID_INVALID;
+
+	/* TODO: handle encoding of non-dir connectable file handle */
+	if (parent)
+		return FILEID_INVALID;
+
+	type = ovl_dentry_to_fh(dentry, (struct fid *)fh, max_len, 0);
+
+	dput(dentry);
+	return type;
+}
+
+/*
+ * Find or instantiate an overlay dentry from real dentries.
+ * Like d_obtain_alias(inode), ovl_obtain_alias() either
+ * takes ownership on the upper dentry reference or puts it
+ * before returning an error.
+ */
+static struct dentry *ovl_obtain_alias(struct super_block *sb,
+				       struct dentry *upper,
+				       struct dentry *lower)
+{
+	struct inode *inode;
+	struct dentry *dentry;
+	struct ovl_entry *oe;
+
+	/* TODO: handle decoding of non pure upper */
+	if (lower) {
+		dput(upper);
+		return ERR_PTR(-EINVAL);
+	}
+
+	inode = ovl_get_inode(sb, upper, NULL, NULL);
+	if (IS_ERR(inode)) {
+		dput(upper);
+		return ERR_CAST(inode);
+	}
+
+	dentry = d_obtain_alias(inode);
+	if (IS_ERR(dentry))
+		return dentry;
+
+	if (dentry->d_fsdata) {
+		if (WARN_ON(ovl_dentry_lower(dentry) ||
+			    ovl_dentry_upper(dentry)->d_inode !=
+			    upper->d_inode)) {
+			dput(dentry);
+			return ERR_PTR(-ESTALE);
+		}
+		return dentry;
+	}
+
+	oe = ovl_alloc_entry(0);
+	if (!oe) {
+		dput(dentry);
+		return ERR_PTR(-ENOMEM);
+	}
+
+	dentry->d_fsdata = oe;
+	ovl_dentry_set_upper_alias(dentry);
+
+	return dentry;
+
+}
+
+static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct vfsmount *mnt = ofs->upper_mnt;
+	const struct export_operations *real_op;
+	struct dentry *upper;
+
+	/* TODO: handle decoding of non pure upper */
+	if (!mnt)
+		return NULL;
+
+	real_op = mnt->mnt_sb->s_export_op;
+	/* TODO: decode ovl_fh format file handle */
+	upper = real_op->fh_to_dentry(mnt->mnt_sb, fid, fh_len, fh_type);
+	if (IS_ERR_OR_NULL(upper))
+		return upper;
+
+	/* Find or instantiate a pure upper dentry */
+	return ovl_obtain_alias(sb, upper, NULL);
+}
+
+const struct export_operations ovl_export_operations = {
+	.encode_fh      = ovl_encode_inode_fh,
+	.fh_to_dentry	= ovl_fh_to_dentry,
+};
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5959293f8e70..a623c0b60583 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -602,14 +602,13 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
 	return true;
 }
 
-struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
-			    struct dentry *index)
+struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
+			    struct dentry *lowerdentry, struct dentry *index)
 {
-	struct dentry *lowerdentry = ovl_dentry_lower(dentry);
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	/* Already indexed or could be indexed on copy up? */
-	bool indexed = (index || (ovl_indexdir(dentry->d_sb) && !upperdentry));
+	bool indexed = (index || (ovl_indexdir(sb) && !upperdentry));
 
 	if (WARN_ON(upperdentry && indexed && !lowerdentry))
 		return ERR_PTR(-EIO);
@@ -624,13 +623,13 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
 	 * non-indexed upper inodes that could be hard linked by upper inode.
 	 * Hash all inodes for NFS export.
 	 */
-	if (dentry->d_sb->s_export_op ||
+	if (sb->s_export_op ||
 	    (!S_ISDIR(realinode->i_mode) && (upperdentry || indexed))) {
 		struct inode *key = d_inode(indexed ? lowerdentry :
 						      upperdentry);
 		unsigned int nlink;
 
-		inode = iget5_locked(dentry->d_sb, (unsigned long) key,
+		inode = iget5_locked(sb, (unsigned long) key,
 				     ovl_inode_test, ovl_inode_set, key);
 		if (!inode)
 			goto out_nomem;
@@ -653,7 +652,7 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
 				      realinode->i_nlink);
 		set_nlink(inode, nlink);
 	} else {
-		inode = new_inode(dentry->d_sb);
+		inode = new_inode(sb);
 		if (!inode)
 			goto out_nomem;
 	}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 0619a789809e..ce3d4930a721 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -881,7 +881,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
-		inode = ovl_get_inode(dentry, upperdentry, index);
+		inode = ovl_get_inode(dentry->d_sb, upperdentry, origin, index);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 18ea89deb040..8ad3110a9b48 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -304,8 +304,8 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
-struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
-			    struct dentry *index);
+struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
+			    struct dentry *lowerdentry, struct dentry *index);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
@@ -337,3 +337,6 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
+
+/* export.c */
+extern const struct export_operations ovl_export_operations;
-- 
2.7.4
