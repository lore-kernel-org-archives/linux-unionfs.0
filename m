From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 1/3] ovl: no direct iteration for dir with origin xattr
Date: Tue, 31 Oct 2017 23:45:48 +0200
Message-ID: <1509486350-21362-2-git-send-email-amir73il@gmail.com>
References: <1509486350-21362-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:51858 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932584AbdJaVpM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 17:45:12 -0400
Received: by mail-wm0-f66.google.com with SMTP id b9so1607836wmh.0
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Oct 2017 14:45:11 -0700 (PDT)
In-Reply-To: <1509486350-21362-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

If a non-merge dir in an overlay mount has an overlay.origin xattr, it
means it was once an upper merge dir, which may contain whiteouts and
then the lower dir was removed under it.

Do not iterate real dir directly in this case to avoid exposing whiteouts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |  5 +++++
 fs/overlayfs/overlayfs.h |  4 ++++
 fs/overlayfs/readdir.c   | 29 +++++++++++++++++++++++++----
 fs/overlayfs/util.c      | 13 +++++++++++++
 4 files changed, 47 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 03f0ec2b73eb..2949448d0c7d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -661,6 +661,11 @@ struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
 	if (upperdentry && ovl_is_impuredir(upperdentry))
 		ovl_set_flag(OVL_IMPURE, inode);
 
+	/* Check for non-merge dir that may have whiteouts */
+	if (S_ISDIR(realinode->i_mode) && (!upperdentry || !lowerdentry) &&
+	    ovl_check_origin_xattr(upperdentry ?: lowerdentry))
+		ovl_set_flag(OVL_WHITEOUTS, inode);
+
 	if (inode->i_state & I_NEW)
 		unlock_new_inode(inode);
 out:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d9a0edd4e57e..d53157ccf0d7 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -28,7 +28,10 @@ enum ovl_path_type {
 #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
 
 enum ovl_flag {
+	/* Pure upper dir that may contain non pure upper entries */
 	OVL_IMPURE,
+	/* Non-merge dir that may contain whiteout entries */
+	OVL_WHITEOUTS,
 	OVL_INDEX,
 };
 
@@ -223,6 +226,7 @@ bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry);
 void ovl_copy_up_end(struct dentry *dentry);
+bool ovl_check_origin_xattr(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       const char *name, const void *value, size_t size,
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 698b74dd750e..ec902a7c1f4d 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -316,21 +316,42 @@ static inline int ovl_dir_read(struct path *realpath,
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
+	return !ovl_test_flag(OVL_WHITEOUTS, d_inode(dir));
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
@@ -816,7 +837,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = !OVL_TYPE_MERGE(type);
+	od->is_real = ovl_dir_is_real(file->f_path.dentry);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index b9b239fa5cfd..51ca8bd16009 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -329,6 +329,19 @@ void ovl_copy_up_end(struct dentry *dentry)
 	mutex_unlock(&OVL_I(d_inode(dentry))->lock);
 }
 
+bool ovl_check_origin_xattr(struct dentry *dentry)
+{
+	int res;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_ORIGIN, NULL, 0);
+
+	/* Zero size value means "copied up but origin unknown" */
+	if (res >= 0)
+		return true;
+
+	return false;
+}
+
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name)
 {
 	int res;
-- 
2.7.4
