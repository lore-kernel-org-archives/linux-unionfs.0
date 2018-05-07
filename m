Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:45956 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752253AbeEGRlM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 7 May 2018 13:41:12 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 07/30] ovl: Add helper ovl_already_copied_up()
Date: Mon,  7 May 2018 13:40:39 -0400
Message-Id: <20180507174102.24086-8-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
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
index 38b332d7c7e4..6ac3220b0834 100644
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
index 396d9ecca919..d8c182f9ec4f 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -244,6 +244,7 @@ bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry);
 void ovl_copy_up_end(struct dentry *dentry);
+bool ovl_already_copied_up(struct dentry *dentry);
 bool ovl_check_origin_xattr(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 25d202b47326..43235294e77b 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -377,13 +377,37 @@ struct file *ovl_path_open(struct path *path, int flags)
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

