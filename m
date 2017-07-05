From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: mark parent impure on ovl_link()
Date: Wed,  5 Jul 2017 09:41:10 +0300
Message-ID: <1499236870-5225-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32942 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751110AbdGEGlG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2017 02:41:06 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 12" <stable@vger.kernel.org>

When linking a file with copy up origin into a new parent, mark the
new parent dir "impure".

Fixes: ee1d6d37b6b8 ("ovl: mark upper dir with type origin entries "impure"")
Cc: <stable@vger.kernel.org> # v4.12
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

We missed a spot with impure dir patches for v4.12.

Amir.

 fs/overlayfs/copy_up.c   |  4 ++--
 fs/overlayfs/dir.c       | 20 ++++++++++++++++----
 fs/overlayfs/overlayfs.h |  2 +-
 fs/overlayfs/util.c      |  6 +++---
 4 files changed, 22 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index acb6f97deb97..aeb22def9f80 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -338,7 +338,7 @@ static int ovl_link_up(struct ovl_copy_up_ctx *c)
 	struct inode *udir = d_inode(upperdir);
 
 	/* Mark parent "impure" because it may now contain non-pure upper */
-	err = ovl_set_impure(c->parent, upperdir);
+	err = ovl_set_impure(c->parent);
 	if (err)
 		return err;
 
@@ -551,7 +551,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
 		 * Mark parent "impure" because it may now contain non-pure
 		 * upper
 		 */
-		err = ovl_set_impure(c->parent, c->destdir);
+		err = ovl_set_impure(c->parent);
 		if (err)
 			return err;
 	}
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 641d9ee97f91..5df99952feba 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -92,7 +92,8 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		return -ESTALE;
 
 	if (hardlink) {
-		err = ovl_do_link(hardlink, dir, newdentry, debug);
+		err = ovl_do_link(ovl_dentry_upper(hardlink), dir, newdentry,
+				  debug);
 	} else {
 		switch (attr->mode & S_IFMT) {
 		case S_IFREG:
@@ -492,6 +493,17 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
 		return err;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
+
+	/*
+	 * When linking a file with copy up origin into a new parent, mark the
+	 * new parent dir "impure".
+	 */
+	if (hardlink && ovl_type_origin(hardlink)) {
+		err = ovl_set_impure(dentry->d_parent);
+		if (err)
+			goto out_revert_creds;
+	}
+
 	err = -ENOMEM;
 	override_cred = prepare_creds();
 	if (override_cred) {
@@ -609,7 +621,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	inode = d_inode(old);
 	ihold(inode);
 
-	err = ovl_create_or_link(new, inode, NULL, ovl_dentry_upper(old));
+	err = ovl_create_or_link(new, inode, NULL, old);
 	if (err)
 		iput(inode);
 
@@ -987,12 +999,12 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		 * lookup the origin inodes of the entries to fill d_ino.
 		 */
 		if (ovl_type_origin(old)) {
-			err = ovl_set_impure(new->d_parent, new_upperdir);
+			err = ovl_set_impure(new->d_parent);
 			if (err)
 				goto out_revert_creds;
 		}
 		if (!overwrite && ovl_type_origin(new)) {
-			err = ovl_set_impure(old->d_parent, old_upperdir);
+			err = ovl_set_impure(old->d_parent);
 			if (err)
 				goto out_revert_creds;
 		}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 60d26605e039..7aa1c48390a5 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -225,7 +225,7 @@ bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       const char *name, const void *value, size_t size,
 		       int xerr);
-int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry);
+int ovl_set_impure(struct dentry *dentry);
 void ovl_set_flag(unsigned long flag, struct inode *inode);
 bool ovl_test_flag(unsigned long flag, struct inode *inode);
 bool ovl_inuse_trylock(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index c492ba75c659..82c3dad6ddf4 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -353,7 +353,7 @@ int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 	return err;
 }
 
-int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
+int ovl_set_impure(struct dentry *dentry)
 {
 	int err;
 
@@ -364,8 +364,8 @@ int ovl_set_impure(struct dentry *dentry, struct dentry *upperdentry)
 	 * Do not fail when upper doesn't support xattrs.
 	 * Upper inodes won't have origin nor redirect xattr anyway.
 	 */
-	err = ovl_check_setxattr(dentry, upperdentry, OVL_XATTR_IMPURE,
-				 "y", 1, 0);
+	err = ovl_check_setxattr(dentry, ovl_dentry_upper(dentry),
+				 OVL_XATTR_IMPURE, "y", 1, 0);
 	if (!err)
 		ovl_set_flag(OVL_IMPURE, d_inode(dentry));
 
-- 
2.7.4
