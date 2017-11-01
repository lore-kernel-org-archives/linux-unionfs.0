From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 5/9] ovl: relax same fs constraint for constant st_ino
Date: Wed,  1 Nov 2017 22:22:49 +0200
Message-ID: <1509567773-25590-6-git-send-email-amir73il@gmail.com>
References: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:44518 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755173AbdKAUWS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 16:22:18 -0400
Received: by mail-wr0-f194.google.com with SMTP id z55so3033006wrz.1
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Nov 2017 13:22:18 -0700 (PDT)
In-Reply-To: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

For the case of all layers not on the same fs, return the copy up origin
inode st_dev/st_ino for non-dir from stat(2).

This guaranties constant and system-wide unique st_dev/st_ino for non-dir
across copy up. Like the same fs case, st_ino of non-dir is also
persistent. Unlike the same fs case, st_dev is not persistent.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 49 +++++++++++++++++++++++++++++--------------------
 1 file changed, 29 insertions(+), 20 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 607a50c50042..d06de98808f6 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -74,6 +74,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	struct path realpath;
 	const struct cred *old_cred;
 	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
+	bool samefs = ovl_same_sb(dentry->d_sb);
 	int err;
 
 	type = ovl_path_real(dentry, &realpath);
@@ -83,16 +84,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		goto out;
 
 	/*
-	 * When all layers are on the same fs, all real inode number are
-	 * unique, so we use the overlay st_dev, which is friendly to du -x.
-	 *
-	 * We also use st_ino of the copy up origin, if we know it.
-	 * This guaranties constant st_dev/st_ino across copy up.
+	 * For non-dir or same fs, we use st_ino of the copy up origin, if we
+	 * know it. This guaranties constant st_dev/st_ino across copy up.
 	 *
 	 * If filesystem supports NFS export ops, this also guaranties
 	 * persistent st_ino across mount cycle.
 	 */
-	if (ovl_same_sb(dentry->d_sb)) {
+	if (!is_dir || samefs) {
 		if (OVL_TYPE_ORIGIN(type)) {
 			struct kstat lowerstat;
 			u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
@@ -103,7 +101,6 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (err)
 				goto out;
 
-			WARN_ON_ONCE(stat->dev != lowerstat.dev);
 			/*
 			 * Lower hardlinks may be broken on copy up to different
 			 * upper files, so we cannot use the lower origin st_ino
@@ -115,27 +112,39 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (is_dir || lowerstat.nlink == 1 ||
 			    ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 				stat->ino = lowerstat.ino;
+
+			if (samefs)
+				WARN_ON_ONCE(stat->dev != lowerstat.dev);
+			else
+				stat->dev = ovl_get_pseudo_dev(dentry);
 		}
-		stat->dev = dentry->d_sb->s_dev;
-	} else if (is_dir) {
+		if (samefs) {
+			/*
+			 * When all layers are on the same fs, all real inode
+			 * number are unique, so we use the overlay st_dev,
+			 * which is friendly to du -x.
+			 */
+			stat->dev = dentry->d_sb->s_dev;
+		} else if (!OVL_TYPE_UPPER(type)) {
+			/*
+			 * For non-samefs setup, to make sure that st_dev/st_ino
+			 * pair is unique across the system, we use a unique
+			 * anonymous st_dev for lower layer inode.
+			 */
+			stat->dev = ovl_get_pseudo_dev(dentry);
+		}
+	} else {
 		/*
-		 * If not all layers are on the same fs the pair {real st_ino;
-		 * overlay st_dev} is not unique, so use the non persistent
-		 * overlay st_ino.
-		 *
 		 * Always use the overlay st_dev for directories, so 'find
 		 * -xdev' will scan the entire overlay mount and won't cross the
 		 * overlay mount boundaries.
+		 *
+		 * If not all layers are on the same fs the pair {real st_ino;
+		 * overlay st_dev} is not unique, so use the non persistent
+		 * overlay st_ino for directories.
 		 */
 		stat->dev = dentry->d_sb->s_dev;
 		stat->ino = dentry->d_inode->i_ino;
-	} else if (!OVL_TYPE_UPPER(type)) {
-		/*
-		 * For non-samefs setup, to make sure that st_dev/st_ino pair
-		 * is unique across the system, we use a unique anonymous
-		 * st_dev for lower layer inode.
-		 */
-		stat->dev = ovl_get_pseudo_dev(dentry);
 	}
 
 	/*
-- 
2.7.4
