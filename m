From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH 1/3] ovl: Allocate anonymous devs for lowerdirs
Date: Fri,  6 Oct 2017 14:55:33 +0530
Message-ID: <20171006092535.15199-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:40100 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752632AbdJFJZV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 05:25:21 -0400
Received: from pps.filterd (m0098396.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v969PJFP144792
        for <linux-unionfs@vger.kernel.org>; Fri, 6 Oct 2017 05:25:21 -0400
Received: from e37.co.us.ibm.com (e37.co.us.ibm.com [32.97.110.158])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2de6q0hded-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 06 Oct 2017 05:25:20 -0400
Received: from localhost
        by e37.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 6 Oct 2017 03:24:55 -0600
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, amir73il@gmail.com
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, miklos@szeredi.hu

For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
provides unique values for st_dev. The unique values are obtained by
allocating anonymous bdevs for each of the lowerdirs in the overlayfs
instance.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/overlayfs/copy_up.c   |  1 -
 fs/overlayfs/inode.c     | 18 +++++++++++++
 fs/overlayfs/namei.c     | 37 +++++++++++++-------------
 fs/overlayfs/overlayfs.h |  5 ++--
 fs/overlayfs/ovl_entry.h | 14 ++++++++--
 fs/overlayfs/readdir.c   |  4 +--
 fs/overlayfs/super.c     | 67 ++++++++++++++++++++++++++++++------------------
 fs/overlayfs/util.c      |  8 ++++--
 8 files changed, 101 insertions(+), 53 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index aad97b3..80d0d9c 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -22,7 +22,6 @@
 #include <linux/ratelimit.h>
 #include <linux/exportfs.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a619add..3091cd6 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -8,6 +8,7 @@
  */
 
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/slab.h>
 #include <linux/cred.h>
 #include <linux/xattr.h>
@@ -15,6 +16,21 @@
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
 
+
+static dev_t ovl_get_pseudo_dev(struct dentry *dentry, dev_t dev)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb->s_dev == dev)
+		return dev;
+
+	if (oe->numlower)
+		return oe->lowerstack[0].layer->pseudo_dev;
+
+	return dev;
+}
+
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	int err;
@@ -121,6 +137,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		 */
 		stat->dev = dentry->d_sb->s_dev;
 		stat->ino = dentry->d_inode->i_ino;
+	} else {
+		stat->dev = ovl_get_pseudo_dev(dentry, stat->dev);
 	}
 
 	/*
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c3addd1..1c578d4 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -15,7 +15,6 @@
 #include <linux/mount.h>
 #include <linux/exportfs.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 struct ovl_lookup_data {
 	struct qstr name;
@@ -286,16 +285,15 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 
 
 static int ovl_check_origin(struct dentry *upperdentry,
-			    struct path *lowerstack, unsigned int numlower,
-			    struct path **stackp, unsigned int *ctrp)
+			    struct ovl_lower *lower, unsigned int numlower,
+			    struct ovl_lower **stackp, unsigned int *ctrp)
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
@@ -309,12 +307,12 @@ static int ovl_check_origin(struct dentry *upperdentry,
 
 	BUG_ON(*ctrp);
 	if (!*stackp)
-		*stackp = kmalloc(sizeof(struct path), GFP_KERNEL);
+		*stackp = kmalloc(sizeof(struct ovl_lower), GFP_KERNEL);
 	if (!*stackp) {
 		dput(origin);
 		return -ENOMEM;
 	}
-	**stackp = (struct path) { .dentry = origin, .mnt = mnt };
+	**stackp = (struct ovl_lower) { .dentry = origin, .layer = lower[i].layer };
 	*ctrp = 1;
 
 	return 0;
@@ -384,13 +382,13 @@ int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
  * OVL_XATTR_ORIGIN and that origin file handle can be decoded to lower path.
  * Return 0 on match, -ESTALE on mismatch or stale origin, < 0 on error.
  */
-int ovl_verify_index(struct dentry *index, struct path *lowerstack,
+int ovl_verify_index(struct dentry *index, struct ovl_lower *lower,
 		     unsigned int numlower)
 {
 	struct ovl_fh *fh = NULL;
 	size_t len;
-	struct path origin = { };
-	struct path *stack = &origin;
+	struct ovl_lower origin = { };
+	struct ovl_lower *stack = &origin;
 	unsigned int ctr = 0;
 	int err;
 
@@ -430,7 +428,7 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 	if (err)
 		goto fail;
 
-	err = ovl_check_origin(index, lowerstack, numlower, &stack, &ctr);
+	err = ovl_check_origin(index, lower, numlower, &stack, &ctr);
 	if (!err && !ctr)
 		err = -ESTALE;
 	if (err)
@@ -568,7 +566,8 @@ int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
 		idx++;
 	}
 	BUG_ON(idx > oe->numlower);
-	*path = oe->lowerstack[idx - 1];
+	path->dentry = oe->lowerstack[idx - 1].dentry;
+	path->mnt = oe->lowerstack[idx - 1].layer->mnt;
 
 	return (idx < oe->numlower) ? idx + 1 : -1;
 }
@@ -581,7 +580,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
-	struct path *stack = NULL;
+	struct ovl_lower *stack = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
 	struct dentry *index = NULL;
 	unsigned int ctr = 0;
@@ -645,17 +644,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (!d.stop && poe->numlower) {
 		err = -ENOMEM;
-		stack = kcalloc(ofs->numlower, sizeof(struct path),
+		stack = kcalloc(ofs->numlower, sizeof(struct ovl_lower),
 				GFP_KERNEL);
 		if (!stack)
 			goto out_put_upper;
 	}
 
 	for (i = 0; !d.stop && i < poe->numlower; i++) {
-		struct path lowerpath = poe->lowerstack[i];
+		struct ovl_lower lower = poe->lowerstack[i];
 
 		d.last = i == poe->numlower - 1;
-		err = ovl_lookup_layer(lowerpath.dentry, &d, &this);
+		err = ovl_lookup_layer(lower.dentry, &d, &this);
 		if (err)
 			goto out_put;
 
@@ -663,7 +662,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			continue;
 
 		stack[ctr].dentry = this;
-		stack[ctr].mnt = lowerpath.mnt;
+		stack[ctr].layer = lower.layer;
 		ctr++;
 
 		if (d.stop)
@@ -674,7 +673,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 			/* Find the current layer on the root dentry */
 			for (i = 0; i < poe->numlower; i++)
-				if (poe->lowerstack[i].mnt == lowerpath.mnt)
+				if (poe->lowerstack[i].layer->mnt == lower.layer->mnt)
 					break;
 			if (WARN_ON(i == poe->numlower))
 				break;
@@ -699,7 +698,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		goto out_put;
 
 	oe->opaque = upperopaque;
-	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
+	memcpy(oe->lowerstack, stack, sizeof(struct ovl_lower) * ctr);
 	dentry->d_fsdata = oe;
 
 	if (upperdentry)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d4e8c1a..7c747a5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/uuid.h>
+#include "ovl_entry.h"
 
 enum ovl_path_type {
 	__OVL_PATH_UPPER	= (1 << 0),
@@ -245,7 +246,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
 		      struct dentry *origin, bool is_upper, bool set);
-int ovl_verify_index(struct dentry *index, struct path *lowerstack,
+int ovl_verify_index(struct dentry *index, struct ovl_lower *lower,
 		     unsigned int numlower);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
@@ -262,7 +263,7 @@ int ovl_check_d_type_supported(struct path *realpath);
 void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 			 struct dentry *dentry, int level);
 int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
-			 struct path *lowerstack, unsigned int numlower);
+			 struct ovl_lower *lower, unsigned int numlower);
 
 /* inode.c */
 int ovl_set_nlink_upper(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 878a750..c2d9322 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -17,11 +17,21 @@ struct ovl_config {
 	bool index;
 };
 
+struct ovl_lower_mnt {
+	struct vfsmount *mnt;
+	dev_t pseudo_dev;
+};
+
+struct ovl_lower {
+	struct ovl_lower_mnt *layer;
+	struct dentry *dentry;
+};
+
 /* private information held for overlayfs's superblock */
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
 	unsigned numlower;
-	struct vfsmount **lower_mnt;
+	struct ovl_lower_mnt *lower_mnt;
 	/* workbasedir is the path at workdir= mount option */
 	struct dentry *workbasedir;
 	/* workdir is the 'work' directory under workbasedir */
@@ -49,7 +59,7 @@ struct ovl_entry {
 		struct rcu_head rcu;
 	};
 	unsigned numlower;
-	struct path lowerstack[];
+	struct ovl_lower lowerstack[];
 };
 
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 62e9b22..02f48cb 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -985,7 +985,7 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 }
 
 int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
-			 struct path *lowerstack, unsigned int numlower)
+			 struct ovl_lower *lower, unsigned int numlower)
 {
 	int err;
 	struct inode *dir = dentry->d_inode;
@@ -1020,7 +1020,7 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			err = PTR_ERR(index);
 			break;
 		}
-		err = ovl_verify_index(index, lowerstack, numlower);
+		err = ovl_verify_index(index, lower, numlower);
 		if (err) {
 			if (err == -EROFS)
 				break;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index fd5ea4f..8f0a28f 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -18,7 +18,6 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Overlay filesystem");
@@ -216,8 +215,10 @@ static void ovl_put_super(struct super_block *sb)
 	if (ufs->upper_mnt)
 		ovl_inuse_unlock(ufs->upper_mnt->mnt_root);
 	mntput(ufs->upper_mnt);
-	for (i = 0; i < ufs->numlower; i++)
-		mntput(ufs->lower_mnt[i]);
+	for (i = 0; i < ufs->numlower; i++) {
+		mntput(ufs->lower_mnt[i].mnt);
+		free_anon_bdev(ufs->lower_mnt[i].pseudo_dev);
+	}
 	kfree(ufs->lower_mnt);
 
 	kfree(ufs->config.lowerdir);
@@ -1015,15 +1016,25 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	}
 
 	err = -ENOMEM;
-	ufs->lower_mnt = kcalloc(numlower, sizeof(struct vfsmount *), GFP_KERNEL);
+	ufs->lower_mnt = kcalloc(numlower, sizeof(struct ovl_lower_mnt),
+				GFP_KERNEL);
 	if (ufs->lower_mnt == NULL)
 		goto out_put_workdir;
 	for (i = 0; i < numlower; i++) {
-		struct vfsmount *mnt = clone_private_mount(&stack[i]);
+		struct vfsmount *mnt;
+		dev_t dev;
+
+		err = get_anon_bdev(&dev);
+		if (err) {
+			pr_err("overlayfs: failed to get anonymous bdev for lowerpath\n");
+			goto out_put_lower_mnt;
+		}
 
+		mnt = clone_private_mount(&stack[i]);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
 			pr_err("overlayfs: failed to clone lowerpath\n");
+			free_anon_bdev(dev);
 			goto out_put_lower_mnt;
 		}
 		/*
@@ -1032,7 +1043,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		 */
 		mnt->mnt_flags |= MNT_READONLY | MNT_NOATIME;
 
-		ufs->lower_mnt[ufs->numlower] = mnt;
+		ufs->lower_mnt[ufs->numlower].mnt = mnt;
+		ufs->lower_mnt[ufs->numlower].pseudo_dev = dev;
 		ufs->numlower++;
 
 		/* Check if all lower layers are on same sb */
@@ -1048,13 +1060,23 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
 		ufs->same_sb = NULL;
 
+	err = -ENOMEM;
+	oe = ovl_alloc_entry(numlower);
+	if (!oe)
+		goto out_put_lower_mnt;
+
+	for (i = 0; i < numlower; i++) {
+		oe->lowerstack[i].dentry = stack[i].dentry;
+		oe->lowerstack[i].layer = &(ufs->lower_mnt[i]);
+	}
+
 	if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
 		/* Verify lower root is upper root origin */
-		err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
-					stack[0].dentry, false, true);
+		err = ovl_verify_origin(upperpath.dentry, oe->lowerstack[0].layer->mnt,
+					oe->lowerstack[0].dentry, false, true);
 		if (err) {
 			pr_err("overlayfs: failed to verify upper root origin\n");
-			goto out_put_lower_mnt;
+			goto out_free_oe;
 		}
 
 		ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
@@ -1070,7 +1092,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			if (!err)
 				err = ovl_indexdir_cleanup(ufs->indexdir,
 							   ufs->upper_mnt,
-							   stack, numlower);
+							   oe->lowerstack,
+							   numlower);
 		}
 		if (err || !ufs->indexdir)
 			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
@@ -1095,11 +1118,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -1108,11 +1126,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
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
 
@@ -1121,11 +1140,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (ovl_is_impuredir(upperpath.dentry))
 			ovl_set_flag(OVL_IMPURE, d_inode(root_dentry));
 	}
-	for (i = 0; i < numlower; i++) {
-		oe->lowerstack[i].dentry = stack[i].dentry;
-		oe->lowerstack[i].mnt = ufs->lower_mnt[i];
-	}
-	kfree(stack);
 
 	root_dentry->d_fsdata = oe;
 
@@ -1136,15 +1150,18 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	return 0;
 
-out_free_oe:
-	kfree(oe);
 out_put_cred:
 	put_cred(ufs->creator_cred);
 out_put_indexdir:
 	dput(ufs->indexdir);
+out_free_oe:
+	kfree(oe);
 out_put_lower_mnt:
-	for (i = 0; i < ufs->numlower; i++)
-		mntput(ufs->lower_mnt[i]);
+	for (i = 0; i < ufs->numlower; i++) {
+		if (ufs->lower_mnt[i].mnt)
+			free_anon_bdev(ufs->lower_mnt[i].pseudo_dev);
+		mntput(ufs->lower_mnt[i].mnt);
+	}
 	kfree(ufs->lower_mnt);
 out_put_workdir:
 	dput(ufs->workdir);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 1177945..c7d5b4a 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -17,7 +17,6 @@
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 int ovl_want_write(struct dentry *dentry)
 {
@@ -125,7 +124,12 @@ void ovl_path_lower(struct dentry *dentry, struct path *path)
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
-- 
2.9.5
