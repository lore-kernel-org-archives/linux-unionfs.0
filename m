Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH 2/4] ovl: update features on upper root dir from lower layers
Date: Thu, 22 Mar 2018 19:35:53 +0800
Message-ID: <20180322113555.47858-3-yi.zhang@huawei.com>
In-Reply-To: <20180322113555.47858-1-yi.zhang@huawei.com>
References: <20180322113555.47858-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

If user mount overlay with lower dirs which used to be upper root dirs
at previous mount of overlay, maybe some features was enabled and the
the lower root dir may contain feature xattr, so features on the lower
layers maybe more than that on the upper root dir. In that case, we
should copy up (or append) all features from the lower layers to the
upper root dir during mount time.

This patch doesn't add any features. After this patch, the upper root
dir will contain all features on every lower root dir after mount.

eg:
upper: "trusted.overlay.feature_compat=a,b,c,d"
lower0: "trusted.overlay.feature_compat=a,b,c"
lower1: "trusted.overlay.feature_compat=b,c,d"

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/overlayfs/super.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 10772ae237b4..19b7d0869fbd 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -231,6 +231,31 @@ static char *ovl_get_feature(struct dentry *realroot, const char *set)
 }
 
 /*
+ * Set overlay feature on the upper root dentry.
+ *
+ * @root: overlay root dir
+ * @upper: upper root dir
+ * @set: feature set xattr name
+ * @feature: feature string
+ * Return 0 if success, errorno otherwise.
+ */
+static int ovl_set_feature(struct dentry *root, struct dentry *upper,
+			   const char *set, const char *feature)
+{
+	int err;
+
+	err = ovl_want_write(root);
+	if (err)
+		return err;
+
+	err = ovl_check_setxattr(root, upper, set, feature,
+				 strlen(feature), 0);
+
+	ovl_drop_write(root);
+	return err;
+}
+
+/*
  * Add new feature to (or generate new) features string, set update flag
  * if new feature added.
  *
@@ -344,6 +369,7 @@ static int ovl_get_feature_set(struct dentry *root, const char *set,
 	struct ovl_entry *oe = root->d_fsdata;
 	char *buf = NULL;
 	int i;
+	bool update = false;
 	int err;
 
 	WARN_ON(*feature || *unknown);
@@ -373,12 +399,23 @@ static int ovl_get_feature_set(struct dentry *root, const char *set,
 			continue;
 
 		err = ovl_parse_feature(buf, supp, feature,
-					unknown, NULL);
+					unknown, &update);
 		kfree(buf);
 		if (err)
 			return err;
 	}
 
+	/*
+	 * If features on the lower layers are more than that on the
+	 * upper dir, update them.
+	 */
+	if (upperroot && update) {
+		err = ovl_set_feature(root, ovl_dentry_upper(root),
+				      set, *feature);
+		if (err)
+			return err;
+	}
+
 	return 0;
 }
 
-- 
2.13.6
