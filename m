From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 10/23] ovl: verify whiteout index entries on mount
Date: Thu,  4 Jan 2018 18:40:05 +0200
Message-ID: <1515084018-25134-11-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35291 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753385AbeADQjk (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:40 -0500
Received: by mail-wm0-f65.google.com with SMTP id a79so4453861wma.0
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:39 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Whiteout index entries are used as an indication that an exported
overlay file handle should be treated as stale (i.e. after unlink
of the overlay inode).

Check on mount that whiteout index entries have a name that looks like
a valid file handle and cleanup invalid index entries.

For whiteout index entries, do not check that they also have valid
origin fh and nlink xattr, because those xattr do not exist for a
whiteout index entry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 21 +++++++++++++--------
 1 file changed, 13 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 6e556d2e2365..b481bc4e79d9 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -435,16 +435,13 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 	/*
 	 * Directory index entries are going to be used for looking up
 	 * redirected upper dirs by lower dir fh when decoding an overlay
-	 * file handle of a merge dir. Whiteout index entries are going to be
-	 * used as an indication that an exported overlay file handle should
-	 * be treated as stale (i.e. after unlink of the overlay inode).
-	 * We don't know the verification rules for directory and whiteout
-	 * index entries, because they have not been implemented yet, so return
-	 * EINVAL if those entries are found to abort the mount to avoid
-	 * corrupting an index that was created by a newer kernel.
+	 * file handle of a merge dir.  We don't know the verification rules
+	 * for directory index entries, because they have not been implemented
+	 * yet, so return EINVAL if those entries are found to abort the mount
+	 * and to avoid corrupting an index that was created by a newer kernel.
 	 */
 	err = -EINVAL;
-	if (d_is_dir(index) || ovl_is_whiteout(index))
+	if (d_is_dir(index))
 		goto fail;
 
 	if (index->d_name.len < sizeof(struct ovl_fh)*2)
@@ -464,6 +461,14 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 	if (err)
 		goto fail;
 
+	/*
+	 * Whiteout index entries are used as an indication that an exported
+	 * overlay file handle should be treated as stale (i.e. after unlink
+	 * of the overlay inode). These entries contain no origin xattr.
+	 */
+	if (ovl_is_whiteout(index))
+		goto out;
+
 	err = ovl_verify_origin_fh(index, fh);
 	if (err)
 		goto fail;
-- 
2.7.4
