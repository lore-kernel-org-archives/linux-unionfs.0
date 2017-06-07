From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 19/20] ovl: handle race of concurrent lower hardlinks copy up
Date: Wed,  7 Jun 2017 10:51:23 +0300
Message-ID: <1496821884-5178-20-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36687 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751550AbdFGHvs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:51:48 -0400
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Make sure that task B does not link to an index inode created by
task A, before task A completed copying the inode data.
Task A marks the index inode 'inuse' and task B waits for 'inuse' flag
to be cleared.  Take care of the race between task A canceling the
copy up and unlinking the index inode and task B trying to link to it.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 85 ++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 69 insertions(+), 16 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index f08220c82c77..f8acf9c8b345 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -552,16 +552,30 @@ static const struct ovl_copy_up_ops ovl_copy_up_tmpfile_ops = {
  */
 static int ovl_copy_up_indexdir_aquire(struct ovl_copy_up_ctx *ctx)
 {
-	/* TODO: handle race of concurrent lower hardlinks copy up */
 	return ovl_copy_up_start(ctx->dentry);
 }
 
+/*
+ * Set ctx->temp to a positive dentry with the index inode.
+ *
+ * Return 0 if entry was created by us, in which case, we also got
+ * inode_inuse lock and we will release it on copy_up_commit after
+ * copying the inode data.
+ *
+ * Return 1 if we found an index inode, in which case, we do not need
+ * to copy the inode data.
+ *
+ * May return -EEXISTS/-ENOENT/-EBUSY on various races of concurrent
+ * lower hardlinks copy up on the same lower inode.
+ */
 static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 {
+	struct inode *dir = d_inode(ctx->tempdir);
 	struct dentry *upper;
 	struct dentry *index;
 	struct inode *inode;
 	int err;
+	bool retried = false;
 	struct cattr cattr = {
 		/* Can't properly set mode on creation because of the umask */
 		.mode = ctx->stat->mode & S_IFMT,
@@ -576,6 +590,7 @@ static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 
 	index = dget(ovl_dentry_index(ctx->dentry));
 	BUG_ON(!index);
+retry:
 	inode = d_inode(index);
 	if (inode) {
 		/* Another lower hardlink already copied-up? */
@@ -583,18 +598,32 @@ static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 		if ((inode->i_mode & S_IFMT) != cattr.mode)
 			goto out_dput;
 
-		err = -ENOENT;
+		/*
+		 * We need to be carefull not to link with a copy in-progress
+		 * index inode. Testing 'inuse' bit with indexdir i_mutex held
+		 * protect us from the time of creating the index entry below
+		 * to the time of ovl_copy_up_indexdir_commit. We also need to
+		 * test i_nlink with indexdir i_mutex held to make sure that
+		 * index has not been unlinked by ovl_copy_up_indexdir_cancel,
+		 * right after clearing 'inuse' bit.
+		 */
+		inode_lock_nested(dir, I_MUTEX_PARENT);
 		if (!inode->i_nlink)
+			err = -ENOENT;
+		else
+			err = wait_on_inode_inuse(inode, TASK_KILLABLE);
+		inode_unlock(dir);
+		if (err)
 			goto out_dput;
 
 		/*
 		 * Verify that found index is a copy up of lower inode.
 		 * If index inode doesn't point back to lower inode via
-		 * origin file handle, then this is either an in-progress
-		 * copy up or leftover from index dir before copying layers.
+		 * origin file handle, then this is either a leftover from
+		 * failed copy up or an index dir entry before copying layers.
 		 * In both cases, we cannot use this index and must fail the
-		 * copy up. The in-progress case will return -EEXISTS and the
-		 * leftover case will return -ESTALE.
+		 * copy up. The failed copy up case will return -EEXISTS and
+		 * the copying layers case will return -ESTALE.
 		 */
 		err = ovl_verify_origin(index, ctx->lowerpath->mnt,
 					ctx->lowerpath->dentry, false);
@@ -630,11 +659,29 @@ static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 		goto out;
 	}
 
-	inode_lock_nested(d_inode(ctx->tempdir), I_MUTEX_PARENT);
-	err = ovl_create_real(d_inode(ctx->tempdir), index, &cattr, NULL, true);
+	/* Raced on creating index and not found on retry? */
+	err = -ENOENT;
+	if (retried)
+		goto out_dput;
+
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+	err = ovl_create_real(dir, index, &cattr, NULL, true);
 	if (!err)
 		ctx->created = true;
-	inode_unlock(d_inode(ctx->tempdir));
+	/*
+	 * Mark index inode 'inuse' before copying inode data to avoid racing
+	 * with copy up of another lower hardlink of the same lower inode.
+	 */
+	if (!err && !inode_inuse_trylock(index->d_inode))
+		err = -EBUSY;
+	inode_unlock(dir);
+
+	/* Raced with copy up of another lower hardlink of the same inode? */
+	if (err == -EEXIST) {
+		retried = true;
+		goto retry;
+	}
+
 	if (err)
 		goto out_dput;
 
@@ -679,6 +726,10 @@ static int ovl_copy_up_indexdir_commit(struct ovl_copy_up_ctx *ctx)
 	}
 	inode_unlock(d_inode(ctx->upperdir));
 
+	/* Allow other lower hardlinks to link with our creation */
+	if (ctx->created)
+		inode_inuse_unlock(d_inode(ctx->temp));
+
 	return err;
 }
 
@@ -696,18 +747,20 @@ static int ovl_copy_up_indexdir_cancel(struct ovl_copy_up_ctx *ctx)
 	inode_lock_nested(d_inode(ctx->tempdir), I_MUTEX_PARENT);
 
 	/*
-	 * We must not cleanup an already hardlinked index.
+	 * We must clear 'inuse' flag before unlink, but we need to take care
+	 * because this could allow another copy up to race with this cleanup,
+	 * find the unborn index inode that looks like an orphan and link it,
+	 * before we unlink the unborn index entry. So before linking an index
+	 * inode we must take indexdir i_mutex, wait for 'inuse' flag to be
+	 * cleared and test that inode i_nlink is positive.
 	 */
-	if (inode->i_nlink != 1)
-		goto out_unlock;
-
-	pr_warn_ratelimited("overlayfs: cleanup bad index (%pd2, ino=%lu)\n",
-			    ctx->temp, inode->i_ino);
+	inode_inuse_unlock(inode);
+	pr_warn_ratelimited("overlayfs: cleanup bad index (%pd2, ino=%lu, nlink=%u)\n",
+			    ctx->temp, inode->i_ino, inode->i_nlink);
 	ovl_cleanup(d_inode(ctx->tempdir), ctx->temp);
 	/* Bad index inode is still cached in overlay dentry */
 	d_drop(ctx->dentry);
 
-out_unlock:
 	inode_unlock(d_inode(ctx->tempdir));
 	return 0;
 }
-- 
2.7.4
