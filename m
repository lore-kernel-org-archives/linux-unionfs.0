From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 09/28] ovl: Modify ovl_lookup() and friends to lookup metacopy dentry
Date: Tue, 29 May 2018 16:45:53 +0200
Message-ID: <20180529144612.16675-10-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

This patch modifies ovl_lookup() and friends to lookup metacopy dentries.
It also allows for presence of metacopy dentries in lower layer.

During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
set OVL_UPPERDATA bit in flags.

We don't support metacopy feature with nfs_export.  So in nfs_export code,
we set OVL_UPPERDATA flag set unconditionally if upper inode exists.

Do not follow metacopy origin if we find a metacopy only inode and metacopy
feature is not enabled for that mount.  Like redirect, this can have
security implications where an attacker could hand craft upper and try to
gain access to file on lower which it should not have to begin with.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/export.c    |   3 ++
 fs/overlayfs/inode.c     |  11 ++++-
 fs/overlayfs/namei.c     | 112 ++++++++++++++++++++++++++++++++++++++++-------
 fs/overlayfs/overlayfs.h |   1 +
 fs/overlayfs/util.c      |  22 ++++++++++
 5 files changed, 131 insertions(+), 18 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 9941ece61a14..8fa37cd7818a 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -317,6 +317,9 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 		return ERR_CAST(inode);
 	}
 
+	if (upper)
+		ovl_set_flag(OVL_UPPERDATA, inode);
+
 	dentry = d_find_any_alias(inode);
 	if (!dentry) {
 		dentry = d_alloc_anon(inode->i_sb);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 0d5615b80422..350e38c5ce7d 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -780,7 +780,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
 					oip->index);
 	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
-	bool is_dir;
+	bool is_dir, metacopy = false;
 	unsigned long ino = 0;
 	int err = -ENOMEM;
 
@@ -839,6 +839,15 @@ struct inode *ovl_get_inode(struct super_block *sb,
 	if (oip->index)
 		ovl_set_flag(OVL_INDEX, inode);
 
+	if (upperdentry) {
+		err = ovl_check_metacopy_xattr(upperdentry);
+		if (err < 0)
+			goto out_err;
+		metacopy = err;
+		if (!metacopy)
+			ovl_set_flag(OVL_UPPERDATA, inode);
+	}
+
 	OVL_I(inode)->redirect = oip->redirect;
 
 	/* Check for non-merge dir that may have whiteouts */
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 54f206485ab8..fcf0eb40d94b 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -24,6 +24,7 @@ struct ovl_lookup_data {
 	bool stop;
 	bool last;
 	char *redirect;
+	bool metacopy;
 };
 
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
@@ -252,16 +253,25 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		d->stop = d->opaque = true;
 		goto put_and_out;
 	}
-	if (!d_can_lookup(this)) {
+	/*
+	 * This dentry should be a regular file if previous layer lookup
+	 * found a metacopy dentry.
+	 */
+	if (last_element && d->metacopy && !d_is_reg(this)) {
 		d->stop = true;
-		if (d->is_dir)
+		goto put_and_out;
+	}
+	if (!d_can_lookup(this)) {
+		if (d->is_dir || !last_element) {
+			d->stop = true;
 			goto put_and_out;
+		}
+		err = ovl_check_metacopy_xattr(this);
+		if (err < 0)
+			goto out_err;
 
-		/*
-		 * NB: handle failure to lookup non-last element when non-dir
-		 * redirects become possible
-		 */
-		WARN_ON(!last_element);
+		d->metacopy = err;
+		d->stop = !d->metacopy;
 		goto out;
 	}
 	if (last_element)
@@ -823,7 +833,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
-	struct ovl_path *stack = NULL;
+	struct ovl_path *stack = NULL, *origin_path = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
 	struct dentry *origin = NULL;
 	struct dentry *index = NULL;
@@ -834,6 +844,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	bool metacopy = false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
 		.is_dir = false,
@@ -841,6 +852,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.stop = false,
 		.last = ofs->config.redirect_follow ? false : !poe->numlower,
 		.redirect = NULL,
+		.metacopy = false,
 	};
 
 	if (dentry->d_name.len > ofs->namelen)
@@ -859,7 +871,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out;
 		}
 		if (upperdentry && !d.is_dir) {
-			BUG_ON(!d.stop || d.redirect);
+			unsigned int origin_ctr = 0;
+
+			BUG_ON(d.redirect);
 			/*
 			 * Lookup copy up origin by decoding origin file handle.
 			 * We may get a disconnected dentry, which is fine,
@@ -870,9 +884,13 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			 * number - it's the same as if we held a reference
 			 * to a dentry in lower layer that was moved under us.
 			 */
-			err = ovl_check_origin(ofs, upperdentry, &stack, &ctr);
+			err = ovl_check_origin(ofs, upperdentry, &origin_path,
+					       &origin_ctr);
 			if (err)
 				goto out_put_upper;
+
+			if (d.metacopy)
+				metacopy = true;
 		}
 
 		if (d.redirect) {
@@ -913,7 +931,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 * If no origin fh is stored in upper of a merge dir, store fh
 		 * of lower dir and set upper parent "impure".
 		 */
-		if (upperdentry && !ctr && !ofs->noxattr) {
+		if (upperdentry && !ctr && !ofs->noxattr && d.is_dir) {
 			err = ovl_fix_origin(dentry, this, upperdentry);
 			if (err) {
 				dput(this);
@@ -925,18 +943,35 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 * When "verify_lower" feature is enabled, do not merge with a
 		 * lower dir that does not match a stored origin xattr. In any
 		 * case, only verified origin is used for index lookup.
+		 *
+		 * For non-dir dentry, if index=on, then ensure origin
+		 * matches the dentry found using path based lookup,
+		 * otherwise error out.
 		 */
-		if (upperdentry && !ctr && ovl_verify_lower(dentry->d_sb)) {
+		if (upperdentry && !ctr &&
+		    ((d.is_dir && ovl_verify_lower(dentry->d_sb)) ||
+		     (!d.is_dir && ofs->config.index && origin_path))) {
 			err = ovl_verify_origin(upperdentry, this, false);
 			if (err) {
 				dput(this);
-				break;
+				if (d.is_dir)
+					break;
+				goto out_put;
 			}
-
-			/* Bless lower dir as verified origin */
 			origin = this;
 		}
 
+		if (d.metacopy)
+			metacopy = true;
+		/*
+		 * Do not store intermediate metacopy dentries in chain,
+		 * except top most lower metacopy dentry
+		 */
+		if (d.metacopy && ctr) {
+			dput(this);
+			continue;
+		}
+
 		stack[ctr].dentry = this;
 		stack[ctr].layer = lower.layer;
 		ctr++;
@@ -968,13 +1003,48 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
+	if (metacopy) {
+		/*
+		 * Found a metacopy dentry but did not find corresponding
+		 * data dentry
+		 */
+		if (d.metacopy) {
+			err = -EIO;
+			goto out_put;
+		}
+
+		err = -EPERM;
+		if (!ofs->config.metacopy) {
+			pr_warn_ratelimited("overlay: refusing to follow metacopy origin for (%pd2)\n",
+					    dentry);
+			goto out_put;
+		}
+	} else if (!d.is_dir && upperdentry && !ctr && origin_path) {
+		if (WARN_ON(stack != NULL)) {
+			err = -EIO;
+			goto out_put;
+		}
+		stack = origin_path;
+		ctr = 1;
+		origin_path = NULL;
+	}
+
 	/*
 	 * Lookup index by lower inode and verify it matches upper inode.
 	 * We only trust dir index if we verified that lower dir matches
 	 * origin, otherwise dir index entries may be inconsistent and we
-	 * ignore them. Always lookup index of non-dir and non-upper.
+	 * ignore them.
+	 *
+	 * For non-dir upper metacopy dentry, we already set "origin" if we
+	 * verified that lower matched upper origin. If upper origin was
+	 * not present (because lower layer did not support fh encode/decode),
+	 * or indexing is not enabled, do not set "origin" and skip looking up
+	 * index. This case should be handled in same way as a non-dir upper
+	 * without ORIGIN is handled.
+	 *
+	 * Always lookup index of non-dir non-metacopy and non-upper.
 	 */
-	if (ctr && (!upperdentry || !d.is_dir))
+	if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
 		origin = stack[0].dentry;
 
 	if (origin && ovl_indexdir(dentry->d_sb) &&
@@ -1019,6 +1089,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	revert_creds(old_cred);
+	if (origin_path) {
+		dput(origin_path->dentry);
+		kfree(origin_path);
+	}
 	dput(index);
 	kfree(stack);
 	kfree(d.redirect);
@@ -1033,6 +1107,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		dput(stack[i].dentry);
 	kfree(stack);
 out_put_upper:
+	if (origin_path) {
+		dput(origin_path->dentry);
+		kfree(origin_path);
+	}
 	dput(upperdentry);
 	kfree(upperredirect);
 out:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 45e4a581a9fe..b1f6591b9af4 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -268,6 +268,7 @@ bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
+int ovl_check_metacopy_xattr(struct dentry *dentry);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f8e3c95711b8..ab9a8fae0f99 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -778,3 +778,25 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
 	pr_err("overlayfs: failed to lock workdir+upperdir\n");
 	return -EIO;
 }
+
+/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
+int ovl_check_metacopy_xattr(struct dentry *dentry)
+{
+	int res;
+
+	/* Only regular files can have metacopy xattr */
+	if (!S_ISREG(d_inode(dentry)->i_mode))
+		return 0;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_METACOPY, NULL, 0);
+	if (res < 0) {
+		if (res == -ENODATA || res == -EOPNOTSUPP)
+			return 0;
+		goto out;
+	}
+
+	return 1;
+out:
+	pr_warn_ratelimited("overlayfs: failed to get metacopy (%i)\n", res);
+	return res;
+}
-- 
2.14.3
