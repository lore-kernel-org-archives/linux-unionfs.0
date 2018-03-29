Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:50000 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751714AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 10/28] ovl: Modify ovl_lookup() and friends to lookup metacopy dentry
Date: Thu, 29 Mar 2018 15:38:36 -0400
Message-Id: <20180329193854.13814-11-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

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
---
 fs/overlayfs/export.c    |  3 ++
 fs/overlayfs/inode.c     |  6 +++-
 fs/overlayfs/namei.c     | 90 ++++++++++++++++++++++++++++++++++++++++++------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 22 ++++++++++++
 5 files changed, 110 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index e668329f7361..1c233096e59c 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -311,6 +311,9 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 		return ERR_CAST(inode);
 	}
 
+	if (upper)
+		ovl_set_flag(OVL_UPPERDATA, inode);
+
 	dentry = d_find_any_alias(inode);
 	if (!dentry) {
 		dentry = d_alloc_anon(inode->i_sb);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3991a890b464..e1dbfed0c449 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -677,7 +677,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
 	bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
-	bool is_dir;
+	bool is_dir, metacopy = false;
 
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
@@ -732,6 +732,10 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
 	if (index)
 		ovl_set_flag(OVL_INDEX, inode);
 
+	metacopy = ovl_check_metacopy_xattr(upperdentry ?: lowerdentry);
+	if (upperdentry && !metacopy)
+		ovl_set_flag(OVL_UPPERDATA, inode);
+
 	OVL_I(inode)->redirect = redirect;
 
 	/* Check for non-merge dir that may have whiteouts */
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 0b325e65864c..1dba89e9543f 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -24,6 +24,7 @@ struct ovl_lookup_data {
 	bool stop;
 	bool last;
 	char *redirect;
+	bool metacopy;
 };
 
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
@@ -252,9 +253,13 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		goto put_and_out;
 	}
 	if (!d_can_lookup(this)) {
-		d->stop = true;
 		if (d->is_dir)
 			goto put_and_out;
+		err = ovl_check_metacopy_xattr(this);
+		if (err < 0)
+			goto out_err;
+		d->stop = !err;
+		d->metacopy = !!err;
 		goto out;
 	}
 	if (last_element)
@@ -815,7 +820,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
 	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
-	struct ovl_path *stack = NULL;
+	struct ovl_path *stack = NULL, *origin_path = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
 	struct dentry *origin = NULL;
 	struct dentry *index = NULL;
@@ -826,6 +831,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	struct dentry *this;
 	unsigned int i;
 	int err;
+	bool metacopy = false;
 	struct ovl_lookup_data d = {
 		.name = dentry->d_name,
 		.is_dir = false,
@@ -833,6 +839,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.stop = false,
 		.last = ofs->config.redirect_follow ? false : !poe->numlower,
 		.redirect = NULL,
+		.metacopy = false,
 	};
 
 	if (dentry->d_name.len > ofs->namelen)
@@ -851,7 +858,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out;
 		}
 		if (upperdentry && !d.is_dir) {
-			BUG_ON(!d.stop || d.redirect);
+			unsigned int origin_ctr = 0;
+			BUG_ON(d.redirect);
 			/*
 			 * Lookup copy up origin by decoding origin file handle.
 			 * We may get a disconnected dentry, which is fine,
@@ -862,16 +870,20 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
@@ -883,7 +895,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		stack = kcalloc(ofs->numlower, sizeof(struct ovl_path),
 				GFP_KERNEL);
 		if (!stack)
-			goto out_put_upper;
+			goto out_put_origin;
 	}
 
 	for (i = 0; !d.stop && i < poe->numlower; i++) {
@@ -905,7 +917,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 * If no origin fh is stored in upper of a merge dir, store fh
 		 * of lower dir and set upper parent "impure".
 		 */
-		if (upperdentry && !ctr && !ofs->noxattr) {
+		if (upperdentry && !ctr && !ofs->noxattr && d.is_dir) {
 			err = ovl_fix_origin(dentry, this, upperdentry);
 			if (err) {
 				dput(this);
@@ -917,16 +929,35 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		 * When "verify_lower" feature is enabled, do not merge with a
 		 * lower dir that does not match a stored origin xattr. In any
 		 * case, only verified origin is used for index lookup.
+		 *
+		 * For non-dir dentry, make sure dentry found by lookup
+		 * matches the origin stored in upper. Otherwise its an
+		 * error.
 		 */
-		if (upperdentry && !ctr && ovl_verify_lower(dentry->d_sb)) {
+		if (upperdentry && !ctr &&
+		    ((d.is_dir && ovl_verify_lower(dentry->d_sb)) ||
+		     (!d.is_dir && origin_path))) {
 			err = ovl_verify_origin(upperdentry, this, false);
 			if (err) {
 				dput(this);
-				break;
+				if (d.is_dir)
+					break;
+				goto out_put;
 			}
-
 			/* Bless lower dir as verified origin */
-			origin = this;
+			if (d.is_dir)
+				origin = this;
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
 		}
 
 		stack[ctr].dentry = this;
@@ -960,6 +991,34 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
@@ -1006,6 +1065,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	}
 
 	revert_creds(old_cred);
+	if (origin_path) {
+		dput(origin_path->dentry);
+		kfree(origin_path);
+	}
 	dput(index);
 	kfree(stack);
 	kfree(d.redirect);
@@ -1019,6 +1082,11 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
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
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 8608f3ec8f44..9f2541c26b0a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -272,6 +272,7 @@ bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
+int ovl_check_metacopy_xattr(struct dentry *dentry);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7929cc872df6..f6a2b75bae35 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -740,3 +740,25 @@ int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
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
2.13.6

