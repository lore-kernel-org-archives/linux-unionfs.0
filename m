Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/2] ovl: abstract ovl_inode lock with a helper
Date: Thu, 18 Oct 2018 18:37:14 +0300
Message-Id: <20181018153714.3834-3-amir73il@gmail.com>
In-Reply-To: <20181018153714.3834-1-amir73il@gmail.com>
References: <20181018153714.3834-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The abstraction improves code readabilty (to some).

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/overlayfs.h | 10 ++++++++++
 fs/overlayfs/util.c      | 25 +++++++++++++------------
 2 files changed, 23 insertions(+), 12 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index b48ef22ef96b..5e45cb3630a0 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -290,6 +290,16 @@ static inline unsigned int ovl_xino_bits(struct super_block *sb)
 	return ofs->xino_bits;
 }
 
+static inline int ovl_inode_lock(struct inode *inode)
+{
+	return mutex_lock_interruptible(&OVL_I(inode)->lock);
+}
+
+static inline void ovl_inode_unlock(struct inode *inode)
+{
+	mutex_unlock(&OVL_I(inode)->lock);
+}
+
 
 /* namei.c */
 int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index d3a786006729..7c01327b1852 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -521,13 +521,13 @@ bool ovl_already_copied_up(struct dentry *dentry, int flags)
 
 int ovl_copy_up_start(struct dentry *dentry, int flags)
 {
-	struct ovl_inode *oi = OVL_I(d_inode(dentry));
+	struct inode *inode = d_inode(dentry);
 	int err;
 
-	err = mutex_lock_interruptible(&oi->lock);
+	err = ovl_inode_lock(inode);
 	if (!err && ovl_already_copied_up_locked(dentry, flags)) {
 		err = 1; /* Already copied up */
-		mutex_unlock(&oi->lock);
+		ovl_inode_unlock(inode);
 	}
 
 	return err;
@@ -535,7 +535,7 @@ int ovl_copy_up_start(struct dentry *dentry, int flags)
 
 void ovl_copy_up_end(struct dentry *dentry)
 {
-	mutex_unlock(&OVL_I(d_inode(dentry))->lock);
+	ovl_inode_unlock(d_inode(dentry));
 }
 
 bool ovl_check_origin_xattr(struct dentry *dentry)
@@ -740,11 +740,11 @@ static void ovl_cleanup_index(struct dentry *dentry)
  */
 int ovl_nlink_start(struct dentry *dentry)
 {
-	struct ovl_inode *oi = OVL_I(d_inode(dentry));
+	struct inode *inode = d_inode(dentry);
 	const struct cred *old_cred;
 	int err;
 
-	if (WARN_ON(!d_inode(dentry)))
+	if (WARN_ON(!inode))
 		return -ENOENT;
 
 	/*
@@ -767,11 +767,11 @@ int ovl_nlink_start(struct dentry *dentry)
 			return err;
 	}
 
-	err = mutex_lock_interruptible(&oi->lock);
+	err = ovl_inode_lock(inode);
 	if (err)
 		return err;
 
-	if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
+	if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, inode))
 		goto out;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
@@ -786,15 +786,16 @@ int ovl_nlink_start(struct dentry *dentry)
 
 out:
 	if (err)
-		mutex_unlock(&oi->lock);
+		ovl_inode_unlock(inode);
 
 	return err;
 }
 
 void ovl_nlink_end(struct dentry *dentry)
 {
-	if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) &&
-	    d_inode(dentry)->i_nlink == 0) {
+	struct inode *inode = d_inode(dentry);
+
+	if (ovl_test_flag(OVL_INDEX, inode) && inode->i_nlink == 0) {
 		const struct cred *old_cred;
 
 		old_cred = ovl_override_creds(dentry->d_sb);
@@ -802,7 +803,7 @@ void ovl_nlink_end(struct dentry *dentry)
 		revert_creds(old_cred);
 	}
 
-	mutex_unlock(&OVL_I(d_inode(dentry))->lock);
+	ovl_inode_unlock(inode);
 }
 
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir)
-- 
2.17.1
