From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 04/17] ovl: decode connected upper dir file handles
Date: Thu,  4 Jan 2018 19:20:36 +0200
Message-ID: <1515086449-26563-5-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:45056 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751679AbeADRUn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:43 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Until this change, we decoded upper file handles by instantiating an
overlay dentry from the real upper dentry. This is sufficient to handle
pure upper files, but insufficient to handle merge/impure dirs.

To that end, if decoded real upper dir is connected and hashed, we
lookup an overlay dentry with the same path as the real upper dir.
If decoded real upper is non-dir, we instantiate a disconnected overlay
dentry as before this change.

Because ovl_fh_to_dentry() returns connected overlay dir dentries,
exportfs never need to call get_parent() and get_name() to reconnect an
upper overlay dir. Because connectable non-dir file handles are not
supported, exportfs will not be able to use fh_to_parent() and get_name()
methods to reconnect a disconnected non-dir to its parent. Therefore, the
methods get_parent() and get_name() are implemented just to print out a
sanity warning and the method fh_to_parent() is implemented to warn the
user that using the 'subtree_check' exportfs option is not supported.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c | 172 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 171 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 5c72784a0b4d..48ae02f3acb8 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -130,6 +130,145 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	return dentry;
 }
 
+/*
+ * Lookup a child overlay dentry whose real dentry is @real.
+ * If @is_upper is true then we lookup a child overlay dentry with the same
+ * name as the real dentry. Otherwise, we need to consult index for lookup.
+ */
+static struct dentry *ovl_lookup_real_one(struct dentry *parent,
+					  struct dentry *real, bool is_upper)
+{
+	struct dentry *this;
+	struct qstr *name = &real->d_name;
+	int err;
+
+	/* TODO: use index when looking up by lower real dentry */
+	if (!is_upper)
+		return ERR_PTR(-EACCES);
+
+	/* Lookup overlay dentry by real name */
+	this = lookup_one_len_unlocked(name->name, parent, name->len);
+	err = PTR_ERR(this);
+	if (IS_ERR(this)) {
+		goto fail;
+	} else if (!this || !this->d_inode) {
+		dput(this);
+		err = -ENOENT;
+		goto fail;
+	} else if (ovl_dentry_upper(this) != real) {
+		dput(this);
+		err = -ESTALE;
+		goto fail;
+	}
+
+	return this;
+
+fail:
+	pr_warn_ratelimited("overlayfs: failed to lookup one by real (%pd2, is_upper=%d, parent=%pd2, err=%i)\n",
+			    real, is_upper, parent, err);
+	return ERR_PTR(err);
+}
+
+/*
+ * Lookup an overlay dentry whose real dentry is @real.
+ * If @is_upper is true then we lookup an overlay dentry with the same path
+ * as the real dentry. Otherwise, we need to consult index for lookup.
+ */
+static struct dentry *ovl_lookup_real(struct super_block *sb,
+				      struct dentry *real, bool is_upper)
+{
+	struct dentry *connected;
+	int err = 0;
+
+	/* TODO: use index when looking up by lower real dentry */
+	if (!is_upper)
+		return ERR_PTR(-EACCES);
+
+	connected = dget(sb->s_root);
+	while (!err) {
+		struct dentry *next, *this;
+		struct dentry *parent = NULL;
+		struct dentry *real_connected = ovl_dentry_upper(connected);
+
+		if (real_connected == real)
+			break;
+
+		next = dget(real);
+		/* find the topmost dentry not yet connected */
+		for (;;) {
+			parent = dget_parent(next);
+
+			if (real_connected == parent)
+				break;
+
+			/*
+			 * If real file has been moved out of the layer root
+			 * directory, we will eventully hit the real fs root.
+			 */
+			if (parent == next) {
+				err = -EXDEV;
+				break;
+			}
+
+			dput(next);
+			next = parent;
+		}
+
+		if (!err) {
+			this = ovl_lookup_real_one(connected, next, is_upper);
+			if (!IS_ERR(this)) {
+				dput(connected);
+				connected = this;
+			} else {
+				err = PTR_ERR(this);
+			}
+		}
+
+		dput(parent);
+		dput(next);
+	}
+
+	if (err)
+		goto fail;
+
+	return connected;
+
+fail:
+	pr_warn_ratelimited("overlayfs: failed to lookup by real (%pd2, is_upper=%d, connected=%pd2, err=%i)\n",
+			    real, is_upper, connected, err);
+	dput(connected);
+	return ERR_PTR(err);
+}
+
+/*
+ * Get an overlay dentry from upper/lower real dentries.
+ */
+static struct dentry *ovl_get_dentry(struct super_block *sb,
+				     struct dentry *upper,
+				     struct ovl_path *lowerpath)
+{
+	/* TODO: get non-upper dentry */
+	if (!upper)
+		return ERR_PTR(-EACCES);
+
+	/*
+	 * Obtain a disconnected overlay dentry from a non-dir real upper
+	 * dentry.
+	 */
+	if (!d_is_dir(upper))
+		return ovl_obtain_alias(sb, upper, NULL);
+
+	/* Removed empty directory? */
+	if ((upper->d_flags & DCACHE_DISCONNECTED) || d_unhashed(upper))
+		return ERR_PTR(-ENOENT);
+
+	/*
+	 * If real upper dentry is connected and hashed, get a connected
+	 * overlay dentry with the same path as the real upper dentry.
+	 */
+	return ovl_lookup_real(sb, upper, true);
+}
+
 static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
 					struct ovl_fh *fh)
 {
@@ -144,7 +283,7 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
 	if (IS_ERR_OR_NULL(upper))
 		return upper;
 
-	dentry = ovl_obtain_alias(sb, upper, NULL);
+	dentry = ovl_get_dentry(sb, upper, NULL);
 	dput(upper);
 
 	return dentry;
@@ -183,7 +322,38 @@ static struct dentry *ovl_fh_to_dentry(struct super_block *sb, struct fid *fid,
 	return ERR_PTR(err);
 }
 
+static struct dentry *ovl_fh_to_parent(struct super_block *sb, struct fid *fid,
+				       int fh_len, int fh_type)
+{
+	pr_warn_ratelimited("overlayfs: connectable file handles not supported; use 'no_subtree_check' exportfs option.\n");
+	return ERR_PTR(-EACCES);
+}
+
+static int ovl_get_name(struct dentry *parent, char *name,
+			struct dentry *child)
+{
+	/*
+	 * ovl_fh_to_dentry() returns connected dir overlay dentries and
+	 * ovl_fh_to_parent() is not implemented, so we should not get here.
+	 */
+	WARN_ON_ONCE(1);
+	return -EIO;
+}
+
+static struct dentry *ovl_get_parent(struct dentry *dentry)
+{
+	/*
+	 * ovl_fh_to_dentry() returns connected dir overlay dentries, so we
+	 * should not get here.
+	 */
+	WARN_ON_ONCE(1);
+	return ERR_PTR(-EIO);
+}
+
 const struct export_operations ovl_export_operations = {
 	.encode_fh      = ovl_encode_inode_fh,
 	.fh_to_dentry	= ovl_fh_to_dentry,
+	.fh_to_parent	= ovl_fh_to_parent,
+	.get_name	= ovl_get_name,
+	.get_parent	= ovl_get_parent,
 };
-- 
2.7.4
