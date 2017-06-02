From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 03/17] ovl: introduce the inodes index dir feature
Date: Fri,  2 Jun 2017 17:04:30 +0300
Message-ID: <1496412284-4113-4-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36195 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbdFBOEi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:38 -0400
Received: by mail-wr0-f196.google.com with SMTP id e23so172316wre.3
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:37 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Create the index dir on mount. The index dir will contain hardlinks to
upper inodes, named after the hex representation of their origin lower
inodes.

The index dir is going to be used to prevent breaking lower hardlinks
on copy up.

Because the feature is not fully backward compat, enabling the feature
is opt-in by config/module/mount option.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Kconfig     | 20 +++++++++++++++
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/ovl_entry.h |  3 +++
 fs/overlayfs/super.c     | 67 ++++++++++++++++++++++++++++++++++++++----------
 fs/overlayfs/util.c      |  7 +++++
 5 files changed, 85 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
index c0c9683934b7..b7241f273c36 100644
--- a/fs/overlayfs/Kconfig
+++ b/fs/overlayfs/Kconfig
@@ -23,3 +23,23 @@ config OVERLAY_FS_REDIRECT_DIR
 	  Note, that redirects are not backward compatible.  That is, mounting
 	  an overlay which has redirects on a kernel that doesn't support this
 	  feature will have unexpected results.
+
+config OVERLAY_FS_INDEX
+	bool "Overlayfs: turn on inodes index feature by default"
+	depends on OVERLAY_FS
+	help
+	  If this config option is enabled then overlay filesystems will use
+	  the inodes index dir to map lower inodes to upper inodes by default.
+	  In this case it is still possible to turn off index globally with the
+	  "index=off" module option or on a filesystem instance basis with the
+	  "index=off" mount option.
+
+	  The inodes index feature prevents breaking of lower hardlinks on copy
+	  up and enables NFS export.
+
+	  Note, that the inodes index feature is read-only backward compatible.
+	  That is, mounting an overlay which has an index dir on a kernel that
+	  doesn't support this feature read-only, will not have any negative
+	  outcomes.  However, mounting the same overlay with an old kernel
+	  read-write and then mounting it again with a new kernel, will have
+	  unexpected results.
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index bf7e1d95e640..45f1cd605f4d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -204,6 +204,7 @@ void ovl_drop_write(struct dentry *dentry);
 struct dentry *ovl_workdir(struct dentry *dentry);
 const struct cred *ovl_override_creds(struct super_block *sb);
 struct super_block *ovl_same_sb(struct super_block *sb);
+struct dentry *ovl_indexdir(struct super_block *sb);
 unsigned int ovl_verify_dir(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 298670fccbb6..f1b1f69e42f0 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -14,6 +14,7 @@ struct ovl_config {
 	char *workdir;
 	bool default_permissions;
 	bool redirect_dir;
+	bool index;
 	unsigned int verify_dir;
 };
 
@@ -26,6 +27,8 @@ struct ovl_fs {
 	struct dentry *workbasedir;
 	/* workdir is the 'work' directory under workbasedir */
 	struct dentry *workdir;
+	/* index directory listing overlay inodes by origin file handle */
+	struct dentry *indexdir;
 	long namelen;
 	/* pathnames of lower and upper dirs, for show_options */
 	struct ovl_config config;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 3cdefd401713..76d5a8cfa86a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -34,6 +34,11 @@ module_param_named(redirect_dir, ovl_redirect_dir_def, bool, 0644);
 MODULE_PARM_DESC(ovl_redirect_dir_def,
 		 "Default to on or off for the redirect_dir feature");
 
+static bool ovl_index_def = IS_ENABLED(CONFIG_OVERLAY_FS_INDEX);
+module_param_named(index, ovl_index_def, bool, 0644);
+MODULE_PARM_DESC(ovl_index_def,
+		 "Default to on or off for the inodes index feature");
+
 static void ovl_dentry_release(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
@@ -182,6 +187,7 @@ static void ovl_put_super(struct super_block *sb)
 	struct ovl_fs *ufs = sb->s_fs_info;
 	unsigned i;
 
+	dput(ufs->indexdir);
 	dput(ufs->workdir);
 	ovl_dir_unlock(ufs->workbasedir);
 	dput(ufs->workbasedir);
@@ -265,6 +271,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ufs->config.redirect_dir != ovl_redirect_dir_def)
 		seq_printf(m, ",redirect_dir=%s",
 			   ufs->config.redirect_dir ? "on" : "off");
+	if (ufs->config.index != ovl_index_def)
+		seq_printf(m, ",index=%s",
+			   ufs->config.index ? "on" : "off");
 	if (ufs->config.verify_dir) {
 		if (ufs->config.verify_dir == OVL_VERIFY_LOWER)
 			seq_puts(m, ",verify_lower");
@@ -300,6 +309,8 @@ enum {
 	OPT_DEFAULT_PERMISSIONS,
 	OPT_REDIRECT_DIR_ON,
 	OPT_REDIRECT_DIR_OFF,
+	OPT_INDEX_ON,
+	OPT_INDEX_OFF,
 	OPT_VERIFY_LOWER,
 	OPT_VERIFY_DIR,
 	OPT_ERR,
@@ -312,6 +323,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
 	{OPT_REDIRECT_DIR_ON,		"redirect_dir=on"},
 	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
+	{OPT_INDEX_ON,			"index=on"},
+	{OPT_INDEX_OFF,			"index=off"},
 	{OPT_VERIFY_LOWER,		"verify_lower"},
 	{OPT_VERIFY_DIR,		"verify_dir=%u"},
 	{OPT_ERR,			NULL}
@@ -386,6 +399,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->redirect_dir = false;
 			break;
 
+		case OPT_INDEX_ON:
+			config->index = true;
+			break;
+
+		case OPT_INDEX_OFF:
+			config->index = false;
+			break;
+
 		case OPT_VERIFY_LOWER:
 			config->verify_dir = OVL_VERIFY_LOWER;
 			break;
@@ -449,6 +470,7 @@ static int ovl_verify_set_origin(struct dentry *dir, struct vfsmount *mnt,
 }
 
 #define OVL_WORKDIR_NAME "work"
+#define OVL_INDEXDIR_NAME "index"
 
 static struct dentry *ovl_workdir_create(struct super_block *sb,
 					 struct ovl_fs *ufs,
@@ -840,6 +862,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	init_waitqueue_head(&ufs->copyup_wq);
 	ufs->config.redirect_dir = ovl_redirect_dir_def;
+	ufs->config.index = ovl_index_def;
 	err = ovl_parse_opt((char *) data, &ufs->config);
 	if (err)
 		goto out_free_config;
@@ -1002,6 +1025,12 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			} else {
 				vfs_removexattr(ufs->workdir, OVL_XATTR_OPAQUE);
 			}
+
+			/* Check if upper/work fs supports file handles */
+			if (!ovl_can_decode_fh(ufs->workdir->d_sb)) {
+				ufs->config.index = false;
+				pr_warn("overlayfs: upper fs does not support NFS export.\n");
+			}
 		}
 	}
 
@@ -1033,34 +1062,44 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			ufs->same_sb = NULL;
 
 		/*
-		 * The verify_lower feature is used to verify that lower dir
-		 * found by path matches the stored copy up origin file handle.
-		 * It requires that all layers support NFS export.
+		 * The inodes index and verify_lower features need to encode
+		 * and decode real inode file handles. They require that all
+		 * layers support NFS export.
 		 */
-		if (ufs->config.verify_dir) {
+		if (!ovl_can_decode_fh(mnt->mnt_sb)) {
+			ufs->config.index = false;
+			pr_warn("overlayfs: lower fs does not support NFS export.\n");
 			err = -EOPNOTSUPP;
-			if (!ovl_can_decode_fh(mnt->mnt_sb)) {
+			if (ufs->config.verify_dir) {
 				pr_err("overlayfs: option \"verify_lower\" not supported by lower fs.\n");
 				goto out_put_lower_mnt;
 			}
+		} else if (i == 0 && OVL_VERIFY_ROOT(ufs->config.verify_dir)) {
 			/* Verify lower root matches origin stored in upper */
-			if (i == 0 && OVL_VERIFY_ROOT(ufs->config.verify_dir)) {
-				err = ovl_verify_set_origin(upperpath.dentry,
-							    mnt, mnt->mnt_root,
-							    "lower root");
-				if (err)
-					goto out_put_lower_mnt;
-			}
+			err = ovl_verify_set_origin(upperpath.dentry, mnt,
+						    mnt->mnt_root,
+						    "lower root");
+			if (err)
+				goto out_put_lower_mnt;
 		}
 
 	}
 
+
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
 	if (!ufs->upper_mnt)
 		sb->s_flags |= MS_RDONLY;
 	else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
 		ufs->same_sb = NULL;
 
+	if (!(sb->s_flags & MS_RDONLY) && ufs->config.index) {
+		ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
+						   OVL_INDEXDIR_NAME, true);
+		err = PTR_ERR(ufs->indexdir);
+		if (IS_ERR(ufs->indexdir))
+			goto out_put_lower_mnt;
+	}
+
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
 	else
@@ -1068,7 +1107,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	ufs->creator_cred = cred = prepare_creds();
 	if (!cred)
-		goto out_put_lower_mnt;
+		goto out_put_indexdir;
 
 	/* Never override disk quota limits or use reserved space */
 	cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
@@ -1118,6 +1157,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(oe);
 out_put_cred:
 	put_cred(ufs->creator_cred);
+out_put_indexdir:
+	dput(ufs->indexdir);
 out_put_lower_mnt:
 	for (i = 0; i < ufs->numlower; i++)
 		mntput(ufs->lower_mnt[i]);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 535665243fe8..53c2fdb10e36 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -47,6 +47,13 @@ struct super_block *ovl_same_sb(struct super_block *sb)
 	return ofs->same_sb;
 }
 
+struct dentry *ovl_indexdir(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->indexdir;
+}
+
 unsigned int ovl_verify_dir(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
-- 
2.7.4
