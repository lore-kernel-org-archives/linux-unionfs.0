Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5/6] ovl: fix corner case of conflicting lower layer uuid
Date: Sun, 17 Nov 2019 17:43:48 +0200
Message-Id: <20191117154349.28695-6-amir73il@gmail.com>
In-Reply-To: <20191117154349.28695-1-amir73il@gmail.com>
References: <20191117154349.28695-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Colin Ian King <colin.king@canonical.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This fixes ovl_lower_uuid_ok() to correctly detect the corner case:
- two filesystems, A and B, both have null uuid
- upper layer is on A
- lower layer 1 is also on A
- lower layer 2 is on B

In this case, bad_uuid would not have been set for B, because the check
only involved the list of lower fs.  Hence we'll try to decode a layer 2
origin on layer 1 and fail.

We check for conflicting (and null) uuid among all lower layers,
including those layers that are on the same fs as the upper layer.

Reported-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/ovl_entry.h | 2 ++
 fs/overlayfs/super.c     | 8 ++++++--
 2 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 93e9fd5fba9d..6c04b6a4e6bf 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -24,6 +24,8 @@ struct ovl_sb {
 	dev_t pseudo_dev;
 	/* Unusable (conflicting) uuid */
 	bool bad_uuid;
+	/* Used as a lower layer (but maybe also as upper) */
+	bool is_lower;
 };
 
 struct ovl_layer {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 09e53780d9bc..e80f79bb8a4e 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1256,7 +1256,7 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 	if (!ofs->config.nfs_export && !ofs->upper_mnt)
 		return true;
 
-	for (i = 1; i <= ofs->maxfsid; i++) {
+	for (i = 0; i <= ofs->maxfsid; i++) {
 		/*
 		 * We use uuid to associate an overlay lower file handle with a
 		 * lower layer, so we can accept lower fs with null uuid as long
@@ -1264,7 +1264,8 @@ static bool ovl_lower_uuid_ok(struct ovl_fs *ofs, const uuid_t *uuid)
 		 * if we detect multiple lower fs with the same uuid, we
 		 * disable lower file handle decoding on all of them.
 		 */
-		if (uuid_equal(&ofs->fs[i].sb->s_uuid, uuid)) {
+		if (ofs->fs[i].is_lower &&
+		    uuid_equal(&ofs->fs[i].sb->s_uuid, uuid)) {
 			ofs->fs[i].bad_uuid = true;
 			return false;
 		}
@@ -1336,10 +1337,12 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 	/*
 	 * All lower layers that share the same fs as upper layer, use the real
 	 * upper st_dev.
+	 * is_lower will be set if upper fs is shared with a lower layer.
 	 */
 	if (ofs->upper_mnt) {
 		ofs->fs[0].sb = ofs->upper_mnt->mnt_sb;
 		ofs->fs[0].pseudo_dev = ofs->upper_mnt->mnt_sb->s_dev;
+		ofs->fs[0].is_lower = false;
 	}
 
 	for (i = 0; i < numlower; i++) {
@@ -1381,6 +1384,7 @@ static int ovl_get_layers(struct super_block *sb, struct ovl_fs *ofs,
 		ofs->layers[ofs->numlower].idx = ofs->numlower;
 		ofs->layers[ofs->numlower].fsid = fsid;
 		ofs->layers[ofs->numlower].fs = &ofs->fs[fsid];
+		ofs->fs[fsid].is_lower = true;
 	}
 
 	/*
-- 
2.17.1
