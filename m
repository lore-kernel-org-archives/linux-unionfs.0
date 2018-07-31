Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH v2 2/9] ovl: read feature set from each layer's root dir
Date: Tue, 31 Jul 2018 17:37:20 +0800
Message-ID: <20180731093727.26855-3-yi.zhang@huawei.com>
In-Reply-To: <20180731093727.26855-1-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

In order to distinguish the backward compatible and backward
incompatible features in overlay filesystem, we introduce compatible,
read-only compatible and incompatible these three kinds of features,
store them as __be64 bit mask on each layer's root directory via
"trusted.overlay.feature" xattr, which contains the features of this
layer.

This patch just read feature bitsets from each layer, doesn't add any
already known features and doesn't yet use the feature bitsets.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
Suggested-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Makefile    |   2 +-
 fs/overlayfs/feature.c   | 119 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  15 ++++++
 fs/overlayfs/ovl_entry.h |   5 ++
 fs/overlayfs/super.c     |   5 ++
 5 files changed, 145 insertions(+), 1 deletion(-)
 create mode 100644 fs/overlayfs/feature.c

diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
index 30802347a020..219c927069d2 100644
--- a/fs/overlayfs/Makefile
+++ b/fs/overlayfs/Makefile
@@ -5,4 +5,4 @@
 obj-$(CONFIG_OVERLAY_FS) += overlay.o
 
 overlay-objs := super.o namei.o util.o inode.o dir.o readdir.o copy_up.o \
-		export.o
+		export.o feature.o
diff --git a/fs/overlayfs/feature.c b/fs/overlayfs/feature.c
new file mode 100644
index 000000000000..eed6644a2a31
--- /dev/null
+++ b/fs/overlayfs/feature.c
@@ -0,0 +1,119 @@
+/*
+ * Overlayfs feature sets support.
+ *
+ * Copyright (C) 2018 Huawei. All Rights Reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License version 2 as published by
+ * the Free Software Foundation.
+ */
+
+#include <linux/fs.h>
+#include <linux/xattr.h>
+#include "overlayfs.h"
+
+/*
+ * Get overlay features from the layer's root dir.
+ *
+ * @realroot: real root dir dentry
+ *
+ * Return on-disk overlay feature struct if success, NULL if no feature
+ * and error ptr if error.
+ */
+static struct ovl_d_feature *ovl_get_feature(struct dentry *realroot)
+{
+	struct ovl_d_feature *odf = NULL;
+	int res;
+
+	res = vfs_getxattr(realroot, OVL_XATTR_FEATURE, NULL, 0);
+	if (res <= 0) {
+		if (res == -EOPNOTSUPP || res == -ENODATA)
+			return NULL;
+		goto fail;
+	}
+
+	odf = kzalloc(res, GFP_KERNEL);
+	if (!odf)
+		return ERR_PTR(-ENOMEM);
+
+	res = vfs_getxattr(realroot, OVL_XATTR_FEATURE, odf, res);
+	if (res < 0)
+		goto fail;
+
+	/* Check validity */
+	if (res < sizeof(struct ovl_d_feature)) {
+		res = -EINVAL;
+		goto invalid;
+	}
+	if (odf->magic != OVL_FEATURE_MAGIC) {
+		res = -EINVAL;
+		goto invalid;
+	}
+
+	return odf;
+out:
+	kfree(odf);
+	return ERR_PTR(res);
+fail:
+	pr_err("overlayfs: failed to get features (%i)\n", res);
+	goto out;
+invalid:
+	pr_err("overlayfs: invalid features (%*phN)\n", res, odf);
+	goto out;
+}
+
+/*
+ * Get features from each underlying root dir.
+ *
+ * @ofs: overlay filesystem information
+ * @oe: overlay lower stack
+ *
+ * Return 0 if success, errno otherwise.
+ */
+int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe)
+{
+	struct ovl_layer *upper_layer = ofs->upper_layer;
+	struct dentry *upper = ofs->upperdir;
+	struct ovl_d_feature *odf;
+	int i;
+
+	/* Get features from the upper root dir */
+	if (upper_layer) {
+		odf = ovl_get_feature(upper);
+		if (IS_ERR(odf))
+			return PTR_ERR(odf);
+
+		if (odf) {
+			upper_layer->compat = be64_to_cpu(odf->compat);
+			upper_layer->ro_compat = be64_to_cpu(odf->ro_compat);
+			upper_layer->incompat = be64_to_cpu(odf->incompat);
+			upper_layer->feature = true;
+			kfree(odf);
+		} else {
+			upper_layer->feature = false;
+		}
+	}
+
+	/* Get features from each lower's root dir */
+	for (i = 0; i < oe->numlower; i++) {
+		struct ovl_path *lowerpath = &oe->lowerstack[i];
+		struct ovl_layer *lower_layer = &ofs->lower_layers[i];
+
+		odf = ovl_get_feature(lowerpath->dentry);
+		if (IS_ERR(odf))
+			return PTR_ERR(odf);
+
+		if (!odf) {
+			lower_layer->feature = false;
+			continue;
+		}
+
+		lower_layer->compat = be64_to_cpu(odf->compat);
+		lower_layer->ro_compat = be64_to_cpu(odf->ro_compat);
+		lower_layer->incompat = be64_to_cpu(odf->incompat);
+		lower_layer->feature = true;
+		kfree(odf);
+	}
+
+	return 0;
+}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7538b9b56237..745f3b89a99e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -28,6 +28,7 @@ enum ovl_path_type {
 #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
 #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
 #define OVL_XATTR_UPPER OVL_XATTR_PREFIX "upper"
+#define OVL_XATTR_FEATURE OVL_XATTR_PREFIX "feature"
 
 enum ovl_inode_flag {
 	/* Pure upper dir that may contain non pure upper entries */
@@ -43,6 +44,17 @@ enum ovl_entry_flag {
 	OVL_E_CONNECTED,
 };
 
+/* Features */
+#define OVL_FEATURE_MAGIC 0xfe
+
+/* On-disk format of overlay layer features */
+struct ovl_d_feature {
+	u8 magic;		/* 0xfe */
+	__be64 compat;		/* compatible features */
+	__be64 ro_compat;	/* read-only compatible features */
+	__be64 incompat;	/* incompatible features */
+} __packed;
+
 /*
  * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
  * where:
@@ -379,3 +391,6 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 
 /* export.c */
 extern const struct export_operations ovl_export_operations;
+
+/* feature.c */
+int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 38ff6689a293..b1b6627f3350 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -34,6 +34,11 @@ struct ovl_layer {
 	int idx;
 	/* One fsid per unique underlying sb (upper fsid == 0) */
 	int fsid;
+	/* Features of this layer */
+	u64 compat;
+	u64 ro_compat;
+	u64 incompat;
+	bool feature;
 };
 
 struct ovl_path {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index cce4f58458dc..59b7d4f07b03 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1427,6 +1427,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (IS_ERR(oe))
 		goto out_err;
 
+	/* Get features from each underlying layer's root dir */
+	err = ovl_init_feature_set(ofs, oe);
+	if (err)
+		goto out_free_oe;
+
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
 	if (!ofs->upper_layer)
 		sb->s_flags |= SB_RDONLY;
-- 
2.13.6
