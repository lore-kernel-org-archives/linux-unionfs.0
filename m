From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v11 07/18] ovl: Copy up only metadata during copy up where it makes sense
Date: Wed, 31 Jan 2018 16:13:18 -0500
Message-ID: <20180131211329.16328-8-vgoyal@redhat.com>
References: <20180131211329.16328-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:58520 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751669AbeAaVNn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 Jan 2018 16:13:43 -0500
In-Reply-To: <20180131211329.16328-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

If it makes sense to copy up only metadata during copy up, do it. This
is done for regular files which are not opened for WRITE and have origin
being saved.

Right now ->metacopy is set to 0 always. Last patch in the series will
remove the hard coded statement and enable metacopy feature.

Currently ovl_set_origin() returns success even if specified xattr could
not be set due to -EOPNOTSUPP returned by upper. IOW, ovl_set_origin()
operation is optional and copy up operation continues.

With metadata copy up, ovl_set_origin() can't be optional. We need to know
if origin could be set or not. If it could not be set, then either disable
metacopy or abort copy up operation. I have take then later approach and
disable metacopy for this inode.

Normally we should not run into this path as metacopy will not be enabled
if upper does not support xattr. This check is done during mount. This
path can only hit if checks during mount pass but at some point of time
later upper still returns -EOPNOTSUPP. So its a saftey mechanism to handle
that unexpected -EOPNOTSUPP.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 38 +++++++++++++++++++++++++++++++-------
 1 file changed, 31 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 31711edf5bde..c5804b87f3c7 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -232,6 +232,26 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
 	return err;
 }
 
+static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
+				  int flags)
+{
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+
+	/* TODO: Will enable metacopy in last patch of series */
+	return false;
+
+	if (!ofs->config.metacopy)
+		return false;
+
+	if (!S_ISREG(mode))
+		return false;
+
+	if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
+		return false;
+
+	return true;
+}
+
 struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
 {
 	struct ovl_fh *fh;
@@ -305,11 +325,8 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
 			return PTR_ERR(fh);
 	}
 
-	/*
-	 * Do not fail when upper doesn't support xattrs.
-	 */
 	err = ovl_check_setxattr(dentry, upper, OVL_XATTR_ORIGIN, fh,
-				 fh ? fh->len : 0, 0);
+				 fh ? fh->len : 0, -EOPNOTSUPP);
 	kfree(fh);
 
 	return err;
@@ -326,6 +343,7 @@ struct ovl_copy_up_ctx {
 	struct qstr destname;
 	struct dentry *workdir;
 	bool tmpfile;
+	bool metacopy;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -453,10 +471,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	 *
 	 */
 	err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
-	if (err)
-		return err;
+	if (err) {
+		if (err != -EOPNOTSUPP)
+			return err;
+		/* Upper does not support xattr. Copy up data as well */
+		c->metacopy = false;
+	}
 
-	if (S_ISREG(c->stat.mode)) {
+	if (S_ISREG(c->stat.mode) && !c->metacopy) {
 		struct path upperpath;
 
 		ovl_path_upper(c->dentry, &upperpath);
@@ -601,6 +623,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (err)
 		return err;
 
+	ctx.metacopy = ovl_need_meta_copy_up(dentry, ctx.stat.mode, flags);
+
 	ovl_path_upper(parent, &parentpath);
 	ctx.destdir = parentpath.dentry;
 	ctx.destname = dentry->d_name;
-- 
2.13.6
