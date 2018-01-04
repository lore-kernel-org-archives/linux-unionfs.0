From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 12/17] ovl: decode pure lower dir file handles
Date: Thu,  4 Jan 2018 19:20:44 +0200
Message-ID: <1515086449-26563-13-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35468 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752392AbeADRUx (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:53 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Similar to decoding a pure upper dir file handle, decoding a pure lower
dir file handle is implemented by looking an overlay dentry of the same
path as the pure lower path and verifying that the overlay dentry's
real lower matches the decoded real lower file handle.

Unlike the case of upper dir file handle, the lookup of overlay path by
lower real path can fail or find a mismatched overlay dentry if any of
the lower parents have been copied up and renamed. To address this case
we will need to check if any of the lower parents are indexed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 28 ++++++++++++----------------
 1 file changed, 12 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 6141682301d6..ec4b9f29d40d 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -215,6 +215,11 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	return dentry;
 }
 
+static struct dentry *ovl_dentry_real_at(struct dentry *dentry, bool is_upper)
+{
+	return is_upper ? ovl_dentry_upper(dentry) : ovl_dentry_lower(dentry);
+}
+
 /*
  * Lookup a child overlay dentry whose real dentry is @real.
  * If @is_upper is true then we lookup a child overlay dentry with the same
@@ -228,8 +233,6 @@ static struct dentry *ovl_lookup_real_one(struct dentry *parent,
 	int err;
 
 	/* TODO: use index when looking up by lower real dentry */
-	if (!is_upper)
-		return ERR_PTR(-EACCES);
 
 	/* Lookup overlay dentry by real name */
 	this = lookup_one_len_unlocked(name->name, parent, name->len);
@@ -240,7 +243,7 @@ static struct dentry *ovl_lookup_real_one(struct dentry *parent,
 		dput(this);
 		err = -ENOENT;
 		goto fail;
-	} else if (ovl_dentry_upper(this) != real) {
+	} else if (ovl_dentry_real_at(this, is_upper) != real) {
 		dput(this);
 		err = -ESTALE;
 		goto fail;
@@ -265,15 +268,12 @@ static struct dentry *ovl_lookup_real(struct super_block *sb,
 	struct dentry *connected;
 	int err = 0;
 
-	/* TODO: use index when looking up by lower real dentry */
-	if (!is_upper)
-		return ERR_PTR(-EACCES);
-
 	connected = dget(sb->s_root);
 	while (!err) {
 		struct dentry *next, *this;
 		struct dentry *parent = NULL;
-		struct dentry *real_connected = ovl_dentry_upper(connected);
+		struct dentry *real_connected = ovl_dentry_real_at(connected,
+								   is_upper);
 
 		if (real_connected == real)
 			break;
@@ -342,19 +342,15 @@ static struct dentry *ovl_get_dentry(struct super_block *sb,
 	if (!d_is_dir(real))
 		return ovl_obtain_alias(sb, upper, lowerpath, index);
 
-	/* TODO: lookup connected dir from real lower dir */
-	if (!upper)
-		return ERR_PTR(-EACCES);
-
 	/* Removed empty directory? */
-	if ((upper->d_flags & DCACHE_DISCONNECTED) || d_unhashed(upper))
+	if ((real->d_flags & DCACHE_DISCONNECTED) || d_unhashed(real))
 		return ERR_PTR(-ENOENT);
 
 	/*
-	 * If real upper dentry is connected and hashed, get a connected
-	 * overlay dentry with the same path as the real upper dentry.
+	 * If real dentry is connected and hashed, get a connected overlay
+	 * dentry whose real dentry is @real.
 	 */
-	return ovl_lookup_real(sb, upper, true);
+	return ovl_lookup_real(sb, real, !!upper);
 }
 
 static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
-- 
2.7.4
