From: Antonio Murdaca <amurdaca@redhat.com>
Subject: [PATCH] fs: overlayfs: remove debug parameter
Date: Thu,  7 Apr 2016 12:18:12 +0200
Message-ID: <1460024292-24264-1-git-send-email-runcom@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f41.google.com ([74.125.82.41]:33242 "EHLO
	mail-wm0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250AbcDGKSR (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 7 Apr 2016 06:18:17 -0400
Received: by mail-wm0-f41.google.com with SMTP id f198so18700949wme.0
        for <linux-unionfs@vger.kernel.org>; Thu, 07 Apr 2016 03:18:16 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, miklos@szeredi.hu

pr_debug is handling whether or not to print debug statements so drop
the bool debug parameter.

Signed-off-by: Antonio Murdaca <runcom@redhat.com>
---
 fs/overlayfs/copy_up.c   |  2 +-
 fs/overlayfs/dir.c       | 18 +++++++++---------
 fs/overlayfs/overlayfs.h | 31 +++++++++++--------------------
 fs/overlayfs/super.c     |  2 +-
 4 files changed, 22 insertions(+), 31 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index cc514da..5117647 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -260,7 +260,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 
 	/* Can't properly set mode on creation because of the umask */
 	stat->mode &= S_IFMT;
-	err = ovl_create_real(wdir, newdentry, stat, link, NULL, true);
+	err = ovl_create_real(wdir, newdentry, stat, link, NULL);
 	stat->mode = mode;
 	if (err)
 		goto out2;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index b3fc0a3..91c481c 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -71,7 +71,7 @@ static struct dentry *ovl_whiteout(struct dentry *workdir,
 
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct kstat *stat, const char *link,
-		    struct dentry *hardlink, bool debug)
+		    struct dentry *hardlink)
 {
 	int err;
 
@@ -79,15 +79,15 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		return -ESTALE;
 
 	if (hardlink) {
-		err = ovl_do_link(hardlink, dir, newdentry, debug);
+		err = ovl_do_link(hardlink, dir, newdentry);
 	} else {
 		switch (stat->mode & S_IFMT) {
 		case S_IFREG:
-			err = ovl_do_create(dir, newdentry, stat->mode, debug);
+			err = ovl_do_create(dir, newdentry, stat->mode);
 			break;
 
 		case S_IFDIR:
-			err = ovl_do_mkdir(dir, newdentry, stat->mode, debug);
+			err = ovl_do_mkdir(dir, newdentry, stat->mode);
 			break;
 
 		case S_IFCHR:
@@ -95,11 +95,11 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		case S_IFIFO:
 		case S_IFSOCK:
 			err = ovl_do_mknod(dir, newdentry,
-					   stat->mode, stat->rdev, debug);
+					   stat->mode, stat->rdev);
 			break;
 
 		case S_IFLNK:
-			err = ovl_do_symlink(dir, newdentry, link, debug);
+			err = ovl_do_symlink(dir, newdentry, link);
 			break;
 
 		default:
@@ -173,7 +173,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 	err = PTR_ERR(newdentry);
 	if (IS_ERR(newdentry))
 		goto out_unlock;
-	err = ovl_create_real(udir, newdentry, stat, link, hardlink, false);
+	err = ovl_create_real(udir, newdentry, stat, link, hardlink);
 	if (err)
 		goto out_dput;
 
@@ -246,7 +246,7 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	if (IS_ERR(opaquedir))
 		goto out_unlock;
 
-	err = ovl_create_real(wdir, opaquedir, &stat, NULL, NULL, true);
+	err = ovl_create_real(wdir, opaquedir, &stat, NULL, NULL);
 	if (err)
 		goto out_dput;
 
@@ -343,7 +343,7 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 	if (IS_ERR(upper))
 		goto out_dput;
 
-	err = ovl_create_real(wdir, newdentry, stat, link, hardlink, true);
+	err = ovl_create_real(wdir, newdentry, stat, link, hardlink);
 	if (err)
 		goto out_dput2;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6a7090f..545b56b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -42,51 +42,42 @@ static inline int ovl_do_unlink(struct inode *dir, struct dentry *dentry)
 }
 
 static inline int ovl_do_link(struct dentry *old_dentry, struct inode *dir,
-			      struct dentry *new_dentry, bool debug)
+			      struct dentry *new_dentry)
 {
 	int err = vfs_link(old_dentry, dir, new_dentry, NULL);
-	if (debug) {
-		pr_debug("link(%pd2, %pd2) = %i\n",
-			 old_dentry, new_dentry, err);
-	}
+	pr_debug("link(%pd2, %pd2) = %i\n", old_dentry, new_dentry, err);
 	return err;
 }
 
 static inline int ovl_do_create(struct inode *dir, struct dentry *dentry,
-			     umode_t mode, bool debug)
+			     umode_t mode)
 {
 	int err = vfs_create(dir, dentry, mode, true);
-	if (debug)
-		pr_debug("create(%pd2, 0%o) = %i\n", dentry, mode, err);
+	pr_debug("create(%pd2, 0%o) = %i\n", dentry, mode, err);
 	return err;
 }
 
 static inline int ovl_do_mkdir(struct inode *dir, struct dentry *dentry,
-			       umode_t mode, bool debug)
+			       umode_t mode)
 {
 	int err = vfs_mkdir(dir, dentry, mode);
-	if (debug)
-		pr_debug("mkdir(%pd2, 0%o) = %i\n", dentry, mode, err);
+	pr_debug("mkdir(%pd2, 0%o) = %i\n", dentry, mode, err);
 	return err;
 }
 
 static inline int ovl_do_mknod(struct inode *dir, struct dentry *dentry,
-			       umode_t mode, dev_t dev, bool debug)
+			       umode_t mode, dev_t dev)
 {
 	int err = vfs_mknod(dir, dentry, mode, dev);
-	if (debug) {
-		pr_debug("mknod(%pd2, 0%o, 0%o) = %i\n",
-			 dentry, mode, dev, err);
-	}
+	pr_debug("mknod(%pd2, 0%o, 0%o) = %i\n", dentry, mode, dev, err);
 	return err;
 }
 
 static inline int ovl_do_symlink(struct inode *dir, struct dentry *dentry,
-				 const char *oldname, bool debug)
+				 const char *oldname)
 {
 	int err = vfs_symlink(dir, dentry, oldname);
-	if (debug)
-		pr_debug("symlink(\"%s\", %pd2) = %i\n", oldname, dentry, err);
+	pr_debug("symlink(\"%s\", %pd2) = %i\n", oldname, dentry, err);
 	return err;
 }
 
@@ -192,7 +183,7 @@ extern const struct inode_operations ovl_dir_inode_operations;
 struct dentry *ovl_lookup_temp(struct dentry *workdir, struct dentry *dentry);
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct kstat *stat, const char *link,
-		    struct dentry *hardlink, bool debug);
+		    struct dentry *hardlink);
 void ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
 /* copy_up.c */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 42c74bb..24a9801 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -801,7 +801,7 @@ retry:
 			goto retry;
 		}
 
-		err = ovl_create_real(dir, work, &stat, NULL, NULL, true);
+		err = ovl_create_real(dir, work, &stat, NULL, NULL);
 		if (err)
 			goto out_dput;
 	}
-- 
2.5.5
