From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH] ovl: System-wide unique st_dev
Date: Mon, 19 Jun 2017 20:52:10 +0530
Message-ID: <20170619152210.15930-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55328 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751458AbdFSPWD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 11:22:03 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5JFIwFp084380
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jun 2017 11:22:02 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2b64u1arhd-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jun 2017 11:22:02 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Mon, 19 Jun 2017 09:22:01 -0600
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, miklos@szeredi.hu, amir73il@gmail.com

On an overlayfs instance having lower and upper dirs on the same
filesystem, stat(2) on a file residing on the lower dir will
provide st_dev corresponding to the lower filesystem's bdev. Later, After
the lower file is copied-up, stat(2) on the file provides st_dev
corresponding to the overlayfs' pseudo device. Hence we have a mismatch
in the st_dev value that is provided to the userspace.

This commit allocates pseudo bdevs for each of the lowerdirs and
provides the value of such a pseudo bdev for stat(2) on files that
either reside only on the lower dir or have been copied up from a
file that was originally present on the lowedir.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/overlayfs/inode.c     | 24 ++++++++++++++++++++++--
 fs/overlayfs/ovl_entry.h |  9 ++++++++-
 fs/overlayfs/super.c     | 34 ++++++++++++++++++++++++++--------
 3 files changed, 56 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index d613e2c..8f6d66c 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -8,11 +8,28 @@
  */
 
 #include <linux/fs.h>
+#include <linux/mount.h>
 #include <linux/slab.h>
 #include <linux/cred.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
 #include "overlayfs.h"
+#include "ovl_entry.h"
+
+static dev_t ovl_get_pseudo_dev(struct ovl_fs *ofs, dev_t dev)
+{
+	int i;
+
+	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb->s_dev == dev)
+		return ofs->ovl_sb->s_dev;
+
+	for (i = 0; i < ofs->numlower; i++) {
+		if (ofs->lower_mnt[i].real_dev == dev)
+			return ofs->lower_mnt[i].pseudo_dev;
+	}
+
+	return dev;
+}
 
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -100,10 +117,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			 * upper files, so we cannot use the lower origin st_ino
 			 * for those different files, even for the same fs case.
 			 */
-			if (is_dir || lowerstat.nlink == 1)
+			if (is_dir || lowerstat.nlink == 1) {
 				stat->ino = lowerstat.ino;
+				stat->dev = lowerstat.dev;
+			}
 		}
-		stat->dev = dentry->d_sb->s_dev;
+		stat->dev = ovl_get_pseudo_dev(dentry->d_sb->s_fs_info,
+					stat->dev);
 	} else if (is_dir) {
 		/*
 		 * If not all layers are on the same fs the pair {real st_ino;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 34bc4a9..f15900a 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -16,11 +16,17 @@ struct ovl_config {
 	bool redirect_dir;
 };
 
+struct ovl_lower_mnt {
+	struct vfsmount *mnt;
+	dev_t real_dev;
+	dev_t pseudo_dev;
+};
+
 /* private information held for overlayfs's superblock */
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
 	unsigned numlower;
-	struct vfsmount **lower_mnt;
+	struct ovl_lower_mnt *lower_mnt;
 	struct dentry *workdir;
 	long namelen;
 	/* pathnames of lower and upper dirs, for show_options */
@@ -30,6 +36,7 @@ struct ovl_fs {
 	bool tmpfile;
 	bool noxattr;
 	wait_queue_head_t copyup_wq;
+	struct super_block *ovl_sb;
 	/* sb common to all layers */
 	struct super_block *same_sb;
 };
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4882ffb..26d3d2d 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -172,8 +172,10 @@ static void ovl_put_super(struct super_block *sb)
 
 	dput(ufs->workdir);
 	mntput(ufs->upper_mnt);
-	for (i = 0; i < ufs->numlower; i++)
-		mntput(ufs->lower_mnt[i]);
+	for (i = 0; i < ufs->numlower; i++) {
+		mntput(ufs->lower_mnt[i].mnt);
+		free_anon_bdev(ufs->lower_mnt[i].pseudo_dev);
+	}
 	kfree(ufs->lower_mnt);
 
 	kfree(ufs->config.lowerdir);
@@ -908,15 +910,25 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
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
 
+		err = get_anon_bdev(&dev);
+		if (err) {
+			pr_err("overlayfs: failed to get anonymous bdev for lowerpath\n");
+			goto out_put_lower_mnt;
+		}
+
+		mnt = clone_private_mount(&stack[i]);
 		err = PTR_ERR(mnt);
 		if (IS_ERR(mnt)) {
 			pr_err("overlayfs: failed to clone lowerpath\n");
+			free_anon_bdev(dev);
 			goto out_put_lower_mnt;
 		}
 		/*
@@ -925,7 +937,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		 */
 		mnt->mnt_flags |= MNT_READONLY | MNT_NOATIME;
 
-		ufs->lower_mnt[ufs->numlower] = mnt;
+		ufs->lower_mnt[ufs->numlower].mnt = mnt;
+		ufs->lower_mnt[ufs->numlower].real_dev = mnt->mnt_sb->s_dev;
+		ufs->lower_mnt[ufs->numlower].pseudo_dev = dev;
 		ufs->numlower++;
 
 		/* Check if all lower layers are on same sb */
@@ -980,7 +994,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	}
 	for (i = 0; i < numlower; i++) {
 		oe->lowerstack[i].dentry = stack[i].dentry;
-		oe->lowerstack[i].mnt = ufs->lower_mnt[i];
+		oe->lowerstack[i].mnt = ufs->lower_mnt[i].mnt;
 	}
 	kfree(stack);
 
@@ -991,6 +1005,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ovl_copyattr(realinode, d_inode(root_dentry));
 
 	sb->s_root = root_dentry;
+	ufs->ovl_sb = sb;
 
 	return 0;
 
@@ -999,8 +1014,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 out_put_cred:
 	put_cred(ufs->creator_cred);
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
-- 
2.9.4
