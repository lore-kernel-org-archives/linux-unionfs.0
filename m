From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/4] ovl: introduce incompatible index feature
Date: Tue, 24 Oct 2017 13:02:58 +0300
Message-ID: <1508839381-24750-2-git-send-email-amir73il@gmail.com>
References: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:54702 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752003AbdJXKCf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2017 06:02:35 -0400
Received: by mail-wr0-f193.google.com with SMTP id o44so20044019wrf.11
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2017 03:02:34 -0700 (PDT)
In-Reply-To: <1508839381-24750-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Introduce a new config option OVERLAY_FS_INDEX_INCOMPAT.

If this config option is enabled then inodes index is declared
an incompatible feature and kernel will refuse to mount an overlay
with inodes index off when a non-empty index directory exists.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Kconfig     |  8 ++++++++
 fs/overlayfs/dir.c       | 30 ++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  3 ++-
 fs/overlayfs/super.c     | 24 +++++++++++++++++++++++-
 4 files changed, 63 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index cbfc196e5dc5..e5e6dec7d177 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -43,3 +43,11 @@ config OVERLAY_FS_INDEX
 	  outcomes.  However, mounting the same overlay with an old kernel
 	  read-write and then mounting it again with a new kernel, will have
 	  unexpected results.
+
+config OVERLAY_FS_INDEX_INCOMPAT
+	bool "Overlayfs: support incompatible index feature"
+	depends on OVERLAY_FS_INDEX
+	help
+	  If this config option is enabled then inodes index is declared an
+	  incompatible feature and kernel will refuse to mount an overlay with
+	  inodes index off when a non-empty index directory exists.
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index cc961a3bd3bd..7e2f748d5a7c 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/xattr.h>
 #include <linux/security.h>
@@ -43,6 +44,35 @@ int ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
 	return err;
 }
 
+int ovl_cleanup_path(struct path *path, const char *name)
+{
+	struct inode *dir = path->dentry->d_inode;
+	struct dentry *dentry;
+	int err;
+
+	err = mnt_want_write(path->mnt);
+	if (err)
+		return err;
+
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+
+	dentry = lookup_one_len(name, path->dentry, strlen(name));
+	if (IS_ERR(dentry)) {
+		err = PTR_ERR(dentry);
+		dentry = NULL;
+	} else if (!dentry->d_inode) {
+		err = -ENOENT;
+	} else {
+		err = ovl_cleanup(dir, dentry);
+	}
+
+	dput(dentry);
+	inode_unlock(dir);
+	mnt_drop_write(path->mnt);
+
+	return err;
+}
+
 struct dentry *ovl_lookup_temp(struct dentry *workdir)
 {
 	struct dentry *temp;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d9a0edd4e57e..3f9a7625bded 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -300,6 +300,8 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
+int ovl_cleanup(struct inode *dir, struct dentry *dentry);
+int ovl_cleanup_path(struct path *path, const char *name);
 struct dentry *ovl_lookup_temp(struct dentry *workdir);
 struct cattr {
 	dev_t rdev;
@@ -309,7 +311,6 @@ struct cattr {
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct cattr *attr,
 		    struct dentry *hardlink, bool debug);
-int ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f5738e96a052..0dc6d61f828a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -39,6 +39,9 @@ module_param_named(index, ovl_index_def, bool, 0644);
 MODULE_PARM_DESC(ovl_index_def,
 		 "Default to on or off for the inodes index feature");
 
+static const bool ovl_incompat_index =
+	IS_ENABLED(CONFIG_OVERLAY_FS_INDEX_INCOMPAT);
+
 static void ovl_dentry_release(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -1060,7 +1063,15 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
 		ufs->same_sb = NULL;
 
-	if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
+	if (ovl_force_readonly(ufs)) {
+		/*
+		 * Cannot enable index without upperdir/workdir and cannot
+		 * test for incompat index dir, but cannot corrupt incompat
+		 * index dir either.
+		 */
+		ufs->config.index = false;
+		pr_warn("overlayfs: no upperdir/workdir, falling back to index=off.\n");
+	} else if (ufs->config.index) {
 		/* Verify lower root is upper root origin */
 		err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
 					stack[0].dentry, false, true);
@@ -1088,6 +1099,17 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
 		if (err)
 			goto out_put_indexdir;
+
+	} else if (ovl_incompat_index) {
+		/*
+		 * Try to remove empty index dir if it exists -
+		 * failure means we need to abort the mount.
+		 */
+		err = ovl_cleanup_path(&workpath, OVL_INDEXDIR_NAME);
+		if (err && err != -ENOENT) {
+			pr_err("overlayfs: incompatible index dir exists, try deleting index dir to disable inodes index.\n");
+			goto out_put_lower_mnt;
+		}
 	}
 
 	/* Show index=off/on in /proc/mounts for any of the reasons above */
-- 
2.7.4
