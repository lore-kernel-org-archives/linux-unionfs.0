From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 1/2] ovl: do not cleanup directory and whiteout index entries
Date: Tue, 18 Jul 2017 21:07:42 +0300
Message-ID: <1500401263-25562-2-git-send-email-amir73il@gmail.com>
References: <1500401263-25562-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34933 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdGRSHe (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Jul 2017 14:07:34 -0400
Received: by mail-wr0-f194.google.com with SMTP id c24so1780957wra.2
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Jul 2017 11:07:34 -0700 (PDT)
In-Reply-To: <1500401263-25562-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Directory index entries are going to be used for looking up
redirected upper dirs by lower dir fh when decoding an overlay
file handle of a merge dir.

Whiteout index entries are going to be used as an indication that
an exported overlay file handle should be treated as stale (i.e.
after unlink of the overlay inode).

We don't know the verification rules for directory and whiteout
index entries, because they have not been implemented yet, so fail
to mount overlay rw if those entries are found to avoid corrupting
an index that was created by a newer kernel.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c   | 19 +++++++++++++++----
 fs/overlayfs/readdir.c |  5 ++++-
 2 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 9bc0e580a5b3..229a88ff335c 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -397,8 +397,19 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 	if (!d_inode(index))
 		return 0;
 
-	err = -EISDIR;
-	if (d_is_dir(index))
+	/*
+	 * Directory index entries are going to be used for looking up
+	 * redirected upper dirs by lower dir fh when decoding an overlay
+	 * file handle of a merge dir. Whiteout index entries are going to be
+	 * used as an indication that an exported overlay file handle should
+	 * be treated as stale (i.e. after unlink of the overlay inode).
+	 * We don't know the verification rules for directory and whiteout
+	 * index entries, because they have not been implemented yet, so return
+	 * EROFS if those entries are found to avoid corrupting an index that
+	 * was created by a newer kernel.
+	 */
+	err = -EROFS;
+	if (d_is_dir(index) || ovl_is_whiteout(index))
 		goto fail;
 
 	err = -EINVAL;
@@ -436,8 +447,8 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 	return err;
 
 fail:
-	pr_warn_ratelimited("overlayfs: failed to verify index (%pd2, err=%i)\n",
-			    index, err);
+	pr_warn_ratelimited("overlayfs: failed to verify index (%pd2, ftype=%x, err=%i)\n",
+			    index, d_inode(index)->i_mode & S_IFMT, err);
 	goto out;
 }
 
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 0298463cf9c3..3d424a51cabb 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -703,7 +703,10 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			err = PTR_ERR(index);
 			break;
 		}
-		if (ovl_verify_index(index, lowerstack, numlower)) {
+		err = ovl_verify_index(index, lowerstack, numlower);
+		if (err) {
+			if (err == -EROFS)
+				break;
 			err = ovl_cleanup(dir, index);
 			if (err)
 				break;
-- 
2.7.4
