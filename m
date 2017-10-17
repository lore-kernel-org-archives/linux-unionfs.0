From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 03/11] ovl: create ovl_need_index() helper
Date: Tue, 17 Oct 2017 19:00:14 +0300
Message-ID: <1508256022-10267-4-git-send-email-amir73il@gmail.com>
References: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:53142 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936666AbdJQP7x (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:59:53 -0400
Received: by mail-wm0-f67.google.com with SMTP id k4so4941973wmc.1
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:59:53 -0700 (PDT)
In-Reply-To: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

The helper determines which lower file needs to be indexed
on copy up and before nlink changes.

For index=on, the helper evaluates to true for lower hardlinks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  6 +-----
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 25 +++++++++++++++++++++----
 3 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index c441f9387a1b..6729ea2a5a1c 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -532,11 +532,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
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
index df605368700d..17457483ccf6 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -235,6 +235,7 @@ void ovl_clear_flag(unsigned long flag, struct inode *inode);
 bool ovl_test_flag(unsigned long flag, struct inode *inode);
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
+bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7355c51ae05f..6b3af32ab0e9 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -506,6 +506,24 @@ static void ovl_cleanup_index(struct dentry *dentry)
 }
 
 /*
+ * Does this overlay dentry need to be indexed on copy up?
+ */
+bool ovl_need_index(struct dentry *dentry)
+{
+	struct dentry *lower = ovl_dentry_lower(dentry);
+
+	if (!lower)
+		return false;
+
+	/* Index only lower hardlinks on copy up */
+	if (ovl_indexdir(dentry->d_sb) &&
+	    !d_is_dir(lower) && d_inode(lower)->i_nlink > 1)
+		return true;
+
+	return false;
+}
+
+/*
  * Operations that change overlay inode and upper inode nlink need to be
  * synchronized with copy up for persistent nlink accounting.
  */
@@ -520,11 +538,11 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 
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
@@ -532,8 +550,7 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
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
