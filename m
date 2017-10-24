From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/4] ovl: check incompat/rocompat index features
Date: Tue, 24 Oct 2017 13:03:01 +0300
Message-ID: <1508839381-24750-5-git-send-email-amir73il@gmail.com>
References: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:47442 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932344AbdJXKCi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2017 06:02:38 -0400
Received: by mail-wm0-f65.google.com with SMTP id t69so14585928wmt.2
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2017 03:02:38 -0700 (PDT)
In-Reply-To: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When enabling a backward incompatible feature, we create a
non-empty directory nested 2 levels deep under "index" dir, e.g.:
workdir/index/incompat_features/incomapt_index.

Kernels with inodes index support, but with no dir index entries support
(i.e. v4.13) will fail to verify the index dir entry "incompat_features"
and fail the mount.

User mounting with those kernels will see warnings like these in dmesg:
  overlayfs: failed to verify index (index/incompat_features,
             ftype=4000, err=-30)
  overlayfs: failed index dir cleanup (-30)
  overlayfs: try deleting index dir or mounting with '-o index=off' to
             disable inodes index.

These warnings should give the hint to the user that:
1. mount failure is caused by backward incompatible features
2. mount failure can be resolved by manually removing the "index" directory

New kernels will recognize the special features directories and will
only fail to mount if any of the names inside the features dir is not a
supported feature.
This will allow us to maintain feature compatibility for index features
going forward.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h |  4 ++-
 fs/overlayfs/readdir.c   | 75 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/overlayfs/super.c     |  8 +++++-
 fs/overlayfs/util.c      | 26 +++++++++++++----
 4 files changed, 102 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d1172b3f9a99..1470713cb05e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -30,6 +30,8 @@ enum ovl_path_type {
 #define OVL_INCOMPAT_FEATURES_NAME "incompat_features"
 #define OVL_FEATURE_INCOMPAT_INDEX "incompat_index"
 
+#define OVL_ROCOMPAT_FEATURES_NAME "rocompat_features"
+
 enum ovl_flag {
 	OVL_IMPURE,
 	OVL_INDEX,
@@ -246,7 +248,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 	return ovl_check_dir_xattr(dentry, OVL_XATTR_IMPURE);
 }
 
-bool ovl_is_features_dir(struct dentry *dentry, const char ***features);
+int ovl_is_features_dir(struct dentry *dentry, const char ***features);
 bool ovl_is_feature_supported(const char *name, int namelen,
 			      const char **features);
 struct ovl_fs;
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 53ee99ec5b1c..44ef65ce03bf 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -48,7 +48,8 @@ struct ovl_readdir_data {
 	int count;
 	int err;
 	bool is_upper;
-	bool d_type_supported;
+	const char **match;
+	bool found;
 };
 
 struct ovl_dir_file {
@@ -898,7 +899,7 @@ static int ovl_check_d_type(struct dir_context *ctx, const char *name,
 		return 0;
 
 	if (d_type != DT_UNKNOWN)
-		rdd->d_type_supported = true;
+		rdd->found = true;
 
 	return 0;
 }
@@ -912,14 +913,14 @@ int ovl_check_d_type_supported(struct path *realpath)
 	int err;
 	struct ovl_readdir_data rdd = {
 		.ctx.actor = ovl_check_d_type,
-		.d_type_supported = false,
+		.found = false,
 	};
 
 	err = ovl_dir_read(realpath, &rdd);
 	if (err)
 		return err;
 
-	return rdd.d_type_supported;
+	return rdd.found;
 }
 
 static void ovl_workdir_cleanup_recurse(struct path *path, int level,
@@ -1007,6 +1008,48 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 	}
 }
 
+static int ovl_check_feature_name(struct dir_context *ctx, const char *name,
+				  int namelen, loff_t offset, u64 ino,
+				  unsigned int d_type)
+{
+	struct ovl_readdir_data *rdd =
+		container_of(ctx, struct ovl_readdir_data, ctx);
+
+	if (name[0] == '.')
+		return 0;
+
+	if (!ovl_is_feature_supported(name, namelen, rdd->match)) {
+		pr_warn("overlayfs: feature '%.*s' not supported\n",
+			namelen, name);
+		rdd->found = true;
+	}
+
+	return 0;
+}
+
+/*
+ * Returns 0 if all feature names are supported.
+ * Returns 1 if an unsupported feature name was found.
+ * Negative values if other error is encountered.
+ */
+int ovl_check_unsupported_feature(struct dentry *dentry, struct vfsmount *mnt,
+				  const char **features)
+{
+	int err;
+	struct path path = { .mnt = mnt, .dentry = dentry };
+	struct ovl_readdir_data rdd = {
+		.ctx.actor = ovl_check_feature_name,
+		.match = features,
+		.found = false,
+	};
+
+	err = ovl_dir_read(&path, &rdd);
+	if (err)
+		return err;
+
+	return rdd.found;
+}
+
 int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			 struct path *lowerstack, unsigned int numlower)
 {
@@ -1031,6 +1074,9 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
 	list_for_each_entry(p, &list, l_node) {
+		const char **features;
+		int ret = 0;
+
 		if (p->name[0] == '.') {
 			if (p->len == 1)
 				continue;
@@ -1043,6 +1089,26 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			index = NULL;
 			break;
 		}
+
+		if (d_is_dir(index))
+			ret = ovl_is_features_dir(index, &features);
+		if (ret) {
+			/*
+			 * ret is -EINVAL for incompat features dir and
+			 * -EROFS for rocompat features dir.
+			 */
+			inode_unlock(dir);
+			err = ovl_check_unsupported_feature(index, mnt,
+							    features);
+			if (err > 0)
+				err = ret;
+			inode_lock_nested(dir, I_MUTEX_PARENT);
+			if (err)
+				break;
+
+			goto next;
+		}
+
 		err = ovl_verify_index(index, lowerstack, numlower);
 		/* Cleanup stale and orphan index entries */
 		if (err && (err == -ESTALE || err == -ENOENT))
@@ -1050,6 +1116,7 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 		if (err)
 			break;
 
+next:
 		dput(index);
 		index = NULL;
 	}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 49c6a7ad695f..2d37afc6bf42 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1111,8 +1111,14 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 							   ufs->upper_mnt,
 							   stack, numlower);
 		}
-		if (err || !ufs->indexdir)
+		if (err || !ufs->indexdir) {
+			if (err == -EROFS) {
+				pr_warn("overlayfs: unsupported index features; mounting read-only to avoid corrupting inodes index.\n");
+				sb->s_flags |= MS_RDONLY;
+				err = 0;
+			}
 			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
+		}
 		if (err)
 			goto out_put_indexdir;
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index bef850632c80..feb4aae736a6 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -587,17 +587,31 @@ static const char * const ovl_incompat_features[] = {
 	NULL,
 };
 
-bool ovl_is_features_dir(struct dentry *dentry, const char ***features)
+static const char * const ovl_rocompat_features[] = {
+	NULL,
+};
+
+/*
+ * Returns 0 if not a features dir name.
+ * Returns error value to be returned from mount if an unsuppoted
+ * feature name is found in this features dir.
+ */
+int ovl_is_features_dir(struct dentry *dentry, const char ***features)
 {
 	if (!dentry || !d_is_dir(dentry))
-		return false;
+		return 0;
 
 	if (!strcmp(dentry->d_name.name, OVL_INCOMPAT_FEATURES_NAME)) {
 		*features = (const char **)ovl_incompat_features;
-		return true;
+		return -EINVAL;
 	}
 
-	return false;
+	if (!strcmp(dentry->d_name.name, OVL_ROCOMPAT_FEATURES_NAME)) {
+		*features = (const char **)ovl_rocompat_features;
+		return -EROFS;
+	}
+
+	return 0;
 }
 
 bool ovl_is_feature_supported(const char *name, int namelen,
@@ -647,7 +661,7 @@ static int ovl_create_feature_dir(struct dentry *dentry,  struct vfsmount *mnt,
 /*
  * Prevent kernel with no support for the enabled feature from mounting
  * this overlay read-write and corrupting the index by creating a
- * non-empty nested dir entires in workdir, that old kernels
+ * non-empty nested dir entires in workdir and in indexdir, that old kernels
  * do not know how to clean on mount.
  */
 int ovl_enable_feature(struct ovl_fs *ofs, const char *dirname,
@@ -664,6 +678,8 @@ int ovl_enable_feature(struct ovl_fs *ofs, const char *dirname,
 		return err;
 
 	err = ovl_create_feature_dir(ofs->workdir, mnt, dirname, name);
+	if (!err)
+		err = ovl_create_feature_dir(ofs->indexdir, mnt, dirname, name);
 
 	mnt_drop_write(mnt);
 	return err;
-- 
2.7.4
