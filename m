From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 6/9] ovl: relax same fs constraint for constant st_ino
Date: Tue,  7 Nov 2017 18:58:06 +0200
Message-ID: <1510073889-11657-7-git-send-email-amir73il@gmail.com>
References: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:51499 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754954AbdKGQ5k (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:57:40 -0500
Received: by mail-wm0-f68.google.com with SMTP id b9so5364839wmh.0
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 08:57:39 -0800 (PST)
In-Reply-To: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

For the case of all layers not on the same fs, return the copy up origin
inode st_dev/st_ino for non-dir from stat(2).

This guaranties constant st_dev/st_ino for non-dir across copy up.
Like the same fs case, st_ino of non-dir is also persistent.

If the st_dev/st_ino for copied up object would have been the same as
that of the real underlying lower file, running diff on underlying lower
file and overlay copied up file would result in diff reporting that the
two files are equal when in fact, they may have different content.

Therefore, unlike the same fs case, st_dev is not uniform across all
overlay object, which is less friednly to du -x.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 29b0adc77ebe..80a4b61a1149 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -104,6 +104,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	struct path realpath;
 	const struct cred *old_cred;
 	bool is_dir = S_ISDIR(dentry->d_inode->i_mode);
+	bool samefs = ovl_same_sb(dentry->d_sb);
 	int err;
 
 	type = ovl_path_real(dentry, &realpath);
@@ -113,13 +114,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 		goto out;
 
 	/*
-	 * When all layers are on the same fs, we use st_ino of copy up origin.
+	 * For non-dir or same fs, we use st_ino of the copy up origin.
 	 * This guaranties constant st_dev/st_ino across copy up.
 	 *
 	 * If lower filesystem supports NFS file handles, this also guaranties
 	 * persistent st_ino across mount cycle.
 	 */
-	if (ovl_same_sb(dentry->d_sb)) {
+	if (!is_dir || samefs) {
 		if (OVL_TYPE_ORIGIN(type)) {
 			struct kstat lowerstat;
 			u32 lowermask = STATX_INO | (!is_dir ? STATX_NLINK : 0);
@@ -130,7 +131,9 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 			if (err)
 				goto out;
 
-			WARN_ON_ONCE(stat->dev != lowerstat.dev);
+			if (samefs)
+				WARN_ON_ONCE(stat->dev != lowerstat.dev);
+
 			/*
 			 * Lower hardlinks may be broken on copy up to different
 			 * upper files, so we cannot use the lower origin st_ino
-- 
2.7.4
