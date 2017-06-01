From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 5/5] ovl: consistent st_ino/d_ino
Date: Thu,  1 Jun 2017 12:02:59 +0300
Message-ID: <1496307779-2766-6-git-send-email-amir73il@gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:36486 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751209AbdFAJC5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:02:57 -0400
Received: by mail-wm0-f65.google.com with SMTP id k15so9569505wmh.3
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Jun 2017 02:02:56 -0700 (PDT)
In-Reply-To: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org

This patch is based on an earlier POC by Miklos Szeredi.

When iterating an "impure" upper directory which may contain copy up
entries, lookup the overlay dentries to see if we know their copy up
origin and if we do, call vfs_getattr() on the overlay dentry
to make sure that d_ino will be consistent with st_ino from stat(2).

This may cause performance overhead of lookup_slow() per upper entry
for entries are not cached and it may cause memory pressure overhead
populating dcache entries that would not have been populated otherwise.

The overhead is minimal if the iterated entries are already in dcache.
It is also quite useful for the common case of 'ls -l' that readdir()
pre populates the dcache with the listed entries, making the following
stat() calls faster.

One exception to consistent d_ino is the case of a merge dir that was
moved into an opaque parent prior to v4.12.  This case will not have
marked parent opaque dir "impure" and therefore, ovl_iterate() will
optimize this to direct iteration on upper dir.  This situation will sort
itself out after another move into the opquae parent.  Worst case is that
the moved dir d_ino is inconsistent with its st_ino, which is not a
regression from version < 4.12.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     |   7 ++-
 fs/overlayfs/overlayfs.h |   2 +-
 fs/overlayfs/readdir.c   | 133 ++++++++++++++++++++++++++++++++++++++++++++---
 3 files changed, 132 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 04b3d6cf4148..4ca6061f7bfa 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -308,18 +308,21 @@ static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
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
index 0623cebeefff..513e25e56eed 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -233,7 +233,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 
 /* namei.c */
-int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
+int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
 
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f241b4ee3d8a..8b7e6cb435bb 100644
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
@@ -97,8 +101,20 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
 	p->name[len] = '\0';
 	p->len = len;
 	p->type = d_type;
-	p->ino = ino;
+	p->ino = p->real_ino = ino;
+	/*
+	 * For upper dir entries and for upper non-dir entries of impure dir,
+	 * d_ino will be updated during ovl_iterate() to the copy up origin ino.
+	 * A non-impure upper dir cannot have non-dir entries with origin xattr,
+	 * but it can have legacy merge dir entries without origin xattr.
+	 * stat will show the lower ino for those legacy merge dir entries, so
+	 * readdir should show it as well.
+	 */
+	if (rdd->idx == 0 && rdd->dentry &&
+	    (d_type == DT_DIR || ovl_dentry_is_impure(rdd->dentry)))
+		p->ino = 0;
 	p->is_whiteout = false;
+	p->idx = rdd->idx;
 
 	if (d_type == DT_CHR) {
 		p->next_maybe_whiteout = rdd->first_maybe_whiteout;
@@ -225,6 +241,7 @@ static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
 	}
 	revert_creds(old_cred);
 
+
 	return err;
 }
 
@@ -256,21 +273,41 @@ static inline int ovl_dir_read(struct path *realpath,
 	return err;
 }
 
+/* Can we iterate real dir directly? */
+static bool ovl_dir_is_real(struct dentry *dir)
+{
+	enum ovl_path_type type = ovl_path_type(dir);
+
+	if (OVL_TYPE_MERGE(type))
+		return false;
+
+	/* Upper dir may contain copied up entries that were moved into it */
+	return !OVL_TYPE_UPPER(type) || !ovl_dentry_is_impure(dir);
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
+		/*
+		 * is_real can only become false. This can happen after dir
+		 * itself is copied up or after child is moved into pure upper
+		 * dir and makes the dir impure.
+		 */
+		if (WARN_ON(is_real))
+			return;
 		od->is_real = false;
+	}
 }
 
 static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
@@ -287,7 +324,7 @@ static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
 	int idx, next;
 
 	for (idx = 0; idx != -1; idx = next) {
-		next = ovl_path_next(idx, dentry, &realpath);
+		next = ovl_path_next(idx, dentry, &realpath, &rdd.idx);
 
 		if (next != -1) {
 			err = ovl_dir_read(&realpath, &rdd);
@@ -353,11 +390,87 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	return cache;
 }
 
+/*
+ * Set d_ino for upper entries with known copy up origin.
+ *
+ * Non-upper entries should always report the uppermost real inode ino and
+ * this function should never be called for them.
+ *
+ * Upper entries should report the ino of their copy up origin if it is known.
+ * Call vfs_getattr() on the overlay entries to make sure that d_ino will be
+ * consistent with st_ino from stat(2).
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
+	if (WARN_ON(p->idx))
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
+
+	/* Task doing readdir may not have exec permissions on dir */
+	this = lookup_one_len_noperm(p->name, dir, p->len);
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
+		bool samefs = ovl_same_sb(dir->d_sb);
+		bool is_dir = S_ISDIR(this->d_inode->i_mode);
+
+		statpath.dentry = this;
+		err = vfs_getattr(&statpath, &stat, STATX_INO, 0);
+		if (err)
+			goto fail;
+
+		if (samefs || is_dir)
+			WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
+
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
@@ -378,9 +491,15 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 
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
@@ -502,7 +621,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = !OVL_TYPE_MERGE(type);
+	od->is_real = ovl_dir_is_real(file->f_path.dentry);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
-- 
2.7.4
