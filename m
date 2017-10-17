From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 04/11] ovl: add support for mount option index=all
Date: Tue, 17 Oct 2017 19:00:15 +0300
Message-ID: <1508256022-10267-5-git-send-email-amir73il@gmail.com>
References: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:46357 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934507AbdJQP7y (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:59:54 -0400
Received: by mail-wm0-f66.google.com with SMTP id m72so4866077wmc.1
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:59:54 -0700 (PDT)
In-Reply-To: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

With mount option index=all, all files are indexed on copy up.

The default boolean module/config var can only be used to configure
indexing of lower hardlinks (true) or to turn off indexing (false).

This is going to be used for overlayfs snapshots and NFS export.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h | 14 ++++++++++++++
 fs/overlayfs/ovl_entry.h |  2 +-
 fs/overlayfs/super.c     | 23 +++++++++++++++--------
 fs/overlayfs/util.c      |  8 ++++++--
 4 files changed, 36 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 17457483ccf6..35f5452e61e0 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -33,6 +33,20 @@ enum ovl_flag {
 };
 
 /*
+ * Which files should be indexed on copy up.
+ * The default is casted from the boolean module config var, which can
+ * only be used to configure indexing of lower hardlinks or to turn off
+ * indexing. Other values can only be configures via mount option
+ * (e.g. index=all).
+ */
+enum ovl_index {
+	OVL_INDEX_OFF = (int)false,
+	OVL_INDEX_ON = (int)true,
+	OVL_INDEX_NLINK = OVL_INDEX_ON,
+	OVL_INDEX_ALL,
+};
+
+/*
  * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
  * where:
  * origin.fh	- exported file handle of the lower file
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 4c3d5ff1a30c..45dc8077d959 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -15,7 +15,7 @@ struct ovl_config {
 	bool default_permissions;
 	bool redirect_dir;
 	bool verify_dir;
-	bool index;
+	int index;
 };
 
 /* private information held for overlayfs's superblock */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index aa230efc1afe..24fac7d987a3 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -302,7 +302,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 			   ufs->config.redirect_dir ? "on" : "off");
 	if (ufs->config.index != ovl_index_def)
 		seq_printf(m, ",index=%s",
-			   ufs->config.index ? "on" : "off");
+			   ufs->config.index == OVL_INDEX_ALL ? "all" :
+			   (ufs->config.index ? "on" : "off"));
 	if (ufs->config.verify_dir)
 		seq_puts(m, ",verify_dir");
 	return 0;
@@ -338,6 +339,7 @@ enum {
 	OPT_REDIRECT_DIR_OFF,
 	OPT_INDEX_ON,
 	OPT_INDEX_OFF,
+	OPT_INDEX_ALL,
 	OPT_VERIFY_DIR,
 	OPT_ERR,
 };
@@ -351,6 +353,7 @@ static const match_table_t ovl_tokens = {
 	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
 	{OPT_INDEX_ON,			"index=on"},
 	{OPT_INDEX_OFF,			"index=off"},
+	{OPT_INDEX_ALL,			"index=all"},
 	{OPT_VERIFY_DIR,		"verify_dir"},
 	{OPT_ERR,			NULL}
 };
@@ -425,11 +428,15 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			break;
 
 		case OPT_INDEX_ON:
-			config->index = true;
+			config->index = OVL_INDEX_NLINK;
 			break;
 
 		case OPT_INDEX_OFF:
-			config->index = false;
+			config->index = 0;
+			break;
+
+		case OPT_INDEX_ALL:
+			config->index = OVL_INDEX_ALL;
 			break;
 
 		case OPT_VERIFY_DIR:
@@ -664,7 +671,7 @@ static int ovl_lower_dir(const char *name, struct path *path,
 	 */
 	if (ofs->config.upperdir && !ovl_can_decode_fh(path->dentry->d_sb) &&
 	    (ofs->config.index || ofs->config.verify_dir)) {
-		ofs->config.index = false;
+		ofs->config.index = 0;
 		ofs->config.verify_dir = false;
 		pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off and no verify_dir.\n",
 			name);
@@ -867,7 +874,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		goto out;
 
 	ufs->config.redirect_dir = ovl_redirect_dir_def;
-	ufs->config.index = ovl_index_def;
+	ufs->config.index = (enum ovl_index) ovl_index_def;
 	err = ovl_parse_opt((char *) data, &ufs->config);
 	if (err)
 		goto out_free_config;
@@ -1031,7 +1038,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			if (err) {
 				ufs->noxattr = true;
 				ufs->config.redirect_dir = false;
-				ufs->config.index = false;
+				ufs->config.index = 0;
 				ufs->config.verify_dir = false;
 				pr_warn("overlayfs: upper fs does not support xattr, falling back to redirect_dir=off, index=off, no verify_dir and no opaque dir.\n");
 			} else {
@@ -1041,7 +1048,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			/* Check if upper/work fs supports file handles */
 			if (ufs->config.index &&
 			    !ovl_can_decode_fh(ufs->workdir->d_sb)) {
-				ufs->config.index = false;
+				ufs->config.index = 0;
 				pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
 			}
 		}
@@ -1105,7 +1112,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 
 	/* Show index=off/on in /proc/mounts for any of the reasons above */
 	if (!ufs->indexdir)
-		ufs->config.index = false;
+		ufs->config.index = 0;
 
 	if (ufs->config.verify_dir || ufs->indexdir) {
 		/* Verify lower root is upper root origin */
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 6b3af32ab0e9..fb501eb5e75c 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -510,13 +510,17 @@ static void ovl_cleanup_index(struct dentry *dentry)
  */
 bool ovl_need_index(struct dentry *dentry)
 {
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct dentry *lower = ovl_dentry_lower(dentry);
 
-	if (!lower)
+	if (!lower || !ofs->indexdir)
 		return false;
 
+	if (!d_is_dir(lower) && ofs->config.index == OVL_INDEX_ALL)
+		return true;
+
 	/* Index only lower hardlinks on copy up */
-	if (ovl_indexdir(dentry->d_sb) &&
+	if ((ofs->config.index == OVL_INDEX_NLINK) &&
 	    !d_is_dir(lower) && d_inode(lower)->i_nlink > 1)
 		return true;
 
-- 
2.7.4
