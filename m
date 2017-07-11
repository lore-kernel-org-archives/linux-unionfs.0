From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 10/10] ovl: follow decoded origin file handle of merge dir
Date: Tue, 11 Jul 2017 15:58:43 +0300
Message-ID: <1499777923-29410-11-git-send-email-amir73il@gmail.com>
References: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:32921 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755693AbdGKM6q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 11 Jul 2017 08:58:46 -0400
Received: by mail-wr0-f196.google.com with SMTP id x23so32115169wrb.0
        for <linux-unionfs@vger.kernel.org>; Tue, 11 Jul 2017 05:58:46 -0700 (PDT)
In-Reply-To: <1499777923-29410-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When inodes index feature is enabled, if lower dir does not match the
origin fh stored in upper dir, or if no lower dir was found by name,
try to decode the stored origin fh and use the result as the merge dir
lower dentry.

This change is needed for indexing of merge directories. A merge
directory is indexed by the file handle of the uppermost lower dir and
the index will have a reference to the upper dir by file handle.
Following down from upper by origin file handle ensures the integrity
of the index for non-stale origin entries. index entries with stale origin
are going to be cleaned up on mount anyway.

When there is more than a single lower layer, a lower merge directory
followed from upper dir by origin fh is not followed down again to lower
layers by name.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/overlayfs.txt |  6 +++++-
 fs/dcache.c                             |  1 +
 fs/overlayfs/namei.c                    | 38 +++++++++++++++++++++++++++++----
 3 files changed, 40 insertions(+), 5 deletions(-)

diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
index 9b9e8efc3977..ceeb77d86671 100644
--- a/Documentation/filesystems/overlayfs.txt
+++ b/Documentation/filesystems/overlayfs.txt
@@ -276,7 +276,11 @@ the "trusted.overlay.redirect" extended attribute, will verify that the
 found lower directory file handle and lower filesystem UUID match the
 origin file handle that was stored at copy_up time.  If a found lower
 directory does not match the stored origin, that directory will be not be
-merged with the upper directory.
+merged with the upper directory.  If the stored origin file handle can be
+decoded to an existing lower directory, the decoded directory will be
+merged with the upper directory instead.  The "inodes index" feature,
+therefore, makes an overlay mount cope better with the situations of
+lower directory rename and delete.
 
 Testsuite
 ---------
diff --git a/fs/dcache.c b/fs/dcache.c
index a9f995f6859e..c6d3d76f4bee 100644
--- a/fs/dcache.c
+++ b/fs/dcache.c
@@ -3497,6 +3497,7 @@ bool is_subdir(struct dentry *new_dentry, struct dentry *old_dentry)
 
 	return result;
 }
+EXPORT_SYMBOL(is_subdir);
 
 static enum d_walk_ret d_genocide_kill(void *data, struct dentry *dentry)
 {
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index ec81d27b12be..42f839d26e94 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -83,9 +83,21 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 	goto err_free;
 }
 
-static int ovl_acceptable(void *ctx, struct dentry *dentry)
+static int ovl_acceptable(void *mnt, struct dentry *dentry)
 {
-	return 1;
+	/*
+	 * A non-dir origin may be disconnected, which is fine, because
+	 * we only need it for its unique inode number.
+	 */
+	if (!d_is_dir(dentry))
+		return 1;
+
+	/* Don't want to follow a deleted empty lower directory */
+	if (d_unhashed(dentry))
+		return 0;
+
+	/* Check if directory belongs to the layer mounted at mnt */
+	return is_subdir(dentry, ((struct vfsmount *)mnt)->mnt_root);
 }
 
 static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry)
@@ -160,7 +172,7 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	bytes = (fh->len - offsetof(struct ovl_fh, fid));
 	origin = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
 				    bytes >> 2, (int)fh->type,
-				    ovl_acceptable, NULL);
+				    ovl_acceptable, mnt);
 	if (IS_ERR(origin)) {
 		/* Treat stale file handle as "origin unknown" */
 		if (origin == ERR_PTR(-ESTALE))
@@ -293,7 +305,6 @@ static int ovl_check_origin(struct dentry *upperdentry,
 	struct dentry *origin = NULL;
 	int i;
 
-
 	for (i = 0; i < numlower; i++) {
 		mnt = lowerstack[i].mnt;
 		origin = ovl_get_origin(upperdentry, mnt);
@@ -677,6 +688,25 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
+	/*
+	 * If lower not found by name or couldn't verify origin fh, try to
+	 * follow the decoded origin fh in upper to the first lower dir.
+	 */
+	if (!d.stop && poe->numlower && upperdentry && !ctr &&
+	    ovl_indexdir(dentry->d_sb)) {
+		err = ovl_check_origin(upperdentry, roe->lowerstack,
+				       roe->numlower, &stack, &ctr);
+		if (err)
+			goto out_put;
+		/*
+		 * XXX: We do not continue layers lookup from decoded origin for
+		 * more than a single lower layer. This would require setting
+		 * d.redirect to decoded origin path and jump back to the
+		 * lowerstack layers lookup loop with 'i' set to the root layer
+		 * number where we found the decoded origin.
+		 */
+	}
+
 	/* Lookup index by lower inode and verify it matches upper inode */
 	if (ctr && !d.is_dir && ovl_indexdir(dentry->d_sb)) {
 		struct dentry *origin = stack[0].dentry;
-- 
2.7.4
