From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 24/25] ovl: persistent overlay inode nlink for indexed inodes
Date: Wed, 21 Jun 2017 15:28:55 +0300
Message-ID: <1498048136-28218-25-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:36022 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbdFUM30 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:29:26 -0400
Received: by mail-wr0-f194.google.com with SMTP id 77so26088305wrb.3
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:29:25 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

With inodes index enabled, an overlay inode nlink counts the union of upper
and non-covered lower hardlinks. During the lifetime of a non-pure upper
inode, the following nlink modifying operations can happen:

1. Lower hardlink copy up
2. Upper hardlink created, unlinked or renamed over
3. Lower hardlink whiteout or renamed over

For the first, copy up case, the union nlink does not change, whether the
operation succeeds or fails, but the upper inode nlink may change.
Therefore, before copy up, we store the union nlink value relative to the
lower inode nlink in the index inode xattr trusted.overlay.nlink.

For the second, upper hardlink case, the union nlink should be incremented
or decremented IFF the operation succeeds, aligned with nlink change of the
upper inode. Therefore, before link/unlink/rename, we store the union nlink
value relative to the upper inode nlink in the index inode.

For the last, lower cover up case, we simplify things by preceding the
whiteout or cover up with copy up. This makes sure that there is an index
upper inode where the nlink xattr can be stored before the copied up upper
entry is unlink.

Return the overlay inode nlinks for indexed upper inodes on stat(2).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   |  88 +++++++++++++++++++++++++++-------------
 fs/overlayfs/dir.c       |  80 +++++++++++++++++++++++++++++++++++-
 fs/overlayfs/inode.c     | 103 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/namei.c     |   2 +-
 fs/overlayfs/overlayfs.h |   6 ++-
 5 files changed, 245 insertions(+), 34 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index acff8b9e6d1b..bbc16880b32d 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -610,24 +610,21 @@ static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 			goto out_dput;
 		}
 
-		if (inode->i_nlink < 2) {
+		err = -ENOENT;
+		if (ctx->dentry->d_inode->i_nlink == 0) {
 			/*
 			 * An orphan index inode can be created by copying up
-			 * a lower hardlink alias and then unlinking it. From
-			 * overlayfs perspective, this inode may still live if
-			 * there are more lower hardlinks and it should contain
-			 * the data of the upper inode that was unlinked. So if
-			 * an orphan inode is found in the index dir and we
-			 * should reuse it on copy up of another lower alias.
-			 *
-			 * TODO: keep account of nlink incremented by copy up
-			 * and account of nlink decremented by lower cover up.
-			 * When copyup_nlink + coverup_nlink == origin_nlink
-			 * and index_nlink == 1, need to remove the index entry
-			 * because all overlay references to the index are gone.
+			 * all lower hardlinks and then unlinking all upper
+			 * hardlinks. The overlay inode may still be alive if
+			 * it is referenced from an open file descriptor, but
+			 * there should be no more copy ups that link to the
+			 * index inode.
+			 * Orphan index inodes should be cleaned up on mount
+			 * and when overlay inode nlink drops to zero.
 			 */
-			pr_warn_ratelimited("overlayfs: linking to orphan upper (%pd2, ino=%lu)\n",
-					    index, inode->i_ino);
+			pr_warn_ratelimited("overlayfs: not linking to orphan index (%pd2, nlink=%u)\n",
+					    index, inode->i_nlink);
+			goto out_dput;
 		}
 
 		/* Link to existing upper without copying lower */
@@ -643,6 +640,15 @@ static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 
 	ctx->created = true;
 out:
+	/*
+	 * The overlay inode nlink does not change on copy up whether the
+	 * operation succeeds or fails, but the upper inode nlink may change.
+	 * Therefore, before copy up, we store the union nlink value relative
+	 * to the lower inode nlink in an index inode xattr. We will store it
+	 * again relative to index inode nlink at copy up commit or cancel.
+	 */
+	ovl_set_nlink(d_inode(ctx->dentry), index, false);
+
 	ctx->upper = upper;
 	ctx->temp = index;
 	return err;
@@ -657,10 +663,45 @@ static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 	return err;
 }
 
+static int ovl_fsync_index(struct dentry *dentry, struct dentry *index)
+{
+	struct file *file;
+	struct path upperpath;
+	int err;
+
+	ovl_path_upper(dentry, &upperpath);
+	BUG_ON(upperpath.dentry != NULL);
+	upperpath.dentry = index;
+
+	file = ovl_path_open(&upperpath, O_LARGEFILE | O_WRONLY);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	err = vfs_fsync(file, 0);
+
+	fput(file);
+	return err;
+}
+
 static int ovl_copy_up_indexdir_commit(struct ovl_copy_up_ctx *ctx)
 {
 	int err;
 
+	/*
+	 * fsync index before "link-up" to guaranty that nlink xattr is stored
+	 * on-disk. Non empty regular files are fsynced on ovl_copy_up_data().
+	 * This does not cover "link-up" of non-regular files.
+	 *
+	 * XXX: Is this really needed? I think that on a journalled file system
+	 * inode xattr change cannot be re-ordered with the same inode's nlink
+	 * change, because they are both metadata changes of that inode.
+	 */
+	if ((!ctx->created || !ctx->stat->size) && S_ISREG(ctx->stat->mode)) {
+		err = ovl_fsync_index(ctx->dentry, ctx->temp);
+		if (err)
+			goto out;
+	}
+
 	inode_lock_nested(d_inode(ctx->upperdir), I_MUTEX_PARENT);
 	/* link the sucker ;) */
 	err = ovl_do_link(ctx->temp, d_inode(ctx->upperdir), ctx->upper, true);
@@ -672,18 +713,8 @@ static int ovl_copy_up_indexdir_commit(struct ovl_copy_up_ctx *ctx)
 	if (err)
 		goto out;
 
-	/*
-	 * Overlay inode nlink doesn't account for lower hardlinks that haven't
-	 * been copied up, so we need to update it on copy up. Otherwise, user
-	 * could decrement nlink below zero by unlinking copied up uppers.
-	 * On the first copy up, we set overlay inode nlink to upper inode nlink
-	 * and on following copy ups we increment it. In between, ovl_link()
-	 * could add more upper hardlinks and increment overlay nlink as well.
-	 */
-	if (ctx->created)
-		set_nlink(d_inode(ctx->dentry), d_inode(ctx->temp)->i_nlink);
-	else
-		inc_nlink(d_inode(ctx->dentry));
+	/* Store the union nlink value relative to index inode nlink */
+	ovl_set_nlink(d_inode(ctx->dentry), ctx->temp, true);
 
 	/* We can mark dentry is indexed before updating upperdentry */
 	ovl_dentry_set_indexed(ctx->dentry);
@@ -699,6 +730,9 @@ static void ovl_copy_up_indexdir_cancel(struct ovl_copy_up_ctx *ctx)
 	if (WARN_ON(!inode))
 		return;
 
+	/* Store the union nlink value relative to index inode nlink */
+	ovl_set_nlink(d_inode(ctx->dentry), ctx->temp, true);
+
 	/* Cleanup prepared index entry only if we created it */
 	if (!ctx->created)
 		return;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 45120e9d8bbd..c9ba057ccfa3 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -18,6 +18,7 @@
 #include <linux/atomic.h>
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
+#include "ovl_entry.h"
 
 static unsigned short ovl_redirect_max = 256;
 module_param_named(redirect_max, ovl_redirect_max, ushort, 0644);
@@ -585,6 +586,64 @@ static int ovl_symlink(struct inode *dir, struct dentry *dentry,
 	return ovl_create_object(dentry, S_IFLNK, 0, link);
 }
 
+/*
+ * Operations that change overlay inode and upper inode nlink need to be
+ * synchronized with copy up for persistent nlink accounting.
+ */
+static int ovl_nlink_start(struct dentry *dentry)
+{
+	enum ovl_path_type type = ovl_path_type(dentry);
+	int err;
+	const struct cred *old_cred;
+
+	/*
+	 * With inodes index is enabled, we store the union overlay nlink
+	 * in an xattr on the index inode. When whiting out lower hardlinks
+	 * we need to decrement the overlay persistent nlink, but before the
+	 * first copy up, we have no upper index inode to store the xattr.
+	 *
+	 * As a workaround, before whiteout/rename over of a lower hardlink,
+	 * copy up to create the upper index. Creating the upper index will
+	 * initialize the overlay nlink, so it could be dropped if unlink
+	 * or rename succeeds.
+	 *
+	 * TODO: implement metadata only index copy up when called with
+	 *       ovl_copy_up_flags(dentry, O_PATH).
+	 */
+	if (ovl_indexdir(dentry->d_sb) && !OVL_TYPE_UPPER(type) &&
+	    ovl_dentry_lower(dentry)->d_inode->i_nlink > 1) {
+		err = ovl_copy_up(dentry);
+		if (err)
+			return err;
+
+		type = ovl_path_type(dentry);
+	}
+
+	err = mutex_lock_interruptible(&OVL_I(d_inode(dentry))->oi_lock);
+	if (err)
+		return err;
+
+	if (!OVL_TYPE_INDEX(type) || !OVL_TYPE_UPPER(type))
+		return 0;
+
+	old_cred = ovl_override_creds(dentry->d_sb);
+	/*
+	 * The overlay inode nlink should be incremented/decremented IFF the
+	 * upper operation succeeds, along with nlink change of upper inode.
+	 * Therefore, before link/unlink/rename, we store the union nlink
+	 * value relative to the upper inode nlink in an upper inode xattr.
+	 */
+	ovl_set_nlink(d_inode(dentry), ovl_dentry_upper(dentry), true);
+	revert_creds(old_cred);
+
+	return 0;
+}
+
+static void ovl_nlink_end(struct dentry *dentry)
+{
+	mutex_unlock(&OVL_I(d_inode(dentry))->oi_lock);
+}
+
 static int ovl_link(struct dentry *old, struct inode *newdir,
 		    struct dentry *new)
 {
@@ -599,6 +658,10 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	if (err)
 		goto out_drop_write;
 
+	err = ovl_nlink_start(old);
+	if (err)
+		goto out_drop_write;
+
 	inode = d_inode(old);
 	ihold(inode);
 
@@ -606,6 +669,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	if (err)
 		iput(inode);
 
+	ovl_nlink_end(old);
 out_drop_write:
 	ovl_drop_write(old);
 out:
@@ -736,7 +800,6 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 
 static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 {
-	enum ovl_path_type type;
 	int err;
 	const struct cred *old_cred;
 
@@ -748,7 +811,9 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	if (err)
 		goto out_drop_write;
 
-	type = ovl_path_type(dentry);
+	err = ovl_nlink_start(dentry);
+	if (err)
+		goto out_drop_write;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	if (!ovl_lower_positive(dentry))
@@ -762,6 +827,8 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 		else
 			drop_nlink(dentry->d_inode);
 	}
+
+	ovl_nlink_end(dentry);
 out_drop_write:
 	ovl_drop_write(dentry);
 out:
@@ -929,6 +996,10 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		if (err)
 			goto out_drop_write;
 	} else if (!new_is_dir && new->d_inode) {
+		err = ovl_nlink_start(new);
+		if (err)
+			goto out_drop_write;
+
 		new_drop_nlink = true;
 	}
 
@@ -1064,6 +1135,11 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	unlock_rename(new_upperdir, old_upperdir);
 out_revert_creds:
 	revert_creds(old_cred);
+	/*
+	 * Release oi_lock after rename lock.
+	 */
+	if (new_drop_nlink)
+		ovl_nlink_end(new);
 out_drop_write:
 	ovl_drop_write(old);
 out:
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 28f9a8cc0f61..b83d7e387a02 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/cred.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
+#include <linux/ratelimit.h>
 #include "overlayfs.h"
 #include "ovl_entry.h"
 
@@ -131,6 +132,15 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	if (is_dir && OVL_TYPE_MERGE(type))
 		stat->nlink = 1;
 
+	/*
+	 * Return the overlay inode nlinks for indexed upper inodes.
+	 * Overlay inode nlink counts the union of the upper hardlinks
+	 * and non-covered lower hardlinks. It does not include the upper
+	 * index hardlink.
+	 */
+	if (!is_dir && OVL_TYPE_UPPER(type) && OVL_TYPE_INDEX(type))
+		stat->nlink = dentry->d_inode->i_nlink;
+
 out:
 	revert_creds(old_cred);
 
@@ -445,6 +455,93 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
 	}
 }
 
+/*
+ * With inodes index enabled, an overlay inode nlink counts the union of upper
+ * hardlinks and non-covered lower hardlinks. During the lifetime of a non-pure
+ * upper inode, the following nlink modifying operations can happen:
+ *
+ * 1. Lower hardlink copy up
+ * 2. Upper hardlink created, unlinked or renamed over
+ * 3. Lower hardlink whiteout or renamed over
+ *
+ * For the first, copy up case, the union nlink does not change, whether the
+ * operation succeeds or fails, but the upper inode nlink may change.
+ * Therefore, before copy up, we store the union nlink value relative to the
+ * lower inode nlink in the index inode xattr trusted.overlay.nlink.
+ *
+ * For the second, upper hardlink case, the union nlink should be incremented
+ * or decremented IFF the operation succeeds, aligned with nlink change of the
+ * upper inode. Therefore, before link/unlink/rename, we store the union nlink
+ * value relative to the upper inode nlink in the index inode.
+ *
+ * For the last, lower cover up case, we simplify things by preceding the
+ * whiteout or cover up with copy up. This makes sure that there is an index
+ * upper inode where the nlink xattr can be stored before the copied up upper
+ * entry is unlink.
+ */
+#define OVL_NLINK_ADD_UPPER	(1 << 0)
+
+/* On-disk format for indexed nlink */
+struct ovl_nlink {
+	__be32 nlink_add;
+	u8 flags;
+} __packed;
+
+/* Called must hold OVL_I(inode)->oi_lock */
+int ovl_set_nlink(struct inode *inode, struct dentry *index, bool add_upper)
+{
+	struct ovl_inode_info *oi = OVL_I_INFO(inode);
+	struct ovl_nlink onlink;
+	unsigned int nlink_base;
+
+	if (add_upper) {
+		/* oi->__upperinode may be NULL after failed copy up */
+		nlink_base = index->d_inode->i_nlink;
+		onlink.flags = OVL_NLINK_ADD_UPPER;
+	} else {
+		nlink_base = oi->lowerinode->i_nlink;
+		onlink.flags = 0;
+	}
+	onlink.nlink_add = cpu_to_be32(inode->i_nlink - nlink_base);
+
+	return ovl_do_setxattr(index, OVL_XATTR_NLINK,
+			       &onlink, sizeof(onlink), 0);
+}
+
+static unsigned int ovl_get_nlink(struct ovl_inode_info *info,
+				  struct dentry *index, unsigned int real_nlink)
+{
+	struct ovl_nlink onlink;
+	__s32 nlink_add = 0;
+	int res;
+
+	if (!index || !index->d_inode)
+		return real_nlink;
+
+	res = vfs_getxattr(index, OVL_XATTR_NLINK, &onlink, sizeof(onlink));
+	if (res < sizeof(onlink))
+		goto fail;
+
+	if (onlink.flags & OVL_NLINK_ADD_UPPER) {
+		/* info->__upperinode may be NULL for indexed lower */
+		nlink_add = index->d_inode->i_nlink;
+	} else {
+		nlink_add = info->lowerinode->i_nlink;
+	}
+
+	nlink_add += (__s32)be32_to_cpu(onlink.nlink_add);
+	if (nlink_add < 0)
+		goto fail;
+
+	return nlink_add;
+
+fail:
+	pr_warn_ratelimited("overlayfs: failed to get index nlink (%pd2, ino=%lu, nlink=%u, nlink_add=%d, res=%i)\n",
+			    index, index->d_inode->i_ino,
+			    index->d_inode->i_nlink, nlink_add, res);
+	return real_nlink;
+}
+
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 {
 	struct inode *inode;
@@ -487,7 +584,8 @@ static int ovl_inode_set(struct inode *inode, void *data)
 	return 0;
 }
 
-struct inode *ovl_get_inode(struct super_block *sb, struct ovl_inode_info *info)
+struct inode *ovl_get_inode(struct super_block *sb, struct ovl_inode_info *info,
+			    struct dentry *index)
 {
 	struct inode *realinode = info->__upperinode;
 	unsigned long hashval = (unsigned long) realinode;
@@ -513,7 +611,8 @@ struct inode *ovl_get_inode(struct super_block *sb, struct ovl_inode_info *info)
 	inode = iget5_locked(sb, hashval, ovl_inode_test, ovl_inode_set, info);
 	if (inode && inode->i_state & I_NEW) {
 		ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
-		set_nlink(inode, realinode->i_nlink);
+		set_nlink(inode, ovl_get_nlink(OVL_I_INFO(inode), index,
+					       realinode->i_nlink));
 		ovl_copyattr(realinode, inode);
 		unlock_new_inode(inode);
 	}
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index c6b986b68105..5ff5f82f6503 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -713,7 +713,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 
 		err = -ENOMEM;
 		if ((upperdentry || index) && !d.is_dir) {
-			inode = ovl_get_inode(dentry->d_sb, &info);
+			inode = ovl_get_inode(dentry->d_sb, &info, index);
 		} else {
 			inode = ovl_new_inode(dentry->d_sb, realinode->i_mode,
 					      realinode->i_rdev);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 250b3d42da86..82c1d51b7b63 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -31,6 +31,7 @@ enum ovl_path_type {
 #define OVL_XATTR_REDIRECT OVL_XATTR_PREFIX "redirect"
 #define OVL_XATTR_ORIGIN OVL_XATTR_PREFIX "origin"
 #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
+#define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
 
 /*
  * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
@@ -270,10 +271,11 @@ int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
+int ovl_set_nlink(struct inode *inode, struct dentry *index, bool add_upper);
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct ovl_inode_info;
-struct inode *ovl_get_inode(struct super_block *sb,
-			    struct ovl_inode_info *info);
+struct inode *ovl_get_inode(struct super_block *sb, struct ovl_inode_info *info,
+			    struct dentry *index);
 
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
-- 
2.7.4
