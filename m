From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v8 08/15] ovl: Copy up only metadata during copy up where it makes sense
Date: Tue, 28 Nov 2017 10:59:52 -0500
Message-ID: <20171128155959.20114-9-vgoyal@redhat.com>
References: <20171128155959.20114-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:53650 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753996AbdK1QAM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 11:00:12 -0500
In-Reply-To: <20171128155959.20114-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com

If it makes sense to copy up only metadata during copy up, do it. This
is done for regular files which are not opened for WRITE and have origin
being saved.

Right now ->metacopy is set to 0 always. Last patch in the series will
remove the hard coded statement and enable metacopy feature.

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
