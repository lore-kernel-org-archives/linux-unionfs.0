From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 6/6] ovl: link upper tempfile on open for write
Date: Wed, 29 Mar 2017 17:36:06 +0300
Message-ID: <1490798166-22310-7-git-send-email-amir73il@gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34919 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751919AbdC2OgL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Mar 2017 10:36:11 -0400
Received: by mail-wr0-f196.google.com with SMTP id p52so3563132wrc.2
        for <linux-unionfs@vger.kernel.org>; Wed, 29 Mar 2017 07:36:09 -0700 (PDT)
In-Reply-To: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

With consistent_fd feature enabled, after copy up on open for read,
upperdentry remains an unlinked tmpfile.
On first open for write, temp upperdentry is linked to upper dir.

This keeps the file system inode allocated for as long as there are open
file descriptors and until overlay inode is evicted from cache.
After force reboot, file system will cleanup all temporary allocated
inodes (orphans).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 74 ++++++++++++++++++++++++++++++++++++++++++------
 fs/overlayfs/inode.c     | 26 ++++++++++++-----
 fs/overlayfs/overlayfs.h |  5 +++-
 fs/overlayfs/ovl_entry.h | 10 ++++++-
 fs/overlayfs/super.c     |  7 +++++
 fs/overlayfs/util.c      | 27 ++++++++++++++++--
 6 files changed, 129 insertions(+), 20 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 3053e33..09ed60f 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -321,14 +321,14 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out_cleanup;
 
-	if (tmpfile)
-		err = ovl_do_link(temp, udir, upper, true);
-	else
+	if (!tmpfile)
 		err = ovl_do_rename(wdir, temp, udir, upper, 0);
+	else if (stat->nlink)
+		err = ovl_do_link(temp, udir, upper, true);
 	if (err)
 		goto out_cleanup;
 
-	newdentry = dget(tmpfile ? upper : temp);
+	newdentry = dget((tmpfile && stat->nlink) ? upper : temp);
 	ovl_dentry_update(dentry, newdentry);
 	ovl_inode_update(d_inode(dentry), d_inode(newdentry));
 
@@ -348,6 +348,43 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 }
 
 /*
+ * Link a temp upperdentry to upper dir
+ *
+ * After copy up on open for read, upperdentry remains unlinked.
+ * On first copy up on open for write upperdentry should be linked.
+ */
+static int ovl_link_ro_upper(struct dentry *upperdir, struct dentry *dentry,
+			     struct dentry *temp, struct kstat *stat,
+			     struct kstat *pstat)
+{
+	struct dentry *upper = NULL;
+	int err;
+
+	upper = lookup_one_len(dentry->d_name.name, upperdir,
+			       dentry->d_name.len);
+	err = PTR_ERR(upper);
+	if (IS_ERR(upper))
+		goto out;
+
+	err = ovl_do_link(temp, upperdir->d_inode, upper, true);
+	if (err)
+		goto out_dput;
+
+	/* inode is already hashed. only need to update upperdentry */
+	ovl_dentry_update(dentry, upper);
+
+	/* Restore timestamps on parent (best effort) */
+	ovl_set_timestamps(upperdir, pstat);
+
+	return err;
+
+out_dput:
+	dput(upper);
+out:
+	return err;
+}
+
+/*
  * Copy up a single dentry
  *
  * All renames start with copy up of source if necessary.  The actual
@@ -366,6 +403,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	struct path parentpath;
 	struct dentry *lowerdentry = lowerpath->dentry;
 	struct dentry *upperdir;
+	struct dentry *temp = NULL;
 	const char *link = NULL;
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 
@@ -388,6 +426,19 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			return PTR_ERR(link);
 	}
 
+	/* Maybe link a ro temp upper dentry on open for write? */
+	if (S_ISREG(stat->mode))
+		temp = ovl_dentry_ro_upper(dentry);
+	if (temp) {
+		inode_lock_nested(upperdir->d_inode, I_MUTEX_PARENT);
+		/* Make sure we did not race with another temp link */
+		if (likely(!ovl_dentry_upper(dentry)))
+			err = ovl_link_ro_upper(upperdir, dentry, temp, stat,
+						&pstat);
+		inode_unlock(upperdir->d_inode);
+		goto out_done;
+	}
+
 	/* Should we copyup with O_TMPFILE or with workdir? */
 	if (S_ISREG(stat->mode) && ofs->tmpfile) {
 		err = ovl_copy_up_start(dentry);
@@ -428,7 +479,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	return err;
 }
 
-int ovl_copy_up_flags(struct dentry *dentry, int flags)
+int ovl_copy_up_flags(struct dentry *dentry, int flags, bool rocopyup)
 {
 	int err = 0;
 	const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
@@ -440,7 +491,8 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 		struct kstat stat;
 		enum ovl_path_type type = ovl_path_type(dentry);
 
-		if (OVL_TYPE_UPPER(type))
+		if (OVL_TYPE_UPPER(type) ||
+		    (rocopyup && OVL_TYPE_RO_UPPER(type)))
 			break;
 
 		next = dget(dentry);
@@ -459,9 +511,15 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 		ovl_path_lower(next, &lowerpath);
 		err = vfs_getattr(&lowerpath, &stat,
 				  STATX_BASIC_STATS, AT_STATX_SYNC_AS_STAT);
-		/* maybe truncate regular file. this has no effect on dirs */
+		/*
+		 * maybe truncate regular file and maybe copy up as unlinked
+		 * tempfile for readonly open. this has no effect on dirs.
+		 */
+		WARN_ON(stat.nlink == 0);
 		if (flags & O_TRUNC)
 			stat.size = 0;
+		else if (rocopyup)
+			stat.nlink = 0;
 		if (!err)
 			err = ovl_copy_up_one(parent, next, &lowerpath, &stat);
 
@@ -475,5 +533,5 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 
 int ovl_copy_up(struct dentry *dentry)
 {
-	return ovl_copy_up_flags(dentry, 0);
+	return ovl_copy_up_flags(dentry, 0, false);
 }
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index f2f55e1..2fb90be 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -230,8 +230,15 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
 	return acl;
 }
 
+/*
+ * Depending on open flags and overlay dentry type, determines if file needs
+ * to be copied up on open.  If *rocopyup is true, then files needs to be
+ * copied up to unlinked tmpfiles on open for read.  If this file has already
+ * been copied up to unlinked tmpfile or if this is an open for write, then
+ * *rocopyup will be set to false.
+ */
 static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
-				  struct dentry *realdentry, bool rocopyup)
+				  struct dentry *realdentry, bool *rocopyup)
 {
 	if (OVL_TYPE_UPPER(type))
 		return false;
@@ -239,13 +246,17 @@ static bool ovl_open_need_copy_up(int flags, enum ovl_path_type type,
 	if (special_file(realdentry->d_inode->i_mode))
 		return false;
 
-	/* Copy up on open for read for consistent fd */
-	if (rocopyup)
-		return true;
+	/* Need copy up to unlinked tmpfile on open for read? */
+	if (*rocopyup &&
+	    (!S_ISREG(realdentry->d_inode->i_mode) ||
+	     OVL_TYPE_RO_UPPER(type)))
+		*rocopyup = false;
 
 	if (!(OPEN_FMODE(flags) & FMODE_WRITE) && !(flags & O_TRUNC))
-		return false;
+		return *rocopyup;
 
+	/* Open for write - need properly linked copy up */
+	*rocopyup = false;
 	return true;
 }
 
@@ -256,12 +267,13 @@ int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags,
 	struct path realpath;
 	enum ovl_path_type type = ovl_path_real(dentry, &realpath);
 
-	if (!ovl_open_need_copy_up(file_flags, type, realpath.dentry, rocopyup))
+	if (!ovl_open_need_copy_up(file_flags, type, realpath.dentry,
+				   &rocopyup))
 		return 0;
 
 	err = ovl_want_write(dentry);
 	if (!err) {
-		err = ovl_copy_up_flags(dentry, file_flags);
+		err = ovl_copy_up_flags(dentry, file_flags, rocopyup);
 		ovl_drop_write(dentry);
 	}
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d13ad5f..cc76197 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -13,11 +13,13 @@ enum ovl_path_type {
 	__OVL_PATH_UPPER	= (1 << 0),
 	__OVL_PATH_MERGE	= (1 << 1),
 	__OVL_PATH_OPAQUE	= (1 << 2),
+	__OVL_PATH_RO_UPPER	= (1 << 3),
 };
 
 #define OVL_TYPE_UPPER(type)	((type) & __OVL_PATH_UPPER)
 #define OVL_TYPE_MERGE(type)	((type) & __OVL_PATH_MERGE)
 #define OVL_TYPE_OPAQUE(type)	((type) & __OVL_PATH_OPAQUE)
+#define OVL_TYPE_RO_UPPER(type)	((type) & __OVL_PATH_RO_UPPER)
 
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
@@ -162,6 +164,7 @@ void ovl_path_upper(struct dentry *dentry, struct path *path);
 void ovl_path_lower(struct dentry *dentry, struct path *path);
 enum ovl_path_type ovl_path_real(struct dentry *dentry, struct path *path);
 struct dentry *ovl_dentry_upper(struct dentry *dentry);
+struct dentry *ovl_dentry_ro_upper(struct dentry *dentry);
 struct dentry *ovl_dentry_lower(struct dentry *dentry);
 struct dentry *ovl_dentry_real(struct dentry *dentry);
 struct ovl_dir_cache *ovl_dir_cache(struct dentry *dentry);
@@ -240,6 +243,6 @@ void ovl_cleanup(struct inode *dir, struct dentry *dentry);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
-int ovl_copy_up_flags(struct dentry *dentry, int flags);
+int ovl_copy_up_flags(struct dentry *dentry, int flags, bool rocopyup);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index c11a72d..87ade0b 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -40,7 +40,10 @@ enum ovl_path_type;
 /* private information held for every overlayfs dentry */
 struct ovl_entry {
 	struct dentry *__upperdentry;
-	struct ovl_dir_cache *cache;
+	union {
+		struct dentry *__roupperdentry; /* regular file */
+		struct ovl_dir_cache *cache; /* directory */
+	};
 	union {
 		struct {
 			u64 version;
@@ -60,3 +63,8 @@ static inline struct dentry *ovl_upperdentry_dereference(struct ovl_entry *oe)
 {
 	return lockless_dereference(oe->__upperdentry);
 }
+
+static inline struct dentry *ovl_roupperdentry_dereference(struct ovl_entry *oe)
+{
+	return lockless_dereference(oe->__roupperdentry);
+}
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e5fd53a..ef159f8 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -47,6 +47,7 @@ static void ovl_dentry_release(struct dentry *dentry)
 		unsigned int i;
 
 		dput(oe->__upperdentry);
+		dput(oe->__roupperdentry);
 		kfree(oe->redirect);
 		for (i = 0; i < oe->numlower; i++)
 			dput(oe->lowerstack[i].dentry);
@@ -84,6 +85,12 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	if (real && (!inode || inode == d_inode(real)))
 		return real;
 
+	if (rocopyup) {
+		real = ovl_dentry_ro_upper(dentry);
+		if (real)
+			return real;
+	}
+
 	real = ovl_dentry_lower(dentry);
 	if (!real)
 		goto bug;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index be0a993..00cd2d6 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -90,12 +90,14 @@ enum ovl_path_type ovl_update_type(struct dentry *dentry)
 		type |= __OVL_PATH_UPPER;
 		if (oe->numlower)
 			type |= __OVL_PATH_MERGE;
+	} else if (oe->__roupperdentry) {
+		type |= __OVL_PATH_RO_UPPER;
 	} else {
 		if (oe->numlower > 1)
 			type |= __OVL_PATH_MERGE;
 	}
 	/*
-	 * Make sure type is consistent with __upperdentry before making it
+	 * Make sure type is consistent with __[ro]upperdentry before making it
 	 * visible to ovl_path_type().
 	 */
 	smp_wmb();
@@ -138,6 +140,13 @@ struct dentry *ovl_dentry_upper(struct dentry *dentry)
 	return ovl_upperdentry_dereference(oe);
 }
 
+struct dentry *ovl_dentry_ro_upper(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	return ovl_roupperdentry_dereference(oe);
+}
+
 static struct dentry *__ovl_dentry_lower(struct ovl_entry *oe)
 {
 	return oe->numlower ? oe->lowerstack[0].dentry : NULL;
@@ -231,18 +240,30 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
 	oe->redirect = redirect;
 }
 
+/*
+ * May be called up to twice in the lifetime of an overlay dentry -
+ * the first time when updating a ro upper dentry with a tempfile (nlink == 0)
+ * and the second time when updating a linked upper dentry (nlink > 0).
+ * Linked upper must have the same inode as the temp ro upper.
+ */
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
+	struct inode *inode = upperdentry->d_inode;
 
 	WARN_ON(!inode_is_locked(upperdentry->d_parent->d_inode));
 	WARN_ON(oe->__upperdentry);
+	if (WARN_ON(!inode))
+		return;
 	/*
 	 * Make sure upperdentry is consistent before making it visible to
-	 * ovl_upperdentry_dereference().
+	 * ovl_[ro]upperdentry_dereference()
 	 */
 	smp_wmb();
-	oe->__upperdentry = upperdentry;
+	if (inode->i_nlink)
+		oe->__upperdentry = upperdentry;
+	else
+		oe->__roupperdentry = upperdentry;
 	ovl_update_type(dentry);
 }
 
-- 
2.7.4
