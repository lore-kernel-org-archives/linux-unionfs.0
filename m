Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/6] ovl: generalize the lower_layers[] array
Date: Sun, 17 Nov 2019 17:43:45 +0200
Message-Id: <20191117154349.28695-3-amir73il@gmail.com>
In-Reply-To: <20191117154349.28695-1-amir73il@gmail.com>
References: <20191117154349.28695-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Colin Ian King <colin.king@canonical.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Rename lower_layers[] array to layers[], extend its size by one
and initialize layers[0] with upper layer values.
Lower layers are now addressed with index 1..numlower.
layers[0] is reserved even with lower only overlay.

This gets rid of special casing upper layer in ovl_iterate_real().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    |  6 ++----
 fs/overlayfs/inode.c     |  4 ++--
 fs/overlayfs/namei.c     | 10 +++++-----
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/ovl_entry.h |  2 +-
 fs/overlayfs/readdir.c   |  7 +++----
 fs/overlayfs/super.c     | 43 ++++++++++++++++++++++------------------
 fs/overlayfs/util.c      |  6 ++++--
 8 files changed, 42 insertions(+), 38 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 70e55588aedc..9128cbb3b198 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -424,7 +424,6 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
 					    struct ovl_layer *layer)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
-	struct ovl_layer upper_layer = { .mnt = ofs->upper_mnt };
 	struct dentry *index = NULL;
 	struct dentry *this = NULL;
 	struct inode *inode;
@@ -466,7 +465,7 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
 		 * recursive call walks back from indexed upper to the topmost
 		 * connected/hashed upper parent (or up to root).
 		 */
-		this = ovl_lookup_real(sb, upper, &upper_layer);
+		this = ovl_lookup_real(sb, upper, &ofs->layers[0]);
 		dput(upper);
 	}
 
@@ -646,8 +645,7 @@ static struct dentry *ovl_get_dentry(struct super_block *sb,
 				     struct dentry *index)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
-	struct ovl_layer upper_layer = { .mnt = ofs->upper_mnt };
-	struct ovl_layer *layer = upper ? &upper_layer : lowerpath->layer;
+	struct ovl_layer *layer = upper ? &ofs->layers[0] : lowerpath->layer;
 	struct dentry *real = upper ?: (index ?: lowerpath->dentry);
 
 	/*
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b045cf1826fc..dab39933bbd4 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -170,7 +170,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	 */
 	if (!is_dir || samefs || ovl_xino_bits(dentry->d_sb)) {
 		if (!OVL_TYPE_UPPER(type)) {
-			lower_layer = ovl_layer_lower(dentry);
+			lower_layer = ovl_dentry_layer(dentry);
 		} else if (OVL_TYPE_ORIGIN(type)) {
 			struct kstat lowerstat;
 			u32 lowermask = STATX_INO | STATX_BLOCKS |
@@ -200,7 +200,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) ||
 			    (!ovl_verify_lower(dentry->d_sb) &&
 			     (is_dir || lowerstat.nlink == 1))) {
-				lower_layer = ovl_layer_lower(dentry);
+				lower_layer = ovl_dentry_layer(dentry);
 				/*
 				 * Cannot use origin st_dev;st_ino because
 				 * origin inode content may differ from overlay
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 80fbca5219d4..f16bf608eed7 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -324,16 +324,16 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 	struct dentry *origin = NULL;
 	int i;
 
-	for (i = 0; i < ofs->numlower; i++) {
+	for (i = 1; i <= ofs->numlower; i++) {
 		/*
 		 * If lower fs uuid is not unique among lower fs we cannot match
 		 * fh->uuid to layer.
 		 */
-		if (ofs->lower_layers[i].fsid &&
-		    ofs->lower_layers[i].fs->bad_uuid)
+		if (ofs->layers[i].fsid &&
+		    ofs->layers[i].fs->bad_uuid)
 			continue;
 
-		origin = ovl_decode_real_fh(fh, ofs->lower_layers[i].mnt,
+		origin = ovl_decode_real_fh(fh, ofs->layers[i].mnt,
 					    connected);
 		if (origin)
 			break;
@@ -356,7 +356,7 @@ int ovl_check_origin_fh(struct ovl_fs *ofs, struct ovl_fh *fh, bool connected,
 	}
 	**stackp = (struct ovl_path){
 		.dentry = origin,
-		.layer = &ofs->lower_layers[i]
+		.layer = &ofs->layers[i]
 	};
 
 	return 0;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f283b1d69a9e..50d41a314308 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -237,7 +237,7 @@ enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_lowerdata(struct dentry *dentry);
-struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
+struct ovl_layer *ovl_dentry_layer(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 28348c44ea5b..ffaf7376f4ab 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -48,7 +48,7 @@ struct ovl_fs {
 	unsigned int numlower;
 	/* Number of unique lower sb that differ from upper sb */
 	unsigned int numlowerfs;
-	struct ovl_layer *lower_layers;
+	struct ovl_layer *layers;
 	struct ovl_sb *lower_fs;
 	/* workbasedir is the path at workdir= mount option */
 	struct dentry *workbasedir;
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 47a91c9733a5..32a7f8a38091 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -508,7 +508,7 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
 		ino = stat.ino;
 	} else if (xinobits && !OVL_TYPE_UPPER(type)) {
 		ino = ovl_remap_lower_ino(ino, xinobits,
-					  ovl_layer_lower(this)->fsid,
+					  ovl_dentry_layer(this)->fsid,
 					  p->name, p->len);
 	}
 
@@ -685,15 +685,14 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	int err;
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dir = file->f_path.dentry;
-	struct ovl_layer *lower_layer = ovl_layer_lower(dir);
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
 		.xinobits = ovl_xino_bits(dir->d_sb),
 	};
 
-	if (rdt.xinobits && lower_layer)
-		rdt.fsid = lower_layer->fsid;
+	if (rdt.xinobits)
+		rdt.fsid = ovl_dentry_layer(dir)->fsid;
 
 	if (OVL_TYPE_MERGE(ovl_path_type(dir->d_parent))) {
 		struct kstat stat;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index cfb236e37fd9..4ff6eede5f90 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -224,13 +224,13 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	if (ofs->upperdir_locked)
 		ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
 	mntput(ofs->upper_mnt);
-	for (i = 0; i < ofs->numlower; i++) {
-		iput(ofs->lower_layers[i].trap);
-		mntput(ofs->lower_layers[i].mnt);
+	for (i = 1; i <= ofs->numlower; i++) {
+		iput(ofs->layers[i].trap);
+		mntput(ofs->layers[i].mnt);
 	}
 	for (i = 0; i < ofs->numlowerfs; i++)
 		free_anon_bdev(ofs->lower_fs[i].pseudo_dev);
-	kfree(ofs->lower_layers);
+	kfree(ofs->layers);
 	kfree(ofs->lower_fs);
 
 	kfree(ofs->config.lowerdir);
@@ -1318,16 +1318,16 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 	return ofs->numlowerfs;
 }
 
-static int ovl_get_lower_layers(struct super_block *sb, struct ovl_fs *ofs,
-				struct path *stack, unsigned int numlower)
+static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
+			  struct path *stack, unsigned int numlower)
 {
 	int err;
 	unsigned int i;
 
 	err = -ENOMEM;
-	ofs->lower_layers = kcalloc(numlower, sizeof(struct ovl_layer),
-				    GFP_KERNEL);
-	if (ofs->lower_layers == NULL)
+	ofs->layers = kcalloc(numlower + 1, sizeof(struct ovl_layer),
+			      GFP_KERNEL);
+	if (ofs->layers == NULL)
 		goto out;
 
 	ofs->lower_fs = kcalloc(numlower, sizeof(struct ovl_sb),
@@ -1335,6 +1335,11 @@ static int ovl_get_lower_layers(struct super_block *sb, struct ovl_fs *ofs,
 	if (ofs->lower_fs == NULL)
 		goto out;
 
+	/* idx 0 is reserved for upper fs even with lower only overlay */
+	ofs->layers[0].mnt = ofs->upper_mnt;
+	ofs->layers[0].idx = 0;
+	ofs->layers[0].fsid = 0;
+
 	for (i = 0; i < numlower; i++) {
 		struct vfsmount *mnt;
 		struct inode *trap;
@@ -1368,15 +1373,15 @@ static int ovl_get_lower_layers(struct super_block *sb, struct ovl_fs *ofs,
 		 */
 		mnt->mnt_flags |= MNT_READONLY | MNT_NOATIME;
 
-		ofs->lower_layers[ofs->numlower].trap = trap;
-		ofs->lower_layers[ofs->numlower].mnt = mnt;
-		ofs->lower_layers[ofs->numlower].idx = i + 1;
-		ofs->lower_layers[ofs->numlower].fsid = fsid;
+		ofs->numlower++;
+		ofs->layers[ofs->numlower].trap = trap;
+		ofs->layers[ofs->numlower].mnt = mnt;
+		ofs->layers[ofs->numlower].idx = ofs->numlower;
+		ofs->layers[ofs->numlower].fsid = fsid;
 		if (fsid) {
-			ofs->lower_layers[ofs->numlower].fs =
+			ofs->layers[ofs->numlower].fs =
 				&ofs->lower_fs[fsid - 1];
 		}
-		ofs->numlower++;
 	}
 
 	/*
@@ -1463,7 +1468,7 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 		goto out_err;
 	}
 
-	err = ovl_get_lower_layers(sb, ofs, stack, numlower);
+	err = ovl_get_layers(sb, ofs, stack, numlower);
 	if (err)
 		goto out_err;
 
@@ -1474,7 +1479,7 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 
 	for (i = 0; i < numlower; i++) {
 		oe->lowerstack[i].dentry = dget(stack[i].dentry);
-		oe->lowerstack[i].layer = &ofs->lower_layers[i];
+		oe->lowerstack[i].layer = &ofs->layers[i+1];
 	}
 
 	if (remote)
@@ -1555,9 +1560,9 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 			return err;
 	}
 
-	for (i = 0; i < ofs->numlower; i++) {
+	for (i = 1; i <= ofs->numlower; i++) {
 		err = ovl_check_layer(sb, ofs,
-				      ofs->lower_layers[i].mnt->mnt_root,
+				      ofs->layers[i].mnt->mnt_root,
 				      "lowerdir");
 		if (err)
 			return err;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f5678a3f8350..3fa1ca8ddd48 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -198,11 +198,13 @@ struct dentry *ovl_dentry_lower(struct dentry *dentry)
 	return oe->numlower ? oe->lowerstack[0].dentry : NULL;
 }
 
-struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
+/* Either top most lower layer or upper layer for pure upper */
+struct ovl_layer *ovl_dentry_layer(struct dentry *dentry)
 {
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	return oe->numlower ? oe->lowerstack[0].layer : NULL;
+	return oe->numlower ? oe->lowerstack[0].layer : &ofs->layers[0];
 }
 
 /*
-- 
2.17.1
