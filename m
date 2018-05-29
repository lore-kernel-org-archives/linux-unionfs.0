From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 22/28] ovl: Set redirect on metacopy files upon rename
Date: Tue, 29 May 2018 16:46:06 +0200
Message-ID: <20180529144612.16675-23-mszeredi@redhat.com>
References: <20180529144612.16675-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144612.16675-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Vivek Goyal <vgoyal@redhat.com>

Set redirect on metacopy files upon rename.  This will help find data
dentry in lower dirs.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c | 66 +++++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 46 insertions(+), 20 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 8d8e063e4706..1658961a9762 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -873,13 +873,13 @@ static bool ovl_can_move(struct dentry *dentry)
 		!d_is_dir(dentry) || !ovl_type_merge_or_lower(dentry);
 }
 
-static char *ovl_get_redirect(struct dentry *dentry, bool samedir)
+static char *ovl_get_redirect(struct dentry *dentry, bool abs_redirect)
 {
 	char *buf, *ret;
 	struct dentry *d, *tmp;
 	int buflen = ovl_redirect_max + 1;
 
-	if (samedir) {
+	if (!abs_redirect) {
 		ret = kstrndup(dentry->d_name.name, dentry->d_name.len,
 			       GFP_KERNEL);
 		goto out;
@@ -933,15 +933,43 @@ static char *ovl_get_redirect(struct dentry *dentry, bool samedir)
 	return ret ? ret : ERR_PTR(-ENOMEM);
 }
 
+static bool ovl_need_absolute_redirect(struct dentry *dentry, bool samedir)
+{
+	struct dentry *lowerdentry;
+
+	if (!samedir)
+		return true;
+
+	if (d_is_dir(dentry))
+		return false;
+
+	/*
+	 * For non-dir hardlinked files, we need absolute redirects
+	 * in general as two upper hardlinks could be in different
+	 * dirs. We could put a relative redirect now and convert
+	 * it to absolute redirect later. But when nlink > 1 and
+	 * indexing is on, that means relative redirect needs to be
+	 * converted to absolute during copy up of another lower
+	 * hardllink as well.
+	 *
+	 * So without optimizing too much, just check if lower is
+	 * a hard link or not. If lower is hard link, put absolute
+	 * redirect.
+	 */
+	lowerdentry = ovl_dentry_lower(dentry);
+	return (d_inode(lowerdentry)->i_nlink > 1);
+}
+
 static int ovl_set_redirect(struct dentry *dentry, bool samedir)
 {
 	int err;
 	const char *redirect = ovl_dentry_get_redirect(dentry);
+	bool absolute_redirect = ovl_need_absolute_redirect(dentry, samedir);
 
-	if (redirect && (samedir || redirect[0] == '/'))
+	if (redirect && (!absolute_redirect || redirect[0] == '/'))
 		return 0;
 
-	redirect = ovl_get_redirect(dentry, samedir);
+	redirect = ovl_get_redirect(dentry, absolute_redirect);
 	if (IS_ERR(redirect))
 		return PTR_ERR(redirect);
 
@@ -1117,22 +1145,20 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		goto out_dput;
 
 	err = 0;
-	if (is_dir) {
-		if (ovl_type_merge_or_lower(old))
-			err = ovl_set_redirect(old, samedir);
-		else if (!old_opaque && ovl_type_merge(new->d_parent))
-			err = ovl_set_opaque_xerr(old, olddentry, -EXDEV);
-		if (err)
-			goto out_dput;
-	}
-	if (!overwrite && new_is_dir) {
-		if (ovl_type_merge_or_lower(new))
-			err = ovl_set_redirect(new, samedir);
-		else if (!new_opaque && ovl_type_merge(old->d_parent))
-			err = ovl_set_opaque_xerr(new, newdentry, -EXDEV);
-		if (err)
-			goto out_dput;
-	}
+	if (ovl_type_merge_or_lower(old))
+		err = ovl_set_redirect(old, samedir);
+	else if (is_dir && !old_opaque && ovl_type_merge(new->d_parent))
+		err = ovl_set_opaque_xerr(old, olddentry, -EXDEV);
+	if (err)
+		goto out_dput;
+
+	if (!overwrite && ovl_type_merge_or_lower(new))
+		err = ovl_set_redirect(new, samedir);
+	else if (!overwrite && new_is_dir && !new_opaque &&
+		 ovl_type_merge(old->d_parent))
+		err = ovl_set_opaque_xerr(new, newdentry, -EXDEV);
+	if (err)
+		goto out_dput;
 
 	err = ovl_do_rename(old_upperdir->d_inode, olddentry,
 			    new_upperdir->d_inode, newdentry, flags);
-- 
2.14.3
