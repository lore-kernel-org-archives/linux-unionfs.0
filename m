Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:38568 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754021AbeCFUyR (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 6 Mar 2018 15:54:17 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v12 08/17] ovl: Modify ovl_lookup() and friends to lookup metacopy dentry
Date: Tue,  6 Mar 2018 15:53:59 -0500
Message-Id: <20180306205408.23383-9-vgoyal@redhat.com>
In-Reply-To: <20180306205408.23383-1-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

This patch modifies ovl_lookup() and friends to lookup metacopy dentries.
It also allows for presence of metacopy dentries in lower layer.

During lookup, check for presence of OVL_XATTR_METACOPY and if not present,
set OVL_UPPERDATA bit in flags.

OVL_UPPERDATA flag is set unconditionally if upper inode exists.

Do not follow metacopy origin if we find a metacopy only inode and metacopy
feature is not enabled for that mount. Like redirect, this can have security
implications where an attacker could hand craft upper and try to gain
access to file on lower which it should not have to begin with.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/export.c |   3 ++
 fs/overlayfs/namei.c  | 121 ++++++++++++++++++++++++++++++++++++++++++++++----
 2 files changed, 115 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index bb94ce9da5c8..35f2d4eb0d7e 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -192,6 +192,9 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 	if (index)
 		ovl_set_flag(OVL_INDEX, inode);
 
+	if (upper)
+		ovl_set_flag(OVL_UPPERDATA, inode);
+
 	dentry = d_find_any_alias(inode);
 	if (!dentry) {
 		dentry = d_alloc_anon(inode->i_sb);
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 70fcfcc684cc..220e754c974b 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -24,6 +24,7 @@ struct ovl_lookup_data {
 	bool stop;
 	bool last;
 	char *redirect;
+	bool metacopy;
 };
 
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
@@ -208,6 +209,28 @@ struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt)
 	return real;
 }
 
+/* err < 0, 0 if no metacopy xattr, 1 if metacopy xattr found */
+static int ovl_check_metacopy_xattr(struct dentry *dentry)
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
+
 static bool ovl_is_opaquedir(struct dentry *dentry)
 {
 	return ovl_check_dir_xattr(dentry, OVL_XATTR_OPAQUE);
@@ -242,9 +265,16 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		goto put_and_out;
 	}
 	if (!d_can_lookup(this)) {
-		d->stop = true;
 		if (d->is_dir)
 			goto put_and_out;
+		err = ovl_check_metacopy_xattr(this);
+		if (err < 0)
+			goto out_err;
+		if (!err) {
+			d->stop = true;
+			d->metacopy = false;
+		} else
+			d->metacopy = true;
 		goto out;
 	}
 	d->is_dir = true;
@@ -799,7 +829,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
-	struct ovl_path *stack = NULL;
+	struct ovl_path *stack = NULL, *origin_path = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
 	struct dentry *origin = NULL;
 	struct dentry *index = NULL;
@@ -810,6 +840,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	bool metacopy = false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
 		.is_dir = false,
@@ -817,6 +848,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.stop = false,
 		.last = !poe->numlower,
 		.redirect = NULL,
+		.metacopy = false,
 	};
 
 	if (dentry->d_name.len > ofs->namelen)
@@ -835,7 +867,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out;
 		}
 		if (upperdentry && !d.is_dir) {
-			BUG_ON(!d.stop || d.redirect);
+			unsigned int origin_ctr = 0;
+			BUG_ON(d.redirect);
 			/*
 			 * Lookup copy up origin by decoding origin file handle.
 			 * We may get a disconnected dentry, which is fine,
@@ -846,16 +879,20 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
 			err = -ENOMEM;
 			upperredirect = kstrdup(d.redirect, GFP_KERNEL);
 			if (!upperredirect)
-				goto out_put_upper;
+				goto out_put_origin;
 			if (d.redirect[0] == '/')
 				poe = roe;
 		}
@@ -867,7 +904,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		stack = kcalloc(ofs->numlower, sizeof(struct ovl_path),
 				GFP_KERNEL);
 		if (!stack)
-			goto out_put_upper;
+			goto out_put_origin;
 	}
 
 	for (i = 0; !d.stop && i < poe->numlower; i++) {
@@ -885,7 +922,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 * If no origin fh is stored in upper of a merge dir, store fh
 		 * of lower dir and set upper parent "impure".
 		 */
-		if (upperdentry && !ctr && !ofs->noxattr) {
+		if (upperdentry && !ctr && !ofs->noxattr && d.is_dir) {
 			err = ovl_fix_origin(dentry, this, upperdentry);
 			if (err) {
 				dput(this);
@@ -898,7 +935,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 * lower dir that does not match a stored origin xattr. In any
 		 * case, only verified origin is used for index lookup.
 		 */
-		if (upperdentry && !ctr && ovl_verify_lower(dentry->d_sb)) {
+		if (upperdentry && !ctr && d.is_dir &&
+		    ovl_verify_lower(dentry->d_sb)) {
 			err = ovl_verify_origin(upperdentry, this, false);
 			if (err) {
 				dput(this);
@@ -909,6 +947,29 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			origin = this;
 		}
 
+		/*
+		 * For non-dir dentry, make sure dentry found by lookup
+		 * matches the origin stored in upper
+		 */
+		if (!d.is_dir && upperdentry && !ctr && origin_path) {
+			err = ovl_verify_origin(upperdentry, this, false);
+			if (err) {
+				dput(this);
+				goto out_put;
+			}
+		}
+
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
@@ -940,6 +1001,34 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
+	if (metacopy) {
+		BUG_ON(d.is_dir);
+		/*
+		 * Found a metacopy dentry but did not find corresponding
+		 * data dentry
+		 */
+		if (d.metacopy) {
+			err = -ESTALE;
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
@@ -972,8 +1061,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 	if (upperdentry)
 		ovl_dentry_set_upper_alias(dentry);
-	else if (index)
+	else if (index) {
 		upperdentry = dget(index);
+		metacopy = ovl_check_metacopy_xattr(index);
+	}
 
 	if (upperdentry || ctr) {
 		if (ctr)
@@ -987,9 +1078,16 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		OVL_I(inode)->redirect = upperredirect;
 		if (index)
 			ovl_set_flag(OVL_INDEX, inode);
+
+		if (upperdentry && !metacopy)
+			ovl_set_flag(OVL_UPPERDATA, inode);
 	}
 
 	revert_creds(old_cred);
+	if (origin_path) {
+		dput(origin_path->dentry);
+		kfree(origin_path);
+	}
 	dput(index);
 	kfree(stack);
 	kfree(d.redirect);
@@ -1003,6 +1101,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	for (i = 0; i < ctr; i++)
 		dput(stack[i].dentry);
 	kfree(stack);
+out_put_origin:
+	if (origin_path) {
+		dput(origin_path->dentry);
+		kfree(origin_path);
+	}
 out_put_upper:
 	dput(upperdentry);
 	kfree(upperredirect);
-- 
2.13.6

