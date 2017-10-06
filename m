From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 4/8] ovl: Copy up only metadata during copy up where it makes sense
Date: Fri,  6 Oct 2017 13:47:13 -0400
Message-ID: <1507312037-30909-5-git-send-email-vgoyal@redhat.com>
References: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35901 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752328AbdJFRrX (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:47:23 -0400
In-Reply-To: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

If it makes sense to copy up only metadata during copy up, do it. This
is done for regular files which are not opened for WRITE and have origin
being saved.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c | 28 ++++++++++++++++++++--------
 1 file changed, 20 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 00e8ae8bb9aa..a1fb6ccfcc51 100644
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
+	bool metadata_only;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -458,11 +456,15 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 	 */
 	if (c->origin) {
 		err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
-		if (err)
-			return err;
+		if (err) {
+			if (err != -EOPNOTSUPP)
+				return err;
+			/* Upper does not support xattr. Copy up data as well */
+			c->metadata_only = false;
+		}
 	}
 
-	if (S_ISREG(c->stat.mode)) {
+	if (S_ISREG(c->stat.mode) && !c->metadata_only) {
 		struct path upperpath;
 
 		ovl_path_upper(c->dentry, &upperpath);
@@ -594,10 +596,12 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	int err;
 	DEFINE_DELAYED_CALL(done);
 	struct path parentpath;
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_copy_up_ctx ctx = {
 		.parent = parent,
 		.dentry = dentry,
 		.workdir = ovl_workdir(dentry),
+		.metadata_only = ofs->config.metacopy,
 	};
 
 	if (WARN_ON(!ctx.workdir))
@@ -618,9 +622,17 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (err)
 		return err;
 
+	if (!S_ISREG(ctx.stat.mode))
+		ctx.metadata_only = false;
+
 	/* maybe truncate regular file. this has no effect on dirs */
-	if (flags & O_TRUNC)
+	if (flags & O_TRUNC) {
 		ctx.stat.size = 0;
+		ctx.metadata_only = false;
+	}
+
+	if (flags & (OPEN_FMODE(flags) & FMODE_WRITE))
+		ctx.metadata_only = false;
 
 	if (S_ISLNK(ctx.stat.mode)) {
 		ctx.link = vfs_get_link(ctx.lowerpath.dentry, &done);
-- 
2.13.5
