From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 13/23] ovl: create ovl_need_index() helper
Date: Thu,  4 Jan 2018 18:40:08 +0200
Message-ID: <1515084018-25134-14-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:42872 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753512AbeADQjn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:43 -0500
Received: by mail-wr0-f196.google.com with SMTP id w107so2009139wrb.9
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:43 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

The helper determines which lower file needs to be indexed
on copy up and before nlink changes.

For index=on, the helper evaluates to true for lower hardlinks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  6 +-----
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 24 ++++++++++++++++++++----
 3 files changed, 22 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 206ececd5ae7..27856663c8c7 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -536,11 +536,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 {
 	int err;
 	struct ovl_fs *ofs = c->dentry->d_sb->s_fs_info;
-	bool indexed = false;
-
-	if (ovl_indexdir(c->dentry->d_sb) && !S_ISDIR(c->stat.mode) &&
-	    c->stat.nlink > 1)
-		indexed = true;
+	bool indexed = ovl_need_index(c->dentry);
 
 	if (S_ISDIR(c->stat.mode) || c->stat.nlink == 1 || indexed)
 		c->origin = true;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 46f9f097e822..86767b71e485 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -243,6 +243,7 @@ void ovl_clear_flag(unsigned long flag, struct inode *inode);
 bool ovl_test_flag(unsigned long flag, struct inode *inode);
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
+bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 42809eae0992..0254d7f0d401 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -481,6 +481,23 @@ void ovl_inuse_unlock(struct dentry *dentry)
 	}
 }
 
+/*
+ * Does this overlay dentry need to be indexed on copy up?
+ */
+bool ovl_need_index(struct dentry *dentry)
+{
+	struct dentry *lower = ovl_dentry_lower(dentry);
+
+	if (!lower || !ovl_indexdir(dentry->d_sb))
+		return false;
+
+	/* Index only lower hardlinks on copy up */
+	if (!d_is_dir(lower) && d_inode(lower)->i_nlink > 1)
+		return true;
+
+	return false;
+}
+
 /* Caller must hold OVL_I(inode)->lock */
 static void ovl_cleanup_index(struct dentry *dentry)
 {
@@ -551,11 +568,11 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 
 	/*
 	 * With inodes index is enabled, we store the union overlay nlink
-	 * in an xattr on the index inode. When whiting out lower hardlinks
+	 * in an xattr on the index inode. When whiting out an indexed lower,
 	 * we need to decrement the overlay persistent nlink, but before the
 	 * first copy up, we have no upper index inode to store the xattr.
 	 *
-	 * As a workaround, before whiteout/rename over of a lower hardlink,
+	 * As a workaround, before whiteout/rename over an indexed lower,
 	 * copy up to create the upper index. Creating the upper index will
 	 * initialize the overlay nlink, so it could be dropped if unlink
 	 * or rename succeeds.
@@ -563,8 +580,7 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 	 * TODO: implement metadata only index copy up when called with
 	 *       ovl_copy_up_flags(dentry, O_PATH).
 	 */
-	if (ovl_indexdir(dentry->d_sb) && !ovl_dentry_has_upper_alias(dentry) &&
-	    d_inode(ovl_dentry_lower(dentry))->i_nlink > 1) {
+	if (ovl_need_index(dentry) && !ovl_dentry_has_upper_alias(dentry)) {
 		err = ovl_copy_up(dentry);
 		if (err)
 			return err;
-- 
2.7.4
