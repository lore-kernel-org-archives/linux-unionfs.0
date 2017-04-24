From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 04/11] ovl: store file handle of lower inode on copy up
Date: Mon, 24 Apr 2017 12:14:09 +0300
Message-ID: <1493025256-27188-5-git-send-email-amir73il@gmail.com>
References: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Sometimes it is interesting to know if an upper file is pure
upper or a copy up target, and if it is a copy up target, it
may be interesting to find the copy up origin.

This will be used to preserve lower inode numbers across copy up.

Store the lower inode file handle in upper inode xattr overlay.fh
on copy up to use it later for these cases.

On failure to encode lower file handle, store an invalid 'null'
handle, so we can always use the overlay.fh xattr to distignuish
between a copy up and a pure upper inode.

If lower fs does not support NFS export ops or if not all lower
layers are on the same fs, don't try to encode a lower file handle
and use the 'null' handle instead.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 98 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h | 15 ++++++++
 fs/overlayfs/ovl_entry.h |  2 +
 fs/overlayfs/super.c     | 11 ++++++
 fs/overlayfs/util.c      | 14 +++++++
 5 files changed, 140 insertions(+)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 906ea6c..1a967b9 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -20,6 +20,7 @@
 #include <linux/namei.h>
 #include <linux/fdtable.h>
 #include <linux/ratelimit.h>
+#include <linux/exportfs.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -232,6 +233,95 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
+static struct ovl_fh *ovl_get_fh(struct dentry *lower)
+{
+	const struct export_operations *nop = lower->d_sb->s_export_op;
+	struct ovl_fh *fh;
+	int fh_type, fh_len, dwords;
+	void *buf = NULL;
+	void *ret = NULL;
+	int buflen = MAX_HANDLE_SZ;
+	int err;
+
+	/* Do not encode file handle if we cannot decode it later */
+	err = -EOPNOTSUPP;
+	if (!nop || !nop->fh_to_dentry)
+		goto out_err;
+
+	err = -ENOMEM;
+	buf = kmalloc(buflen, GFP_TEMPORARY);
+	if (!buf)
+		goto out_err;
+
+	fh = buf;
+	dwords = (buflen - offsetof(struct ovl_fh, fid)) >> 2;
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
+static struct ovl_fh null_fh = {
+	.version = OVL_FH_VERSION,
+	.magic = OVL_FH_MAGIC,
+	.type = FILEID_INVALID,
+	.len = sizeof(struct ovl_fh),
+};
+
+static int ovl_set_lower_fh(struct dentry *dentry, struct dentry *upper)
+{
+	int err;
+	const struct ovl_fh *fh = NULL;
+
+	if (ovl_redirect_fh(dentry->d_sb))
+		fh = ovl_get_fh(ovl_dentry_lower(dentry));
+	/*
+	 * On failure to encode lower fh, store an invalid 'null' fh, so
+	 * we can always use the overlay.fh xattr to distignuish between
+	 * a copy up and a pure upper inode.  If lower fs does not support
+	 * encoding fh, don't try to encode again.
+	 */
+	err = PTR_ERR(fh);
+	if (IS_ERR_OR_NULL(fh)) {
+		if (err == -EOPNOTSUPP) {
+			pr_warn("overlay: file handle not supported by lower - turning off redirect_fh\n");
+			ovl_clear_redirect_fh(dentry->d_sb);
+		}
+		fh = &null_fh;
+	}
+
+	err = ovl_do_setxattr(upper, OVL_XATTR_FH, fh, fh->len, 0);
+
+	if (fh != &null_fh)
+		kfree(fh);
+	return err;
+}
+
 static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 			      struct dentry *dentry, struct path *lowerpath,
 			      struct kstat *stat, const char *link,
@@ -316,6 +406,14 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 	if (err)
 		goto out_cleanup;
 
+	/*
+	 * Store file handle of lower inode in upper inode xattr to
+	 * allow lookup of the copy up origin inode.
+	 */
+	err = ovl_set_lower_fh(dentry, temp);
+	if (err)
+		goto out_cleanup;
+
 	if (tmpfile)
 		err = ovl_do_link(temp, udir, upper, true);
 	else
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 48d0dae..c3cfbc5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -22,6 +22,7 @@ enum ovl_path_type {
 #define OVL_XATTR_PREFIX XATTR_TRUSTED_PREFIX "overlay."
 #define OVL_XATTR_OPAQUE OVL_XATTR_PREFIX "opaque"
 #define OVL_XATTR_REDIRECT OVL_XATTR_PREFIX "redirect"
+#define OVL_XATTR_FH OVL_XATTR_PREFIX "fh"
 
 #define OVL_ISUPPER_MASK 1UL
 
@@ -148,6 +149,18 @@ static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
 	return (struct inode *) (x & ~OVL_ISUPPER_MASK);
 }
 
+/* redirect data format for redirect by file handle */
+struct ovl_fh {
+	unsigned char version;	/* 0 */
+	unsigned char magic;	/* 0xfb */
+	unsigned char len;	/* size of this header + size of fid */
+	unsigned char type;	/* fid_type of fid */
+	unsigned char fid[0];	/* file identifier */
+} __packed;
+
+#define OVL_FH_VERSION	0
+#define OVL_FH_MAGIC	0xfb
+
 /* util.c */
 int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
@@ -175,6 +188,8 @@ bool ovl_redirect_dir(struct super_block *sb);
 void ovl_clear_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
+bool ovl_redirect_fh(struct super_block *sb);
+void ovl_clear_redirect_fh(struct super_block *sb);
 void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry);
 void ovl_inode_init(struct inode *inode, struct inode *realinode,
 		    bool is_upper);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 41708bf..2172dc5 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -32,6 +32,8 @@ struct ovl_fs {
 	/* sb common to all (or all lower) layers */
 	struct super_block *same_lower_sb;
 	struct super_block *same_sb;
+	/* redirect by file handle */
+	bool redirect_fh;
 };
 
 enum ovl_path_type;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b8830ee..34632ec 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -17,6 +17,7 @@
 #include <linux/statfs.h>
 #include <linux/seq_file.h>
 #include <linux/posix_acl_xattr.h>
+#include <linux/exportfs.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -929,6 +930,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	else if (ufs->upper_mnt->mnt_sb == ufs->same_lower_sb)
 		ufs->same_sb = ufs->same_lower_sb;
 
+	/*
+	 * Redirect by file handle is used to find a lower entry in one of the
+	 * lower layers,  so the handle must be unique across all lower layers.
+	 * Therefore, enable redirect by file handle, only if all lower layers
+	 * are on the same sb which supports lookup by file handles.
+	 */
+	if (ufs->same_lower_sb && ufs->same_lower_sb->s_export_op &&
+	    ufs->same_lower_sb->s_export_op->fh_to_dentry)
+		ufs->redirect_fh = true;
+
 	if (remote)
 		sb->s_d_op = &ovl_reval_dentry_operations;
 	else
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 43dcdf5..b3bc117 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -240,6 +240,20 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect)
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
