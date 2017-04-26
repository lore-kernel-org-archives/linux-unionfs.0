From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 07/16] ovl: lookup redirect by file handle
Date: Thu, 27 Apr 2017 00:35:09 +0300
Message-ID: <1493242518-15266-8-git-send-email-amir73il@gmail.com>
References: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33860 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030854AbdDZVfW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:22 -0400
In-Reply-To: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When overlay.origin.fh xattr is found in an upper inode, instead of lookup
of the dentry in next lower layer by name, first try to get it by calling
exportfs_decode_fh().

On failure to lookup by file handle to lower layer, fall back to lookup
by name with or without path redirect.

For now we only support following by file handle from upper if there is a
single lower layer, because fallback from lookup by file hande to lookup
by path in mid layers is not yet implemented.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c     | 158 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/overlayfs/overlayfs.h |   1 +
 fs/overlayfs/util.c      |  14 +++++
 3 files changed, 168 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index b965785..28d54e3 100644
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
 
@@ -21,7 +23,10 @@ struct ovl_lookup_data {
 	bool opaque;
 	bool stop;
 	bool last;
-	char *redirect;
+	bool by_path;		/* redirect by path: */
+	char *redirect;		/* - path to follow */
+	bool by_fh;		/* redirect by file handle: */
+	struct ovl_fh *fh;	/* - file handle to follow */
 };
 
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
@@ -81,6 +86,52 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
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
+static int ovl_check_redirect_fh(struct dentry *dentry,
+				 struct ovl_lookup_data *d)
+{
+	kfree(d->fh);
+	d->fh = ovl_get_fh(dentry, OVL_XATTR_ORIGIN_FH);
+	return 0;
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
@@ -126,9 +177,16 @@ static int ovl_lookup_data(struct dentry *this, struct ovl_lookup_data *d,
 		d->stop = d->opaque = true;
 		goto out;
 	}
-	err = ovl_check_redirect(this, d, prelen, post);
-	if (err)
-		goto out_err;
+	if (d->by_path) {
+		err = ovl_check_redirect(this, d, prelen, post);
+		if (err)
+			goto out_err;
+	}
+	if (d->by_fh) {
+		err = ovl_check_redirect_fh(this, d);
+		if (err)
+			goto out_err;
+	}
 out:
 	*ret = this;
 	return 0;
@@ -202,6 +260,55 @@ static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
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
+/* Check if dentry belongs to this layer */
+static int ovl_dentry_in_layer(void *mnt, struct dentry *dentry)
+{
+	return is_subdir(dentry, ((struct vfsmount *)mnt)->mnt_root);
+}
+
+/* Lookup by file handle in a lower layer mounted at @mnt */
+static int ovl_lookup_layer_fh(struct vfsmount *mnt, struct ovl_lookup_data *d,
+			       struct dentry **ret)
+{
+	struct dentry *this = ovl_decode_fh(mnt, d->fh, ovl_dentry_in_layer);
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
 /*
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
@@ -246,7 +353,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.opaque = false,
 		.stop = false,
 		.last = !poe->numlower,
+		.by_path = true,
 		.redirect = NULL,
+		.by_fh = true,
+		.fh = NULL,
 	};
 
 	if (dentry->d_name.len > ofs->namelen)
@@ -276,7 +386,15 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			type |= __OVL_PATH_OPAQUE;
 	}
 
-	if (!d.stop && poe->numlower) {
+	/*
+	 * For now we only support lower by fh in single layer, because
+	 * fallback from lookup by fh to lookup by path in mid layers for
+	 * merge directory is not yet implemented.
+	 */
+	if (!ofs->redirect_fh || ofs->numlower > 1)
+		ovl_reset_redirect_fh(&d);
+
+	if (!d.stop && (poe->numlower || d.fh)) {
 		err = -ENOMEM;
 		stack = kcalloc(ofs->numlower, sizeof(struct path),
 				GFP_TEMPORARY);
@@ -284,6 +402,35 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 			goto out_put_upper;
 	}
 
+	/* Try to lookup lower layers by file handle */
+	d.by_path = false;
+	if (!d.stop && d.fh) {
+		struct vfsmount *lowermnt = roe->lowerstack[0].mnt;
+
+		d.last = true;
+		err = ovl_lookup_layer_fh(lowermnt, &d, &this);
+		if (err)
+			goto out_put;
+
+		if (!this)
+			goto lookup_by_path;
+
+		stack[ctr].dentry = this;
+		stack[ctr].mnt = lowermnt;
+		ctr++;
+		/*
+		 * Found by fh - won't lookup by path.
+		 * TODO: set d.redirect to dentry_path(this), so
+		 *       lookup can continue by path in next layers
+		 */
+		d.stop = true;
+	}
+
+lookup_by_path:
+	/* Fallback to lookup lower layers by path */
+	d.by_path = true;
+	d.by_fh = false;
+	ovl_reset_redirect_fh(&d);
 	for (i = 0; !d.stop && i < poe->numlower; i++) {
 		struct path lowerpath = poe->lowerstack[i];
 
@@ -363,6 +510,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 	dput(upperdentry);
 	kfree(upperredirect);
 out:
+	ovl_reset_redirect_fh(&d);
 	kfree(d.redirect);
 	revert_creds(old_cred);
 	return ERR_PTR(err);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2395dd7..ea23bef 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -204,6 +204,7 @@ const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 bool ovl_redirect_fh(struct super_block *sb);
 void ovl_clear_redirect_fh(struct super_block *sb);
+bool ovl_redirect_fh_ok(const char *redirect, size_t size);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 84f0c1f..a36ca7b 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -254,6 +254,20 @@ void ovl_clear_redirect_fh(struct super_block *sb)
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
