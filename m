From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3] ovl: mark upper merge dir with type origin entries "impure"
Date: Wed, 24 May 2017 15:29:33 +0300
Message-ID: <1495628973-12099-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:36727 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1760126AbdEXM3T (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 24 May 2017 08:29:19 -0400
Received: by mail-wr0-f193.google.com with SMTP id v42so9612107wrc.3
        for <linux-unionfs@vger.kernel.org>; Wed, 24 May 2017 05:29:18 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

An upper dir is marked "impure" to let ovl_iterate() know that this
directory may contain non pure upper entries whose d_ino may need to be
read from the origin inode.

We already mark a non-merge dir "impure" when moving a non-pure child
entry inside it, to let ovl_iterate() know not to iterate the non-merge
dir directly.

Mark also a merge dir "impure" when moving a non-pure child entry inside
it and when copying up a child entry inside it.

This can be used to optimize ovl_iterate() to perform a "pure merge" of
upper and lower directories, merging the content of the directories,
without having to read d_ino from origin inodes.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  7 +++++++
 fs/overlayfs/dir.c       | 31 ++++++-------------------------
 fs/overlayfs/namei.c     | 20 --------------------
 fs/overlayfs/overlayfs.h | 14 +++++++++++---
 fs/overlayfs/super.c     |  5 ++++-
 fs/overlayfs/util.c      | 31 +++++++++++++++++++++++++++++++
 6 files changed, 59 insertions(+), 49 deletions(-)


Miklos,

Please consider this patch for v4.12-rc3 on top of the one already in
overlayfs-next.

Not sure how common the use case of "pure merge" is, but the optimization
of not doing the origin lookup in ovl_interate() is trivial [1], so better
have the merge dir marked "impure" now when introducing overlay.origin.

Amir.

v3:
- Fix bug that slipped into ovl_check_dir_xattr() in v1

v2:
- Check on mount if upper dir is impure
- Tested the optimization [1] with consistent st_ino/d_ino patch

[1] https://github.com/amir73il/linux/blob/ovl-constino/fs/overlayfs/readdir.c#L413

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 843ed2a..1ae1790 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -459,6 +459,13 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	ovl_path_upper(parent, &parentpath);
 	upperdir = parentpath.dentry;
 
+	/* Mark parent "impure" because it may now contain non-pure upper */
+	if (!ovl_dentry_is_impure(parent)) {
+		err = ovl_set_impure(parent, upperdir);
+		if (err)
+			return err;
+	}
+
 	err = vfs_getattr(&parentpath, &pstat,
 			  STATX_ATIME | STATX_MTIME, AT_STATX_SYNC_AS_STAT);
 	if (err)
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f2a118b..c9efc54 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -149,22 +149,6 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
 	return ovl_set_opaque_xerr(dentry, upperdentry, -EIO);
 }
 
-static int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
-{
-	int err;
-
-	/*
-	 * Do not fail when upper doesn't support xattrs.
-	 * Upper inodes won't have origin nor redirect xattr anyway.
-	 */
-	err = ovl_check_setxattr(dentry, upperdentry, OVL_XATTR_IMPURE,
-				 "y", 1, 0);
-	if (!err)
-		ovl_dentry_set_impure(dentry);
-
-	return err;
-}
-
 /* Common operations required to be done after creation of file on upper */
 static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
 			    struct dentry *newdentry, bool hardlink)
@@ -976,21 +960,18 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	if (!samedir) {
 		/*
 		 * When moving a merge dir or non-dir with copy up origin into
-		 * a non-merge upper dir (a.k.a pure upper dir), we are making
-		 * the target parent dir "impure". ovl_iterate() iterates pure
-		 * upper dirs directly, because there is no need to filter out
-		 * whiteouts and merge dir content with lower dir. But for the
-		 * case of an "impure" upper dir, ovl_iterate() cannot iterate
-		 * the real directory directly, because it looks for the inode
-		 * numbers to fill d_ino in the entries origin inode.
+		 * a new parent, we are marking the new parent dir "impure".
+		 * When ovl_iterate() iterates an "impure" upper dir, it will
+		 * lookup the origin inodes of the entries to fill d_ino.
 		 */
-		if (ovl_type_origin(old) && !ovl_type_merge(new->d_parent)) {
+		if (ovl_type_origin(old) &&
+		    !ovl_dentry_is_impure(new->d_parent)) {
 			err = ovl_set_impure(new->d_parent, new_upperdir);
 			if (err)
 				goto out_revert_creds;
 		}
 		if (!overwrite && ovl_type_origin(new) &&
-		    !ovl_type_merge(old->d_parent)) {
+		    !ovl_dentry_is_impure(old->d_parent)) {
 			err = ovl_set_impure(old->d_parent, old_upperdir);
 			if (err)
 				goto out_revert_creds;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 0c72a59..f3136c3 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -167,31 +167,11 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	goto out;
 }
 
-static bool ovl_check_dir_xattr(struct dentry *dentry, const char *name)
-{
-	int res;
-	char val;
-
-	if (!d_is_dir(dentry))
-		return false;
-
-	res = vfs_getxattr(dentry, name, &val, 1);
-	if (res == 1 && val == 'y')
-		return true;
-
-	return false;
-}
-
 static bool ovl_is_opaquedir(struct dentry *dentry)
 {
 	return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
 }
 
-static bool ovl_is_impuredir(struct dentry *dentry)
-{
-	return ovl_check_dir_xattr(dentry, OVL_XATTR_IMPURE);
-}
-
 static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 			     const char *name, unsigned int namelen,
 			     size_t prelen, const char *post,
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index a9fb958..a2ca3d615 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -221,6 +221,17 @@ bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry);
 void ovl_copy_up_end(struct dentry *dentry);
+bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
+int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
+		       const char *name, const void *value, size_t size,
+		       int xerr);
+int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
+
+static inline bool ovl_is_impuredir(struct dentry *dentry)
+{
+	return ovl_check_dir_xattr(dentry, OVL_XATTR_IMPURE);
+}
+
 
 /* namei.c */
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path);
@@ -281,6 +292,3 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
-int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
-		       const char *name, const void *value, size_t size,
-		       int xerr);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f164762..4882ffb 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -974,7 +974,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	path_put(&workpath);
 	kfree(lowertmp);
 
-	oe->__upperdentry = upperpath.dentry;
+	if (upperpath.dentry) {
+		oe->__upperdentry = upperpath.dentry;
+		oe->impure = ovl_is_impuredir(upperpath.dentry);
+	}
 	for (i = 0; i < numlower; i++) {
 		oe->lowerstack[i].dentry = stack[i].dentry;
 		oe->lowerstack[i].mnt = ufs->lower_mnt[i];
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index e0dfb07..d8ce448 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -311,6 +311,21 @@ void ovl_copy_up_end(struct dentry *dentry)
 	spin_unlock(&ofs->copyup_wq.lock);
 }
 
+bool ovl_check_dir_xattr(struct dentry *dentry, const char *name)
+{
+	int res;
+	char val;
+
+	if (!d_is_dir(dentry))
+		return false;
+
+	res = vfs_getxattr(dentry, name, &val, 1);
+	if (res == 1 && val == 'y')
+		return true;
+
+	return false;
+}
+
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       const char *name, const void *value, size_t size,
 		       int xerr)
@@ -331,3 +346,19 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 
 	return err;
 }
+
+int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
+{
+	int err;
+
+	/*
+	 * Do not fail when upper doesn't support xattrs.
+	 * Upper inodes won't have origin nor redirect xattr anyway.
+	 */
+	err = ovl_check_setxattr(dentry, upperdentry, OVL_XATTR_IMPURE,
+				 "y", 1, 0);
+	if (!err)
+		ovl_dentry_set_impure(dentry);
+
+	return err;
+}
-- 
2.7.4
