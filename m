Return-Path: <miklos@szeredi.hu>
Date: Mon, 4 Feb 2019 10:05:26 +0100
From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH][v3] overlayfs: Do not lose security.capability xattr
 over metadata file copy-up
Message-ID: <20190204090526.GC23837@veci.piliscsaba.redhat.com>
References: <20190130190157.GC15061@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190130190157.GC15061@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Jan 30, 2019 at 02:01:57PM -0500, Vivek Goyal wrote:
> If a file has been copied up metadata only, and later data is copied up,
> upper loses any security.capability xattr it has (underlying filesystem
> clears it as upon file write).
> 
> From a user's point of view, this is just a file copy-up and that should
> not result in losing security.capability xattr. Hence, before data copy
> up, save security.capability xattr (if any) and restore it on upper after
> data copy up is complete.
> 
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>


Cleaned it up a bit.  Hope I didn't break it...

Thanks,
Miklos

---
 fs/overlayfs/copy_up.c   |   27 +++++++++++++++++++++--
 fs/overlayfs/overlayfs.h |    2 +
 fs/overlayfs/util.c      |   55 +++++++++++++++++++++++++++++------------------
 3 files changed, 62 insertions(+), 22 deletions(-)

--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -863,28 +863,49 @@ bool ovl_is_metacopy_dentry(struct dentr
 	return (oe->numlower > 1);
 }
 
-char *ovl_get_redirect_xattr(struct dentry *dentry, int padding)
+ssize_t ovl_getxattr(struct dentry *dentry, char *name, char **value,
+		     size_t padding)
 {
-	int res;
-	char *s, *next, *buf = NULL;
+	ssize_t res;
+	char *buf = NULL;
 
-	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, NULL, 0);
+	res = vfs_getxattr(dentry, name, NULL, 0);
 	if (res < 0) {
 		if (res == -ENODATA || res == -EOPNOTSUPP)
-			return NULL;
+			return -ENODATA;
 		goto fail;
 	}
 
-	buf = kzalloc(res + padding + 1, GFP_KERNEL);
-	if (!buf)
-		return ERR_PTR(-ENOMEM);
+	if (res != 0) {
+		buf = kzalloc(res + padding, GFP_KERNEL);
+		if (!buf)
+			return -ENOMEM;
+
+		res = vfs_getxattr(dentry, name, buf, res);
+		if (res < 0)
+			goto fail;
+	}
+	*value = buf;
 
-	if (res == 0)
-		goto invalid;
+	return res;
+
+fail:
+	pr_warn_ratelimited("overlayfs: failed to get xattr %s: err=%zi)\n",
+			    name, res);
+	kfree(buf);
+	return res;
+}
+
+char *ovl_get_redirect_xattr(struct dentry *dentry, int padding)
+{
+	int res;
+	char *s, *next, *buf = NULL;
 
-	res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, buf, res);
+	res = ovl_getxattr(dentry, OVL_XATTR_REDIRECT, &buf, padding + 1);
+	if (res == -ENODATA)
+		return NULL;
 	if (res < 0)
-		goto fail;
+		return ERR_PTR(res);
 	if (res == 0)
 		goto invalid;
 
@@ -900,15 +921,9 @@ char *ovl_get_redirect_xattr(struct dent
 	}
 
 	return buf;
-
-err_free:
-	kfree(buf);
-	return ERR_PTR(res);
-fail:
-	pr_warn_ratelimited("overlayfs: failed to get redirect (%i)\n", res);
-	goto err_free;
 invalid:
 	pr_warn_ratelimited("overlayfs: invalid redirect (%s)\n", buf);
 	res = -EINVAL;
-	goto err_free;
+	kfree(buf);
+	return ERR_PTR(res);
 }
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -277,6 +277,8 @@ int ovl_lock_rename_workdir(struct dentr
 int ovl_check_metacopy_xattr(struct dentry *dentry);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
 char *ovl_get_redirect_xattr(struct dentry *dentry, int padding);
+ssize_t ovl_getxattr(struct dentry *dentry, char *name, char **value,
+		     size_t padding);
 
 static inline bool ovl_is_impuredir(struct dentry *dentry)
 {
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -742,6 +742,8 @@ static int ovl_copy_up_meta_inode_data(s
 {
 	struct path upperpath, datapath;
 	int err;
+	char *capability = NULL;
+	ssize_t uninitialized_var(cap_size);
 
 	ovl_path_upper(c->dentry, &upperpath);
 	if (WARN_ON(upperpath.dentry == NULL))
@@ -751,15 +753,36 @@ static int ovl_copy_up_meta_inode_data(s
 	if (WARN_ON(datapath.dentry == NULL))
 		return -EIO;
 
+	if (c->stat.size) {
+		err = cap_size = ovl_getxattr(upperpath.dentry, XATTR_NAME_CAPS,
+					      &capability, 0);
+		if (err < 0 && err != -ENODATA)
+			goto out;
+	}
+
 	err = ovl_copy_up_data(&datapath, &upperpath, c->stat.size);
 	if (err)
-		return err;
+		goto out_free;
+
+	/*
+	 * Writing to upper file will clear security.capability xattr. We
+	 * don't want that to happen for normal copy-up operation.
+	 */
+	if (capability) {
+		err = ovl_do_setxattr(upperpath.dentry, XATTR_NAME_CAPS, capability, cap_size, 0);
+		if (err)
+			goto out_free;
+	}
+
 
 	err = vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
 	if (err)
-		return err;
+		goto out_free;
 
 	ovl_set_upperdata(d_inode(c->dentry));
+out_free:
+	kfree(capability);
+out:
 	return err;
 }
 
