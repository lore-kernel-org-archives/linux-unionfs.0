From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 06/13] ovl: Copy up only metadata during copy up where it makes sense
Date: Wed, 25 Oct 2017 15:09:28 -0400
Message-ID: <1508958575-14086-7-git-send-email-vgoyal@redhat.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44764 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932338AbdJYTJn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2017 15:09:43 -0400
In-Reply-To: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

If it makes sense to copy up only metadata during copy up, do it. This
is done for regular files which are not opened for WRITE and have origin
being saved.

Right now ->metacopy is set to 0 hard coded. Last patch in the series will
set it based on config option and enable the feature.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 4f580ec..2936284 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -306,11 +306,8 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
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
@@ -328,6 +325,7 @@ struct ovl_copy_up_ctx {
 	struct dentry *workdir;
 	bool tmpfile;
 	bool origin;
+	bool metacopy;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -456,11 +454,15 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	 */
 	if (c->origin) {
 		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
-		if (err)
-			return err;
+		if (err) {
+			if (err != -EOPNOTSUPP)
+				return err;
+			/* Upper does not support xattr. Copy up data as well */
+			c->metacopy = false;
+		}
 	}
 
-	if (S_ISREG(c->stat.mode)) {
+	if (S_ISREG(c->stat.mode) && !c->metacopy) {
 		struct path upperpath;
 
 		ovl_path_upper(c->dentry, &upperpath);
@@ -590,6 +592,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		.dentry = dentry,
 		.workdir = ovl_workdir(dentry),
 		.origin = true,
+		.metacopy = false,
 	};
 
 	if (WARN_ON(!ctx.workdir))
@@ -610,9 +613,17 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (err)
 		return err;
 
+	if (!S_ISREG(ctx.stat.mode))
+		ctx.metacopy = false;
+
 	/* maybe truncate regular file. this has no effect on dirs */
-	if (flags & O_TRUNC)
+	if (flags & O_TRUNC) {
 		ctx.stat.size = 0;
+		ctx.metacopy = false;
+	}
+
+	if (flags & (OPEN_FMODE(flags) & FMODE_WRITE))
+		ctx.metacopy = false;
 
 	if (S_ISLNK(ctx.stat.mode)) {
 		ctx.link = vfs_get_link(ctx.lowerpath.dentry, &done);
-- 
2.5.5
