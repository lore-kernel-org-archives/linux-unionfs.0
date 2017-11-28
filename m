From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v8 09/15] ovl: Add helper ovl_already_copied_up()
Date: Tue, 28 Nov 2017 10:59:53 -0500
Message-ID: <20171128155959.20114-10-vgoyal@redhat.com>
References: <20171128155959.20114-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51958 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753923AbdK1QAL (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:00:11 -0500
In-Reply-To: <20171128155959.20114-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

There are couple of places where we need to know if file is already copied
up (in lockless manner). Right now its open coded and there are only
two conditions to check. Soon this patch series will introduce another
condition to check and Amir wants to introduce one more. So introduce
a helper instead to check this so that code is easier to read.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 19 ++-----------------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 24 +++++++++++++++++++++++-
 3 files changed, 26 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index c5804b87f3c7..65e993e931ba 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -671,21 +671,7 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 		struct dentry *next;
 		struct dentry *parent;
 
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
-		    ovl_dentry_has_upper_alias(dentry))
+		if (ovl_already_copied_up(dentry))
 			break;
 
 		next = dget(dentry);
@@ -712,8 +698,7 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 
 static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
 {
-	if (ovl_dentry_upper(dentry) &&
-	    ovl_dentry_has_upper_alias(dentry))
+	if (ovl_already_copied_up(dentry))
 		return false;
 
 	if (special_file(d_inode(dentry)->i_mode))
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 1ca946ec57c9..6eb1769541e9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -227,6 +227,7 @@ bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry);
 void ovl_copy_up_end(struct dentry *dentry);
+bool ovl_already_copied_up(struct dentry *dentry);
 bool ovl_check_origin_xattr(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 77dc00438d54..572bf46e9f2e 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -314,13 +314,35 @@ struct file *ovl_path_open(struct path *path, int flags)
 	return dentry_open(path, flags | O_NOATIME, current_cred());
 }
 
+bool ovl_already_copied_up(struct dentry *dentry)
+{
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
+	    ovl_dentry_has_upper_alias(dentry))
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
