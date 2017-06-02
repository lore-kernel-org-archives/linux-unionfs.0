From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 16/17] ovl: implement index dir copy up method
Date: Fri,  2 Jun 2017 17:04:43 +0300
Message-ID: <1496412284-4113-17-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33302 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751141AbdFBOFB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:05:01 -0400
Received: by mail-wr0-f195.google.com with SMTP id v104so1345571wrb.0
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:55 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Implement a copy up method using index dir to prevent breaking lower
hardlinks on copy up.

This method requires that the inodes index dir feature was enabled and
that all underlying fs support NFS export.

On the first lower hardlink copy up, upper file is created in index dir,
named after the hex representation of the lower origin inode file handle.
On the second lower hardlink copy up, upper file is found in index dir,
by the same lower handle key.
On either case, the upper indexed inode is then linked to the copy up
upper path.

The index entry remains linked for future lower hardlink copy up and for
lower to upper inode map, that is needed for exporting overlayfs to NFS.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 175 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 167 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 5031dd7fef89..59ea4c365b7a 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -351,7 +351,8 @@ static int ovl_copy_up_inode(struct dentry *dentry, struct dentry *temp,
 
 	/*
 	 * Store identifier of lower inode in upper inode xattr to
-	 * allow lookup of the copy up origin inode.
+	 * allow lookup of the copy up origin inode. We do this last
+	 * to bless the inode, in case it was created in the index dir.
 	 */
 	err = ovl_set_origin(dentry, lowerpath->dentry, temp);
 
@@ -549,6 +550,156 @@ static const struct ovl_copy_up_ops ovl_copy_up_tmpfile_ops = {
 	.release = ovl_copy_up_tmpfile_release,
 };
 
+/*
+ * Copy up operations using index dir.
+ * Upper file is created in index dir, copied and linked to upperdir.
+ * The index entry remains to be used for mapping lower inode to upper inode.
+ */
+static int ovl_copy_up_indexdir_aquire(struct ovl_copy_up_ctx *ctx)
+{
+	/* TODO: handle race of concurrent lower hardlinks copy up */
+	return ovl_copy_up_start(ctx->dentry);
+}
+
+static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
+{
+	struct dentry *upper;
+	struct dentry *temp;
+	struct inode *inode;
+	int err;
+	struct cattr cattr = {
+		/* Can't properly set mode on creation because of the umask */
+		.mode = ctx->stat->mode & S_IFMT,
+		.rdev = ctx->stat->rdev,
+		.link = ctx->link,
+	};
+
+	upper = lookup_one_len_unlocked(ctx->dentry->d_name.name, ctx->upperdir,
+					ctx->dentry->d_name.len);
+	if (IS_ERR(upper))
+		return PTR_ERR(upper);
+
+	temp = ovl_lookup_index(ctx->dentry->d_sb, ctx->lowerpath->dentry);
+	if (IS_ERR(temp)) {
+		err = PTR_ERR(temp);
+		goto out_dput_upper;
+	}
+
+	inode = d_inode(temp);
+	if (inode) {
+		/* Another lower hardlink already copied-up? */
+		err = -EEXIST;
+		if ((inode->i_mode & S_IFMT) != cattr.mode)
+			goto out_dput_temp;
+
+		/*
+		 * Verify that found index is a copy up of lower inode.
+		 * If index inode doesn't point back to lower inode via
+		 * origin file handle, then this is either an in-progress
+		 * copy up or leftover from index dir before copying layers.
+		 * In both cases, we cannot use this index and must fail the
+		 * copy up. The in-progress case will return -EEXISTS and the
+		 * leftover case will return -ESTALE.
+		 */
+		err = ovl_verify_origin(temp, ctx->lowerpath->mnt,
+					ctx->lowerpath->dentry, false);
+		if (err) {
+			if (err == -ENODATA)
+				err = -EEXIST;
+			goto out_dput_temp;
+		}
+
+		if (inode->i_nlink < 2) {
+			/*
+			 * An orphan index inode can be created by copying up
+			 * a lower hardlink alias and then unlinking it. From
+			 * overlayfs perspective, this inode may still live if
+			 * there are more lower hardlinks and it should contain
+			 * the data of the upper inode that was unlinked. So if
+			 * an orphan inode is found in the index dir and we
+			 * should reuse it on copy up of another lower alias.
+			 */
+			pr_warn_ratelimited("overlayfs: linking to orphan upper (%pd2, ino=%lu)\n",
+					    temp, inode->i_ino);
+		}
+
+		/* Link to existing upper without copying lower */
+		err = 1;
+		goto out;
+	}
+
+	inode_lock_nested(d_inode(ctx->tempdir), I_MUTEX_PARENT);
+	err = ovl_create_real(d_inode(ctx->tempdir), temp, &cattr, NULL, true);
+	inode_unlock(d_inode(ctx->tempdir));
+	if (err)
+		goto out_dput_temp;
+
+out:
+	ctx->upper = upper;
+	ctx->temp = temp;
+	return err;
+
+out_dput_temp:
+	pr_warn_ratelimited("overlayfs: failed to create index entry (%pd2, ino=%lu, err=%i)\n",
+			    temp, inode ? inode->i_ino : 0, err);
+	pr_warn_ratelimited("overlayfs: try clearing index dir or mounting without 'verify_lower' mount option.\n");
+	dput(temp);
+out_dput_upper:
+	dput(upper);
+	return err;
+}
+
+static int ovl_copy_up_indexdir_commit(struct ovl_copy_up_ctx *ctx)
+{
+	int err;
+
+	inode_lock_nested(d_inode(ctx->upperdir), I_MUTEX_PARENT);
+	/* link the sucker ;) */
+	err = ovl_do_link(ctx->temp, d_inode(ctx->upperdir), ctx->upper, true);
+	/* Restore timestamps on parent (best effort) */
+	if (!err)
+		ovl_set_timestamps(ctx->upperdir, &ctx->pstat);
+	inode_unlock(d_inode(ctx->upperdir));
+
+	return err;
+}
+
+static int ovl_copy_up_indexdir_cancel(struct ovl_copy_up_ctx *ctx)
+{
+	struct inode *inode = d_inode(ctx->temp);
+
+	if (WARN_ON(!inode))
+		return 0;
+
+	inode_lock_nested(d_inode(ctx->tempdir), I_MUTEX_PARENT);
+
+	/*
+	 * We must not cleanup an already hardlinked index.
+	 */
+	if (inode->i_nlink != 1)
+		goto out_unlock;
+
+	ovl_cleanup(d_inode(ctx->tempdir), ctx->temp);
+
+out_unlock:
+	inode_unlock(d_inode(ctx->tempdir));
+	return 0;
+}
+
+static int ovl_copy_up_indexdir_release(struct ovl_copy_up_ctx *ctx)
+{
+	ovl_copy_up_end(ctx->dentry);
+	return 0;
+}
+
+static const struct ovl_copy_up_ops ovl_copy_up_indexdir_ops = {
+	.aquire = ovl_copy_up_indexdir_aquire,
+	.prepare = ovl_copy_up_indexdir_prepare,
+	.commit = ovl_copy_up_indexdir_commit,
+	.cancel = ovl_copy_up_indexdir_cancel,
+	.release = ovl_copy_up_indexdir_release,
+};
+
 static int ovl_copy_up_locked(struct ovl_copy_up_ctx *ctx,
 			      const struct ovl_copy_up_ops *ops)
 {
@@ -571,12 +722,16 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *ctx,
 		revert_creds(old_creds);
 		put_cred(new_creds);
 	}
-	if (err)
+	if (err < 0)
 		goto out;
 
-	err = ovl_copy_up_inode(dentry, ctx->temp, ctx->lowerpath, ctx->stat);
-	if (err)
-		goto out_cancel;
+	/* err == 1 means we found an existing hardlinked upper inode */
+	if (!err) {
+		err = ovl_copy_up_inode(dentry, ctx->temp, ctx->lowerpath,
+					ctx->stat);
+		if (err)
+			goto out_cancel;
+	}
 
 	err = ops->commit(ctx);
 	if (err)
@@ -616,12 +771,14 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	struct path parentpath;
 	struct dentry *lowerdentry = lowerpath->dentry;
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	bool indexed = ovl_indexdir(dentry->d_sb) && !S_ISDIR(stat->mode);
 	struct ovl_copy_up_ctx ctx = {
 		.dentry = dentry,
 		.lowerpath = lowerpath,
 		.stat = stat,
 		.link = NULL,
-		.tempdir = ovl_workdir(dentry),
+		.tempdir = indexed ? ovl_indexdir(dentry->d_sb) :
+				     ovl_workdir(dentry),
 	};
 	const struct ovl_copy_up_ops *ops;
 
@@ -649,8 +806,10 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			return PTR_ERR(ctx.link);
 	}
 
-	/* Should we copyup with O_TMPFILE or with workdir? */
-	if (S_ISREG(stat->mode) && ofs->tmpfile)
+	/* Should we copyup with O_TMPFILE with indexdir or with workdir? */
+	if (indexed)
+		ops = &ovl_copy_up_indexdir_ops;
+	else if (S_ISREG(stat->mode) && ofs->tmpfile)
 		ops = &ovl_copy_up_tmpfile_ops;
 	else
 		ops = &ovl_copy_up_workdir_ops;
-- 
2.7.4
