From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] ovl: constant d_ino across copy up
Date: Thu, 11 May 2017 16:42:27 +0300
Message-ID: <1494510147-18658-3-git-send-email-amir73il@gmail.com>
References: <1494510147-18658-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35918 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755821AbdEKNmS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 11 May 2017 09:42:18 -0400
Received: by mail-wr0-f193.google.com with SMTP id v42so3618367wrc.3
        for <linux-unionfs@vger.kernel.org>; Thu, 11 May 2017 06:42:17 -0700 (PDT)
In-Reply-To: <1494510147-18658-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

This patch is based on an earlier POC by Miklos Szeredi.

When all layers are on the same fs, and iterating a directory which
may contain copy up entries, call vfs_getattr() on the overlay entries
to make sure that d_ino will be consistent with st_ino from stat(2).

There is an overhead of lookup per upper entry in readdir.
That overhead is a waste for a merge dir with only pure upper
entries (i.e. no copy ups), but that can be optimized later.

The overhead is minimal if the iterated entries are already in dcache.
It is also quite useful for the common case of 'ls -l' that readdir()
pre populates the dcache with the listed entries, making the following
stat() calls faster.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     |   7 ++-
 fs/overlayfs/overlayfs.h |   2 +-
 fs/overlayfs/readdir.c   | 115 ++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 114 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 0c72a59..d8daecf 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -331,18 +331,21 @@ static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
  */
-int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
+int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
 	BUG_ON(idx < 0);
 	if (idx == 0) {
 		ovl_path_upper(dentry, path);
-		if (path->dentry)
+		if (path->dentry) {
+			*idxp = 0;
 			return oe->numlower ? 1 : -1;
+		}
 		idx++;
 	}
 	BUG_ON(idx > oe->numlower);
+	*idxp = idx;
 	*path = oe->lowerstack[idx - 1];
 
 	return (idx < oe->numlower) ? idx + 1 : -1;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index fae52f5..2a44b05 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -224,7 +224,7 @@ int ovl_copy_up_start(struct dentry *dentry);
 void ovl_copy_up_end(struct dentry *dentry);
 
 /* namei.c */
-int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
+int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
 
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f241b4e..d999899 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -15,15 +15,18 @@
 #include <linux/rbtree.h>
 #include <linux/security.h>
 #include <linux/cred.h>
+#include <linux/ratelimit.h>
 #include "overlayfs.h"
 
 struct ovl_cache_entry {
 	unsigned int len;
 	unsigned int type;
+	u64 real_ino;
 	u64 ino;
 	struct list_head l_node;
 	struct rb_node node;
 	struct ovl_cache_entry *next_maybe_whiteout;
+	int idx;
 	bool is_whiteout;
 	char name[];
 };
@@ -43,6 +46,7 @@ struct ovl_readdir_data {
 	struct list_head middle;
 	struct ovl_cache_entry *first_maybe_whiteout;
 	int count;
+	int idx;
 	int err;
 	bool d_type_supported;
 };
@@ -97,8 +101,11 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 	p->name[len] = '\0';
 	p->len = len;
 	p->type = d_type;
-	p->ino = ino;
+	p->real_ino = ino;
+	/* Defer setting d_ino for upper entry to ovl_iterate() */
+	p->ino = rdd->idx ? ino : 0;
 	p->is_whiteout = false;
+	p->idx = rdd->idx;
 
 	if (d_type == DT_CHR) {
 		p->next_maybe_whiteout = rdd->first_maybe_whiteout;
@@ -225,6 +232,7 @@ static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
 	}
 	revert_creds(old_cred);
 
+
 	return err;
 }
 
@@ -256,21 +264,38 @@ static inline int ovl_dir_read(struct path *realpath,
 	return err;
 }
 
+/* Can we iterate real dir directly? */
+static bool ovl_dir_is_real(struct dentry *dir)
+{
+	enum ovl_path_type type = ovl_path_type(dir);
+
+	if (OVL_TYPE_MERGE(type))
+		return false;
+	/* Upper dir may contain copied up entries that were moved into it */
+	if (ovl_same_sb(dir->d_sb))
+		return !OVL_TYPE_UPPER(type) || !ovl_dentry_is_impure(dir);
+	return true;
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
+		/* is_real can only become false (after dir copy up) */
+		if (WARN_ON(is_real))
+			return;
 		od->is_real = false;
+	}
 }
 
 static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
@@ -287,7 +312,7 @@ static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
 	int idx, next;
 
 	for (idx = 0; idx != -1; idx = next) {
-		next = ovl_path_next(idx, dentry, &realpath);
+		next = ovl_path_next(idx, dentry, &realpath, &rdd.idx);
 
 		if (next != -1) {
 			err = ovl_dir_read(&realpath, &rdd);
@@ -353,11 +378,81 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	return cache;
 }
 
+/*
+ * Set d_ino for upper entries. Non-upper entries should always report
+ * the uppermost real inode ino and should not call this function.
+ *
+ * When not all layer are on same fs, report real ino also for upper.
+ *
+ * When all layers are on the same fs, and upper has a reference to
+ * copy up origin, call vfs_getattr() on the overlay entry to make
+ * sure that d_ino will be consistent with st_ino from stat(2).
+ */
+static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
+
+{
+	struct dentry *dir = path->dentry;
+	struct dentry *this = NULL;
+	enum ovl_path_type type;
+	u64 ino = p->real_ino;
+	int err = 0;
+
+	if (!ovl_same_sb(dir->d_sb) || WARN_ON(p->idx))
+		goto out;
+
+	if (p->name[0] == '.') {
+		if (p->len == 1) {
+			this = dget(dir);
+			goto get;
+		}
+		if (p->len == 2 && p->name[1] == '.') {
+			/* we shall not be moved */
+			this = dget(dir->d_parent);
+			goto get;
+		}
+	}
+	this = lookup_one_len(p->name, dir, p->len);
+	if (IS_ERR_OR_NULL(this) || !this->d_inode) {
+		if (IS_ERR(this)) {
+			err = PTR_ERR(this);
+			this = NULL;
+			goto fail;
+		}
+		goto out;
+	}
+
+get:
+	type = ovl_path_type(this);
+	if (OVL_TYPE_ORIGIN(type)) {
+		struct kstat stat;
+		struct path statpath = *path;
+
+		statpath.dentry = this;
+		err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
+		if (err)
+			goto fail;
+
+		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
+		ino = stat.ino;
+	}
+
+out:
+	p->ino = ino;
+	dput(this);
+	return err;
+
+fail:
+	pr_warn_ratelimited("overlay: failed to look up (%s) for ino (%i)\n",
+			    p->name, err);
+	goto out;
+}
+
 static int ovl_iterate(struct file *file, struct dir_context *ctx)
 {
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dentry = file->f_path.dentry;
 	struct ovl_cache_entry *p;
+	int err;
 
 	if (!ctx->pos)
 		ovl_dir_reset(file);
@@ -378,9 +473,15 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 
 	while (od->cursor != &od->cache->entries) {
 		p = list_entry(od->cursor, struct ovl_cache_entry, l_node);
-		if (!p->is_whiteout)
+		if (!p->is_whiteout) {
+			if (!p->ino) {
+				err = ovl_cache_update_ino(&file->f_path, p);
+				if (err)
+					return err;
+			}
 			if (!dir_emit(ctx, p->name, p->len, p->ino, p->type))
 				break;
+		}
 		od->cursor = p->l_node.next;
 		ctx->pos++;
 	}
@@ -502,7 +603,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = !OVL_TYPE_MERGE(type);
+	od->is_real = ovl_dir_is_real(file->f_path.dentry);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
-- 
2.7.4
