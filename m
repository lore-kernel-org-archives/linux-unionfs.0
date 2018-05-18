Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 9/9] ovl: use iget5_prealloc() to hash a newly created inode
Date: Fri, 18 May 2018 11:29:37 +0300
Message-Id: <1526632177-28832-10-git-send-email-amir73il@gmail.com>
In-Reply-To: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
References: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Currently, there is a small window where ovl_obtain_alias() can
race with ovl_instantiate() and create two different overlay inodes
with the same underlying real non-dir non-hardlink inode.

The race requires an adversary to guess the file handle of the
yet to be created upper inode and decode the guessed file handle
after ovl_creat_real(), but before ovl_instantiate().
This race does not affect overlay directory inodes, because those
are decoded via ovl_lookup_real() and not with ovl_obtain_alias().

This patch fixes the race, by using iget5_prealloc() to add a newly
created inode to cache.

If the newly created inode apears to already exist in cache (hashed
by the same real upper inode), we instantiate the dentry with the old
inode and drop the new inode, instead of silently not hashing the new
inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 81 +++++++++++++++++++++++++++++++++++-------------
 fs/overlayfs/inode.c     | 12 +++++--
 fs/overlayfs/overlayfs.h |  1 +
 3 files changed, 70 insertions(+), 24 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 6f7400be3fc8..833528d3e351 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -217,24 +217,57 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
 	return ovl_set_opaque_xerr(dentry, upperdentry, -EIO);
 }
 
-/* Common operations required to be done after creation of file on upper */
-static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
-			    struct dentry *newdentry, bool hardlink)
+/*
+ * Common operations required to be done after creation of file on upper.
+ * If @hardlink is false, then @inode is a pre-allocated inode, not yet on
+ * overlay's inode_sb_list.  If @newdentry is instantiated with @inode it
+ * takes a reference on @inode.
+ */
+static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
+			   struct dentry *newdentry, bool hardlink)
 {
+	struct ovl_inode_params oip = {
+		.upperdentry = newdentry,
+		.newinode = inode,
+	};
+
 	ovl_dir_modified(dentry->d_parent, false);
-	ovl_copyattr(d_inode(newdentry), inode);
 	ovl_dentry_set_upper_alias(dentry);
 	if (!hardlink) {
-		ovl_inode_update(inode, newdentry);
+		/*
+		 * ovl_obtain_alias() can be called after ovl_create_real()
+		 * and before we get here, so we may get an inode from cache
+		 * with the same real upperdentry that is not the inode we
+		 * pre-allocated.  In this case we will use the cached inode
+		 * to instantiate the new dentry.
+		 *
+		 * XXX: if we ever use ovl_obtain_alias() to decode directory
+		 * file handles, need to use ovl_get_inode_locked() and
+		 * d_instantiate_new() here to prevent from creating two
+		 * hashed directory inode aliases.
+		 */
+		inode = ovl_get_inode(dentry->d_sb, &oip);
+		if (IS_ERR(inode))
+			return PTR_ERR(inode);
 	} else {
 		WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
 		dput(newdentry);
 		inc_nlink(inode);
 	}
+
+	ihold(inode);
 	d_instantiate(dentry, inode);
+	if (inode != oip.newinode) {
+		pr_warn_ratelimited("overlayfs: newly created inode found in cache (%pd2)\n",
+				    dentry);
+		iput(inode);
+	}
+
 	/* Force lookup of new upper hardlink to find its lower */
 	if (hardlink)
 		d_drop(dentry);
+
+	return 0;
 }
 
 static bool ovl_type_merge(struct dentry *dentry)
@@ -273,11 +306,17 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 		ovl_set_opaque(dentry, newdentry);
 	}
 
-	ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink);
-	err = 0;
+	err = ovl_instantiate(dentry, inode, newdentry, !!attr->hardlink);
+	if (err)
+		goto out_cleanup;
 out_unlock:
 	inode_unlock(udir);
 	return err;
+
+out_cleanup:
+	ovl_cleanup(udir, newdentry);
+	dput(newdentry);
+	goto out_unlock;
 }
 
 static struct dentry *ovl_clear_empty(struct dentry *dentry,
@@ -462,10 +501,9 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		if (err)
 			goto out_cleanup;
 	}
-	ovl_instantiate(dentry, inode, newdentry, hardlink);
-	newdentry = NULL;
-out_dput2:
-	dput(newdentry);
+	err = ovl_instantiate(dentry, inode, newdentry, hardlink);
+	if (err)
+		goto out_cleanup;
 out_dput:
 	dput(upper);
 out_unlock:
@@ -479,7 +517,8 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 
 out_cleanup:
 	ovl_cleanup(wdir, newdentry);
-	goto out_dput2;
+	dput(newdentry);
+	goto out_dput;
 }
 
 static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
@@ -547,8 +586,9 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 	if (err)
 		goto out;
 
+	/* Preallocate inode to be used by ovl_get_inode() */
 	err = -ENOMEM;
-	inode = ovl_new_inode(dentry->d_sb, mode, rdev);
+	inode = alloc_inode(dentry->d_sb);
 	if (!inode)
 		goto out_drop_write;
 
@@ -556,9 +596,12 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 	attr.mode = inode->i_mode;
 
 	err = ovl_create_or_link(dentry, inode, &attr, false);
-	if (err)
-		iput(inode);
 
+	/* Did we ended up using the preallocated inode? */
+	if (inode == d_inode(dentry))
+		iput(inode);
+	else
+		destroy_inode(inode);
 out_drop_write:
 	ovl_drop_write(dentry);
 out:
@@ -597,7 +640,6 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 {
 	int err;
 	bool locked = false;
-	struct inode *inode;
 
 	err = ovl_want_write(old);
 	if (err)
@@ -611,14 +653,9 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	if (err)
 		goto out_drop_write;
 
-	inode = d_inode(old);
-	ihold(inode);
-
-	err = ovl_create_or_link(new, inode,
+	err = ovl_create_or_link(new, d_inode(old),
 			&(struct ovl_cattr) {.hardlink = ovl_dentry_upper(old)},
 			ovl_type_origin(old));
-	if (err)
-		iput(inode);
 
 	ovl_nlink_end(old, locked);
 out_drop_write:
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3aa2ea447436..5d017ea06ea1 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -792,6 +792,15 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 	return true;
 }
 
+static struct inode *ovl_iget5(struct super_block *sb, struct inode *newinode,
+			       struct inode *key)
+{
+	return newinode ? iget5_prealloc(newinode, (unsigned long) key,
+					 ovl_inode_test, ovl_inode_set, key) :
+			  iget5_locked(sb, (unsigned long) key,
+				       ovl_inode_test, ovl_inode_set, key);
+}
+
 struct inode *ovl_get_inode(struct super_block *sb,
 			    struct ovl_inode_params *oip)
 {
@@ -819,8 +828,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 						      upperdentry);
 		unsigned int nlink = is_dir ? 1 : realinode->i_nlink;
 
-		inode = iget5_locked(sb, (unsigned long) key, ovl_inode_test,
-				     ovl_inode_set, key);
+		inode = ovl_iget5(sb, oip->newinode, key);
 		if (!inode)
 			goto out_nomem;
 		if (!(inode->i_state & I_NEW)) {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index dfb25b9b26a8..330dc0467f40 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -335,6 +335,7 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct ovl_inode_params {
+	struct inode *newinode;
 	struct dentry *upperdentry;
 	struct ovl_path *lowerpath;
 	struct dentry *index;
-- 
2.7.4
