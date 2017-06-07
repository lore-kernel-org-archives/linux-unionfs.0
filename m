From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 05/20] ovl: introduce the inodes index dir feature
Date: Wed,  7 Jun 2017 10:51:09 +0300
Message-ID: <1496821884-5178-6-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35399 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbdFGHvT (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:51:19 -0400
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Create the index dir on mount. The index dir will contain hardlinks to
upper inodes, named after the hex representation of their origin lower
inodes.

The index dir is going to be used to prevent breaking lower hardlinks
on copy up and to implement overlayfs NFS export.

Because the feature is not fully backward compat, enabling the feature
is opt-in by config/module/mount option.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/Kconfig     | 20 ++++++++++++++++++
 fs/overlayfs/copy_up.c   | 10 ++++-----
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/ovl_entry.h |  3 +++
 fs/overlayfs/super.c     | 54 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/util.c      | 15 ++++++++++++++
 6 files changed, 97 insertions(+), 7 deletions(-)

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
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 7a44533f4bbf..d3047fdc0377 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -233,12 +233,13 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
-static struct ovl_fh *ovl_encode_fh(struct dentry *lower, uuid_be *uuid)
+static struct ovl_fh *ovl_encode_fh(struct dentry *lower)
 {
 	struct ovl_fh *fh;
 	int fh_type, fh_len, dwords;
 	void *buf;
 	int buflen = MAX_HANDLE_SZ;
+	uuid_be *uuid = (uuid_be *) &lower->d_sb->s_uuid;
 
 	buf = kmalloc(buflen, GFP_TEMPORARY);
 	if (!buf)
@@ -283,8 +284,6 @@ static struct ovl_fh *ovl_encode_fh(struct dentry *lower, uuid_be *uuid)
 static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 			  struct dentry *upper)
 {
-	struct super_block *sb = lower->d_sb;
-	uuid_be *uuid = (uuid_be *) &sb->s_uuid;
 	const struct ovl_fh *fh = NULL;
 	int err;
 
@@ -293,9 +292,8 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	 * so we can use the overlay.origin xattr to distignuish between a copy
 	 * up and a pure upper inode.
 	 */
-	if (sb->s_export_op && sb->s_export_op->fh_to_dentry &&
-	    uuid_be_cmp(*uuid, NULL_UUID_BE)) {
-		fh = ovl_encode_fh(lower, uuid);
+	if (ovl_can_decode_fh(lower->d_sb)) {
+		fh = ovl_encode_fh(lower);
 		if (IS_ERR(fh))
 			return PTR_ERR(fh);
 	}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 513e25e56eed..9ec93063c3a8 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -191,6 +191,8 @@ void ovl_drop_write(struct dentry *dentry);
 struct dentry *ovl_workdir(struct dentry *dentry);
 const struct cred *ovl_override_creds(struct super_block *sb);
 struct super_block *ovl_same_sb(struct super_block *sb);
+bool ovl_can_decode_fh(struct super_block *sb);
+struct dentry *ovl_indexdir(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
 bool ovl_dentry_weird(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b0e7ee2ae398..ddd4b0a874a9 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -14,6 +14,7 @@ struct ovl_config {
 	char *workdir;
 	bool default_permissions;
 	bool redirect_dir;
+	bool index;
 };
 
 /* private information held for overlayfs's superblock */
@@ -25,6 +26,8 @@ struct ovl_fs {
 	struct dentry *workbasedir;
 	/* workdir is the 'work' directory under workbasedir */
 	struct dentry *workdir;
+	/* index directory listing overlay inodes by origin file handle */
+	struct dentry *indexdir;
 	long namelen;
 	/* pathnames of lower and upper dirs, for show_options */
 	struct ovl_config config;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 5114627799e9..02edc5ab1df3 100644
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
 	return 0;
 }
 
@@ -294,6 +303,8 @@ enum {
 	OPT_DEFAULT_PERMISSIONS,
 	OPT_REDIRECT_DIR_ON,
 	OPT_REDIRECT_DIR_OFF,
+	OPT_INDEX_ON,
+	OPT_INDEX_OFF,
 	OPT_ERR,
 };
 
@@ -304,6 +315,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
 	{OPT_REDIRECT_DIR_ON,		"redirect_dir=on"},
 	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
+	{OPT_INDEX_ON,			"index=on"},
+	{OPT_INDEX_OFF,			"index=off"},
 	{OPT_ERR,			NULL}
 };
 
@@ -376,6 +389,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
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
 		default:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
@@ -394,6 +415,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 }
 
 #define OVL_WORKDIR_NAME "work"
+#define OVL_INDEXDIR_NAME "index"
 
 static struct dentry *ovl_workdir_create(struct super_block *sb,
 					 struct ovl_fs *ufs,
@@ -785,6 +807,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	init_waitqueue_head(&ufs->copyup_wq);
 	ufs->config.redirect_dir = ovl_redirect_dir_def;
+	ufs->config.index = ovl_index_def;
 	err = ovl_parse_opt((char *) data, &ufs->config);
 	if (err)
 		goto out_free_config;
@@ -947,6 +970,13 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			} else {
 				vfs_removexattr(ufs->workdir, OVL_XATTR_OPAQUE);
 			}
+
+			/* Check if upper/work fs supports file handles */
+			if (ufs->config.index &&
+			    !ovl_can_decode_fh(ufs->workdir->d_sb)) {
+				ufs->config.index = false;
+				pr_warn("overlayfs: upper fs does not support NFS export.\n");
+			}
 		}
 	}
 
@@ -976,6 +1006,15 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			ufs->same_sb = mnt->mnt_sb;
 		else if (ufs->same_sb != mnt->mnt_sb)
 			ufs->same_sb = NULL;
+
+		/*
+		 * The inodes index feature needs to encode and decode file
+		 * handles, so it requires that all layers support NFS export.
+		 */
+		if (ufs->config.index && !ovl_can_decode_fh(mnt->mnt_sb)) {
+			ufs->config.index = false;
+			pr_warn("overlayfs: lower fs does not support NFS export.\n");
+		}
 	}
 
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
@@ -984,6 +1023,17 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
 		ufs->same_sb = NULL;
 
+	if (!(sb->s_flags & MS_RDONLY) && ufs->config.index) {
+		ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
+						   OVL_INDEXDIR_NAME, true);
+		err = PTR_ERR(ufs->indexdir);
+		if (IS_ERR(ufs->indexdir))
+			goto out_put_lower_mnt;
+
+		if (!ufs->indexdir)
+			pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
+	}
+
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
 	else
@@ -991,7 +1041,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	ufs->creator_cred = cred = prepare_creds();
 	if (!cred)
-		goto out_put_lower_mnt;
+		goto out_put_indexdir;
 
 	/* Never override disk quota limits or use reserved space */
 	cap_lower(cred->cap_effective, CAP_SYS_RESOURCE);
@@ -1041,6 +1091,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	kfree(oe);
 out_put_cred:
 	put_cred(ufs->creator_cred);
+out_put_indexdir:
+	dput(ufs->indexdir);
 out_put_lower_mnt:
 	for (i = 0; i < ufs->numlower; i++)
 		mntput(ufs->lower_mnt[i]);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 809048913889..8e2f308056f1 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -12,6 +12,8 @@
 #include <linux/slab.h>
 #include <linux/cred.h>
 #include <linux/xattr.h>
+#include <linux/exportfs.h>
+#include <linux/uuid.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -47,6 +49,19 @@ struct super_block *ovl_same_sb(struct super_block *sb)
 	return ofs->same_sb;
 }
 
+bool ovl_can_decode_fh(struct super_block *sb)
+{
+	return (sb->s_export_op && sb->s_export_op->fh_to_dentry &&
+		uuid_be_cmp(*(uuid_be *) &sb->s_uuid, NULL_UUID_BE));
+}
+
+struct dentry *ovl_indexdir(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->indexdir;
+}
+
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 {
 	size_t size = offsetof(struct ovl_entry, lowerstack[numlower]);
-- 
2.7.4
