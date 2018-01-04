From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 18/23] ovl: whiteout orphan index entries on mount
Date: Thu,  4 Jan 2018 18:40:13 +0200
Message-ID: <1515084018-25134-19-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:32951 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753480AbeADQjt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:49 -0500
Received: by mail-wr0-f194.google.com with SMTP id p6so2030497wrd.0
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:48 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Orphan index entries are non-dir index entries whose union nlink count
dropped to zero. With index=on, orphan index entries are removed on
mount. With verify=on, orphan index entries are replaced with white
out index entries to block future open by handle from opening the lower
file.

When dir index has a stale origin fh to upper dir, we assume that the
upper dir was removed and we treat the dir index as orphan entry that
needs to be whited out or removed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c   | 27 ++++++++++++++++++++++++---
 fs/overlayfs/readdir.c | 25 +++++++++++++++++++++++--
 2 files changed, 47 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 7cab6071c916..1a052f821fff 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -188,8 +188,14 @@ static struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt)
 				    bytes >> 2, (int)fh->type,
 				    ovl_acceptable, mnt);
 	if (IS_ERR(origin)) {
-		/* Treat stale file handle as "origin unknown" */
-		if (origin == ERR_PTR(-ESTALE))
+		/*
+		 * Treat stale file handle to lower file as "origin unknown".
+		 * upper file handle could become stale when upper file is
+		 * unlinked and this information is needed to handle stale
+		 * index entries correctly.
+		 */
+		if (origin == ERR_PTR(-ESTALE) &&
+		    !(fh->flags & OVL_FH_FLAG_PATH_UPPER))
 			origin = NULL;
 		return origin;
 	}
@@ -536,6 +542,14 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 	upper = ovl_index_upper(ofs, index);
 	if (IS_ERR(upper)) {
 		err = PTR_ERR(upper);
+		/*
+		 * Invalid index entries and stale non-dir index entries need
+		 * to be removed.  When dir index has a stale origin fh to upper
+		 * dir, we assume that upper dir was removed and we treat the
+		 * dir index as orphan entry that needs to be whited out.
+		 */
+		if (err == -ESTALE)
+			goto orphan;
 		if (err)
 			goto fail;
 	}
@@ -553,7 +567,7 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 			goto fail;
 
 		if (ovl_get_nlink(origin.dentry, index, 0) == 0)
-			err = -ENOENT;
+			goto orphan;
 	}
 
 out:
@@ -565,6 +579,13 @@ int ovl_verify_index(struct ovl_fs *ofs, struct dentry *index)
 	pr_warn_ratelimited("overlayfs: failed to verify index (%pd2, ftype=%x, err=%i)\n",
 			    index, d_inode(index)->i_mode & S_IFMT, err);
 	goto out;
+
+orphan:
+	pr_warn_ratelimited("overlayfs: orphan index entry (%pd2, ftype=%x, nlink=%u)\n",
+			    index, d_inode(index)->i_mode & S_IFMT,
+			    d_inode(index)->i_nlink);
+	err = -ENOENT;
+	goto out;
 }
 
 /*
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 0cdd1ad0b4f6..a5e4182149dc 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -1060,12 +1060,33 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 			break;
 		}
 		err = ovl_verify_index(ofs, index);
-		/* Cleanup stale and orphan index entries */
-		if (err && (err == -ESTALE || err == -ENOENT))
+		if (!err) {
+			goto next;
+		} else if (err == -ESTALE) {
+			/* Cleanup stale index entries */
 			err = ovl_cleanup(dir, index);
+		} else if (err != -ENOENT) {
+			/*
+			 * Abort mount to avoid corrupting the index if
+			 * an incompatible index entry was found or on out
+			 * of memory.
+			 */
+			break;
+		} else if (ofs->config.verify) {
+			/*
+			 * Whiteout orphan index to block future open by
+			 * handle after overlay nlink dropped to zero.
+			 */
+			err = ovl_cleanup_and_whiteout(indexdir, dir, index);
+		} else {
+			/* Cleanup orphan index entries */
+			err = ovl_cleanup(dir, index);
+		}
+
 		if (err)
 			break;
 
+next:
 		dput(index);
 		index = NULL;
 	}
-- 
2.7.4
