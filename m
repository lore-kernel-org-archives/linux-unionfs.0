From: hujianyang <hujianyang@huawei.com>
Subject: Allow non-workdir mount in overlayfs?
Date: Wed, 14 Jan 2015 10:45:54 +0800
Message-ID: <54B5D862.3010600@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:28934 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbbANCqR (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 13 Jan 2015 21:46:17 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Seunghun Lee <waydi1@gmail.com>, linux-unionfs@vger.kernel.org

Hi Miklos,

I was considering the "FIXME: workdir is not needed for a R/O mount"
you left in ovl_fill_super() these days.

Actually Seunghun (Seunghun Lee <waydi1@gmail.com>) has sent a patch
about these problem. But I have some different ideas. I think there are
two ways to fix this problem. One, just remove this *FIXME*. Another,
Allow non-workdir mount.

1) Remove *FIXME*; Further, use workdir in R/W case only

As multi-layer mount are allowed in ovl, users could initialize a R/O
mount by setting multi lower directories. Workdir should only be used
in R/W case with upperdir exist. So this *FIXME* can be removed.

We should add some information in the code and document about this.

2) Allow non-workdir mount

This logic is simple, just mark upper_mnt as R/O if workdir is not exist
in the option line.

I've written a patch about it below. But I'm not sure which way is
better, or there are other acceptable solutions. I need your advisement.


Here is a problem, if upper partition is R/O mount, ovl can't create
*work* directory in workdir and return an error:

overlayfs: failed to create directory ./workdir/work

I guess this problem can be fixed if we decide how to deal with R/O
mount.

Thanks,
Hu


Non-workdir mount patch:

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b90952f..c7141ff 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -520,7 +520,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	seq_printf(m, ",lowerdir=%s", ufs->config.lowerdir);
 	if (ufs->config.upperdir) {
 		seq_printf(m, ",upperdir=%s", ufs->config.upperdir);
-		seq_printf(m, ",workdir=%s", ufs->config.workdir);
+		if (ufs->config.workdir)
+			seq_printf(m, ",workdir=%s", ufs->config.workdir);
 	}
 	return 0;
 }
@@ -530,7 +531,8 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
 	struct ovl_fs *ufs = sb->s_fs_info;

 	if (!(*flags & MS_RDONLY) &&
-	    (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY)))
+	    (!ufs->upper_mnt || !ufs->workdir ||
+	    (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY)))
 		return -EROFS;

 	return 0;
@@ -837,28 +839,24 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)

 	sb->s_stack_depth = 0;
 	if (ufs->config.upperdir) {
-		/* FIXME: workdir is not needed for a R/O mount */
-		if (!ufs->config.workdir) {
-			pr_err("overlayfs: missing 'workdir'\n");
-			goto out_free_config;
-		}
-
 		err = ovl_mount_dir(ufs->config.upperdir, &upperpath);
 		if (err)
 			goto out_free_config;

-		err = ovl_mount_dir(ufs->config.workdir, &workpath);
-		if (err)
-			goto out_put_upperpath;
+		if (ufs->config.workdir) {
+			err = ovl_mount_dir(ufs->config.workdir, &workpath);
+			if (err)
+				goto out_put_upperpath;

-		err = -EINVAL;
-		if (upperpath.mnt != workpath.mnt) {
-			pr_err("overlayfs: workdir and upperdir must reside under the same mount\n");
-			goto out_put_workpath;
-		}
-		if (!ovl_workdir_ok(workpath.dentry, upperpath.dentry)) {
-			pr_err("overlayfs: workdir and upperdir must be separate subtrees\n");
-			goto out_put_workpath;
+			err = -EINVAL;
+			if (upperpath.mnt != workpath.mnt) {
+				pr_err("overlayfs: workdir and upperdir must reside under the same mount\n");
+				goto out_put_workpath;
+			}
+			if (!ovl_workdir_ok(workpath.dentry, upperpath.dentry)) {
+				pr_err("overlayfs: workdir and upperdir must be separate subtrees\n");
+				goto out_put_workpath;
+			}
 		}
 		sb->s_stack_depth = upperpath.mnt->mnt_sb->s_stack_depth;
 	}
@@ -901,12 +899,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			goto out_put_lowerpath;
 		}

-		ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
-		err = PTR_ERR(ufs->workdir);
-		if (IS_ERR(ufs->workdir)) {
-			pr_err("overlayfs: failed to create directory %s/%s\n",
-			       ufs->config.workdir, OVL_WORKDIR_NAME);
-			goto out_put_upper_mnt;
+		if (ufs->config.workdir) {
+			ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
+			err = PTR_ERR(ufs->workdir);
+			if (IS_ERR(ufs->workdir)) {
+				pr_err("overlayfs: failed to create directory %s/%s\n",
+				       ufs->config.workdir, OVL_WORKDIR_NAME);
+				goto out_put_upper_mnt;
+			}
+		} else {
+			ufs->upper_mnt->mnt_flags |= MNT_READONLY;
 		}
 	}

@@ -932,8 +934,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		ufs->numlower++;
 	}

-	/* If the upper fs is r/o or nonexistent, we mark overlayfs r/o too */
-	if (!ufs->upper_mnt || (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
+	/*
+	 * If the upper fs is r/o or nonexistent, or workdir is absent,
+	 * we mark overlayfs r/o too
+	 */
+	if (!ufs->upper_mnt || !ufs->workdir ||
+	    (ufs->upper_mnt->mnt_sb->s_flags & MS_RDONLY))
 		sb->s_flags |= MS_RDONLY;

 	sb->s_d_op = &ovl_dentry_operations;

