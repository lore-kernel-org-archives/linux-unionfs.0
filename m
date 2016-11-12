From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 3/4] ovl: fold ovl_copy_up_truncate() into ovl_copy_up()
Date: Sat, 12 Nov 2016 21:36:03 +0200
Message-ID: <1478979364-10355-4-git-send-email-amir73il@gmail.com>
References: <1478979364-10355-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:34046 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966816AbcKLTgm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 12 Nov 2016 14:36:42 -0500
In-Reply-To: <1478979364-10355-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

This removes code duplication and is prep work
for fixing up copy up locking.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 19 ++++++++++++++++---
 fs/overlayfs/inode.c     | 33 +--------------------------------
 fs/overlayfs/overlayfs.h |  3 +--
 3 files changed, 18 insertions(+), 37 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 7e67512..a16127b 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -336,8 +336,8 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
  * d_parent it is possible that the copy up will lock the old parent.  At
  * that point the file will have already been copied up anyway.
  */
-int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
-		    struct path *lowerpath, struct kstat *stat)
+static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
+			   struct path *lowerpath, struct kstat *stat)
 {
 	DEFINE_DELAYED_CALL(done);
 	struct dentry *workdir = ovl_workdir(dentry);
@@ -391,7 +391,7 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	return err;
 }
 
-int ovl_copy_up(struct dentry *dentry)
+static int __ovl_copy_up(struct dentry *dentry, int flags)
 {
 	int err = 0;
 	const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
@@ -419,6 +419,9 @@ int ovl_copy_up(struct dentry *dentry)
 
 		ovl_path_lower(next, &lowerpath);
 		err = vfs_getattr(&lowerpath, &stat);
+		/* maybe truncate regular file. this has no effect on dirs */
+		if (flags & O_TRUNC)
+			stat.size = 0;
 		if (!err)
 			err = ovl_copy_up_one(parent, next, &lowerpath, &stat);
 
@@ -429,3 +432,13 @@ int ovl_copy_up(struct dentry *dentry)
 
 	return err;
 }
+
+int ovl_copy_up(struct dentry *dentry)
+{
+	return __ovl_copy_up(dentry, 0);
+}
+
+int ovl_copy_up_open(struct dentry *dentry, int flags)
+{
+	return __ovl_copy_up(dentry, flags);
+}
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a10e948..7abae00 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -13,34 +13,6 @@
 #include <linux/posix_acl.h>
 #include "overlayfs.h"
 
-static int ovl_copy_up_truncate(struct dentry *dentry)
-{
-	int err;
-	struct dentry *parent;
-	struct kstat stat;
-	struct path lowerpath;
-	const struct cred *old_cred;
-
-	parent = dget_parent(dentry);
-	err = ovl_copy_up(parent);
-	if (err)
-		goto out_dput_parent;
-
-	ovl_path_lower(dentry, &lowerpath);
-
-	old_cred = ovl_override_creds(dentry->d_sb);
-	err = vfs_getattr(&lowerpath, &stat);
-	if (!err) {
-		stat.size = 0;
-		err = ovl_copy_up_one(parent, dentry, &lowerpath, &stat);
-	}
-	revert_creds(old_cred);
-
-out_dput_parent:
-	dput(parent);
-	return err;
-}
-
 int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 {
 	int err;
@@ -281,10 +253,7 @@ int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags)
 	if (ovl_open_need_copy_up(file_flags, type, realpath.dentry)) {
 		err = ovl_want_write(dentry);
 		if (!err) {
-			if (file_flags & O_TRUNC)
-				err = ovl_copy_up_truncate(dentry);
-			else
-				err = ovl_copy_up(dentry);
+			err = ovl_copy_up_open(dentry, file_flags);
 			ovl_drop_write(dentry);
 		}
 	}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 421fd50..1a2f9a5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -215,7 +215,6 @@ void ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
-int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
-		    struct path *lowerpath, struct kstat *stat);
+int ovl_copy_up_open(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
-- 
2.7.4
