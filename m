From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 17/17] ovl: handle race of concurrent lower hardlinks copy up
Date: Fri,  2 Jun 2017 17:04:44 +0300
Message-ID: <1496412284-4113-18-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:36295 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751220AbdFBOE5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:57 -0400
Received: by mail-wr0-f196.google.com with SMTP id e23so173112wre.3
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:56 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Make sure that task B does not link to an index inode created by
task A, before task A completed copying the inode data.
Task A marks the index inode 'inuse' and task B waits for 'inuse' flag
to be cleared.  Take care of the race between task A canceling the
copy up and unlinking the index inode and task B trying to link to it.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c | 93 ++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 83 insertions(+), 10 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 59ea4c365b7a..69a581d3d609 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -372,6 +372,7 @@ struct ovl_copy_up_ctx {
 	struct dentry *tempdir;
 	struct dentry *upper;
 	struct dentry *temp;
+	bool created;
 };
 
 struct ovl_copy_up_ops {
@@ -557,16 +558,30 @@ static const struct ovl_copy_up_ops ovl_copy_up_tmpfile_ops = {
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
 	struct dentry *temp;
 	struct inode *inode;
 	int err;
+	bool retried = false;
 	struct cattr cattr = {
 		/* Can't properly set mode on creation because of the umask */
 		.mode = ctx->stat->mode & S_IFMT,
@@ -579,6 +594,7 @@ static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 	if (IS_ERR(upper))
 		return PTR_ERR(upper);
 
+retry:
 	temp = ovl_lookup_index(ctx->dentry->d_sb, ctx->lowerpath->dentry);
 	if (IS_ERR(temp)) {
 		err = PTR_ERR(temp);
@@ -593,13 +609,31 @@ static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 			goto out_dput_temp;
 
 		/*
+		 * We need to be carefull not to link with a copy in-progress
+		 * index inode. Testing 'inuse' bit with indexdir i_mutex held
+		 * protect us from the time of creating the index entry below
+		 * to the time of ovl_copy_up_indexdir_commit. We also need to
+		 * test i_nlink with indexdir i_mutex held to make sure that
+		 * index has not been unlinked by ovl_copy_up_indexdir_cancel,
+		 * right after clearing 'inuse' bit.
+		 */
+		inode_lock_nested(dir, I_MUTEX_PARENT);
+		if (inode->i_nlink < 1)
+			err = -ENOENT;
+		else
+			err = wait_on_inode_inuse(inode, TASK_KILLABLE);
+		inode_unlock(dir);
+		if (err)
+			goto out_dput_temp;
+
+		/*
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
 		err = ovl_verify_origin(temp, ctx->lowerpath->mnt,
 					ctx->lowerpath->dentry, false);
@@ -628,12 +662,32 @@ static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 		goto out;
 	}
 
-	inode_lock_nested(d_inode(ctx->tempdir), I_MUTEX_PARENT);
-	err = ovl_create_real(d_inode(ctx->tempdir), temp, &cattr, NULL, true);
-	inode_unlock(d_inode(ctx->tempdir));
+	/* Raced on creating index and not found on retry? */
+	err = -ENOENT;
+	if (retried)
+		goto out_dput_temp;
+
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+	err = ovl_create_real(dir, temp, &cattr, NULL, true);
+	/*
+	 * Mark index inode 'inuse' before copying inode data to avoid racing
+	 * with copy up of another lower hardlink of the same lower inode.
+	 */
+	if (!err && !inode_inuse_trylock(temp->d_inode))
+		err = -EBUSY;
+	inode_unlock(dir);
+
+	/* Raced with copy up of another lower hardlink of the same inode? */
+	if (err == -EEXIST) {
+		retried = true;
+		dput(temp);
+		goto retry;
+	}
+
 	if (err)
 		goto out_dput_temp;
 
+	ctx->created = true;
 out:
 	ctx->upper = upper;
 	ctx->temp = temp;
@@ -661,6 +715,10 @@ static int ovl_copy_up_indexdir_commit(struct ovl_copy_up_ctx *ctx)
 		ovl_set_timestamps(ctx->upperdir, &ctx->pstat);
 	inode_unlock(d_inode(ctx->upperdir));
 
+	/* Allow other lower hardlinks to link with our creation */
+	if (ctx->created)
+		inode_inuse_unlock(d_inode(ctx->temp));
+
 	return err;
 }
 
@@ -671,13 +729,28 @@ static int ovl_copy_up_indexdir_cancel(struct ovl_copy_up_ctx *ctx)
 	if (WARN_ON(!inode))
 		return 0;
 
+	/* Cleanup prepared index entry only if we created it */
+	if (!ctx->created)
+		return 0;
+
 	inode_lock_nested(d_inode(ctx->tempdir), I_MUTEX_PARENT);
 
+	if (WARN_ON(!inode->i_nlink))
+		goto out_unlock;
+
+	inode_inuse_unlock(inode);
+
 	/*
-	 * We must not cleanup an already hardlinked index.
+	 * We must clear 'inuse' flag before unlink, but we need to take care
+	 * because this could allow another copy up to race with this cleanup,
+	 * find the unborn index inode that looks like an orphan and link it,
+	 * before we unlink the unborn index entry. So before linking an index
+	 * inode we must take indexdir i_mutex, wait for 'inuse' flag to be
+	 * cleared and test that inode i_nlink > 0.
 	 */
 	if (inode->i_nlink != 1)
-		goto out_unlock;
+		pr_warn("overlayfs: cleanup of linked upper (%pd2, ino=%lu, nlink=%u)\n",
+			ctx->temp, inode->i_ino, inode->i_nlink);
 
 	ovl_cleanup(d_inode(ctx->tempdir), ctx->temp);
 
-- 
2.7.4
