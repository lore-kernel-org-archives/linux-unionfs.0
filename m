From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 05/15] ovl: Copy up only metadata during copy up where it makes sense
Date: Thu,  9 Nov 2017 15:50:09 -0500
Message-ID: <20171109205019.11409-6-vgoyal@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35591 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751133AbdKIUub (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:50:31 -0500
In-Reply-To: <20171109205019.11409-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

If it makes sense to copy up only metadata during copy up, do it. This
is done for regular files which are not opened for WRITE and have origin
being saved.

Right now ->metacopy is set to 0 always. Last patch in the series will
remove the hard coded statement and enable metacopy feature.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c   | 18 +++++++++++-------
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 22 ++++++++++++++++++++++
 3 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 303794bb9127..6bb6b1723564 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -305,11 +305,8 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
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
@@ -326,6 +323,7 @@ struct ovl_copy_up_ctx {
 	struct qstr destname;
 	struct dentry *workdir;
 	bool tmpfile;
+	bool metacopy;
 };
 
 static int ovl_link_up(struct ovl_copy_up_ctx *c)
@@ -453,10 +451,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
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
@@ -601,6 +603,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (err)
 		return err;
 
+	ctx.metacopy = ovl_metaonly_copy_up(dentry, ctx.stat.mode, flags);
+
 	ovl_path_upper(parent, &parentpath);
 	ctx.destdir = parentpath.dentry;
 	ctx.destname = dentry->d_name;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 13eab09a6b6f..9e5aaa4a5db2 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -215,6 +215,7 @@ bool ovl_dentry_is_whiteout(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry);
 bool ovl_dentry_has_upper_alias(struct dentry *dentry);
 void ovl_dentry_set_upper_alias(struct dentry *dentry);
+bool ovl_metaonly_copy_up(struct dentry *dentry, umode_t mode, int flags);
 bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 77dc00438d54..c5b62546c613 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -231,6 +231,28 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry)
 	oe->has_upper = true;
 }
 
+bool ovl_metaonly_copy_up(struct dentry *dentry, umode_t mode, int flags)
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
+	if (flags && (flags & O_TRUNC))
+		return false;
+
+	if (flags && (OPEN_FMODE(flags) & FMODE_WRITE))
+		return false;
+
+	return true;
+}
+
 bool ovl_redirect_dir(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
-- 
2.13.6
