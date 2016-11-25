From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [POC/RFC PATCH] overlayfs: constant inode numbers
Date: Fri, 25 Nov 2016 22:29:34 +0100
Message-ID: <20161125212934.GB2622@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Here's a really preliminary patch to allow inode numbers to be constant across
copy ups and be consistent between st_ino and d_ino.

It only works if underlying lower and upper dirs are all on the same filesystem
(so there's only a single inode namespace to deal with).

Performance of readdir is probably dismal, definitely needs improving.

Readdir of overlay root doesn't get ino of "." right.  This probably needs
special casing.

And it doesn't yet deal with the hard link copy-up issue, which is a somewhat
separate problem.

Thanks,
Miklos

---
 fs/overlayfs/copy_up.c   |   16 +++++++--
 fs/overlayfs/dir.c       |    9 +----
 fs/overlayfs/inode.c     |   45 +++++++++++++++++++++++++--
 fs/overlayfs/namei.c     |   17 +++++++++-
 fs/overlayfs/overlayfs.h |    9 ++++-
 fs/overlayfs/ovl_entry.h |    1 
 fs/overlayfs/readdir.c   |   78 +++++++++++++++++++++++++++++++++++++----------
 fs/overlayfs/util.c      |   15 +++++++++
 8 files changed, 160 insertions(+), 30 deletions(-)

--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -177,6 +177,7 @@ int ovl_set_attr(struct dentry *upperden
 {
 	int err = 0;
 
+	inode_lock(upperdentry->d_inode);
 	if (!S_ISLNK(stat->mode)) {
 		struct iattr attr = {
 			.ia_valid = ATTR_MODE,
@@ -194,6 +195,15 @@ int ovl_set_attr(struct dentry *upperden
 	}
 	if (!err)
 		ovl_set_timestamps(upperdentry, stat);
+	inode_unlock(upperdentry->d_inode);
+
+	if (!err) {
+		char buf[17];
+
+		snprintf(buf, sizeof(buf), "%llx", stat->ino);
+		err = ovl_do_setxattr(upperdentry, OVL_XATTR_INO,
+				      buf, strlen(buf), 0);
+	}
 
 	return err;
 }
@@ -258,12 +268,12 @@ static int ovl_copy_up_locked(struct den
 	if (err)
 		goto out_cleanup;
 
-	inode_lock(newdentry->d_inode);
 	err = ovl_set_attr(newdentry, stat);
-	inode_unlock(newdentry->d_inode);
 	if (err)
 		goto out_cleanup;
 
+	ovl_dentry_set_ino(dentry, stat->ino);
+
 	err = ovl_do_rename(wdir, newdentry, udir, upper, 0);
 	if (err)
 		goto out_cleanup;
@@ -379,7 +389,7 @@ int ovl_copy_up(struct dentry *dentry)
 		}
 
 		ovl_path_lower(next, &lowerpath);
-		err = vfs_getattr(&lowerpath, &stat);
+		err = ovl_getattr_int(next, &lowerpath, &stat);
 		if (!err)
 			err = ovl_copy_up_one(parent, next, &lowerpath, &stat);
 
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -20,6 +20,7 @@ enum ovl_path_type {
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
 #define OVL_XATTR_REDIRECT OVL_XATTR_PREFIX "redirect"
+#define OVL_XATTR_INO OVL_XATTR_PREFIX "ino"
 
 #define OVL_ISUPPER_MASK 1UL
 
@@ -161,6 +162,8 @@ bool ovl_redirect_dir(struct super_block
 void ovl_clear_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
+u64 ovl_dentry_get_ino(struct dentry *dentry);
+void ovl_dentry_set_ino(struct dentry *dentry, u64 ino);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
@@ -171,9 +174,10 @@ bool ovl_is_whiteout(struct dentry *dent
 struct file *ovl_path_open(struct path *path, int flags);
 
 /* namei.c */
-int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
+int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
+struct dentry *ovl_dentry_at_idx(struct dentry *dentry, int idx);
 
 /* readdir.c */
 extern const struct file_operations ovl_dir_operations;
@@ -196,6 +200,9 @@ struct posix_acl *ovl_get_acl(struct ino
 int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
+int ovl_getattr_int(struct dentry *dentry, struct path *realpath,
+		    struct kstat *stat);
+void ovl_get_ino(struct dentry *realdentry, u64 *ino);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode);
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -15,6 +15,7 @@
 #include <linux/module.h>
 #include <linux/file.h>
 #include <linux/hashtable.h>
+#include <linux/ratelimit.h>
 #include "overlayfs.h"
 
 static int ovl_copy_up_truncate(struct dentry *dentry)
@@ -33,7 +34,7 @@ static int ovl_copy_up_truncate(struct d
 	ovl_path_lower(dentry, &lowerpath);
 
 	old_cred = ovl_override_creds(dentry->d_sb);
-	err = vfs_getattr(&lowerpath, &stat);
+	err = ovl_getattr_int(dentry, &lowerpath, &stat);
 	if (!err) {
 		stat.size = 0;
 		err = ovl_copy_up_one(parent, dentry, &lowerpath, &stat);
@@ -88,6 +89,46 @@ int ovl_setattr(struct dentry *dentry, s
 	return err;
 }
 
+void ovl_get_ino(struct dentry *realdentry, u64 *ino)
+{
+	int err;
+	char buf[18];
+
+	err = vfs_getxattr(realdentry, OVL_XATTR_INO,
+			   buf, sizeof(buf) - 1);
+	if (err < 0) {
+		if (err != -ENODATA && err != -EOPNOTSUPP)
+			pr_warn_ratelimited("overlay: failed to get ino (%i)\n", err);
+	} else {
+		buf[err] = '\0';
+		err = kstrtoull(buf, 16, ino);
+		if (err)
+			pr_warn("overlay: invalid ino (%s)\n", buf);
+	}
+}
+
+int ovl_getattr_int(struct dentry *dentry, struct path *realpath,
+		    struct kstat *stat)
+{
+	int err;
+	u64 ino;
+
+	err = vfs_getattr(realpath, stat);
+	if (err)
+		return err;
+
+	ino = ovl_dentry_get_ino(dentry);
+	if (!ino) {
+		ino = stat->ino;
+		ovl_get_ino(realpath->dentry, &ino);
+		ovl_dentry_set_ino(dentry, ino);
+	}
+	stat->dev = dentry->d_sb->s_dev;
+	stat->ino = ino;
+
+	return 0;
+}
+
 static int ovl_getattr(struct vfsmount *mnt, struct dentry *dentry,
 			 struct kstat *stat)
 {
@@ -97,7 +138,7 @@ static int ovl_getattr(struct vfsmount *
 
 	ovl_path_real(dentry, &realpath);
 	old_cred = ovl_override_creds(dentry->d_sb);
-	err = vfs_getattr(&realpath, stat);
+	err = ovl_getattr_int(dentry, &realpath, stat);
 	revert_creds(old_cred);
 	return err;
 }
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -36,6 +36,7 @@ struct ovl_entry {
 	union {
 		struct {
 			u64 version;
+			u64 ino;
 			const char *redirect;
 			bool opaque;
 		};
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -205,6 +205,21 @@ void ovl_dentry_set_redirect(struct dent
 	oe->redirect = redirect;
 }
 
+u64 ovl_dentry_get_ino(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	return oe->ino;
+}
+
+void ovl_dentry_set_ino(struct dentry *dentry, u64 ino)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	WARN_ON(oe->ino && oe->ino != ino);
+	oe->ino = ino;
+}
+
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -143,14 +143,11 @@ static int ovl_dir_getattr(struct vfsmou
 
 	type = ovl_path_real(dentry, &realpath);
 	old_cred = ovl_override_creds(dentry->d_sb);
-	err = vfs_getattr(&realpath, stat);
+	err = ovl_getattr_int(dentry, &realpath, stat);
 	revert_creds(old_cred);
 	if (err)
 		return err;
 
-	stat->dev = dentry->d_sb->s_dev;
-	stat->ino = dentry->d_inode->i_ino;
-
 	/*
 	 * It's probably not worth it to count subdirs to get the
 	 * correct link count.  nlink=1 seems to pacify 'find' and
@@ -250,7 +247,7 @@ static struct dentry *ovl_clear_empty(st
 		goto out;
 
 	ovl_path_upper(dentry, &upperpath);
-	err = vfs_getattr(&upperpath, &stat);
+	err = ovl_getattr_int(dentry, &upperpath, &stat);
 	if (err)
 		goto out_unlock;
 
@@ -278,9 +275,7 @@ static struct dentry *ovl_clear_empty(st
 	if (err)
 		goto out_cleanup;
 
-	inode_lock(opaquedir->d_inode);
 	err = ovl_set_attr(opaquedir, &stat);
-	inode_unlock(opaquedir->d_inode);
 	if (err)
 		goto out_cleanup;
 
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -186,23 +186,36 @@ static int ovl_lookup_layer(struct dentr
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
 }
 
+struct dentry *ovl_dentry_at_idx(struct dentry *dentry, int idx)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	if (idx == 0)
+		return ovl_upperdentry_dereference(oe);
+	else
+		return oe->lowerstack[idx - 1].dentry;
+}
+
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			  unsigned int flags)
 {
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -20,10 +20,12 @@
 struct ovl_cache_entry {
 	unsigned int len;
 	unsigned int type;
+	u64 orig_ino;
 	u64 ino;
 	struct list_head l_node;
 	struct rb_node node;
 	struct ovl_cache_entry *next_maybe_whiteout;
+	int idx;
 	bool is_whiteout;
 	char name[];
 };
@@ -36,13 +38,14 @@ struct ovl_dir_cache {
 
 struct ovl_readdir_data {
 	struct dir_context ctx;
-	struct dentry *dentry;
+	bool check_whiteouts;
 	bool is_lowest;
 	struct rb_root root;
 	struct list_head *list;
 	struct list_head middle;
 	struct ovl_cache_entry *first_maybe_whiteout;
 	int count;
+	int idx;
 	int err;
 	bool d_type_supported;
 };
@@ -97,8 +100,10 @@ static struct ovl_cache_entry *ovl_cache
 	p->name[len] = '\0';
 	p->len = len;
 	p->type = d_type;
-	p->ino = ino;
+	p->orig_ino = ino;
+	p->ino = 0;
 	p->is_whiteout = false;
+	p->idx = rdd->idx;
 
 	if (d_type == DT_CHR) {
 		p->next_maybe_whiteout = rdd->first_maybe_whiteout;
@@ -206,9 +211,6 @@ static int ovl_check_whiteouts(struct de
 	int err;
 	struct ovl_cache_entry *p;
 	struct dentry *dentry;
-	const struct cred *old_cred;
-
-	old_cred = ovl_override_creds(rdd->dentry->d_sb);
 
 	err = down_write_killable(&dir->d_inode->i_rwsem);
 	if (!err) {
@@ -223,7 +225,6 @@ static int ovl_check_whiteouts(struct de
 		}
 		inode_unlock(dir->d_inode);
 	}
-	revert_creds(old_cred);
 
 	return err;
 }
@@ -248,7 +249,7 @@ static inline int ovl_dir_read(struct pa
 			err = rdd->err;
 	} while (!err && rdd->count);
 
-	if (!err && rdd->first_maybe_whiteout && rdd->dentry)
+	if (!err && rdd->first_maybe_whiteout && rdd->check_whiteouts)
 		err = ovl_check_whiteouts(realpath->dentry, rdd);
 
 	fput(realfile);
@@ -268,7 +269,7 @@ static void ovl_dir_reset(struct file *f
 		od->cache = NULL;
 		od->cursor = NULL;
 	}
-	WARN_ON(!od->is_real && !OVL_TYPE_MERGE(type));
+//	WARN_ON(!od->is_real && !OVL_TYPE_MERGE(type));
 	if (od->is_real && OVL_TYPE_MERGE(type))
 		od->is_real = false;
 }
@@ -279,7 +280,7 @@ static int ovl_dir_read_merged(struct de
 	struct path realpath;
 	struct ovl_readdir_data rdd = {
 		.ctx.actor = ovl_fill_merge,
-		.dentry = dentry,
+		.check_whiteouts = true,
 		.list = list,
 		.root = RB_ROOT,
 		.is_lowest = false,
@@ -287,7 +288,7 @@ static int ovl_dir_read_merged(struct de
 	int idx, next;
 
 	for (idx = 0; idx != -1; idx = next) {
-		next = ovl_path_next(idx, dentry, &realpath);
+		next = ovl_path_next(idx, dentry, &realpath, &rdd.idx);
 
 		if (next != -1) {
 			err = ovl_dir_read(&realpath, &rdd);
@@ -353,11 +354,45 @@ static struct ovl_dir_cache *ovl_cache_g
 	return cache;
 }
 
+static int ovl_cache_entry_update_ino(struct dentry *dir,
+				      struct ovl_cache_entry *p)
+
+{
+	struct dentry *this;
+	struct dentry *base = ovl_dentry_at_idx(dir, p->idx);
+
+	if (p->name[0] == '.') {
+		if (p->len == 1) {
+			this = dget(base);
+			goto get;
+		}
+		if (p->len == 2 && p->name[1] == '.') {
+			/* ♫ we shall not be moved */
+			this = dget(ovl_dentry_real(dir->d_parent));
+			goto get;
+		}
+	}
+	this = lookup_one_len_unlocked(p->name, base, p->len);
+	if (IS_ERR(this)) {
+		pr_err("overlay: failed to look up (%s) for ino (%i)\n",
+		       p->name, (int) PTR_ERR(this));
+		return -EIO;
+	}
+	get:
+	p->ino = p->orig_ino;
+	ovl_get_ino(this, &p->ino);
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
+	const struct cred *old_cred;
+	int err;
 
 	if (!ctx->pos)
 		ovl_dir_reset(file);
@@ -365,12 +400,14 @@ static int ovl_iterate(struct file *file
 	if (od->is_real)
 		return iterate_dir(od->realfile, ctx);
 
+	old_cred = ovl_override_creds(dentry->d_sb);
 	if (!od->cache) {
 		struct ovl_dir_cache *cache;
 
 		cache = ovl_cache_get(dentry);
+		err = PTR_ERR(cache);
 		if (IS_ERR(cache))
-			return PTR_ERR(cache);
+			goto out;
 
 		od->cache = cache;
 		ovl_seek_cursor(od, ctx->pos);
@@ -378,13 +415,23 @@ static int ovl_iterate(struct file *file
 
 	while (od->cursor != &od->cache->entries) {
 		p = list_entry(od->cursor, struct ovl_cache_entry, l_node);
-		if (!p->is_whiteout)
+		if (!p->is_whiteout) {
+			if (!p->ino) {
+				err = ovl_cache_entry_update_ino(dentry, p);
+				if (err)
+					goto out;
+			}
 			if (!dir_emit(ctx, p->name, p->len, p->ino, p->type))
 				break;
+		}
 		od->cursor = p->l_node.next;
 		ctx->pos++;
 	}
-	return 0;
+	err = 0;
+out:
+	revert_creds(old_cred);
+
+	return err;
 }
 
 static loff_t ovl_dir_llseek(struct file *file, loff_t offset, int origin)
@@ -502,7 +549,8 @@ static int ovl_dir_open(struct inode *in
 		return PTR_ERR(realfile);
 	}
 	od->realfile = realfile;
-	od->is_real = !OVL_TYPE_MERGE(type);
+//	od->is_real = !OVL_TYPE_MERGE(type);
+	od->is_real = false;
 	od->is_upper = OVL_TYPE_UPPER(type);
 	file->private_data = od;
 
@@ -615,7 +663,7 @@ static void ovl_workdir_cleanup_recurse(
 	struct ovl_cache_entry *p;
 	struct ovl_readdir_data rdd = {
 		.ctx.actor = ovl_fill_merge,
-		.dentry = NULL,
+		.check_whiteouts = false,
 		.list = &list,
 		.root = RB_ROOT,
 		.is_lowest = false,
