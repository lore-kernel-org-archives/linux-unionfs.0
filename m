From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: do not cleanup unsupported index entries
Date: Tue, 24 Oct 2017 12:24:11 +0300
Message-ID: <1508837051-15724-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54211 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751704AbdJXJXg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 24 Oct 2017 05:23:36 -0400
Received: by mail-wm0-f66.google.com with SMTP id r196so1919125wmf.2
        for <linux-unionfs@vger.kernel.org>; Tue, 24 Oct 2017 02:23:36 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

With index=on, ovl_indexdir_cleanup() tries to cleanup invalid index
entries (e.g. bad index name). This behavior could result in cleaning of
entries created by newer kernels and is therefore undesirable.
Instead, abort mount if such entries are encountered. We still cleanup
'stale' entries and 'orphan' entries, both those cases can be a result
of offline changes to lower and upper dirs.

When encoutering an index entry of type directory or whiteout, kernel
was supposed to fallback to read-only mount, but the fill_super()
operation returns EROFS in this case instead of returning success with
read-only mount flag, so mount fails when encoutering directory or
whiteout index entries. Bless this behavior by returning -EINVAL on
directory and whiteout index entries as we do for all unsupported index
entries.

Fixes: 61b674710cd9 ("ovl: do not cleanup directory and whiteout index..")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

My intentions in the commit that this patch Fixes were correct, but:
1. The implementation was buggy
2. The desired result should have been to fail the mount
3. I did not take the unsupported entries principle far enough

Luckily, faults 1 and 2 above cancel each other.

Please apply this fix to v4.14.
It is the base for an "incompat index features" series I will
be posting soon.

Thanks,
Amir.


 fs/overlayfs/namei.c   |  7 +++----
 fs/overlayfs/readdir.c | 11 +++++------
 2 files changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 0a72b855f4aa..97b14c4dda6e 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -405,14 +405,13 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 	 * be treated as stale (i.e. after unlink of the overlay inode).
 	 * We don't know the verification rules for directory and whiteout
 	 * index entries, because they have not been implemented yet, so return
-	 * EROFS if those entries are found to avoid corrupting an index that
-	 * was created by a newer kernel.
+	 * EINVAL if those entries are found to abort the mount to avoid
+	 * corrupting an index that was created by a newer kernel.
 	 */
-	err = -EROFS;
+	err = -EINVAL;
 	if (d_is_dir(index) || ovl_is_whiteout(index))
 		goto fail;
 
-	err = -EINVAL;
 	if (index->d_name.len < sizeof(struct ovl_fh)*2)
 		goto fail;
 
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 0f85ee9c3268..698b74dd750e 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1021,13 +1021,12 @@ int ovl_indexdir_cleanup(struct dentry *dentry, struct vfsmount *mnt,
 			break;
 		}
 		err = ovl_verify_index(index, lowerstack, numlower);
-		if (err) {
-			if (err == -EROFS)
-				break;
+		/* Cleanup stale and orphan index entries */
+		if (err && (err == -ESTALE || err == -ENOENT))
 			err = ovl_cleanup(dir, index);
-			if (err)
-				break;
-		}
+		if (err)
+			break;
+
 		dput(index);
 		index = NULL;
 	}
-- 
2.7.4
