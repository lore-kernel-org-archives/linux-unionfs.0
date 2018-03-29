Return-Path: <yangerkun@huawei.com>
From: yangerkun <yangerkun@huawei.com>
Subject: [RFC PATCH 2/2] overlay: add no wait share flock for lowers/upper/work dirs to help check mount
Date: Thu, 29 Mar 2018 17:08:56 +0800
Message-ID: <20180329090856.39966-1-yangerkun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: jlayton@kernel.org, miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

In order to help check any dirs has been used in overlay, add share
flock to lowerdirs/upperdir/workdir, so user space can use flock -x to
help check mount.

Signed-off-by: yangerkun <yangerkun@huawei.com>
---
 fs/overlayfs/ovl_entry.h |  3 ++
 fs/overlayfs/super.c     | 87 ++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index bfef6ed..69dd89c 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -35,10 +35,13 @@ struct ovl_path {
 /* private information held for overlayfs's superblock */
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
+	struct file *upperfile;
 	unsigned numlower;
 	struct ovl_layer *lower_layers;
+	struct file **lowerfiles;
 	/* workbasedir is the path at workdir= mount option */
 	struct dentry *workbasedir;
+	struct file *workbasefile;
 	/* workdir is the 'work' directory under workbasedir */
 	struct dentry *workdir;
 	/* index directory listing overlay inodes by origin file handle */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 9ee37c7..e311c66 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -16,6 +16,7 @@
 #include <linux/module.h>
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
+#include <linux/file.h>
 #include <linux/posix_acl_xattr.h>
 #include "overlayfs.h"
 
@@ -233,15 +234,31 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	if (ofs->workdir_locked)
 		ovl_inuse_unlock(ofs->workbasedir);
 	dput(ofs->workbasedir);
+
+	if (ofs->workbasefile)
+		fput(ofs->workbasefile);
+
 	if (ofs->upperdir_locked)
 		ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
 	mntput(ofs->upper_mnt);
+
+	if (ofs->upperfile)
+		fput(ofs->upperfile);
+
 	for (i = 0; i < ofs->numlower; i++) {
 		mntput(ofs->lower_layers[i].mnt);
 		free_anon_bdev(ofs->lower_layers[i].pseudo_dev);
 	}
 	kfree(ofs->lower_layers);
 
+	if (ofs->lowerfiles) {
+		for (i = 0; i < ofs->numlower; i++) {
+			if (ofs->lowerfiles[i])
+				fput(ofs->lowerfiles[i]);
+		}
+		kfree(ofs->lowerfiles);
+	}
+
 	kfree(ofs->config.lowerdir);
 	kfree(ofs->config.upperdir);
 	kfree(ofs->config.workdir);
@@ -902,15 +919,49 @@ static int ovl_other_xattr_set(const struct xattr_handler *handler,
 	NULL
 };
 
+static int ovl_add_share_flock(struct file *filp)
+{
+	int err;
+	struct file_lock *fl = locks_alloc_lock();
+
+	if (!fl)
+		return -ENOMEM;
+	fl->fl_file = filp;
+	fl->fl_owner = filp;
+	fl->fl_pid = current->tgid;
+	fl->fl_flags = FL_FLOCK;
+	fl->fl_type = F_RDLCK;
+	fl->fl_end = OFFSET_MAX;
+
+	err = flock_setlk(filp, fl);
+	locks_free_lock(fl);
+	return err;
+}
+
 static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
 {
 	struct vfsmount *upper_mnt;
+	struct file *upperfile;
 	int err;
 
 	err = ovl_mount_dir(ofs->config.upperdir, upperpath);
 	if (err)
 		goto out;
 
+	upperfile = ovl_path_open(upperpath, O_DIRECTORY);
+	if (IS_ERR(upperfile)) {
+		pr_err("overlayfs: unable to open upperdir.\n");
+		err = PTR_ERR(upperfile);
+		goto out;
+	}
+
+	ofs->upperfile = upperfile;
+	err = ovl_add_share_flock(upperfile);
+	if (err) {
+		pr_err("overlayfs: unable to add share flock for upperdir.\n");
+		goto out;
+	}
+
 	/* Upper fs should not be r/o */
 	if (sb_rdonly(upperpath->mnt->mnt_sb)) {
 		pr_err("overlayfs: upper fs is r/o, try multi-lower layers mount\n");
@@ -1021,11 +1072,26 @@ static int ovl_get_workdir(struct ovl_fs *ofs, struct path *upperpath)
 {
 	int err;
 	struct path workpath = { };
+	struct file *workfile;
 
 	err = ovl_mount_dir(ofs->config.workdir, &workpath);
 	if (err)
 		goto out;
 
+	workfile = ovl_path_open(&workpath, O_DIRECTORY);
+	if (IS_ERR(workfile)) {
+		pr_err("overlayfs: unable to open workdir.\n");
+		err = PTR_ERR(workfile);
+		goto out;
+	}
+
+	ofs->workbasefile = workfile;
+	err = ovl_add_share_flock(workfile);
+	if (err) {
+		pr_err("overlayfs: unable to add share flock for workdir.\n");
+		goto out;
+	}
+
 	err = -EINVAL;
 	if (upperpath->mnt != workpath.mnt) {
 		pr_err("overlayfs: workdir and upperdir must reside under the same mount\n");
@@ -1167,6 +1233,7 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	unsigned int stacklen, numlower = 0, i;
 	bool remote = false;
 	struct ovl_entry *oe;
+	struct file *lowerfile, **files = NULL;
 
 	err = -ENOMEM;
 	lowertmp = kstrdup(ofs->config.lowerdir, GFP_KERNEL);
@@ -1193,6 +1260,10 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	if (!stack)
 		goto out_err;
 
+	files = kcalloc(stacklen, sizeof(struct file *), GFP_KERNEL);
+	if (!files)
+		goto out_err;
+
 	err = -EINVAL;
 	lower = lowertmp;
 	for (numlower = 0; numlower < stacklen; numlower++) {
@@ -1201,9 +1272,24 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 		if (err)
 			goto out_err;
 
+		lowerfile = ovl_path_open(&stack[numlower], O_DIRECTORY);
+		if (IS_ERR(lowerfile)) {
+			pr_err("overlayfs: unable to open lowerdir:%s.\n", lower);
+			goto out_err;
+		}
+
+		files[numlower] = lowerfile;
+		err = ovl_add_share_flock(lowerfile);
+		if (err) {
+			pr_err("overlayfs: unable to add share flock for lowerdir:%s.\n", lower);
+			goto out_err;
+		}
+
 		lower = strchr(lower, '\0') + 1;
 	}
 
+	ofs->lowerfiles = files;
+
 	err = -EINVAL;
 	sb->s_stack_depth++;
 	if (sb->s_stack_depth > FILESYSTEM_MAX_STACK_DEPTH) {
@@ -1239,6 +1325,7 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	return oe;
 
 out_err:
+	kfree(files);
 	oe = ERR_PTR(err);
 	goto out;
 }
-- 
1.8.3.1
