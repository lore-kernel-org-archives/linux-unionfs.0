From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 08/15] ovl: lookup non-dir copy up origin by file handle
Date: Mon,  1 May 2017 16:41:59 +0300
Message-ID: <1493646126-10101-9-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33651 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424445AbdEANmN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:13 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When redirect_fh is enabled, if overlay.origin xattr is found on a
non-dir upper inode, instead of lookup of the copy up origin in lower
layer by name, try to get it by calling exportfs_decode_fh().

On failure to lookup by file handle to lower layer or if redirect_fh is
disabled, do not lookup the copy up origin by name, because the lower
found by name could be another file in case the upper file was renamed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 176 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/overlayfs/overlayfs.h |   1 +
 fs/overlayfs/util.c      |  14 ++++
 3 files changed, 186 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 66072b0..695a78e 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -12,6 +12,8 @@
 #include <linux/namei.h>
 #include <linux/xattr.h>
 #include <linux/ratelimit.h>
+#include <linux/mount.h>
+#include <linux/exportfs.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -22,7 +24,10 @@ struct ovl_lookup_data {
 	bool stop;
 	bool last;
 	int idx;
-	char *redirect;
+	bool by_path;		/* redirect by path: */
+	char *redirect;		/* - path to follow */
+	bool by_fh;		/* redirect by file handle: */
+	struct ovl_fh *fh;	/* - file handle to follow */
 };
 
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
@@ -82,6 +87,51 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 	goto err_free;
 }
 
+static struct ovl_fh *ovl_get_fh(struct dentry *dentry, const char *name)
+{
+	int res;
+	void *buf = NULL;
+
+	res = vfs_getxattr(dentry, name, NULL, 0);
+	if (res <= 0) {
+		if (res == -ENODATA || res == -EOPNOTSUPP)
+			return 0;
+		goto fail;
+	}
+	buf = kzalloc(res, GFP_TEMPORARY);
+	if (!buf) {
+		res = -ENOMEM;
+		goto fail;
+	}
+
+	res = vfs_getxattr(dentry, name, buf, res);
+	if (res < 0 || !ovl_redirect_fh_ok(buf, res))
+		goto fail;
+
+	return (struct ovl_fh *)buf;
+
+err_free:
+	kfree(buf);
+	return NULL;
+fail:
+	pr_warn_ratelimited("overlayfs: failed to get %s (%i)\n",
+			    name, res);
+	goto err_free;
+}
+
+static void ovl_check_redirect_fh(struct dentry *dentry,
+				  struct ovl_lookup_data *d)
+{
+	kfree(d->fh);
+	d->fh = ovl_get_fh(dentry, OVL_XATTR_ORIGIN);
+}
+
+static void ovl_reset_redirect_fh(struct ovl_lookup_data *d)
+{
+	kfree(d->fh);
+	d->fh = NULL;
+}
+
 static bool ovl_is_opaquedir(struct dentry *dentry)
 {
 	int res;
@@ -149,9 +199,23 @@ static int ovl_lookup_data(struct dentry *this, struct ovl_lookup_data *d,
 	 * Check redirect dir even if d->last, because with redirect_dir,
 	 * a merge dir may have an opaque dir parent.
 	 */
-	err = ovl_check_redirect(this, d, prelen, post);
-	if (err)
-		goto out_err;
+	if (d->by_path) {
+		err = ovl_check_redirect(this, d, prelen, post);
+		if (err)
+			goto out_err;
+	}
+	/*
+	 * If non-dir has a valid origin file handle, it will be used to
+	 * find the copy up origin in lower layers.
+	 *
+	 * Directory lookup by fh is not desired for all workloads, so it
+	 * will be enabled by a future mount option.
+	 */
+	if (d->by_fh && !d_is_dir(this)) {
+		ovl_check_redirect_fh(this, d);
+		d->stop = !d->fh;
+	}
+
 out:
 	*ret = this;
 	return 0;
@@ -225,6 +289,76 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
 	return 0;
 }
 
+static struct dentry *ovl_decode_fh(struct vfsmount *mnt,
+				    const struct ovl_fh *fh,
+				    int (*acceptable)(void *, struct dentry *))
+{
+	int bytes = (fh->len - offsetof(struct ovl_fh, fid));
+
+	/*
+	 * When redirect_fh is disabled, 'invalid' file handles are stored
+	 * to indicate that this entry has been copied up.
+	 */
+	if (!bytes || (int)fh->type == FILEID_INVALID)
+		return ERR_PTR(-ESTALE);
+
+	/*
+	 * Several layers can be on the same fs and decoded dentry may be in
+	 * either one of those layers. We are looking for a match of dentry
+	 * and mnt to find out to which layer the decoded dentry belongs to.
+	 */
+	return exportfs_decode_fh(mnt, (struct fid *)fh->fid,
+				  bytes >> 2, (int)fh->type,
+				  acceptable, mnt);
+}
+
+static int ovl_acceptable(void *ctx, struct dentry *dentry)
+{
+	return 1;
+}
+
+/* Lookup by file handle in a lower layer mounted at @mnt */
+static int ovl_lookup_layer_fh(struct vfsmount *mnt, struct ovl_lookup_data *d,
+			       struct dentry **ret)
+{
+	struct dentry *this = ovl_decode_fh(mnt, d->fh, ovl_acceptable);
+	int err;
+
+	if (IS_ERR(this)) {
+		err = PTR_ERR(this);
+		*ret = NULL;
+		if (err == -ESTALE)
+			return 0;
+		return err;
+	}
+
+	/* If found by file handle - don't follow that handle again */
+	ovl_reset_redirect_fh(d);
+	return ovl_lookup_data(this, d, 0, "", ret);
+}
+
+/* Find a lower layer where file handle should be decoded */
+static int ovl_find_layer_by_fh(struct dentry *dentry, int idx,
+				struct ovl_fh *fh)
+{
+	struct super_block *same_sb = ovl_same_sb(dentry->d_sb);
+
+	/* We only support redirect_fh when all layers are on the same fs */
+	if (!same_sb)
+		return -1;
+
+	/*
+	 * Since all layers are on the same fs, we use the first layer for
+	 * decoding the file handle.  We may get a disconnected dentry,
+	 * which is fine, because we only need to hold the origin inode in
+	 * cache and use its inode number.  We may even get a connected dentry,
+	 * that is not under the first layer's root.  That is also fine for
+	 * using it's inode number - it's the same as if we held a reference
+	 * to a dentry in first layer that was moved under us.
+	 */
+	return 0;
+}
+
 /*
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
@@ -270,7 +404,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.stop = false,
 		.last = !poe->numlower,
 		.idx = 0,
+		.by_path = true,
 		.redirect = NULL,
+		.by_fh = ofs->redirect_fh,
+		.fh = NULL,
 	};
 
 	if (dentry->d_name.len > ofs->namelen)
@@ -299,7 +436,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperopaque = d.opaque;
 	}
 
-	if (!d.stop && poe->numlower) {
+	if (!d.stop && (poe->numlower || d.fh)) {
 		err = -ENOMEM;
 		stack = kcalloc(ofs->numlower, sizeof(struct path),
 				GFP_TEMPORARY);
@@ -307,6 +444,33 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out_put_upper;
 	}
 
+	/* Lookup non-dir copy up origin by file handle */
+	if (!d.stop && d.fh && !S_ISDIR(d.mode)) {
+		/* Find layer where file handle should be decoded */
+		i = ovl_find_layer_by_fh(dentry, 0, d.fh);
+		if (i < 0 || i > roe->numlower)
+			goto alloc_entry;
+
+		d.last = true;
+		d.by_path = false;
+		err = ovl_lookup_layer_fh(roe->lowerstack[i].mnt, &d, &this);
+		if (err)
+			goto out_put;
+
+		if (!this)
+			goto alloc_entry;
+
+		stack[ctr].dentry = this;
+		stack[ctr].mnt = roe->lowerstack[i].mnt;
+		ctr++;
+
+		/* Looked up by fh - do not lookup also by path */
+		goto alloc_entry;
+	}
+
+	/* Lookup lower layers by path */
+	d.by_path = true;
+	d.by_fh = false;
 	for (i = 0; !d.stop && i < poe->numlower; i++) {
 		struct path lowerpath = poe->lowerstack[i];
 
@@ -338,6 +502,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		}
 	}
 
+alloc_entry:
 	oe = ovl_alloc_entry(ctr);
 	err = -ENOMEM;
 	if (!oe)
@@ -386,6 +551,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	dput(upperdentry);
 	kfree(upperredirect);
 out:
+	kfree(d.fh);
 	kfree(d.redirect);
 	revert_creds(old_cred);
 	return ERR_PTR(err);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index da37aaf..90181e16 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -194,6 +194,7 @@ const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 bool ovl_redirect_fh(struct super_block *sb);
 void ovl_clear_redirect_fh(struct super_block *sb);
+bool ovl_redirect_fh_ok(const char *redirect, size_t size);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 9db0588..08c55e6 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -236,6 +236,20 @@ void ovl_clear_redirect_fh(struct super_block *sb)
 	ofs->redirect_fh = false;
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
