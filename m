From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 22/23] ovl: move copy up helpers to copy_up.c
Date: Thu,  8 Jun 2017 18:00:48 +0300
Message-ID: <1496934049-11216-2-git-send-email-amir73il@gmail.com>
References: <CAOQ4uxjptLTC_qX5RpcCAwQyyRCq+Y7RHuXThCN32oChZL50Kg@mail.gmail.com>
 <1496934049-11216-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:33049 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFHPAk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 8 Jun 2017 11:00:40 -0400
In-Reply-To: <1496934049-11216-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 65 +++++++++++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/inode.c     | 33 ------------------------
 fs/overlayfs/overlayfs.h |  5 +---
 fs/overlayfs/util.c      | 30 ----------------------
 4 files changed, 65 insertions(+), 68 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f8acf9c8b345..8a297cfc33fb 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -353,6 +353,36 @@ static int ovl_copy_up_inode(struct dentry *dentry, struct dentry *temp,
 	return err;
 }
 
+static int ovl_copy_up_start(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct ovl_entry *oe = dentry->d_fsdata;
+	int err;
+
+	spin_lock(&ofs->copyup_wq.lock);
+	err = wait_event_interruptible_locked(ofs->copyup_wq, !oe->copying);
+	if (!err) {
+		if (oe->__upperdentry)
+			err = 1; /* Already copied up */
+		else
+			oe->copying = true;
+	}
+	spin_unlock(&ofs->copyup_wq.lock);
+
+	return err;
+}
+
+static void ovl_copy_up_end(struct dentry *dentry)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	spin_lock(&ofs->copyup_wq.lock);
+	oe->copying = false;
+	wake_up_locked(&ofs->copyup_wq);
+	spin_unlock(&ofs->copyup_wq.lock);
+}
+
 /*
  * Context and operations for copying up a single lower file.
  */
@@ -911,7 +941,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	return err;
 }
 
-int ovl_copy_up_flags(struct dentry *dentry, int flags)
+static int ovl_copy_up_flags(struct dentry *dentry, int flags)
 {
 	int err = 0;
 	const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
@@ -960,3 +990,36 @@ int ovl_copy_up(struct dentry *dentry)
 {
 	return ovl_copy_up_flags(dentry, 0);
 }
+
+static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
+				  struct dentry *realdentry)
+{
+	if (OVL_TYPE_UPPER(type))
+		return false;
+
+	if (special_file(realdentry->d_inode->i_mode))
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
+	struct path realpath;
+	enum ovl_path_type type;
+
+	type = ovl_path_real(dentry, &realpath);
+	if (ovl_open_need_copy_up(file_flags, type, realpath.dentry)) {
+		err = ovl_want_write(dentry);
+		if (!err) {
+			err = ovl_copy_up_flags(dentry, file_flags);
+			ovl_drop_write(dentry);
+		}
+	}
+
+	return err;
+}
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 8a30dc6cd42d..db2a63bd8bb9 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -312,39 +312,6 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
-static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
-				  struct dentry *realdentry)
-{
-	if (OVL_TYPE_UPPER(type))
-		return false;
-
-	if (special_file(realdentry->d_inode->i_mode))
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
-	struct path realpath;
-	enum ovl_path_type type;
-
-	type = ovl_path_real(dentry, &realpath);
-	if (ovl_open_need_copy_up(file_flags, type, realpath.dentry)) {
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
index beac2d858689..434870f5bb4b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -210,8 +210,6 @@ void ovl_dentry_version_inc(struct dentry *dentry);
 u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
-int ovl_copy_up_start(struct dentry *dentry);
-void ovl_copy_up_end(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       const char *name, const void *value, size_t size,
@@ -251,7 +249,6 @@ int ovl_xattr_get(struct dentry *dentry, const char *name,
 		  void *value, size_t size);
 ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size);
 struct posix_acl *ovl_get_acl(struct inode *inode, int type);
-int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
@@ -307,7 +304,7 @@ void ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
-int ovl_copy_up_flags(struct dentry *dentry, int flags);
+int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
 struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index a28bf55a0d48..fa6c2ae4a747 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -285,36 +285,6 @@ struct file *ovl_path_open(struct path *path, int flags)
 	return dentry_open(path, flags | O_NOATIME, current_cred());
 }
 
-int ovl_copy_up_start(struct dentry *dentry)
-{
-	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
-	struct ovl_entry *oe = dentry->d_fsdata;
-	int err;
-
-	spin_lock(&ofs->copyup_wq.lock);
-	err = wait_event_interruptible_locked(ofs->copyup_wq, !oe->copying);
-	if (!err) {
-		if (oe->__upperdentry)
-			err = 1; /* Already copied up */
-		else
-			oe->copying = true;
-	}
-	spin_unlock(&ofs->copyup_wq.lock);
-
-	return err;
-}
-
-void ovl_copy_up_end(struct dentry *dentry)
-{
-	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
-	struct ovl_entry *oe = dentry->d_fsdata;
-
-	spin_lock(&ofs->copyup_wq.lock);
-	oe->copying = false;
-	wake_up_locked(&ofs->copyup_wq);
-	spin_unlock(&ofs->copyup_wq.lock);
-}
-
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name)
 {
 	int res;
-- 
2.7.4
