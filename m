From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v6 07/15] ovl: A new xattr OVL_XATTR_METACOPY for file on upper
Date: Thu,  9 Nov 2017 15:50:11 -0500
Message-ID: <20171109205019.11409-8-vgoyal@redhat.com>
References: <20171109205019.11409-1-vgoyal@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52086 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753088AbdKIUub (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Nov 2017 15:50:31 -0500
In-Reply-To: <20171109205019.11409-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com

Now we will have the capability to have upper inodes which might be only
metadata copy up and data is still on lower inode. So add a new xattr
OVL_XATTR_METACOPY to distinguish between two cases.

Presence of OVL_XATTR_METACOPY reflects that file has been copied up metadata
only and and data will be copied up later from lower origin.
So this xattr is set when a metadata copy takes place and cleared when
data copy takes place.

We also use a bit in ovl_inode->flags to cache OVL_UPPERDATA which reflects
whether ovl inode has data or not (as opposed to metadata only copy up).

Note, OVL_UPPERDATA is set only on those upper inodes which can possibly
be metacopy only inodes. For example, inode should be a regular file and
there needs to be a lower dentry.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c   | 53 +++++++++++++++++++++++++++++++++++++++++++++---
 fs/overlayfs/inode.c     |  2 +-
 fs/overlayfs/overlayfs.h |  9 ++++++--
 fs/overlayfs/util.c      | 46 +++++++++++++++++++++++++++++++++++++----
 4 files changed, 100 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 23122bdf0b14..977ece7d3055 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -195,6 +195,16 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
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
@@ -437,6 +447,28 @@ static int ovl_get_tmpfile(struct ovl_copy_up_ctx *c, struct dentry **tempp)
 	goto out;
 }
 
+/* Copy up data of an inode which was copied up metadata only in the past. */
+static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
+{
+	struct path upperpath;
+	int err;
+
+	ovl_path_upper(c->dentry, &upperpath);
+	if (WARN_ON(upperpath.dentry == NULL))
+		return -EIO;
+
+	err = ovl_copy_up_data(&c->lowerpath, &upperpath, c->stat.size);
+	if (err)
+		return err;
+
+	err= vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
+	if (err)
+		return err;
+
+	ovl_set_upperdata(c->dentry);
+	return err;
+}
+
 static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 {
 	int err;
@@ -470,8 +502,19 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
+	if (c->metacopy) {
+		err = ovl_check_setxattr(c->dentry, temp, OVL_XATTR_METACOPY,
+					 NULL, 0, -EOPNOTSUPP);
+		if (err)
+			return err;
+	}
+
+
 	inode_lock(temp->d_inode);
-	err = ovl_set_attr(temp, &c->stat);
+	if (c->metacopy)
+		err = ovl_set_size(temp, &c->stat);
+	if (!err)
+		err = ovl_set_attr(temp, &c->stat);
 	inode_unlock(temp->d_inode);
 
 	return err;
@@ -503,6 +546,8 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
 	if (err)
 		goto out_cleanup;
 
+	if (!c->metacopy)
+		ovl_set_upperdata(c->dentry);
 	inode = d_inode(c->dentry);
 	ovl_inode_update(inode, newdentry);
 	if (S_ISDIR(inode->i_mode))
@@ -625,7 +670,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	}
 	ovl_do_check_copy_up(ctx.lowerpath.dentry);
 
-	err = ovl_copy_up_start(dentry);
+	err = ovl_copy_up_start(dentry, flags);
 	/* err < 0: interrupted, err > 0: raced with another copy-up */
 	if (unlikely(err)) {
 		if (err > 0)
@@ -635,6 +680,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			err = ovl_do_copy_up(&ctx);
 		if (!err && !ovl_dentry_has_upper_alias(dentry))
 			err = ovl_link_up(&ctx);
+		if (!err && ovl_dentry_needs_data_copy_up(dentry, flags))
+			err = ovl_copy_up_meta_inode_data(&ctx);
 		ovl_copy_up_end(dentry);
 	}
 	do_delayed_call(&done);
@@ -651,7 +698,7 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 		struct dentry *next;
 		struct dentry *parent;
 
-		if (ovl_already_copied_up(dentry))
+		if (ovl_already_copied_up(dentry, flags))
 			break;
 
 		next = dget(dentry);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 537dc25f84c6..405a8c34471b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -343,7 +343,7 @@ struct posix_acl *ovl_get_acl(struct inode *inode, int type)
 
 static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
 {
-	if (ovl_already_copied_up(dentry))
+	if (ovl_already_copied_up(dentry, flags))
 		return false;
 
 	if (special_file(d_inode(dentry)->i_mode))
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index a6fdc2f0da6d..6962fab08012 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -27,6 +27,7 @@ enum ovl_path_type {
 #define OVL_XATTR_ORIGIN OVL_XATTR_PREFIX "origin"
 #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
 #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
+#define OVL_XATTR_METACOPY OVL_XATTR_PREFIX "metacopy"
 
 enum ovl_flag {
 	/* Pure upper dir that may contain non pure upper entries */
@@ -34,6 +35,7 @@ enum ovl_flag {
 	/* Non-merge dir that may contain whiteout entries */
 	OVL_WHITEOUTS,
 	OVL_INDEX,
+	OVL_UPPERDATA,
 };
 
 /*
@@ -215,6 +217,9 @@ bool ovl_dentry_is_whiteout(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry);
 bool ovl_dentry_has_upper_alias(struct dentry *dentry);
 void ovl_dentry_set_upper_alias(struct dentry *dentry);
+bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags);
+bool ovl_has_upperdata(struct dentry *dentry);
+void ovl_set_upperdata(struct dentry *dentry);
 bool ovl_metaonly_copy_up(struct dentry *dentry, umode_t mode, int flags);
 bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
@@ -226,9 +231,9 @@ void ovl_dentry_version_inc(struct dentry *dentry, bool impurity);
 u64 ovl_dentry_version_get(struct dentry *dentry);
 bool ovl_is_whiteout(struct dentry *dentry);
 struct file *ovl_path_open(struct path *path, int flags);
-int ovl_copy_up_start(struct dentry *dentry);
+int ovl_copy_up_start(struct dentry *dentry, int flags);
 void ovl_copy_up_end(struct dentry *dentry);
-bool ovl_already_copied_up(struct dentry *dentry);
+bool ovl_already_copied_up(struct dentry *dentry, int flags);
 bool ovl_check_origin_xattr(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index f4e3e011a097..f70eea77c5c7 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -253,6 +253,43 @@ bool ovl_metaonly_copy_up(struct dentry *dentry, umode_t mode, int flags)
 	return true;
 }
 
+static bool ovl_should_check_upperdata(struct dentry *dentry) {
+	if (!S_ISREG(d_inode(dentry)->i_mode))
+		return false;
+
+	if (!ovl_dentry_lower(dentry))
+		return false;
+
+	return true;
+}
+
+bool ovl_has_upperdata(struct dentry *dentry) {
+	if (!ovl_should_check_upperdata(dentry))
+		return true;
+
+	return ovl_test_flag(OVL_UPPERDATA, d_inode(dentry));
+}
+
+void ovl_set_upperdata(struct dentry *dentry) {
+	if (!S_ISREG(d_inode(dentry)->i_mode))
+		return;
+
+	ovl_set_flag(OVL_UPPERDATA, d_inode(dentry));
+}
+
+bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags) {
+	if (!flags)
+		return false;
+
+	if (!(OPEN_FMODE(flags) & FMODE_WRITE))
+		return false;
+
+	if (ovl_has_upperdata(dentry))
+		return false;
+
+	return true;
+}
+
 bool ovl_redirect_dir(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
@@ -336,13 +373,13 @@ struct file *ovl_path_open(struct path *path, int flags)
 	return dentry_open(path, flags | O_NOATIME, current_cred());
 }
 
-int ovl_copy_up_start(struct dentry *dentry)
+int ovl_copy_up_start(struct dentry *dentry, int flags)
 {
 	struct ovl_inode *oi = OVL_I(d_inode(dentry));
 	int err;
 
 	err = mutex_lock_interruptible(&oi->lock);
-	if (!err && ovl_already_copied_up(dentry)) {
+	if (!err && ovl_already_copied_up(dentry, flags)) {
 		err = 1; /* Already copied up */
 		mutex_unlock(&oi->lock);
 	}
@@ -368,7 +405,7 @@ bool ovl_check_origin_xattr(struct dentry *dentry)
 	return false;
 }
 
-bool ovl_already_copied_up(struct dentry *dentry)
+bool ovl_already_copied_up(struct dentry *dentry, int flags)
 {
 	/*
 	 * Check if copy-up has happened as well as for upper alias (in
@@ -384,7 +421,8 @@ bool ovl_already_copied_up(struct dentry *dentry)
 	 *      with rename.
 	 */
 	if (ovl_dentry_upper(dentry) &&
-	    ovl_dentry_has_upper_alias(dentry))
+	    ovl_dentry_has_upper_alias(dentry) &&
+	    !ovl_dentry_needs_data_copy_up(dentry, flags))
 		return true;
 
 	return false;
-- 
2.13.6
