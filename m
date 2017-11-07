From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 2/9] ovl: re-structure overlay lower layers in-memory
Date: Tue,  7 Nov 2017 18:58:02 +0200
Message-ID: <1510073889-11657-3-git-send-email-amir73il@gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:48490 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753842AbdKGQ5f (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:57:35 -0500
Received: by mail-wm0-f67.google.com with SMTP id p75so5169761wmg.3
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 08:57:34 -0800 (PST)
In-Reply-To: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

From: Chandan Rajendra <chandan@linux.vnet.ibm.com>

Define new structures to represent overlay instance lower layers and
overlay merge dir lower layers to make room for storing more per layer
information in-memory.

Instead of keeping the fs instance lower layers in an array of struct
vfsmount, keep them in an array of new struct ovl_layer, that has a
pointer to struct vfsmount.

Instead of keeping the dentry lower layers in an array of struct path,
keep them in an array of new struct ovl_path, that has a pointer to
struct dentry and to struct ovl_layer.

Store fs root layer index in struct layer to get from non-root dir layer
object to root dir layer layer object.

[amir: split re-structure from anonymous bdev patch
       store layer index in layer struct]

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 41 ++++++++++++++-----------------
 fs/overlayfs/overlayfs.h |  5 ++--
 fs/overlayfs/ovl_entry.h | 15 ++++++++++--
 fs/overlayfs/readdir.c   |  4 +--
 fs/overlayfs/super.c     | 63 +++++++++++++++++++++++++++---------------------
 fs/overlayfs/util.c      | 14 ++++++++++-
 6 files changed, 84 insertions(+), 58 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 505a4b8902fc..7b89f5944e04 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -285,16 +285,15 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 
 
 static int ovl_check_origin(struct dentry *upperdentry,
-			    struct path *lowerstack, unsigned int numlower,
-			    struct path **stackp, unsigned int *ctrp)
+			    struct ovl_path *lower, unsigned int numlower,
+			    struct ovl_path **stackp, unsigned int *ctrp)
 {
 	struct vfsmount *mnt;
 	struct dentry *origin = NULL;
 	int i;
 
-
 	for (i = 0; i < numlower; i++) {
-		mnt = lowerstack[i].mnt;
+		mnt = lower[i].layer->mnt;
 		origin = ovl_get_origin(upperdentry, mnt);
 		if (IS_ERR(origin))
 			return PTR_ERR(origin);
@@ -308,12 +307,12 @@ static int ovl_check_origin(struct dentry *upperdentry,
 
 	BUG_ON(*ctrp);
 	if (!*stackp)
-		*stackp = kmalloc(sizeof(struct path), GFP_KERNEL);
+		*stackp = kmalloc(sizeof(struct ovl_path), GFP_KERNEL);
 	if (!*stackp) {
 		dput(origin);
 		return -ENOMEM;
 	}
-	**stackp = (struct path) { .dentry = origin, .mnt = mnt };
+	**stackp = (struct ovl_path){.dentry = origin, .layer = lower[i].layer};
 	*ctrp = 1;
 
 	return 0;
@@ -383,13 +382,13 @@ int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
  * OVL_XATTR_ORIGIN and that origin file handle can be decoded to lower path.
  * Return 0 on match, -ESTALE on mismatch or stale origin, < 0 on error.
  */
-int ovl_verify_index(struct dentry *index, struct path *lowerstack,
+int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
 		     unsigned int numlower)
 {
 	struct ovl_fh *fh = NULL;
 	size_t len;
-	struct path origin = { };
-	struct path *stack = &origin;
+	struct ovl_path origin = { };
+	struct ovl_path *stack = &origin;
 	unsigned int ctr = 0;
 	int err;
 
@@ -428,7 +427,7 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 	if (err)
 		goto fail;
 
-	err = ovl_check_origin(index, lowerstack, numlower, &stack, &ctr);
+	err = ovl_check_origin(index, lower, numlower, &stack, &ctr);
 	if (!err && !ctr)
 		err = -ESTALE;
 	if (err)
@@ -567,7 +566,8 @@ int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
 		idx++;
 	}
 	BUG_ON(idx > oe->numlower);
-	*path = oe->lowerstack[idx - 1];
+	path->dentry = oe->lowerstack[idx - 1].dentry;
+	path->mnt = oe->lowerstack[idx - 1].layer->mnt;
 
 	return (idx < oe->numlower) ? idx + 1 : -1;
 }
@@ -580,7 +580,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
-	struct path *stack = NULL;
+	struct ovl_path *stack = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
 	struct dentry *index = NULL;
 	unsigned int ctr = 0;
@@ -645,17 +645,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (!d.stop && poe->numlower) {
 		err = -ENOMEM;
-		stack = kcalloc(ofs->numlower, sizeof(struct path),
+		stack = kcalloc(ofs->numlower, sizeof(struct ovl_path),
 				GFP_KERNEL);
 		if (!stack)
 			goto out_put_upper;
 	}
 
 	for (i = 0; !d.stop && i < poe->numlower; i++) {
-		struct path lowerpath = poe->lowerstack[i];
+		struct ovl_path lower = poe->lowerstack[i];
 
 		d.last = i == poe->numlower - 1;
-		err = ovl_lookup_layer(lowerpath.dentry, &d, &this);
+		err = ovl_lookup_layer(lower.dentry, &d, &this);
 		if (err)
 			goto out_put;
 
@@ -663,7 +663,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			continue;
 
 		stack[ctr].dentry = this;
-		stack[ctr].mnt = lowerpath.mnt;
+		stack[ctr].layer = lower.layer;
 		ctr++;
 
 		if (d.stop)
@@ -671,13 +671,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		if (d.redirect && d.redirect[0] == '/' && poe != roe) {
 			poe = roe;
-
 			/* Find the current layer on the root dentry */
-			for (i = 0; i < poe->numlower; i++)
-				if (poe->lowerstack[i].mnt == lowerpath.mnt)
-					break;
-			if (WARN_ON(i == poe->numlower))
-				break;
+			i = lower.layer->idx - 1;
 		}
 	}
 
@@ -699,7 +694,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		goto out_put;
 
 	oe->opaque = upperopaque;
-	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
+	memcpy(oe->lowerstack, stack, sizeof(struct ovl_path) * ctr);
 	dentry->d_fsdata = oe;
 
 	if (upperdentry)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1cf3bdd193a4..6d43e0f3d6f5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -203,6 +203,7 @@ void ovl_path_lower(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
+struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct dentry *ovl_i_dentry_upper(struct inode *inode);
 struct inode *ovl_inode_upper(struct inode *inode);
@@ -251,7 +252,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
 		      struct dentry *origin, bool is_upper, bool set);
-int ovl_verify_index(struct dentry *index, struct path *lowerstack,
+int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
 		     unsigned int numlower);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
@@ -268,7 +269,7 @@ int ovl_check_d_type_supported(struct path *realpath);
 void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 			 struct dentry *dentry, int level);
 int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
-			 struct path *lowerstack, unsigned int numlower);
+			 struct ovl_path *lower, unsigned int numlower);
 
 /* inode.c */
 int ovl_set_nlink_upper(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 25d9b5adcd42..7573f98ddec1 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -17,11 +17,22 @@ struct ovl_config {
 	bool index;
 };
 
+struct ovl_layer {
+	struct vfsmount *mnt;
+	/* Index of this layer in mount (upper == 0) */
+	int idx;
+};
+
+struct ovl_path {
+	struct ovl_layer *layer;
+	struct dentry *dentry;
+};
+
 /* private information held for overlayfs's superblock */
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
 	unsigned numlower;
-	struct vfsmount **lower_mnt;
+	struct ovl_layer *lower_layers;
 	/* workbasedir is the path at workdir= mount option */
 	struct dentry *workbasedir;
 	/* workdir is the 'work' directory under workbasedir */
@@ -52,7 +63,7 @@ struct ovl_entry {
 		struct rcu_head rcu;
 	};
 	unsigned numlower;
-	struct path lowerstack[];
+	struct ovl_path lowerstack[];
 };
 
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 333de85d6de4..4f2479b6ef91 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1019,7 +1019,7 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 }
 
 int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
-			 struct path *lowerstack, unsigned int numlower)
+			 struct ovl_path *lower, unsigned int numlower)
 {
 	int err;
 	struct dentry *index = NULL;
@@ -1054,7 +1054,7 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			index = NULL;
 			break;
 		}
-		err = ovl_verify_index(index, lowerstack, numlower);
+		err = ovl_verify_index(index, lower, numlower);
 		/* Cleanup stale and orphan index entries */
 		if (err && (err == -ESTALE || err == -ENOENT))
 			err = ovl_cleanup(dir, index);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 8702803ba328..ceca3a9ac27f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -220,8 +220,8 @@ static void ovl_put_super(struct super_block *sb)
 		ovl_inuse_unlock(ufs->upper_mnt->mnt_root);
 	mntput(ufs->upper_mnt);
 	for (i = 0; i < ufs->numlower; i++)
-		mntput(ufs->lower_mnt[i]);
-	kfree(ufs->lower_mnt);
+		mntput(ufs->lower_layers[i].mnt);
+	kfree(ufs->lower_layers);
 
 	kfree(ufs->config.lowerdir);
 	kfree(ufs->config.upperdir);
@@ -1026,24 +1026,27 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	err = -ENOMEM;
-	ufs->lower_mnt = kcalloc(numlower, sizeof(struct vfsmount *), GFP_KERNEL);
-	if (ufs->lower_mnt == NULL)
+	ufs->lower_layers = kcalloc(numlower, sizeof(struct ovl_layer),
+				    GFP_KERNEL);
+	if (ufs->lower_layers == NULL)
 		goto out_put_workdir;
 	for (i = 0; i < numlower; i++) {
-		struct vfsmount *mnt = clone_private_mount(&stack[i]);
+		struct vfsmount *mnt;
 
+		mnt = clone_private_mount(&stack[i]);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
 			pr_err("overlayfs: failed to clone lowerpath\n");
-			goto out_put_lower_mnt;
+			goto out_put_lower_layers;
 		}
 		/*
-		 * Make lower_mnt R/O.  That way fchmod/fchown on lower file
+		 * Make lower layers R/O.  That way fchmod/fchown on lower file
 		 * will fail instead of modifying lower fs.
 		 */
 		mnt->mnt_flags |= MNT_READONLY | MNT_NOATIME;
 
-		ufs->lower_mnt[ufs->numlower] = mnt;
+		ufs->lower_layers[ufs->numlower].mnt = mnt;
+		ufs->lower_layers[ufs->numlower].idx = i + 1;
 		ufs->numlower++;
 
 		/* Check if all lower layers are on same sb */
@@ -1059,13 +1062,25 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
 		ufs->same_sb = NULL;
 
+	err = -ENOMEM;
+	oe = ovl_alloc_entry(numlower);
+	if (!oe)
+		goto out_put_lower_layers;
+
+	for (i = 0; i < numlower; i++) {
+		oe->lowerstack[i].dentry = stack[i].dentry;
+		oe->lowerstack[i].layer = &(ufs->lower_layers[i]);
+	}
+
 	if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
 		/* Verify lower root is upper root origin */
-		err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
-					stack[0].dentry, false, true);
+		err = ovl_verify_origin(upperpath.dentry,
+					oe->lowerstack[0].layer->mnt,
+					oe->lowerstack[0].dentry,
+					false, true);
 		if (err) {
 			pr_err("overlayfs: failed to verify upper root origin\n");
-			goto out_put_lower_mnt;
+			goto out_free_oe;
 		}
 
 		ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
@@ -1081,7 +1096,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			if (!err)
 				err = ovl_indexdir_cleanup(ufs->indexdir,
 							   ufs->upper_mnt,
-							   stack, numlower);
+							   oe->lowerstack,
+							   numlower);
 		}
 		if (err || !ufs->indexdir)
 			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
@@ -1106,11 +1122,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	/* Never override disk quota limits or use reserved space */
 	cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
 
-	err = -ENOMEM;
-	oe = ovl_alloc_entry(numlower);
-	if (!oe)
-		goto out_put_cred;
-
 	sb->s_magic = OVERLAYFS_SUPER_MAGIC;
 	sb->s_op = &ovl_super_operations;
 	sb->s_xattr = ovl_xattr_handlers;
@@ -1119,11 +1130,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
 	if (!root_dentry)
-		goto out_free_oe;
+		goto out_put_cred;
 
 	mntput(upperpath.mnt);
 	for (i = 0; i < numlower; i++)
 		mntput(stack[i].mnt);
+	kfree(stack);
 	mntput(workpath.mnt);
 	kfree(lowertmp);
 
@@ -1132,11 +1144,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (ovl_is_impuredir(upperpath.dentry))
 			ovl_set_flag(OVL_IMPURE, d_inode(root_dentry));
 	}
-	for (i = 0; i < numlower; i++) {
-		oe->lowerstack[i].dentry = stack[i].dentry;
-		oe->lowerstack[i].mnt = ufs->lower_mnt[i];
-	}
-	kfree(stack);
 
 	root_dentry->d_fsdata = oe;
 
@@ -1147,16 +1154,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	return 0;
 
-out_free_oe:
-	kfree(oe);
 out_put_cred:
 	put_cred(ufs->creator_cred);
 out_put_indexdir:
 	dput(ufs->indexdir);
-out_put_lower_mnt:
+out_free_oe:
+	kfree(oe);
+out_put_lower_layers:
 	for (i = 0; i < ufs->numlower; i++)
-		mntput(ufs->lower_mnt[i]);
-	kfree(ufs->lower_mnt);
+		mntput(ufs->lower_layers[i].mnt);
+	kfree(ufs->lower_layers);
 out_put_workdir:
 	dput(ufs->workdir);
 	mntput(ufs->upper_mnt);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 9158d17bb320..3c3b026c189b 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -124,7 +124,12 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
 
-	*path = oe->numlower ? oe->lowerstack[0] : (struct path) { };
+	if (oe->numlower) {
+		path->mnt = oe->lowerstack[0].layer->mnt;
+		path->dentry = oe->lowerstack[0].dentry;
+	} else {
+		*path = (struct path) { };
+	}
 }
 
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path)
@@ -151,6 +156,13 @@ struct dentry *ovl_dentry_lower(struct dentry *dentry)
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
