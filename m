Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/3] ovl: limit xino for some nested overlay cases
Date: Thu,  8 Nov 2018 13:49:41 +0200
Message-Id: <20181108114942.32531-3-amir73il@gmail.com>
In-Reply-To: <20181108114942.32531-1-amir73il@gmail.com>
References: <20181108114942.32531-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

When overlayfs is nested over a lower overlayfs and lower overlayfs
layers are not all on the same underlying fs, there are three cases
to consider:

1. lower overlay is non-samefs with xino=on
2. lower overlay is non-samefs with xino=off
3. lower overlay is non-samefs with xino=auto and all underlying
   fs use 32bit inode numbers

In the first case, lower layer uses the most significant inode number
bits, so they are not available for the nested overlay and xino should
be disabled.

In the second case, inode numbers of lower layer are not in a single
inode numbers domain, so there is no use enabling xino in nested overlay.

In the last case, the lower overlayfs advertises how many high ino bits
are available for use by next level stacked fs, so we use this
information to determine if the available bits are enough to encode the
nested overlay layer fsid.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 189 +++++++++++++++++++++++++++++++++----------
 1 file changed, 148 insertions(+), 41 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 1afe67c4599a..c7acc3d39b5f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -774,9 +774,67 @@ static int ovl_check_namelen(struct path *path, struct ovl_fs *ofs,
 	return err;
 }
 
-static int ovl_lower_dir(const char *name, struct path *path,
-			 struct ovl_fs *ofs, unsigned short *stack_depth,
-			 bool *remote)
+static void ovl_update_xino_bits(struct ovl_fs *ofs,
+				 struct super_block *real_sb, int fh_type)
+{
+	unsigned int xinobits = BITS_PER_LONG - real_sb->s_max_ino_bits;
+
+	if (ofs->config.xino == OVL_XINO_OFF) {
+		ofs->xino_bits = 0;
+		return;
+	}
+
+	/*
+	 * Check if underlying fs advertises that it uses all ino bits or that
+	 * it doesn't have an ino domain. A private case of the former is a non
+	 * same fs overlayfs with xino=on. A private case of the latter is a non
+	 * same fs overlayfs with xino=off.
+	 */
+	if (!real_sb->s_ino_domain || !xinobits) {
+		pr_warn("overlayfs: no high bits available for xino, falling back to xino=off.\n");
+		ofs->config.xino = OVL_XINO_OFF;
+		ofs->xino_bits = 0;
+		goto out;
+	}
+
+	/*
+	 * If underlying fs does not advertises maximum ino bits, we assume
+	 * for the sake of xino=auto, that the high bits are not available, but
+	 * if we see that underlying fs encodes file handles with 32bit inode
+	 * numbers, we know that it doesn't use the high ino bits.
+	 *
+	 * Not advertising maximum ino bits it not the same as advertizing that
+	 * all ino bits are used (case above). In the case of not advertised
+	 * maximum ino bits, we give the user the benefit of doubt and will
+	 * allow user to request using high ino bits with xino=on.
+	 */
+	if (real_sb->s_max_ino_bits)
+		ofs->xino_bits = min(ofs->xino_bits, xinobits);
+	else if (fh_type != FILEID_INO32_GEN)
+		ofs->xino_bits = 0;
+
+out:
+	pr_debug("%s: id=%s, max_ino_bits=%u, ino_domain=%x, fh_type=%d, xino=%u\n",
+		 __func__, real_sb->s_id, real_sb->s_max_ino_bits,
+		 real_sb->s_ino_domain, fh_type, ofs->xino_bits);
+}
+
+static void ovl_update_sb_limits(struct super_block *sb,
+				 struct super_block *real_sb)
+{
+	unsigned short ino_bits = real_sb->s_max_ino_bits ?: BITS_PER_LONG;
+
+	/*
+	 * Assume non samefs and xino=off until proven otherwise and assume
+	 * undelying fs that does not advertise max_ino_bits uses all bits
+	 * unless proven otherwise.
+	 */
+	sb->s_max_ino_bits = max(sb->s_max_ino_bits, ino_bits);
+	sb->s_stack_depth = max(sb->s_stack_depth, real_sb->s_stack_depth);
+}
+
+static int ovl_lower_dir(struct super_block *sb, struct ovl_fs *ofs,
+			 const char *name, struct path *path, bool *remote)
 {
 	int fh_type;
 	int err;
@@ -789,7 +847,7 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	if (err)
 		goto out_put;
 
-	*stack_depth = max(*stack_depth, path->mnt->mnt_sb->s_stack_depth);
+	ovl_update_sb_limits(sb, path->mnt->mnt_sb);
 
 	if (ovl_dentry_remote(path->dentry))
 		*remote = true;
@@ -807,9 +865,7 @@ static int ovl_lower_dir(const char *name, struct path *path,
 			name);
 	}
 
-	/* Check if lower fs has 32bit inode numbers */
-	if (fh_type != FILEID_INO32_GEN)
-		ofs->xino_bits = 0;
+	ovl_update_xino_bits(ofs, path->dentry->d_sb, fh_type);
 
 	return 0;
 
@@ -1092,15 +1148,14 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 		pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
 	}
 
-	/* Check if upper fs has 32bit inode numbers */
-	if (fh_type != FILEID_INO32_GEN)
-		ofs->xino_bits = 0;
-
 	/* NFS export of r/w mount depends on index */
 	if (ofs->config.nfs_export && !ofs->config.index) {
 		pr_warn("overlayfs: NFS export requires \"index=on\", falling back to nfs_export=off.\n");
 		ofs->config.nfs_export = false;
 	}
+
+	ovl_update_xino_bits(ofs, ofs->workdir->d_sb, fh_type);
+
 out:
 	mnt_drop_write(mnt);
 	return err;
@@ -1255,6 +1310,16 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 	return ofs->numlowerfs;
 }
 
+static unsigned int ovl_fsid_bits(unsigned int numlowerfs)
+{
+	/*
+	 * This is a roundup of number of bits needed for numlowerfs+1
+	 * (i.e. ilog2(numlowerfs+1 - 1) + 1). fsid 0 is reserved for
+	 * upper fs even with non upper overlay.
+	 */
+	return ilog2(numlowerfs) + 1;
+}
+
 static int ovl_get_lower_layers(struct ovl_fs *ofs, struct path *stack,
 				unsigned int numlower)
 {
@@ -1303,32 +1368,6 @@ static int ovl_get_lower_layers(struct ovl_fs *ofs, struct path *stack,
 		ofs->numlower++;
 	}
 
-	/*
-	 * When all layers on same fs, overlay can use real inode numbers.
-	 * With mount option "xino=on", mounter declares that there are enough
-	 * free high bits in underlying fs to hold the unique fsid.
-	 * If overlayfs does encounter underlying inodes using the high xino
-	 * bits reserved for fsid, it emits a warning and uses the original
-	 * inode number.
-	 */
-	if (!ofs->numlowerfs || (ofs->numlowerfs == 1 && !ofs->upper_mnt)) {
-		ofs->xino_bits = 0;
-		ofs->config.xino = OVL_XINO_OFF;
-	} else if (ofs->config.xino == OVL_XINO_ON && !ofs->xino_bits) {
-		/*
-		 * This is a roundup of number of bits needed for numlowerfs+1
-		 * (i.e. ilog2(numlowerfs+1 - 1) + 1). fsid 0 is reserved for
-		 * upper fs even with non upper overlay.
-		 */
-		BUILD_BUG_ON(ilog2(OVL_MAX_STACK) > 31);
-		ofs->xino_bits = ilog2(ofs->numlowerfs) + 1;
-	}
-
-	if (ofs->xino_bits) {
-		pr_info("overlayfs: \"xino\" feature enabled using %d upper inode bits.\n",
-			ofs->xino_bits);
-	}
-
 	err = 0;
 out:
 	return err;
@@ -1372,8 +1411,7 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	err = -EINVAL;
 	lower = lowertmp;
 	for (numlower = 0; numlower < stacklen; numlower++) {
-		err = ovl_lower_dir(lower, &stack[numlower], ofs,
-				    &sb->s_stack_depth, &remote);
+		err = ovl_lower_dir(sb, ofs, lower, &stack[numlower], &remote);
 		if (err)
 			goto out_err;
 
@@ -1419,6 +1457,74 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	goto out;
 }
 
+static void ovl_set_ino_domain(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	struct super_block *same_sb = ovl_same_sb(sb);
+	/*
+	 * xino_bits are the high bits not used by underlying fs.
+	 * fsid_bits are high bits actually used by overlayfs.
+	 */
+	unsigned int xino_bits = ovl_xino_bits(sb);
+	unsigned int fsid_bits = ovl_fsid_bits(ofs->numlowerfs);
+
+	BUILD_BUG_ON(ovl_fsid_bits(OVL_MAX_STACK) > 32);
+
+	/*
+	 * When all layers on same fs, overlay can use real inode numbers.
+	 */
+	if (same_sb) {
+		/* "inherit" inode number domain from underlying fs */
+		ofs->xino_bits = 0;
+		ofs->config.xino = OVL_XINO_OFF;
+		sb->s_ino_domain = same_sb->s_ino_domain;
+		sb->s_max_ino_bits = same_sb->s_max_ino_bits;
+		goto out;
+	}
+
+	/*
+	 * xino_bits are the high bits not used by underlying fs.
+	 * fsid_bits are high bits actually used by overlayfs.
+	 */
+	if (ofs->config.xino != OVL_XINO_OFF &&
+	    xino_bits && xino_bits < fsid_bits) {
+		ofs->xino_bits = 0;
+		ofs->config.xino = OVL_XINO_OFF;
+		pr_warn("overlayfs: not enough high bits (%d < %d) available for xino, falling back to xino=off.\n",
+			xino_bits, fsid_bits);
+	}
+
+	/*
+	 * With mount option "xino=on", mounter declares that there are enough
+	 * free high bits in underlying fs to hold the unique fsid.
+	 * If overlayfs does encounter underlying inodes using the high xino
+	 * bits reserved for fsid, it emits a warning and uses the original
+	 * inode number.
+	 */
+	if (ofs->config.xino == OVL_XINO_ON && !xino_bits)
+		xino_bits = fsid_bits;
+
+	if (xino_bits) {
+		/* New multiplexed inode number domain */
+		ofs->xino_bits = xino_bits;
+		sb->s_ino_domain = sb->s_dev;
+		sb->s_max_ino_bits = BITS_PER_LONG - xino_bits + fsid_bits;
+		pr_info("overlayfs: \"xino\" feature enabled using %d upper inode bits.\n",
+			xino_bits);
+	} else {
+		/*
+		 * No inode numbers domain. inode numbers are not unique across
+		 * the overlay, only unique along with lower fs pseudo dev.
+		 */
+		sb->s_ino_domain = 0;
+	}
+
+out:
+	pr_debug("%s: max_ino_bits=%u, ino_domain=%x, xinobits=%u, fsidbits=%u\n",
+		 __func__, sb->s_max_ino_bits, sb->s_ino_domain, ofs->xino_bits,
+		 fsid_bits);
+}
+
 static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 {
 	struct path upperpath = { };
@@ -1452,7 +1558,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_err;
 	}
 
-	sb->s_stack_depth = 0;
 	sb->s_maxbytes = MAX_LFS_FILESIZE;
 	/* Assume underlaying fs uses 32bit inodes unless proven otherwise */
 	if (ofs->config.xino != OVL_XINO_OFF)
@@ -1475,7 +1580,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (!ofs->workdir)
 			sb->s_flags |= SB_RDONLY;
 
-		sb->s_stack_depth = ofs->upper_mnt->mnt_sb->s_stack_depth;
+		ovl_update_sb_limits(sb, ofs->upper_mnt->mnt_sb);
 		sb->s_time_gran = ofs->upper_mnt->mnt_sb->s_time_gran;
 
 	}
@@ -1548,6 +1653,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ovl_set_upperdata(d_inode(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
 		       ovl_dentry_lower(root_dentry), NULL);
+	/* Describe this inode number domain to next level stacked fs */
+	ovl_set_ino_domain(sb);
 
 	sb->s_root = root_dentry;
 
-- 
2.17.1
