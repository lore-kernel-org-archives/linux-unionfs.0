From: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Subject: [PATCH V2] ovl: Allocate anonymous devs for lowerdirs
Date: Fri, 23 Jun 2017 16:31:18 +0530
Message-ID: <20170623110118.19975-1-chandan@linux.vnet.ibm.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:59212 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751153AbdFWLBH (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 23 Jun 2017 07:01:07 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5NAwj3U029870
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Jun 2017 07:01:06 -0400
Received: from e16.ny.us.ibm.com (e16.ny.us.ibm.com [129.33.205.206])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2b8xef8jan-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-unionfs@vger.kernel.org>; Fri, 23 Jun 2017 07:01:06 -0400
Received: from localhost
        by e16.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-unionfs@vger.kernel.org> from <chandan@linux.vnet.ibm.com>;
        Fri, 23 Jun 2017 07:01:05 -0400
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
v1->v2: Drop code that provided unique st_dev across copy up.

 fs/overlayfs/inode.c     | 20 ++++++++++++++++++++
 fs/overlayfs/ovl_entry.h |  8 +++++++-
 fs/overlayfs/super.c     | 33 +++++++++++++++++++++++++--------
 3 files changed, 52 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index d613e2c..e30bdca 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -8,11 +8,29 @@
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
+static dev_t ovl_get_pseudo_dev(struct dentry *dentry, dev_t dev)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	int i;
+
+	if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb->s_dev == dev)
+		return dev;
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
@@ -116,6 +134,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		 */
 		stat->dev = dentry->d_sb->s_dev;
 		stat->ino = dentry->d_inode->i_ino;
+	} else {
+		stat->dev = ovl_get_pseudo_dev(dentry, stat->dev);
 	}
 
 	/*
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
