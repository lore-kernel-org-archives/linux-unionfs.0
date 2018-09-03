Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/3] ovl: relax requirement for non null uuid of lower fs
Date: Mon,  3 Sep 2018 09:12:09 +0300
Message-Id: <20180903061211.20830-2-amir73il@gmail.com>
In-Reply-To: <20180903061211.20830-1-amir73il@gmail.com>
References: <20180903061211.20830-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

We use uuid to associate an overlay lower file handle with a lower layer,
so we can accept lower fs with null uuid as long as all lower layers with
null uuid are on the same fs.

This change allows enabling index and nfs_export features for the setup of
single lower fs of type squashfs - squashfs supports file handles, but has
a null uuid. This change also allows enabling index and nfs_export
features for nested overlayfs, where the lower overlay has nfs_export
enabled.

Enabling the index feature with single lower squashfs fixes the
unionmount-testsuite test:
  ./run --ov --squashfs --verify

As a by-product, if, like the lower squashfs, upper fs also uses the
generic export_encode_fh() implementation to export 32bit inode file
handles (e.g. ext4), then the xino_auto config/module/mount option will
enable unique overlay inode numbers.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 23 +++++++++++++++++++++--
 fs/overlayfs/util.c  |  3 +--
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 2e0fc93c2c06..069e441e24eb 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1174,11 +1174,14 @@ static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
 }
 
 /* Get a unique fsid for the layer */
-static int ovl_get_fsid(struct ovl_fs *ofs, struct super_block *sb)
+static int ovl_get_fsid(struct ovl_fs *ofs, struct vfsmount *mnt)
 {
+	struct super_block *sb = mnt->mnt_sb;
 	unsigned int i;
 	dev_t dev;
 	int err;
+	bool need_uuid = ofs->config.nfs_export ||
+			 (ofs->config.index && ofs->upper_mnt);
 
 	/* fsid 0 is reserved for upper fs even with non upper overlay */
 	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
@@ -1187,6 +1190,22 @@ static int ovl_get_fsid(struct ovl_fs *ofs, struct super_block *sb)
 	for (i = 0; i < ofs->numlowerfs; i++) {
 		if (ofs->lower_fs[i].sb == sb)
 			return i + 1;
+
+		/*
+		 * We use uuid to associate an overlay lower file handle with a
+		 * lower layer, so we can accept lower fs with null uuid as long
+		 * as all lower layers with null uuid are on the same fs.
+		 */
+		if (need_uuid &&
+		    uuid_equal(&ofs->lower_fs[i].sb->s_uuid, &sb->s_uuid)) {
+			need_uuid = false;
+			ofs->config.index = false;
+			ofs->config.nfs_export = false;
+			pr_warn("overlayfs: %s uuid detected in lower fs '%pd2', falling back to index=off,nfs_export=off.\n",
+				uuid_is_null(&sb->s_uuid) ? "null" :
+							    "conflicting",
+				mnt->mnt_root);
+		}
 	}
 
 	err = get_anon_bdev(&dev);
@@ -1223,7 +1242,7 @@ static int ovl_get_lower_layers(struct ovl_fs *ofs, struct path *stack,
 		struct vfsmount *mnt;
 		int fsid;
 
-		err = fsid = ovl_get_fsid(ofs, stack[i].mnt->mnt_sb);
+		err = fsid = ovl_get_fsid(ofs, stack[i].mnt);
 		if (err < 0)
 			goto out;
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8cfb62cc8672..6eabe7cf9652 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -65,8 +65,7 @@ struct super_block *ovl_same_sb(struct super_block *sb)
  */
 int ovl_can_decode_fh(struct super_block *sb)
 {
-	if (!sb->s_export_op || !sb->s_export_op->fh_to_dentry ||
-	    uuid_is_null(&sb->s_uuid))
+	if (!sb->s_export_op || !sb->s_export_op->fh_to_dentry)
 		return 0;
 
 	return sb->s_export_op->encode_fh ? -1 : FILEID_INO32_GEN;
-- 
2.17.1
