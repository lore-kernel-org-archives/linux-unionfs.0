From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 5/5] ovl: fix missing unlock_rename() in ovl_do_copy_up()
Date: Mon, 25 Sep 2017 17:02:36 +0300
Message-ID: <1506348156-19270-1-git-send-email-amir73il@gmail.com>
References: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36621 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933471AbdIYOCI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2017 10:02:08 -0400
In-Reply-To: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 13" <stable@vger.kernel.org>

Use the ovl_lock_rename_workdir() helper which requires
unlock_rename() only on lock success.

Fixes: ("fd210b7d67ee ovl: move copy up lock out")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  6 ++----
 fs/overlayfs/dir.c       | 20 --------------------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 19 +++++++++++++++++++
 4 files changed, 22 insertions(+), 24 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index aad97b30d5e6..c441f9387a1b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -561,10 +561,8 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		c->tmpfile = true;
 		err = ovl_copy_up_locked(c);
 	} else {
-		err = -EIO;
-		if (lock_rename(c->workdir, c->destdir) != NULL) {
-			pr_err("overlayfs: failed to lock workdir+upperdir\n");
-		} else {
+		err = ovl_lock_rename_workdir(c->workdir, c->destdir);
+		if (!err) {
 			err = ovl_copy_up_locked(c);
 			unlock_rename(c->workdir, c->destdir);
 		}
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 3309b1912241..cc961a3bd3bd 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -216,26 +216,6 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	return err;
 }
 
-static int ovl_lock_rename_workdir(struct dentry *workdir,
-				   struct dentry *upperdir)
-{
-	/* Workdir should not be the same as upperdir */
-	if (workdir == upperdir)
-		goto err;
-
-	/* Workdir should not be subdir of upperdir and vice versa */
-	if (lock_rename(workdir, upperdir) != NULL)
-		goto err_unlock;
-
-	return 0;
-
-err_unlock:
-	unlock_rename(workdir, upperdir);
-err:
-	pr_err("overlayfs: failed to lock workdir+upperdir\n");
-	return -EIO;
-}
-
 static struct dentry *ovl_clear_empty(struct dentry *dentry,
 				      struct list_head *list)
 {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d4e8c1a08fb0..c706a6f99928 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -235,6 +235,7 @@ bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
+int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index a1bf81d352b4..904c60b4e759 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -560,3 +560,22 @@ void ovl_nlink_end(struct dentry *dentry, bool locked)
 		mutex_unlock(&OVL_I(d_inode(dentry))->lock);
 	}
 }
+
+int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
+{
+	/* Workdir should not be the same as upperdir */
+	if (workdir == upperdir)
+		goto err;
+
+	/* Workdir should not be subdir of upperdir and vice versa */
+	if (lock_rename(workdir, upperdir) != NULL)
+		goto err_unlock;
+
+	return 0;
+
+err_unlock:
+	unlock_rename(workdir, upperdir);
+err:
+	pr_err("overlayfs: failed to lock workdir+upperdir\n");
+	return -EIO;
+}
-- 
2.7.4
