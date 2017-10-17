From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/7] ovl: no direct iteration for dir with copy up origin
Date: Tue, 17 Oct 2017 18:23:48 +0300
Message-ID: <1508253833-9866-3-git-send-email-amir73il@gmail.com>
References: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:50554 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936078AbdJQPXY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:23:24 -0400
Received: by mail-wm0-f65.google.com with SMTP id u138so4628034wmu.5
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:23:23 -0700 (PDT)
In-Reply-To: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

If a non-merge dir in an overlay mount has an overlay.origin xattr, it
means it was once an upper merge dir, which may contain whiteouts and
then the lower dir was removed under it.

Do not iterate real dir directly in this case to avoid exposing whiteouts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 29 +++++++++++++++++++++++++----
 1 file changed, 25 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 55623b6635b6..ba44546ad1ed 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -319,21 +319,42 @@ static inline int ovl_dir_read(struct path *realpath,
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
 
 static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list,
@@ -819,7 +840,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = !OVL_TYPE_MERGE(type);
+	od->is_real = ovl_dir_is_real(file->f_path.dentry);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
-- 
2.7.4
