From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 17/23] ovl: generalize ovl_copy_up_locked() using actors
Date: Wed, 14 Jun 2017 10:26:36 +0300
Message-ID: <1497425202-16270-18-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:32965 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754406AbdFNH0z (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:26:55 -0400
Received: by mail-wr0-f196.google.com with SMTP id v104so36664752wrb.0
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:26:54 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

ovl_copy_up_locked() is implementing two different copy up methods in one
function with many conditional statements.

Split the function into actors: prepare,commit,cancel.
Implement the actors for the 'workdir' and 'tmpfile' copy up methods.

The aquire,release code for the two methods is still open coded in
ovl_copy_up_one(). Next patch will implement the aquire,release actors.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 250 ++++++++++++++++++++++++++++++++++---------------
 1 file changed, 172 insertions(+), 78 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index e642a51f3be4..39e982acc6c3 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -352,104 +352,197 @@ static int ovl_copy_up_inode(struct dentry *dentry, struct dentry *temp,
 	return err;
 }
 
-static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
-			      struct dentry *dentry, struct path *lowerpath,
-			      struct kstat *stat, const char *link,
-			      struct kstat *pstat, bool tmpfile)
+/*
+ * Context and operations for copying up a single lower file.
+ */
+struct ovl_copy_up_ctx {
+	struct dentry *dentry;
+	struct path *lowerpath;
+	struct kstat *stat;
+	struct kstat pstat;
+	const char *link;
+	struct dentry *upperdir;
+	struct dentry *tempdir;
+	struct dentry *upper;
+	struct dentry *temp;
+};
+
+struct ovl_copy_up_ops {
+	int (*prepare)(struct ovl_copy_up_ctx *);
+	int (*commit)(struct ovl_copy_up_ctx *);
+	void (*cancel)(struct ovl_copy_up_ctx *);
+};
+
+/*
+ * Copy up operations using workdir.
+ * Upper file is created in workdir, copied and moved to upperdir.
+ */
+static int ovl_copy_up_workdir_prepare(struct ovl_copy_up_ctx *ctx)
 {
-	struct inode *wdir = workdir->d_inode;
-	struct inode *udir = upperdir->d_inode;
-	struct dentry *newdentry = NULL;
 	struct dentry *upper = NULL;
 	struct dentry *temp = NULL;
 	int err;
-	const struct cred *old_creds = NULL;
-	struct cred *new_creds = NULL;
 	struct cattr cattr = {
 		/* Can't properly set mode on creation because of the umask */
-		.mode = stat->mode & S_IFMT,
-		.rdev = stat->rdev,
-		.link = link
+		.mode = ctx->stat->mode & S_IFMT,
+		.rdev = ctx->stat->rdev,
+		.link = ctx->link,
 	};
 
-	if (tmpfile) {
-		upper = lookup_one_len_unlocked(dentry->d_name.name, upperdir,
-						dentry->d_name.len);
-	} else {
-		upper = lookup_one_len(dentry->d_name.name, upperdir,
-				       dentry->d_name.len);
-	}
+
+	upper = lookup_one_len(ctx->dentry->d_name.name, ctx->upperdir,
+			       ctx->dentry->d_name.len);
 	err = PTR_ERR(upper);
 	if (IS_ERR(upper))
 		goto out;
 
+	temp = ovl_lookup_temp(ctx->tempdir);
+	if (IS_ERR(temp)) {
+		err = PTR_ERR(temp);
+		goto out_dput_upper;
+	}
+
+	err = ovl_create_real(d_inode(ctx->tempdir), temp, &cattr, NULL, true);
+	if (err)
+		goto out_dput_temp;
+
+	ctx->upper = upper;
+	ctx->temp = temp;
+	return 0;
+
+out_dput_temp:
+	dput(temp);
+out_dput_upper:
+	dput(upper);
+out:
+	return err;
+}
+
+static int ovl_copy_up_workdir_commit(struct ovl_copy_up_ctx *ctx)
+{
+	int err;
+
+	err = ovl_do_rename(d_inode(ctx->tempdir), ctx->temp,
+			    d_inode(ctx->upperdir), ctx->upper, 0);
+	if (err)
+		return err;
+
+	/* After rename, ctx->temp is the upper entry we will use */
+	swap(ctx->temp, ctx->upper);
+
+	/* Restore timestamps on parent (best effort) */
+	ovl_set_timestamps(ctx->upperdir, &ctx->pstat);
+
+	return err;
+}
+
+static void ovl_copy_up_workdir_cancel(struct ovl_copy_up_ctx *ctx)
+{
+	ovl_cleanup(d_inode(ctx->tempdir), ctx->temp);
+}
+
+static const struct ovl_copy_up_ops ovl_copy_up_workdir_ops = {
+	.prepare = ovl_copy_up_workdir_prepare,
+	.commit = ovl_copy_up_workdir_commit,
+	.cancel = ovl_copy_up_workdir_cancel,
+};
+
+/*
+ * Copy up operations using O_TMPFILE.
+ * Upper file is created unlinked, copied and linked to upperdir.
+ */
+static int ovl_copy_up_tmpfile_prepare(struct ovl_copy_up_ctx *ctx)
+{
+	struct dentry *upper;
+	struct dentry *temp;
+
+	upper = lookup_one_len_unlocked(ctx->dentry->d_name.name, ctx->upperdir,
+					ctx->dentry->d_name.len);
+	if (IS_ERR(upper))
+		return PTR_ERR(upper);
+
+	temp = ovl_do_tmpfile(ctx->upperdir, ctx->stat->mode);
+	if (IS_ERR(temp)) {
+		dput(upper);
+		return PTR_ERR(temp);
+	}
+
+	ctx->upper = upper;
+	ctx->temp = temp;
+	return 0;
+}
+
+static int ovl_copy_up_tmpfile_commit(struct ovl_copy_up_ctx *ctx)
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
+static void ovl_copy_up_tmpfile_cancel(struct ovl_copy_up_ctx *ctx) { }
+
+static const struct ovl_copy_up_ops ovl_copy_up_tmpfile_ops = {
+	.prepare = ovl_copy_up_tmpfile_prepare,
+	.commit = ovl_copy_up_tmpfile_commit,
+	.cancel = ovl_copy_up_tmpfile_cancel,
+};
+
+static int ovl_copy_up_locked(struct ovl_copy_up_ctx *ctx,
+			      const struct ovl_copy_up_ops *ops)
+{
+	struct dentry *dentry = ctx->dentry;
+	const struct cred *old_creds = NULL;
+	struct cred *new_creds = NULL;
+	int err;
+
 	err = security_inode_copy_up(dentry, &new_creds);
 	if (err < 0)
-		goto out1;
+		return err;
 
 	if (new_creds)
 		old_creds = override_creds(new_creds);
 
-	if (tmpfile)
-		temp = ovl_do_tmpfile(upperdir, stat->mode);
-	else
-		temp = ovl_lookup_temp(workdir);
-	err = 0;
-	if (IS_ERR(temp)) {
-		err = PTR_ERR(temp);
-		temp = NULL;
-	}
-
-	if (!err && !tmpfile)
-		err = ovl_create_real(wdir, temp, &cattr, NULL, true);
+	ctx->upper = ctx->temp = NULL;
+	err = ops->prepare(ctx);
 
 	if (new_creds) {
 		revert_creds(old_creds);
 		put_cred(new_creds);
 	}
-
 	if (err)
-		goto out2;
+		goto out;
 
-	err = ovl_copy_up_inode(dentry, temp, lowerpath, stat);
+	err = ovl_copy_up_inode(dentry, ctx->temp, ctx->lowerpath, ctx->stat);
 	if (err)
-		goto out_cleanup;
+		goto out_cancel;
 
-	if (tmpfile) {
-		inode_lock_nested(udir, I_MUTEX_PARENT);
-		err = ovl_do_link(temp, udir, upper, true);
-		if (!err)
-			ovl_set_timestamps(upperdir, pstat);
-		pstat = NULL;
-		inode_unlock(udir);
-	} else {
-		err = ovl_do_rename(wdir, temp, udir, upper, 0);
-	}
+	err = ops->commit(ctx);
 	if (err)
-		goto out_cleanup;
+		goto out_cancel;
 
-	newdentry = dget(tmpfile ? upper : temp);
-	ovl_dentry_update(dentry, newdentry);
-	err = ovl_inode_update(d_inode(dentry), d_inode(newdentry));
+	ovl_dentry_update(dentry, dget(ctx->upper));
+	err = ovl_inode_update(d_inode(dentry), d_inode(ctx->upper));
 	if (err) {
 		/* Broken hardlink - drop cache and return error */
 		d_drop(dentry);
 	}
 
-	/* Restore timestamps on parent (best effort) */
-	if (pstat)
-		ovl_set_timestamps(upperdir, pstat);
-out2:
-	dput(temp);
-out1:
-	dput(upper);
 out:
+	dput(ctx->temp);
+	dput(ctx->upper);
 	return err;
 
-out_cleanup:
-	if (!tmpfile)
-		ovl_cleanup(wdir, temp);
-	goto out2;
+out_cancel:
+	ops->cancel(ctx);
+	goto out;
 }
 
 /*
@@ -465,37 +558,40 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			   struct path *lowerpath, struct kstat *stat)
 {
 	DEFINE_DELAYED_CALL(done);
-	struct dentry *workdir = ovl_workdir(dentry);
 	int err;
-	struct kstat pstat;
 	struct path parentpath;
 	struct dentry *lowerdentry = lowerpath->dentry;
-	struct dentry *upperdir;
-	const char *link = NULL;
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+	struct ovl_copy_up_ctx ctx = {
+		.dentry = dentry,
+		.lowerpath = lowerpath,
+		.stat = stat,
+		.link = NULL,
+		.tempdir = ovl_workdir(dentry),
+	};
 
-	if (WARN_ON(!workdir))
+	if (WARN_ON(!ctx.tempdir))
 		return -EROFS;
 
 	ovl_do_check_copy_up(lowerdentry);
 
 	ovl_path_upper(parent, &parentpath);
-	upperdir = parentpath.dentry;
+	ctx.upperdir = parentpath.dentry;
 
 	/* Mark parent "impure" because it may now contain non-pure upper */
-	err = ovl_set_impure(parent, upperdir);
+	err = ovl_set_impure(parent, ctx.upperdir);
 	if (err)
 		return err;
 
-	err = vfs_getattr(&parentpath, &pstat,
+	err = vfs_getattr(&parentpath, &ctx.pstat,
 			  STATX_ATIME | STATX_MTIME, AT_STATX_SYNC_AS_STAT);
 	if (err)
 		return err;
 
 	if (S_ISLNK(stat->mode)) {
-		link = vfs_get_link(lowerdentry, &done);
-		if (IS_ERR(link))
-			return PTR_ERR(link);
+		ctx.link = vfs_get_link(lowerdentry, &done);
+		if (IS_ERR(ctx.link))
+			return PTR_ERR(ctx.link);
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
@@ -509,14 +605,13 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 			goto out_done;
 		}
 
-		err = ovl_copy_up_locked(workdir, upperdir, dentry, lowerpath,
-					 stat, link, &pstat, true);
+		err = ovl_copy_up_locked(&ctx, &ovl_copy_up_tmpfile_ops);
 		ovl_copy_up_end(dentry);
 		goto out_done;
 	}
 
 	err = -EIO;
-	if (lock_rename(workdir, upperdir) != NULL) {
+	if (lock_rename(ctx.tempdir, ctx.upperdir) != NULL) {
 		pr_err("overlayfs: failed to lock workdir+upperdir\n");
 		goto out_unlock;
 	}
@@ -526,10 +621,9 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		goto out_unlock;
 	}
 
-	err = ovl_copy_up_locked(workdir, upperdir, dentry, lowerpath,
-				 stat, link, &pstat, false);
+	err = ovl_copy_up_locked(&ctx, &ovl_copy_up_workdir_ops);
 out_unlock:
-	unlock_rename(workdir, upperdir);
+	unlock_rename(ctx.tempdir, ctx.upperdir);
 out_done:
 	do_delayed_call(&done);
 
-- 
2.7.4
