From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6/7] ovl: add support for verify_dir mount option
Date: Tue, 17 Oct 2017 18:23:52 +0300
Message-ID: <1508253833-9866-7-git-send-email-amir73il@gmail.com>
References: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:54228 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936322AbdJQPX2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:23:28 -0400
Received: by mail-wm0-f65.google.com with SMTP id q132so4701440wmd.2
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:23:27 -0700 (PDT)
In-Reply-To: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When overlayfs is mounted with option 'verify_dir', a directory inode
found in lower layer by name or by redirect_dir is verified against the
file handle of the copy up origin that is stored in the upper layer.
If origin xattr does not exist, update it with the lower found by name.

This option introduces a change of behavior for the case of lower layer
modification while overlay is offline. A lower directory created or
moved offline under an exisitng upper directory, will not be merged with
that upper directory when the overlay in mounted with 'verify_dir'.

The 'verify_dir' option should not be used after copying layers,
because the new lower directory inodes would fail verification.

This is going to be used for overlayfs snapshots and NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt | 16 +++++++++++++
 fs/overlayfs/namei.c                    | 12 ++++++++++
 fs/overlayfs/overlayfs.h                |  1 +
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 42 ++++++++++++++++++++++-----------
 fs/overlayfs/util.c                     |  7 ++++++
 6 files changed, 65 insertions(+), 14 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 8caa60734647..17a3c9196fd3 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -265,6 +265,22 @@ filesystem are not allowed.  If the underlying filesystem is changed,
 the behavior of the overlay is undefined, though it will not result in
 a crash or deadlock.
 
+When the underlying filesystems supports NFS export, overlay mount can be
+made more resilient to offline and online changes of the underlying lower
+layer by enabling the "verify_dir" feature.
+
+On every copy_up, an NFS file handle of the lower inode, along with the
+UUID of the lower filesystem, are encoded and stored in an extended
+attribute "trusted.overlay.origin" on the upper inode.
+
+With the "verify_dir" feature, a lookup of a merged directory, that
+found a lower directory at the lookup path or at the path pointed to by
+the "trusted.overlay.redirect" extended attribute, will verify that the
+found lower directory file handle and lower filesystem UUID match the
+origin file handle that was stored at copy_up time.  If a found lower
+directory does not match the stored origin, that directory will be not be
+merged with the upper directory.
+
 Testsuite
 ---------
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index e39d0df10099..988cb5496474 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -666,6 +666,18 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (!this)
 			continue;
 
+		/*
+		 * Verify that uppermost lower matches the copy up origin fh.
+		 * If no origin fh is stored in upper, store fh of lower dir.
+		 */
+		if (this && upperdentry && !ctr) {
+			err = ovl_verify_origin(upperdentry, this, false, true);
+			if (err && ovl_verify_dir(dentry->d_sb)) {
+				dput(this);
+				break;
+			}
+		}
+
 		stack[ctr].dentry = this;
 		stack[ctr].mnt = lowerpath.mnt;
 		ctr++;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 29f9a24eaa50..ba455642152f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -212,6 +212,7 @@ void ovl_dentry_set_opaque(struct dentry *dentry);
 bool ovl_dentry_has_upper_alias(struct dentry *dentry);
 void ovl_dentry_set_upper_alias(struct dentry *dentry);
 bool ovl_redirect_dir(struct super_block *sb);
+bool ovl_verify_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 25d9b5adcd42..4c3d5ff1a30c 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -14,6 +14,7 @@ struct ovl_config {
 	char *workdir;
 	bool default_permissions;
 	bool redirect_dir;
+	bool verify_dir;
 	bool index;
 };
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f4c81767523f..aa230efc1afe 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -303,6 +303,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ufs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s",
 			   ufs->config.index ? "on" : "off");
+	if (ufs->config.verify_dir)
+		seq_puts(m, ",verify_dir");
 	return 0;
 }
 
@@ -336,6 +338,7 @@ enum {
 	OPT_REDIRECT_DIR_OFF,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
+	OPT_VERIFY_DIR,
 	OPT_ERR,
 };
 
@@ -348,6 +351,7 @@ static const match_table_t ovl_tokens = {
 	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
+	{OPT_VERIFY_DIR,		"verify_dir"},
 	{OPT_ERR,			NULL}
 };
 
@@ -428,6 +432,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->index = false;
 			break;
 
+		case OPT_VERIFY_DIR:
+			config->verify_dir = true;
+			break;
+
 		default:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
@@ -443,10 +451,11 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->workdir = NULL;
 		}
 		if (config->redirect_dir != ovl_redirect_dir_def ||
-		    config->index != ovl_index_def) {
-			pr_info("overlayfs: options \"redirect_dir\" and \"index\" are useless in a non-upper mount, ignore\n");
+		    config->index != ovl_index_def || config->verify_dir) {
+			pr_info("overlayfs: options \"redirect_dir\", \"verify_dir\" and \"index\" are useless in a non-upper mount, ignore\n");
 			config->redirect_dir = ovl_redirect_dir_def;
 			config->index = ovl_index_def;
+			config->verify_dir = false;
 		}
 	}
 
@@ -649,14 +658,16 @@ static int ovl_lower_dir(const char *name, struct path *path,
 		*remote = true;
 
 	/*
-	 * The inodes index feature needs to encode and decode lower file
+	 * The features index and verify_dir need to decode lower file
 	 * handles stored in upper inodes, so it requires that all lower
 	 * layers support file handles.
 	 */
 	if (ofs->config.upperdir && !ovl_can_decode_fh(path->dentry->d_sb) &&
-	    ofs->config.index) {
+	    (ofs->config.index || ofs->config.verify_dir)) {
 		ofs->config.index = false;
-		pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
+		ofs->config.verify_dir = false;
+		pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off and no verify_dir.\n",
+			name);
 	}
 
 	return 0;
@@ -1021,7 +1032,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 				ufs->noxattr = true;
 				ufs->config.redirect_dir = false;
 				ufs->config.index = false;
-				pr_warn("overlayfs: upper fs does not support xattr, falling back to redirect_dir=off, index=off and no opaque dir.\n");
+				ufs->config.verify_dir = false;
+				pr_warn("overlayfs: upper fs does not support xattr, falling back to redirect_dir=off, index=off, no verify_dir and no opaque dir.\n");
 			} else {
 				vfs_removexattr(ufs->workdir, OVL_XATTR_OPAQUE);
 			}
@@ -1070,14 +1082,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		ufs->same_sb = NULL;
 
 	if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
-		/* Verify lower root is upper root origin */
-		err = ovl_verify_origin(upperpath.dentry, stack[0].dentry,
-					false, true);
-		if (err) {
-			pr_err("overlayfs: failed to verify upper root origin\n");
-			goto out_put_lower_mnt;
-		}
-
 		ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
 						   OVL_INDEXDIR_NAME, true);
 		if (ufs->indexdir) {
@@ -1103,6 +1107,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ufs->indexdir)
 		ufs->config.index = false;
 
+	if (ufs->config.verify_dir || ufs->indexdir) {
+		/* Verify lower root is upper root origin */
+		err = ovl_verify_origin(upperpath.dentry, stack[0].dentry,
+					false, true);
+		if (err) {
+			pr_err("overlayfs: failed to verify upper root origin\n");
+			goto out_put_indexdir;
+		}
+	}
+
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
 	else
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 51ca8bd16009..7355c51ae05f 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -234,6 +234,13 @@ bool ovl_redirect_dir(struct super_block *sb)
 	return ofs->config.redirect_dir && !ofs->noxattr;
 }
 
+bool ovl_verify_dir(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->config.verify_dir && !ofs->noxattr;
+}
+
 const char *ovl_dentry_get_redirect(struct dentry *dentry)
 {
 	return OVL_I(d_inode(dentry))->redirect;
-- 
2.7.4
