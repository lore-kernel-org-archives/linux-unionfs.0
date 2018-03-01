Return-Path: <houtao1@huawei.com>
From: Hou Tao <houtao1@huawei.com>
Subject: [RFC][PATCH v3] overlay: hardlink all whiteout files into a single one
Date: Thu, 1 Mar 2018 14:45:26 +0800
Message-ID: <20180301064526.17216-1-houtao1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

Now each whiteout file will be assigned a new inode. To reduce the
overhead of allocating and freeing inodes in upper fs, creating a
singleton whiteout file under workdir and hardlink all whiteout files
into it.

The effect is obvious: under a KVM VM, the time used for removing the
linux kernel source tree is reduced from 17s to 10s.

Got the idea from aufs4.

Signed-off-by: Hou Tao <houtao1@huawei.com>
---
v3:
    * rebased on 4.16-rc3
    * add a limitation on the hardlinks of singleton whiteout, and it
      can be adjusted by module param singleton_wt_link_max. During
      the mount procoess, if the value of limit is less than or equal to 1,
      the singleon whiteout will be disabled (suggested by Amir)
    * rename ovl_make_singleton_whiteout_nolock() to
      ovl_make_singleton_whiteout_locked() (also from Amir)
    * check errors more strictly: treat singleton whiteout creation
      failure as an error and abort the mount or unlink procedure
    * remove unnecessary mnt_want_write() from ovl_make_singleton_whiteout(),
      because mnt_want_write() has been invoked by its caller.
    * document the lock assertions for newly-added helpers
v2:
    * address the comments from Miklos and Amir: handle -EMLINK and -EXDEV
      when hard-linking whiteout file to the singleton

    * move the singleton whiteout from workbasedir to workdir to simplify
      the lock of inodes
v1:
    * https://www.spinics.net/lists/linux-unionfs/msg04023.html
---
 fs/overlayfs/dir.c       | 150 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/overlayfs/overlayfs.h |   5 +-
 fs/overlayfs/ovl_entry.h |   5 ++
 fs/overlayfs/readdir.c   |   2 +-
 fs/overlayfs/super.c     |   5 ++
 fs/overlayfs/util.c      |   4 +-
 6 files changed, 161 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 839709c7803a..c87360d22f92 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -24,6 +24,12 @@ module_param_named(redirect_max, ovl_redirect_max, ushort, 0644);
 MODULE_PARM_DESC(ovl_redirect_max,
 		 "Maximum length of absolute redirect xattr value");
 
+static unsigned int ovl_singleton_wt_link_max = 255;
+module_param_named(singleton_whiteout_link_max,
+		ovl_singleton_wt_link_max, uint, 0644);
+MODULE_PARM_DESC(ovl_singleton_wt_link_max,
+		"Maximum hardlinks of a whiteout singleton");
+
 int ovl_cleanup(struct inode *wdir, struct dentry *wdentry)
 {
 	int err;
@@ -62,18 +68,149 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
 	return temp;
 }
 
+#define OVL_SINGLETON_WHITEOUT_NAME "whiteout"
+
+/* caller holds write lock (i_rwsem) of dir */
+static int ovl_make_singleton_whiteout_locked(struct ovl_fs *ofs,
+		struct dentry *dir, const char *name)
+{
+	int err = 0;
+	struct inode *inode = d_inode(dir);
+	struct dentry *whiteout;
+
+	whiteout = lookup_one_len(name, dir, strlen(name));
+	if (IS_ERR(whiteout))
+		return PTR_ERR(whiteout);
+
+	if (ovl_is_whiteout(whiteout)) {
+		ofs->whiteout = whiteout;
+	} else if (!whiteout->d_inode) {
+		err = ovl_do_whiteout(inode, whiteout);
+		if (!err)
+			ofs->whiteout = whiteout;
+		else
+			dput(whiteout);
+	} else {
+		/*
+		 * fallback to creating new whiteout file if
+		 * a non-whiteout file already exists
+		 */
+		dput(whiteout);
+	}
+
+	return err;
+}
+
+/*
+ * create a new whiteout file under workdir if it doesn't exist.
+ * If a non-whiteout file already exists, no error will be reported
+ * and the needed whiteout file will be newly created instead of
+ * being linked to a singleton whiteout.
+ */
+int ovl_make_singleton_whiteout(struct ovl_fs *ofs)
+{
+	int err;
+	struct inode *dir;
+
+	/* disable singleton whiteout */
+	if (ovl_singleton_wt_link_max <= 1)
+		return 0;
+
+	dir = d_inode(ofs->workdir);
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+
+	err = ovl_make_singleton_whiteout_locked(ofs, ofs->workdir,
+			OVL_SINGLETON_WHITEOUT_NAME);
+
+	inode_unlock(dir);
+
+	return err;
+}
+
+/*
+ * caller holds i_mutex of workdir to ensure the operations
+ * on the singletion whiteout are serialized.
+ */
+static int ovl_link_to_singleton_whiteout(struct ovl_fs *ofs,
+		struct dentry *whiteout, bool *create_instead)
+{
+	int err;
+	struct inode *wdir = d_inode(ofs->workdir);
+	struct dentry *singleton;
+	bool retried = false;
+
+	*create_instead = false;
+retry:
+	singleton = ofs->whiteout;
+	/* Create a new singletion whiteout when the limit is exceeded */
+	if (1 < ovl_singleton_wt_link_max &&
+		singleton->d_inode->i_nlink >= ovl_singleton_wt_link_max)
+		err = -EMLINK;
+	else
+		err = ovl_do_link(singleton, wdir, whiteout, false);
+
+	if (!err) {
+		goto out;
+	} else if (err == -EMLINK && !retried) {
+		/*
+		 * The singleton already has the maximum number of links to it,
+		 * so remove the old singleton and create a new one
+		 */
+		ofs->whiteout = NULL;
+		err = ovl_do_unlink(wdir, singleton);
+		if (err) {
+			dput(singleton);
+			goto out;
+		}
+
+		dput(singleton);
+		err = ovl_make_singleton_whiteout_locked(ofs, ofs->workdir,
+				OVL_SINGLETON_WHITEOUT_NAME);
+		if (err)
+			goto out;
+
+		retried = true;
+		if (ofs->whiteout)
+			goto retry;
+		else
+			goto out_fallback;
+	} else if (err == -EXDEV) {
+		/*
+		 * upper fs may have a project id different than singleton,
+		 * so fall back to create whiteout directly
+		 */
+		goto out_fallback;
+	} else {
+		goto out;
+	}
+
+out_fallback:
+	*create_instead = true;
+out:
+	return err;
+}
+
 /* caller holds i_mutex on workdir */
-static struct dentry *ovl_whiteout(struct dentry *workdir)
+static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry *workdir)
 {
 	int err;
 	struct dentry *whiteout;
 	struct inode *wdir = workdir->d_inode;
+	bool create_instead;
 
 	whiteout = ovl_lookup_temp(workdir);
 	if (IS_ERR(whiteout))
 		return whiteout;
 
-	err = ovl_do_whiteout(wdir, whiteout);
+	if (workdir == ofs->workdir && ofs->whiteout)
+		err = ovl_link_to_singleton_whiteout(ofs, whiteout,
+				&create_instead);
+	else
+		create_instead = true;
+
+	if (create_instead)
+		err = ovl_do_whiteout(wdir, whiteout);
+
 	if (err) {
 		dput(whiteout);
 		whiteout = ERR_PTR(err);
@@ -83,15 +220,15 @@ static struct dentry *ovl_whiteout(struct dentry *workdir)
 }
 
 /* Caller must hold i_mutex on both workdir and dir */
-int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
-			     struct dentry *dentry)
+int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workdir,
+		struct inode *dir, struct dentry *dentry)
 {
 	struct inode *wdir = workdir->d_inode;
 	struct dentry *whiteout;
 	int err;
 	int flags = 0;
 
-	whiteout = ovl_whiteout(workdir);
+	whiteout = ovl_whiteout(ofs, workdir);
 	err = PTR_ERR(whiteout);
 	if (IS_ERR(whiteout))
 		return err;
@@ -621,6 +758,7 @@ static bool ovl_matches_upper(struct dentry *dentry, struct dentry *upper)
 static int ovl_remove_and_whiteout(struct dentry *dentry,
 				   struct list_head *list)
 {
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct dentry *workdir = ovl_workdir(dentry);
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
 	struct dentry *upper;
@@ -654,7 +792,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry,
 		goto out_dput_upper;
 	}
 
-	err = ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), upper);
+	err = ovl_cleanup_and_whiteout(ofs, workdir, d_inode(upperdir), upper);
 	if (err)
 		goto out_d_drop;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 0df25a9c94bd..d46894598f05 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -343,8 +343,8 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
 struct dentry *ovl_lookup_temp(struct dentry *workdir);
-int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
-			     struct dentry *dentry);
+int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workdir,
+		struct inode *dir, struct dentry *dentry);
 struct cattr {
 	dev_t rdev;
 	umode_t mode;
@@ -354,6 +354,7 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct cattr *attr,
 		    struct dentry *hardlink, bool debug);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
+int ovl_make_singleton_whiteout(struct ovl_fs *ofs);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index bfef6edcc111..5a7929f8a778 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -43,6 +43,11 @@ struct ovl_fs {
 	struct dentry *workdir;
 	/* index directory listing overlay inodes by origin file handle */
 	struct dentry *indexdir;
+	/*
+	 * the singleton whiteout file under workdir: all newly created
+	 * whiteout files will be linked to it if possible
+	 */
+	struct dentry *whiteout;
 	long namelen;
 	/* pathnames of lower and upper dirs, for show_options */
 	struct ovl_config config;
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index c11f5c0906c3..4858ea6e8b99 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1084,7 +1084,7 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 			 * Whiteout orphan index to block future open by
 			 * handle after overlay nlink dropped to zero.
 			 */
-			err = ovl_cleanup_and_whiteout(indexdir, dir, index);
+			err = ovl_cleanup_and_whiteout(ofs, indexdir, dir, index);
 		} else {
 			/* Cleanup orphan index entries */
 			err = ovl_cleanup(dir, index);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9ee37c76091d..0b26523eaf43 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -229,6 +229,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	unsigned i;
 
 	dput(ofs->indexdir);
+	dput(ofs->whiteout);
 	dput(ofs->workdir);
 	if (ofs->workdir_locked)
 		ovl_inuse_unlock(ofs->workbasedir);
@@ -961,6 +962,10 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	if (!ofs->workdir)
 		goto out;
 
+	err = ovl_make_singleton_whiteout(ofs);
+	if (err < 0)
+		goto out;
+
 	/*
 	 * Upper should support d_type, else whiteouts are visible.  Given
 	 * workdir and upper are on same fs, we can do iterate_dir() on
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 930784a26623..4b8bbb63bcec 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -533,8 +533,10 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	if (IS_ERR(index)) {
 		index = NULL;
 	} else if (ovl_index_all(dentry->d_sb)) {
+		struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+
 		/* Whiteout orphan index to block future open by handle */
-		err = ovl_cleanup_and_whiteout(indexdir, dir, index);
+		err = ovl_cleanup_and_whiteout(ofs, indexdir, dir, index);
 	} else {
 		/* Cleanup orphan index entries */
 		err = ovl_cleanup(dir, index);
-- 
2.13.6
