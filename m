From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: fix inconsistent d_ino for legacy merge dir
Date: Sun, 31 Dec 2017 11:49:38 +0200
Message-ID: <1514713778-15640-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34230 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbdLaJtt (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 31 Dec 2017 04:49:49 -0500
Received: by mail-wr0-f196.google.com with SMTP id 36so11517438wrh.1
        for <linux-unionfs@vger.kernel.org>; Sun, 31 Dec 2017 01:49:48 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, zhangyi <yi.zhang@huawei.com>
Cc: linux-unionfs@vger.kernel.org

For a merge dir that was copied up before v4.12 or that was hand crafted
offline (e.g. mkdir {upper/lower}/dir), upper dir does not contain the
'trusted.overlay.origin' xattr.  In that case, stat(2) on the merge dir
returns the lower dir st_ino, but getdents(2) returns the upper dir d_ino.

After this change, on merge dir lookup, missing origin xattr on upper
dir will be fixed and 'impure' xattr will be fixed on parent of the legacy
merge dir.

Suggested-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Zhangyi,

Please review/test this patch.
I ended up applying it at the bottom of verify_dir [1] series,
so it could be merged to v4.15 and/or easily backported to v4.14
(where consistent d_ino was merged) if Miklos thinks this is an important
use case to fix.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-verify-dir

 fs/overlayfs/namei.c     | 36 +++++++++++++++++++++++++++++++-----
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/super.c     |  5 +++--
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 9cf15463754c..bd7375c05f7d 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -343,13 +343,13 @@ static int ovl_verify_origin_fh(struct dentry *dentry, const struct ovl_fh *fh)
 /*
  * Verify that an inode matches the origin file handle stored in upper inode.
  *
- * If @set is true and there is no stored file handle, encode and store origin
- * file handle in OVL_XATTR_ORIGIN.
+ * If @set is non-null and there is no stored file handle, set *@set to true
+ * and try to encode and store origin file handle in OVL_XATTR_ORIGIN.
  *
- * Return 0 on match, -ESTALE on mismatch, < 0 on error.
+ * Return 0 on match or successful set, -ESTALE on mismatch, < 0 on error.
  */
 int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
-		      bool is_upper, bool set)
+		      bool is_upper, bool *set)
 {
 	struct inode *inode;
 	struct ovl_fh *fh;
@@ -361,8 +361,13 @@ int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
 		goto fail;
 
 	err = ovl_verify_origin_fh(dentry, fh);
-	if (set && err == -ENODATA)
+	if (set && err == -ENODATA) {
+		*set = true;
 		err = ovl_do_setxattr(dentry, OVL_XATTR_ORIGIN, fh, fh->len, 0);
+		if (err)
+			goto fail;
+	}
+
 	if (err)
 		goto fail;
 
@@ -674,6 +679,27 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (!this)
 			continue;
 
+		/*
+		 * If no origin fh is stored in upper of a merge dir, store fh
+		 * of upper most lower dir and set upper parent "impure".
+		 */
+		if (upperdentry && !ctr) {
+			bool set = false;
+
+			err = ovl_verify_origin(upperdentry, this, false, &set);
+			if (set && !err) {
+				err = ovl_set_impure(dentry->d_parent,
+						     upperdentry->d_parent);
+			}
+			if (set && err)
+				goto out_put;
+
+			/*
+			 * Ignore merge dir origin mismatch, which may have
+			 * been caused by copying layers
+			 */
+		}
+
 		stack[ctr].dentry = this;
 		stack[ctr].layer = lower.layer;
 		ctr++;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b489099ccd49..6620db670afa 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -250,7 +250,7 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct dentry *origin,
-		      bool is_upper, bool set);
+		      bool is_upper, bool *set);
 int ovl_verify_index(struct dentry *index, struct ovl_path *lower,
 		     unsigned int numlower);
 int ovl_get_index_name(struct dentry *origin, struct qstr *name);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76440feb79f6..f548717e3388 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1026,11 +1026,12 @@ static int ovl_get_workdir(struct ovl_fs *ofs, struct path *upperpath)
 static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
 			    struct path *upperpath)
 {
+	bool set;
 	int err;
 
 	/* Verify lower root is upper root origin */
 	err = ovl_verify_origin(upperpath->dentry, oe->lowerstack[0].dentry,
-				false, true);
+				false, &set);
 	if (err) {
 		pr_err("overlayfs: failed to verify upper root origin\n");
 		goto out;
@@ -1040,7 +1041,7 @@ static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
 	if (ofs->indexdir) {
 		/* Verify upper root is index dir origin */
 		err = ovl_verify_origin(ofs->indexdir, upperpath->dentry,
-					true, true);
+					true, &set);
 		if (err)
 			pr_err("overlayfs: failed to verify index dir origin\n");
 
-- 
2.7.4
