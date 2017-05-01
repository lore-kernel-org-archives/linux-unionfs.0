From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 15/15] ovl: add support for verify_lower option
Date: Mon,  1 May 2017 16:42:06 +0300
Message-ID: <1493646126-10101-16-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33691 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1425624AbdEANmZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:25 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When overlayfs is mounted with option 'verify_lower', a directory inode
found in lower layer by name or by redirect_dir is verified against the
file handle of the copy up origin that is stored in the upper layer.

The 'verify_lower' option should not be used after copying layers,
because the new lower directory inodes would fail verification.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  2 +-
 fs/overlayfs/namei.c     | 71 +++++++++++++++++++++++++++++++++++++++++++-----
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 23 ++++++++++++++++
 fs/overlayfs/util.c      |  7 +++++
 6 files changed, 98 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 767ae77..0aa626a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -234,7 +234,7 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
-static struct ovl_fh *ovl_encode_fh(struct dentry *lower)
+struct ovl_fh *ovl_encode_fh(struct dentry *lower)
 {
 	struct ovl_fh *fh;
 	int fh_type, fh_len, dwords;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 2be2917..4580ac0 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -27,7 +27,8 @@ struct ovl_lookup_data {
 	bool by_path;		/* redirect by path: */
 	char *redirect;		/* - path to follow */
 	bool by_fh;		/* redirect by file handle: */
-	struct ovl_fh *fh;	/* - file handle to follow */
+	bool verify_fh;		/* verify by file handle: */
+	struct ovl_fh *fh;	/* - file handle to follow/verify */
 };
 
 static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
@@ -206,14 +207,14 @@ static int ovl_lookup_data(struct dentry *this, struct ovl_lookup_data *d,
 	}
 	/*
 	 * If non-dir has a valid origin file handle, it will be used to
-	 * find the copy up origin in lower layers.
-	 *
-	 * Directory lookup by fh is not desired for all workloads, so it
-	 * will be enabled by a future mount option.
+	 * find the copy up origin in lower layers.  If verify_lower is
+	 * enabled a directory origin file handle will be used to verify
+	 * lower directory that was found by path.
 	 */
-	if (d->by_fh && !d_is_dir(this)) {
+	if (d->by_fh && (d->verify_fh || !d_is_dir(this))) {
 		ovl_check_redirect_fh(this, d);
-		d->stop = !d->fh;
+		if (!d_is_dir(this) && !d->fh)
+			d->stop = true;
 	}
 
 out:
@@ -364,6 +365,57 @@ static int ovl_find_layer_by_fh(struct dentry *dentry, int idx,
 }
 
 /*
+ * Verify that a lower directory matches the stored file handle.
+ * Return 0 on match, > 0 on mismatch, < 0 on error.
+ */
+static int ovl_verify_lower_fh(struct dentry **lower,
+			       struct ovl_lookup_data *d)
+{
+	struct ovl_fh *fh;
+	struct inode *inode;
+	int ret;
+
+	/* We should be called only to verify lower dir matches fh */
+	if (WARN_ON(!d->fh) || !S_ISDIR(d->mode))
+		return -EIO;
+
+	/* We currently support verify_lower for single lower layer */
+	if (WARN_ON(!d->last))
+		return -EIO;
+
+	/* If we have a copy up origin, we should have found a lower dir */
+	if (!*lower) {
+		pr_warn_ratelimited("overlayfs: failed to find lower dir\n");
+		return -ENOENT;
+	}
+
+	fh = ovl_encode_fh(*lower);
+	if (IS_ERR(fh)) {
+		ret = PTR_ERR(fh);
+		fh = NULL;
+		goto fail;
+	} else if (fh->len != d->fh->len || memcmp(fh, d->fh, fh->len)) {
+		ret = fh->len;
+		goto fail;
+	}
+
+	ret = 0;
+out:
+	/* Don't verify that handle again */
+	ovl_reset_redirect_fh(d);
+	kfree(fh);
+	return ret;
+
+fail:
+	inode = d_inode(*lower);
+	pr_warn_ratelimited("overlayfs: failed to verify lower dir (ino=%lu, ret=%i) - were layers copied?\n",
+			    inode ? inode->i_ino : 0, ret);
+	dput(*lower);
+	*lower = NULL;
+	goto out;
+}
+
+/*
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
  */
@@ -411,6 +463,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		.by_path = true,
 		.redirect = NULL,
 		.by_fh = ofs->redirect_fh,
+		.verify_fh = ofs->config.verify_lower,
 		.fh = NULL,
 	};
 
@@ -484,6 +537,10 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (err)
 			goto out_put;
 
+		/* Verify that lower matches the copy up origin fh */
+		if (d.verify_fh && d.fh && ovl_verify_lower_fh(&this, &d))
+			break;
+
 		if (!this)
 			continue;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 90181e16..d9ff028a 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -190,6 +190,7 @@ bool ovl_dentry_is_whiteout(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry);
 bool ovl_redirect_dir(struct super_block *sb);
 void ovl_clear_redirect_dir(struct super_block *sb);
+bool ovl_verify_lower(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 bool ovl_redirect_fh(struct super_block *sb);
@@ -263,3 +264,4 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
+struct ovl_fh *ovl_encode_fh(struct dentry *lower);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 3abf025..0e26af2 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -14,6 +14,7 @@ struct ovl_config {
 	char *workdir;
 	bool default_permissions;
 	bool redirect_dir;
+	bool verify_lower;
 };
 
 /* private information held for overlayfs's superblock */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e639750..a7c03ca 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -280,6 +280,7 @@ enum {
 	OPT_DEFAULT_PERMISSIONS,
 	OPT_REDIRECT_DIR_ON,
 	OPT_REDIRECT_DIR_OFF,
+	OPT_VERIFY_LOWER,
 	OPT_ERR,
 };
 
@@ -290,6 +291,7 @@ static const match_table_t ovl_tokens = {
 	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
 	{OPT_REDIRECT_DIR_ON,		"redirect_dir=on"},
 	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
+	{OPT_VERIFY_LOWER,		"verify_lower"},
 	{OPT_ERR,			NULL}
 };
 
@@ -362,6 +364,10 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->redirect_dir = false;
 			break;
 
+		case OPT_VERIFY_LOWER:
+			config->verify_lower = true;
+			break;
+
 		default:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
@@ -957,6 +963,23 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			pr_warn("overlayfs: lower fs needs to report s_uuid.\n");
 	}
 
+	/*
+	 * The verify_lower feature is used to verify that lower directory
+	 * found by path matches the stored copy up origin.  Currently, only
+	 * single lower layer on same fs as upper layer is supported.
+	 */
+	if (ufs->config.verify_lower) {
+		ufs->config.verify_lower = false;
+		if (!ufs->same_sb)
+			pr_warn("overlayfs: option \"verify_lower\" requires lower/upper on same fs.\n");
+		if (numlower > 1)
+			pr_warn("overlayfs: option \"verify_lower\" requires single lower layer.\n");
+		else if (!ufs->redirect_fh)
+			pr_warn("overlayfs: option \"verify_lower\" not supported by lower fs.\n");
+		else
+			ufs->config.verify_lower = true;
+	}
+
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
 	else
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 08c55e6..dad924d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -207,6 +207,13 @@ void ovl_clear_redirect_dir(struct super_block *sb)
 	ofs->config.redirect_dir = false;
 }
 
+bool ovl_verify_lower(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->config.verify_lower;
+}
+
 const char *ovl_dentry_get_redirect(struct dentry *dentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-- 
2.7.4
