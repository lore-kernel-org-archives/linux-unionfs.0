Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] ovl: set lower layer st_dev only if setting lower st_ino
Date: Wed, 11 Apr 2018 21:44:28 +0300
Message-Id: <1523472268-16707-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

For broken hardlinks, we do not return lower st_ino, so we should
also not return lower pseudo st_dev.

Fixes: a0c5ad307ac0 ("ovl: relax same fs constraint for constant st_ino")
Cc: <stable@vger.kernel.org> #v4.15
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

Miklos,

This is the bug fix on top of current overlayfs-next.
Since this patch will not apply to v4.15, I will send
backported v1 to stable after this is merged.

If you prefer to rebase xino patches over v1 bugfix,
you can use this one as conflict resolution.

Thanks,
Amir.

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 960d47154dc6..f31912853ebb 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -59,13 +59,19 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	return err;
 }
 
-static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat)
+static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat,
+			   u64 origin_ino)
 {
-	struct ovl_layer *lower_layer = ovl_layer_lower(dentry);
-	bool samefs = ovl_same_sb(dentry->d_sb);
+	struct ovl_layer *lower_layer = NULL;
 	unsigned int xinobits = ovl_xino_bits(dentry->d_sb);
 
-	if (samefs) {
+	if (origin_ino) {
+		stat->ino = origin_ino;
+		lower_layer = ovl_layer_lower(dentry);
+		WARN_ON(!lower_layer);
+	}
+
+	if (ovl_same_sb(dentry->d_sb)) {
 		/*
 		 * When all layers are on the same fs, all real inode
 		 * number are unique, so we use the overlay st_dev,
@@ -131,6 +137,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	const struct cred *old_cred;
 	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
 	bool samefs = ovl_same_sb(dentry->d_sb);
+	u64 origin_ino = 0;
 	int err;
 
 	type = ovl_path_real(dentry, &realpath);
@@ -177,14 +184,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) ||
 			    (!ovl_verify_lower(dentry->d_sb) &&
 			     (is_dir || lowerstat.nlink == 1)))
-				stat->ino = lowerstat.ino;
-
-			if (samefs)
-				WARN_ON_ONCE(stat->dev != lowerstat.dev);
+				origin_ino = lowerstat.ino;
+		} else if (!OVL_TYPE_UPPER(type)) {
+			origin_ino = stat->ino;
 		}
 	}
 
-	err = ovl_map_dev_ino(dentry, stat);
+	err = ovl_map_dev_ino(dentry, stat, origin_ino);
 	if (err)
 		goto out;
 
-- 
2.7.4
