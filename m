From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/6] ovl: check if clone from lower to upper is supported
Date: Wed, 29 Mar 2017 17:36:04 +0300
Message-ID: <1490798166-22310-5-git-send-email-amir73il@gmail.com>
References: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34803 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751843AbdC2OgI (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 29 Mar 2017 10:36:08 -0400
Received: by mail-wr0-f194.google.com with SMTP id w43so3559874wrb.1
        for <linux-unionfs@vger.kernel.org>; Wed, 29 Mar 2017 07:36:06 -0700 (PDT)
In-Reply-To: <1490798166-22310-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Currently copy up will always try to clone and fall back
to copy if clone fails.

Check clone support during mount time and don't try to clone
up if clone is not supported.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 23 ++++++++++++++---------
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 11 ++++++++---
 3 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 906ea6c..3053e33 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -134,7 +134,8 @@ int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 	return error;
 }
 
-static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
+static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len,
+			    bool cloneup)
 {
 	struct file *old_file;
 	struct file *new_file;
@@ -155,12 +156,15 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 		goto out_fput;
 	}
 
-	/* Try to use clone_file_range to clone up within the same fs */
-	error = vfs_clone_file_range(old_file, 0, new_file, 0, len);
-	if (!error)
-		goto out;
-	/* Couldn't clone, so now we try to copy the data */
-	error = 0;
+	if (cloneup) {
+		/* Try to use clone_file_range to clone up within the same fs */
+		error = vfs_clone_file_range(old_file, 0, new_file, 0, len);
+		if (!error)
+			goto out;
+
+		/* Couldn't clone, so now we try to copy the data */
+		error = 0;
+	}
 
 	/* FIXME: copy up sparse files efficiently */
 	while (len) {
@@ -251,6 +255,7 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 		.rdev = stat->rdev,
 		.link = link
 	};
+	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
 
 	upper = lookup_one_len(dentry->d_name.name, upperdir,
 			       dentry->d_name.len);
@@ -295,11 +300,11 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
 		if (tmpfile) {
 			inode_unlock(udir);
 			err = ovl_copy_up_data(lowerpath, &upperpath,
-					       stat->size);
+					       stat->size, ofs->cloneup);
 			inode_lock_nested(udir, I_MUTEX_PARENT);
 		} else {
 			err = ovl_copy_up_data(lowerpath, &upperpath,
-					       stat->size);
+					       stat->size, ofs->cloneup);
 		}
 
 		if (err)
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 0e159c3..fb1210d 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -29,6 +29,7 @@ struct ovl_fs {
 	const struct cred *creator_cred;
 	bool tmpfile;	/* upper supports O_TMPFILE */
 	bool samefs;	/* all layers on same fs */
+	bool cloneup;	/* can clone from lower to upper */
 	wait_queue_head_t copyup_wq;
 };
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index b8a83e8..75b93d6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -865,10 +865,15 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			/* Check if upper/work fs supports O_TMPFILE */
 			temp = ovl_do_tmpfile(ufs->workdir, S_IFREG | 0);
 			ufs->tmpfile = !IS_ERR(temp);
-			if (ufs->tmpfile)
+			if (ufs->tmpfile) {
+				/* Check if upper/work supports clone */
+				if (temp->d_inode && temp->d_inode->i_fop &&
+				    temp->d_inode->i_fop->clone_file_range)
+					ufs->cloneup = true;
 				dput(temp);
-			else
+			} else {
 				pr_warn("overlayfs: upper fs does not support tmpfile.\n");
+			}
 		}
 	}
 
@@ -898,7 +903,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 		/* Check if all layers on same sb */
 		if ((ufs->upper_mnt && ufs->upper_mnt->mnt_sb != mnt->mnt_sb) ||
 		    (i > 0 && ufs->lower_mnt[0]->mnt_sb != mnt->mnt_sb))
-			ufs->samefs = false;
+			ufs->cloneup = ufs->samefs = false;
 	}
 
 	/* If the upper fs is nonexistent, we mark overlayfs r/o too */
-- 
2.7.4
