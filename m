Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/5] ovl: generalize the lower_fs[] array
Date: Sun, 22 Dec 2019 10:07:57 +0200
Message-Id: <20191222080759.32035-4-amir73il@gmail.com>
In-Reply-To: <20191222080759.32035-1-amir73il@gmail.com>
References: <20191222080759.32035-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Rename lower_fs[] array to fs[], extend its size by one and use
index fsid (instead of fsid-1) to access the fs[] array.

Initialize fs[0] with upper fs values. fsid 0 is reserved even with
lower only overlay, so fs[0] remains null in this case.

This gets rid of special casing upper layer in ovl_map_dev_ino().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 31 +++++++++----------
 fs/overlayfs/ovl_entry.h |  6 ++--
 fs/overlayfs/super.c     | 66 +++++++++++++++++++++-------------------
 3 files changed, 52 insertions(+), 51 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b510e8408be3..09153dbe8090 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -75,8 +75,7 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	return err;
 }
 
-static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat,
-			   struct ovl_layer *lower_layer)
+static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat, int fsid)
 {
 	bool samefs = ovl_same_fs(dentry->d_sb);
 	unsigned int xinobits = ovl_xino_bits(dentry->d_sb);
@@ -103,9 +102,7 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat,
 			pr_warn_ratelimited("overlayfs: inode number too big (%pd2, ino=%llu, xinobits=%d)\n",
 					    dentry, stat->ino, xinobits);
 		} else {
-			if (lower_layer)
-				stat->ino |= ((u64)lower_layer->fsid) << shift;
-
+			stat->ino |= ((u64)fsid) << shift;
 			stat->dev = dentry->d_sb->s_dev;
 			return 0;
 		}
@@ -124,15 +121,15 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat,
 		 */
 		stat->dev = dentry->d_sb->s_dev;
 		stat->ino = dentry->d_inode->i_ino;
-	} else if (lower_layer && lower_layer->fsid) {
+	} else {
 		/*
 		 * For non-samefs setup, if we cannot map all layers st_ino
 		 * to a unified address space, we need to make sure that st_dev
-		 * is unique per lower fs. Upper layer uses real st_dev and
-		 * lower layers use the unique anonymous bdev assigned to the
-		 * lower fs.
+		 * is unique per lower fs. Layers that are on the same fs as
+		 * upper layer use real upper st_dev and other lower layers use
+		 * the unique anonymous bdev assigned to the lower fs.
 		 */
-		stat->dev = lower_layer->fs->pseudo_dev;
+		stat->dev = OVL_FS(dentry->d_sb)->fs[fsid].pseudo_dev;
 	}
 
 	return 0;
@@ -147,7 +144,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	const struct cred *old_cred;
 	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
 	bool samefs = ovl_same_fs(dentry->d_sb);
-	struct ovl_layer *lower_layer = NULL;
+	int fsid;
 	int err;
 	bool metacopy_blocks = false;
 
@@ -169,9 +166,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	 * persistent st_ino across mount cycle.
 	 */
 	if (!is_dir || ovl_same_dev(dentry->d_sb)) {
-		if (!OVL_TYPE_UPPER(type)) {
-			lower_layer = ovl_dentry_layer(dentry);
-		} else if (OVL_TYPE_ORIGIN(type)) {
+		fsid = ovl_dentry_layer(dentry)->fsid;
+		if (OVL_TYPE_ORIGIN(type)) {
 			struct kstat lowerstat;
 			u32 lowermask = STATX_INO | STATX_BLOCKS |
 					(!is_dir ? STATX_NLINK : 0);
@@ -200,14 +196,15 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) ||
 			    (!ovl_verify_lower(dentry->d_sb) &&
 			     (is_dir || lowerstat.nlink == 1))) {
-				lower_layer = ovl_dentry_layer(dentry);
 				/*
 				 * Cannot use origin st_dev;st_ino because
 				 * origin inode content may differ from overlay
 				 * inode content.
 				 */
-				if (samefs || lower_layer->fsid)
+				if (samefs || fsid)
 					stat->ino = lowerstat.ino;
+			} else {
+				fsid = 0;
 			}
 
 			/*
@@ -241,7 +238,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		}
 	}
 
-	err = ovl_map_dev_ino(dentry, stat, lower_layer);
+	err = ovl_map_dev_ino(dentry, stat, fsid);
 	if (err)
 		goto out;
 
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ef05817d8d89..4c1d3b20a4e8 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -46,10 +46,10 @@ struct ovl_path {
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
 	unsigned int numlower;
-	/* Number of unique lower sb that differ from upper sb */
-	unsigned int numlowerfs;
+	/* Number of unique fs among layers including upper fs */
+	unsigned int numfs;
 	struct ovl_layer *layers;
-	struct ovl_sb *lower_fs;
+	struct ovl_sb *fs;
 	/* workbasedir is the path at workdir= mount option */
 	struct dentry *workbasedir;
 	/* workdir is the 'work' directory under workbasedir */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 2d03ab26e202..8522c66134b5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -228,10 +228,13 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 		iput(ofs->layers[i].trap);
 		mntput(ofs->layers[i].mnt);
 	}
-	for (i = 0; i < ofs->numlowerfs; i++)
-		free_anon_bdev(ofs->lower_fs[i].pseudo_dev);
 	kfree(ofs->layers);
-	kfree(ofs->lower_fs);
+	if (ofs->fs) {
+		/* fs[0].pseudo_dev is either null or real upper st_dev */
+		for (i = 1; i < ofs->numfs; i++)
+			free_anon_bdev(ofs->fs[i].pseudo_dev);
+		kfree(ofs->fs);
+	}
 
 	kfree(ofs->config.lowerdir);
 	kfree(ofs->config.upperdir);
@@ -1253,7 +1256,7 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 	if (!ofs->config.nfs_export && !ofs->upper_mnt)
 		return true;
 
-	for (i = 0; i < ofs->numlowerfs; i++) {
+	for (i = 1; i < ofs->numfs; i++) {
 		/*
 		 * We use uuid to associate an overlay lower file handle with a
 		 * lower layer, so we can accept lower fs with null uuid as long
@@ -1261,8 +1264,8 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 		 * if we detect multiple lower fs with the same uuid, we
 		 * disable lower file handle decoding on all of them.
 		 */
-		if (uuid_equal(&ofs->lower_fs[i].sb->s_uuid, uuid)) {
-			ofs->lower_fs[i].bad_uuid = true;
+		if (uuid_equal(&ofs->fs[i].sb->s_uuid, uuid)) {
+			ofs->fs[i].bad_uuid = true;
 			return false;
 		}
 	}
@@ -1278,13 +1281,9 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 	int err;
 	bool bad_uuid = false;
 
-	/* fsid 0 is reserved for upper fs even with non upper overlay */
-	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
-		return 0;
-
-	for (i = 0; i < ofs->numlowerfs; i++) {
-		if (ofs->lower_fs[i].sb == sb)
-			return i + 1;
+	for (i = 0; i < ofs->numfs; i++) {
+		if (ofs->fs[i].sb == sb)
+			return i;
 	}
 
 	if (!ovl_lower_uuid_ok(ofs, &sb->s_uuid)) {
@@ -1305,12 +1304,11 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 		return err;
 	}
 
-	ofs->lower_fs[ofs->numlowerfs].sb = sb;
-	ofs->lower_fs[ofs->numlowerfs].pseudo_dev = dev;
-	ofs->lower_fs[ofs->numlowerfs].bad_uuid = bad_uuid;
-	ofs->numlowerfs++;
+	ofs->fs[ofs->numfs].sb = sb;
+	ofs->fs[ofs->numfs].pseudo_dev = dev;
+	ofs->fs[ofs->numfs].bad_uuid = bad_uuid;
 
-	return ofs->numlowerfs;
+	return ofs->numfs++;
 }
 
 static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
@@ -1325,16 +1323,25 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	if (ofs->layers == NULL)
 		goto out;
 
-	ofs->lower_fs = kcalloc(numlower, sizeof(struct ovl_sb),
-				GFP_KERNEL);
-	if (ofs->lower_fs == NULL)
+	ofs->fs = kcalloc(numlower + 1, sizeof(struct ovl_sb), GFP_KERNEL);
+	if (ofs->fs == NULL)
 		goto out;
 
-	/* idx 0 is reserved for upper fs even with lower only overlay */
+	/* idx/fsid 0 are reserved for upper fs even with lower only overlay */
+	ofs->numfs++;
 	ofs->layers[0].mnt = ofs->upper_mnt;
 	ofs->layers[0].idx = 0;
 	ofs->layers[0].fsid = 0;
 
+	/*
+	 * All lower layers that share the same fs as upper layer, use the real
+	 * upper st_dev.
+	 */
+	if (ofs->upper_mnt) {
+		ofs->fs[0].sb = ofs->upper_mnt->mnt_sb;
+		ofs->fs[0].pseudo_dev = ofs->upper_mnt->mnt_sb->s_dev;
+	}
+
 	for (i = 0; i < numlower; i++) {
 		struct vfsmount *mnt;
 		struct inode *trap;
@@ -1373,10 +1380,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		ofs->layers[ofs->numlower].mnt = mnt;
 		ofs->layers[ofs->numlower].idx = ofs->numlower;
 		ofs->layers[ofs->numlower].fsid = fsid;
-		if (fsid) {
-			ofs->layers[ofs->numlower].fs =
-				&ofs->lower_fs[fsid - 1];
-		}
+		ofs->layers[ofs->numlower].fs = &ofs->fs[fsid];
 	}
 
 	/*
@@ -1387,19 +1391,19 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	 * bits reserved for fsid, it emits a warning and uses the original
 	 * inode number.
 	 */
-	if (!ofs->numlowerfs || (ofs->numlowerfs == 1 && !ofs->upper_mnt)) {
+	if (ofs->numfs == 1 || (ofs->numfs == 2 && !ofs->upper_mnt)) {
 		if (ofs->config.xino == OVL_XINO_ON)
 			pr_info("overlayfs: \"xino=on\" is useless with all layers on same fs, ignore.\n");
 		ofs->xino_bits = 0;
 		ofs->config.xino = OVL_XINO_SAME_FS;
 	} else if (ofs->config.xino == OVL_XINO_ON && !ofs->xino_bits) {
 		/*
-		 * This is a roundup of number of bits needed for numlowerfs+1
-		 * (i.e. ilog2(numlowerfs+1 - 1) + 1). fsid 0 is reserved for
-		 * upper fs even with non upper overlay.
+		 * This is a roundup of number of bits needed for encoding
+		 * fsid, where fsid 0 is reserved for upper fs even with
+		 * lower only overlay.
 		 */
 		BUILD_BUG_ON(ilog2(OVL_MAX_STACK) > 31);
-		ofs->xino_bits = ilog2(ofs->numlowerfs) + 1;
+		ofs->xino_bits = ilog2(ofs->numfs - 1) + 1;
 	}
 
 	if (ofs->xino_bits) {
-- 
2.17.1
