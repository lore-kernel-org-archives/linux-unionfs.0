From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 13/20] ovl: adjust overlay inode nlink for indexed inodes
Date: Wed,  7 Jun 2017 10:51:17 +0300
Message-ID: <1496821884-5178-14-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

If overlay inode has an indexed realinode, decrement 1 nlink for the
index entry.  Overlay inode nlink does not account for all the lower
hardlinks that have not been copied up yet.  Those will be added to nlink
as they get copied up and won't decrement nlink when they get unlinked
or renamed over.

The important thing to take care of is that overlay inode nlink doesn't
drop to zero when there are still upper hardlinks or non covered
lower hardlinks.

An overlay inode zero nlink stands for an orphan indexed inode. This is
the case where some of the lower hardlinks were copied up, modified, and
then all copied up upper hardlinks has been unlinked, but there are still
non covered lower hardlinks.

Return the overlay inode nlinks for indexed upper inodes on stat(2).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c   | 17 +++++++++++++----
 fs/overlayfs/inode.c | 25 ++++++++++++++++++++++++-
 2 files changed, 37 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a60c075f62f6..3bb226ffa552 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -733,9 +733,16 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 	return err;
 }
 
+static bool ovl_type_indexed_lower(struct dentry *dentry)
+{
+	enum ovl_path_type type = ovl_path_type(dentry);
+
+	return !OVL_TYPE_UPPER(type) && OVL_TYPE_INDEX(type);
+}
+
 static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 {
-	enum ovl_path_type type;
+	bool indexed_lower;
 	int err;
 	const struct cred *old_cred;
 
@@ -747,7 +754,8 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	if (err)
 		goto out_drop_write;
 
-	type = ovl_path_type(dentry);
+	/* An indexed lower hardlink is not counted in overlay nlink */
+	indexed_lower = ovl_type_indexed_lower(dentry);
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	if (!ovl_lower_positive(dentry))
@@ -758,7 +766,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	if (!err) {
 		if (is_dir)
 			clear_nlink(dentry->d_inode);
-		else
+		else if (!indexed_lower)
 			drop_nlink(dentry->d_inode);
 	}
 out_drop_write:
@@ -953,7 +961,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			flags |= RENAME_EXCHANGE;
 			cleanup_whiteout = true;
 		}
-		if (!new_is_dir && new->d_inode)
+		/* An indexed lower hardlink is not counted in overlay nlink */
+		if (!new_is_dir && new->d_inode && !ovl_type_indexed_lower(new))
 			new_drop_nlink = true;
 	}
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1f8276d7df32..6e85a2a7fcdc 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -126,6 +126,15 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
 	if (is_dir && OVL_TYPE_MERGE(type))
 		stat->nlink = 1;
 
+	/*
+	 * Return the overlay inode nlinks for indexed upper inodes.
+	 * Overlay nlink accounts for all upper hardlinks excluding the
+	 * index hardlink entry.
+	 * TODO: add count of non-covered lower hardlinks.
+	 */
+	if (!is_dir && OVL_TYPE_UPPER(type) && OVL_TYPE_INDEX(type))
+		stat->nlink = dentry->d_inode->i_nlink;
+
 out:
 	revert_creds(old_cred);
 
@@ -542,6 +551,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct ovl_inode_info *oi)
 {
 	struct inode *realinode = oi->realinode;
 	unsigned long hashval = (unsigned long) realinode;
+	unsigned int nlink = realinode->i_nlink;
 	struct inode *inode;
 
 	/*
@@ -560,12 +570,25 @@ struct inode *ovl_get_inode(struct super_block *sb, struct ovl_inode_info *oi)
 	if (oi->index && d_inode(oi->index)) {
 		WARN_ON(oi->is_upper && d_inode(oi->index) != realinode);
 		realinode = d_inode(oi->index);
+		/*
+		 * Decrement 1 nlink for the index entry. Overlay inode nlink
+		 * does not account for all the lower hardlinks that have not
+		 * been copied up yet. Those will be added to nlink as they get
+		 * copied up and won't decrement nlink when they get unlinked
+		 * or renamed over.
+		 * An overlay inode zero nlink stands for an orphan indexed
+		 * inode - an inode that was copied up, modified, and then the
+		 * copied up alias has been unlinked.
+		 */
+		nlink = realinode->i_nlink;
+		if (!WARN_ON(!nlink))
+			nlink--;
 	}
 
 	inode = iget5_locked(sb, hashval, ovl_inode_test, ovl_inode_set, oi);
 	if (inode && inode->i_state & I_NEW) {
 		ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
-		set_nlink(inode, realinode->i_nlink);
+		set_nlink(inode, nlink);
 		unlock_new_inode(inode);
 	}
 
-- 
2.7.4
