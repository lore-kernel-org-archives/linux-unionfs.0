Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v9 1/7] ovl: factor out ovl_map_dev_ino() helper
Date: Thu, 29 Mar 2018 17:18:47 +0300
Message-Id: <1522333133-24772-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

A helper for ovl_getattr() to map the values of st_dev and st_ino
according to constant st_ino rules.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 83 +++++++++++++++++++++++++-----------------------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      |  7 ++++
 3 files changed, 52 insertions(+), 39 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 4689716f23d8..1ae53357b228 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -16,13 +16,6 @@
 #include "overlayfs.h"
 
 
-static dev_t ovl_get_pseudo_dev(struct dentry *dentry)
-{
-	struct ovl_entry *oe = dentry->d_fsdata;
-
-	return oe->lowerstack[0].layer->pseudo_dev;
-}
-
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	int err;
@@ -66,6 +59,43 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	return err;
 }
 
+static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat)
+{
+	struct ovl_layer *lower_layer = ovl_layer_lower(dentry);
+	bool samefs = ovl_same_sb(dentry->d_sb);
+
+	if (samefs) {
+		/*
+		 * When all layers are on the same fs, all real inode
+		 * number are unique, so we use the overlay st_dev,
+		 * which is friendly to du -x.
+		 */
+		stat->dev = dentry->d_sb->s_dev;
+	} else if (S_ISDIR(dentry->d_inode->i_mode)) {
+		/*
+		 * Always use the overlay st_dev for directories, so 'find
+		 * -xdev' will scan the entire overlay mount and won't cross the
+		 * overlay mount boundaries.
+		 *
+		 * If not all layers are on the same fs the pair {real st_ino;
+		 * overlay st_dev} is not unique, so use the non persistent
+		 * overlay st_ino for directories.
+		 */
+		stat->dev = dentry->d_sb->s_dev;
+		stat->ino = dentry->d_inode->i_ino;
+	} else if (lower_layer) {
+		/*
+		 * For non-samefs setup, if we cannot map all layers st_ino
+		 * to a unified address space, we need to make sure that st_dev
+		 * is unique per layer. Upper layer uses real st_dev and lower
+		 * layers use the unique anonymous bdev.
+		 */
+		stat->dev = lower_layer->pseudo_dev;
+	}
+
+	return 0;
+}
+
 int ovl_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int flags)
 {
@@ -84,10 +114,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		goto out;
 
 	/*
-	 * For non-dir or same fs, we use st_ino of the copy up origin, if we
-	 * know it. This guaranties constant st_dev/st_ino across copy up.
+	 * For non-dir or same fs, we use st_ino of the copy up origin.
+	 * This guaranties constant st_dev/st_ino across copy up.
 	 *
-	 * If filesystem supports NFS export ops, this also guaranties
+	 * If lower filesystem supports NFS file handles, this also guaranties
 	 * persistent st_ino across mount cycle.
 	 */
 	if (!is_dir || samefs) {
@@ -123,38 +153,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 
 			if (samefs)
 				WARN_ON_ONCE(stat->dev != lowerstat.dev);
-			else
-				stat->dev = ovl_get_pseudo_dev(dentry);
-		}
-		if (samefs) {
-			/*
-			 * When all layers are on the same fs, all real inode
-			 * number are unique, so we use the overlay st_dev,
-			 * which is friendly to du -x.
-			 */
-			stat->dev = dentry->d_sb->s_dev;
-		} else if (!OVL_TYPE_UPPER(type)) {
-			/*
-			 * For non-samefs setup, to make sure that st_dev/st_ino
-			 * pair is unique across the system, we use a unique
-			 * anonymous st_dev for lower layer inode.
-			 */
-			stat->dev = ovl_get_pseudo_dev(dentry);
 		}
-	} else {
-		/*
-		 * Always use the overlay st_dev for directories, so 'find
-		 * -xdev' will scan the entire overlay mount and won't cross the
-		 * overlay mount boundaries.
-		 *
-		 * If not all layers are on the same fs the pair {real st_ino;
-		 * overlay st_dev} is not unique, so use the non persistent
-		 * overlay st_ino for directories.
-		 */
-		stat->dev = dentry->d_sb->s_dev;
-		stat->ino = dentry->d_inode->i_ino;
 	}
 
+	err = ovl_map_dev_ino(dentry, stat);
+	if (err)
+		goto out;
+
 	/*
 	 * It's probably not worth it to count subdirs to get the
 	 * correct link count.  nlink=1 seems to pacify 'find' and
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 225ff1171147..4432599ecbc6 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -215,6 +215,7 @@ void ovl_path_lower(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
+struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 493f9b76fbf6..5042293d2078 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -172,6 +172,13 @@ struct dentry *ovl_dentry_lower(struct dentry *dentry)
 	return oe->numlower ? oe->lowerstack[0].dentry : NULL;
 }
 
+struct ovl_layer *ovl_layer_lower(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	return oe->numlower ? oe->lowerstack[0].layer : NULL;
+}
+
 struct dentry *ovl_dentry_real(struct dentry *dentry)
 {
 	return ovl_dentry_upper(dentry) ?: ovl_dentry_lower(dentry);
-- 
2.7.4
