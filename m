Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] ovl: remove the 'locked' argument of ovl_nlink_{start,end}
Date: Thu, 18 Oct 2018 18:37:13 +0300
Message-Id: <20181018153714.3834-2-amir73il@gmail.com>
In-Reply-To: <20181018153714.3834-1-amir73il@gmail.com>
References: <20181018153714.3834-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

It just makes the interface strange without adding any significant value.
The only case where locked is false and return value is 0 is in
ovl_rename() when new is negative, so handle that case explicitly in
ovl_rename().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 21 +++++++++++----------
 fs/overlayfs/overlayfs.h |  4 ++--
 fs/overlayfs/util.c      | 28 ++++++++++++----------------
 3 files changed, 25 insertions(+), 28 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index e1a55ecb7aba..e03f39550ccf 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -652,7 +652,6 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 		    struct dentry *new)
 {
 	int err;
-	bool locked = false;
 	struct inode *inode;
 
 	err = ovl_want_write(old);
@@ -673,7 +672,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 			goto out_drop_write;
 	}
 
-	err = ovl_nlink_start(old, &locked);
+	err = ovl_nlink_start(old);
 	if (err)
 		goto out_drop_write;
 
@@ -686,7 +685,7 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	if (err)
 		iput(inode);
 
-	ovl_nlink_end(old, locked);
+	ovl_nlink_end(old);
 out_drop_write:
 	ovl_drop_write(old);
 out:
@@ -811,7 +810,6 @@ static bool ovl_pure_upper(struct dentry *dentry)
 static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 {
 	int err;
-	bool locked = false;
 	const struct cred *old_cred;
 	struct dentry *upperdentry;
 	bool lower_positive = ovl_lower_positive(dentry);
@@ -832,7 +830,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	if (err)
 		goto out_drop_write;
 
-	err = ovl_nlink_start(dentry, &locked);
+	err = ovl_nlink_start(dentry);
 	if (err)
 		goto out_drop_write;
 
@@ -848,7 +846,7 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 		else
 			drop_nlink(dentry->d_inode);
 	}
-	ovl_nlink_end(dentry, locked);
+	ovl_nlink_end(dentry);
 
 	/*
 	 * Copy ctime
@@ -1012,7 +1010,6 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		      unsigned int flags)
 {
 	int err;
-	bool locked = false;
 	struct dentry *old_upperdir;
 	struct dentry *new_upperdir;
 	struct dentry *olddentry;
@@ -1021,6 +1018,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	bool old_opaque;
 	bool new_opaque;
 	bool cleanup_whiteout = false;
+	bool update_nlink = false;
 	bool overwrite = !(flags & RENAME_EXCHANGE);
 	bool is_dir = d_is_dir(old);
 	bool new_is_dir = d_is_dir(new);
@@ -1078,10 +1076,12 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		err = ovl_copy_up(new);
 		if (err)
 			goto out_drop_write;
-	} else {
-		err = ovl_nlink_start(new, &locked);
+	} else if (d_inode(new)) {
+		err = ovl_nlink_start(new);
 		if (err)
 			goto out_drop_write;
+
+		update_nlink = true;
 	}
 
 	old_cred = ovl_override_creds(old->d_sb);
@@ -1210,7 +1210,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	unlock_rename(new_upperdir, old_upperdir);
 out_revert_creds:
 	revert_creds(old_cred);
-	ovl_nlink_end(new, locked);
+	if (update_nlink)
+		ovl_nlink_end(new);
 out_drop_write:
 	ovl_drop_write(old);
 out:
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index a3c0d9584312..b48ef22ef96b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -271,8 +271,8 @@ bool ovl_test_flag(unsigned long flag, struct inode *inode);
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
 bool ovl_need_index(struct dentry *dentry);
-int ovl_nlink_start(struct dentry *dentry, bool *locked);
-void ovl_nlink_end(struct dentry *dentry, bool locked);
+int ovl_nlink_start(struct dentry *dentry);
+void ovl_nlink_end(struct dentry *dentry);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 int ovl_check_metacopy_xattr(struct dentry *dentry);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8cd37baf5d0a..d3a786006729 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -738,14 +738,14 @@ static void ovl_cleanup_index(struct dentry *dentry)
  * Operations that change overlay inode and upper inode nlink need to be
  * synchronized with copy up for persistent nlink accounting.
  */
-int ovl_nlink_start(struct dentry *dentry, bool *locked)
+int ovl_nlink_start(struct dentry *dentry)
 {
 	struct ovl_inode *oi = OVL_I(d_inode(dentry));
 	const struct cred *old_cred;
 	int err;
 
-	if (!d_inode(dentry))
-		return 0;
+	if (WARN_ON(!d_inode(dentry)))
+		return -ENOENT;
 
 	/*
 	 * With inodes index is enabled, we store the union overlay nlink
@@ -787,26 +787,22 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 out:
 	if (err)
 		mutex_unlock(&oi->lock);
-	else
-		*locked = true;
 
 	return err;
 }
 
-void ovl_nlink_end(struct dentry *dentry, bool locked)
+void ovl_nlink_end(struct dentry *dentry)
 {
-	if (locked) {
-		if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) &&
-		    d_inode(dentry)->i_nlink == 0) {
-			const struct cred *old_cred;
-
-			old_cred = ovl_override_creds(dentry->d_sb);
-			ovl_cleanup_index(dentry);
-			revert_creds(old_cred);
-		}
+	if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) &&
+	    d_inode(dentry)->i_nlink == 0) {
+		const struct cred *old_cred;
 
-		mutex_unlock(&OVL_I(d_inode(dentry))->lock);
+		old_cred = ovl_override_creds(dentry->d_sb);
+		ovl_cleanup_index(dentry);
+		revert_creds(old_cred);
 	}
+
+	mutex_unlock(&OVL_I(d_inode(dentry))->lock);
 }
 
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
-- 
2.17.1
