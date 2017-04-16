From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 12/13] ovl: constant ino across copy up
Date: Mon, 17 Apr 2017 02:59:42 +0300
Message-ID: <1492387183-18847-13-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:32910 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756894AbdDPX7y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Apr 2017 19:59:54 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

This patch is based on an earlier POC by Miklos Szeredi.

When redirect_fh is enabled, export the overlay inode ino to stat(2)
and readdir(3)/getdents(2) instead of the real upper inode ino.

The overlay inode ino is inherited from the uppermost lower real inode
(a.k.a. stable inode) and therefore remains unmodified after copy up
as well as after mount cycle.

There is an overhead of lookup per upper entry in readdir.
That overhead is a waste for pure upper dir with only pure upper
entries (i.e. no redirects), but that can be optimized later.

The overhead is minimal if the listed entries are already in dcache.
It is also quite useful for the common case of 'ls -l' that readdir()
pre populates the dcache with the listed entries, making the following
stat() calls faster.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |  6 ++++
 fs/overlayfs/namei.c     |  7 ++--
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/readdir.c   | 85 ++++++++++++++++++++++++++++++++++++++++++++----
 4 files changed, 91 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1951865..0324d1c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -79,6 +79,12 @@ static int ovl_getattr(const struct path *path, struct kstat *stat,
 	 */
 	if (ovl_same_sb(dentry->d_sb))
 		stat->dev = dentry->d_sb->s_dev;
+	/*
+	 * When redirect_fh is enabled, return the overlay inode ino, which is
+	 * inherited from the uppermost lower real inode (a.k.a. stable inode).
+	 */
+	if (ovl_redirect_fh(dentry->d_sb))
+		stat->ino = dentry->d_inode->i_ino;
 
 	return err;
 }
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 7aaff83..d7f3a15 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -319,18 +319,21 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
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
index dacee9e..8092aae 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -198,7 +198,7 @@ int ovl_copy_up_start(struct dentry *dentry);
 void ovl_copy_up_end(struct dentry *dentry);
 
 /* namei.c */
-int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
+int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
 
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index f241b4e..ebe15ea 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -20,10 +20,12 @@
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
@@ -43,6 +45,7 @@ struct ovl_readdir_data {
 	struct list_head middle;
 	struct ovl_cache_entry *first_maybe_whiteout;
 	int count;
+	int idx;
 	int err;
 	bool d_type_supported;
 };
@@ -97,8 +100,11 @@ static struct ovl_cache_entry *ovl_cache_entry_new(struct ovl_readdir_data *rdd,
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
@@ -225,6 +231,7 @@ static int ovl_check_whiteouts(struct dentry *dir, struct ovl_readdir_data *rdd)
 	}
 	revert_creds(old_cred);
 
+
 	return err;
 }
 
@@ -256,21 +263,37 @@ static inline int ovl_dir_read(struct path *realpath,
 	return err;
 }
 
+/* Can we iterate real dir directly? */
+static bool ovl_dir_is_real(struct super_block *sb, enum ovl_path_type type)
+{
+	if (OVL_TYPE_MERGE(type))
+		return false;
+	/* Upper dir may contain copied up entries that were moved into it */
+	if (ovl_redirect_fh(sb))
+		return !OVL_TYPE_UPPER(type);
+	return true;
+}
+
 static void ovl_dir_reset(struct file *file)
 {
 	struct ovl_dir_file *od = file->private_data;
 	struct ovl_dir_cache *cache = od->cache;
 	struct dentry *dentry = file->f_path.dentry;
 	enum ovl_path_type type = ovl_path_type(dentry);
+	bool is_real;
 
 	if (cache && ovl_dentry_version_get(dentry) != cache->version) {
 		ovl_cache_put(od, dentry);
 		od->cache = NULL;
 		od->cursor = NULL;
 	}
-	WARN_ON(!od->is_real && !OVL_TYPE_MERGE(type));
-	if (od->is_real && OVL_TYPE_MERGE(type))
+	is_real = ovl_dir_is_real(dentry->d_sb, type);
+	if (od->is_real != is_real) {
+		/* is_real can only become false (after dir copy up) */
+		if (WARN_ON(is_real))
+			return;
 		od->is_real = false;
+	}
 }
 
 static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
@@ -287,7 +310,7 @@ static int ovl_dir_read_merged(struct dentry *dentry, struct list_head *list)
 	int idx, next;
 
 	for (idx = 0; idx != -1; idx = next) {
-		next = ovl_path_next(idx, dentry, &realpath);
+		next = ovl_path_next(idx, dentry, &realpath, &rdd.idx);
 
 		if (next != -1) {
 			err = ovl_dir_read(&realpath, &rdd);
@@ -353,11 +376,55 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	return cache;
 }
 
+/*
+ * Set d_ino for upper entries. Non-upper entries should always report
+ * the uppermost real inode ino and should not call this function.
+ * When redirect_fh is disabled, report real ino also for upper.
+ * When redirect_fh is enabled, lookup the overlay inode of p->name
+ * under dir and report ino of the overlay inode. The overlay inode ino
+ * is inherited from the uppermost lower real inode (a.k.a. stable inode).
+ */
+static int ovl_cache_entry_update_ino(struct dentry *dir,
+				      struct ovl_cache_entry *p)
+
+{
+	struct dentry *this;
+
+	if (!ovl_redirect_fh(dir->d_sb) || WARN_ON(p->idx)) {
+		p->ino = p->real_ino;
+		return 0;
+	}
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
+	if (IS_ERR_OR_NULL(this)) {
+		pr_err("overlay: failed to look up (%s) for ino (%i)\n",
+		       p->name, (int) PTR_ERR(this));
+		return -EIO;
+	}
+get:
+	p->ino = this->d_inode->i_ino;
+	dput(this);
+
+	return 0;
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
@@ -378,9 +445,15 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 
 	while (od->cursor != &od->cache->entries) {
 		p = list_entry(od->cursor, struct ovl_cache_entry, l_node);
-		if (!p->is_whiteout)
+		if (!p->is_whiteout) {
+			if (!p->ino) {
+				err = ovl_cache_entry_update_ino(dentry, p);
+				if (err)
+					return err;
+			}
 			if (!dir_emit(ctx, p->name, p->len, p->ino, p->type))
 				break;
+		}
 		od->cursor = p->l_node.next;
 		ctx->pos++;
 	}
@@ -502,7 +575,7 @@ static int ovl_dir_open(struct inode *inode, struct file *file)
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = !OVL_TYPE_MERGE(type);
+	od->is_real = ovl_dir_is_real(inode->i_sb, type);
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
-- 
2.7.4
