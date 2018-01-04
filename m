From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 10/17] ovl: decode lower file handles of unlinked but open files
Date: Thu,  4 Jan 2018 19:20:42 +0200
Message-ID: <1515086449-26563-11-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:46372 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752215AbeADRUu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:50 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Lookup overlay inode in cache by origin inode, so we can decode a file
handle of an open file even if the index has a whiteout index entry to
mark this overlay inode was unlinked.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 22 ++++++++++++++++++++--
 fs/overlayfs/inode.c     | 16 ++++++++++++++++
 fs/overlayfs/overlayfs.h |  1 +
 3 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 602bada474ba..6ecb54d4b52c 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -385,13 +385,21 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 	struct ovl_path *stack = &origin;
 	struct dentry *dentry = NULL;
 	struct dentry *index = NULL;
+	struct inode *inode = NULL;
+	bool is_deleted = false;
 	int err;
 
 	/* First lookup indexed upper by fh */
 	index = ovl_get_index_fh(ofs, fh);
 	err = PTR_ERR(index);
-	if (IS_ERR(index))
-		return ERR_PTR(err);
+	if (IS_ERR(index)) {
+		if (err != -ESTALE)
+			return ERR_PTR(err);
+
+		/* Found a whiteout index - treat as deleted inode */
+		is_deleted = true;
+		index = NULL;
+	}
 
 	/* Then lookup origin by fh */
 	err = ovl_check_origin_fh(fh, NULL, ofs->lower_layers, ofs->numlower,
@@ -404,6 +412,15 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 		err = ovl_verify_origin(index, origin.dentry, false, false);
 		if (err)
 			goto out_err;
+	} else if (is_deleted && origin.dentry && !d_is_dir(origin.dentry)) {
+		/* Lookup deleted overlay inode by origin inode */
+		inode = ovl_lookup_inode(sb, origin.dentry);
+		err = -ESTALE;
+		if (!inode || atomic_read(&inode->i_count) == 1)
+			goto out_err;
+
+		/* Deleted but still open? */
+		index = dget(ovl_i_dentry_upper(inode));
 	}
 
 	dentry = ovl_get_dentry(sb, NULL, &origin, index);
@@ -411,6 +428,7 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 out:
 	dput(origin.dentry);
 	dput(index);
+	iput(inode);
 	return dentry;
 
 out_err:
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index bb742d195f12..a25908ba3512 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -637,6 +637,22 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
 	return true;
 }
 
+struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *origin)
+{
+	struct inode *inode, *key = d_inode(origin);
+
+	inode = ilookup5(sb, (unsigned long) key, ovl_inode_test, key);
+	if (!inode)
+		return NULL;
+
+	if (!ovl_verify_inode(inode, origin, NULL)) {
+		iput(inode);
+		return ERR_PTR(-ESTALE);
+	}
+
+	return inode;
+}
+
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			    struct dentry *lowerdentry, struct dentry *index,
 			    unsigned int numlower)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2ddd74043b5f..8fa8253af7cb 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -305,6 +305,7 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
+struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *origin);
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			    struct dentry *lowerdentry, struct dentry *index,
 			    unsigned int numlower);
-- 
2.7.4
