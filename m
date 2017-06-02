From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 02/17] ovl: generalize ovl_create_workdir()
Date: Fri,  2 Jun 2017 17:04:29 +0300
Message-ID: <1496412284-4113-3-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33206 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbdFBOEg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:36 -0400
Received: by mail-wr0-f194.google.com with SMTP id v104so1344751wrb.0
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:35 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Pass in the subdir name to create and specify if subdir is persistent
or if it should be cleaned up on every mount.

Move fallback to readonly mount on failure to create dir and print of error
message into the helper.

This function is going to be used for creating the persistent 'index' dir
under workbasedir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 45 +++++++++++++++++++++++++++++----------------
 1 file changed, 29 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 3d7b5c9bc042..3cdefd401713 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -450,22 +450,25 @@ static int ovl_verify_set_origin(struct dentry *dir, struct vfsmount *mnt,
 
 #define OVL_WORKDIR_NAME "work"
 
-static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
-					 struct dentry *dentry)
+static struct dentry *ovl_workdir_create(struct super_block *sb,
+					 struct ovl_fs *ufs,
+					 struct dentry *dentry,
+					 const char *name, bool persist)
 {
-	struct inode *dir = dentry->d_inode;
-	struct dentry *work;
+	struct vfsmount *mnt = ufs->upper_mnt;
+	struct inode *dir = NULL;
+	struct dentry *work = NULL;
 	int err;
 	bool retried = false;
 
 	err = mnt_want_write(mnt);
 	if (err)
-		return ERR_PTR(err);
+		goto out_err;
 
+	dir = d_inode(dentry);
 	inode_lock_nested(dir, I_MUTEX_PARENT);
 retry:
-	work = lookup_one_len(OVL_WORKDIR_NAME, dentry,
-			      strlen(OVL_WORKDIR_NAME));
+	work = lookup_one_len(name, dentry, strlen(name));
 
 	if (!IS_ERR(work)) {
 		struct iattr attr = {
@@ -478,6 +481,9 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
 			if (retried)
 				goto out_dput;
 
+			if (persist)
+				goto out_unlock;
+
 			retried = true;
 			ovl_workdir_cleanup(dir, mnt, work, 0);
 			dput(work);
@@ -517,16 +523,25 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
 		inode_unlock(work->d_inode);
 		if (err)
 			goto out_dput;
+	} else {
+		err = PTR_ERR(work);
+		goto out_err;
 	}
+
 out_unlock:
-	inode_unlock(dir);
+	if (dir)
+		inode_unlock(dir);
 	mnt_drop_write(mnt);
 
 	return work;
 
 out_dput:
 	dput(work);
-	work = ERR_PTR(err);
+out_err:
+	pr_warn("overlayfs: failed to create directory %s/%s (errno: %i); mounting read-only\n",
+		ufs->config.workdir, name, -err);
+	sb->s_flags |= MS_RDONLY;
+	work = NULL;
 	goto out_unlock;
 }
 
@@ -940,14 +955,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 		sb->s_time_gran = ufs->upper_mnt->mnt_sb->s_time_gran;
 
-		ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
+		ufs->workdir = ovl_workdir_create(sb, ufs, workpath.dentry,
+						  OVL_WORKDIR_NAME, false);
 		err = PTR_ERR(ufs->workdir);
-		if (IS_ERR(ufs->workdir)) {
-			pr_warn("overlayfs: failed to create directory %s/%s (errno: %i); mounting read-only\n",
-				ufs->config.workdir, OVL_WORKDIR_NAME, -err);
-			sb->s_flags |= MS_RDONLY;
-			ufs->workdir = NULL;
-		}
+		if (IS_ERR(ufs->workdir))
+			goto out_put_upper_mnt;
 
 		/*
 		 * Upper should support d_type, else whiteouts are visible.
@@ -1112,6 +1124,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(ufs->lower_mnt);
 out_put_workdir:
 	dput(ufs->workdir);
+out_put_upper_mnt:
 	mntput(ufs->upper_mnt);
 out_put_lowerpath:
 	for (i = 0; i < numlower; i++)
-- 
2.7.4
