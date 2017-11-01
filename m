From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 9/9] ovl: update non-merge dir cache for non-samefs case
Date: Wed,  1 Nov 2017 22:22:53 +0200
Message-ID: <1509567773-25590-10-git-send-email-amir73il@gmail.com>
References: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:45551 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755211AbdKAUWY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 16:22:24 -0400
Received: by mail-wr0-f193.google.com with SMTP id y9so3021160wrb.2
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Nov 2017 13:22:23 -0700 (PDT)
In-Reply-To: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

For non-samefs case, all subdirectories are "impure" because the
st_ino value returned from stat(2) is not the st_ino value of the
real inode.

Update non-merge dir cache version on every change in subdir entry
and cache st_ino values of subdirs in impure dir cache.

Build the impure dir cache for non-samefs case even if there is no
"impure" xattr on dir, but if real dir has nlink > 2 or nlink == 1,
which indicates that is has subdirs.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 13 +++++++------
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/readdir.c   |  9 ++++++++-
 fs/overlayfs/util.c      |  9 ++++++---
 4 files changed, 22 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 70af6b470420..b41f9d15345b 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -155,7 +155,7 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
 static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
 			    struct dentry *newdentry, bool hardlink)
 {
-	ovl_dentry_version_inc(dentry->d_parent, false);
+	ovl_dentry_version_inc(dentry->d_parent, false, S_ISDIR(inode->i_mode));
 	ovl_dentry_set_upper_alias(dentry);
 	if (!hardlink) {
 		ovl_inode_update(inode, newdentry);
@@ -676,7 +676,7 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 	if (flags)
 		ovl_cleanup(wdir, upper);
 
-	ovl_dentry_version_inc(dentry->d_parent, true);
+	ovl_dentry_version_inc(dentry->d_parent, true, is_dir);
 out_d_drop:
 	d_drop(dentry);
 	dput(whiteout);
@@ -727,7 +727,8 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 		err = vfs_rmdir(dir, upper);
 	else
 		err = vfs_unlink(dir, upper, NULL);
-	ovl_dentry_version_inc(dentry->d_parent, ovl_type_origin(dentry));
+	ovl_dentry_version_inc(dentry->d_parent, ovl_type_origin(dentry),
+			       is_dir);
 
 	/*
 	 * Keeping this dentry hashed would mean having to release
@@ -1075,10 +1076,10 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			drop_nlink(d_inode(new));
 	}
 
-	ovl_dentry_version_inc(old->d_parent, ovl_type_origin(old));
+	ovl_dentry_version_inc(old->d_parent, ovl_type_origin(old), is_dir);
 	ovl_dentry_version_inc(old->d_parent,
-			       !overwrite && ovl_type_origin(new));
-	ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old));
+			       !overwrite && ovl_type_origin(new), new_is_dir);
+	ovl_dentry_version_inc(new->d_parent, ovl_type_origin(old), is_dir);
 
 out_dput:
 	dput(newdentry);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index cefe5a97d048..17fc4622dfba 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -221,7 +221,7 @@ void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
 void ovl_inode_init(struct inode *inode, struct dentry *upperdentry,
 		    struct dentry *lowerdentry);
 void ovl_inode_update(struct inode *inode, struct dentry *upperdentry);
-void ovl_dentry_version_inc(struct dentry *dentry, bool impurity);
+void ovl_dentry_version_inc(struct dentry *dentry, bool impurity, bool subdir);
 u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index fa1be3fe68fa..469837c06814 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -660,6 +660,7 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 	int err;
 	struct ovl_dir_file *od = file->private_data;
 	struct dentry *dir = file->f_path.dentry;
+	struct inode *realinode = d_inode(od->realfile->f_path.dentry);
 	struct ovl_readdir_translate rdt = {
 		.ctx.actor = ovl_fill_real,
 		.orig_ctx = ctx,
@@ -678,7 +679,13 @@ static int ovl_iterate_real(struct file *file, struct dir_context *ctx)
 		rdt.parent_ino = stat.ino;
 	}
 
-	if (ovl_test_flag(OVL_IMPURE, d_inode(dir))) {
+	/*
+	 * If dir is impure, we need to cache st_ino values of copy up origins.
+	 * For non-samefs, if dir nlink is either 1 (=any) or > 2, then it may
+	 * have subdirs and we need to cache their non persistent st_ino values.
+	 */
+	if (ovl_test_flag(OVL_IMPURE, d_inode(dir)) ||
+	    (!ovl_same_sb(dir->d_sb) && realinode->i_nlink != 2)) {
 		rdt.cache = ovl_cache_get_impure(&file->f_path);
 		if (IS_ERR(rdt.cache))
 			return PTR_ERR(rdt.cache);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index d6bb1c9f5e7a..b4d729dff66b 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -279,7 +279,7 @@ void ovl_inode_update(struct inode *inode, struct dentry *upperdentry)
 	}
 }
 
-void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
+void ovl_dentry_version_inc(struct dentry *dentry, bool impurity, bool subdir)
 {
 	struct inode *inode = d_inode(dentry);
 
@@ -288,9 +288,12 @@ void ovl_dentry_version_inc(struct dentry *dentry, bool impurity)
 	 * Version is used by readdir code to keep cache consistent.  For merge
 	 * dirs all changes need to be noted.  For non-merge dirs, cache only
 	 * contains impure (ones which have been copied up and have origins)
-	 * entries, so only need to note changes to impure entries.
+	 * entries, so only need to note changes to impure entries.  For
+	 * non-merge dirs in non-samefs case, we need to also note changes for
+	 * all sub-dirs, because we cache all overlay dir inode numbers.
 	 */
-	if (OVL_TYPE_MERGE(ovl_path_type(dentry)) || impurity)
+	if (OVL_TYPE_MERGE(ovl_path_type(dentry)) || impurity ||
+	    (subdir && !ovl_same_sb(dentry->d_sb)))
 		OVL_I(inode)->version++;
 }
 
-- 
2.7.4
