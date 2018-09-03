Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/3] ovl: disable xino for some nested overlay cases
Date: Mon,  3 Sep 2018 09:12:10 +0300
Message-Id: <20180903061211.20830-3-amir73il@gmail.com>
In-Reply-To: <20180903061211.20830-1-amir73il@gmail.com>
References: <20180903061211.20830-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

There are three possible cases when overlayfs is used as lower
layer for a nested overlay mount:

1. lower overlay is non-samefs with xino enabled
2. lower overlay is non-samefs with xino disabled
3. lower overlay is samefs

In the first case, lower layer uses high inode number bits, so they are
not available for the nested overlay and xino should be disabled.

In the second case, inode numbers of lower layer are not in a single
address space, so there is no use enabling xino in nested overlay.

In the last case (samefs) the lower layer inode number address space
is that of the underlying real fs, so we can assign fsid of the lower
layer according the the real underlying fs.

In the private case of all lower overlay layers on the same fs, which is
also the upper fs of the nested overlay, the nested overlay itself is
treated as "samefs", because inode numbers in all layers are from the
same address space.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  8 ++++++++
 fs/overlayfs/super.c     | 25 +++++++++++++++++++++++--
 2 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index f61839e1054c..d32fe09a222f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -418,3 +418,11 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 
 /* export.c */
 extern const struct export_operations ovl_export_operations;
+
+/* super.c */
+extern struct file_system_type ovl_fs_type;
+
+static inline bool ovl_is_overlay_fs(struct super_block *sb)
+{
+	return sb->s_type == &ovl_fs_type;
+}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 069e441e24eb..b6a0211dc75c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -755,6 +755,7 @@ static int ovl_check_namelen(struct path *path, struct ovl_fs *ofs,
 static int ovl_lower_dir(const char *name, struct path *path,
 			 struct ovl_fs *ofs, int *stack_depth, bool *remote)
 {
+	struct super_block *real_sb;
 	int fh_type;
 	int err;
 
@@ -775,7 +776,8 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	 * The inodes index feature and NFS export need to encode and decode
 	 * file handles, so they require that all layers support them.
 	 */
-	fh_type = ovl_can_decode_fh(path->dentry->d_sb);
+	real_sb = path->dentry->d_sb;
+	fh_type = ovl_can_decode_fh(real_sb);
 	if ((ofs->config.nfs_export ||
 	     (ofs->config.index && ofs->config.upperdir)) && !fh_type) {
 		ofs->config.index = false;
@@ -784,6 +786,17 @@ static int ovl_lower_dir(const char *name, struct path *path,
 			name);
 	}
 
+	/* Are all layers of nested overlay on same sb? */
+	if (ofs->config.xino != OVL_XINO_OFF && ovl_is_overlay_fs(real_sb)) {
+		real_sb = ovl_same_sb(real_sb);
+		if (real_sb) {
+			fh_type = ovl_can_decode_fh(real_sb);
+		} else {
+			pr_warn("overlayfs: nested xino not supported, falling back to xino=off.\n");
+			ofs->config.xino = OVL_XINO_OFF;
+		}
+	}
+
 	/* Check if lower fs has 32bit inode numbers */
 	if (fh_type != FILEID_INO32_GEN)
 		ofs->xino_bits = 0;
@@ -1183,6 +1196,14 @@ static int ovl_get_fsid(struct ovl_fs *ofs, struct vfsmount *mnt)
 	bool need_uuid = ofs->config.nfs_export ||
 			 (ofs->config.index && ofs->upper_mnt);
 
+	/* Are all layers of nested overlay on same sb? */
+	if (ovl_is_overlay_fs(sb)) {
+		struct super_block *real_sb = ovl_same_sb(sb);
+
+		if (real_sb)
+			sb = real_sb;
+	}
+
 	/* fsid 0 is reserved for upper fs even with non upper overlay */
 	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
 		return 0;
@@ -1535,7 +1556,7 @@ static struct dentry *ovl_mount(struct file_system_type *fs_type, int flags,
 	return mount_nodev(fs_type, flags, raw_data, ovl_fill_super);
 }
 
-static struct file_system_type ovl_fs_type = {
+struct file_system_type ovl_fs_type = {
 	.owner		= THIS_MODULE,
 	.name		= "overlay",
 	.mount		= ovl_mount,
-- 
2.17.1
