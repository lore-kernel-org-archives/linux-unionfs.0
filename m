Return-Path: <vgoyal@redhat.com>
Date: Fri, 11 May 2018 10:30:41 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v15 10/30] ovl: Modify ovl_lookup() and friends to lookup
 metacopy dentry
Message-ID: <20180511143041.GB6044@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
 <20180507174102.24086-11-vgoyal@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180507174102.24086-11-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Miklos, Amir,

Please find attached V2 of the patch. I have taken care of comments. I
have again pushed latest patches on metacopy-next branch.

https://github.com/rhvgoyal/linux/commits/metacopy-next

Changes:
- Use EIO instead of ESTALE at few places.
- Make sure metacopy dentry or data dentry is a regular file.
- Modified ovl_lookup_single() for better error handling of bad
  redirects (Miklos's feedback).
- In ovl_lookup(), for non-dir, if lower does not match against ORIGIN,
  then we error out only if index=on. Otherwise we continue to use the
  dentry found by path based lookup.

Thanks
Vivek

Subject: ovl: Modify ovl_lookup() and friends to lookup metacopy dentry

This patch modifies ovl_lookup() and friends to lookup metacopy dentries.
It also allows for presence of metacopy dentries in lower layer.

During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
set OVL_UPPERDATA bit in flags.

We don't support metacopy feature with nfs_export. So in nfs_export code,
we set OVL_UPPERDATA flag set unconditionally if upper inode exists.

Do not follow metacopy origin if we find a metacopy only inode and metacopy
feature is not enabled for that mount. Like redirect, this can have security
implications where an attacker could hand craft upper and try to gain
access to file on lower which it should not have to begin with. 

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    |    3 +
 fs/overlayfs/inode.c     |   11 +++-
 fs/overlayfs/namei.c     |  125 ++++++++++++++++++++++++++++++++++++++++-------
 fs/overlayfs/overlayfs.h |    1 
 fs/overlayfs/util.c      |   22 ++++++++
 5 files changed, 143 insertions(+), 19 deletions(-)

Index: rhvgoyal-linux/fs/overlayfs/namei.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/namei.c	2018-05-10 15:53:00.858878145 -0400
+++ rhvgoyal-linux/fs/overlayfs/namei.c	2018-05-11 09:17:38.751646662 -0400
@@ -24,6 +24,7 @@ struct ovl_lookup_data {
 	bool stop;
 	bool last;
 	char *redirect;
+	bool metacopy;
 };
 
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
@@ -253,19 +254,33 @@ static int ovl_lookup_single(struct dent
 		goto put_and_out;
 	}
 	if (!d_can_lookup(this)) {
-		d->stop = true;
-		if (d->is_dir)
+		if (d->is_dir || !last_element) {
+			d->stop = true;
 			goto put_and_out;
-
+		}
+		err = ovl_check_metacopy_xattr(this);
+		if (err < 0)
+			goto out_err;
 		/*
-		 * NB: handle failure to lookup non-last element when non-dir
-		 * redirects become possible
+		 * This dentry should be a regular file if this is
+		 * a metacopy dentry or previous layer lookup found
+		 * a metacopy dentry.
 		 */
-		WARN_ON(!last_element);
+		if ((err || d->metacopy) && !d_is_reg(this)) {
+			d->stop = true;
+			goto put_and_out;
+		}
+		d->stop = !err;
+		d->metacopy = !!err;
 		goto out;
 	}
-	if (last_element)
+	if (last_element) {
+		if (d->metacopy) {
+			d->stop = true;
+			goto put_and_out;
+		}
 		d->is_dir = true;
+	}
 	if (d->last)
 		goto out;
 
@@ -823,7 +838,7 @@ struct dentry *ovl_lookup(struct inode *
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
-	struct ovl_path *stack = NULL;
+	struct ovl_path *stack = NULL, *origin_path = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
 	struct dentry *origin = NULL;
 	struct dentry *index = NULL;
@@ -834,6 +849,7 @@ struct dentry *ovl_lookup(struct inode *
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	bool metacopy = false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
 		.is_dir = false,
@@ -841,6 +857,7 @@ struct dentry *ovl_lookup(struct inode *
 		.stop = false,
 		.last = ofs->config.redirect_follow ? false : !poe->numlower,
 		.redirect = NULL,
+		.metacopy = false,
 	};
 
 	if (dentry->d_name.len > ofs->namelen)
@@ -859,7 +876,8 @@ struct dentry *ovl_lookup(struct inode *
 			goto out;
 		}
 		if (upperdentry && !d.is_dir) {
-			BUG_ON(!d.stop || d.redirect);
+			unsigned int origin_ctr = 0;
+			BUG_ON(d.redirect);
 			/*
 			 * Lookup copy up origin by decoding origin file handle.
 			 * We may get a disconnected dentry, which is fine,
@@ -870,9 +888,13 @@ struct dentry *ovl_lookup(struct inode *
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
@@ -913,7 +935,7 @@ struct dentry *ovl_lookup(struct inode *
 		 * If no origin fh is stored in upper of a merge dir, store fh
 		 * of lower dir and set upper parent "impure".
 		 */
-		if (upperdentry && !ctr && !ofs->noxattr) {
+		if (upperdentry && !ctr && !ofs->noxattr && d.is_dir) {
 			err = ovl_fix_origin(dentry, this, upperdentry);
 			if (err) {
 				dput(this);
@@ -925,16 +947,39 @@ struct dentry *ovl_lookup(struct inode *
 		 * When "verify_lower" feature is enabled, do not merge with a
 		 * lower dir that does not match a stored origin xattr. In any
 		 * case, only verified origin is used for index lookup.
+		 *
+		 * For non-dir dentry, if index=on, then ensure origin
+		 * matches the dentry found using path based lookup,
+		 * otherwise error out. If index=off, then do not error
+		 * out if origin does not match.
 		 */
-		if (upperdentry && !ctr && ovl_verify_lower(dentry->d_sb)) {
+		if (upperdentry && !ctr &&
+		    ((d.is_dir && ovl_verify_lower(dentry->d_sb)) ||
+		     (!d.is_dir && origin_path))) {
 			err = ovl_verify_origin(upperdentry, this, false);
 			if (err) {
-				dput(this);
-				break;
+				if (d.is_dir) {
+					dput(this);
+					break;
+				} else if (ofs->config.index) {
+					dput(this);
+					goto out_put;
+				}
+			} else {
+				/* Bless lower as verified origin */
+				origin = this;
 			}
+		}
 
-			/* Bless lower dir as verified origin */
-			origin = this;
+		if (d.metacopy)
+			metacopy = true;
+		/*
+		 * Do not store intermediate metacopy dentries in chain,
+		 * except top most lower metacopy dentry
+		 */
+		if (d.metacopy && ctr) {
+			dput(this);
+			continue;
 		}
 
 		stack[ctr].dentry = this;
@@ -968,13 +1013,49 @@ struct dentry *ovl_lookup(struct inode *
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
+			pr_warn_ratelimited("overlay: refusing to follow"
+					    " metacopy origin for (%pd2)\n",
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
+	 * or origin did not match, do not set "origin" and skip looking up
+	 * index. This case should be handled in same way as a non-dir upper
+	 * without ORIGIN is handled.
+	 *
+	 * Always lookup index of non-dir non-metacopy and non-upper.
 	 */
-	if (ctr && (!upperdentry || !d.is_dir))
+	if (ctr && (!upperdentry || (!d.is_dir && !metacopy)))
 		origin = stack[0].dentry;
 
 	if (origin && ovl_indexdir(dentry->d_sb) &&
@@ -1019,6 +1100,10 @@ struct dentry *ovl_lookup(struct inode *
 	}
 
 	revert_creds(old_cred);
+	if (origin_path) {
+		dput(origin_path->dentry);
+		kfree(origin_path);
+	}
 	dput(index);
 	kfree(stack);
 	kfree(d.redirect);
@@ -1033,6 +1118,10 @@ out_put:
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
Index: rhvgoyal-linux/fs/overlayfs/export.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/export.c	2018-05-10 15:53:00.836878145 -0400
+++ rhvgoyal-linux/fs/overlayfs/export.c	2018-05-10 15:53:01.054878145 -0400
@@ -317,6 +317,9 @@ static struct dentry *ovl_obtain_alias(s
 		return ERR_CAST(inode);
 	}
 
+	if (upper)
+		ovl_set_flag(OVL_UPPERDATA, inode);
+
 	dentry = d_find_any_alias(inode);
 	if (!dentry) {
 		dentry = d_alloc_anon(inode->i_sb);
Index: rhvgoyal-linux/fs/overlayfs/overlayfs.h
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/overlayfs.h	2018-05-10 15:53:01.007878145 -0400
+++ rhvgoyal-linux/fs/overlayfs/overlayfs.h	2018-05-11 09:17:02.037646662 -0400
@@ -274,6 +274,7 @@ bool ovl_need_index(struct dentry *dentr
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
+int ovl_check_metacopy_xattr(struct dentry *dentry);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
Index: rhvgoyal-linux/fs/overlayfs/inode.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/inode.c	2018-05-10 15:53:01.031878145 -0400
+++ rhvgoyal-linux/fs/overlayfs/inode.c	2018-05-11 09:17:01.656646662 -0400
@@ -771,7 +771,7 @@ struct inode *ovl_get_inode(struct super
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry,
 					oip->index);
 	int fsid = bylower ? oip->lowerpath->layer->fsid : 0;
-	bool is_dir;
+	bool is_dir, metacopy = false;
 	unsigned long ino = 0;
 	int err = -ENOMEM;
 
@@ -831,6 +831,15 @@ struct inode *ovl_get_inode(struct super
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
Index: rhvgoyal-linux/fs/overlayfs/util.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/util.c	2018-05-10 15:53:01.008878145 -0400
+++ rhvgoyal-linux/fs/overlayfs/util.c	2018-05-11 09:17:02.037646662 -0400
@@ -778,3 +778,25 @@ err:
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
