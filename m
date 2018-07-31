Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10188 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731722AbeGaLEl (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jul 2018 07:04:41 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 582135F934B96
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Jul 2018 17:25:13 +0800 (CST)
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH v2 4/9] ovl: add helper funcs to set upper layer feature set
Date: Tue, 31 Jul 2018 17:37:22 +0800
Message-ID: <20180731093727.26855-5-yi.zhang@huawei.com>
In-Reply-To: <20180731093727.26855-1-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

overlayfs will want to add the upper layer's feature bitset if some
overlay file system features were set. For example: redirect dir feature
will be set when user rename a lower/merge dir if redirect dir feature
is enabled. So add helper functions to set feature sets to the upper
layer for future use.

This patch introduce helper functions only, does not set any feature
bits.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/overlayfs/feature.c   | 85 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h | 46 ++++++++++++++++++++++++++
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     |  1 +
 4 files changed, 134 insertions(+)

diff --git a/fs/overlayfs/feature.c b/fs/overlayfs/feature.c
index fac4d7544475..7c66e71bdd98 100644
--- a/fs/overlayfs/feature.c
+++ b/fs/overlayfs/feature.c
@@ -10,6 +10,8 @@
 
 #include <linux/fs.h>
 #include <linux/xattr.h>
+#include <linux/mount.h>
+#include <linux/ratelimit.h>
 #include "overlayfs.h"
 
 /*
@@ -63,6 +65,89 @@ static struct ovl_d_feature *ovl_get_feature(struct dentry *realroot)
 }
 
 /*
+ * Set overlay features to the upper root dir.
+ *
+ * @upper_layer: overlay upper layer information,
+ * @upper: upper root dentry.
+ *
+ * Return 0 if success, error number otherwise.
+ */
+static int ovl_set_feature(struct ovl_layer *upper_layer,
+			   struct dentry *upper)
+{
+	struct vfsmount *upper_mnt = upper_layer->mnt;
+	struct ovl_d_feature odf = {};
+	int err;
+
+	odf.magic = OVL_FEATURE_MAGIC;
+	odf.compat = cpu_to_be64(upper_layer->compat);
+	odf.ro_compat = cpu_to_be64(upper_layer->ro_compat);
+	odf.incompat = cpu_to_be64(upper_layer->incompat);
+
+	err = mnt_want_write(upper_mnt);
+	if (err)
+		return err;
+
+	err = ovl_do_setxattr(upper, OVL_XATTR_FEATURE,
+			      &odf, sizeof(odf), 0);
+	if (err)
+		pr_err_ratelimited("overlayfs: failed to set features (%i)\n", err);
+
+	mnt_drop_write(upper_mnt);
+	return err;
+}
+
+/*
+ * Add feature bit mask to the upper root dir.
+ *
+ * @ofs: overlay filesystem information
+ * @type: feature set type, compat, ro compat or incompat
+ * @mask: new features mask want to add
+ *
+ * Return 0 if success, error number otherwise.
+ */
+int ovl_set_upper_feature(struct ovl_fs *ofs,
+			  enum ovl_feature_type type,
+			  u64 mask)
+{
+	struct ovl_layer *upper_layer = ofs->upper_layer;
+	u64 *features;
+	int err;
+
+	if (!upper_layer)
+		return -EINVAL;
+
+	switch (type) {
+	case OVL_FEATURE_COMPAT:
+		features = &upper_layer->compat;
+		break;
+	case OVL_FEATURE_RO_COMPAT:
+		features = &upper_layer->ro_compat;
+		break;
+	case OVL_FEATURE_INCOMPAT:
+		features = &upper_layer->incompat;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	spin_lock(&upper_layer->lock);
+	if ((*features) & mask) {
+		spin_unlock(&upper_layer->lock);
+		return 0;
+	}
+
+	(*features) |= mask;
+	spin_unlock(&upper_layer->lock);
+
+	err = ovl_set_feature(upper_layer, ofs->upperdir);
+	if (err)
+		return err;
+
+	return 0;
+}
+
+/*
  * Get features from each underlying root dir.
  *
  * @ofs: overlay filesystem information
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f1bf21d030ac..d6231acc660a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -83,6 +83,52 @@ static inline bool ovl_has_unknown_incompat_features(struct ovl_layer *layer)
 		((layer->incompat & OVL_FEATURE_INCOMPAT_UNKNOWN) != 0));
 }
 
+enum ovl_feature_type {
+	OVL_FEATURE_COMPAT,
+	OVL_FEATURE_RO_COMPAT,
+	OVL_FEATURE_INCOMPAT
+};
+
+int ovl_set_upper_feature(struct ovl_fs *ofs,
+			  enum ovl_feature_type type,
+			  u64 mask);
+
+#define OVL_FEATURE_COMPAT_FUNCS(name, flagname) \
+static inline bool ovl_has_feature_##name(struct ovl_layer *layer) \
+{ \
+	return ((layer->feature) && \
+		((layer->compat & OVL_FEATURE_COMPAT_##flagname) != 0); \
+} \
+static inline int ovl_set_feature_##name(struct ovl_fs *ofs) \
+{ \
+	return ovl_set_upper_feature(ofs, OVL_FEATURE_COMPAT, \
+			OVL_FEATURE_COMPAT_##flagname); \
+} \
+
+#define OVL_FEATURE_RO_COMPAT_FUNCS(name, flagname) \
+static inline bool ovl_has_feature_##name(struct ovl_layer *layer) \
+{ \
+	return ((layer->feature) && \
+		(layer->ro_compat & OVL_FEATURE_RO_COMPAT_##flagname) != 0); \
+} \
+static inline int ovl_set_feature_##name(struct ovl_fs *ofs) \
+{ \
+	return ovl_set_upper_feature(ofs, OVL_FEATURE_RO_COMPAT, \
+			OVL_FEATURE_RO_COMPAT_##flagname); \
+} \
+
+#define OVL_FEATURE_INCOMPAT_FUNCS(name, flagname) \
+static inline bool ovl_has_feature_##name(struct ovl_layer *layer) \
+{ \
+	return ((layer->feature) && \
+		(layer->incompat & OVL_FEATURE_INCOMPAT_##flagname) != 0); \
+} \
+static inline int ovl_set_feature_##name(struct ovl_fs *ofs) \
+{ \
+	return ovl_set_upper_feature(ofs, OVL_FEATURE_INCOMPAT, \
+			OVL_FEATURE_INCOMPAT_##flagname); \
+} \
+
 /*
  * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
  * where:
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b1b6627f3350..8a28e24dd149 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -39,6 +39,8 @@ struct ovl_layer {
 	u64 ro_compat;
 	u64 incompat;
 	bool feature;
+	/* Protect features when updating (upper use only) */
+	spinlock_t lock;
 };
 
 struct ovl_path {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f8e516656104..a5bbbddf741c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -998,6 +998,7 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
 	if (ofs->upper_layer == NULL)
 		goto out;
 
+	spin_lock_init(&ofs->upper_layer->lock);
 	ofs->upper_layer->mnt = upper_mnt;
 	ofs->upperdir = dget(upperpath->dentry);
 	err = 0;
-- 
2.13.6

