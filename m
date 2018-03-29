Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33136 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751256AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 08/28] ovl: Add helper ovl_already_copied_up()
Date: Thu, 29 Mar 2018 15:38:34 -0400
Message-Id: <20180329193854.13814-9-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

There are couple of places where we need to know if file is already copied
up (in lockless manner). Right now its open coded and there are only
two conditions to check. Soon this patch series will introduce another
condition to check and Amir wants to introduce one more. So introduce
a helper instead to check this so that code is easier to read.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 20 ++------------------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 26 +++++++++++++++++++++++++-
 3 files changed, 28 insertions(+), 19 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 45e396a0fd6a..8d9af7fdc8a4 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -810,21 +810,7 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 		struct dentry *next;
 		struct dentry *parent = NULL;
 
-		/*
-		 * Check if copy-up has happened as well as for upper alias (in
-		 * case of hard links) is there.
-		 *
-		 * Both checks are lockless:
-		 *  - false negatives: will recheck under oi->lock
-		 *  - false positives:
-		 *    + ovl_dentry_upper() uses memory barriers to ensure the
-		 *      upper dentry is up-to-date
-		 *    + ovl_dentry_has_upper_alias() relies on locking of
-		 *      upper parent i_rwsem to prevent reordering copy-up
-		 *      with rename.
-		 */
-		if (ovl_dentry_upper(dentry) &&
-		    (ovl_dentry_has_upper_alias(dentry) || disconnected))
+		if (ovl_already_copied_up(dentry))
 			break;
 
 		next = dget(dentry);
@@ -852,9 +838,7 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
 {
 	/* Copy up of disconnected dentry does not set upper alias */
-	if (ovl_dentry_upper(dentry) &&
-	    (ovl_dentry_has_upper_alias(dentry) ||
-	     (dentry->d_flags & DCACHE_DISCONNECTED)))
+	if (ovl_already_copied_up(dentry))
 		return false;
 
 	if (special_file(d_inode(dentry)->i_mode))
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7c57820524f4..c7c9d717d546 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -242,6 +242,7 @@ bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry);
 void ovl_copy_up_end(struct dentry *dentry);
+bool ovl_already_copied_up(struct dentry *dentry);
 bool ovl_check_origin_xattr(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 930784a26623..4e537eeb594e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -339,13 +339,37 @@ struct file *ovl_path_open(struct path *path, int flags)
 	return dentry_open(path, flags | O_NOATIME, current_cred());
 }
 
+bool ovl_already_copied_up(struct dentry *dentry)
+{
+	bool disconnected = dentry->d_flags & DCACHE_DISCONNECTED;
+
+	/*
+	 * Check if copy-up has happened as well as for upper alias (in
+	 * case of hard links) is there.
+	 *
+	 * Both checks are lockless:
+	 *  - false negatives: will recheck under oi->lock
+	 *  - false positives:
+	 *    + ovl_dentry_upper() uses memory barriers to ensure the
+	 *      upper dentry is up-to-date
+	 *    + ovl_dentry_has_upper_alias() relies on locking of
+	 *      upper parent i_rwsem to prevent reordering copy-up
+	 *      with rename.
+	 */
+	if (ovl_dentry_upper(dentry) &&
+	    (ovl_dentry_has_upper_alias(dentry) || disconnected))
+		return true;
+
+	return false;
+}
+
 int ovl_copy_up_start(struct dentry *dentry)
 {
 	struct ovl_inode *oi = OVL_I(d_inode(dentry));
 	int err;
 
 	err = mutex_lock_interruptible(&oi->lock);
-	if (!err && ovl_dentry_has_upper_alias(dentry)) {
+	if (!err && ovl_already_copied_up(dentry)) {
 		err = 1; /* Already copied up */
 		mutex_unlock(&oi->lock);
 	}
-- 
2.13.6

