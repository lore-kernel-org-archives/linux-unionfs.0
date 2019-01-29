Return-Path: <vgoyal@redhat.com>
Date: Tue, 29 Jan 2019 15:50:42 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH] overlayfs: Do not lose security.capability xattr over
 metadata file copy-up
Message-ID: <20190129205042.GA22017@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
To: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com
List-ID: <linux-unionfs@vger.kernel.org>

If a file has been copied up metadata only, and later data is copied up,
upper loses any security.capability xattr it has (underlying filesystem
clears it as upon file write).

>From a user's point of view, this is just a file copy-up and that should
not result in losing security.capability xattr. Hence, before data copy
up, save security.capability xattr (if any) and restore it on upper after
data copy up is complete.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c   |   24 +++++++++++++++++++++++-
 fs/overlayfs/overlayfs.h |    1 +
 fs/overlayfs/util.c      |   44 ++++++++++++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+), 1 deletion(-)

Index: rhvgoyal-linux/fs/overlayfs/util.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/util.c	2019-01-28 14:42:10.499670636 -0500
+++ rhvgoyal-linux/fs/overlayfs/util.c	2019-01-29 14:45:49.747395201 -0500
@@ -912,3 +912,47 @@ invalid:
 	res = -EINVAL;
 	goto err_free;
 }
+
+size_t ovl_getxattr(struct dentry *dentry, char *name, void **value,
+				size_t *size)
+{
+	int res;
+	void *buf = NULL;
+
+	res = vfs_getxattr(dentry, name, NULL, 0);
+	if (res < 0) {
+		if (res == -ENODATA || res == -EOPNOTSUPP)
+			return 0;
+		goto fail;
+	}
+
+	if (res == 0)
+		goto invalid;
+
+	buf = kzalloc(res, GFP_KERNEL);
+	if (!buf)
+		return -ENOMEM;
+
+	res = vfs_getxattr(dentry, name, buf, res);
+	if (res < 0)
+		goto fail;
+
+	if (res == 0)
+		goto invalid;
+
+	*value = buf;
+	*size = res;
+
+	return res;
+
+err_free:
+	kfree(buf);
+	return res;
+fail:
+	pr_warn_ratelimited("overlayfs: failed to get xattr %s: err=%i)\n", name, res);
+	goto err_free;
+invalid:
+	pr_warn_ratelimited("overlayfs: invalid xattr %s \n", name);
+	res = -EINVAL;
+	goto err_free;
+}
Index: rhvgoyal-linux/fs/overlayfs/overlayfs.h
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/overlayfs.h	2019-01-28 14:42:10.498670636 -0500
+++ rhvgoyal-linux/fs/overlayfs/overlayfs.h	2019-01-29 14:31:15.344575562 -0500
@@ -277,6 +277,7 @@ int ovl_lock_rename_workdir(struct dentr
 int ovl_check_metacopy_xattr(struct dentry *dentry);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct dentry *dentry, int padding);
+size_t ovl_getxattr(struct dentry *dentry, char *name, void **value, size_t *size);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
Index: rhvgoyal-linux/fs/overlayfs/copy_up.c
===================================================================
--- rhvgoyal-linux.orig/fs/overlayfs/copy_up.c	2019-01-28 15:11:36.265434802 -0500
+++ rhvgoyal-linux/fs/overlayfs/copy_up.c	2019-01-29 14:35:06.376575562 -0500
@@ -742,6 +742,8 @@ static int ovl_copy_up_meta_inode_data(s
 {
 	struct path upperpath, datapath;
 	int err;
+	void *capability = NULL;
+	size_t cap_size;
 
 	ovl_path_upper(c->dentry, &upperpath);
 	if (WARN_ON(upperpath.dentry == NULL))
@@ -751,9 +753,29 @@ static int ovl_copy_up_meta_inode_data(s
 	if (WARN_ON(datapath.dentry == NULL))
 		return -EIO;
 
+	if (c->stat.size) {
+		cap_size = ovl_getxattr(upperpath.dentry, XATTR_NAME_CAPS, &capability, &cap_size);
+		if (cap_size < 0)
+			return cap_size;
+	}
+
 	err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
-	if (err)
+	if (err) {
+		kfree(capability);
 		return err;
+	}
+
+	/*
+	 * Writing to upper file will clear security.capability xattr. We
+	 * don't want that to happen for normal copy-up operation.
+	 */
+	if (capability) {
+		err = ovl_do_setxattr(upperpath.dentry, XATTR_NAME_CAPS, capability, cap_size, 0);
+		kfree(capability);
+		if (err)
+			return err;
+	}
+
 
 	err = vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
 	if (err)
