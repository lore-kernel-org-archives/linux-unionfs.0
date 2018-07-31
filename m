Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10184 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731722AbeGaLEo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jul 2018 07:04:44 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 4A0B156D0D38D
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Jul 2018 17:25:13 +0800 (CST)
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH v2 5/9] ovl: add redirect dir feature when set redirect xattr to dir
Date: Tue, 31 Jul 2018 17:37:23 +0800
Message-ID: <20180731093727.26855-6-yi.zhang@huawei.com>
In-Reply-To: <20180731093727.26855-1-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Redirect dir feature is backward incompatible because old kernel (which
not support this feature) may corrupt the merge relationship between
directories when change the directory which have redirect xattr.

This patch check and set the upper layer's redirect dir feature when
kernel set redirect xattr to directory in the upper layer.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/overlayfs/dir.c       | 11 +++++++++++
 fs/overlayfs/overlayfs.h |  5 ++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f480b1a2cd2e..238999e5f47b 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -969,6 +969,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	bool is_dir = d_is_dir(old);
 	bool new_is_dir = d_is_dir(new);
 	bool samedir = olddir == newdir;
+	struct ovl_fs* ofs = old->d_sb->s_fs_info;
 	struct dentry *opaquedir = NULL;
 	const struct cred *old_cred = NULL;
 	LIST_HEAD(list);
@@ -1061,6 +1062,16 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		}
 	}
 
+	if ((is_dir && ovl_type_merge_or_lower(old)) ||
+	    (!overwrite && new_is_dir && ovl_type_merge_or_lower(new))) {
+		/*
+		 * Set redirect dir feature to the upper root dir if this
+		 * feature doesn't exist.
+		 */
+		if (!ovl_has_feature_redirect_dir(ofs->upper_layer))
+			err = ovl_set_feature_redirect_dir(ofs);
+	}
+
 	trap = lock_rename(new_upperdir, old_upperdir);
 
 	olddentry = lookup_one_len(old->d_name.name, old_upperdir,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d6231acc660a..7ed8ed49266f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -62,7 +62,8 @@ struct ovl_d_feature {
 #define OVL_FEATURE_RO_COMPAT_SUPP		(0)
 #define OVL_FEATURE_RO_COMPAT_UNKNOWN		(~OVL_FEATURE_RO_COMPAT_SUPP)
 
-#define OVL_FEATURE_INCOMPAT_SUPP		(0)
+#define OVL_FEATURE_INCOMPAT_REDIRECT_DIR	(1 << 0)
+#define OVL_FEATURE_INCOMPAT_SUPP		(OVL_FEATURE_INCOMPAT_REDIRECT_DIR)
 #define OVL_FEATURE_INCOMPAT_UNKNOWN		(~OVL_FEATURE_INCOMPAT_SUPP)
 
 static inline bool ovl_has_unknown_compat_features(struct ovl_layer *layer)
@@ -129,6 +130,8 @@ static inline int ovl_set_feature_##name(struct ovl_fs *ofs) \
 			OVL_FEATURE_INCOMPAT_##flagname); \
 } \
 
+OVL_FEATURE_INCOMPAT_FUNCS(redirect_dir,	REDIRECT_DIR)
+
 /*
  * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
  * where:
-- 
2.13.6

