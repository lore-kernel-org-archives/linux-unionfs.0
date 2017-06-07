From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 18/20] ovl: implement index dir copy up method
Date: Wed,  7 Jun 2017 10:51:22 +0300
Message-ID: <1496821884-5178-19-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

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
 fs/overlayfs/copy_up.c | 209 ++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 200 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 843ba9ca7bfc..f08220c82c77 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -345,7 +345,8 @@ static int ovl_copy_up_inode(struct dentry *dentry, struct dentry *temp,
 
 	/*
 	 * Store identifier of lower inode in upper inode xattr to
-	 * allow lookup of the copy up origin inode.
+	 * allow lookup of the copy up origin inode. We do this last
+	 * to bless the inode, in case it was created in the index dir.
 	 */
 	err = ovl_set_origin(dentry, lowerpath->dentry, temp);
 
@@ -365,6 +366,7 @@ struct ovl_copy_up_ctx {
 	struct dentry *tempdir;
 	struct dentry *upper;
 	struct dentry *temp;
+	bool created;
 };
 
 struct ovl_copy_up_ops {
@@ -543,6 +545,187 @@ static const struct ovl_copy_up_ops ovl_copy_up_tmpfile_ops = {
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
+	struct dentry *index;
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
+	index = dget(ovl_dentry_index(ctx->dentry));
+	BUG_ON(!index);
+	inode = d_inode(index);
+	if (inode) {
+		/* Another lower hardlink already copied-up? */
+		err = -EEXIST;
+		if ((inode->i_mode & S_IFMT) != cattr.mode)
+			goto out_dput;
+
+		err = -ENOENT;
+		if (!inode->i_nlink)
+			goto out_dput;
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
+		err = ovl_verify_origin(index, ctx->lowerpath->mnt,
+					ctx->lowerpath->dentry, false);
+		if (err) {
+			if (err == -ENODATA)
+				err = -EEXIST;
+			goto out_dput;
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
+			 *
+			 * TODO: keep account of nlink incremented by copy up
+			 * and account of nlink decremented by lower cover up.
+			 * When copyup_nlink + coverup_nlink == origin_nlink
+			 * and index_nlink == 1, need to replace the index entry
+			 * with a whiteout because all overlay references to the
+			 * index are gone.
+			 */
+			pr_warn_ratelimited("overlayfs: linking to orphan upper (%pd2, ino=%lu)\n",
+					    index, inode->i_ino);
+		}
+
+		/* Link to existing upper without copying lower */
+		err = 1;
+		goto out;
+	}
+
+	inode_lock_nested(d_inode(ctx->tempdir), I_MUTEX_PARENT);
+	err = ovl_create_real(d_inode(ctx->tempdir), index, &cattr, NULL, true);
+	if (!err)
+		ctx->created = true;
+	inode_unlock(d_inode(ctx->tempdir));
+	if (err)
+		goto out_dput;
+
+out:
+	ctx->upper = upper;
+	ctx->temp = index;
+	return err;
+
+out_dput:
+	pr_warn_ratelimited("overlayfs: failed to create index entry (%pd2, ino=%lu, err=%i)\n",
+			    index, inode ? inode->i_ino : 0, err);
+	pr_warn_ratelimited("overlayfs: try clearing index dir or mounting with '-o index=off' to disable inodes index.\n");
+	dput(upper);
+	dput(index);
+	/* In case a bad/deleted index inode is cached in overlay dentry */
+	d_drop(ctx->dentry);
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
+	/*
+	 * Overlay inode nlink doesn't account for lower hardlinks that haven't
+	 * been copied up, so we need to update it on copy up. Otherwise, user
+	 * could decrement nlink below zero by unlinking copied up uppers.
+	 * On the first copy up, we set nlink to 1 (excluding the index entry)
+	 * and on following copy ups we increment it. In between ovl_link
+	 * could add more upper hardlinks and increment nlink as well.
+	 */
+	if (!err) {
+		if (ctx->created)
+			set_nlink(d_inode(ctx->dentry), 1);
+		else
+			inc_nlink(d_inode(ctx->dentry));
+		/* Restore timestamps on parent (best effort) */
+		ovl_set_timestamps(ctx->upperdir, &ctx->pstat);
+	}
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
+	/* Cleanup prepared index entry only if we created it */
+	if (!ctx->created)
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
+	pr_warn_ratelimited("overlayfs: cleanup bad index (%pd2, ino=%lu)\n",
+			    ctx->temp, inode->i_ino);
+	ovl_cleanup(d_inode(ctx->tempdir), ctx->temp);
+	/* Bad index inode is still cached in overlay dentry */
+	d_drop(ctx->dentry);
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
@@ -565,12 +748,16 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *ctx,
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
@@ -584,8 +771,8 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *ctx,
 	}
 
 out:
-	dput(ctx->temp);
 	dput(ctx->upper);
+	dput(ctx->temp);
 	return err;
 
 out_cancel:
@@ -610,12 +797,14 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	struct path parentpath;
 	struct dentry *lowerdentry = lowerpath->dentry;
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	bool indexed = ovl_dentry_index(dentry);
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
 
@@ -643,8 +832,10 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
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
