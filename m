Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:39554 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730113AbeGaLEh (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jul 2018 07:04:37 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1FBF5DEE1772A
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Jul 2018 17:25:08 +0800 (CST)
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH v2 1/9] ovl: store ovl upper root path in ovl_fs
Date: Tue, 31 Jul 2018 17:37:19 +0800
Message-ID: <20180731093727.26855-2-yi.zhang@huawei.com>
In-Reply-To: <20180731093727.26855-1-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Store upper layer's ovl_layer structure and root upper dentry into
ovl_fs sturcture for the upcoming "feature set" feature. "feature set"
feature will read upper layer's feature from upper root dentry and save
feature bit mask into upper layer's ovl_layer structure.

This patch relpace ->upper_mnt to ->upper_layer and add a helper func
ovl_upper_mnt() to get ->upper_mnt easily.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
---
 fs/overlayfs/export.c    | 12 +++++-------
 fs/overlayfs/inode.c     |  4 ++--
 fs/overlayfs/namei.c     |  2 +-
 fs/overlayfs/ovl_entry.h |  9 ++++++++-
 fs/overlayfs/readdir.c   |  2 +-
 fs/overlayfs/super.c     | 39 ++++++++++++++++++++++++---------------
 fs/overlayfs/util.c      | 10 +++++-----
 7 files changed, 46 insertions(+), 32 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 9941ece61a14..0a11bd46895a 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -207,7 +207,7 @@ static int ovl_check_encode_origin(struct dentry *dentry)
 	 * ovl_connect_layer() will try to make origin's layer "connected" by
 	 * copying up a "connectable" ancestor.
 	 */
-	if (d_is_dir(dentry) && ofs->upper_mnt)
+	if (d_is_dir(dentry) && ofs->upper_layer)
 		return ovl_connect_layer(dentry);
 
 	/* Lower file handle for indexed and non-upper dir/non-dir */
@@ -434,7 +434,6 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
 					    struct ovl_layer *layer)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
-	struct ovl_layer upper_layer = { .mnt = ofs->upper_mnt };
 	struct dentry *index = NULL;
 	struct dentry *this = NULL;
 	struct inode *inode;
@@ -476,7 +475,7 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
 		 * recursive call walks back from indexed upper to the topmost
 		 * connected/hashed upper parent (or up to root).
 		 */
-		this = ovl_lookup_real(sb, upper, &upper_layer);
+		this = ovl_lookup_real(sb, upper, ofs->upper_layer);
 		dput(upper);
 	}
 
@@ -656,8 +655,7 @@ static struct dentry *ovl_get_dentry(struct super_block *sb,
 				     struct dentry *index)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
-	struct ovl_layer upper_layer = { .mnt = ofs->upper_mnt };
-	struct ovl_layer *layer = upper ? &upper_layer : lowerpath->layer;
+	struct ovl_layer *layer = upper ? ofs->upper_layer : lowerpath->layer;
 	struct dentry *real = upper ?: (index ?: lowerpath->dentry);
 
 	/*
@@ -685,10 +683,10 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
 	struct dentry *dentry;
 	struct dentry *upper;
 
-	if (!ofs->upper_mnt)
+	if (!ofs->upper_layer)
 		return ERR_PTR(-EACCES);
 
-	upper = ovl_decode_real_fh(fh, ofs->upper_mnt, true);
+	upper = ovl_decode_real_fh(fh, ovl_upper_mnt(ofs), true);
 	if (IS_ERR_OR_NULL(upper))
 		return upper;
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ed16a898caeb..0b6ecf26c066 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -421,7 +421,7 @@ int ovl_update_time(struct inode *inode, struct timespec64 *ts, int flags)
 	if (flags & S_ATIME) {
 		struct ovl_fs *ofs = inode->i_sb->s_fs_info;
 		struct path upperpath = {
-			.mnt = ofs->upper_mnt,
+			.mnt = ovl_upper_mnt(ofs),
 			.dentry = ovl_upperdentry_dereference(OVL_I(inode)),
 		};
 
@@ -733,7 +733,7 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 		return true;
 
 	/* Yes, if won't be copied up */
-	if (!ofs->upper_mnt)
+	if (!ofs->upper_layer)
 		return true;
 
 	/* No, if lower hardlink is or will be broken on copy up */
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c993dd8db739..bb2d347c0a7e 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -475,7 +475,7 @@ struct dentry *ovl_index_upper(struct ovl_fs *ofs, struct dentry *index)
 	if (IS_ERR_OR_NULL(fh))
 		return ERR_CAST(fh);
 
-	upper = ovl_decode_real_fh(fh, ofs->upper_mnt, true);
+	upper = ovl_decode_real_fh(fh, ovl_upper_mnt(ofs), true);
 	kfree(fh);
 
 	if (IS_ERR_OR_NULL(upper))
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 41655a7d6894..38ff6689a293 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -28,6 +28,7 @@ struct ovl_sb {
 
 struct ovl_layer {
 	struct vfsmount *mnt;
+	/* Private fs info of this layer (upper fs == NULL) */
 	struct ovl_sb *fs;
 	/* Index of this layer in fs root (upper idx == 0) */
 	int idx;
@@ -42,7 +43,8 @@ struct ovl_path {
 
 /* private information held for overlayfs's superblock */
 struct ovl_fs {
-	struct vfsmount *upper_mnt;
+	struct ovl_layer *upper_layer;
+	struct dentry *upperdir;
 	unsigned int numlower;
 	/* Number of unique lower sb that differ from upper sb */
 	unsigned int numlowerfs;
@@ -109,3 +111,8 @@ static inline struct dentry *ovl_upperdentry_dereference(struct ovl_inode *oi)
 {
 	return READ_ONCE(oi->__upperdentry);
 }
+
+static inline struct vfsmount *ovl_upper_mnt(struct ovl_fs *ofs)
+{
+	return ofs->upper_layer ? ofs->upper_layer->mnt : NULL;
+}
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index ef1fe42ff7bb..1b70ffe4a633 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1069,7 +1069,7 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 	struct dentry *indexdir = ofs->indexdir;
 	struct dentry *index = NULL;
 	struct inode *dir = indexdir->d_inode;
-	struct path path = { .mnt = ofs->upper_mnt, .dentry = indexdir };
+	struct path path = { .mnt = ovl_upper_mnt(ofs), .dentry = indexdir };
 	LIST_HEAD(list);
 	struct rb_root root = RB_ROOT;
 	struct ovl_cache_entry *p;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 704b37311467..cce4f58458dc 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -240,8 +240,10 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 		ovl_inuse_unlock(ofs->workbasedir);
 	dput(ofs->workbasedir);
 	if (ofs->upperdir_locked)
-		ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
-	mntput(ofs->upper_mnt);
+		ovl_inuse_unlock(ovl_upper_mnt(ofs)->mnt_root);
+	dput(ofs->upperdir);
+	mntput(ovl_upper_mnt(ofs));
+	kfree(ofs->upper_layer);
 	for (i = 0; i < ofs->numlower; i++)
 		mntput(ofs->lower_layers[i].mnt);
 	for (i = 0; i < ofs->numlowerfs; i++)
@@ -272,7 +274,7 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 	struct super_block *upper_sb;
 	int ret;
 
-	if (!ofs->upper_mnt)
+	if (!ofs->upper_layer)
 		return 0;
 
 	/*
@@ -286,7 +288,7 @@ static int ovl_sync_fs(struct super_block *sb, int wait)
 	if (!wait)
 		return 0;
 
-	upper_sb = ofs->upper_mnt->mnt_sb;
+	upper_sb = ovl_upper_mnt(ofs)->mnt_sb;
 
 	down_read(&upper_sb->s_umount);
 	ret = sync_filesystem(upper_sb);
@@ -324,7 +326,7 @@ static int ovl_statfs(struct dentry *dentry, struct kstatfs *buf)
 /* Will this overlay be forced to mount/remount ro? */
 static bool ovl_force_readonly(struct ovl_fs *ofs)
 {
-	return (!ofs->upper_mnt || !ofs->workdir);
+	return (!ofs->upper_layer || !ofs->workdir);
 }
 
 static const char *ovl_redirect_mode_def(void)
@@ -579,7 +581,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 					 const char *name, bool persist)
 {
 	struct inode *dir =  ofs->workbasedir->d_inode;
-	struct vfsmount *mnt = ofs->upper_mnt;
+	struct vfsmount *mnt = ovl_upper_mnt(ofs);
 	struct dentry *work;
 	int err;
 	bool retried = false;
@@ -989,7 +991,14 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
 
 	/* Don't inherit atime flags */
 	upper_mnt->mnt_flags &= ~(MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME);
-	ofs->upper_mnt = upper_mnt;
+
+	err = -ENOMEM;
+	ofs->upper_layer = kzalloc(sizeof(struct ovl_layer), GFP_KERNEL);
+	if (ofs->upper_layer == NULL)
+		goto out;
+
+	ofs->upper_layer->mnt = upper_mnt;
+	ofs->upperdir = dget(upperpath->dentry);
 	err = 0;
 out:
 	return err;
@@ -997,7 +1006,7 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
 
 static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 {
-	struct vfsmount *mnt = ofs->upper_mnt;
+	struct vfsmount *mnt = ovl_upper_mnt(ofs);
 	struct dentry *temp;
 	int fh_type;
 	int err;
@@ -1114,7 +1123,7 @@ static int ovl_get_workdir(struct ovl_fs *ofs, struct path *upperpath)
 static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
 			    struct path *upperpath)
 {
-	struct vfsmount *mnt = ofs->upper_mnt;
+	struct vfsmount *mnt = ovl_upper_mnt(ofs);
 	int err;
 
 	err = mnt_want_write(mnt);
@@ -1169,7 +1178,7 @@ static int ovl_get_fsid(struct ovl_fs *ofs, struct super_block *sb)
 	int err;
 
 	/* fsid 0 is reserved for upper fs even with non upper overlay */
-	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb == sb)
+	if (ofs->upper_layer && ovl_upper_mnt(ofs)->mnt_sb == sb)
 		return 0;
 
 	for (i = 0; i < ofs->numlowerfs; i++) {
@@ -1246,7 +1255,7 @@ static int ovl_get_lower_layers(struct ovl_fs *ofs, struct path *stack,
 	 * bits reserved for fsid, it emits a warning and uses the original
 	 * inode number.
 	 */
-	if (!ofs->numlowerfs || (ofs->numlowerfs == 1 && !ofs->upper_mnt)) {
+	if (!ofs->numlowerfs || (ofs->numlowerfs == 1 && !ofs->upper_layer)) {
 		ofs->xino_bits = 0;
 		ofs->config.xino = OVL_XINO_OFF;
 	} else if (ofs->config.xino == OVL_XINO_ON && !ofs->xino_bits) {
@@ -1409,8 +1418,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (!ofs->workdir)
 			sb->s_flags |= SB_RDONLY;
 
-		sb->s_stack_depth = ofs->upper_mnt->mnt_sb->s_stack_depth;
-		sb->s_time_gran = ofs->upper_mnt->mnt_sb->s_time_gran;
+		sb->s_stack_depth = ovl_upper_mnt(ofs)->mnt_sb->s_stack_depth;
+		sb->s_time_gran = ovl_upper_mnt(ofs)->mnt_sb->s_time_gran;
 
 	}
 	oe = ovl_get_lowerstack(sb, ofs);
@@ -1419,7 +1428,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		goto out_err;
 
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
-	if (!ofs->upper_mnt)
+	if (!ofs->upper_layer)
 		sb->s_flags |= SB_RDONLY;
 
 	if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
@@ -1439,7 +1448,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	/* Show index=off in /proc/mounts for forced r/o mount */
 	if (!ofs->indexdir) {
 		ofs->config.index = false;
-		if (ofs->upper_mnt && ofs->config.nfs_export) {
+		if (ofs->upper_layer && ofs->config.nfs_export) {
 			pr_warn("overlayfs: NFS export requires an index dir, falling back to nfs_export=off.\n");
 			ofs->config.nfs_export = false;
 		}
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6f1078028c66..6499f3b6fc5a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -21,13 +21,13 @@
 int ovl_want_write(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
-	return mnt_want_write(ofs->upper_mnt);
+	return mnt_want_write(ovl_upper_mnt(ofs));
 }
 
 void ovl_drop_write(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
-	mnt_drop_write(ofs->upper_mnt);
+	mnt_drop_write(ovl_upper_mnt(ofs));
 }
 
 struct dentry *ovl_workdir(struct dentry *dentry)
@@ -48,8 +48,8 @@ struct super_block *ovl_same_sb(struct super_block *sb)
 	struct ovl_fs *ofs = sb->s_fs_info;
 
 	if (!ofs->numlowerfs)
-		return ofs->upper_mnt->mnt_sb;
-	else if (ofs->numlowerfs == 1 && !ofs->upper_mnt)
+		return ovl_upper_mnt(ofs)->mnt_sb;
+	else if (ofs->numlowerfs == 1 && !ofs->upper_layer)
 		return ofs->lower_fs[0].sb;
 	else
 		return NULL;
@@ -148,7 +148,7 @@ void ovl_path_upper(struct dentry *dentry, struct path *path)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 
-	path->mnt = ofs->upper_mnt;
+	path->mnt = ovl_upper_mnt(ofs);
 	path->dentry = ovl_dentry_upper(dentry);
 }
 
-- 
2.13.6

