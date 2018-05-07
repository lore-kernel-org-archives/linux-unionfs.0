Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v15 08/30] ovl: A new xattr OVL_XATTR_METACOPY for file on upper
Date: Mon,  7 May 2018 13:40:40 -0400
Message-Id: <20180507174102.24086-9-vgoyal@redhat.com>
In-Reply-To: <20180507174102.24086-1-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Now we will have the capability to have upper inodes which might be only
metadata copy up and data is still on lower inode. So add a new xattr
OVL_XATTR_METACOPY to distinguish between two cases.

Presence of OVL_XATTR_METACOPY reflects that file has been copied up
metadata only and and data will be copied up later from lower origin.
So this xattr is set when a metadata copy takes place and cleared when
data copy takes place.

We also use a bit in ovl_inode->flags to cache OVL_UPPERDATA which reflects
whether ovl inode has data or not (as opposed to metadata only copy up).

If a file is copied up metadata only and later when same file is opened
for WRITE, then data copy up takes place. We copy up data, remove METACOPY
xattr and then set the UPPERDATA flag in ovl_inode->flags. While all
these operations happen with oi->lock held, read side of oi->flags can be
lockless. That is another thread on another cpu can check if UPPERDATA
flag is set or not.

So this gives us an ordering requirement w.r.t UPPERDATA flag. That is, if
another cpu sees UPPERDATA flag set, then it should be guaranteed that
effects of data copy up and remove xattr operations are also visible.

For example.

	CPU1				CPU2
ovl_open()				acquire(oi->lock)
 ovl_open_maybe_copy_up()                ovl_copy_up_data()
  open_open_need_copy_up()		 vfs_removexattr()
   ovl_already_copied_up()
    ovl_dentry_needs_data_copy_up()	 ovl_set_flag(OVL_UPPERDATA)
     ovl_test_flag(OVL_UPPERDATA)       release(oi->lock)

Say CPU2 is copying up data and in the end sets UPPERDATA flag. But if
CPU1 perceives the effects of setting UPPERDATA flag but not the effects
of preceeding operations (ex. upper that is not fully copied up), it will be
a problem.

Hence this patch introduces smp_wmb() on setting UPPERDATA flag operation
and smp_rmb() on UPPERDATA flag test operation.

May be some other lock or barrier is already covering it. But I am not sure
what that is and is it obvious enough that we will not break it in future.

So hence trying to be safe here and introducing barriers explicitly for
UPPERDATA flag/bit.

Reviewed-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/copy_up.c   | 56 ++++++++++++++++++++++++++++++----
 fs/overlayfs/dir.c       |  1 +
 fs/overlayfs/overlayfs.h | 18 +++++++++--
 fs/overlayfs/super.c     |  1 +
 fs/overlayfs/util.c      | 78 +++++++++++++++++++++++++++++++++++++++++++++---
 5 files changed, 143 insertions(+), 11 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 6ac3220b0834..7453913ca61b 100644
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
@@ -566,8 +576,18 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
 			return err;
 	}
 
+	if (c->metacopy) {
+		err = ovl_check_setxattr(c->dentry, temp, OVL_XATTR_METACOPY,
+					 NULL, 0, -EOPNOTSUPP);
+		if (err)
+			return err;
+	}
+
 	inode_lock(temp->d_inode);
-	err = ovl_set_attr(temp, &c->stat);
+	if (c->metacopy)
+		err = ovl_set_size(temp, &c->stat);
+	if (!err)
+		err = ovl_set_attr(temp, &c->stat);
 	inode_unlock(temp->d_inode);
 
 	return err;
@@ -605,6 +625,8 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *c)
 	if (err)
 		goto out_cleanup;
 
+	if (!c->metacopy)
+		ovl_set_upperdata(d_inode(c->dentry));
 	inode = d_inode(c->dentry);
 	ovl_inode_update(inode, newdentry);
 	if (S_ISDIR(inode->i_mode))
@@ -729,6 +751,28 @@ static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
 	return true;
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
+	err = vfs_removexattr(upperpath.dentry, OVL_XATTR_METACOPY);
+	if (err)
+		return err;
+
+	ovl_set_upperdata(d_inode(c->dentry));
+	return err;
+}
+
 static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			   int flags)
 {
@@ -775,7 +819,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	}
 	ovl_do_check_copy_up(ctx.lowerpath.dentry);
 
-	err = ovl_copy_up_start(dentry);
+	err = ovl_copy_up_start(dentry, flags);
 	/* err < 0: interrupted, err > 0: raced with another copy-up */
 	if (unlikely(err)) {
 		if (err > 0)
@@ -785,6 +829,8 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			err = ovl_do_copy_up(&ctx);
 		if (!err && parent && !ovl_dentry_has_upper_alias(dentry))
 			err = ovl_link_up(&ctx);
+		if (!err && ovl_dentry_needs_data_copy_up_locked(dentry, flags))
+			err = ovl_copy_up_meta_inode_data(&ctx);
 		ovl_copy_up_end(dentry);
 	}
 	do_delayed_call(&done);
@@ -810,7 +856,7 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 		struct dentry *next;
 		struct dentry *parent = NULL;
 
-		if (ovl_already_copied_up(dentry))
+		if (ovl_already_copied_up(dentry, flags))
 			break;
 
 		next = dget(dentry);
@@ -838,13 +884,13 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
 static bool ovl_open_need_copy_up(struct dentry *dentry, int flags)
 {
 	/* Copy up of disconnected dentry does not set upper alias */
-	if (ovl_already_copied_up(dentry))
+	if (ovl_already_copied_up(dentry, flags))
 		return false;
 
 	if (special_file(d_inode(dentry)->i_mode))
 		return false;
 
-	if (!(OPEN_FMODE(flags) & FMODE_WRITE) && !(flags & O_TRUNC))
+	if (!ovl_open_flags_need_copy_up(flags))
 		return false;
 
 	return true;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 47dc980e8b33..bdaa5e4fa603 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -190,6 +190,7 @@ static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
 	ovl_copyattr(d_inode(newdentry), inode);
 	ovl_dentry_set_upper_alias(dentry);
 	if (!hardlink) {
+		ovl_set_upperdata(inode);
 		ovl_inode_update(inode, newdentry);
 	} else {
 		WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index d8c182f9ec4f..2daea529b7eb 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -29,6 +29,7 @@ enum ovl_path_type {
 #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
 #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
 #define OVL_XATTR_UPPER OVL_XATTR_PREFIX "upper"
+#define OVL_XATTR_METACOPY OVL_XATTR_PREFIX "metacopy"
 
 enum ovl_inode_flag {
 	/* Pure upper dir that may contain non pure upper entries */
@@ -36,6 +37,7 @@ enum ovl_inode_flag {
 	/* Non-merge dir that may contain whiteout entries */
 	OVL_WHITEOUTS,
 	OVL_INDEX,
+	OVL_UPPERDATA,
 };
 
 enum ovl_entry_flag {
@@ -197,6 +199,14 @@ static inline struct dentry *ovl_do_tmpfile(struct dentry *dentry, umode_t mode)
 	return ret;
 }
 
+static inline bool ovl_open_flags_need_copy_up(int flags)
+{
+	if (!flags)
+		return false;
+
+	return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC));
+}
+
 /* util.c */
 int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
@@ -232,6 +242,10 @@ bool ovl_dentry_is_whiteout(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry);
 bool ovl_dentry_has_upper_alias(struct dentry *dentry);
 void ovl_dentry_set_upper_alias(struct dentry *dentry);
+bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags);
+bool ovl_dentry_needs_data_copy_up_locked(struct dentry *dentry, int flags);
+bool ovl_has_upperdata(struct inode *inode);
+void ovl_set_upperdata(struct inode *inode);
 bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
@@ -242,9 +256,9 @@ void ovl_dir_modified(struct dentry *dentry, bool impurity);
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
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 2c5cc94e1c5f..1213c035e9ad 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1508,6 +1508,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	/* Root is always merge -> can have whiteouts */
 	ovl_set_flag(OVL_WHITEOUTS, d_inode(root_dentry));
 	ovl_dentry_set_flag(OVL_E_CONNECTED, root_dentry);
+	ovl_set_upperdata(d_inode(root_dentry));
 	ovl_inode_init(d_inode(root_dentry), upperpath.dentry,
 		       ovl_dentry_lower(root_dentry));
 
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 43235294e77b..f8e3c95711b8 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -279,6 +279,62 @@ void ovl_dentry_set_upper_alias(struct dentry *dentry)
 	ovl_dentry_set_flag(OVL_E_UPPER_ALIAS, dentry);
 }
 
+static bool ovl_should_check_upperdata(struct inode *inode)
+{
+	if (!S_ISREG(inode->i_mode))
+		return false;
+
+	if (!ovl_inode_lower(inode))
+		return false;
+
+	return true;
+}
+
+bool ovl_has_upperdata(struct inode *inode)
+{
+	if (!ovl_should_check_upperdata(inode))
+		return true;
+
+	if (!ovl_test_flag(OVL_UPPERDATA, inode))
+		return false;
+	/*
+	 * Pairs with smp_wmb() in ovl_set_upperdata(). Main user of
+	 * ovl_has_upperdata() is ovl_copy_up_meta_inode_data(). Make sure
+	 * if setting of OVL_UPPERDATA is visible, then effects of writes
+	 * before that are visible too.
+	 */
+	smp_rmb();
+	return true;
+}
+
+void ovl_set_upperdata(struct inode *inode)
+{
+	/*
+	 * Pairs with smp_rmb() in ovl_has_upperdata(). Make sure
+	 * if OVL_UPPERDATA flag is visible, then effects of write operations
+	 * before it are visible as well.
+	 */
+	smp_wmb();
+	ovl_set_flag(OVL_UPPERDATA, inode);
+}
+
+/* Caller should hold ovl_inode->lock */
+bool ovl_dentry_needs_data_copy_up_locked(struct dentry *dentry, int flags)
+{
+	if (!ovl_open_flags_need_copy_up(flags))
+		return false;
+
+	return !ovl_test_flag(OVL_UPPERDATA, d_inode(dentry));
+}
+
+bool ovl_dentry_needs_data_copy_up(struct dentry *dentry, int flags)
+{
+	if (!ovl_open_flags_need_copy_up(flags))
+		return false;
+
+	return !ovl_has_upperdata(d_inode(dentry));
+}
+
 bool ovl_redirect_dir(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
@@ -377,7 +433,20 @@ struct file *ovl_path_open(struct path *path, int flags)
 	return dentry_open(path, flags | O_NOATIME, current_cred());
 }
 
-bool ovl_already_copied_up(struct dentry *dentry)
+/* Caller should hold ovl_inode->lock */
+static bool ovl_already_copied_up_locked(struct dentry *dentry, int flags)
+{
+	bool disconnected = dentry->d_flags & DCACHE_DISCONNECTED;
+
+	if (ovl_dentry_upper(dentry) &&
+	    (ovl_dentry_has_upper_alias(dentry) || disconnected) &&
+	    !ovl_dentry_needs_data_copy_up_locked(dentry, flags))
+		return true;
+
+	return false;
+}
+
+bool ovl_already_copied_up(struct dentry *dentry, int flags)
 {
 	bool disconnected = dentry->d_flags & DCACHE_DISCONNECTED;
 
@@ -395,19 +464,20 @@ bool ovl_already_copied_up(struct dentry *dentry)
 	 *      with rename.
 	 */
 	if (ovl_dentry_upper(dentry) &&
-	    (ovl_dentry_has_upper_alias(dentry) || disconnected))
+	    (ovl_dentry_has_upper_alias(dentry) || disconnected) &&
+	    !ovl_dentry_needs_data_copy_up(dentry, flags))
 		return true;
 
 	return false;
 }
 
-int ovl_copy_up_start(struct dentry *dentry)
+int ovl_copy_up_start(struct dentry *dentry, int flags)
 {
 	struct ovl_inode *oi = OVL_I(d_inode(dentry));
 	int err;
 
 	err = mutex_lock_interruptible(&oi->lock);
-	if (!err && ovl_already_copied_up(dentry)) {
+	if (!err && ovl_already_copied_up_locked(dentry, flags)) {
 		err = 1; /* Already copied up */
 		mutex_unlock(&oi->lock);
 	}
-- 
2.13.6
