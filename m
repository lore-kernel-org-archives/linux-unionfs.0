Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10186 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731961AbeGaLEn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jul 2018 07:04:43 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 50A515FF48D25
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Jul 2018 17:25:13 +0800 (CST)
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH v2 3/9] ovl: check file system features can be mounted properly
Date: Tue, 31 Jul 2018 17:37:21 +0800
Message-ID: <20180731093727.26855-4-yi.zhang@huawei.com>
In-Reply-To: <20180731093727.26855-1-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Mount operation should fail if unknown incompatible feature is
detected on any one of the underlying layers, and read-write mount
operation should fail if unknown read-only compatible feature is
detected on the upper layer.

This patch doesn't add any features, so if any feature xattrs is
detected on the underlying root dir, it will be recognized as
unknown feature.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/overlayfs/feature.c   | 65 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h | 29 +++++++++++++++++++++
 fs/overlayfs/super.c     |  8 +++++-
 3 files changed, 101 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/feature.c b/fs/overlayfs/feature.c
index eed6644a2a31..fac4d7544475 100644
--- a/fs/overlayfs/feature.c
+++ b/fs/overlayfs/feature.c
@@ -117,3 +117,68 @@ int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe)
 
 	return 0;
 }
+
+/*
+ * Check whether this overlay layer can be mounted based on
+ * the features present and the read-only/read-write mount requested.
+ * Returns true if this layer can be mounted as requested,
+ * false if it cannot be.
+ */
+static bool ovl_check_layer_feature(struct ovl_layer *layer, bool readonly)
+{
+	if (ovl_has_unknown_incompat_features(layer)) {
+		pr_err("overlayfs: unknown optional incompat features "
+		       "(0x%llx) enabled on layer %d\n",
+		       layer->incompat & OVL_FEATURE_INCOMPAT_UNKNOWN,
+		       layer->idx);
+		pr_err("overlayfs: filesystem cannot not be safely mounted "
+		       "by this kernel\n");
+		return false;
+	}
+
+	if (ovl_has_unknown_ro_compat_features(layer)) {
+		pr_err("overlayfs: unknown optional ro_compat features "
+		       "(0x%llx) enabled on layer %d\n",
+		       layer->ro_compat & OVL_FEATURE_RO_COMPAT_UNKNOWN,
+		       layer->idx);
+
+		if (readonly)
+			return true;
+
+		pr_err("overlayfs: filesystem cannot not be safely mounted "
+		       "read-write by this kernel\n");
+		return false;
+	}
+
+	if (ovl_has_unknown_compat_features(layer)) {
+		pr_warn("overlayfs: unknown optional compat features "
+		        "(0x%llx) enabled on layer %d\n",
+			layer->compat & OVL_FEATURE_COMPAT_UNKNOWN,
+			layer->idx);
+	}
+
+	return true;
+}
+
+/*
+ * Check all layers of overlay filesystem to make sure whether this
+ * filesystem can be mounted. Returns true if all layers can be
+ * mounted as requested, false if any one of them cannot be.
+ */
+bool ovl_check_feature_ok(struct ovl_fs *ofs, bool readonly)
+{
+	int i;
+
+	if (ofs->upper_layer) {
+		if (!ovl_check_layer_feature(ofs->upper_layer, readonly))
+			return false;
+	}
+
+	for (i = 0; i < ofs->numlower; i++) {
+		/* Lower layer is always read-only */
+		if (!ovl_check_layer_feature(&ofs->lower_layers[i], true))
+			return false;
+	}
+
+	return true;
+}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 745f3b89a99e..f1bf21d030ac 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -55,6 +55,34 @@ struct ovl_d_feature {
 	__be64 incompat;	/* incompatible features */
 } __packed;
 
+
+#define OVL_FEATURE_COMPAT_SUPP 		(0)
+#define OVL_FEATURE_COMPAT_UNKNOWN		(~OVL_FEATURE_COMPAT_SUPP)
+
+#define OVL_FEATURE_RO_COMPAT_SUPP		(0)
+#define OVL_FEATURE_RO_COMPAT_UNKNOWN		(~OVL_FEATURE_RO_COMPAT_SUPP)
+
+#define OVL_FEATURE_INCOMPAT_SUPP		(0)
+#define OVL_FEATURE_INCOMPAT_UNKNOWN		(~OVL_FEATURE_INCOMPAT_SUPP)
+
+static inline bool ovl_has_unknown_compat_features(struct ovl_layer *layer)
+{
+	return ((layer->feature) && \
+		((layer->compat & OVL_FEATURE_COMPAT_UNKNOWN) != 0));
+}
+
+static inline bool ovl_has_unknown_ro_compat_features(struct ovl_layer *layer)
+{
+	return ((layer->feature) && \
+		((layer->ro_compat & OVL_FEATURE_RO_COMPAT_UNKNOWN) != 0));
+}
+
+static inline bool ovl_has_unknown_incompat_features(struct ovl_layer *layer)
+{
+	return ((layer->feature) && \
+		((layer->incompat & OVL_FEATURE_INCOMPAT_UNKNOWN) != 0));
+}
+
 /*
  * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
  * where:
@@ -394,3 +422,4 @@ extern const struct export_operations ovl_export_operations;
 
 /* feature.c */
 int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe);
+bool ovl_check_feature_ok(struct ovl_fs *ofs, bool readonly);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 59b7d4f07b03..f8e516656104 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -385,7 +385,8 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
 
-	if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
+	if (!(*flags & SB_RDONLY) &&
+	    (ovl_force_readonly(ofs) || !ovl_check_feature_ok(ofs, false)))
 		return -EROFS;
 
 	return 0;
@@ -1450,6 +1451,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	}
 
+	/* Check the features could be mounted properly by this kernel */
+	err = -EINVAL;
+	if (!ovl_check_feature_ok(ofs, (sb_rdonly(sb))))
+		goto out_free_oe;
+
 	/* Show index=off in /proc/mounts for forced r/o mount */
 	if (!ofs->indexdir) {
 		ofs->config.index = false;
-- 
2.13.6

