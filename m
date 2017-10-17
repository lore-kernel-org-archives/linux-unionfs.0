From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 10/14] ovl: obtain a non-pure-upper disconnected dentry
Date: Tue, 17 Oct 2017 19:44:27 +0300
Message-ID: <1508258671-10800-11-git-send-email-amir73il@gmail.com>
References: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1508258671-10800-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Instantiate an overlay dentry from lower real inode and optionally
from upper real inode with origin xattr.

This is needed for decoding an overlay inode that was encoded by real
lower file handle and since then may or may not have been copied up
and indexed.

This implementation is currently limited to non-dir and merge dirs
with single lower dir. For this reason, NFS export support currently
requires overlay with single lower layer.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/export.c    | 44 +++++++++++++++++++++++++++++-----------
 fs/overlayfs/namei.c     | 52 ++++++++++++++++++++++++++++++------------------
 fs/overlayfs/overlayfs.h |  4 ++++
 3 files changed, 69 insertions(+), 31 deletions(-)

diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
index 7ebe04317647..476e2a74aca7 100644
--- a/fs/overlayfs/export.c
+++ b/fs/overlayfs/export.c
@@ -176,17 +176,13 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 				       struct dentry *upper,
 				       struct dentry *lower)
 {
+	struct ovl_fs *ofs = sb->s_fs_info;
 	struct inode *inode;
 	struct dentry *dentry;
+	struct dentry *index = lower ? upper : NULL;
 	struct ovl_entry *oe;
 
-	/* TODO: handle decoding of non pure upper */
-	if (lower) {
-		dput(upper);
-		return ERR_PTR(-EINVAL);
-	}
-
-	inode = ovl_get_inode(sb, upper, NULL, NULL);
+	inode = ovl_get_inode(sb, upper, lower, index);
 	if (IS_ERR(inode)) {
 		dput(upper);
 		return ERR_CAST(inode);
@@ -206,16 +202,40 @@ static struct dentry *ovl_obtain_alias(struct super_block *sb,
 		return dentry;
 	}
 
-	oe = ovl_alloc_entry(0);
+	/*
+	 * This implementation is currently limited to non-dir and merge dirs
+	 * with single lower dir. For this reason, NFS export support currently
+	 * requires overlay with single lower layer.
+	 *
+	 * TODO: use ovl_lookup or derivative to populate lowerstack with more
+	 *       lower dirs to support NFS export with multi lower layers.
+	 */
+	oe = ovl_alloc_entry(lower ? 1 : 0);
 	if (!oe) {
 		dput(dentry);
 		return ERR_PTR(-ENOMEM);
 	}
-
+	if (lower) {
+		oe->lowerstack->dentry = dget(lower);
+		oe->lowerstack->mnt = ofs->lower_mnt[0];
+	}
 	dentry->d_fsdata = oe;
-	ovl_dentry_set_upper_alias(dentry);
-	if (d_is_dir(upper) && ovl_is_opaquedir(upper))
-		ovl_dentry_set_opaque(dentry);
+
+	if (upper) {
+		ovl_dentry_set_upper_alias(dentry);
+		if (d_is_dir(upper)) {
+			size_t len = 0;
+			char *redirect = ovl_get_redirect_xattr(upper, &len);
+
+			if (redirect)
+				ovl_dentry_set_redirect(dentry, redirect);
+			if (ovl_is_opaquedir(upper))
+				ovl_dentry_set_opaque(dentry);
+		}
+	}
+
+	if (index)
+		ovl_set_flag(OVL_INDEX, inode);
 
 	return dentry;
 
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 4f20af22bd0b..796c869559a9 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -26,8 +26,7 @@ struct ovl_lookup_data {
 	char *redirect;
 };
 
-static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
-			      size_t prelen, const char *post)
+char *ovl_get_redirect_xattr(struct dentry *dentry, size_t *len)
 {
 	int res;
 	char *s, *next, *buf = NULL;
@@ -35,12 +34,12 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, NULL, 0);
 	if (res < 0) {
 		if (res == -ENODATA || res == -EOPNOTSUPP)
-			return 0;
+			return NULL;
 		goto fail;
 	}
-	buf = kzalloc(prelen + res + strlen(post) + 1, GFP_KERNEL);
+	buf = kzalloc(res + *len + 1, GFP_KERNEL);
 	if (!buf)
-		return -ENOMEM;
+		return ERR_PTR(-ENOMEM);
 
 	if (res == 0)
 		goto invalid;
@@ -59,22 +58,14 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 	} else {
 		if (strchr(buf, '/') != NULL)
 			goto invalid;
-
-		memmove(buf + prelen, buf, res);
-		memcpy(buf, d->name.name, prelen);
 	}
 
-	strcat(buf, post);
-	kfree(d->redirect);
-	d->redirect = buf;
-	d->name.name = d->redirect;
-	d->name.len = strlen(d->redirect);
-
-	return 0;
+	*len = res;
+	return buf;
 
 err_free:
 	kfree(buf);
-	return 0;
+	return NULL;
 fail:
 	pr_warn_ratelimited("overlayfs: failed to get redirect (%i)\n", res);
 	goto err_free;
@@ -83,6 +74,29 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
 	goto err_free;
 }
 
+static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
+			      size_t prelen, const char *post)
+{
+	size_t len = prelen + strlen(post);
+	char *buf = ovl_get_redirect_xattr(dentry, &len);
+
+	if (IS_ERR_OR_NULL(buf))
+		return PTR_ERR(buf);
+
+	if (buf[0] != '/' && prelen) {
+		memmove(buf + prelen, buf, len);
+		memcpy(buf, d->name.name, prelen);
+	}
+
+	strcat(buf, post);
+	kfree(d->redirect);
+	d->redirect = buf;
+	d->name.name = d->redirect;
+	d->name.len = strlen(d->redirect);
+
+	return 0;
+}
+
 static int ovl_acceptable(void *mnt, struct dentry *dentry)
 {
 	/*
@@ -348,9 +362,9 @@ static int ovl_check_origin_fh(struct ovl_fh *fh, struct dentry *upperdentry,
 	return -ESTALE;
 }
 
-static int ovl_check_origin(struct dentry *upperdentry,
-			    struct path *lowerstack, unsigned int numlower,
-			    struct path **stackp, unsigned int *ctrp)
+int ovl_check_origin(struct dentry *upperdentry, struct path *lowerstack,
+		     unsigned int numlower, struct path **stackp,
+		     unsigned int *ctrp)
 {
 	struct ovl_fh *fh = ovl_get_origin_fh(upperdentry);
 	int err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 75a8b10d4e10..ffc5a955478e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -271,8 +271,12 @@ static inline bool ovl_is_opaquedir(struct dentry *dentry)
 
 
 /* namei.c */
+char *ovl_get_redirect_xattr(struct dentry *dentry, size_t *len);
 int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
 struct dentry *ovl_decode_fh(struct ovl_fh *fh, struct vfsmount *mnt);
+int ovl_check_origin(struct dentry *upperdentry, struct path *lowerstack,
+		     unsigned int numlower, struct path **stackp,
+		     unsigned int *ctrp);
 int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 		      bool is_upper, bool set);
 int ovl_verify_index(struct dentry *index, struct vfsmount *mnt,
-- 
2.7.4
