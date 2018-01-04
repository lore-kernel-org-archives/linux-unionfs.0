From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 14/17] ovl: lookup connected ancestor of dir in inode cache
Date: Thu,  4 Jan 2018 19:20:46 +0200
Message-ID: <1515086449-26563-15-git-send-email-amir73il@gmail.com>
References: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:38522 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751066AbeADRUz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 12:20:55 -0500
In-Reply-To: <1515086449-26563-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Decoding a dir file handle requires walking backward up to layer root and
for lower dir also checking the index to see if any of the parents have
been copied up.

Lookup overlay ancestor dentry in inode/dentry cache by decoded real
parents to shortcut looking up all the way back to layer root.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 88 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/overlayfs/inode.c     |  8 +++--
 fs/overlayfs/overlayfs.h |  3 +-
 3 files changed, 93 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index ec4b9f29d40d..01c4e3f733c1 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -258,6 +258,87 @@ static struct dentry *ovl_lookup_real_one(struct dentry *parent,
 }
 
 /*
+ * Lookup an indexed or hashed overlay dentry by real inode.
+ */
+static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
+					    struct dentry *real, bool is_upper)
+{
+	struct dentry *this = NULL;
+	struct inode *inode;
+
+	inode = ovl_lookup_inode(sb, real, is_upper);
+	if (IS_ERR(inode))
+		return ERR_CAST(inode);
+	if (inode) {
+		this = d_find_any_alias(inode);
+		iput(inode);
+	}
+
+	/* TODO: use index when looking up by origin inode */
+	if (!this)
+		return NULL;
+
+	if (WARN_ON(ovl_dentry_real_at(this, is_upper) != real)) {
+		dput(this);
+		this = ERR_PTR(-EIO);
+	}
+
+	return this;
+}
+
+/*
+ * Lookup an indexed or hashed overlay dentry, whose real dentry is an
+ * ancestor of @real.
+ */
+static struct dentry *ovl_lookup_real_ancestor(struct super_block *sb,
+					       struct dentry *real,
+					       bool is_upper)
+{
+	struct dentry *real_root = ovl_dentry_real_at(sb->s_root, is_upper);
+	struct dentry *next, *parent = NULL;
+	struct dentry *ancestor;
+
+	if (real_root == real)
+		return dget(sb->s_root);
+
+	/* Find the topmost indexed or hashed ancestor */
+	next = dget(real);
+	for (;;) {
+		parent = dget_parent(next);
+
+		/*
+		 * Lookup a matching overlay dentry in inode/dentry
+		 * cache or in index by real inode.
+		 */
+		ancestor = ovl_lookup_real_inode(sb, next, is_upper);
+		if (ancestor)
+			break;
+
+		if (real_root == parent) {
+			ancestor = dget(sb->s_root);
+			break;
+		}
+
+		/*
+		 * If @real has been moved out of the layer root directory,
+		 * we will eventully hit the real fs root.
+		 */
+		if (parent == next) {
+			ancestor = ERR_PTR(-EXDEV);
+			break;
+		}
+
+		dput(next);
+		next = parent;
+	}
+
+	dput(parent);
+	dput(next);
+
+	return ancestor;
+}
+
+/*
  * Lookup an overlay dentry whose real dentry is @real.
  * If @is_upper is true then we lookup an overlay dentry with the same path
  * as the real dentry. Otherwise, we need to consult index for lookup.
@@ -268,7 +349,10 @@ static struct dentry *ovl_lookup_real(struct super_block *sb,
 	struct dentry *connected;
 	int err = 0;
 
-	connected = dget(sb->s_root);
+	connected = ovl_lookup_real_ancestor(sb, real, is_upper);
+	if (IS_ERR_OR_NULL(connected))
+		return connected;
+
 	while (!err) {
 		struct dentry *next, *this;
 		struct dentry *parent = NULL;
@@ -423,7 +507,7 @@ static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
 			goto out_err;
 	} else if (is_deleted && origin.dentry && !d_is_dir(origin.dentry)) {
 		/* Lookup deleted overlay inode by origin inode */
-		inode = ovl_lookup_inode(sb, origin.dentry);
+		inode = ovl_lookup_inode(sb, origin.dentry, false);
 		err = -ESTALE;
 		if (!inode || atomic_read(&inode->i_count) == 1)
 			goto out_err;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 8db3f466df60..038a62857580 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -639,15 +639,17 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
 	return true;
 }
 
-struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *origin)
+struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
+			       bool is_upper)
 {
-	struct inode *inode, *key = d_inode(origin);
+	struct inode *inode, *key = d_inode(real);
 
 	inode = ilookup5(sb, (unsigned long) key, ovl_inode_test, key);
 	if (!inode)
 		return NULL;
 
-	if (!ovl_verify_inode(inode, origin, NULL)) {
+	if (!ovl_verify_inode(inode, is_upper ? NULL : real,
+			      is_upper ? real : NULL)) {
 		iput(inode);
 		return ERR_PTR(-ESTALE);
 	}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 7310e0eca383..d06299b27ec3 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -306,7 +306,8 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
-struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *origin);
+struct inode *ovl_lookup_inode(struct super_block *sb, struct dentry *real,
+			       bool is_upper);
 struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 			    struct dentry *lowerdentry, struct dentry *index,
 			    unsigned int numlower);
-- 
2.7.4
