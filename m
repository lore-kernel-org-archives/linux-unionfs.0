Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v9 2/7] ovl: allocate anon bdev per unique lower fs
Date: Thu, 29 Mar 2018 17:18:48 +0300
Message-Id: <1522333133-24772-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Instead of allocating an anonymous bdev per lower layer, allocate
one anonymous bdev per every unique lower fs that is different than
upper fs.

Every unique lower fs is assigned an fsid > 0 and the number of
unique lower fs are stored in ofs->numlowerfs.

The assigned fsid is stored in the lower layer struct and will be
used also for inode number multiplexing.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     |  9 ++++---
 fs/overlayfs/ovl_entry.h | 18 +++++++++----
 fs/overlayfs/super.c     | 66 +++++++++++++++++++++++++++++++++++-------------
 fs/overlayfs/util.c      |  7 ++++-
 4 files changed, 72 insertions(+), 28 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1ae53357b228..89dfab20fe0e 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -83,14 +83,15 @@ static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat)
 		 */
 		stat->dev = dentry->d_sb->s_dev;
 		stat->ino = dentry->d_inode->i_ino;
-	} else if (lower_layer) {
+	} else if (lower_layer && lower_layer->fsid) {
 		/*
 		 * For non-samefs setup, if we cannot map all layers st_ino
 		 * to a unified address space, we need to make sure that st_dev
-		 * is unique per layer. Upper layer uses real st_dev and lower
-		 * layers use the unique anonymous bdev.
+		 * is unique per lower fs. Upper layer uses real st_dev and
+		 * lower layers use the unique anonymous bdev assigned to the
+		 * lower fs.
 		 */
-		stat->dev = lower_layer->pseudo_dev;
+		stat->dev = lower_layer->fs->pseudo_dev;
 	}
 
 	return 0;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index bfef6edcc111..e1c838c27a74 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -20,11 +20,18 @@ struct ovl_config {
 	bool nfs_export;
 };
 
+struct ovl_sb {
+	struct super_block *sb;
+	dev_t pseudo_dev;
+};
+
 struct ovl_layer {
 	struct vfsmount *mnt;
-	dev_t pseudo_dev;
-	/* Index of this layer in fs root (upper == 0) */
+	struct ovl_sb *fs;
+	/* Index of this layer in fs root (upper idx == 0) */
 	int idx;
+	/* One fsid per unique underlying sb (upper fsid == 0) */
+	int fsid;
 };
 
 struct ovl_path {
@@ -35,8 +42,11 @@ struct ovl_path {
 /* private information held for overlayfs's superblock */
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
-	unsigned numlower;
+	unsigned int numlower;
+	/* Number of unique lower sb that differ from upper sb */
+	unsigned int numlowerfs;
 	struct ovl_layer *lower_layers;
+	struct ovl_sb *lower_fs;
 	/* workbasedir is the path at workdir= mount option */
 	struct dentry *workbasedir;
 	/* workdir is the 'work' directory under workbasedir */
@@ -50,8 +60,6 @@ struct ovl_fs {
 	const struct cred *creator_cred;
 	bool tmpfile;
 	bool noxattr;
-	/* sb common to all layers */
-	struct super_block *same_sb;
 	/* Did we take the inuse lock? */
 	bool upperdir_locked;
 	bool workdir_locked;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7c24619ae7fc..7d97d30cad39 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -236,11 +236,12 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	if (ofs->upperdir_locked)
 		ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
 	mntput(ofs->upper_mnt);
-	for (i = 0; i < ofs->numlower; i++) {
+	for (i = 0; i < ofs->numlower; i++)
 		mntput(ofs->lower_layers[i].mnt);
-		free_anon_bdev(ofs->lower_layers[i].pseudo_dev);
-	}
+	for (i = 0; i < ofs->numlowerfs; i++)
+		free_anon_bdev(ofs->lower_fs[i].pseudo_dev);
 	kfree(ofs->lower_layers);
+	kfree(ofs->lower_fs);
 
 	kfree(ofs->config.lowerdir);
 	kfree(ofs->config.upperdir);
@@ -1108,6 +1109,35 @@ static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
 	return err;
 }
 
+/* Get a unique fsid for the layer */
+static int ovl_get_fsid(struct ovl_fs *ofs, struct super_block *sb)
+{
+	unsigned int i;
+	dev_t dev;
+	int err;
+
+	/* fsid 0 is reserved for upper fs even with non upper overlay */
+	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
+		return 0;
+
+	for (i = 0; i < ofs->numlowerfs; i++) {
+		if (ofs->lower_fs[i].sb == sb)
+			return i + 1;
+	}
+
+	err = get_anon_bdev(&dev);
+	if (err) {
+		pr_err("overlayfs: failed to get anonymous bdev for lowerpath\n");
+		return err;
+	}
+
+	ofs->lower_fs[ofs->numlowerfs].sb = sb;
+	ofs->lower_fs[ofs->numlowerfs].pseudo_dev = dev;
+	ofs->numlowerfs++;
+
+	return ofs->numlowerfs;
+}
+
 static int ovl_get_lower_layers(struct ovl_fs *ofs, struct path *stack,
 				unsigned int numlower)
 {
@@ -1119,23 +1149,27 @@ static int ovl_get_lower_layers(struct ovl_fs *ofs, struct path *stack,
 				    GFP_KERNEL);
 	if (ofs->lower_layers == NULL)
 		goto out;
+
+	ofs->lower_fs = kcalloc(numlower, sizeof(struct ovl_sb),
+				GFP_KERNEL);
+	if (ofs->lower_fs == NULL)
+		goto out;
+
 	for (i = 0; i < numlower; i++) {
 		struct vfsmount *mnt;
-		dev_t dev;
+		int fsid;
 
-		err = get_anon_bdev(&dev);
-		if (err) {
-			pr_err("overlayfs: failed to get anonymous bdev for lowerpath\n");
+		err = fsid = ovl_get_fsid(ofs, stack[i].mnt->mnt_sb);
+		if (err < 0)
 			goto out;
-		}
 
 		mnt = clone_private_mount(&stack[i]);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
 			pr_err("overlayfs: failed to clone lowerpath\n");
-			free_anon_bdev(dev);
 			goto out;
 		}
+
 		/*
 		 * Make lower layers R/O.  That way fchmod/fchown on lower file
 		 * will fail instead of modifying lower fs.
@@ -1143,15 +1177,13 @@ static int ovl_get_lower_layers(struct ovl_fs *ofs, struct path *stack,
 		mnt->mnt_flags |= MNT_READONLY | MNT_NOATIME;
 
 		ofs->lower_layers[ofs->numlower].mnt = mnt;
-		ofs->lower_layers[ofs->numlower].pseudo_dev = dev;
 		ofs->lower_layers[ofs->numlower].idx = i + 1;
+		ofs->lower_layers[ofs->numlower].fsid = fsid;
+		if (fsid) {
+			ofs->lower_layers[ofs->numlower].fs =
+				&ofs->lower_fs[fsid - 1];
+		}
 		ofs->numlower++;
-
-		/* Check if all lower layers are on same sb */
-		if (i == 0)
-			ofs->same_sb = mnt->mnt_sb;
-		else if (ofs->same_sb != mnt->mnt_sb)
-			ofs->same_sb = NULL;
 	}
 	err = 0;
 out:
@@ -1305,8 +1337,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
 	if (!ofs->upper_mnt)
 		sb->s_flags |= SB_RDONLY;
-	else if (ofs->upper_mnt->mnt_sb != ofs->same_sb)
-		ofs->same_sb = NULL;
 
 	if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
 		err = ovl_get_indexdir(ofs, oe, &upperpath);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 5042293d2078..9dfec74ec77d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -47,7 +47,12 @@ struct super_block *ovl_same_sb(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
 
-	return ofs->same_sb;
+	if (!ofs->numlowerfs)
+		return ofs->upper_mnt->mnt_sb;
+	else if (ofs->numlowerfs == 1 && !ofs->upper_mnt)
+		return ofs->lower_fs[0].sb;
+	else
+		return NULL;
 }
 
 bool ovl_can_decode_fh(struct super_block *sb)
-- 
2.7.4
