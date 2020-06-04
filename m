Return-Path: <SRS0=s+il=7R=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5643EC433E0
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 16:13:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C4D920738
	for <linux-unionfs@archiver.kernel.org>; Thu,  4 Jun 2020 16:13:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729747AbgFDQND (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 4 Jun 2020 12:13:03 -0400
Received: from relay.sw.ru ([185.231.240.75]:35390 "EHLO relay3.sw.ru"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729678AbgFDQND (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jun 2020 12:13:03 -0400
Received: from [172.16.25.93] (helo=amikhalitsyn-pc0.sw.ru)
        by relay3.sw.ru with esmtp (Exim 4.93)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1jgsU9-0003Zt-5J; Thu, 04 Jun 2020 19:12:53 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     miklos@szeredi.hu
Cc:     avagin@openvz.org, ptikhomirov@virtuozzo.com,
        khorenko@virtuozzo.com, vvs@virtuozzo.com, ktkhai@virtuozzo.com,
        Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>,
        linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] overlayfs: add dynamic path resolving in mount options
Date:   Thu,  4 Jun 2020 19:11:32 +0300
Message-Id: <20200604161133.20949-2-alexander.mikhalitsyn@virtuozzo.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
References: <20200604161133.20949-1-alexander.mikhalitsyn@virtuozzo.com>
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

This patch adds OVERLAY_FS_DYNAMIC_RESOLVE_PATH_OPTIONS
compile-time option, and "dyn_path_opts" runtime module option.
These options corresponds "dynamic path resolving in lowerdir,
upperdir, workdir mount options" mode. If enabled, user may see
real full paths relatively to the mount namespace in lowerdir,
upperdir, workdir options (/proc/mounts, /proc/<fd>/mountinfo).

This patch is very helpful to checkpoint/restore functionality
of overlayfs mounts. With this patch and CRIU it's real to C/R
Docker containers with overlayfs storage driver.

Note: d_path function from dcache.c is used to resolve full path
in mount namespace. This function also adds "(deleted)" suffix
if dentry was deleted. So, If one of dentries in lowerdir, upperdir,
workdir options is deleted, we will see "(deleted)" suffix in
corresponding path.

Signed-off-by: Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
---
 fs/overlayfs/Kconfig     | 31 ++++++++++++++
 fs/overlayfs/overlayfs.h |  5 +++
 fs/overlayfs/ovl_entry.h |  6 ++-
 fs/overlayfs/super.c     | 88 ++++++++++++++++++++++------------------
 fs/overlayfs/util.c      | 21 ++++++++++
 5 files changed, 110 insertions(+), 41 deletions(-)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index dd188c7996b3..c24988527ef3 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -124,3 +124,34 @@ config OVERLAY_FS_METACOPY
 	  that doesn't support this feature will have unexpected results.
 
 	  If unsure, say N.
+
+config OVERLAY_FS_DYNAMIC_RESOLVE_PATH_OPTIONS
+	bool "Overlayfs: all mount paths options resolves dynamically on options show"
+	default y
+	depends on OVERLAY_FS
+	help
+	  This option helps checkpoint/restore of overlayfs mounts.
+	  If N selected, old behavior is saved. In this case lowerdir, upperdir,
+	  workdir options shows in /proc/fd/mountinfo, /proc/mounts as it given
+	  by user on mount. User may specify relative paths in these options, then
+	  we couldn't determine from options which full paths correspond these
+	  relative paths. Also, after pivot_root syscall these paths (even full)
+	  will not rebuild according to root change.
+
+	  If this config option is enabled then overlay filesystems lowerdir, upperdir,
+	  workdir options paths will dynamically recalculated as full paths in corresponding
+	  mount namespaces by default.
+
+	  It's also possible to change this behavior on overlayfs module loading or
+	  through sysfs (dyn_path_opts parameter).
+
+	  Disable this to get a backward compatible with previous kernels configuration,
+	  but in this case checkpoint/restore functionality for overlayfs mounts
+	  will not work.
+
+	  If backward compatibility is not an issue, then it is safe and
+	  recommended to say Y here.
+
+	  For more information, see Documentation/filesystems/overlayfs.txt
+
+	  If unsure, say N.
\ No newline at end of file
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e6f3670146ed..8722ed556e11 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -302,6 +302,11 @@ char *ovl_get_redirect_xattr(struct dentry *dentry, int padding);
 ssize_t ovl_getxattr(struct dentry *dentry, char *name, char **value,
 		     size_t padding);
 
+void print_path_option(struct seq_file *m, const char *name, struct path *path);
+void print_paths_option(struct seq_file *m, const char *name,
+			struct path *paths, unsigned int num);
+			struct path *paths, unsigned int num);
+
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
 	return ovl_check_dir_xattr(dentry, OVL_XATTR_IMPURE);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 5762d802fe01..5db2582b47bf 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -47,13 +47,15 @@ struct ovl_path {
 /* private information held for overlayfs's superblock */
 struct ovl_fs {
 	struct vfsmount *upper_mnt;
+	struct path upperpath;
 	unsigned int numlayer;
 	/* Number of unique fs among layers including upper fs */
 	unsigned int numfs;
+	struct path *lowerpaths;
 	const struct ovl_layer *layers;
 	struct ovl_sb *fs;
-	/* workbasedir is the path at workdir= mount option */
-	struct dentry *workbasedir;
+	/* workbasepath is the path at workdir= mount option */
+	struct path workbasepath;
 	/* workdir is the 'work' directory under workbasedir */
 	struct dentry *workdir;
 	/* index directory listing overlay inodes by origin file handle */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 732ad5495c92..a449b6bb4b20 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -53,6 +53,10 @@ module_param_named(xino_auto, ovl_xino_auto_def, bool, 0644);
 MODULE_PARM_DESC(xino_auto,
 		 "Auto enable xino feature");
 
+static bool ovl_dyn_path_opts = IS_ENABLED(CONFIG_OVERLAY_FS_DYNAMIC_RESOLVE_PATH_OPTIONS);
+module_param_named(dyn_path_opts, ovl_dyn_path_opts, bool, 0644);
+MODULE_PARM_DESC(dyn_path_opts, "dyn_path_opts feature enabled");
+
 static void ovl_entry_stack_free(struct ovl_entry *oe)
 {
 	unsigned int i;
@@ -220,11 +224,17 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	dput(ofs->indexdir);
 	dput(ofs->workdir);
 	if (ofs->workdir_locked)
-		ovl_inuse_unlock(ofs->workbasedir);
-	dput(ofs->workbasedir);
+		ovl_inuse_unlock(ofs->workbasepath.dentry);
+	path_put(&ofs->workbasepath);
 	if (ofs->upperdir_locked)
 		ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
 	mntput(ofs->upper_mnt);
+	path_put(&ofs->upperpath);
+	if (ofs->lowerpaths) {
+		for (i = 0; i < ofs->numlayer; i++)
+			path_put(&ofs->lowerpaths[i]);
+		kfree(ofs->lowerpaths);
+	}
 	for (i = 1; i < ofs->numlayer; i++) {
 		iput(ofs->layers[i].trap);
 		mntput(ofs->layers[i].mnt);
@@ -339,10 +349,18 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	struct super_block *sb = dentry->d_sb;
 	struct ovl_fs *ofs = sb->s_fs_info;
 
-	seq_show_option(m, "lowerdir", ofs->config.lowerdir);
-	if (ofs->config.upperdir) {
-		seq_show_option(m, "upperdir", ofs->config.upperdir);
-		seq_show_option(m, "workdir", ofs->config.workdir);
+	if (ovl_dyn_path_opts) {
+		print_paths_option(m, "lowerdir", ofs->lowerpaths, ofs->numlayer);
+		if (ofs->config.upperdir) {
+			print_path_option(m, "upperdir", &ofs->upperpath);
+			print_path_option(m, "workdir", &ofs->workbasepath);
+		}
+	} else {
+		seq_show_option(m, "lowerdir", ofs->config.lowerdir);
+		if (ofs->config.upperdir) {
+			seq_show_option(m, "upperdir", ofs->config.upperdir);
+			seq_show_option(m, "workdir", ofs->config.workdir);
+		}
 	}
 	if (ofs->config.default_permissions)
 		seq_puts(m, ",default_permissions");
@@ -610,7 +628,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 					 const char *name, bool persist)
 {
-	struct inode *dir =  ofs->workbasedir->d_inode;
+	struct inode *dir =  ofs->workbasepath.dentry->d_inode;
 	struct vfsmount *mnt = ofs->upper_mnt;
 	struct dentry *work;
 	int err;
@@ -621,7 +639,7 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 	locked = true;
 
 retry:
-	work = lookup_one_len(name, ofs->workbasedir, strlen(name));
+	work = lookup_one_len(name, ofs->workbasepath.dentry, strlen(name));
 
 	if (!IS_ERR(work)) {
 		struct iattr attr = {
@@ -1126,7 +1144,7 @@ static int ovl_check_rename_whiteout(struct dentry *workdir)
 }
 
 static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
-			    struct path *workpath)
+			    struct path *workbasepath)
 {
 	struct vfsmount *mnt = ofs->upper_mnt;
 	struct dentry *temp;
@@ -1153,7 +1171,7 @@ static int ovl_make_workdir(struct super_block *sb, struct ovl_fs *ofs,
 	 * workdir. This check requires successful creation of workdir in
 	 * previous step.
 	 */
-	err = ovl_check_d_type_supported(workpath);
+	err = ovl_check_d_type_supported(workbasepath);
 	if (err < 0)
 		goto out;
 
@@ -1230,25 +1248,22 @@ static int ovl_get_workdir(struct super_block *sb, struct ovl_fs *ofs,
 			   struct path *upperpath)
 {
 	int err;
-	struct path workpath = { };
 
-	err = ovl_mount_dir(ofs->config.workdir, &workpath);
+	err = ovl_mount_dir(ofs->config.workdir, &ofs->workbasepath);
 	if (err)
 		goto out;
 
 	err = -EINVAL;
-	if (upperpath->mnt != workpath.mnt) {
+	if (upperpath->mnt != ofs->workbasepath.mnt) {
 		pr_err("workdir and upperdir must reside under the same mount\n");
 		goto out;
 	}
-	if (!ovl_workdir_ok(workpath.dentry, upperpath->dentry)) {
+	if (!ovl_workdir_ok(ofs->workbasepath.dentry, upperpath->dentry)) {
 		pr_err("workdir and upperdir must be separate subtrees\n");
 		goto out;
 	}
 
-	ofs->workbasedir = dget(workpath.dentry);
-
-	if (ovl_inuse_trylock(ofs->workbasedir)) {
+	if (ovl_inuse_trylock(ofs->workbasepath.dentry)) {
 		ofs->workdir_locked = true;
 	} else {
 		err = ovl_report_in_use(ofs, "workdir");
@@ -1256,15 +1271,14 @@ static int ovl_get_workdir(struct super_block *sb, struct ovl_fs *ofs,
 			goto out;
 	}
 
-	err = ovl_setup_trap(sb, ofs->workbasedir, &ofs->workbasedir_trap,
+	err = ovl_setup_trap(sb, ofs->workbasepath.dentry, &ofs->workbasedir_trap,
 			     "workdir");
 	if (err)
 		goto out;
 
-	err = ovl_make_workdir(sb, ofs, &workpath);
+	err = ovl_make_workdir(sb, ofs, &ofs->workbasepath);
 
 out:
-	path_put(&workpath);
 
 	return err;
 }
@@ -1513,7 +1527,6 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 {
 	int err;
 	char *lowertmp, *lower;
-	struct path *stack = NULL;
 	unsigned int stacklen, numlower = 0, i;
 	struct ovl_entry *oe;
 
@@ -1538,14 +1551,14 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 	}
 
 	err = -ENOMEM;
-	stack = kcalloc(stacklen, sizeof(struct path), GFP_KERNEL);
-	if (!stack)
+	ofs->lowerpaths = kcalloc(stacklen, sizeof(struct path), GFP_KERNEL);
+	if (!ofs->lowerpaths)
 		goto out_err;
 
 	err = -EINVAL;
 	lower = lowertmp;
 	for (numlower = 0; numlower < stacklen; numlower++) {
-		err = ovl_lower_dir(lower, &stack[numlower], ofs,
+		err = ovl_lower_dir(lower, &ofs->lowerpaths[numlower], ofs,
 				    &sb->s_stack_depth);
 		if (err)
 			goto out_err;
@@ -1560,7 +1573,7 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 		goto out_err;
 	}
 
-	err = ovl_get_layers(sb, ofs, stack, numlower);
+	err = ovl_get_layers(sb, ofs, ofs->lowerpaths, numlower);
 	if (err)
 		goto out_err;
 
@@ -1570,19 +1583,20 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
 		goto out_err;
 
 	for (i = 0; i < numlower; i++) {
-		oe->lowerstack[i].dentry = dget(stack[i].dentry);
+		oe->lowerstack[i].dentry = dget(ofs->lowerpaths[i].dentry);
 		oe->lowerstack[i].layer = &ofs->layers[i+1];
 	}
 
 out:
-	for (i = 0; i < numlower; i++)
-		path_put(&stack[i]);
-	kfree(stack);
 	kfree(lowertmp);
 
 	return oe;
 
 out_err:
+	for (i = 0; i < numlower; i++)
+		path_put_init(&ofs->lowerpaths[i]);
+	kfree(ofs->lowerpaths);
+	ofs->lowerpaths = NULL;
 	oe = ERR_PTR(err);
 	goto out;
 }
@@ -1642,7 +1656,7 @@ static int ovl_check_overlapping_layers(struct super_block *sb,
 		 * workbasedir.  In that case, we already have their traps in
 		 * inode cache and we will catch that case on lookup.
 		 */
-		err = ovl_check_layer(sb, ofs, ofs->workbasedir, "workdir");
+		err = ovl_check_layer(sb, ofs, ofs->workbasepath.dentry, "workdir");
 		if (err)
 			return err;
 	}
@@ -1667,7 +1681,7 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 	unsigned long ino = d_inode(lowerpath->dentry)->i_ino;
 	int fsid = lowerpath->layer->fsid;
 	struct ovl_inode_params oip = {
-		.upperdentry = upperdentry,
+		.upperdentry = dget(upperdentry),
 		.lowerpath = lowerpath,
 	};
 
@@ -1698,7 +1712,6 @@ static struct dentry *ovl_get_root(struct super_block *sb,
 
 static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 {
-	struct path upperpath = { };
 	struct dentry *root_dentry;
 	struct ovl_entry *oe;
 	struct ovl_fs *ofs;
@@ -1752,11 +1765,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			goto out_err;
 		}
 
-		err = ovl_get_upper(sb, ofs, &upperpath);
+		err = ovl_get_upper(sb, ofs, &ofs->upperpath);
 		if (err)
 			goto out_err;
 
-		err = ovl_get_workdir(sb, ofs, &upperpath);
+		err = ovl_get_workdir(sb, ofs, &ofs->upperpath);
 		if (err)
 			goto out_err;
 
@@ -1777,7 +1790,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		sb->s_flags |= SB_RDONLY;
 
 	if (!(ovl_force_readonly(ofs)) && ofs->config.index) {
-		err = ovl_get_indexdir(sb, ofs, oe, &upperpath);
+		err = ovl_get_indexdir(sb, ofs, oe, &ofs->upperpath);
 		if (err)
 			goto out_free_oe;
 
@@ -1820,12 +1833,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	sb->s_flags |= SB_POSIXACL;
 
 	err = -ENOMEM;
-	root_dentry = ovl_get_root(sb, upperpath.dentry, oe);
+	root_dentry = ovl_get_root(sb, ofs->upperpath.dentry, oe);
 	if (!root_dentry)
 		goto out_free_oe;
 
-	mntput(upperpath.mnt);
-
 	sb->s_root = root_dentry;
 
 	return 0;
@@ -1834,7 +1845,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	ovl_entry_stack_free(oe);
 	kfree(oe);
 out_err:
-	path_put(&upperpath);
 	ovl_free_fs(ofs);
 out:
 	return err;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 36b60788ee47..36bb98c14d35 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -13,6 +13,7 @@
 #include <linux/uuid.h>
 #include <linux/namei.h>
 #include <linux/ratelimit.h>
+#include <linux/seq_file.h>
 #include "overlayfs.h"
 
 int ovl_want_write(struct dentry *dentry)
@@ -920,3 +921,23 @@ char *ovl_get_redirect_xattr(struct dentry *dentry, int padding)
 	kfree(buf);
 	return ERR_PTR(res);
 }
+
+void print_path_option(struct seq_file *m, const char *name, struct path *path)
+{
+	seq_show_option(m, name, "");
+	seq_path(m, path, ", \t\n\\");
+}
+
+void print_paths_option(struct seq_file *m, const char *name,
+			struct path *paths, unsigned int num)
+{
+	int i;
+
+	seq_show_option(m, name, "");
+
+	for (i = 0; i < num; i++) {
+		if (i)
+			seq_putc(m, ':');
+		seq_path(m, &paths[i], ", \t\n\\");
+	}
+}
-- 
2.17.1

