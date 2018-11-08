Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/3] ovl: relax xino for some nested overlay cases
Date: Thu,  8 Nov 2018 13:49:42 +0200
Message-Id: <20181108114942.32531-4-amir73il@gmail.com>
In-Reply-To: <20181108114942.32531-1-amir73il@gmail.com>
References: <20181108114942.32531-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

When overlayfs is nested over a lower overlayfs and all lower overlayfs
layers are on the same fs, the lower layer inode number domain is that of
the underlying real fs, so we can assign the same fsid to the lower
overlayfs and the real underlying fs.

In the private case of all lower overlay layers on the same fs, which is
also the upper fs of the nested overlay, the nested overlay itself is
treated as "samefs", because inode numbers in all layers are from the same
inode numbers domain. In that case, we do not need xino and can use the
underlying inode numbers.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/ovl_entry.h |  7 ++++++-
 fs/overlayfs/super.c     | 12 ++++++------
 fs/overlayfs/util.c      |  2 +-
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index ec237035333a..c23bdf41918f 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -23,10 +23,15 @@ struct ovl_config {
 };
 
 struct ovl_sb {
-	struct super_block *sb;
+	dev_t key;
 	dev_t pseudo_dev;
 };
 
+static inline dev_t ovl_sb_key(struct super_block *sb)
+{
+	return sb->s_ino_domain ?: sb->s_dev;
+}
+
 struct ovl_layer {
 	struct vfsmount *mnt;
 	struct ovl_sb *fs;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index c7acc3d39b5f..90dca7c935db 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1260,13 +1260,13 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 	if (!ofs->config.nfs_export && !(ofs->config.index && ofs->upper_mnt))
 		return true;
 
-	for (i = 0; i < ofs->numlowerfs; i++) {
+	for (i = 0; i < ofs->numlower; i++) {
 		/*
 		 * We use uuid to associate an overlay lower file handle with a
 		 * lower layer, so we can accept lower fs with null uuid as long
 		 * as all lower layers with null uuid are on the same fs.
 		 */
-		if (uuid_equal(&ofs->lower_fs[i].sb->s_uuid, uuid))
+		if (uuid_equal(&ofs->lower_layers[i].mnt->mnt_sb->s_uuid, uuid))
 			return false;
 	}
 	return true;
@@ -1276,16 +1276,17 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 {
 	struct super_block *sb = path->mnt->mnt_sb;
+	dev_t key = ovl_sb_key(sb);
 	unsigned int i;
 	dev_t dev;
 	int err;
 
 	/* fsid 0 is reserved for upper fs even with non upper overlay */
-	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
+	if (ofs->upper_mnt && ovl_sb_key(ofs->upper_mnt->mnt_sb) == key)
 		return 0;
 
 	for (i = 0; i < ofs->numlowerfs; i++) {
-		if (ofs->lower_fs[i].sb == sb)
+		if (ofs->lower_fs[i].key == key)
 			return i + 1;
 	}
 
@@ -1303,7 +1304,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, const struct path *path)
 		return err;
 	}
 
-	ofs->lower_fs[ofs->numlowerfs].sb = sb;
+	ofs->lower_fs[ofs->numlowerfs].key = key;
 	ofs->lower_fs[ofs->numlowerfs].pseudo_dev = dev;
 	ofs->numlowerfs++;
 
@@ -1582,7 +1583,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 		ovl_update_sb_limits(sb, ofs->upper_mnt->mnt_sb);
 		sb->s_time_gran = ofs->upper_mnt->mnt_sb->s_time_gran;
-
 	}
 	oe = ovl_get_lowerstack(sb, ofs);
 	err = PTR_ERR(oe);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7c01327b1852..b73ec8c544ec 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -50,7 +50,7 @@ struct super_block *ovl_same_sb(struct super_block *sb)
 	if (!ofs->numlowerfs)
 		return ofs->upper_mnt->mnt_sb;
 	else if (ofs->numlowerfs == 1 && !ofs->upper_mnt)
-		return ofs->lower_fs[0].sb;
+		return ofs->lower_layers[0].mnt->mnt_sb;
 	else
 		return NULL;
 }
-- 
2.17.1
