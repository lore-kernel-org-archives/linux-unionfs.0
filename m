From: cgxu <cgxu@mykernel.net>
Subject: [PATCH]  long mount option support
Date: Tue, 24 Oct 2017 11:44:22 +0800
Message-ID: <D90A2B0B-C311-4F73-9CB7-D6361EDCD131@mykernel.net>
Mime-Version: 1.0 (Mac OS X Mail 10.3 \(3273\))
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from smtpbguseast2.qq.com ([54.204.34.130]:56661 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751267AbdJXDoZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 23 Oct 2017 23:44:25 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Hi Miklos,

We’re testing our container system using overlayfs as image storage.
We noticed that although overlayfs supports maximum 500 layers in filesystem,
but  when lowerdir is quite long then mount will fail because of mount option’s one PAGE SIZE limitation.
In our environment, we added new mount option “long_option” to deliver long mount option with extended attribute.
This approach is backward compatible and could be useful to container.
I have done basic testing on this and hope to hear some feedback for the patch.

Detail explanations:
In this approach, we can set mount option both in command line and config file’s extended attribute.
There are three possible cases as below.

Case1) set all mount options in extended attribute
Example steps:
1, setfattr -n “trusted.overlayfs.long_option” -v “lowerdir=l1:l2:l3,upperdir=upper,workdir=work” overlay-config
2, mount -t overlay overlay -o long_option=./overlay-config merged

Case2) set mount options both in command line and config file’s extended attribute.
Example steps:
1, setfattr -n “trusted.overlayfs.long_option” -v “lowerdir=l1:l2:l3” overlay-config
2, mount -t  overlay overlay -o upperdir=upper,workdir=work,long_option=./overlay-config merged

// We can set same option both in command line amd config file’s extended attribute.
// In this case, command line value will override the value in the extended attribute.

Case3) set all mount options in command line.
Example steps:
1, mount -t overlay overlay -o upperdir=upper,workdir=work,lowerdir=lower merged

—

Signed-off-by: Chengguang Xu <cgxu@mykernel.net>

diff -Nurp a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
--- a/fs/overlayfs/overlayfs.h	2017-10-21 23:55:07.000000000 +0800
+++ b/fs/overlayfs/overlayfs.h	2017-10-23 17:55:46.338203874 +0800
@@ -27,6 +27,20 @@ enum ovl_path_type {
#define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
#define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
+#define OVL_XATTR_LONG_OPTION "trusted.overlayfs.long_option"
+
+enum ovl_opt_type {
+	__OVL_OPT_LOWERDIR	= (1 << 0),
+	__OVL_OPT_UPPERDIR	= (1 << 1),
+	__OVL_OPT_WORKDIR	= (1 << 2),
+	__OVL_OPT_LONG_OPTION	= (1 << 3),
+};
+
+#define OVL_OPT_LOWERDIR(type)		((type) & __OVL_OPT_LOWERDIR)
+#define OVL_OPT_UPPERDIR(type)		((type) & __OVL_OPT_UPPERDIR)
+#define OVL_OPT_WORKDIR(type)		((type) & __OVL_OPT_WORKDIR)
+#define OVL_OPT_LONG_OPTION(type)	((type) & __OVL_OPT_LONG_OPTION)
+
enum ovl_flag {
	OVL_IMPURE,
	OVL_INDEX,
diff -Nurp a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
--- a/fs/overlayfs/ovl_entry.h	2017-10-21 23:55:07.000000000 +0800
+++ b/fs/overlayfs/ovl_entry.h	2017-10-23 17:55:46.770211500 +0800
@@ -12,6 +12,8 @@ struct ovl_config {
	char *lowerdir;
	char *upperdir;
	char *workdir;
+	char *long_option;
+	enum ovl_opt_type opt_type;
	bool default_permissions;
	bool redirect_dir;
	bool index;
diff -Nurp a/fs/overlayfs/super.c b/fs/overlayfs/super.c
--- a/fs/overlayfs/super.c	2017-10-21 23:55:07.000000000 +0800
+++ b/fs/overlayfs/super.c	2017-10-23 18:14:35.619263116 +0800
@@ -289,11 +289,14 @@ static int ovl_show_options(struct seq_f
	struct super_block *sb = dentry->d_sb;
	struct ovl_fs *ufs = sb->s_fs_info;
-	seq_show_option(m, "lowerdir", ufs->config.lowerdir);
-	if (ufs->config.upperdir) {
+	if (OVL_OPT_LOWERDIR(ufs->config.opt_type))
+		seq_show_option(m, "lowerdir", ufs->config.lowerdir);
+	if (OVL_OPT_UPPERDIR(ufs->config.opt_type))
		seq_show_option(m, "upperdir", ufs->config.upperdir);
+	if (OVL_OPT_WORKDIR(ufs->config.opt_type))
		seq_show_option(m, "workdir", ufs->config.workdir);
-	}
+	if (OVL_OPT_LONG_OPTION(ufs->config.opt_type))
+		seq_show_option(m, "long_option", ufs->config.long_option);
	if (ufs->config.default_permissions)
		seq_puts(m, ",default_permissions");
	if (ufs->config.redirect_dir != ovl_redirect_dir_def)
@@ -330,6 +333,7 @@ enum {
	OPT_LOWERDIR,
	OPT_UPPERDIR,
	OPT_WORKDIR,
+	OPT_LONG_OPTION,
	OPT_DEFAULT_PERMISSIONS,
	OPT_REDIRECT_DIR_ON,
	OPT_REDIRECT_DIR_OFF,
@@ -342,6 +346,7 @@ static const match_table_t ovl_tokens =
	{OPT_LOWERDIR,			"lowerdir=%s"},
	{OPT_UPPERDIR,			"upperdir=%s"},
	{OPT_WORKDIR,			"workdir=%s"},
+	{OPT_LONG_OPTION,		"long_option=%s"},
	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
	{OPT_REDIRECT_DIR_ON,		"redirect_dir=on"},
	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
@@ -407,6 +412,13 @@ static int ovl_parse_opt(char *opt, stru
				return -ENOMEM;
			break;
+		case OPT_LONG_OPTION:
+			kfree(config->long_option);
+			config->long_option = match_strdup(&args[0]);
+			if (!config->long_option)
+				return -ENOMEM;
+			break;
+
		case OPT_DEFAULT_PERMISSIONS:
			config->default_permissions = true;
			break;
@@ -433,14 +445,6 @@ static int ovl_parse_opt(char *opt, stru
		}
	}
-	/* Workdir is useless in non-upper mount */
-	if (!config->upperdir && config->workdir) {
-		pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
-			config->workdir);
-		kfree(config->workdir);
-		config->workdir = NULL;
-	}
-
	return 0;
}
@@ -621,6 +625,43 @@ static int ovl_check_namelen(struct path
	return err;
}
+static int ovl_long_option_check(const char *name, struct path *path)
+{
+	int err = -ENOMEM;
+	char *tmp = kstrdup(name, GFP_KERNEL);
+
+	if (!tmp)
+		goto out;
+
+	ovl_unescape(tmp);
+	err = kern_path(tmp, LOOKUP_FOLLOW, path);
+	if (err) {
+		pr_err("overlayfs: failed to resolve '%s': %i\n", tmp, err);
+		goto out_free_tmp;
+	}
+
+	err = -EINVAL;
+	if (ovl_dentry_weird(path->dentry)) {
+		pr_err("overlayfs: filesystem on '%s' not supported\n", tmp);
+		goto out_put;
+	}
+
+	if (unlikely(!S_ISREG(path->dentry->d_inode->i_mode))) {
+		pr_err("overlayfs: '%s' not a file\n", tmp);
+		goto out_put;
+	}
+
+	kfree(tmp);
+	return 0;
+
+out_put:
+	path_put(path);
+out_free_tmp:
+	kfree(tmp);
+out:
+	return err;
+}
+
static int ovl_lower_dir(const char *name, struct path *path,
			 struct ovl_fs *ofs, int *stack_depth, bool *remote)
{
@@ -826,12 +867,16 @@ static int ovl_fill_super(struct super_b
{
	struct path upperpath = { };
	struct path workpath = { };
+	struct path long_option_path = { NULL, NULL };
	struct dentry *root_dentry;
	struct ovl_entry *oe;
	struct ovl_fs *ufs;
+	struct ovl_fs *new_ufs;
	struct path *stack = NULL;
	char *lowertmp;
	char *lower;
+	char *long_option_data = NULL;
+	size_t long_option_size = 0; 
	unsigned int numlower;
	unsigned int stacklen = 0;
	unsigned int i;
@@ -850,6 +895,75 @@ static int ovl_fill_super(struct super_b
	if (err)
		goto out_free_config;
+	if (ufs->config.long_option && (!ufs->config.lowerdir || !ufs->config.upperdir || !ufs->config.workdir)) {
+		err = ovl_long_option_check(ufs->config.long_option, &long_option_path);
+		if (err)
+			goto  out_free_config;
+
+		err = -EINVAL;
+		if ((long_option_size = vfs_getxattr(long_option_path.dentry, OVL_XATTR_LONG_OPTION, NULL, 0)) <= 0) {
+			pr_err("overlayfs: improper value of xattr OVL_XATTR_LONG_OPTION in %s\n", ufs->config.long_option);
+			goto out_put_long_option_path;
+		}
+
+		err = -ENOMEM;
+		long_option_data = kzalloc(long_option_size + 1, GFP_KERNEL);
+		if (!long_option_data)
+			goto out_put_long_option_path;
+
+		new_ufs = kzalloc(sizeof(struct ovl_fs), GFP_KERNEL);
+		if (!new_ufs)
+			goto out_free_long_option_data;
+
+		err = -EINVAL;
+		if (vfs_getxattr(long_option_path.dentry, OVL_XATTR_LONG_OPTION, long_option_data, long_option_size) < 0) {
+			pr_err("overlayfs: improper value of xattr OVL_XATTR_LONG_OPTION in %s\n", ufs->config.long_option);
+			goto out_free_new_config;
+		}
+
+		err = ovl_parse_opt((char *) long_option_data, &new_ufs->config);
+		if (err)
+			goto out_free_new_config;
+
+		if (ufs->config.lowerdir)
+			ufs->config.opt_type |= __OVL_OPT_LOWERDIR;
+		if (ufs->config.upperdir)
+			ufs->config.opt_type |= __OVL_OPT_UPPERDIR;
+		if (ufs->config.workdir)
+			ufs->config.opt_type |= __OVL_OPT_WORKDIR;
+
+		ufs->config.opt_type |= __OVL_OPT_LONG_OPTION;
+
+		if (!ufs->config.lowerdir && new_ufs->config.lowerdir) {
+			ufs->config.lowerdir = new_ufs->config.lowerdir;
+			new_ufs->config.lowerdir = NULL;
+		}
+
+		if (!ufs->config.upperdir && new_ufs->config.upperdir) {
+			ufs->config.upperdir = new_ufs->config.upperdir;
+			new_ufs->config.upperdir = NULL;
+		}
+
+		if (!ufs->config.workdir && new_ufs->config.workdir) {
+			ufs->config.workdir = new_ufs->config.workdir;
+			new_ufs->config.workdir = NULL;
+		}
+
+		kfree(new_ufs->config.lowerdir);
+		kfree(new_ufs->config.upperdir);
+		kfree(new_ufs->config.workdir);
+		kfree(new_ufs);
+		kfree(long_option_data);
+		path_put(&long_option_path);
+	}
+
+	/* Workdir is useless in non-upper mount */
+	if (!ufs->config.upperdir && ufs->config.workdir) {
+		pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper mount, ignore\n", ufs->config.workdir);
+		kfree(ufs->config.workdir);
+		ufs->config.workdir = NULL;
+	}
+
	err = -EINVAL;
	if (!ufs->config.lowerdir) {
		if (!silent)
@@ -1173,6 +1287,15 @@ out_unlock_upperdentry:
		ovl_inuse_unlock(upperpath.dentry);
out_put_upperpath:
	path_put(&upperpath);
+out_free_new_config:
+	kfree(new_ufs->config.lowerdir);
+	kfree(new_ufs->config.upperdir);
+	kfree(new_ufs->config.workdir);
+	kfree(new_ufs);
+out_free_long_option_data:
+	kfree(long_option_data);
+out_put_long_option_path:
+	path_put(&long_option_path);
out_free_config:
	kfree(ufs->config.lowerdir);
	kfree(ufs->config.upperdir);

—

Best Regards,
cgxu.
