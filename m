Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:34192 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751496AbeDZTKk (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Apr 2018 15:10:40 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v14 02/31] ovl: Move the copy up helpers to copy_up.c
Date: Thu, 26 Apr 2018 15:09:44 -0400
Message-Id: <20180426191013.13219-3-vgoyal@redhat.com>
In-Reply-To: <20180426191013.13219-1-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Right now two copy up helpers are in inode.c. Amir suggested it might
be better to move these to copy_up.c.

There will one more related function which will come in later patch.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c   | 32 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c     | 32 --------------------------------
 fs/overlayfs/overlayfs.h |  2 +-
 3 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8bede0742619..4afc97872c2d 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -828,6 +828,38 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 	return err;
 }
 
+static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
+{
+	/* Copy up of disconnected dentry does not set upper alias */
+	if (ovl_dentry_upper(dentry) &&
+	    (ovl_dentry_has_upper_alias(dentry) ||
+	     (dentry->d_flags & DCACHE_DISCONNECTED)))
+		return false;
+
+	if (special_file(d_inode(dentry)->i_mode))
+		return false;
+
+	if (!(OPEN_FMODE(flags) & FMODE_WRITE) && !(flags & O_TRUNC))
+		return false;
+
+	return true;
+}
+
+int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
+{
+	int err = 0;
+
+	if (ovl_open_need_copy_up(dentry, file_flags)) {
+		err = ovl_want_write(dentry);
+		if (!err) {
+			err = ovl_copy_up_flags(dentry, file_flags);
+			ovl_drop_write(dentry);
+		}
+	}
+
+	return err;
+}
+
 int ovl_copy_up(struct dentry *dentry)
 {
 	return ovl_copy_up_flags(dentry, 0);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a3b9124f95d6..8a25bb569bdd 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -406,38 +406,6 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
-{
-	/* Copy up of disconnected dentry does not set upper alias */
-	if (ovl_dentry_upper(dentry) &&
-	    (ovl_dentry_has_upper_alias(dentry) ||
-	     (dentry->d_flags & DCACHE_DISCONNECTED)))
-		return false;
-
-	if (special_file(d_inode(dentry)->i_mode))
-		return false;
-
-	if (!(OPEN_FMODE(flags) & FMODE_WRITE) && !(flags & O_TRUNC))
-		return false;
-
-	return true;
-}
-
-int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
-{
-	int err = 0;
-
-	if (ovl_open_need_copy_up(dentry, file_flags)) {
-		err = ovl_want_write(dentry);
-		if (!err) {
-			err = ovl_copy_up_flags(dentry, file_flags);
-			ovl_drop_write(dentry);
-		}
-	}
-
-	return err;
-}
-
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags)
 {
 	if (flags & S_ATIME) {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2b68175f7400..199a39762d1d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -345,7 +345,6 @@ int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 		  void *value, size_t size);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
 struct posix_acl *ovl_get_acl(struct inode *inode, int type);
-int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
@@ -394,6 +393,7 @@ extern const struct file_operations ovl_file_operations;
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
+int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper);
-- 
2.13.6

