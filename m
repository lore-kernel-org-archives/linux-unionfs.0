From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 02/17] ovl: encode pure upper file handles
Date: Thu,  4 Jan 2018 19:20:34 +0200
Message-ID: <1515086449-26563-3-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Encode overlay file handles as struct ovl_fh containing the file handle
encoding of the real upper inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Makefile    |  3 +-
 fs/overlayfs/export.c    | 98 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  6 +++
 3 files changed, 106 insertions(+), 1 deletion(-)
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
index 000000000000..58c4f5e8a67e
--- /dev/null
+++ b/fs/overlayfs/export.c
@@ -0,0 +1,98 @@
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
+#include <linux/cred.h>
+#include <linux/mount.h>
+#include <linux/namei.h>
+#include <linux/xattr.h>
+#include <linux/exportfs.h>
+#include <linux/ratelimit.h>
+#include "overlayfs.h"
+
+int ovl_d_to_fh(struct dentry *dentry, char *buf, int buflen)
+{
+	struct dentry *upper = ovl_dentry_upper(dentry);
+	struct dentry *origin = ovl_dentry_lower(dentry);
+	struct ovl_fh *fh = NULL;
+	int err;
+
+	/*
+	 * Overlay root dir inode is encoded as an upper file handle upper,
+	 * because root dir dentry is born upper and not indexed.
+	 */
+	if (dentry == dentry->d_sb->s_root)
+		origin = NULL;
+
+	err = -EACCES;
+	if (!upper || origin)
+		goto fail;
+
+	/* TODO: encode non pure-upper by origin */
+	fh = ovl_encode_fh(upper, true);
+
+	err = -EOVERFLOW;
+	if (fh->len > buflen)
+		goto fail;
+
+	memcpy(buf, (char *)fh, fh->len);
+	err = fh->len;
+
+out:
+	kfree(fh);
+	return err;
+
+fail:
+	pr_warn_ratelimited("overlayfs: failed to encode file handle (%pd2, err=%i, buflen=%d, len=%d, type=%d)\n",
+			    dentry, err, buflen, fh ? (int)fh->len : 0,
+			    fh ? fh->type : 0);
+	goto out;
+}
+
+static int ovl_dentry_to_fh(struct dentry *dentry, u32 *fid, int *max_len)
+{
+	int res, len = *max_len << 2;
+
+	res = ovl_d_to_fh(dentry, (char *)fid, len);
+	if (res <= 0)
+		return FILEID_INVALID;
+
+	len = res;
+
+	/* Round up to dwords */
+	*max_len = (len + 3) >> 2;
+	return OVL_FILEID;
+}
+
+static int ovl_encode_inode_fh(struct inode *inode, u32 *fid, int *max_len,
+			       struct inode *parent)
+{
+	struct dentry *dentry;
+	int type;
+
+	/* TODO: encode connectable file handles */
+	if (parent)
+		return FILEID_INVALID;
+
+	dentry = d_find_any_alias(inode);
+	if (WARN_ON(!dentry))
+		return FILEID_INVALID;
+
+	type = ovl_dentry_to_fh(dentry, fid, max_len);
+
+	dput(dentry);
+	return type;
+}
+
+const struct export_operations ovl_export_operations = {
+	.encode_fh      = ovl_encode_inode_fh,
+};
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f4b064023826..f6fd999cb98e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -65,6 +65,9 @@ enum ovl_flag {
 #error Endianness not defined
 #endif
 
+/* The type returned by overlay exportfs ops when encoding an ovl_fh handle */
+#define OVL_FILEID	0xfb
+
 /* On-disk and in-memeory format for redirect by file handle */
 struct ovl_fh {
 	u8 version;	/* 0 */
@@ -333,3 +336,6 @@ int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_fh(struct dentry *origin, bool is_upper);
 int ovl_set_origin(struct dentry *dentry, struct dentry *origin,
 		   struct dentry *upper, bool is_upper);
+
+/* export.c */
+extern const struct export_operations ovl_export_operations;
-- 
2.7.4
