From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 19/23] ovl: factor out ovl_get_index_fh() helper
Date: Thu,  4 Jan 2018 18:40:14 +0200
Message-ID: <1515084018-25134-20-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:46279 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753310AbeADQju (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:50 -0500
Received: by mail-wm0-f67.google.com with SMTP id r78so4577571wme.5
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:49 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

The helper is needed to lookup an index by file handle for NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 59 ++++++++++++++++++++++++++++++++++++++++--------
 fs/overlayfs/overlayfs.h |  1 +
 2 files changed, 50 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 1a052f821fff..ac902fa7c5e2 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -588,6 +588,21 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 	goto out;
 }
 
+static int ovl_get_index_name_fh(struct ovl_fh *fh, struct qstr *name)
+{
+	char *n, *s;
+
+	n = kzalloc(fh->len * 2, GFP_KERNEL);
+	if (!n)
+		return -ENOMEM;
+
+	s  = bin2hex(n, fh, fh->len);
+	*name = (struct qstr) QSTR_INIT(n, s - n);
+
+	return 0;
+
+}
+
 /*
  * Lookup in indexdir for the index entry of a lower real inode or a copy up
  * origin inode. The index entry name is the hex representation of the lower
@@ -605,25 +620,49 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
  */
 int ovl_get_index_name(struct dentry *origin, struct qstr *name)
 {
-	int err;
 	struct ovl_fh *fh;
-	char *n, *s;
+	int err;
 
 	fh = ovl_encode_fh(origin, false);
 	if (IS_ERR(fh))
 		return PTR_ERR(fh);
 
-	err = -ENOMEM;
-	n = kzalloc(fh->len * 2, GFP_KERNEL);
-	if (n) {
-		s  = bin2hex(n, fh, fh->len);
-		*name = (struct qstr) QSTR_INIT(n, s - n);
-		err = 0;
-	}
-	kfree(fh);
+	err = ovl_get_index_name_fh(fh, name);
 
+	kfree(fh);
 	return err;
+}
+
+/* Lookup index by file handle for NFS export */
+struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh)
+{
+	struct dentry *index;
+	struct qstr name;
+	int err;
+
+	err = ovl_get_index_name_fh(fh, &name);
+	if (err)
+		return ERR_PTR(err);
+
+	index = lookup_one_len_unlocked(name.name, ofs->indexdir, name.len);
+	kfree(name.name);
+	if (IS_ERR(index)) {
+		if (PTR_ERR(index) == -ENOENT)
+			index = NULL;
+		return index;
+	}
 
+	if (d_is_negative(index))
+		err = 0;
+	else if (ovl_is_whiteout(index))
+		err = -ESTALE;
+	else if (ovl_dentry_weird(index))
+		err = -EIO;
+	else
+		return index;
+
+	dput(index);
+	return ERR_PTR(err);
 }
 
 static struct dentry *ovl_lookup_index(struct dentry *dentry,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 9d0dd8b70e03..d9467eab8514 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -259,6 +259,7 @@ int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 		      bool is_upper, bool set);
 int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
+struct dentry *ovl_get_index_fh(struct ovl_fs *ofs, struct ovl_fh *fh);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags);
-- 
2.7.4
