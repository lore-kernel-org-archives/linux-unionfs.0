From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 01/11] ovl: fix EIO from lookup of non-indexed upper
Date: Tue, 17 Oct 2017 19:00:12 +0300
Message-ID: <1508256022-10267-2-git-send-email-amir73il@gmail.com>
References: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Sender: stable-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, "# v4 . 13" <stable@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

Commit fbaf94ee3cd5 ("ovl: don't set origin on broken lower hardlink")
attempt to avoid the condition of non-indexed upper inode with lower
hardlink as origin. If this condition is found, lookup returns EIO.

The protection of commit mentioned above does not cover the case of lower
that is not a hardlink when it is copied up (with either index=off/on)
and then lower is hardlinked while overlay is offline.

Changes to lower layer while overlayfs is offline should not result in
unexpected behavior, so a permanent EIO error after creating a link in
lower layer should not be considered as correct behavior.

This fix replaces EIO error with a warning in cases where upper has
origin but no index is found, or index is found that does not match upper
inode. In those cases, lookup will not fail and the returned overlay
inode will be hashed by upper inode instead of by lower origin inode.

Fixes: 359f392ca53e ("ovl: lookup index entry for copy up origin")
Cc: <stable@vger.kernel.org> # v4.13
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 20 ++++++++++++++++----
 fs/overlayfs/namei.c     | 26 ++++++++++++++++----------
 fs/overlayfs/overlayfs.h |  3 ++-
 3 files changed, 34 insertions(+), 15 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a619addecafc..321511ed8c42 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -598,18 +598,30 @@ static bool ovl_verify_inode(struct inode *inode, struct dentry *lowerdentry,
 	return true;
 }
 
-struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry)
+struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
+			    struct dentry *index)
 {
 	struct dentry *lowerdentry = ovl_dentry_lower(dentry);
 	struct inode *realinode = upperdentry ? d_inode(upperdentry) : NULL;
 	struct inode *inode;
+	/* Already indexed or could be indexed on copy up? */
+	bool indexed = (index || (ovl_indexdir(dentry->d_sb) && !upperdentry));
+
+	if (WARN_ON(upperdentry && indexed && !lowerdentry))
+		return ERR_PTR(-EIO);
 
 	if (!realinode)
 		realinode = d_inode(lowerdentry);
 
-	if (!S_ISDIR(realinode->i_mode) &&
-	    (upperdentry || (lowerdentry && ovl_indexdir(dentry->d_sb)))) {
-		struct inode *key = d_inode(lowerdentry ?: upperdentry);
+	/*
+	 * Copy up origin (lower) may exist for non-indexed upper, but we must
+	 * not use lower as hash key in that case.
+	 * Hash inodes that are or could be indexed by origin inode and
+	 * non-indexed upper inodes that could be hard linked by upper inode.
+	 */
+	if (!S_ISDIR(realinode->i_mode) && (upperdentry || indexed)) {
+		struct inode *key = d_inode(indexed ? lowerdentry :
+						      upperdentry);
 		unsigned int nlink;
 
 		inode = iget5_locked(dentry->d_sb, (unsigned long) key,
diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 5de7aa60a7a6..6a8e0156d40d 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -519,6 +519,10 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 	index = lookup_one_len_unlocked(name.name, ofs->indexdir, name.len);
 	if (IS_ERR(index)) {
 		err = PTR_ERR(index);
+		if (err == -ENOENT) {
+			index = NULL;
+			goto out;
+		}
 		pr_warn_ratelimited("overlayfs: failed inode index lookup (ino=%lu, key=%*s, err=%i);\n"
 				    "overlayfs: mount with '-o index=off' to disable inodes index.\n",
 				    d_inode(origin)->i_ino, name.len, name.name,
@@ -529,17 +533,14 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 	inode = d_inode(index);
 	if (d_is_negative(index)) {
 		if (upper && d_inode(origin)->i_nlink > 1) {
-			pr_warn_ratelimited("overlayfs: hard link with origin but no index (ino=%lu).\n",
-					    d_inode(origin)->i_ino);
-			goto fail;
+			pr_warn_ratelimited("overlayfs: hard link with origin but no index (%pd2).\n",
+					    upper);
 		}
-
-		dput(index);
-		index = NULL;
+		goto out_dput;
 	} else if (upper && d_inode(upper) != inode) {
-		pr_warn_ratelimited("overlayfs: wrong index found (index=%pd2, ino=%lu, upper ino=%lu).\n",
-				    index, inode->i_ino, d_inode(upper)->i_ino);
-		goto fail;
+		pr_warn_ratelimited("overlayfs: broken hard link - ignoring index (%pd2).\n",
+				    upper);
+		goto out_dput;
 	} else if (ovl_dentry_weird(index) || ovl_is_whiteout(index) ||
 		   ((inode->i_mode ^ d_inode(origin)->i_mode) & S_IFMT)) {
 		/*
@@ -559,6 +560,11 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 	kfree(name.name);
 	return index;
 
+out_dput:
+	dput(index);
+	index = NULL;
+	goto out;
+
 fail:
 	dput(index);
 	index = ERR_PTR(-EIO);
@@ -755,7 +761,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		upperdentry = dget(index);
 
 	if (upperdentry || ctr) {
-		inode = ovl_get_inode(dentry, upperdentry);
+		inode = ovl_get_inode(dentry, upperdentry, index);
 		err = PTR_ERR(inode);
 		if (IS_ERR(inode))
 			goto out_free_oe;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index ba455642152f..df605368700d 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -288,7 +288,8 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
-struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry);
+struct inode *ovl_get_inode(struct dentry *dentry, struct dentry *upperdentry,
+			    struct dentry *index);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
 	to->i_uid = from->i_uid;
-- 
2.7.4
