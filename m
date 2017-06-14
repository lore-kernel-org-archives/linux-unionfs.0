From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 23/23] ovl: adjust overlay inode nlink for indexed inodes
Date: Wed, 14 Jun 2017 10:26:42 +0300
Message-ID: <1497425202-16270-24-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35128 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754313AbdFNH1C (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:27:02 -0400
Received: by mail-wr0-f193.google.com with SMTP id z45so6095921wrb.2
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:27:01 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Overlay inode nlink does not account for all the lower hardlinks that
have not been copied up yet. Those are added to nlink as they get copied up
and do not decrement nlink when they get unlinked or renamed over.

As a workaround for correct overlay nlink count, before trying to unlink
or rename over the first lower hardlink, try to copy up that lower and
create the index prior to removal of upper.

An overlay inode nlink of 1 stands for an orphan indexed inode. This is
the case where some of the lower hardlinks were copied up, modified, and
then all copied up upper hardlinks has been unlinked, but there are still
non covered lower hardlinks.

The important thing to take care of is that overlay inode nlink doesn't
drop to zero when there are still upper hardlinks or non covered
lower hardlinks.

Return the overlay inode nlinks for indexed upper inodes on stat(2),
excluding 1 nlink for the index entry.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c   | 43 +++++++++++++++++++++++++++++++++++++++----
 fs/overlayfs/inode.c |  9 +++++++++
 2 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index cec89d33ab1e..6c354bd4483e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -732,9 +732,42 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 	return err;
 }
 
+static bool ovl_is_indexed_lower(struct dentry *dentry)
+{
+	enum ovl_path_type type = ovl_path_type(dentry);
+
+	/*
+	 * With inodes index feature, lower hardlinks are not counted in
+	 * overlay inode nlink. The lower hardlinks are added to overlay nlink
+	 * count as they get copied up and do not decrement overlay nlink when
+	 * they get unlinked or renamed over.
+	 *
+	 * An overlay inode nlink of 1 stands for an orphan indexed inode -
+	 * an inode that was copied up, modified, and then the copied up alias
+	 * has been unlinked. The orphan index can still be linked by another
+	 * lower hardlink copy up.
+	 *
+	 * Removing non indexed lower hardlinks would lead to negative overlay
+	 * nlink if we wanted to account for those removals in overlay nlink.
+	 * As a workaround, before whiteout/rename over of a lower hardlink,
+	 * try to copy up to create the upper index. Creating the upper index
+	 * will initialize the overlay nlink, do it could be dropped if unlink
+	 * or rename succeeds.
+	 * TODO: implement metadata only index copy up when called with
+	 *       ovl_copy_up_flags(dentry, O_PATH).
+	 */
+	if (ovl_indexdir(dentry->d_sb) && !OVL_TYPE_UPPER(type) &&
+	    ovl_dentry_lower(dentry)->d_inode->i_nlink > 1) {
+		ovl_copy_up(dentry);
+		type = ovl_path_type(dentry);
+	}
+
+	return !OVL_TYPE_UPPER(type) && OVL_TYPE_INDEX(type);
+}
+
 static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 {
-	enum ovl_path_type type;
+	bool indexed_lower;
 	int err;
 	const struct cred *old_cred;
 
@@ -746,7 +779,8 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	if (err)
 		goto out_drop_write;
 
-	type = ovl_path_type(dentry);
+	if (!is_dir)
+		indexed_lower = ovl_is_indexed_lower(dentry);
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	if (!ovl_lower_positive(dentry))
@@ -757,7 +791,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	if (!err) {
 		if (is_dir)
 			clear_nlink(dentry->d_inode);
-		else
+		else if (!indexed_lower)
 			drop_nlink(dentry->d_inode);
 	}
 out_drop_write:
@@ -952,7 +986,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			flags |= RENAME_EXCHANGE;
 			cleanup_whiteout = true;
 		}
-		if (!new_is_dir && new->d_inode)
+		/* An indexed lower hardlink is not counted in overlay nlink */
+		if (!new_is_dir && new->d_inode && !ovl_is_indexed_lower(new))
 			new_drop_nlink = true;
 	}
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 28f9a8cc0f61..35fda6fb9de3 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -131,6 +131,15 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	if (is_dir && OVL_TYPE_MERGE(type))
 		stat->nlink = 1;
 
+	/*
+	 * Return the overlay inode nlinks for indexed upper inodes, excluding
+	 * 1 nlink for the index entry. Overlay inode nlink does not account
+	 * for all the lower hardlinks that have not been copied up yet.
+	 * TODO: add count of non-covered lower hardlinks.
+	 */
+	if (!is_dir && OVL_TYPE_UPPER(type) && OVL_TYPE_INDEX(type))
+		stat->nlink = dentry->d_inode->i_nlink - 1;
+
 out:
 	revert_creds(old_cred);
 
-- 
2.7.4
