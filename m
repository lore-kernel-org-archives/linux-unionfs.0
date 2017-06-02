From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 15/17] ovl: generalize ovl_copy_up_one() using actors
Date: Fri,  2 Jun 2017 17:04:42 +0300
Message-ID: <1496412284-4113-16-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33293 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdFBOEy (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:54 -0400
Received: by mail-wr0-f193.google.com with SMTP id v104so1345513wrb.0
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:54 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
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
 fs/overlayfs/copy_up.c | 59 ++++++++++++++++++++++++++++----------------------
 1 file changed, 33 insertions(+), 26 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index d3b922bcd983..5031dd7fef89 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -387,7 +387,23 @@ struct ovl_copy_up_ops {
  */
 static int ovl_copy_up_workdir_aquire(struct ovl_copy_up_ctx *ctx)
 {
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
 	return 0;
+
+out_unlock:
+	unlock_rename(ctx->tempdir, ctx->upperdir);
+	return err;
 }
 
 static int ovl_copy_up_workdir_prepare(struct ovl_copy_up_ctx *ctx)
@@ -457,6 +473,7 @@ static int ovl_copy_up_workdir_cancel(struct ovl_copy_up_ctx *ctx)
 
 static int ovl_copy_up_workdir_release(struct ovl_copy_up_ctx *ctx)
 {
+	unlock_rename(ctx->tempdir, ctx->upperdir);
 	return 0;
 }
 
@@ -474,7 +491,7 @@ static const struct ovl_copy_up_ops ovl_copy_up_workdir_ops = {
  */
 static int ovl_copy_up_tmpfile_aquire(struct ovl_copy_up_ctx *ctx)
 {
-	return 0;
+	return ovl_copy_up_start(ctx->dentry);
 }
 
 static int ovl_copy_up_tmpfile_prepare(struct ovl_copy_up_ctx *ctx)
@@ -520,6 +537,7 @@ static int ovl_copy_up_tmpfile_cancel(struct ovl_copy_up_ctx *ctx)
 
 static int ovl_copy_up_tmpfile_release(struct ovl_copy_up_ctx *ctx)
 {
+	ovl_copy_up_end(ctx->dentry);
 	return 0;
 }
 
@@ -605,6 +623,7 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 		.link = NULL,
 		.tempdir = ovl_workdir(dentry),
 	};
+	const struct ovl_copy_up_ops *ops;
 
 	if (WARN_ON(!ctx.tempdir))
 		return -EROFS;
@@ -631,35 +650,23 @@ static int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
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
