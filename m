Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/5] ovl: enforce 'strict' feature requirements with metacopy=on
Date: Thu,  1 Nov 2018 02:48:10 +0200
Message-Id: <20181101004813.31349-3-amir73il@gmail.com>
In-Reply-To: <20181101004813.31349-1-amir73il@gmail.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Some overlayfs features require file handle support from underlying
filesystems and extended attributes support from upper filesystem.
We should prefer to fail the mount if those feature requirements are
not met, but for backward compatibility, we write a warning to log
and disable the feature instead.

When user asks explicitly via mount option to enable the new metacopy
feature, we do not need to worry about backward compatibility and we
can fail the mount if any of the feature requirements are not met.

Fixes: d5791044d2e5 ("ovl: Provide a mount option metacopy=on/off...")
Cc: <stable@vger.kernel.org> # v4.19
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 84 +++++++++++++++++++++++++-------------------
 1 file changed, 47 insertions(+), 37 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d91d2ba70d54..20135dd28192 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -608,6 +608,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 		config->workdir = NULL;
 	}
 
+	/* Show index=off in /proc/mounts for forced r/o mount */
+	if (!config->upperdir)
+		config->index = false;
+
 	err = ovl_parse_redirect_mode(config, config->redirect_mode);
 	if (err)
 		return err;
@@ -814,13 +818,17 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	 * file handles, so they require that all layers support them.
 	 */
 	fh_type = ovl_can_decode_fh(path->dentry->d_sb);
-	if ((ofs->config.nfs_export ||
-	     (ofs->config.index && ofs->config.upperdir)) && !fh_type) {
-		ofs->config.index = false;
-		ofs->config.nfs_export = false;
-		pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off,nfs_export=off.\n",
-			name);
-	}
+	err = ovl_feature_check(&ofs->config, &ofs->config.nfs_export,
+				fh_type, "NFS export",
+				"lower fs file handles support");
+	if (err)
+		goto out_put;
+
+	err = ovl_feature_check(&ofs->config, &ofs->config.index,
+				fh_type, "inodes index",
+				"lower fs file handles support");
+	if (err)
+		goto out_put;
 
 	/* Check if lower fs has 32bit inode numbers */
 	if (fh_type != FILEID_INO32_GEN)
@@ -1092,34 +1100,35 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	err = ovl_do_setxattr(ofs->workdir, OVL_XATTR_OPAQUE, "0", 1, 0);
 	if (err) {
 		ofs->noxattr = true;
-		ofs->config.index = false;
-		pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off.\n");
-		err = ovl_feature_check(&ofs->config, &ofs->config.metacopy,
-					!ofs->noxattr,
-					"metadata only copy up",
-					"upper fs xattr support");
-		if (err)
-			goto out;
+		pr_warn("overlayfs: upper fs does not support xattr.\n");
 	} else {
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
 	}
 
+	/* metacopy depends on redirect_dir which depend on xattr */
+	err = ovl_feature_check(&ofs->config, &ofs->config.metacopy,
+				!ofs->noxattr, "metadata only copy up",
+				"upper fs xattr support");
+	if (err)
+		goto out;
+
 	/* Check if upper/work fs supports file handles */
 	fh_type = ovl_can_decode_fh(ofs->workdir->d_sb);
-	if (ofs->config.index && !fh_type) {
-		ofs->config.index = false;
-		pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
-	}
+	err = ovl_feature_check(&ofs->config, &ofs->config.index,
+				!ofs->noxattr && fh_type, "inodes index",
+				"upper fs file handles and xattr support");
+	if (err)
+		goto out;
 
 	/* Check if upper fs has 32bit inode numbers */
 	if (fh_type != FILEID_INO32_GEN)
 		ofs->xino_bits = 0;
 
 	/* NFS export of r/w mount depends on index */
-	if (ofs->config.nfs_export && !ofs->config.index) {
-		pr_warn("overlayfs: NFS export requires \"index=on\", falling back to nfs_export=off.\n");
-		ofs->config.nfs_export = false;
-	}
+	err = ovl_feature_check(&ofs->config, &ofs->config.nfs_export,
+				ofs->config.index, "NFS export",
+				"\"index=on\" and upper fs file handles");
+
 out:
 	mnt_drop_write(mnt);
 	return err;
@@ -1377,10 +1386,13 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	} else if (!ofs->config.upperdir && stacklen == 1) {
 		pr_err("overlayfs: at least 2 lowerdir are needed while upperdir nonexistent\n");
 		goto out_err;
-	} else if (!ofs->config.upperdir && ofs->config.nfs_export &&
-		   ofs->config.redirect_follow) {
-		pr_warn("overlayfs: NFS export requires \"redirect_dir=nofollow\" on non-upper mount, falling back to nfs_export=off.\n");
-		ofs->config.nfs_export = false;
+	} else if (!ofs->config.upperdir) {
+		err = ovl_feature_check(&ofs->config, &ofs->config.nfs_export,
+					!ofs->config.redirect_follow,
+					"NFS export",
+					"\"redirect_dir=nofollow\" on non-upper mount");
+		if (err)
+			goto out_err;
 	}
 
 	err = -ENOMEM;
@@ -1522,18 +1534,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	/* Show index=off in /proc/mounts for forced r/o mount */
-	if (!ofs->indexdir) {
+	if (!ofs->indexdir)
 		ofs->config.index = false;
-		if (ofs->upper_mnt && ofs->config.nfs_export) {
-			pr_warn("overlayfs: NFS export requires an index dir, falling back to nfs_export=off.\n");
-			ofs->config.nfs_export = false;
-		}
-	}
 
-	if (ofs->config.metacopy && ofs->config.nfs_export) {
-		pr_warn("overlayfs: NFS export is not supported with metadata only copy up, falling back to nfs_export=off.\n");
-		ofs->config.nfs_export = false;
-	}
+	/* NFS export is not supported with metacopy or without index */
+	err = ovl_feature_check(&ofs->config, &ofs->config.nfs_export,
+				(ofs->indexdir || !ofs->upper_mnt) &&
+				!ofs->config.metacopy, "NFS export",
+				"\"metacopy=off\" and \"index=on\" on an upper mount");
+	if (err)
+		goto out_free_oe;
 
 	if (ofs->config.nfs_export)
 		sb->s_export_op = &ovl_export_operations;
-- 
2.17.1
