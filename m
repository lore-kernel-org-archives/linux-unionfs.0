Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10187 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731948AbeGaLEm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jul 2018 07:04:42 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 54A764082D8A3
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Jul 2018 17:25:13 +0800 (CST)
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH v2 6/9] ovl: add index feature if index dir exists
Date: Tue, 31 Jul 2018 17:37:24 +0800
Message-ID: <20180731093727.26855-7-yi.zhang@huawei.com>
In-Reply-To: <20180731093727.26855-1-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Index feature is backward read-only compatible becasue it only affect
the upper layer, and old kernel (which not support this feature) may
corrupt the relationship between files in upper dir and index dir when
change the copied-up linked files.

If the index feature is enabled, kernel will create an index dir in the
work base dir, so this patch check and set upper layer's index feature
when overlayfs get or create the index dir.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/overlayfs/overlayfs.h |  4 +++-
 fs/overlayfs/super.c     | 11 +++++++++--
 2 files changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7ed8ed49266f..21a41c12168c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -59,7 +59,8 @@ struct ovl_d_feature {
 #define OVL_FEATURE_COMPAT_SUPP 		(0)
 #define OVL_FEATURE_COMPAT_UNKNOWN		(~OVL_FEATURE_COMPAT_SUPP)
 
-#define OVL_FEATURE_RO_COMPAT_SUPP		(0)
+#define OVL_FEATURE_RO_COMPAT_INDEX		(1 << 0)
+#define OVL_FEATURE_RO_COMPAT_SUPP		(OVL_FEATURE_RO_COMPAT_INDEX)
 #define OVL_FEATURE_RO_COMPAT_UNKNOWN		(~OVL_FEATURE_RO_COMPAT_SUPP)
 
 #define OVL_FEATURE_INCOMPAT_REDIRECT_DIR	(1 << 0)
@@ -130,6 +131,7 @@ static inline int ovl_set_feature_##name(struct ovl_fs *ofs) \
 			OVL_FEATURE_INCOMPAT_##flagname); \
 } \
 
+OVL_FEATURE_RO_COMPAT_FUNCS(index,		INDEX)
 OVL_FEATURE_INCOMPAT_FUNCS(redirect_dir,	REDIRECT_DIR)
 
 /*
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index a5bbbddf741c..197329f7d284 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1443,8 +1443,15 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (err)
 			goto out_free_oe;
 
-		/* Force r/o mount with no index dir */
-		if (!ofs->indexdir) {
+		if (ofs->indexdir) {
+			/* Set index feature if index dir exists */
+			if (!ovl_has_feature_index(ofs->upper_layer)) {
+				err = ovl_set_feature_index(ofs);
+				if (err)
+					goto out_free_oe;
+			}
+		} else {
+		        /* Force r/o mount with no index dir */
 			dput(ofs->workdir);
 			ofs->workdir = NULL;
 			sb->s_flags |= SB_RDONLY;
-- 
2.13.6

