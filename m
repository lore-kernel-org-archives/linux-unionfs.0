Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH 4/4] ovl: fix redirect feature for backward compatibility
Date: Thu, 22 Mar 2018 19:35:55 +0800
Message-ID: <20180322113555.47858-5-yi.zhang@huawei.com>
In-Reply-To: <20180322113555.47858-1-yi.zhang@huawei.com>
References: <20180322113555.47858-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

For a redirect dir was created before the overlayfs support
"feature set", upper root dir does not contain the redirect dir
feature xattr. In that case, we cannot detect this feature during
mount time, so fix this feature set once a redirect xattr is detected
in ovl_lookup().

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/overlayfs/namei.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 70fcfcc684cc..9325c5a870c0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -914,6 +914,18 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		ctr++;
 
 		/*
+		 * Detect redirect xattr but not enable this feature, this
+		 * redirect maybe set by the old overlay driver, fix this
+		 * feature for backward compatibility.
+		 */
+		if (d.redirect && !ofs->config.redirect_dir &&
+		    !ovl_has_feature_redirect_dir(dentry->d_sb)) {
+			err = ovl_set_feature_redirect_dir(dentry->d_sb);
+			if (err)
+				goto out_put;
+		}
+
+		/*
 		 * Following redirects can have security consequences: it's like
 		 * a symlink into the lower layer without the permission checks.
 		 * This is only a problem if the upper layer is untrusted (e.g
-- 
2.13.6
