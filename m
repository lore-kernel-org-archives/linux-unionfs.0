From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 2/5] ovl: relax same fs constrain for constant st_ino
Date: Thu,  1 Jun 2017 12:02:56 +0300
Message-ID: <1496307779-2766-3-git-send-email-amir73il@gmail.com>
References: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36400 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdFAJCv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:02:51 -0400
Received: by mail-wm0-f68.google.com with SMTP id k15so9568837wmh.3
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Jun 2017 02:02:51 -0700 (PDT)
In-Reply-To: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org

For the case of all layers not on the same fs, use the copy up
origin st_ino/st_dev for non-dir, if we know it.

This guarantied constant and persistent st_ino/st_dev for non-dir,
but not system-wide uniqueness, like in the same fs case.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 32 +++++++++++++++++++-------------
 1 file changed, 19 insertions(+), 13 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index d613e2c41242..5f285c179bbd 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -65,6 +65,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	struct path realpath;
 	const struct cred *old_cred;
 	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
+	bool samefs = ovl_same_sb(dentry->d_sb);
 	int err;
 
 	type = ovl_path_real(dentry, &realpath);
@@ -74,16 +75,16 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
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
+	 *
+	 * When all layers are on the same fs, all real inode number are
+	 * unique, so we use the overlay st_dev, which is friendly to du -x.
 	 */
-	if (ovl_same_sb(dentry->d_sb)) {
+	if (!is_dir || samefs) {
 		if (OVL_TYPE_ORIGIN(type)) {
 			struct kstat lowerstat;
 			u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
@@ -94,7 +95,6 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (err)
 				goto out;
 
-			WARN_ON_ONCE(stat->dev != lowerstat.dev);
 			/*
 			 * Lower hardlinks are broken on copy up to different
 			 * upper files, so we cannot use the lower origin st_ino
@@ -102,17 +102,23 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			 */
 			if (is_dir || lowerstat.nlink == 1)
 				stat->ino = lowerstat.ino;
+
+			if (samefs)
+				WARN_ON_ONCE(stat->dev != lowerstat.dev);
+			else
+				stat->dev = lowerstat.dev;
 		}
-		stat->dev = dentry->d_sb->s_dev;
-	} else if (is_dir) {
+		if (samefs)
+			stat->dev = dentry->d_sb->s_dev;
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
-- 
2.7.4
