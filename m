Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 06/28] ovl: Move the copy up helpers to copy_up.c
Date: Thu, 29 Mar 2018 15:38:32 -0400
Message-Id: <20180329193854.13814-7-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
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
index 2de4ab3254a4..98403b1d40c2 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -826,6 +826,38 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
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
index 2e7ee09c7831..3991a890b464 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -349,38 +349,6 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
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
 	struct dentry *alias;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index a65ce7fd1b6e..7c57820524f4 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -321,7 +321,6 @@ int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 		  void *value, size_t size);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
 struct posix_acl *ovl_get_acl(struct inode *inode, int type);
-int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
@@ -359,6 +358,7 @@ int ovl_cleanup(struct inode *dir, struct dentry *dentry);
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
+int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_fh(struct dentry *real, bool is_upper);
-- 
2.13.6
