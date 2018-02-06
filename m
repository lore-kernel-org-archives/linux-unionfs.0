From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/4] ovl: lookup in inode cache when decoding lower file handle
Date: Tue,  6 Feb 2018 14:21:40 +0200
Message-ID: <1517919700-29182-6-git-send-email-amir73il@gmail.com>
References: <1517919700-29182-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35209 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753069AbeBFMUu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Feb 2018 07:20:50 -0500
Received: by mail-wm0-f66.google.com with SMTP id r78so3472283wme.0
        for <linux-unionfs@vger.kernel.org>; Tue, 06 Feb 2018 04:20:49 -0800 (PST)
In-Reply-To: <1517919700-29182-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When decoding a lower file handle, we need to check if lower file was
copied up and indexed and if it has a whiteout index, we need to check
if this is an unlinked but open non-dir before returning -ESTALE.

To find out if this is an unlinked but open non-dir we need to lookup
an overlay inode in inode cache with an alias.

Before this change, the overlay inode was looked up by lower inode and
that required decoding the lower file handle before looking in inode
cache. If the lower inode turned out to be a directory, we may have
paid an expensive cost to reconnect that lower directory for nothing.

After this change, we start by looking up an overlay inode in inode
cache by lower file handle. If we don't find an overlay inode and dentry
alias, then we only need to decode the lower file handle in case the
lower file is not indexed or if the index is a non-dir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 39 ++++++++++++++++-----------------------
 1 file changed, 16 insertions(+), 23 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 031cbe060e1b..f8dce6976248 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -700,22 +700,26 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 	struct ovl_path *stack = &origin;
 	struct dentry *dentry = NULL;
 	struct dentry *index = NULL;
-	struct inode *inode = NULL;
-	bool is_deleted = false;
+	struct inode *inode;
 	int err;
 
-	/* First lookup indexed upper by fh */
+	/* First lookup overlay inode in inode cache by fh */
+	inode = ovl_lookup_inode_fh(sb, fh);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (inode) {
+		dentry = d_find_any_alias(inode);
+		iput(inode);
+		if (dentry)
+			return dentry;
+	}
+
+	/* Then lookup indexed upper by fh */
 	if (ofs->indexdir) {
 		index = ovl_get_index_fh(ofs, fh);
 		err = PTR_ERR(index);
-		if (IS_ERR(index)) {
-			if (err != -ESTALE)
-				return ERR_PTR(err);
-
-			/* Found a whiteout index - treat as deleted inode */
-			is_deleted = true;
-			index = NULL;
-		}
+		if (IS_ERR(index))
+			return index;
 	}
 
 	/* Then try to get upper dir by index */
@@ -731,7 +735,7 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 		goto out;
 	}
 
-	/* Then lookup origin by fh */
+	/* Then lookup indexed non-dir origin or non-upper by fh */
 	err = ovl_check_origin_fh(ofs, fh, NULL, &stack);
 	if (err) {
 		goto out_err;
@@ -739,16 +743,6 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 		err = ovl_verify_origin(index, origin.dentry, false);
 		if (err)
 			goto out_err;
-	} else if (is_deleted) {
-		/* Lookup deleted non-dir by origin inode */
-		if (!d_is_dir(origin.dentry))
-			inode = ovl_lookup_inode(sb, origin.dentry, false);
-		err = -ESTALE;
-		if (!inode || atomic_read(&inode->i_count) == 1)
-			goto out_err;
-
-		/* Deleted but still open? */
-		index = dget(ovl_i_dentry_upper(inode));
 	}
 
 	dentry = ovl_get_dentry(sb, NULL, &origin, index);
@@ -756,7 +750,6 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 out:
 	dput(origin.dentry);
 	dput(index);
-	iput(inode);
 	return dentry;
 
 out_err:
-- 
2.7.4
