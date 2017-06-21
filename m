From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 19/25] ovl: generalize ovl_copy_up_one() using actors
Date: Wed, 21 Jun 2017 15:28:50 +0300
Message-ID: <1498048136-28218-20-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:34150 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751160AbdFUM3M (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:29:12 -0400
Received: by mail-wr0-f196.google.com with SMTP id y25so23908969wrd.1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:29:11 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

ovl_copy_up_one() is implementing two different locking methods
for regular files and non-regular files.

Implement the actors aquire,release for the 'workdir' and 'tmpfile'
copy up methods and use them to generalize locking in ovl_copy_up_one().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 81 ++++++++++++++++++++++++++++++++++----------------
 1 file changed, 56 insertions(+), 25 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 39e982acc6c3..452560a17d7e 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -368,15 +368,38 @@ struct ovl_copy_up_ctx {
 };
 
 struct ovl_copy_up_ops {
+	int (*aquire)(struct ovl_copy_up_ctx *);
 	int (*prepare)(struct ovl_copy_up_ctx *);
 	int (*commit)(struct ovl_copy_up_ctx *);
 	void (*cancel)(struct ovl_copy_up_ctx *);
+	void (*release)(struct ovl_copy_up_ctx *);
 };
 
 /*
  * Copy up operations using workdir.
  * Upper file is created in workdir, copied and moved to upperdir.
  */
+static int ovl_copy_up_workdir_aquire(struct ovl_copy_up_ctx *ctx)
+{
+	int err = -EIO;
+
+	if (lock_rename(ctx->tempdir, ctx->upperdir) != NULL) {
+		pr_err("overlayfs: failed to lock workdir+upperdir\n");
+		goto out_unlock;
+	}
+	if (ovl_dentry_upper(ctx->dentry)) {
+		/* Raced with another copy-up? */
+		err = 1;
+		goto out_unlock;
+	}
+
+	return 0;
+
+out_unlock:
+	unlock_rename(ctx->tempdir, ctx->upperdir);
+	return err;
+}
+
 static int ovl_copy_up_workdir_prepare(struct ovl_copy_up_ctx *ctx)
 {
 	struct dentry *upper = NULL;
@@ -441,16 +464,28 @@ static void ovl_copy_up_workdir_cancel(struct ovl_copy_up_ctx *ctx)
 	ovl_cleanup(d_inode(ctx->tempdir), ctx->temp);
 }
 
+static void ovl_copy_up_workdir_release(struct ovl_copy_up_ctx *ctx)
+{
+	unlock_rename(ctx->tempdir, ctx->upperdir);
+}
+
 static const struct ovl_copy_up_ops ovl_copy_up_workdir_ops = {
+	.aquire = ovl_copy_up_workdir_aquire,
 	.prepare = ovl_copy_up_workdir_prepare,
 	.commit = ovl_copy_up_workdir_commit,
 	.cancel = ovl_copy_up_workdir_cancel,
+	.release = ovl_copy_up_workdir_release,
 };
 
 /*
  * Copy up operations using O_TMPFILE.
  * Upper file is created unlinked, copied and linked to upperdir.
  */
+static int ovl_copy_up_tmpfile_aquire(struct ovl_copy_up_ctx *ctx)
+{
+	return ovl_copy_up_start(ctx->dentry);
+}
+
 static int ovl_copy_up_tmpfile_prepare(struct ovl_copy_up_ctx *ctx)
 {
 	struct dentry *upper;
@@ -489,10 +524,17 @@ static int ovl_copy_up_tmpfile_commit(struct ovl_copy_up_ctx *ctx)
 
 static void ovl_copy_up_tmpfile_cancel(struct ovl_copy_up_ctx *ctx) { }
 
+static void ovl_copy_up_tmpfile_release(struct ovl_copy_up_ctx *ctx)
+{
+	ovl_copy_up_end(ctx->dentry);
+}
+
 static const struct ovl_copy_up_ops ovl_copy_up_tmpfile_ops = {
+	.aquire = ovl_copy_up_tmpfile_aquire,
 	.prepare = ovl_copy_up_tmpfile_prepare,
 	.commit = ovl_copy_up_tmpfile_commit,
 	.cancel = ovl_copy_up_tmpfile_cancel,
+	.release = ovl_copy_up_tmpfile_release,
 };
 
 static int ovl_copy_up_locked(struct ovl_copy_up_ctx *ctx,
@@ -569,6 +611,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		.link = NULL,
 		.tempdir = ovl_workdir(dentry),
 	};
+	const struct ovl_copy_up_ops *ops;
 
 	if (WARN_ON(!ctx.tempdir))
 		return -EROFS;
@@ -595,35 +638,23 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	}
 
 	/* Should we copyup with O_TMPFILE or with workdir? */
-	if (S_ISREG(stat->mode) && ofs->tmpfile) {
-		err = ovl_copy_up_start(dentry);
-		/* err < 0: interrupted, err > 0: raced with another copy-up */
-		if (unlikely(err)) {
-			pr_debug("ovl_copy_up_start(%pd2) = %i\n", dentry, err);
-			if (err > 0)
-				err = 0;
-			goto out_done;
-		}
-
-		err = ovl_copy_up_locked(&ctx, &ovl_copy_up_tmpfile_ops);
-		ovl_copy_up_end(dentry);
+	if (S_ISREG(stat->mode) && ofs->tmpfile)
+		ops = &ovl_copy_up_tmpfile_ops;
+	else
+		ops = &ovl_copy_up_workdir_ops;
+
+	err = ops->aquire(&ctx);
+	/* err < 0: interrupted, err > 0: raced with another copy-up */
+	if (unlikely(err)) {
+		pr_debug("%s(%pd2): aquire = %i\n", __func__, dentry, err);
+		if (err > 0)
+			err = 0;
 		goto out_done;
 	}
 
-	err = -EIO;
-	if (lock_rename(ctx.tempdir, ctx.upperdir) != NULL) {
-		pr_err("overlayfs: failed to lock workdir+upperdir\n");
-		goto out_unlock;
-	}
-	if (ovl_dentry_upper(dentry)) {
-		/* Raced with another copy-up?  Nothing to do, then... */
-		err = 0;
-		goto out_unlock;
-	}
+	err = ovl_copy_up_locked(&ctx, ops);
+	ops->release(&ctx);
 
-	err = ovl_copy_up_locked(&ctx, &ovl_copy_up_workdir_ops);
-out_unlock:
-	unlock_rename(ctx.tempdir, ctx.upperdir);
 out_done:
 	do_delayed_call(&done);
 
-- 
2.7.4
