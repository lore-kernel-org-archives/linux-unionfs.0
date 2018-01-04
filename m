From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 23/23] ovl: copy up of disconnected dentries
Date: Thu,  4 Jan 2018 18:40:18 +0200
Message-ID: <1515084018-25134-24-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:39995 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753481AbeADQjy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:54 -0500
Received: by mail-wm0-f67.google.com with SMTP id f206so4417104wmf.5
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:54 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

With NFS export, some operations on decoded file handles (e.g. open,
link, setattr, xattr_set) may call copy up with a disconnected non-dir.
In this case, we will copy up lower inode to index dir without
linking it to upper dir.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 56 ++++++++++++++++++++++++++++++++++++--------------
 fs/overlayfs/inode.c   |  4 +++-
 fs/overlayfs/util.c    |  7 ++++---
 3 files changed, 48 insertions(+), 19 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 275a08ab0dd3..384a3b37eeea 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -434,7 +434,10 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 		}
 	}
 	inode_unlock(udir);
-	ovl_set_nlink_upper(c->dentry);
+	if (err)
+		return err;
+
+	err = ovl_set_nlink_upper(c->dentry);
 
 	return err;
 }
@@ -640,6 +643,9 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		err = ovl_get_index_name(c->lowerpath.dentry, &c->destname);
 		if (err)
 			return err;
+	} else if (WARN_ON(!c->parent)) {
+		/* Disconnected dentry must be copied up to index dir */
+		return -EIO;
 	} else {
 		/*
 		 * Mark parent "impure" because it may now contain non-pure
@@ -662,12 +668,17 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		}
 	}
 
-	if (!err && c->indexed)
+
+	if (err)
+		goto out;
+
+	if (c->indexed)
 		ovl_set_flag(OVL_INDEX, d_inode(c->dentry));
 
 	if (to_index) {
-		kfree(c->destname.name);
-	} else if (!err) {
+		/* Initialize nlink for copy up of disconnected dentry */
+		err = ovl_set_nlink_upper(c->dentry);
+	} else {
 		struct inode *udir = d_inode(c->destdir);
 
 		/* Restore timestamps on parent (best effort) */
@@ -678,6 +689,9 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		ovl_dentry_set_upper_alias(c->dentry);
 	}
 
+out:
+	if (to_index)
+		kfree(c->destname.name);
 	return err;
 }
 
@@ -702,14 +716,17 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (err)
 		return err;
 
-	ovl_path_upper(parent, &parentpath);
-	ctx.destdir = parentpath.dentry;
-	ctx.destname = dentry->d_name;
+	if (parent) {
+		ovl_path_upper(parent, &parentpath);
+		ctx.destdir = parentpath.dentry;
+		ctx.destname = dentry->d_name;
 
-	err = vfs_getattr(&parentpath, &ctx.pstat,
-			  STATX_ATIME | STATX_MTIME, AT_STATX_SYNC_AS_STAT);
-	if (err)
-		return err;
+		err = vfs_getattr(&parentpath, &ctx.pstat,
+				  STATX_ATIME | STATX_MTIME,
+				  AT_STATX_SYNC_AS_STAT);
+		if (err)
+			return err;
+	}
 
 	/* maybe truncate regular file. this has no effect on dirs */
 	if (flags & O_TRUNC)
@@ -730,7 +747,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	} else {
 		if (!ovl_dentry_upper(dentry))
 			err = ovl_do_copy_up(&ctx);
-		if (!err && !ovl_dentry_has_upper_alias(dentry))
+		if (!err && parent && !ovl_dentry_has_upper_alias(dentry))
 			err = ovl_link_up(&ctx);
 		ovl_copy_up_end(dentry);
 	}
@@ -743,10 +760,19 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 {
 	int err = 0;
 	const struct cred *old_cred = ovl_override_creds(dentry->d_sb);
+	bool disconnected = (dentry->d_flags & DCACHE_DISCONNECTED);
+
+	/*
+	 * With NFS export, copy up can get called for a disconnected non-dir.
+	 * In this case, we will copy up lower inode to index dir without
+	 * linking it to upper dir.
+	 */
+	if (WARN_ON(disconnected && d_is_dir(dentry)))
+		return -EIO;
 
 	while (!err) {
 		struct dentry *next;
-		struct dentry *parent;
+		struct dentry *parent = NULL;
 
 		/*
 		 * Check if copy-up has happened as well as for upper alias (in
@@ -762,12 +788,12 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 		 *      with rename.
 		 */
 		if (ovl_dentry_upper(dentry) &&
-		    ovl_dentry_has_upper_alias(dentry))
+		    (ovl_dentry_has_upper_alias(dentry) || disconnected))
 			break;
 
 		next = dget(dentry);
 		/* find the topmost dentry not yet copied up */
-		for (;;) {
+		for (; !disconnected;) {
 			parent = dget_parent(next);
 
 			if (ovl_dentry_upper(parent))
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index fb436d66da7c..bb742d195f12 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -353,8 +353,10 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
 
 static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
 {
+	/* Copy up of disconnected dentry does not set upper alias */
 	if (ovl_dentry_upper(dentry) &&
-	    ovl_dentry_has_upper_alias(dentry))
+	    (ovl_dentry_has_upper_alias(dentry) ||
+	     (dentry->d_flags & DCACHE_DISCONNECTED)))
 		return false;
 
 	if (special_file(d_inode(dentry)->i_mode))
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index d6fe01ece7e8..1b0dc903cf6d 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -220,9 +220,10 @@ void ovl_dentry_set_opaque(struct dentry *dentry)
 }
 
 /*
- * For hard links it's possible for ovl_dentry_upper() to return positive, while
- * there's no actual upper alias for the inode.  Copy up code needs to know
- * about the existence of the upper alias, so it can't use ovl_dentry_upper().
+ * For hard links and decoded file handles, it's possible for ovl_dentry_upper()
+ * to return positive, while there's no actual upper alias for the inode.
+ * Copy up code needs to know about the existence of the upper alias, so it
+ * can't use ovl_dentry_upper().
  */
 bool ovl_dentry_has_upper_alias(struct dentry *dentry)
 {
-- 
2.7.4
