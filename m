From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 25/25] ovl: cleanup orphan index entries
Date: Wed, 21 Jun 2017 19:45:51 +0300
Message-ID: <1498063551-10314-1-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-26-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:33861 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751007AbdFUQpf (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 12:45:35 -0400
Received: by mail-wr0-f194.google.com with SMTP id y25so25740895wrd.1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 09:45:34 -0700 (PDT)
In-Reply-To: <1498048136-28218-26-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

index entry should live only as long as there are upper or lower
hardlinks.

Cleanup orphan index entries on mount and when dropping the last
overlay inode nlink.

When about to cleanup or link up to orphan index and the index inode
nlink > 1, admit that something went wrong and adjust overlay nlink
to index inode nlink - 1 to prevent it from dropping below zero.
This could happen when adding lower hardlinks underneath a mounted
overlay and then trying to unlink them.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/copy_up.c   | 21 ++++++++++++--
 fs/overlayfs/dir.c       | 72 ++++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c     |  4 +--
 fs/overlayfs/namei.c     |  6 ++++
 fs/overlayfs/overlayfs.h |  4 ++-
 fs/overlayfs/super.c     |  2 +-
 6 files changed, 102 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index bbc16880b32d..642957f5bed9 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -622,9 +622,24 @@ static int ovl_copy_up_indexdir_prepare(struct ovl_copy_up_ctx *ctx)
 			 * Orphan index inodes should be cleaned up on mount
 			 * and when overlay inode nlink drops to zero.
 			 */
-			pr_warn_ratelimited("overlayfs: not linking to orphan index (%pd2, nlink=%u)\n",
-					    index, inode->i_nlink);
-			goto out_dput;
+			pr_warn_ratelimited("overlayfs: link-up orphan index (%pd2, ino=%lu, nlink=%u)\n",
+					    index, inode->i_ino,
+					    inode->i_nlink);
+
+			if (inode->i_nlink == 1)
+				goto out_dput;
+
+			/*
+			 * If index is has nlink > 1, then we either have a bug
+			 * with persistent union nlink or a lower hardlink was
+			 * added while overlay is mounted. Adding a lower
+			 * hardlink and then unlinking all overlay hardlinks
+			 * would drop overlay nlink to zero before all upper
+			 * inodes are unlinked. As a safety measure, when that
+			 * situation is detected, set the overlay nlink to the
+			 * index inode nlink minus one for the index entry.
+			 */
+			set_nlink(d_inode(ctx->dentry), inode->i_nlink - 1);
 		}
 
 		/* Link to existing upper without copying lower */
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index c9ba057ccfa3..b4cd8de1ce0c 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -84,6 +84,65 @@ static struct dentry *ovl_whiteout(struct dentry *workdir,
 	return whiteout;
 }
 
+/* Called must hold OVL_I(inode)->oi_lock */
+static int ovl_cleanup_index(struct dentry *dentry)
+{
+	struct inode *dir = ovl_indexdir(dentry->d_sb)->d_inode;
+	struct dentry *lower;
+	struct dentry *index = NULL;
+	struct inode *inode;
+	int err;
+
+	/*
+	 * dentry may already be unhashed, but it still holds a reference to
+	 * the lower/upper dentries from before an unlink operation.
+	 */
+	lower = ovl_dentry_lower(dentry);
+	err = -ESTALE;
+	if (WARN_ON(!lower))
+		goto fail;
+
+	err = ovl_lookup_index(dentry, ovl_dentry_upper(dentry), lower, &index);
+	if (err)
+		goto fail;
+
+	err = -ENOENT;
+	if (WARN_ON(!index || !index->d_inode))
+		goto fail;
+
+	inode = d_inode(index);
+	err = -EEXIST;
+	if (inode->i_nlink != 1) {
+		pr_warn_ratelimited("overlayfs: cleanup linked index (%pd2, ino=%lu, nlink=%u)\n",
+				    index, inode->i_ino, inode->i_nlink);
+		/*
+		 * We either have a bug with persistent union nlink or a lower
+		 * hardlink was added while overlay is mounted. Adding a lower
+		 * hardlink and then unlinking all overlay hardlinks would drop
+		 * overlay nlink to zero before all upper inodes are unlinked.
+		 * As a safety measure, when that situation is detected, set
+		 * the overlay nlink to the index inode nlink minus one for the
+		 * index entry itself.
+		 */
+		set_nlink(d_inode(dentry), inode->i_nlink - 1);
+		ovl_set_nlink(d_inode(dentry), index, true);
+		goto fail;
+	}
+
+	inode_lock_nested(dir, I_MUTEX_PARENT);
+	/* TODO: whiteout instead of cleanup to block future open by handle */
+	err = ovl_cleanup(dir, index);
+	inode_unlock(dir);
+
+out:
+	dput(index);
+	return err;
+
+fail:
+	pr_err("overlayfs: cleanup index of '%pd2' failed (%i)\n", dentry, err);
+	goto out;
+}
+
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct cattr *attr, struct dentry *hardlink, bool debug)
 {
@@ -641,6 +700,17 @@ static int ovl_nlink_start(struct dentry *dentry)
 
 static void ovl_nlink_end(struct dentry *dentry)
 {
+	enum ovl_path_type type = ovl_path_type(dentry);
+
+	/* Unlink the index inode on last overlay inode unlink */
+	if (OVL_TYPE_INDEX(type) && d_inode(dentry)->i_nlink == 0) {
+		const struct cred *old_cred;
+
+		old_cred = ovl_override_creds(dentry->d_sb);
+		ovl_cleanup_index(dentry);
+		revert_creds(old_cred);
+	}
+
 	mutex_unlock(&OVL_I(d_inode(dentry))->oi_lock);
 }
 
@@ -1137,6 +1207,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	revert_creds(old_cred);
 	/*
 	 * Release oi_lock after rename lock.
+	 * Orphan index cleanup may need to aquire index dir mutex, which is
+	 * the same lockdep class/fstype as the upper dir rename lock.
 	 */
 	if (new_drop_nlink)
 		ovl_nlink_end(new);
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b83d7e387a02..d21e4450b5a9 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -508,8 +508,8 @@ int ovl_set_nlink(struct inode *inode, struct dentry *index, bool add_upper)
 			       &onlink, sizeof(onlink), 0);
 }
 
-static unsigned int ovl_get_nlink(struct ovl_inode_info *info,
-				  struct dentry *index, unsigned int real_nlink)
+unsigned int ovl_get_nlink(struct ovl_inode_info *info, struct dentry *index,
+			   unsigned int real_nlink)
 {
 	struct ovl_nlink onlink;
 	__s32 nlink_add = 0;
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 5ff5f82f6503..aef123a441dd 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -393,6 +393,7 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 	struct path origin = { };
 	struct path *stack = &origin;
 	unsigned int ctr = 0;
+	struct ovl_inode_info info = { };
 	int err;
 
 	if (!d_inode(index))
@@ -426,6 +427,11 @@ int ovl_verify_index(struct dentry *index, struct path *lowerstack,
 	if (err)
 		goto fail;
 
+	/* Check if index is orphan and don't warn before cleaning it */
+	info.lowerinode = d_inode(origin.dentry);
+	if (ovl_get_nlink(&info, index, 0) == 0)
+		err = -ENOENT;
+
 	dput(origin.dentry);
 out:
 	kfree(fh);
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 82c1d51b7b63..89eea7954420 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -271,9 +271,11 @@ int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
+struct ovl_inode_info;
 int ovl_set_nlink(struct inode *inode, struct dentry *index, bool add_upper);
+unsigned int ovl_get_nlink(struct ovl_inode_info *info, struct dentry *index,
+			   unsigned int real_nlink);
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
-struct ovl_inode_info;
 struct inode *ovl_get_inode(struct super_block *sb, struct ovl_inode_info *info,
 			    struct dentry *index);
 
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index d6604bbe0a66..793667f47a04 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -1108,7 +1108,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 			if (err)
 				pr_err("overlayfs: failed to verify index dir origin\n");
 
-			/* Cleanup bad/stale index entries */
+			/* Cleanup bad/stale/orphan index entries */
 			if (!err)
 				err = ovl_indexdir_cleanup(ufs->indexdir,
 							   ufs->upper_mnt,
-- 
2.7.4
