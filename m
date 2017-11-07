From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 4/9] ovl: factor out ovl_map_dev_ino() helper
Date: Tue,  7 Nov 2017 18:58:04 +0200
Message-ID: <1510073889-11657-5-git-send-email-amir73il@gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:46537 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754954AbdKGQ5h (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:57:37 -0500
Received: by mail-wm0-f66.google.com with SMTP id r68so5176526wmr.1
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 08:57:37 -0800 (PST)
In-Reply-To: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

A helper for ovl_getattr() to map the values of st_dev and st_ino
according to constant st_ino rules.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 52 ++++++++++++++++++++++++++++++++++------------------
 1 file changed, 34 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b772e5a2a730..6c54ecff56ee 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -58,6 +58,34 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	return err;
 }
 
+static int ovl_map_dev_ino(struct dentry *dentry, struct kstat *stat)
+{
+	bool samefs = ovl_same_sb(dentry->d_sb);
+
+	if (samefs) {
+		/*
+		 * When all layers are on the same fs, all real inode
+		 * number are unique, so we use the overlay st_dev,
+		 * which is friendly to du -x.
+		 */
+		stat->dev = dentry->d_sb->s_dev;
+	} else if (S_ISDIR(dentry->d_inode->i_mode)) {
+		/*
+		 * Always use the overlay st_dev for directories, so 'find
+		 * -xdev' will scan the entire overlay mount and won't cross the
+		 * overlay mount boundaries.
+		 *
+		 * If not all layers are on the same fs the pair {real st_ino;
+		 * overlay st_dev} is not unique, so use the non persistent
+		 * overlay st_ino for directories.
+		 */
+		stat->dev = dentry->d_sb->s_dev;
+		stat->ino = dentry->d_inode->i_ino;
+	}
+
+	return 0;
+}
+
 int ovl_getattr(const struct path *path, struct kstat *stat,
 		u32 request_mask, unsigned int flags)
 {
@@ -75,13 +103,10 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		goto out;
 
 	/*
-	 * When all layers are on the same fs, all real inode number are
-	 * unique, so we use the overlay st_dev, which is friendly to du -x.
-	 *
-	 * We also use st_ino of the copy up origin, if we know it.
+	 * When all layers are on the same fs, we use st_ino of copy up origin.
 	 * This guaranties constant st_dev/st_ino across copy up.
 	 *
-	 * If filesystem supports NFS export ops, this also guaranties
+	 * If lower filesystem supports NFS file handles, this also guaranties
 	 * persistent st_ino across mount cycle.
 	 */
 	if (ovl_same_sb(dentry->d_sb)) {
@@ -108,21 +133,12 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			    ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 				stat->ino = lowerstat.ino;
 		}
-		stat->dev = dentry->d_sb->s_dev;
-	} else if (is_dir) {
-		/*
-		 * If not all layers are on the same fs the pair {real st_ino;
-		 * overlay st_dev} is not unique, so use the non persistent
-		 * overlay st_ino.
-		 *
-		 * Always use the overlay st_dev for directories, so 'find
-		 * -xdev' will scan the entire overlay mount and won't cross the
-		 * overlay mount boundaries.
-		 */
-		stat->dev = dentry->d_sb->s_dev;
-		stat->ino = dentry->d_inode->i_ino;
 	}
 
+	err = ovl_map_dev_ino(dentry, stat);
+	if (err)
+		goto out;
+
 	/*
 	 * It's probably not worth it to count subdirs to get the
 	 * correct link count.  nlink=1 seems to pacify 'find' and
-- 
2.7.4
