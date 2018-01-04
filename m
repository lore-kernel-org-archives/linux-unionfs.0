From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 03/23] ovl: store layer index in ovl_layer
Date: Thu,  4 Jan 2018 18:39:58 +0200
Message-ID: <1515084018-25134-4-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:37288 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753395AbeADQjc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:32 -0500
Received: by mail-wr0-f193.google.com with SMTP id f8so2018677wre.4
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:31 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Store the fs root layer index inside ovl_layer struct, so we can
get the root fs layer index from merge dir lower layer instead of
find it with ovl_find_layer() helper.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 17 +----------------
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     |  1 +
 3 files changed, 4 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 71db9a966d88..a48ee02c4524 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -572,18 +572,6 @@ int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
 	return (idx < oe->numlower) ? idx + 1 : -1;
 }
 
-static int ovl_find_layer(struct ovl_fs *ofs, struct ovl_path *path)
-{
-	int i;
-
-	for (i = 0; i < ofs->numlower; i++) {
-		if (ofs->lower_layers[i].mnt == path->layer->mnt)
-			break;
-	}
-
-	return i;
-}
-
 /* Fix missing 'origin' xattr */
 static int ovl_fix_origin(struct dentry *dentry, struct dentry *lower,
 			  struct dentry *upper)
@@ -733,11 +721,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		if (d.redirect && d.redirect[0] == '/' && poe != roe) {
 			poe = roe;
-
 			/* Find the current layer on the root dentry */
-			i = ovl_find_layer(ofs, &lower);
-			if (WARN_ON(i == ofs->numlower))
-				break;
+			i = lower.layer->idx - 1;
 		}
 	}
 
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 9d0bc03bf6e4..608e48755070 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -22,6 +22,8 @@ struct ovl_config {
 struct ovl_layer {
 	struct vfsmount *mnt;
 	dev_t pseudo_dev;
+	/* Index of this layer in fs root (upper == 0) */
+	int idx;
 };
 
 struct ovl_path {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7e33c83c5a07..2b58620eedf0 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1111,6 +1111,7 @@ static int ovl_get_lower_layers(struct ovl_fs *ofs, struct path *stack,
 
 		ofs->lower_layers[ofs->numlower].mnt = mnt;
 		ofs->lower_layers[ofs->numlower].pseudo_dev = dev;
+		ofs->lower_layers[ofs->numlower].idx = i + 1;
 		ofs->numlower++;
 
 		/* Check if all lower layers are on same sb */
-- 
2.7.4
