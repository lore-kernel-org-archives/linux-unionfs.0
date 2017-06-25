From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: no direct iteration for dir with copy up origin
Date: Sun, 25 Jun 2017 17:14:29 +0300
Message-ID: <1498400069-12840-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35501 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750763AbdFYOON (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 25 Jun 2017 10:14:13 -0400
Received: by mail-wr0-f196.google.com with SMTP id z45so24697223wrb.2
        for <linux-unionfs@vger.kernel.org>; Sun, 25 Jun 2017 07:14:12 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, yi.zhang@huawei.com
Cc: linux-unionfs@vger.kernel.org

If a non-merge dir in an overlay mount has an overlay.origin xattr, it
means it was once an upper merge dir, which may contain whiteouts and
then the lower dir was removed under it.

Do not iterate real dir directly in this case to avoid exposing whiteouts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

Yi,

You missed a very big spot and so did I in review.
Your patch doen't hide whiteouts from readdir and it doesn't
even pass you own xfstest...

Anyway, here are the missing parts picked from my impure readdir
patch.

Amir.

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 0298463cf9c3..3c8796705517 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -256,21 +256,42 @@ static inline int ovl_dir_read(struct path *realpath,
 	return err;
 }
 
+/* Can we iterate real dir directly? */
+static bool ovl_dir_is_real(struct dentry *dir)
+{
+	struct path realpath;
+	enum ovl_path_type type = ovl_path_real(dir, &realpath);
+
+	if (OVL_TYPE_MERGE(type))
+		return false;
+
+	/*
+	 * Non-merge dir may contain whiteouts from a time it was a merge
+	 * upper, before lower dir was removed under it and possibly before
+	 * it was rotated from upper to lower layer.
+	 */
+	return !ovl_check_origin_xattr(realpath.dentry);
+}
+
 static void ovl_dir_reset(struct file *file)
 {
 	struct ovl_dir_file *od = file->private_data;
 	struct ovl_dir_cache *cache = od->cache;
 	struct dentry *dentry = file->f_path.dentry;
-	enum ovl_path_type type = ovl_path_type(dentry);
+	bool is_real;
 
 	if (cache && ovl_dentry_version_get(dentry) != cache->version) {
 		ovl_cache_put(od, dentry);
 		od->cache = NULL;
 		od->cursor = NULL;
 	}
-	WARN_ON(!od->is_real && !OVL_TYPE_MERGE(type));
-	if (od->is_real && OVL_TYPE_MERGE(type))
+	is_real = ovl_dir_is_real(dentry);
+	if (od->is_real != is_real) {
+		/* is_real can only become false when dir is copied up */
+		if (WARN_ON(is_real))
+			return;
 		od->is_real = false;
+	}
 }
 
 static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
@@ -502,7 +523,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = !OVL_TYPE_MERGE(type);
+	od->is_real = ovl_dir_is_real(file->f_path.dentry);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
-- 
2.7.4
