From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 03/13] ovl: lookup redirect by file handle
Date: Mon, 17 Apr 2017 02:59:33 +0300
Message-ID: <1492387183-18847-4-git-send-email-amir73il@gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36543 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755141AbdDPX7l (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 16 Apr 2017 19:59:41 -0400
In-Reply-To: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When redirect_fh feature is enabled and when underlying
layers are all on the same fs, construct the dentry stack
of a merged dir by following a file handle chain of all
merged dir layers.

When overlay.fh xattr is found in upper inode, instead
of lookup of the dentry in next lower layer by name,
try to get it by calling exportfs_decode_fh().

On failure to follow file handle from upper to lower, fall back
to regular name lookup with or without path redirect.

On failure to decode file handle from middle layer, after
already following file handle from upper, there is no fall back
to lookup by name.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 167 +++++++++++++++++++++++++++++++++++++++++++----
 fs/overlayfs/overlayfs.h |   1 +
 fs/overlayfs/util.c      |  14 ++++
 3 files changed, 168 insertions(+), 14 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b8b0778..fcb7c15 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -9,9 +9,11 @@
 
 #include <linux/fs.h>
 #include <linux/cred.h>
+#include <linux/mount.h>
 #include <linux/namei.h>
 #include <linux/xattr.h>
 #include <linux/ratelimit.h>
+#include <linux/exportfs.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -21,7 +23,10 @@ struct ovl_lookup_data {
 	bool opaque;
 	bool stop;
 	bool last;
-	char *redirect;
+	bool by_path;		/* redirect by path */
+	bool by_fh;		/* redirect by file handle */
+	char *redirect;		/* path to follow */
+	struct ovl_fh *fh;	/* file handle to follow */
 };
 
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
@@ -81,6 +86,41 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 	goto err_free;
 }
 
+static int ovl_check_redirect_fh(struct dentry *dentry, struct ovl_lookup_data *d)
+{
+	int res;
+	void *buf = NULL;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_FH, NULL, 0);
+	if (res < 0) {
+		if (res == -ENODATA || res == -EOPNOTSUPP)
+			return 0;
+		goto fail;
+	}
+	buf = kzalloc(res, GFP_TEMPORARY);
+	if (!buf)
+		return -ENOMEM;
+
+	if (res == 0)
+		goto fail;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_FH, buf, res);
+	if (res < 0 || !ovl_redirect_fh_ok(buf, res))
+		goto fail;
+
+	kfree(d->fh);
+	d->fh = buf;
+
+	return 0;
+
+err_free:
+	kfree(buf);
+	return 0;
+fail:
+	pr_warn_ratelimited("overlayfs: failed to get file handle (%i)\n", res);
+	goto err_free;
+}
+
 static bool ovl_is_opaquedir(struct dentry *dentry)
 {
 	int res;
@@ -96,22 +136,76 @@ static bool ovl_is_opaquedir(struct dentry *dentry)
 	return false;
 }
 
+/* Check if p1 is connected with a chain of hashed dentries to p2 */
+static bool ovl_is_lookable(struct dentry *p1, struct dentry *p2)
+{
+	struct dentry *p;
+
+	for (p = p2; !IS_ROOT(p); p = p->d_parent) {
+		if (d_unhashed(p))
+			return false;
+		if (p->d_parent == p1)
+			return true;
+	}
+	return false;
+}
+
+/* Check if dentry is reachable from mnt via path lookup */
+static int ovl_dentry_under_mnt(void *ctx, struct dentry *dentry)
+{
+	struct vfsmount *mnt = ctx;
+
+	return ovl_is_lookable(mnt->mnt_root, dentry);
+}
+
+static struct dentry *ovl_lookup_fh(struct vfsmount *mnt,
+				    const struct ovl_fh *fh)
+{
+	int bytes = (fh->len - offsetof(struct ovl_fh, fid));
+
+	/*
+	 * Several layers can be on the same fs and decoded dentry may be in
+	 * either one of those layers. We are looking for a match of dentry
+	 * and mnt to find out to which layer the decoded dentry belongs to.
+	 */
+	return exportfs_decode_fh(mnt, (struct fid *)fh->fid,
+				  bytes >> 2, (int)fh->type,
+				  ovl_dentry_under_mnt, mnt);
+}
+
 static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 			     const char *name, unsigned int namelen,
 			     size_t prelen, const char *post,
-			     struct dentry **ret)
+			     struct vfsmount *mnt, struct dentry **ret)
 {
 	struct dentry *this;
 	int err;
 
-	this = lookup_one_len_unlocked(name, base, namelen);
+	/*
+	 * Lookup of upper is with null d->fh.
+	 * Lookup of lower is either by_fh with non-null d->fh
+	 * or by_path with null d->fh.
+	 */
+	if (d->fh)
+		this = ovl_lookup_fh(mnt, d->fh);
+	else
+		this = lookup_one_len_unlocked(name, base, namelen);
 	if (IS_ERR(this)) {
 		err = PTR_ERR(this);
 		this = NULL;
 		if (err == -ENOENT || err == -ENAMETOOLONG)
 			goto out;
+		if (d->fh && err == -ESTALE)
+			goto out;
 		goto out_err;
 	}
+
+	/* Lower found by file handle - don't follow that handle again */
+	if (d->fh) {
+		kfree(d->fh);
+		d->fh = NULL;
+	}
+
 	if (!this->d_inode)
 		goto put_and_out;
 
@@ -135,9 +229,18 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 		d->stop = d->opaque = true;
 		goto out;
 	}
-	err = ovl_check_redirect(this, d, prelen, post);
-	if (err)
-		goto out_err;
+	if (d->last)
+		goto out;
+	if (d->by_fh) {
+		err = ovl_check_redirect_fh(this, d);
+		if (err)
+			goto out_err;
+	}
+	if (d->by_path) {
+		err = ovl_check_redirect(this, d, prelen, post);
+		if (err)
+			goto out_err;
+	}
 out:
 	*ret = this;
 	return 0;
@@ -152,6 +255,12 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
 	return err;
 }
 
+static int ovl_lookup_layer_fh(struct path *path, struct ovl_lookup_data *d,
+			       struct dentry **ret)
+{
+	return ovl_lookup_single(path->dentry, d, "", 0, 0, "", path->mnt, ret);
+}
+
 static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 			    struct dentry **ret)
 {
@@ -162,7 +271,7 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 
 	if (d->name.name[0] != '/')
 		return ovl_lookup_single(base, d, d->name.name, d->name.len,
-					 0, "", ret);
+					 0, "", NULL, ret);
 
 	while (!IS_ERR_OR_NULL(base) && d_can_lookup(base)) {
 		const char *s = d->name.name + d->name.len - rem;
@@ -175,7 +284,7 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 			return -EIO;
 
 		err = ovl_lookup_single(base, d, s, thislen,
-					d->name.len - rem, next, &base);
+					d->name.len - rem, next, NULL, &base);
 		dput(dentry);
 		if (err)
 			return err;
@@ -220,6 +329,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	const struct cred *old_cred;
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_entry *poe = dentry->d_parent->d_fsdata;
+	struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
 	struct path *stack = NULL;
 	struct dentry *upperdir, *upperdentry = NULL;
 	unsigned int ctr = 0;
@@ -235,7 +345,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.opaque = false,
 		.stop = false,
 		.last = !poe->numlower,
+		.by_path = true,
+		.by_fh = ofs->config.redirect_fh,
 		.redirect = NULL,
+		.fh = NULL,
 	};
 
 	if (dentry->d_name.len > ofs->namelen)
@@ -259,12 +372,12 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			if (!upperredirect)
 				goto out_put_upper;
 			if (d.redirect[0] == '/')
-				poe = dentry->d_sb->s_root->d_fsdata;
+				poe = roe;
 		}
 		upperopaque = d.opaque;
 	}
 
-	if (!d.stop && poe->numlower) {
+	if (!d.stop && (poe->numlower || d.fh)) {
 		err = -ENOMEM;
 		stack = kcalloc(ofs->numlower, sizeof(struct path),
 				GFP_TEMPORARY);
@@ -272,6 +385,33 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out_put_upper;
 	}
 
+	/* Try to lookup lower layers by file handle (at root) */
+	d.by_path = false;
+	for (i = 0; !d.stop && d.fh && i < roe->numlower; i++) {
+		struct path lowerpath = roe->lowerstack[i];
+
+		d.last = i == roe->numlower - 1;
+		err = ovl_lookup_layer_fh(&lowerpath, &d, &this);
+		if (err)
+			goto out_put;
+
+		if (!this)
+			continue;
+
+		stack[ctr].dentry = this;
+		stack[ctr].mnt = lowerpath.mnt;
+		ctr++;
+	}
+
+	/* Fallback to lookup lower layers by name (at parent) */
+	if (ctr) {
+		d.stop = true;
+	} else {
+		d.by_path = true;
+		d.by_fh = false;
+		kfree(d.fh);
+		d.fh = NULL;
+	}
 	for (i = 0; !d.stop && i < poe->numlower; i++) {
 		struct path lowerpath = poe->lowerstack[i];
 
@@ -290,10 +430,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (d.stop)
 			break;
 
-		if (d.redirect &&
-		    d.redirect[0] == '/' &&
-		    poe != dentry->d_sb->s_root->d_fsdata) {
-			poe = dentry->d_sb->s_root->d_fsdata;
+		if (d.redirect && d.redirect[0] == '/' && poe != roe) {
+			poe = roe;
 
 			/* Find the current layer on the root dentry */
 			for (i = 0; i < poe->numlower; i++)
@@ -352,6 +490,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	dput(upperdentry);
 	kfree(upperredirect);
 out:
+	kfree(d.fh);
 	kfree(d.redirect);
 	revert_creds(old_cred);
 	return ERR_PTR(err);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 49be199..6257c5b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -186,6 +186,7 @@ const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 bool ovl_redirect_fh(struct super_block *sb);
 void ovl_clear_redirect_fh(struct super_block *sb);
+bool ovl_redirect_fh_ok(const char *redirect, size_t size);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 17530c5..6538ec5 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -229,6 +229,20 @@ void ovl_clear_redirect_fh(struct super_block *sb)
 	ofs->config.redirect_fh = false;
 }
 
+bool ovl_redirect_fh_ok(const char *redirect, size_t size)
+{
+	struct ovl_fh *fh = (void *)redirect;
+
+	if (size < sizeof(struct ovl_fh) || size < fh->len)
+		return false;
+
+	if (fh->version > OVL_FH_VERSION ||
+	    fh->magic != OVL_FH_MAGIC)
+		return false;
+
+	return true;
+}
+
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-- 
2.7.4
