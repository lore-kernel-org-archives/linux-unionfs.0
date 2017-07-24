From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V3] ovl: Allocate anonymous devs for lowerdirs
Date: Mon, 24 Jul 2017 14:47:22 +0530
Message-ID: <20170724091722.23252-1-chandan@linux.vnet.ibm.com>
References: <CAJfpegs9W=qQRXBeF7h4t4bxnXvbGnTbUi+iGaZhft79Mvxgtw@mail.gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:35091 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751610AbdGXJRF (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Jul 2017 05:17:05 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6O9E6hV145334
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Jul 2017 05:17:04 -0400
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bw592rk4s-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Mon, 24 Jul 2017 05:17:04 -0400
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 24 Jul 2017 03:17:03 -0600
In-Reply-To: <CAJfpegs9W=qQRXBeF7h4t4bxnXvbGnTbUi+iGaZhft79Mvxgtw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, miklos@szeredi.hu, amir73il@gmail.com

For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
provides unique values for st_dev. The unique values are obtained by
allocating anonymous bdevs for each of the lowerdirs in the overlayfs
instance.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
Changelog:

v2->v3: Optimize away O(n) search for pseudo dev in ovl_get_pseudo_dev().

v1->v2: Drop code that provided unique st_dev across copy up.

 fs/overlayfs/copy_up.c   |  1 -
 fs/overlayfs/inode.c     | 18 +++++++++++++
 fs/overlayfs/namei.c     | 37 +++++++++++++-------------
 fs/overlayfs/overlayfs.h |  5 ++--
 fs/overlayfs/ovl_entry.h | 14 ++++++++--
 fs/overlayfs/readdir.c   |  4 +--
 fs/overlayfs/super.c     | 69 ++++++++++++++++++++++++++++++------------------
 fs/overlayfs/util.c      |  8 ++++--
 8 files changed, 102 insertions(+), 54 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f193976..fc27f92 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -22,7 +22,6 @@
 #include <linux/ratelimit.h>
 #include <linux/exportfs.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 69f4fc2..8e81aa7 100644
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
index 9bc0e58..c286719 100644
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
-		*stackp = kmalloc(sizeof(struct path), GFP_TEMPORARY);
+		*stackp = kmalloc(sizeof(struct ovl_lower), GFP_TEMPORARY);
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
 
@@ -419,7 +417,7 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 	if (err)
 		goto fail;
 
-	err = ovl_check_origin(index, lowerstack, numlower, &stack, &ctr);
+	err = ovl_check_origin(index, lower, numlower, &stack, &ctr);
 	if (!err && !ctr)
 		err = -ESTALE;
 	if (err)
@@ -545,7 +543,8 @@ int ovl_path_next(int idx, struct dentry *dentry, struct path *path)
 		idx++;
 	}
 	BUG_ON(idx > oe->numlower);
-	*path = oe->lowerstack[idx - 1];
+	path->dentry = oe->lowerstack[idx - 1].dentry;
+	path->mnt = oe->lowerstack[idx - 1].layer->mnt;
 
 	return (idx < oe->numlower) ? idx + 1 : -1;
 }
@@ -558,7 +557,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
-	struct path *stack = NULL;
+	struct ovl_lower *stack = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
 	struct dentry *index = NULL;
 	unsigned int ctr = 0;
@@ -622,17 +621,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (!d.stop && poe->numlower) {
 		err = -ENOMEM;
-		stack = kcalloc(ofs->numlower, sizeof(struct path),
+		stack = kcalloc(ofs->numlower, sizeof(struct ovl_lower),
 				GFP_TEMPORARY);
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
 
@@ -640,7 +639,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			continue;
 
 		stack[ctr].dentry = this;
-		stack[ctr].mnt = lowerpath.mnt;
+		stack[ctr].layer = lower.layer;
 		ctr++;
 
 		if (d.stop)
@@ -651,7 +650,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 			/* Find the current layer on the root dentry */
 			for (i = 0; i < poe->numlower; i++)
-				if (poe->lowerstack[i].mnt == lowerpath.mnt)
+				if (poe->lowerstack[i].layer->mnt == lower.layer->mnt)
 					break;
 			if (WARN_ON(i == poe->numlower))
 				break;
@@ -676,7 +675,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		goto out_put;
 
 	oe->opaque = upperopaque;
-	memcpy(oe->lowerstack, stack, sizeof(struct path) * ctr);
+	memcpy(oe->lowerstack, stack, sizeof(struct ovl_lower) * ctr);
 	dentry->d_fsdata = oe;
 
 	if (upperdentry)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 60d2660..76856dc 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/uuid.h>
+#include "ovl_entry.h"
 
 enum ovl_path_type {
 	__OVL_PATH_UPPER	= (1 << 0),
@@ -242,7 +243,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
 		      struct dentry *origin, bool is_upper, bool set);
-int ovl_verify_index(struct dentry *index, struct path *lowerstack,
+int ovl_verify_index(struct dentry *index, struct ovl_lower *lower,
 		     unsigned int numlower);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
@@ -258,7 +259,7 @@ int ovl_check_d_type_supported(struct path *realpath);
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
index 0298463..f286c32 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -669,7 +669,7 @@ void ovl_workdir_cleanup(struct inode *dir, struct vfsmount *mnt,
 }
 
 int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
-			 struct path *lowerstack, unsigned int numlower)
+			 struct ovl_lower *lower, unsigned int numlower)
 {
 	int err;
 	struct inode *dir = dentry->d_inode;
@@ -703,7 +703,7 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			err = PTR_ERR(index);
 			break;
 		}
-		if (ovl_verify_index(index, lowerstack, numlower)) {
+		if (ovl_verify_index(index, lower, numlower)) {
 			err = ovl_cleanup(dir, index);
 			if (err)
 				break;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 44dc2d6..ae0e034 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -18,7 +18,6 @@
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
 #include "overlayfs.h"
-#include "ovl_entry.h"
 
 MODULE_AUTHOR("Miklos Szeredi <miklos@szeredi.hu>");
 MODULE_DESCRIPTION("Overlay filesystem");
@@ -215,8 +214,10 @@ static void ovl_put_super(struct super_block *sb)
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
@@ -1014,15 +1015,25 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -1031,7 +1042,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		 */
 		mnt->mnt_flags |= MNT_READONLY | MNT_NOATIME;
 
-		ufs->lower_mnt[ufs->numlower] = mnt;
+		ufs->lower_mnt[ufs->numlower].mnt = mnt;
+		ufs->lower_mnt[ufs->numlower].pseudo_dev = dev;
 		ufs->numlower++;
 
 		/* Check if all lower layers are on same sb */
@@ -1047,20 +1059,30 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
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
 						   OVL_INDEXDIR_NAME, true);
 		err = PTR_ERR(ufs->indexdir);
 		if (IS_ERR(ufs->indexdir))
-			goto out_put_lower_mnt;
+			goto out_free_oe;
 
 		if (ufs->indexdir) {
 			/* Verify upper root is index dir origin */
@@ -1073,7 +1095,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			if (!err)
 				err = ovl_indexdir_cleanup(ufs->indexdir,
 							   ufs->upper_mnt,
-							   stack, numlower);
+							   oe->lowerstack,
+							   numlower);
 		}
 		if (err || !ufs->indexdir)
 			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
@@ -1097,11 +1120,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
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
@@ -1110,11 +1128,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
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
 
@@ -1123,11 +1142,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (ovl_is_impuredir(upperpath.dentry))
 			ovl_set_flag(OVL_IMPURE, d_inode(root_dentry));
 	}
-	for (i = 0; i < numlower; i++) {
-		oe->lowerstack[i].dentry = stack[i].dentry;
-		oe->lowerstack[i].mnt = ufs->lower_mnt[i];
-	}
-	kfree(stack);
 
 	root_dentry->d_fsdata = oe;
 
@@ -1138,15 +1152,18 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
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
index c492ba7..b16aade 100644
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
2.9.3
