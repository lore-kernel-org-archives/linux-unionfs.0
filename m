From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/4] ovl: cast a shadow of incomapt index into the past
Date: Tue, 24 Oct 2017 13:03:00 +0300
Message-ID: <1508839381-24750-4-git-send-email-amir73il@gmail.com>
References: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:53370 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752249AbdJXKCh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2017 06:02:37 -0400
Received: by mail-wm0-f65.google.com with SMTP id r196so2161083wmf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2017 03:02:37 -0700 (PDT)
In-Reply-To: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Because overlayfs features were not implemented in the first version
of overlayfs merged in v3.18, we cannot enforce old kernel not to mount
overlayfs with new backward incompatible features... but we can try to
set traps for those who try to perform those mounts.

When enabling a backward incompatible feature, we create a
non-empty directory nested 2 levels deep under "work" dir, e.g.:
workdir/work/incompat_features/incomapt_index.

Very old kernels (i.e. v3.18) will fail to remove a non-empty "work"
dir and fail the mount. Newer kernels will fail to remove a "work"
dir with entries nested 3 levels and fall back to read-only mount.

User mounting with old kernel will see a warning like these in dmesg:
  overlayfs: cleanup of 'incompat_features/incompat_index' failed (-39)
  overlayfs: cleanup of 'work/incompat_features' failed (-39)
  overlayfs: cleanup of 'ovl-work/work' failed (-39)
  overlayfs: failed to create directory /vdf/ovl-work/work (errno: 17);
             mounting read-only

These warnings should give the hint to the user that:
1. mount failure is caused by backward incompatible features
2. mount failure can be resolved by manually removing the "work" directory

There is nothing preventing users on old kernels from manually removing
workdir entirely or mounting overlay with a new workdir, so this is in
no way a full proof backward compatibility enforcement, but only a best
effort approach to complement the backward compatibility disclaimers
in Kconfig for enabling backward incompatible features (e.g.
OVERLAY_FS_INDEX_INCOMAPT).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Kconfig     | 12 +++++++
 fs/overlayfs/dir.c       | 36 ++++++++++++++++++++
 fs/overlayfs/overlayfs.h | 15 +++++++-
 fs/overlayfs/readdir.c   | 33 +++++++++++++++---
 fs/overlayfs/super.c     | 18 +++++++++-
 fs/overlayfs/util.c      | 89 ++++++++++++++++++++++++++++++++++++++++++++++++
 6 files changed, 196 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index 02295e10ffbe..7c97550ba39f 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -44,3 +44,15 @@ config OVERLAY_FS_INDEX_INCOMPAT
 	  If this config option is enabled then inodes index is declared an
 	  incompatible feature and kernel will refuse to mount an overlay with
 	  inodes index off when a non-empty index directory exists.
+
+	  After mounting an overlay filesystems once with incompatible index
+	  enabled, mounting the overlay with a kernel that doesn't support
+	  inodes index feature or mounting with inodes index off will either
+	  fail to mount or fallback to read-only mount.
+
+	  The inodes index dir resides under the 'workdir' path provided with
+	  overlay mount options, so it is still possible to mount the overlay
+	  on a kernel that doesn't support incompatible index feature, by
+	  cleaning the content of 'workdir' or by providing an alternative
+	  'workdir' path.  In that case, mounting the same overlay again with
+	  inodes index enabled will have unexpected results.
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 7e2f748d5a7c..63a3b848bdf0 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -159,6 +159,42 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 	return err;
 }
 
+/* Create object if it doesn't exist */
+struct dentry *ovl_test_create(struct dentry *parent, const char *name,
+			       umode_t mode)
+{
+	struct inode *dir = parent->d_inode;
+	struct dentry *dentry;
+	int err;
+
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+
+	dentry = lookup_one_len(name, parent, strlen(name));
+	err = PTR_ERR(dentry);
+	if (IS_ERR(dentry))
+		return dentry;
+
+	if (!dentry->d_inode) {
+		err = ovl_create_real(dir, dentry,
+				      &(struct cattr){.mode = mode},
+				      NULL, true);
+	} else if ((mode ^ d_inode(dentry)->i_mode) & S_IFMT) {
+		/* File exists but with wrong file type? */
+		err = -EEXIST;
+	} else {
+		err = 0;
+	}
+
+	inode_unlock(dir);
+
+	if (err) {
+		dput(dentry);
+		return ERR_PTR(err);
+	}
+
+	return dentry;
+}
+
 static int ovl_set_opaque_xerr(struct dentry *dentry, struct dentry *upper,
 			       int xerr)
 {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 3f9a7625bded..d1172b3f9a99 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -27,11 +27,15 @@ enum ovl_path_type {
 #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
 #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
 
+#define OVL_INCOMPAT_FEATURES_NAME "incompat_features"
+#define OVL_FEATURE_INCOMPAT_INDEX "incompat_index"
+
 enum ovl_flag {
 	OVL_IMPURE,
 	OVL_INDEX,
 };
 
+
 /*
  * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
  * where:
@@ -242,6 +246,12 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 	return ovl_check_dir_xattr(dentry, OVL_XATTR_IMPURE);
 }
 
+bool ovl_is_features_dir(struct dentry *dentry, const char ***features);
+bool ovl_is_feature_supported(const char *name, int namelen,
+			      const char **features);
+struct ovl_fs;
+int ovl_enable_feature(struct ovl_fs *ofs, const char *dirname,
+		       const char *name);
 
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
@@ -261,7 +271,8 @@ void ovl_cache_free(struct list_head *list);
 void ovl_dir_cache_free(struct inode *inode);
 int ovl_check_d_type_supported(struct path *realpath);
 void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
-			 struct dentry *dentry, int level);
+			 struct dentry *dentry, int level,
+			 const char **features);
 int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			 struct path *lowerstack, unsigned int numlower);
 
@@ -311,6 +322,8 @@ struct cattr {
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct cattr *attr,
 		    struct dentry *hardlink, bool debug);
+struct dentry *ovl_test_create(struct dentry *parent, const char *name,
+			       umode_t mode);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 698b74dd750e..53ee99ec5b1c 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -922,7 +922,8 @@ int ovl_check_d_type_supported(struct path *realpath)
 	return rdd.d_type_supported;
 }
 
-static void ovl_workdir_cleanup_recurse(struct path *path, int level)
+static void ovl_workdir_cleanup_recurse(struct path *path, int level,
+					const char **features)
 {
 	int err;
 	struct inode *dir = path->dentry->d_inode;
@@ -950,12 +951,19 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
 				continue;
 			if (p->len == 2 && p->name[1] == '.')
 				continue;
+		} else if (features && level == 1 &&
+			   !ovl_is_feature_supported(p->name, p->len,
+						     features)) {
+			pr_warn("overlayfs: feature '%.*s' not supported\n",
+				p->len, p->name);
+			break;
 		}
 		dentry = lookup_one_len(p->name, path->dentry, p->len);
 		if (IS_ERR(dentry))
 			continue;
 		if (dentry->d_inode)
-			ovl_workdir_cleanup(dir, path->mnt, dentry, level);
+			ovl_workdir_cleanup(dir, path->mnt, dentry, level,
+					    features);
 		dput(dentry);
 	}
 	inode_unlock(dir);
@@ -964,11 +972,26 @@ static void ovl_workdir_cleanup_recurse(struct path *path, int level)
 }
 
 void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
-			 struct dentry *dentry, int level)
+			 struct dentry *dentry, int level,
+			 const char **features)
 {
 	int err;
 
-	if (!d_is_dir(dentry) || level > 1) {
+	/*
+	 * The features directories are treated specially:
+	 * Recursive cleanup iterates 2 levels inside features dir.
+	 * Iteration inside features dir aborts on unsupported feature name.
+	 * By aborting cleanup on unsupported feature name, remove of the
+	 * features dir will fail followed by failure to remove "work" dir
+	 * and resulting in read-only mount.
+	 * This is a hack to force read-only mount with older kernels that
+	 * do not know about features, but only iterate recursively 2 levels
+	 * inside "work" dir.
+	 */
+	if (!features && d_is_dir(dentry) && level == 1 &&
+	    ovl_is_features_dir(dentry, &features)) {
+		level = 0;
+	} else if (!d_is_dir(dentry) || level > 1) {
 		ovl_cleanup(dir, dentry);
 		return;
 	}
@@ -978,7 +1001,7 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 		struct path path = { .mnt = mnt, .dentry = dentry };
 
 		inode_unlock(dir);
-		ovl_workdir_cleanup_recurse(&path, level + 1);
+		ovl_workdir_cleanup_recurse(&path, level + 1, features);
 		inode_lock_nested(dir, I_MUTEX_PARENT);
 		ovl_cleanup(dir, dentry);
 	}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 0dc6d61f828a..49c6a7ad695f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -491,7 +491,7 @@ static struct dentry *ovl_workdir_create(struct super_block *sb,
 				goto out_unlock;
 
 			retried = true;
-			ovl_workdir_cleanup(dir, mnt, work, 0);
+			ovl_workdir_cleanup(dir, mnt, work, 0, NULL);
 			dput(work);
 			goto retry;
 		}
@@ -1089,6 +1089,22 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			if (err)
 				pr_err("overlayfs: failed to verify index dir origin\n");
 
+			/*
+			 * Prevent from mounting this overlay with index=off
+			 * or with kernel without incompat index support and
+			 * corrupting the index.
+			 * Enable incompat index feature if verified index dir
+			 * exists and regardless if ovl_indexdir_cleanup() will
+			 * fail.
+			 */
+			if (!err && ovl_incompat_index) {
+				err = ovl_enable_feature(ufs,
+						 OVL_INCOMPAT_FEATURES_NAME,
+						 OVL_FEATURE_INCOMPAT_INDEX);
+				if (err)
+					goto out_put_indexdir;
+			}
+
 			/* Cleanup bad/stale/orphan index entries */
 			if (!err)
 				err = ovl_indexdir_cleanup(ufs->indexdir,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index b9b239fa5cfd..bef850632c80 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -579,3 +579,92 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
 	pr_err("overlayfs: failed to lock workdir+upperdir\n");
 	return -EIO;
 }
+
+static const char * const ovl_incompat_features[] = {
+#ifdef CONFIG_OVERLAY_FS_INDEX_INCOMPAT
+	OVL_FEATURE_INCOMPAT_INDEX,
+#endif
+	NULL,
+};
+
+bool ovl_is_features_dir(struct dentry *dentry, const char ***features)
+{
+	if (!dentry || !d_is_dir(dentry))
+		return false;
+
+	if (!strcmp(dentry->d_name.name, OVL_INCOMPAT_FEATURES_NAME)) {
+		*features = (const char **)ovl_incompat_features;
+		return true;
+	}
+
+	return false;
+}
+
+bool ovl_is_feature_supported(const char *name, int namelen,
+			      const char **features)
+{
+	const char **p;
+
+	for (p = features; *p; p++) {
+		if (!p[namelen] && !strncmp(name, *p, namelen))
+			return true;
+	}
+	return false;
+}
+
+/*
+ * Create a non-empty directory under features dir, e.g.:
+ * work/incompat_features/incompat_index
+ */
+static int ovl_create_feature_dir(struct dentry *dentry,  struct vfsmount *mnt,
+				  const char *dirname, const char *name)
+{
+	struct dentry *features, *feature, *enabled;
+	int err;
+
+	features = ovl_test_create(dentry, dirname, S_IFDIR | 0);
+	err = PTR_ERR(features);
+	if (IS_ERR(features))
+		return err;
+
+	feature = ovl_test_create(features, name, S_IFDIR | 0);
+	dput(features);
+	err = PTR_ERR(feature);
+	if (IS_ERR(feature))
+		return err;
+
+	enabled = ovl_test_create(feature, "enabled", S_IFREG | 0);
+	dput(feature);
+	err = PTR_ERR(enabled);
+	if (IS_ERR(enabled))
+		return err;
+
+	dput(enabled);
+
+	return 0;
+}
+
+/*
+ * Prevent kernel with no support for the enabled feature from mounting
+ * this overlay read-write and corrupting the index by creating a
+ * non-empty nested dir entires in workdir, that old kernels
+ * do not know how to clean on mount.
+ */
+int ovl_enable_feature(struct ovl_fs *ofs, const char *dirname,
+		       const char *name)
+{
+	struct vfsmount *mnt = ofs->upper_mnt;
+	int err;
+
+	if (!mnt || !ofs->workdir || !ofs->indexdir)
+		return -EROFS;
+
+	err = mnt_want_write(mnt);
+	if (err)
+		return err;
+
+	err = ovl_create_feature_dir(ofs->workdir, mnt, dirname, name);
+
+	mnt_drop_write(mnt);
+	return err;
+}
-- 
2.7.4
