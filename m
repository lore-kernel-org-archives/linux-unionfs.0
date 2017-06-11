From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [RFC] ovl: System-wide unique st_dev
Date: Sun, 11 Jun 2017 19:14:30 +0530
Message-ID: <20170611134430.4360-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:55833 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751772AbdFKNoZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Jun 2017 09:44:25 -0400
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5BDhYcr135898
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Jun 2017 09:44:24 -0400
Received: from e13.ny.us.ibm.com (e13.ny.us.ibm.com [129.33.205.203])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b14c3n19m-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Jun 2017 09:44:24 -0400
Received: from localhost
        by e13.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Sun, 11 Jun 2017 09:44:24 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, miklos@szeredi.hu, amir73il@gmail.com

The following sequence of commands causes a lowerdir file and an
overlay file to have the same values for st_ino/st_dev,

$ xfs_io -f -c "pwrite 0 4k" /mnt/lowerdir/testfile -c sync
$ xfs_io -a -c "pwrite 4k 4k" /mnt/ovl/testfile # Copy-up occurs here

This commit solves the bug by reporting pseudo device numbers for files
on lowerdir.

Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
---
 fs/overlayfs/inode.c     | 23 ++++++++++++++++++++---
 fs/overlayfs/ovl_entry.h |  8 +++++++-
 fs/overlayfs/super.c     | 33 +++++++++++++++++++++++++--------
 3 files changed, 52 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5f285c1..154c87892 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -13,6 +13,19 @@
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
 #include "overlayfs.h"
+#include "ovl_entry.h"
+
+static dev_t get_lowerdir_pseudo_dev(struct ovl_fs *ufs, dev_t dev)
+{
+	int i;
+
+	for (i = 0; i < ufs->numlower; i++) {
+		if (ufs->lower_mnt[i].real_dev == dev)
+			return ufs->lower_mnt[i].pseudo_dev;
+	}
+
+	BUG();
+}
 
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
@@ -61,6 +74,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int flags)
 {
 	struct dentry *dentry = path->dentry;
+	struct ovl_fs *ufs;
 	enum ovl_path_type type;
 	struct path realpath;
 	const struct cred *old_cred;
@@ -103,10 +117,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (is_dir || lowerstat.nlink == 1)
 				stat->ino = lowerstat.ino;
 
-			if (samefs)
+			if (samefs) {
 				WARN_ON_ONCE(stat->dev != lowerstat.dev);
-			else
-				stat->dev = lowerstat.dev;
+			} else {
+				ufs = dentry->d_sb->s_fs_info;
+				stat->dev = get_lowerdir_pseudo_dev(ufs,
+								lowerstat.dev);
+			}
 		}
 		if (samefs)
 			stat->dev = dentry->d_sb->s_dev;
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 34bc4a9..92aebe9 100644
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
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4882ffb..c922a92 100644
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
 
@@ -999,8 +1013,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
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
