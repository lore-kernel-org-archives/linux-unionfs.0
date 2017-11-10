From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: take lower dir inode mutex outside upper sb_writers lock
Date: Fri, 10 Nov 2017 13:18:07 +0200
Message-ID: <1510312687-9680-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:45907 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750835AbdKJLRX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 10 Nov 2017 06:17:23 -0500
Received: by mail-wr0-f195.google.com with SMTP id y9so8302434wrb.2
        for <linux-unionfs@vger.kernel.org>; Fri, 10 Nov 2017 03:17:23 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

The functions ovl_lower_positive() and ovl_check_empty_dir() both take
inode mutex on the real lower dir under ovl_want_write() which takes
the upper_mnt sb_writers lock.

While this is not a clear locking order or layering violation, it creates
an undesired lock dependency between two unrelated layers for no good
reason.

This lock dependency materializes to a false(?) positive lockdep warning
when calling rmdir() on a nested overlayfs, where both nested and
underlying overlayfs both use the same fs type as upper layer.

rmdir() on the nested overlayfs creates the lock chain:
  sb_writers of upper_mnt (e.g. tmpfs) in ovl_do_remove()
  ovl_i_mutex_dir_key[] of lower overlay dir in ovl_lower_positive()

rmdir() on the underlying overlayfs creates the lock chain in
reverse order:
  ovl_i_mutex_dir_key[] of lower overlay dir in vfs_rmdir()
  sb_writers of nested upper_mnt (e.g. tmpfs) in ovl_do_remove()

To rid of the unneeded locking dependency, move both ovl_lower_positive()
and ovl_check_empty_dir() to before ovl_want_write() in rmdir() and
rename() implementation.

This change spreads the pieces of ovl_check_empty_and_clear() directly
inside the rmdir()/rename() implementations so the helper is no longer
needed and removed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Please consider this patch for v4.15.

I bumped into the lockdep warning while testing file handles on nested
overlay and had to work around it by using different type of fs for the
lower-upper(xfs) and the upper-upper(tmpfs).

The workaround doesn't suffice if there is another test mounting an overlay
with the same fs type used for upper-upper (e.g. unionmount-testsuite)
at the same machine boot, which happens on my automated testing.

So fixing this removes a false positive from my automated testing.

Thanks,
Amir.

 fs/overlayfs/dir.c     | 117 ++++++++++++++++++++++---------------------------
 fs/overlayfs/namei.c   |   3 ++
 fs/overlayfs/readdir.c |   3 ++
 3 files changed, 58 insertions(+), 65 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index e13921824c70..a91daa5ab857 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -181,11 +181,6 @@ static bool ovl_type_origin(struct dentry *dentry)
 	return OVL_TYPE_ORIGIN(ovl_path_type(dentry));
 }
 
-static bool ovl_may_have_whiteouts(struct dentry *dentry)
-{
-	return ovl_test_flag(OVL_WHITEOUTS, d_inode(dentry));
-}
-
 static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 			    struct cattr *attr, struct dentry *hardlink)
 {
@@ -301,37 +296,6 @@ static struct dentry *ovl_clear_empty(struct dentry *dentry,
 	return ERR_PTR(err);
 }
 
-static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
-{
-	int err;
-	struct dentry *ret = NULL;
-	LIST_HEAD(list);
-
-	err = ovl_check_empty_dir(dentry, &list);
-	if (err) {
-		ret = ERR_PTR(err);
-		goto out_free;
-	}
-
-	/*
-	 * When removing an empty opaque directory, then it makes no sense to
-	 * replace it with an exact replica of itself.
-	 *
-	 * If upperdentry has whiteouts, clear them.
-	 *
-	 * Can race with copy-up, since we don't hold the upperdir mutex.
-	 * Doesn't matter, since copy-up can't create a non-empty directory
-	 * from an empty one.
-	 */
-	if (!list_empty(&list))
-		ret = ovl_clear_empty(dentry, &list);
-
-out_free:
-	ovl_cache_free(&list);
-
-	return ret;
-}
-
 static int ovl_set_upper_acl(struct dentry *upperdentry, const char *name,
 			     const struct posix_acl *acl)
 {
@@ -623,7 +587,8 @@ static bool ovl_matches_upper(struct dentry *dentry, struct dentry *upper)
 	return d_inode(ovl_dentry_upper(dentry)) == d_inode(upper);
 }
 
-static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
+static int ovl_remove_and_whiteout(struct dentry *dentry,
+				   struct list_head *list)
 {
 	struct dentry *workdir = ovl_workdir(dentry);
 	struct inode *wdir = workdir->d_inode;
@@ -638,8 +603,8 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 	if (WARN_ON(!workdir))
 		return -EROFS;
 
-	if (is_dir) {
-		opaquedir = ovl_check_empty_and_clear(dentry);
+	if (!list_empty(list)) {
+		opaquedir = ovl_clear_empty(dentry, list);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir))
 			goto out;
@@ -694,7 +659,8 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 	goto out_d_drop;
 }
 
-static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
+static int ovl_remove_upper(struct dentry *dentry, bool is_dir,
+			    struct list_head *list)
 {
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
 	struct inode *dir = upperdir->d_inode;
@@ -702,10 +668,8 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 	struct dentry *opaquedir = NULL;
 	int err;
 
-	/* Redirect/origin dir can be !ovl_lower_positive && not clean */
-	if (is_dir && (ovl_dentry_get_redirect(dentry) ||
-		       ovl_may_have_whiteouts(dentry))) {
-		opaquedir = ovl_check_empty_and_clear(dentry);
+	if (!list_empty(list)) {
+		opaquedir = ovl_clear_empty(dentry, list);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir))
 			goto out;
@@ -746,11 +710,26 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 	return err;
 }
 
+static bool ovl_pure_upper(struct dentry *dentry)
+{
+	return !ovl_dentry_lower(dentry) &&
+	       !ovl_test_flag(OVL_WHITEOUTS, d_inode(dentry));
+}
+
 static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 {
 	int err;
 	bool locked = false;
 	const struct cred *old_cred;
+	bool lower_positive = ovl_lower_positive(dentry);
+	LIST_HEAD(list);
+
+	/* No need to clean pure upper removed by vfs_rmdir() */
+	if (is_dir && (lower_positive || !ovl_pure_upper(dentry))) {
+		err = ovl_check_empty_dir(dentry, &list);
+		if (err)
+			goto out;
+	}
 
 	err = ovl_want_write(dentry);
 	if (err)
@@ -765,10 +744,10 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 		goto out_drop_write;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
-	if (!ovl_lower_positive(dentry))
-		err = ovl_remove_upper(dentry, is_dir);
+	if (!lower_positive)
+		err = ovl_remove_upper(dentry, is_dir, &list);
 	else
-		err = ovl_remove_and_whiteout(dentry, is_dir);
+		err = ovl_remove_and_whiteout(dentry, &list);
 	revert_creds(old_cred);
 	if (!err) {
 		if (is_dir)
@@ -780,6 +759,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 out_drop_write:
 	ovl_drop_write(dentry);
 out:
+	ovl_cache_free(&list);
 	return err;
 }
 
@@ -914,6 +894,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	bool samedir = olddir == newdir;
 	struct dentry *opaquedir = NULL;
 	const struct cred *old_cred = NULL;
+	LIST_HEAD(list);
 
 	err = -EINVAL;
 	if (flags & ~(RENAME_EXCHANGE | RENAME_NOREPLACE))
@@ -928,6 +909,27 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	if (!overwrite && !ovl_can_move(new))
 		goto out;
 
+	if (overwrite && new_is_dir && !ovl_pure_upper(new)) {
+		err = ovl_check_empty_dir(new, &list);
+		if (err)
+			goto out;
+	}
+
+	if (overwrite) {
+		if (ovl_lower_positive(old)) {
+			if (!ovl_dentry_is_whiteout(new)) {
+				/* Whiteout source */
+				flags |= RENAME_WHITEOUT;
+			} else {
+				/* Switch whiteouts */
+				flags |= RENAME_EXCHANGE;
+			}
+		} else if (is_dir && ovl_dentry_is_whiteout(new)) {
+			flags |= RENAME_EXCHANGE;
+			cleanup_whiteout = true;
+		}
+	}
+
 	err = ovl_want_write(old);
 	if (err)
 		goto out;
@@ -951,9 +953,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 
 	old_cred = ovl_override_creds(old->d_sb);
 
-	if (overwrite && new_is_dir && (ovl_type_merge_or_lower(new) ||
-					ovl_may_have_whiteouts(new))) {
-		opaquedir = ovl_check_empty_and_clear(new);
+	if (!list_empty(&list)) {
+		opaquedir = ovl_clear_empty(new, &list);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir)) {
 			opaquedir = NULL;
@@ -961,21 +962,6 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		}
 	}
 
-	if (overwrite) {
-		if (ovl_lower_positive(old)) {
-			if (!ovl_dentry_is_whiteout(new)) {
-				/* Whiteout source */
-				flags |= RENAME_WHITEOUT;
-			} else {
-				/* Switch whiteouts */
-				flags |= RENAME_EXCHANGE;
-			}
-		} else if (is_dir && ovl_dentry_is_whiteout(new)) {
-			flags |= RENAME_EXCHANGE;
-			cleanup_whiteout = true;
-		}
-	}
-
 	old_upperdir = ovl_dentry_upper(old->d_parent);
 	new_upperdir = ovl_dentry_upper(new->d_parent);
 
@@ -1093,6 +1079,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	ovl_drop_write(old);
 out:
 	dput(opaquedir);
+	ovl_cache_free(&list);
 	return err;
 }
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 625ed8066570..b6564f1a6d48 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -758,6 +758,7 @@ bool ovl_lower_positive(struct dentry *dentry)
 	struct ovl_entry *oe = dentry->d_fsdata;
 	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
 	const struct qstr *name = &dentry->d_name;
+	const struct cred *old_cred;
 	unsigned int i;
 	bool positive = false;
 	bool done = false;
@@ -773,6 +774,7 @@ bool ovl_lower_positive(struct dentry *dentry)
 	if (!ovl_dentry_upper(dentry))
 		return true;
 
+	old_cred = ovl_override_creds(dentry->d_sb);
 	/* Positive upper -> have to look up lower to see whether it exists */
 	for (i = 0; !done && !positive && i < poe->numlower; i++) {
 		struct dentry *this;
@@ -802,6 +804,7 @@ bool ovl_lower_positive(struct dentry *dentry)
 			dput(this);
 		}
 	}
+	revert_creds(old_cred);
 
 	return positive;
 }
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 77d2027fe5aa..06d7be6799b2 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -860,8 +860,11 @@ int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
 	int err;
 	struct ovl_cache_entry *p, *n;
 	struct rb_root root = RB_ROOT;
+	const struct cred *old_cred;
 
+	old_cred = ovl_override_creds(dentry->d_sb);
 	err = ovl_dir_read_merged(dentry, list, &root);
+	revert_creds(old_cred);
 	if (err)
 		return err;
 
-- 
2.7.4
