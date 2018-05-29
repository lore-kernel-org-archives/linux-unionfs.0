From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 11/11] ovl: use inode_insert5() to hash a newly created inode
Date: Tue, 29 May 2018 16:41:43 +0200
Message-ID: <20180529144143.16378-12-mszeredi@redhat.com>
References: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144143.16378-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Amir Goldstein <amir73il@gmail.com>

Currently, there is a small window where ovl_obtain_alias() can
race with ovl_instantiate() and create two different overlay inodes
with the same underlying real non-dir non-hardlink inode.

The race requires an adversary to guess the file handle of the
yet to be created upper inode and decode the guessed file handle
after ovl_creat_real(), but before ovl_instantiate().
This race does not affect overlay directory inodes, because those
are decoded via ovl_lookup_real() and not with ovl_obtain_alias().

This patch fixes the race, by using inode_insert5() to add a newly
created inode to cache.

If the newly created inode apears to already exist in cache (hashed
by the same real upper inode), we instantiate the dentry with the old
inode and drop the new inode, instead of silently not hashing the new
inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/dir.c       | 59 ++++++++++++++++++++++++++++++++++++++++--------
 fs/overlayfs/inode.c     | 12 ++++++++--
 fs/overlayfs/overlayfs.h |  1 +
 3 files changed, 60 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index b33d37d1a87c..b2bc313241a6 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -228,24 +228,54 @@ static int ovl_set_opaque(struct dentry *dentry, struct dentry *upperdentry)
 	return ovl_set_opaque_xerr(dentry, upperdentry, -EIO);
 }
 
-/* Common operations required to be done after creation of file on upper */
-static void ovl_instantiate(struct dentry *dentry, struct inode *inode,
-			    struct dentry *newdentry, bool hardlink)
+/*
+ * Common operations required to be done after creation of file on upper.
+ * If @hardlink is false, then @inode is a pre-allocated inode, we may or
+ * may not use to instantiate the new dentry.
+ */
+static int ovl_instantiate(struct dentry *dentry, struct inode *inode,
+			   struct dentry *newdentry, bool hardlink)
 {
+	struct ovl_inode_params oip = {
+		.upperdentry = newdentry,
+		.newinode = inode,
+	};
+
 	ovl_dentry_version_inc(dentry->d_parent, false);
 	ovl_dentry_set_upper_alias(dentry);
 	if (!hardlink) {
-		ovl_inode_update(inode, newdentry);
-		ovl_copyattr(newdentry->d_inode, inode);
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
+		if (WARN_ON(IS_ERR(inode)))
+			return PTR_ERR(inode);
 	} else {
 		WARN_ON(ovl_inode_real(inode) != d_inode(newdentry));
 		dput(newdentry);
 		inc_nlink(inode);
 	}
+
 	d_instantiate(dentry, inode);
+	if (inode != oip.newinode) {
+		pr_warn_ratelimited("overlayfs: newly created inode found in cache (%pd2)\n",
+				    dentry);
+	}
+
 	/* Force lookup of new upper hardlink to find its lower */
 	if (hardlink)
 		d_drop(dentry);
+
+	return 0;
 }
 
 static bool ovl_type_merge(struct dentry *dentry)
@@ -284,11 +314,17 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
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
@@ -473,8 +509,9 @@ static int ovl_create_over_whiteout(struct dentry *dentry, struct inode *inode,
 		if (err)
 			goto out_cleanup;
 	}
-	ovl_instantiate(dentry, inode, newdentry, hardlink);
-	err = 0;
+	err = ovl_instantiate(dentry, inode, newdentry, hardlink);
+	if (err)
+		goto out_cleanup;
 out_dput:
 	dput(upper);
 out_unlock:
@@ -557,6 +594,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 	if (err)
 		goto out;
 
+	/* Preallocate inode to be used by ovl_get_inode() */
 	err = -ENOMEM;
 	inode = ovl_new_inode(dentry->d_sb, mode, rdev);
 	if (!inode)
@@ -566,7 +604,8 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 	attr.mode = inode->i_mode;
 
 	err = ovl_create_or_link(dentry, inode, &attr, false);
-	if (err)
+	/* Did we end up using the preallocated inode? */
+	if (inode != d_inode(dentry))
 		iput(inode);
 
 out_drop_write:
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 2b9e8370500c..1db5b3b458a1 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -749,6 +749,15 @@ static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
 	return true;
 }
 
+static struct inode *ovl_iget5(struct super_block *sb, struct inode *newinode,
+			       struct inode *key)
+{
+	return newinode ? inode_insert5(newinode, (unsigned long) key,
+					 ovl_inode_test, ovl_inode_set, key) :
+			  iget5_locked(sb, (unsigned long) key,
+				       ovl_inode_test, ovl_inode_set, key);
+}
+
 struct inode *ovl_get_inode(struct super_block *sb,
 			    struct ovl_inode_params *oip)
 {
@@ -776,8 +785,7 @@ struct inode *ovl_get_inode(struct super_block *sb,
 						      upperdentry);
 		unsigned int nlink = is_dir ? 1 : realinode->i_nlink;
 
-		inode = iget5_locked(sb, (unsigned long) key, ovl_inode_test,
-				     ovl_inode_set, key);
+		inode = ovl_iget5(sb, oip->newinode, key);
 		if (!inode)
 			goto out_nomem;
 		if (!(inode->i_state & I_NEW)) {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b8a0160742b2..3c5e9f18b0d9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -329,6 +329,7 @@ int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
 struct ovl_inode_params {
+	struct inode *newinode;
 	struct dentry *upperdentry;
 	struct ovl_path *lowerpath;
 	struct dentry *index;
-- 
2.14.3
