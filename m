From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 8/9] ovl: consistent d_ino for non-samefs with xino
Date: Tue,  7 Nov 2017 18:58:08 +0200
Message-ID: <1510073889-11657-9-git-send-email-amir73il@gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:46558 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1758218AbdKGQ5m (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:57:42 -0500
Received: by mail-wm0-f67.google.com with SMTP id r68so5177070wmr.1
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 08:57:41 -0800 (PST)
In-Reply-To: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

When overlay layers are not all on the same fs, but all inode numbers
of underlying fs do not use the high 'xino' bits, overlay st_ino values
are constant and persistent.

In that case, relax non-samefs constraint for consistent d_ino and always
iterate non-merge dir using ovl_fill_real() actor so we can remap lower
inode numbers to unique layer range.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/readdir.c | 45 +++++++++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 4f2479b6ef91..92a6dcdbdaf7 100644
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
@@ -440,6 +444,19 @@ static struct ovl_dir_cache *ovl_cache_get(struct dentry *dentry)
 	return cache;
 }
 
+/* Map inode number to lower layer unique range */
+static u64 ovl_remap_lower_ino(u64 ino, int xinobits, int idx,
+			       const char *name, int namelen)
+{
+	if (ino >> (64 - xinobits)) {
+		pr_warn_ratelimited("overlayfs: d_ino too big (%.*s, ino=%llu, xinobits=%d)\n",
+				    namelen, name, ino, xinobits);
+		return ino;
+	}
+
+	return ino | ((u64)idx) << (64 - xinobits);
+}
+
 /*
  * Set d_ino for upper entries. Non-upper entries should always report
  * the uppermost real inode ino and should not call this function.
@@ -457,9 +474,10 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 	struct dentry *this = NULL;
 	enum ovl_path_type type;
 	u64 ino = p->real_ino;
+	int xinobits = ovl_xino_bits(dir->d_sb);
 	int err = 0;
 
-	if (!ovl_same_sb(dir->d_sb))
+	if (!ovl_same_sb(dir->d_sb) && !xinobits)
 		goto out;
 
 	if (p->name[0] == '.') {
@@ -496,6 +514,10 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 
 		WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
 		ino = stat.ino;
+	} else if (xinobits && !OVL_TYPE_UPPER(type)) {
+		ino = ovl_remap_lower_ino(ino, xinobits,
+					  ovl_layer_lower(this)->idx,
+					  p->name, p->len);
 	}
 
 out:
@@ -616,6 +638,8 @@ struct ovl_readdir_translate {
 	struct ovl_dir_cache *cache;
 	struct dir_context ctx;
 	u64 parent_ino;
+	int layer_idx;
+	int xinobits;
 };
 
 static int ovl_fill_real(struct dir_context *ctx, const char *name,
@@ -626,14 +650,17 @@ static int ovl_fill_real(struct dir_context *ctx, const char *name,
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
+		ino = ovl_remap_lower_ino(ino, rdt->xinobits, rdt->layer_idx,
+					  name, namelen);
 	}
 
 	return orig_ctx->actor(orig_ctx, name, namelen, offset, ino, d_type);
@@ -644,11 +671,16 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
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
+		rdt.layer_idx = lower_layer->idx;
+
 	if (OVL_TYPE_MERGE(ovl_path_type(dir->d_parent))) {
 		struct kstat stat;
 		struct path statpath = file->f_path;
@@ -688,9 +720,10 @@ static int ovl_iterate(struct file *file, struct dir_context *ctx)
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
