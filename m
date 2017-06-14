From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 20/23] ovl: implement index dir copy up method
Date: Wed, 14 Jun 2017 10:26:39 +0300
Message-ID: <1497425202-16270-21-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33868 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754280AbdFNH1E (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:27:04 -0400
Received: by mail-wr0-f193.google.com with SMTP id u101so37036658wrc.1
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:26:58 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Implement a copy up method for non-dir objects using index dir to
prevent breaking lower hardlinks on copy up.

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
 fs/overlayfs/copy_up.c   | 212 +++++++++++++++++++++++++++++++++++++++++++++--
 fs/overlayfs/namei.c     |   4 +-
 fs/overlayfs/overlayfs.h |   3 +
 fs/overlayfs/util.c      |   9 ++
 4 files changed, 218 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 452560a17d7e..1f2007c35755 100644
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
@@ -537,6 +539,192 @@ static const struct ovl_copy_up_ops ovl_copy_up_tmpfile_ops = {
 	.release = ovl_copy_up_tmpfile_release,
 };
 
+/*
+ * Copy up operations using index dir.
+ * Upper file is created in index dir, copied and linked to upperdir.
+ * The index entry remains to be used for mapping lower inode to upper inode.
+ */
+static int ovl_copy_up_indexdir_aquire(struct ovl_copy_up_ctx *ctx)
+{
+	return ovl_copy_up_start(ctx->dentry);
+}
+
+/*
+ * Set ctx->temp to a positive dentry with the index inode.
+ *
+ * Return 0 if entry was created by us and we need to copy the inode data.
+ *
+ * Return 1 if we found an index inode, in which case, we do not need
+ * to copy the inode data.
+ *
+ * May return -EEXISTS/-ENOENT if corrupt index entries are found.
+ */
+static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
+{
+	struct dentry *upper;
+	struct dentry *index = NULL;
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
+	err = ovl_lookup_index(ctx->dentry, NULL, ctx->lowerpath->dentry,
+			       &index);
+	if (err)
+		goto out_dput;
+
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
+		 * origin file handle, then this is either a leftover from
+		 * failed copy up or an index dir entry before copying layers.
+		 * In both cases, we cannot use this index and must fail the
+		 * copy up. The failed copy up case will return -EEXISTS and
+		 * the copying layers case will return -ESTALE.
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
+	inode_unlock(d_inode(ctx->tempdir));
+	if (err)
+		goto out_dput;
+
+	ctx->created = true;
+out:
+	ctx->upper = upper;
+	ctx->temp = index;
+	return err;
+
+out_dput:
+	pr_warn_ratelimited("overlayfs: failed to create index entry (%pd2, ino=%lu, err=%i)\n",
+			    index ? : ctx->lowerpath->dentry,
+			    inode ? inode->i_ino : 0, err);
+	pr_warn_ratelimited("overlayfs: try clearing index dir or mounting with '-o index=off' to disable inodes index.\n");
+	dput(upper);
+	dput(index);
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
+	if (err)
+		goto out;
+
+	/*
+	 * Overlay inode nlink doesn't account for lower hardlinks that haven't
+	 * been copied up, so we need to update it on copy up. Otherwise, user
+	 * could decrement nlink below zero by unlinking copied up uppers.
+	 * On the first copy up, we set overlay inode nlink to upper inode nlink
+	 * and on following copy ups we increment it. In between, ovl_link()
+	 * could add more upper hardlinks and increment overlay nlink as well.
+	 */
+	if (ctx->created)
+		set_nlink(d_inode(ctx->dentry), d_inode(ctx->temp)->i_nlink);
+	else
+		inc_nlink(d_inode(ctx->dentry));
+
+	/* We can mark dentry is indexed before updating upperdentry */
+	ovl_dentry_set_indexed(ctx->dentry);
+
+out:
+	return err;
+}
+
+static void ovl_copy_up_indexdir_cancel(struct ovl_copy_up_ctx *ctx)
+{
+	struct inode *inode = d_inode(ctx->temp);
+
+	if (WARN_ON(!inode))
+		return;
+
+	/* Cleanup prepared index entry only if we created it */
+	if (!ctx->created)
+		return;
+
+	pr_warn_ratelimited("overlayfs: cleanup bad index (%pd2, ino=%lu, nlink=%u)\n",
+			    ctx->temp, inode->i_ino, inode->i_nlink);
+
+	inode_lock_nested(d_inode(ctx->tempdir), I_MUTEX_PARENT);
+	ovl_cleanup(d_inode(ctx->tempdir), ctx->temp);
+	inode_unlock(d_inode(ctx->tempdir));
+}
+
+static void ovl_copy_up_indexdir_release(struct ovl_copy_up_ctx *ctx)
+{
+	ovl_copy_up_end(ctx->dentry);
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
@@ -559,12 +747,16 @@ static int ovl_copy_up_locked(struct ovl_copy_up_ctx *ctx,
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
@@ -604,12 +796,14 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
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
 
@@ -637,8 +831,10 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			return PTR_ERR(ctx.link);
 	}
 
-	/* Should we copyup with O_TMPFILE or with workdir? */
-	if (S_ISREG(stat->mode) && ofs->tmpfile)
+	/* Should we copyup with O_TMPFILE, with indexdir or with workdir? */
+	if (indexed)
+		ops = &ovl_copy_up_indexdir_ops;
+	else if (S_ISREG(stat->mode) && ofs->tmpfile)
 		ops = &ovl_copy_up_tmpfile_ops;
 	else
 		ops = &ovl_copy_up_workdir_ops;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 31f5ad774499..193177883dc7 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -381,8 +381,8 @@ int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
  * index dir was cleared. Either way, that index cannot be used to indentify
  * the overlay inode.
  */
-static int ovl_lookup_index(struct dentry *dentry, struct dentry *upper,
-			    struct dentry *lower, struct dentry **indexp)
+int ovl_lookup_index(struct dentry *dentry, struct dentry *upper,
+		     struct dentry *lower, struct dentry **indexp)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 	struct ovl_fh *fh;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 0e801059311a..28dd0d59d998 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -206,6 +206,7 @@ bool ovl_dentry_is_opaque(struct dentry *dentry);
 bool ovl_dentry_is_impure(struct dentry *dentry);
 bool ovl_dentry_is_whiteout(struct dentry *dentry);
 void ovl_dentry_set_opaque(struct dentry *dentry);
+void ovl_dentry_set_indexed(struct dentry *dentry);
 bool ovl_redirect_dir(struct super_block *sb);
 const char *ovl_dentry_get_redirect(struct dentry *dentry);
 void ovl_dentry_set_redirect(struct dentry *dentry, const char *redirect);
@@ -235,6 +236,8 @@ static inline bool ovl_is_impuredir(struct dentry *dentry)
 /* namei.c */
 int ovl_verify_origin(struct dentry *dentry, struct vfsmount *mnt,
 		      struct dentry *origin, bool is_upper);
+int ovl_lookup_index(struct dentry *dentry, struct dentry *upper,
+		     struct dentry *lower, struct dentry **indexp);
 int ovl_path_next(int idx, struct dentry *dentry, struct path *path, int *idxp);
 struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry, unsigned int flags);
 bool ovl_lower_positive(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 9c729322d3b0..0211ec353adc 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -230,6 +230,15 @@ static void ovl_dentry_set_impure(struct dentry *dentry)
 	spin_unlock(&dentry->d_lock);
 }
 
+void ovl_dentry_set_indexed(struct dentry *dentry)
+{
+	struct ovl_entry *oe = dentry->d_fsdata;
+
+	spin_lock(&dentry->d_lock);
+	oe->__type |= __OVL_PATH_INDEX;
+	spin_unlock(&dentry->d_lock);
+}
+
 bool ovl_redirect_dir(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
-- 
2.7.4
