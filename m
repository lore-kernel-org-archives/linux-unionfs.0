Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:51301 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731722AbeGaLEr (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jul 2018 07:04:47 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 0724D2A69669E
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Jul 2018 17:25:19 +0800 (CST)
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH v2 9/9] ovl: check redirect_dir feature when detect redirect xattr on dir
Date: Tue, 31 Jul 2018 17:37:27 +0800
Message-ID: <20180731093727.26855-10-yi.zhang@huawei.com>
In-Reply-To: <20180731093727.26855-1-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

After we introduce the fsck.overlay program, we could check and fix
the inconsistency of feature set xattr, so it's a good opportunity
check the redirect dir feature when we detect redirect xattr on
directory in the underlying layer. If the feature is necessary
(OVL_FS_V2 for all layers and OVL_FS_UPPER_V2 for upper layer) but
the redirect dir feature is missing, the feature set is inconsistent
and fsck.overlay is required.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/overlayfs/feature.c   | 11 +++++++++++
 fs/overlayfs/namei.c     | 33 ++++++++++++++++++++++++++++++++-
 fs/overlayfs/overlayfs.h |  1 +
 3 files changed, 44 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/feature.c b/fs/overlayfs/feature.c
index fffa79ee9b15..ed9830ab7ae1 100644
--- a/fs/overlayfs/feature.c
+++ b/fs/overlayfs/feature.c
@@ -285,3 +285,14 @@ bool ovl_check_feature_ok(struct ovl_fs *ofs, bool readonly)
 
 	return true;
 }
+
+/*
+ * Feature set on upper layer is necessary when OVL_FS_V2 and
+ * OVL_FS_UPPER_V2, feautre sets on lower layers are necessary
+ * when OVL_FS_V2.
+ */
+bool ovl_feature_necessary(struct ovl_fs *ofs, struct ovl_layer *layer)
+{
+	return (ofs->config.format == OVL_FS_UPPER_V2) ?
+			(layer->idx == 0) : (ofs->config.format == OVL_FS_V2);
+}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index bb2d347c0a7e..160c87734092 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -24,6 +24,7 @@ struct ovl_lookup_data {
 	bool stop;
 	bool last;
 	char *redirect;
+	bool redirect_xattr;
 };
 
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
@@ -35,7 +36,7 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, NULL, 0);
 	if (res < 0) {
 		if (res == -ENODATA || res == -EOPNOTSUPP)
-			return 0;
+			goto out;
 		goto fail;
 	}
 	buf = kzalloc(prelen + res + strlen(post) + 1, GFP_KERNEL);
@@ -75,6 +76,7 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 
 	strcat(buf, post);
 	kfree(d->redirect);
+	d->redirect_xattr = true;
 	d->redirect = buf;
 	d->name.name = d->redirect;
 	d->name.len = strlen(d->redirect);
@@ -83,6 +85,8 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 
 err_free:
 	kfree(buf);
+out:
+	d->redirect_xattr = false;
 	return 0;
 fail:
 	pr_warn_ratelimited("overlayfs: failed to get redirect (%i)\n", res);
@@ -841,6 +845,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.stop = false,
 		.last = ofs->config.redirect_follow ? false : !poe->numlower,
 		.redirect = NULL,
+		.redirect_xattr = false,
 	};
 
 	if (dentry->d_name.len > ofs->namelen)
@@ -875,6 +880,19 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 				goto out_put_upper;
 		}
 
+		/*
+		 * Check redirect_dir feature when redirect xattr is detected on
+		 * directory and feature set is required.
+		 */
+		err = -ESTALE;
+		if (d.redirect_xattr && d.is_dir &&
+		    ovl_feature_necessary(ofs, ofs->upper_layer) &&
+		    !ovl_has_feature_redirect_dir(ofs->upper_layer)) {
+			pr_warn_ratelimited("overlayfs: redirect_dir feature missing, "
+					    "running fsck.overlay is recommended\n");
+			goto out_put;
+		}
+
 		if (d.redirect) {
 			err = -ENOMEM;
 			upperredirect = kstrdup(d.redirect, GFP_KERNEL);
@@ -942,6 +960,19 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		ctr++;
 
 		/*
+		 * Check redirect_dir feature when redirect xattr is detected on
+		 * directory and feature set is required.
+		 */
+		err = -ESTALE;
+		if (d.redirect_xattr && d.is_dir &&
+		    ovl_feature_necessary(ofs, lower.layer) &&
+		    !ovl_has_feature_redirect_dir(lower.layer)) {
+			pr_warn_ratelimited("overlayfs: redirect_dir feature missing, "
+					    "running fsck.overlay is recommended\n");
+			goto out_put;
+		}
+
+		/*
 		 * Following redirects can have security consequences: it's like
 		 * a symlink into the lower layer without the permission checks.
 		 * This is only a problem if the upper layer is untrusted (e.g
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 0f95e60cae69..b3db106b8e22 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -477,3 +477,4 @@ extern const struct export_operations ovl_export_operations;
 /* feature.c */
 int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe);
 bool ovl_check_feature_ok(struct ovl_fs *ofs, bool readonly);
+bool ovl_feature_necessary(struct ovl_fs *ofs, struct ovl_layer *layer);
-- 
2.13.6

