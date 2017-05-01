From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 12/15] ovl: fix du --one-file-system on overlay mount
Date: Mon,  1 May 2017 16:42:03 +0300
Message-ID: <1493646126-10101-13-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34130 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424607AbdEANmU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:20 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Overlay directory inodes report overlay st_dev to stat(2).
Overlay non-dir inodes report real st_dev and real st_ino to stat(2).

Due to the different st_dev values for dir and non-dir inodes, when
executing the command du -x on an overlay mount, the result is wrong,
because non-dirs are not accounted for in the overlay disk usage.

The reason that the overlay st_dev is not used for non-dir is because
the tuple overlay st_dev and real st_ino is not unique when overlay
layers are not on the same fs.

When all overlay layers are on the same fs, that tuple is unique, so
use overlay st_dev for non-dirs to get the correct result from du -x.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 9c0c4e1..ec5230f 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -73,8 +73,10 @@ static int ovl_getattr(const struct path *path, struct kstat *stat,
 		return err;
 
 	/*
-	 * When all layers are on the same fs, we use st_ino of the copy up
-	 * origin, if we know it.
+	 * When all layers are on the same fs, all real inode number are
+	 * unique, so we use the overlay st_dev, which is friendly to du -x.
+	 *
+	 * We also use st_ino of the copy up origin, if we know it.
 	 * This guaranties constant st_dev/st_ino across copy up.
 	 *
 	 * When redirect_fh is enabled, this also guaranties persistent
@@ -83,15 +85,14 @@ static int ovl_getattr(const struct path *path, struct kstat *stat,
 	if (ovl_same_sb(dentry->d_sb)) {
 		struct dentry *lower = ovl_dentry_lower(dentry);
 
+		stat->dev = dentry->d_sb->s_dev;
 		/*
 		 * Lower hardlinks are broken on copy up to differnt upper
 		 * files, so we cannot use the lower origin st_ino for those
 		 * different files, even for the same fs case.
 		 */
-		if (lower && lower->d_inode->i_nlink == 1) {
-			stat->dev = lower->d_sb->s_dev;
+		if (lower && lower->d_inode->i_nlink == 1)
 			stat->ino = lower->d_inode->i_ino;
-		}
 	}
 
 	return 0;
-- 
2.7.4
