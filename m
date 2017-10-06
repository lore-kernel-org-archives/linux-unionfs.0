From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH 5/8] ovl: Set xattr OVL_XATTR_METACOPY on upper file
Date: Fri,  6 Oct 2017 13:47:14 -0400
Message-ID: <1507312037-30909-6-git-send-email-vgoyal@redhat.com>
References: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45622 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752504AbdJFRrY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 6 Oct 2017 13:47:24 -0400
In-Reply-To: <1507312037-30909-1-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: amir73il@gmail.com, miklos@szeredi.hu, vgoyal@redhat.com

Presence of OVL_XATTR_METACOPY reflects that file has been copied up
with metadata only and data needs to be copied up later from lower.
So this xattr is set when a metadata copy takes place and cleared when
data copy takes place.

We also use a bit in ovl_inode->flags to cache OVL_METACOPY which reflects
whether ovl inode has only metadata copied up.

ovl_set_size() code has been taken from Amir's patch.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c   | 63 ++++++++++++++++++++++++++++++++++++++++++++++--
 fs/overlayfs/inode.c     |  3 ++-
 fs/overlayfs/overlayfs.h |  5 +++-
 fs/overlayfs/util.c      | 21 ++++++++++++++--
 4 files changed, 86 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index a1fb6ccfcc51..f4d269790080 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -196,6 +196,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 	return error;
 }
 
+static int ovl_set_size(struct dentry *upperdentry, struct kstat *stat)
+{
+	struct iattr attr = {
+		.ia_valid = ATTR_SIZE,
+		.ia_size = stat->size,
+	};
+
+	return notify_change(upperdentry, &attr, NULL);
+}
+
 static int ovl_set_timestamps(struct dentry *upperdentry, struct kstat *stat)
 {
 	struct iattr attr = {
@@ -439,9 +449,30 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
 	goto out;
 }
 
+static int ovl_copy_up_data_inode(struct ovl_copy_up_ctx *c)
+{
+	struct path upperpath;
+	int err;
+
+	ovl_path_upper(c->dentry, &upperpath);
+	BUG_ON(upperpath.dentry == NULL);
+
+	err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
+	if (err)
+		return err;
+
+	err= vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
+	if (err)
+		return err;
+
+	ovl_clear_flag(OVL_METACOPY, d_inode(c->dentry));
+	return err;
+}
+
 static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 {
 	int err;
+	bool set_size = false;
 
 	err = ovl_copy_xattr(c->lowerpath.dentry, temp);
 	if (err)
@@ -476,8 +507,29 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
+	if (c->metadata_only) {
+		err = ovl_check_setxattr(c->dentry, temp, OVL_XATTR_METACOPY,
+					 NULL, 0, -EOPNOTSUPP);
+		if (err)
+			return err;
+
+		set_size = true;
+	}
+
 	inode_lock(temp->d_inode);
+	if (set_size) {
+		err = ovl_set_size(temp, &c->stat);
+		if (err) {
+			inode_unlock(temp->d_inode);
+			return err;
+		}
+	}
+
 	err = ovl_set_attr(temp, &c->stat);
+	if (err) {
+		inode_unlock(temp->d_inode);
+		return err;
+	}
 	inode_unlock(temp->d_inode);
 	if (err)
 		return err;
@@ -511,6 +563,9 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
 		goto out_cleanup;
 
 	ovl_inode_update(d_inode(c->dentry), newdentry);
+	if (c->metadata_only) {
+		ovl_set_flag(OVL_METACOPY, d_inode(c->dentry));
+	}
 out:
 	dput(temp);
 	return err;
@@ -641,7 +696,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	}
 	ovl_do_check_copy_up(ctx.lowerpath.dentry);
 
-	err = ovl_copy_up_start(dentry);
+	err = ovl_copy_up_start(dentry, flags);
 	/* err < 0: interrupted, err > 0: raced with another copy-up */
 	if (unlikely(err)) {
 		if (err > 0)
@@ -651,6 +706,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			err = ovl_do_copy_up(&ctx);
 		if (!err && !ovl_dentry_has_upper_alias(dentry))
 			err = ovl_link_up(&ctx);
+		if (!err && ovl_dentry_needs_data_copy_up(dentry, flags))
+			err = ovl_copy_up_data_inode(&ctx);
 		ovl_copy_up_end(dentry);
 	}
 	do_delayed_call(&done);
@@ -681,8 +738,10 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 		 *      with rename.
 		 */
 		if (ovl_dentry_upper(dentry) &&
-		    ovl_dentry_has_upper_alias(dentry))
+		    ovl_dentry_has_upper_alias(dentry) &&
+		    !ovl_dentry_needs_data_copy_up(dentry, flags)) {
 			break;
+		}
 
 		next = dget(dentry);
 		/* find the topmost dentry not yet copied up */
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a619addecafc..e5825b8948e0 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -320,7 +320,8 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
 static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
 {
 	if (ovl_dentry_upper(dentry) &&
-	    ovl_dentry_has_upper_alias(dentry))
+	    ovl_dentry_has_upper_alias(dentry) &&
+	    !ovl_dentry_needs_data_copy_up(dentry, flags))
 		return false;
 
 	if (special_file(d_inode(dentry)->i_mode))
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d4e8c1a08fb0..28969d64af0d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -26,10 +26,12 @@ enum ovl_path_type {
 #define OVL_XATTR_ORIGIN OVL_XATTR_PREFIX "origin"
 #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
 #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
+#define OVL_XATTR_METACOPY OVL_XATTR_PREFIX "metacopy"
 
 enum ovl_flag {
 	OVL_IMPURE,
 	OVL_INDEX,
+	OVL_METACOPY,
 };
 
 /*
@@ -211,6 +213,7 @@ bool ovl_dentry_is_whiteout(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry);
 bool ovl_dentry_has_upper_alias(struct dentry *dentry);
 void ovl_dentry_set_upper_alias(struct dentry *dentry);
+bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags);
 bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
@@ -221,7 +224,7 @@ void ovl_dentry_version_inc(struct dentry *dentry, bool impurity);
 u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
-int ovl_copy_up_start(struct dentry *dentry);
+int ovl_copy_up_start(struct dentry *dentry, int flags);
 void ovl_copy_up_end(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 792a5f5f27e0..cfcbf1e522f0 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -227,6 +227,22 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry)
 	oe->has_upper = true;
 }
 
+bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
+	if (!S_ISREG(d_inode(dentry)->i_mode))
+		return false;
+
+	if (!flags)
+		return false;
+
+	if (!(OPEN_FMODE(flags) & FMODE_WRITE))
+		return false;
+
+	if (!ovl_test_flag(OVL_METACOPY, d_inode(dentry)))
+		return false;
+
+	return true;
+}
+
 bool ovl_redirect_dir(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
@@ -310,13 +326,14 @@ struct file *ovl_path_open(struct path *path, int flags)
 	return dentry_open(path, flags | O_NOATIME, current_cred());
 }
 
-int ovl_copy_up_start(struct dentry *dentry)
+int ovl_copy_up_start(struct dentry *dentry, int flags)
 {
 	struct ovl_inode *oi = OVL_I(d_inode(dentry));
 	int err;
 
 	err = mutex_lock_interruptible(&oi->lock);
-	if (!err && ovl_dentry_has_upper_alias(dentry)) {
+	if (!err && ovl_dentry_has_upper_alias(dentry) &&
+	    !ovl_dentry_needs_data_copy_up(dentry, flags)) {
 		err = 1; /* Already copied up */
 		mutex_unlock(&oi->lock);
 	}
-- 
2.13.5
