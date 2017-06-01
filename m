From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/5] ovl: get exclusive ownership on upper/work dirs
Date: Thu,  1 Jun 2017 20:01:51 +0300
Message-ID: <1496336514-11000-3-git-send-email-amir73il@gmail.com>
References: <1496336514-11000-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:32991 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751485AbdFARBn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 13:01:43 -0400
In-Reply-To: <1496336514-11000-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Bad things can happen if several concurrent overlay mounts try to
use the same upperdir/workdir path.

Try to get the 'inuse' advisory lock on upperdir and workdir.
Fail mount if another overlay mount instance or another user
holds the 'inuse' lock on these directories.

Note that this provides no protection for concurrent overlay
mount that use overlapping (i.e. descendant) upper/work dirs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/ovl_entry.h |  3 +++
 fs/overlayfs/super.c     | 41 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 41 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 34bc4a9f5c61..b0e7ee2ae398 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -21,6 +21,9 @@ struct ovl_fs {
 	struct vfsmount *upper_mnt;
 	unsigned numlower;
 	struct vfsmount **lower_mnt;
+	/* workbasedir is the path at workdir= mount option */
+	struct dentry *workbasedir;
+	/* workdir is the 'work' directory under workbasedir */
 	struct dentry *workdir;
 	long namelen;
 	/* pathnames of lower and upper dirs, for show_options */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 4882ffb37bae..476f021baf2a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -165,12 +165,28 @@ static const struct dentry_operations ovl_reval_dentry_operations = {
 	.d_weak_revalidate = ovl_dentry_weak_revalidate,
 };
 
+/* Get exclusive ownership on upper/work dir among overlay mounts */
+static bool ovl_dir_lock(struct dentry *dentry)
+{
+	return inode_inuse_trylock(d_inode(dentry));
+}
+
+static void ovl_dir_unlock(struct dentry *dentry)
+{
+	if (dentry)
+		inode_inuse_unlock(d_inode(dentry));
+}
+
 static void ovl_put_super(struct super_block *sb)
 {
 	struct ovl_fs *ufs = sb->s_fs_info;
 	unsigned i;
 
 	dput(ufs->workdir);
+	ovl_dir_unlock(ufs->workbasedir);
+	dput(ufs->workbasedir);
+	if (ufs->upper_mnt)
+		ovl_dir_unlock(ufs->upper_mnt->mnt_root);
 	mntput(ufs->upper_mnt);
 	for (i = 0; i < ufs->numlower; i++)
 		mntput(ufs->lower_mnt[i]);
@@ -788,9 +804,15 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		if (err)
 			goto out_put_upperpath;
 
+		err = -EBUSY;
+		if (!ovl_dir_lock(upperpath.dentry)) {
+			pr_err("overlayfs: upperdir is in-use by another mount\n");
+			goto out_put_upperpath;
+		}
+
 		err = ovl_mount_dir(ufs->config.workdir, &workpath);
 		if (err)
-			goto out_put_upperpath;
+			goto out_unlock_upperdentry;
 
 		err = -EINVAL;
 		if (upperpath.mnt != workpath.mnt) {
@@ -801,12 +823,20 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			pr_err("overlayfs: workdir and upperdir must be separate subtrees\n");
 			goto out_put_workpath;
 		}
+
+		err = -EBUSY;
+		if (!ovl_dir_lock(workpath.dentry)) {
+			pr_err("overlayfs: workdir is in-use by another mount\n");
+			goto out_put_workpath;
+		}
+
+		ufs->workbasedir = workpath.dentry;
 		sb->s_stack_depth = upperpath.mnt->mnt_sb->s_stack_depth;
 	}
 	err = -ENOMEM;
 	lowertmp = kstrdup(ufs->config.lowerdir, GFP_KERNEL);
 	if (!lowertmp)
-		goto out_put_workpath;
+		goto out_unlock_workdentry;
 
 	err = -EINVAL;
 	stacklen = ovl_split_lowerdirs(lowertmp);
@@ -849,6 +879,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			pr_err("overlayfs: failed to clone upperpath\n");
 			goto out_put_lowerpath;
 		}
+
 		/* Don't inherit atime flags */
 		ufs->upper_mnt->mnt_flags &= ~(MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME);
 
@@ -971,7 +1002,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	mntput(upperpath.mnt);
 	for (i = 0; i < numlower; i++)
 		mntput(stack[i].mnt);
-	path_put(&workpath);
+	mntput(workpath.mnt);
 	kfree(lowertmp);
 
 	if (upperpath.dentry) {
@@ -1011,8 +1042,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(stack);
 out_free_lowertmp:
 	kfree(lowertmp);
+out_unlock_workdentry:
+	ovl_dir_unlock(workpath.dentry);
 out_put_workpath:
 	path_put(&workpath);
+out_unlock_upperdentry:
+	ovl_dir_unlock(upperpath.dentry);
 out_put_upperpath:
 	path_put(&upperpath);
 out_free_config:
-- 
2.7.4
