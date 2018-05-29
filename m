From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 02/28] ovl: Move the copy up helpers to copy_up.c
Date: Tue, 29 May 2018 16:45:46 +0200
Message-ID: <20180529144612.16675-3-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Right now two copy up helpers are in inode.c.  Amir suggested it might be
better to move these to copy_up.c.

There will one more related function which will come in later patch.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c   | 32 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c     | 32 --------------------------------
 fs/overlayfs/overlayfs.h |  2 +-
 3 files changed, 33 insertions(+), 33 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e675e8349e71..91b3b668482b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -779,6 +779,38 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
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
index c365b94fa158..60c88a09a3f3 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -399,38 +399,6 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
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
index 1948e38c3c95..9172d3d5d870 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -332,7 +332,6 @@ int ovl_xattr_get(struct dentry *dentry, struct inode *inode, const char *name,
 		  void *value, size_t size);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
 struct posix_acl *ovl_get_acl(struct inode *inode, int type);
-int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
@@ -391,6 +390,7 @@ extern const struct file_operations ovl_file_operations;
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
+int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_real_fh(struct dentry *real, bool is_upper);
-- 
2.14.3
