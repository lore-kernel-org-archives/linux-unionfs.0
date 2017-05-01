From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 02/15] ovl: store file handle of lower inode on copy up
Date: Mon,  1 May 2017 16:41:53 +0300
Message-ID: <1493646126-10101-3-git-send-email-amir73il@gmail.com>
References: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:35661 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035208AbdEANmD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 1 May 2017 09:42:03 -0400
In-Reply-To: <1493646126-10101-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Sometimes it is interesting to know if an upper file is pure
upper or a copy up target, and if it is a copy up target, it
may be interesting to find the copy up origin.

This will be used to preserve lower inode numbers across copy up.

Store the lower inode file handle in upper inode extended attribute
overlay.origin on copy up to use it later for these cases.
Store the lower filesystem uuid along side the file handle, so we can
validate that we are looking for the origin file in the original fs.

On failure to encode lower file handle, store an invalid 'null' handle,
so we can always use the overlay.origin xattr to distinguish between
a copy up and a pure upper inode.

If lower fs does not support NFS export ops or if not all layers are
on the same fs, don't try to encode a lower file handle and store the
'null' handle instead.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 109 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  22 ++++++++++
 fs/overlayfs/ovl_entry.h |   2 +
 fs/overlayfs/super.c     |  17 ++++++++
 fs/overlayfs/util.c      |  14 ++++++
 5 files changed, 164 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 906ea6c..767ae77 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -20,6 +20,8 @@
 #include <linux/namei.h>
 #include <linux/fdtable.h>
 #include <linux/ratelimit.h>
+#include <linux/mount.h>
+#include <linux/exportfs.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -232,6 +234,105 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
+static struct ovl_fh *ovl_encode_fh(struct dentry *lower)
+{
+	struct ovl_fh *fh;
+	int fh_type, fh_len, dwords;
+	void *buf = NULL;
+	void *ret = NULL;
+	int buflen = MAX_HANDLE_SZ;
+	int err;
+
+	err = -ENOMEM;
+	buf = kmalloc(buflen, GFP_TEMPORARY);
+	if (!buf)
+		goto out_err;
+
+	fh = buf;
+	dwords = (buflen - offsetof(struct ovl_fh, fid)) >> 2;
+	/*
+	 * We encode a non-connectable file handle for non-dir, because we
+	 * only need to find the lower inode number and we don't want to pay
+	 * the price or reconnecting the dentry.
+	 */
+	fh_type = exportfs_encode_fh(lower,
+				     (struct fid *)fh->fid,
+				     &dwords, 0);
+	fh_len = (dwords << 2) + offsetof(struct ovl_fh, fid);
+
+	err = -EOVERFLOW;
+	if (fh_len > buflen || fh_type <= 0 || fh_type == FILEID_INVALID)
+		goto out_err;
+
+	fh->version = OVL_FH_VERSION;
+	fh->magic = OVL_FH_MAGIC;
+	fh->type = fh_type;
+	fh->len = fh_len;
+	memcpy(fh->uuid, lower->d_sb->s_uuid, sizeof(fh->uuid));
+
+	err = -ENOMEM;
+	ret = kmalloc(fh_len, GFP_KERNEL);
+	if (!ret)
+		goto out_err;
+
+	memcpy(ret, buf, fh_len);
+
+	kfree(buf);
+	return ret;
+
+out_err:
+	pr_warn_ratelimited("overlay: failed to get redirect fh (%i)\n", err);
+	kfree(buf);
+	kfree(ret);
+	return ERR_PTR(err);
+}
+
+static const struct ovl_fh null_fh = {
+	.version = OVL_FH_VERSION,
+	.magic = OVL_FH_MAGIC,
+	.type = FILEID_INVALID,
+	.len = sizeof(struct ovl_fh),
+};
+
+static int ovl_set_origin(struct dentry *dentry, struct dentry *upper)
+{
+	struct path lowerpath;
+	const struct ovl_fh *fh = NULL;
+	int err;
+
+	ovl_path_lower(dentry, &lowerpath);
+	if (WARN_ON(!lowerpath.mnt))
+		return -EIO;
+
+	/*
+	 * redirect_fh is disabled if not all layers are on the same fs, so
+	 * file handles the we encode are unique across all layers.
+	 */
+	if (ovl_redirect_fh(dentry->d_sb))
+		fh = ovl_encode_fh(lowerpath.dentry);
+	/*
+	 * When redirect_fh is disabled or on failure to encode lower fh,
+	 * store an invalid 'null' fh, so we can use the overlay.origin xattr
+	 * to distignuish between a copy up and a pure upper inode.  If lower
+	 * fs does not support encoding fh, disable redirect_fh and don't try
+	 * to encode again.
+	 */
+	if (IS_ERR_OR_NULL(fh)) {
+		err = PTR_ERR(fh);
+		if (err == -EOPNOTSUPP) {
+			pr_warn("overlay: file handle not supported by lower - turning off redirect_fh\n");
+			ovl_clear_redirect_fh(dentry->d_sb);
+		}
+		fh = &null_fh;
+	}
+
+	err = ovl_do_setxattr(upper, OVL_XATTR_ORIGIN, fh, fh->len, 0);
+
+	if (fh != &null_fh)
+		kfree(fh);
+	return err;
+}
+
 static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 			      struct dentry *dentry, struct path *lowerpath,
 			      struct kstat *stat, const char *link,
@@ -316,6 +417,14 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out_cleanup;
 
+	/*
+	 * Store identifier of lower inode in upper inode xattr to
+	 * allow lookup of the copy up origin inode.
+	 */
+	err = ovl_set_origin(dentry, temp);
+	if (err)
+		goto out_cleanup;
+
 	if (tmpfile)
 		err = ovl_do_link(temp, udir, upper, true);
 	else
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 2ddbd44..da37aaf 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -20,6 +20,26 @@ enum ovl_path_type {
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
 #define OVL_XATTR_REDIRECT OVL_XATTR_PREFIX "redirect"
+#define OVL_XATTR_ORIGIN OVL_XATTR_PREFIX "origin"
+
+/*
+ * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
+ * where:
+ * origin.fh	- exported file handle of the lower file
+ * origin.uuid	- uuid of the lower filesystem
+ */
+#define OVL_FH_VERSION	0
+#define OVL_FH_MAGIC	0xfb
+
+/* On-disk and in-memeory format for redirect by file handle */
+struct ovl_fh {
+	unsigned char version;	/* 0 */
+	unsigned char magic;	/* 0xfb */
+	unsigned char len;	/* size of this header + size of fid */
+	unsigned char type;	/* fid_type of fid */
+	unsigned char uuid[16];	/* uuid of filesystem */
+	unsigned char fid[0];	/* file identifier */
+} __packed;
 
 #define OVL_ISUPPER_MASK 1UL
 
@@ -172,6 +192,8 @@ bool ovl_redirect_dir(struct super_block *sb);
 void ovl_clear_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
+bool ovl_redirect_fh(struct super_block *sb);
+void ovl_clear_redirect_fh(struct super_block *sb);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 68fa932..3abf025 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -32,6 +32,8 @@ struct ovl_fs {
 	/* sb common to all (or all lower) layers */
 	struct super_block *same_lower_sb;
 	struct super_block *same_sb;
+	/* redirect by file handle */
+	bool redirect_fh;
 };
 
 /* private information held for every overlayfs dentry */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7d56aa8..de246a5 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -17,6 +17,7 @@
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/exportfs.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -929,6 +930,22 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ufs->upper_mnt->mnt_sb == ufs->same_lower_sb)
 		ufs->same_sb = ufs->same_lower_sb;
 
+	/*
+	 * Redirect by file handle is used to find a dentry in one of the
+	 * layers, so the handle must be unique across all layers.
+	 * Therefore, enable redirect by file handle, only if all layers are
+	 * on the same sb which supports lookup by file handles.
+	 *
+	 * XXX: We could relax this to same_lower_sb, but we currently use
+	 * redirect_fh for constant inode numbers, which require same_sb.
+	 * Also, for NFS export of overlay, it is easier if all layers are on
+	 * the same fs, because then we can export the encoded file handle
+	 * without adding a layer descriptor to it.
+	 */
+	if (ufs->same_sb && ufs->same_sb->s_export_op &&
+	    ufs->same_sb->s_export_op->fh_to_dentry)
+		ufs->redirect_fh = true;
+
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
 	else
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index a474ab9..9db0588 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -222,6 +222,20 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
 	oe->redirect = redirect;
 }
 
+bool ovl_redirect_fh(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->redirect_fh;
+}
+
+void ovl_clear_redirect_fh(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	ofs->redirect_fh = false;
+}
+
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 {
 	struct ovl_entry *oe = dentry->d_fsdata;
-- 
2.7.4
