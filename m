From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v11 06/18] ovl: Move the copy up helpers to copy_up.c
Date: Wed, 31 Jan 2018 16:13:17 -0500
Message-ID: <20180131211329.16328-7-vgoyal@redhat.com>
References: <20180131211329.16328-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:50284 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752310AbeAaVNn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 16:13:43 -0500
In-Reply-To: <20180131211329.16328-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

Right now two copy up helpers are in inode.c. Amir suggested it might
be better to move these to copy_up.c.

There will one more related function which will come in later patch.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c   | 30 ++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c     | 30 ------------------------------
 fs/overlayfs/overlayfs.h |  2 +-
 3 files changed, 31 insertions(+), 31 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 303794bb9127..31711edf5bde 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -686,6 +686,36 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 	return err;
 }
 
+static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
+{
+	if (ovl_dentry_upper(dentry) &&
+	    ovl_dentry_has_upper_alias(dentry))
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
index 903548a6b825..5239a1ff7211 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -341,36 +341,6 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
-{
-	if (ovl_dentry_upper(dentry) &&
-	    ovl_dentry_has_upper_alias(dentry))
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
 	struct dentry *alias;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index edb23f97bd90..31a212781a15 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -286,7 +286,6 @@ int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 		  void *value, size_t size);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
 struct posix_acl *ovl_get_acl(struct inode *inode, int type);
-int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
@@ -319,6 +318,7 @@ int ovl_cleanup(struct inode *dir, struct dentry *dentry);
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
+int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
-- 
2.13.6
