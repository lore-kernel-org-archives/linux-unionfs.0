Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v9 5/7] ovl: consistent d_ino for non-samefs with xino
Date: Thu, 29 Mar 2018 17:18:51 +0300
Message-Id: <1522333133-24772-6-git-send-email-amir73il@gmail.com>
In-Reply-To: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

When overlay layers are not all on the same fs, but all inode numbers
of underlying fs do not use the high 'xino' bits, overlay st_ino values
are constant and persistent.

In that case, relax non-samefs constraint for consistent d_ino and always
iterate non-merge dir using ovl_fill_real() actor so we can remap lower
inode numbers to unique lower fs range.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index c11f5c0906c3..ef1fe42ff7bb 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -120,6 +120,10 @@ static bool ovl_calc_d_ino(struct ovl_readdir_data *rdd,
 	if (!rdd->dentry)
 		return false;
 
+	/* Always recalc d_ino when remapping lower inode numbers */
+	if (ovl_xino_bits(rdd->dentry->d_sb))
+		return true;
+
 	/* Always recalc d_ino for parent */
 	if (strcmp(p->name, "..") == 0)
 		return true;
@@ -435,6 +439,19 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	return cache;
 }
 
+/* Map inode number to lower fs unique range */
+static u64 ovl_remap_lower_ino(u64 ino, int xinobits, int fsid,
+			       const char *name, int namelen)
+{
+	if (ino >> (64 - xinobits)) {
+		pr_warn_ratelimited("overlayfs: d_ino too big (%.*s, ino=%llu, xinobits=%d)\n",
+				    namelen, name, ino, xinobits);
+		return ino;
+	}
+
+	return ino | ((u64)fsid) << (64 - xinobits);
+}
+
 /*
  * Set d_ino for upper entries. Non-upper entries should always report
  * the uppermost real inode ino and should not call this function.
@@ -452,9 +469,10 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 	struct dentry *this = NULL;
 	enum ovl_path_type type;
 	u64 ino = p->real_ino;
+	int xinobits = ovl_xino_bits(dir->d_sb);
 	int err = 0;
 
-	if (!ovl_same_sb(dir->d_sb))
+	if (!ovl_same_sb(dir->d_sb) && !xinobits)
 		goto out;
 
 	if (p->name[0] == '.') {
@@ -491,6 +509,10 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 
 		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
 		ino = stat.ino;
+	} else if (xinobits && !OVL_TYPE_UPPER(type)) {
+		ino = ovl_remap_lower_ino(ino, xinobits,
+					  ovl_layer_lower(this)->fsid,
+					  p->name, p->len);
 	}
 
 out:
@@ -618,6 +640,8 @@ struct ovl_readdir_translate {
 	struct ovl_dir_cache *cache;
 	struct dir_context ctx;
 	u64 parent_ino;
+	int fsid;
+	int xinobits;
 };
 
 static int ovl_fill_real(struct dir_context *ctx, const char *name,
@@ -628,14 +652,17 @@ static int ovl_fill_real(struct dir_context *ctx, const char *name,
 		container_of(ctx, struct ovl_readdir_translate, ctx);
 	struct dir_context *orig_ctx = rdt->orig_ctx;
 
-	if (rdt->parent_ino && strcmp(name, "..") == 0)
+	if (rdt->parent_ino && strcmp(name, "..") == 0) {
 		ino = rdt->parent_ino;
-	else if (rdt->cache) {
+	} else if (rdt->cache) {
 		struct ovl_cache_entry *p;
 
 		p = ovl_cache_entry_find(&rdt->cache->root, name, namelen);
 		if (p)
 			ino = p->ino;
+	} else if (rdt->xinobits) {
+		ino = ovl_remap_lower_ino(ino, rdt->xinobits, rdt->fsid,
+					  name, namelen);
 	}
 
 	return orig_ctx->actor(orig_ctx, name, namelen, offset, ino, d_type);
@@ -646,11 +673,16 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	int err;
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dir = file->f_path.dentry;
+	struct ovl_layer *lower_layer = ovl_layer_lower(dir);
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
+		.xinobits = ovl_xino_bits(dir->d_sb),
 	};
 
+	if (rdt.xinobits && lower_layer)
+		rdt.fsid = lower_layer->fsid;
+
 	if (OVL_TYPE_MERGE(ovl_path_type(dir->d_parent))) {
 		struct kstat stat;
 		struct path statpath = file->f_path;
@@ -693,9 +725,10 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
 		 * dir is impure then need to adjust d_ino for copied up
 		 * entries.
 		 */
-		if (ovl_same_sb(dentry->d_sb) &&
-		    (ovl_test_flag(OVL_IMPURE, d_inode(dentry)) ||
-		     OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent)))) {
+		if (ovl_xino_bits(dentry->d_sb) ||
+		    (ovl_same_sb(dentry->d_sb) &&
+		     (ovl_test_flag(OVL_IMPURE, d_inode(dentry)) ||
+		      OVL_TYPE_MERGE(ovl_path_type(dentry->d_parent))))) {
 			return ovl_iterate_real(file, ctx);
 		}
 		return iterate_dir(od->realfile, ctx);
-- 
2.7.4
