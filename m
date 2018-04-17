Return-Path: <cgxu519@gmx.com>
From: Chengguang Xu <cgxu519@gmx.com>
Subject: [PATCH 2/3] ovl: using lowestack handling functions to replace bare array operation
Date: Tue, 17 Apr 2018 10:42:44 +0800
Message-Id: <1523932965-25792-2-git-send-email-cgxu519@gmx.com>
In-Reply-To: <1523932965-25792-1-git-send-email-cgxu519@gmx.com>
References: <1523932965-25792-1-git-send-email-cgxu519@gmx.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, Chengguang Xu <cgxu519@gmx.com>
List-ID: <linux-unionfs@vger.kernel.org>

ovl_*_lower() can handle lowerstack requirement well and more importantly
we can hide detail lowerstack implementation for outside. so using these
functions to replace bare array operaion.

Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
---
 fs/overlayfs/export.c    |  4 ++--
 fs/overlayfs/namei.c     | 18 ++++++++++--------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/super.c     |  8 ++++----
 4 files changed, 17 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 425a946..f2ba5fb 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -94,7 +94,7 @@ static int ovl_connectable_layer(struct dentry *dentry)
 		return 0;
 
 	/* We can get upper/overlay path from indexed/lower dentry */
-	return oe->lowerstack[0].layer->idx;
+	return ovl_layer_lower(dentry)->idx;
 }
 
 /*
@@ -115,7 +115,7 @@ static int ovl_connect_layer(struct dentry *dentry)
 	    WARN_ON(!ovl_dentry_lower(dentry)))
 		return -EIO;
 
-	origin_layer = OVL_E(dentry)->lowerstack[0].layer->idx;
+	origin_layer = ovl_layer_lower(dentry)->idx;
 	if (ovl_dentry_test_flag(OVL_E_CONNECTED, dentry))
 		return origin_layer;
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 2dba29e..eb3ec6c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -779,6 +779,7 @@ struct dentry *ovl_lookup_index(struct ovl_fs *ofs, struct dentry *upper,
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
+	struct ovl_path *op;
 
 	BUG_ON(idx < 0);
 	if (idx == 0) {
@@ -788,8 +789,9 @@ int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
 		idx++;
 	}
 	BUG_ON(idx > oe->numlower);
-	path->dentry = oe->lowerstack[idx - 1].dentry;
-	path->mnt = oe->lowerstack[idx - 1].layer->mnt;
+	op = __ovl_path_lower(oe, idx);
+	path->dentry = op->dentry;
+	path->mnt = op->layer->mnt;
 
 	return (idx < oe->numlower) ? idx + 1 : -1;
 }
@@ -895,14 +897,14 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	for (i = 0; !d.stop && i < poe->numlower; i++) {
-		struct ovl_path lower = poe->lowerstack[i];
+		struct ovl_path *lower = __ovl_path_lower(poe, i + 1);
 
 		if (!ofs->config.redirect_follow)
 			d.last = i == poe->numlower - 1;
 		else
-			d.last = lower.layer->idx == roe->numlower;
+			d.last = lower->layer->idx == roe->numlower;
 
-		err = ovl_lookup_layer(lower.dentry, &d, &this);
+		err = ovl_lookup_layer(lower->dentry, &d, &this);
 		if (err)
 			goto out_put;
 
@@ -938,7 +940,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 
 		stack[ctr].dentry = this;
-		stack[ctr].layer = lower.layer;
+		stack[ctr].layer = lower->layer;
 		ctr++;
 
 		/*
@@ -964,7 +966,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (d.redirect && d.redirect[0] == '/' && poe != roe) {
 			poe = roe;
 			/* Find the current layer on the root dentry */
-			i = lower.layer->idx - 1;
+			i = lower->layer->idx - 1;
 		}
 	}
 
@@ -1065,7 +1067,7 @@ bool ovl_lower_positive(struct dentry *dentry)
 	/* Positive upper -> have to look up lower to see whether it exists */
 	for (i = 0; !done && !positive && i < poe->numlower; i++) {
 		struct dentry *this;
-		struct dentry *lowerdir = poe->lowerstack[i].dentry;
+		struct dentry *lowerdir = __ovl_path_lower(poe, i + 1)->dentry;
 
 		this = lookup_one_len_unlocked(name->name, lowerdir,
 					       name->len);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index abb5cf4..8039602 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -214,6 +214,7 @@ static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
+struct ovl_path *__ovl_path_lower(struct ovl_entry *oe, int layer);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct vfsmount *ovl_mnt_lower(struct dentry *dentry);
 struct ovl_layer *ovl_layer_lower(struct dentry *dentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e8551c9..38c1dd1 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -144,7 +144,7 @@ static int ovl_dentry_revalidate(struct dentry *dentry, unsigned int flags)
 	int ret = 1;
 
 	for (i = 0; i < oe->numlower; i++) {
-		struct dentry *d = oe->lowerstack[i].dentry;
+		struct dentry *d = __ovl_path_lower(oe, i + 1)->dentry;
 
 		if (d->d_flags & DCACHE_OP_REVALIDATE) {
 			ret = d->d_op->d_revalidate(d, flags);
@@ -167,7 +167,7 @@ static int ovl_dentry_weak_revalidate(struct dentry *dentry, unsigned int flags)
 	int ret = 1;
 
 	for (i = 0; i < oe->numlower; i++) {
-		struct dentry *d = oe->lowerstack[i].dentry;
+		struct dentry *d = __ovl_path_lower(oe, i + 1)->dentry;
 
 		if (d->d_flags & DCACHE_OP_WEAK_REVALIDATE) {
 			ret = d->d_op->d_weak_revalidate(d, flags);
@@ -1123,8 +1123,8 @@ static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
 		return err;
 
 	/* Verify lower root is upper root origin */
-	err = ovl_verify_origin(upperpath->dentry, oe->lowerstack[0].dentry,
-				true);
+	err = ovl_verify_origin(upperpath->dentry,
+				__ovl_path_lower(oe, 1)->dentry, true);
 	if (err) {
 		pr_err("overlayfs: failed to verify upper root origin\n");
 		goto out;
-- 
1.8.3.1
