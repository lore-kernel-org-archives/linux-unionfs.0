From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 3/5] ovl: add support for verify_lower mount option
Date: Thu,  1 Jun 2017 20:01:52 +0300
Message-ID: <1496336514-11000-4-git-send-email-amir73il@gmail.com>
References: <1496336514-11000-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33016 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751846AbdFARBz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 13:01:55 -0400
In-Reply-To: <1496336514-11000-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

When overlayfs is mounted with option 'verify_lower', a directory inode
found in lower layer by name or by redirect_dir is verified against the
file handle of the copy up origin that is stored in the upper layer.

The 'verify_lower' option should not be used after copying layers,
because the new lower directory inodes would fail verification.

Internally, 'verify_lower' is implemented as an alias to mount option
'verify_dir=<verify_mask>'. Currently, 'verify_mask' is a bitmask with a
single defined flag (__OVL_VERIFY_MERGE). That bitmask is going to be
extended with more flags for more directory inode verifications soon.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 16 +++++---
 fs/overlayfs/namei.c     | 95 ++++++++++++++++++++++++++++++++++++++++++------
 fs/overlayfs/overlayfs.h | 15 ++++++++
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 34 +++++++++++++++++
 fs/overlayfs/util.c      |  7 ++++
 6 files changed, 151 insertions(+), 17 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 7a44533f4bbf..047b2c3fdf6a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -233,12 +233,19 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
-static struct ovl_fh *ovl_encode_fh(struct dentry *lower, uuid_be *uuid)
+bool ovl_can_decode_fh(struct super_block *sb)
+{
+	return (sb->s_export_op && sb->s_export_op->fh_to_dentry &&
+		uuid_be_cmp(*(uuid_be *) &sb->s_uuid, NULL_UUID_BE));
+}
+
+struct ovl_fh *ovl_encode_fh(struct dentry *lower)
 {
 	struct ovl_fh *fh;
 	int fh_type, fh_len, dwords;
 	void *buf;
 	int buflen = MAX_HANDLE_SZ;
+	uuid_be *uuid = (uuid_be *) &lower->d_sb->s_uuid;
 
 	buf = kmalloc(buflen, GFP_TEMPORARY);
 	if (!buf)
@@ -283,8 +290,6 @@ static struct ovl_fh *ovl_encode_fh(struct dentry *lower, uuid_be *uuid)
 static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 			  struct dentry *upper)
 {
-	struct super_block *sb = lower->d_sb;
-	uuid_be *uuid = (uuid_be *) &sb->s_uuid;
 	const struct ovl_fh *fh = NULL;
 	int err;
 
@@ -293,9 +298,8 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 	 * so we can use the overlay.origin xattr to distignuish between a copy
 	 * up and a pure upper inode.
 	 */
-	if (sb->s_export_op && sb->s_export_op->fh_to_dentry &&
-	    uuid_be_cmp(*uuid, NULL_UUID_BE)) {
-		fh = ovl_encode_fh(lower, uuid);
+	if (ovl_can_decode_fh(lower->d_sb)) {
+		fh = ovl_encode_fh(lower);
 		if (IS_ERR(fh))
 			return PTR_ERR(fh);
 	}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 4ca6061f7bfa..4a37f2fc3bbe 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -88,13 +88,11 @@ static int ovl_acceptable(void *ctx, struct dentry *dentry)
 	return 1;
 }
 
-static struct dentry *ovl_get_origin(struct dentry *dentry,
-				     struct vfsmount *mnt)
+static struct ovl_fh *ovl_get_origin_fh(struct dentry *dentry,
+					struct vfsmount *mnt)
 {
 	int res;
 	struct ovl_fh *fh = NULL;
-	struct dentry *origin = NULL;
-	int bytes;
 
 	res = vfs_getxattr(dentry, OVL_XATTR_ORIGIN, NULL, 0);
 	if (res < 0) {
@@ -106,7 +104,7 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	if (res == 0)
 		return NULL;
 
-	fh  = kzalloc(res, GFP_TEMPORARY);
+	fh = kzalloc(res, GFP_TEMPORARY);
 	if (!fh)
 		return ERR_PTR(-ENOMEM);
 
@@ -129,8 +127,6 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	    (fh->flags & OVL_FH_FLAG_BIG_ENDIAN) != OVL_FH_FLAG_CPU_ENDIAN)
 		goto out;
 
-	bytes = (fh->len - offsetof(struct ovl_fh, fid));
-
 	/*
 	 * Make sure that the stored uuid matches the uuid of the lower
 	 * layer where file handle will be decoded.
@@ -138,6 +134,31 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	if (uuid_be_cmp(fh->uuid, *(uuid_be *) &mnt->mnt_sb->s_uuid))
 		goto out;
 
+	return fh;
+
+out:
+	kfree(fh);
+	return NULL;
+
+fail:
+	pr_warn_ratelimited("overlayfs: failed to get origin (%i)\n", res);
+	goto out;
+invalid:
+	pr_warn_ratelimited("overlayfs: invalid origin (%*phN)\n", res, fh);
+	goto out;
+}
+
+static struct dentry *ovl_get_origin(struct dentry *dentry,
+				     struct vfsmount *mnt)
+{
+	struct dentry *origin = NULL;
+	struct ovl_fh *fh = ovl_get_origin_fh(dentry, mnt);
+	int bytes;
+
+	if (!fh)
+		return NULL;
+
+	bytes = (fh->len - offsetof(struct ovl_fh, fid));
 	origin = exportfs_decode_fh(mnt, (struct fid *)fh->fid,
 				    bytes >> 2, (int)fh->type,
 				    ovl_acceptable, NULL);
@@ -159,11 +180,8 @@ static struct dentry *ovl_get_origin(struct dentry *dentry,
 	kfree(fh);
 	return origin;
 
-fail:
-	pr_warn_ratelimited("overlayfs: failed to get origin (%i)\n", res);
-	goto out;
 invalid:
-	pr_warn_ratelimited("overlayfs: invalid origin (%*phN)\n", res, fh);
+	pr_warn_ratelimited("overlayfs: invalid origin (%*phN)\n", fh->len, fh);
 	goto out;
 }
 
@@ -305,6 +323,50 @@ static int ovl_check_origin(struct dentry *dentry, struct dentry *upperdentry,
 }
 
 /*
+ * Verify that an inode matches the origin file handle stored in upper inode.
+ * Return 0 on match, -ESTALE on mismatch, < 0 on error.
+ */
+int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
+		      struct dentry *origin)
+{
+	struct inode *inode = NULL;
+	struct ovl_fh *fh = NULL;
+	struct ovl_fh *ofh = ovl_get_origin_fh(dentry, mnt);
+	int err;
+
+	/* Fail verification with no warning if no valid origin fh */
+	if (!ofh)
+		return -ENODATA;
+
+	if (IS_ERR(ofh)) {
+		err = PTR_ERR(ofh);
+		goto fail;
+	}
+
+	fh = ovl_encode_fh(origin);
+	if (IS_ERR(fh)) {
+		err = PTR_ERR(fh);
+		fh = NULL;
+		goto fail;
+	} else if (fh->len != ofh->len || memcmp(fh, ofh, fh->len)) {
+		err = -ESTALE;
+		goto fail;
+	}
+
+	err = 0;
+out:
+	kfree(ofh);
+	kfree(fh);
+	return err;
+
+fail:
+	inode = d_inode(origin);
+	pr_warn_ratelimited("overlayfs: failed to verify origin (ino=%lu, err=%i) - were layers copied?\n",
+			    inode ? inode->i_ino : 0, err);
+	goto out;
+}
+
+/*
  * Returns next layer in stack starting from top.
  * Returns -1 if this is the last layer.
  */
@@ -416,6 +478,17 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (err)
 			goto out_put;
 
+		/* Verify that uppermost lower matches the copy up origin fh */
+		if (this && upperdentry && !ctr &&
+		    OVL_VERIFY_MERGE(ovl_verify_dir(dentry->d_sb))) {
+			err = ovl_verify_origin(upperdentry, lowerpath.mnt,
+						this);
+			if (err && err != -ENODATA) {
+				dput(this);
+				break;
+			}
+		}
+
 		if (!this)
 			continue;
 
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 513e25e56eed..e65910ef215b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -20,6 +20,16 @@ enum ovl_path_type {
 #define OVL_TYPE_MERGE(type)	((type) & __OVL_PATH_MERGE)
 #define OVL_TYPE_ORIGIN(type)	((type) & __OVL_PATH_ORIGIN)
 
+enum ovl_verify_dir {
+	__OVL_VERIFY_MERGE	= (1 << 0),
+};
+
+/* Verify on lookup of merge dir that lower matches origin fh stored in upper */
+#define OVL_VERIFY_MERGE(v)	((v) & __OVL_VERIFY_MERGE)
+
+/* Verify flags for mount options 'verify_lower' */
+#define OVL_VERIFY_LOWER	(__OVL_VERIFY_MERGE)
+
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
 #define OVL_XATTR_REDIRECT OVL_XATTR_PREFIX "redirect"
@@ -191,6 +201,7 @@ void ovl_drop_write(struct dentry *dentry);
 struct dentry *ovl_workdir(struct dentry *dentry);
 const struct cred *ovl_override_creds(struct super_block *sb);
 struct super_block *ovl_same_sb(struct super_block *sb);
+unsigned int ovl_verify_dir(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
 bool ovl_dentry_weird(struct dentry *dentry);
@@ -233,6 +244,8 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 
 /* namei.c */
+int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
+		      struct dentry *origin);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
@@ -291,3 +304,5 @@ int ovl_copy_up(struct dentry *dentry);
 int ovl_copy_up_flags(struct dentry *dentry, int flags);
 int ovl_copy_xattr(struct dentry *old, struct dentry *new);
 int ovl_set_attr(struct dentry *upper, struct kstat *stat);
+bool ovl_can_decode_fh(struct super_block *sb);
+struct ovl_fh *ovl_encode_fh(struct dentry *lower);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index b0e7ee2ae398..298670fccbb6 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -14,6 +14,7 @@ struct ovl_config {
 	char *workdir;
 	bool default_permissions;
 	bool redirect_dir;
+	unsigned int verify_dir;
 };
 
 /* private information held for overlayfs's superblock */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 476f021baf2a..b677d38bca5c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -265,6 +265,12 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
 	if (ufs->config.redirect_dir != ovl_redirect_dir_def)
 		seq_printf(m, ",redirect_dir=%s",
 			   ufs->config.redirect_dir ? "on" : "off");
+	if (ufs->config.verify_dir) {
+		if (ufs->config.verify_dir == OVL_VERIFY_LOWER)
+			seq_puts(m, ",verify_lower");
+		else
+			seq_printf(m, ",verify_dir=%x", ufs->config.verify_dir);
+	}
 	return 0;
 }
 
@@ -294,6 +300,8 @@ enum {
 	OPT_DEFAULT_PERMISSIONS,
 	OPT_REDIRECT_DIR_ON,
 	OPT_REDIRECT_DIR_OFF,
+	OPT_VERIFY_LOWER,
+	OPT_VERIFY_DIR,
 	OPT_ERR,
 };
 
@@ -304,6 +312,8 @@ static const match_table_t ovl_tokens = {
 	{OPT_DEFAULT_PERMISSIONS,	"default_permissions"},
 	{OPT_REDIRECT_DIR_ON,		"redirect_dir=on"},
 	{OPT_REDIRECT_DIR_OFF,		"redirect_dir=off"},
+	{OPT_VERIFY_LOWER,		"verify_lower"},
+	{OPT_VERIFY_DIR,		"verify_dir=%u"},
 	{OPT_ERR,			NULL}
 };
 
@@ -376,7 +386,17 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
 			config->redirect_dir = false;
 			break;
 
+		case OPT_VERIFY_LOWER:
+			config->verify_dir = OVL_VERIFY_LOWER;
+			break;
+
+		case OPT_VERIFY_DIR:
+			if (match_hex(args, &config->verify_dir))
+				goto parse_err;
+			break;
+
 		default:
+parse_err:
 			pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
 			return -EINVAL;
 		}
@@ -964,6 +984,20 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			ufs->same_sb = mnt->mnt_sb;
 		else if (ufs->same_sb != mnt->mnt_sb)
 			ufs->same_sb = NULL;
+
+		/*
+		 * The verify_lower feature is used to verify that lower dir
+		 * found by path matches the stored copy up origin file handle.
+		 * It requires that all layers support NFS export.
+		 */
+		if (ufs->config.verify_dir) {
+			err = -EOPNOTSUPP;
+			if (!ovl_can_decode_fh(mnt->mnt_sb)) {
+				pr_err("overlayfs: option \"verify_lower\" not supported by lower fs.\n");
+				goto out_put_lower_mnt;
+			}
+		}
+
 	}
 
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 809048913889..535665243fe8 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -47,6 +47,13 @@ struct super_block *ovl_same_sb(struct super_block *sb)
 	return ofs->same_sb;
 }
 
+unsigned int ovl_verify_dir(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->config.verify_dir;
+}
+
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower)
 {
 	size_t size = offsetof(struct ovl_entry, lowerstack[numlower]);
-- 
2.7.4
