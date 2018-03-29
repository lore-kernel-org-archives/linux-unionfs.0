Return-Path: <vgoyal@redhat.com>
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 16/28] ovl: Create locked version of ovl_nlink_start() and ovl_nlink_end()
Date: Thu, 29 Mar 2018 15:38:42 -0400
Message-Id: <20180329193854.13814-17-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Soon in ovl_rename() I will introduce a function to take lock both on old
and new ovl_inode. That means I don't want ovl_nlink_start() to take lock
and ovl_nlink_end() to drop lock. It will be done by other functions.

So create ovl_nlink_start_locked() and ovl_nlink_end_locked() which assume
that by the time they are called, lock has already been taken and these
don't deal with taking/releasing locks.

These will be used in following patches.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/util.c      | 50 +++++++++++++++++++++++++++++-------------------
 2 files changed, 32 insertions(+), 20 deletions(-)

diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index aa5b0c121fc7..429713653b3b 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -273,7 +273,9 @@ void ovl_inuse_unlock(struct dentry *dentry);
 bool ovl_need_index(struct dentry *dentry);
 int ovl_nlink_prep(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
+int ovl_nlink_start_locked(struct dentry *dentry);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
+void ovl_nlink_end_locked(struct dentry *dentry);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
 int ovl_check_metacopy_xattr(struct dentry *dentry);
 bool ovl_is_metacopy_dentry(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index ed93e233894f..927960aa57ee 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -709,21 +709,13 @@ int ovl_nlink_prep(struct dentry *dentry)
  * Operations that change overlay inode and upper inode nlink need to be
  * synchronized with copy up for persistent nlink accounting.
  */
-int ovl_nlink_start(struct dentry *dentry, bool *locked)
+int ovl_nlink_start_locked(struct dentry *dentry)
 {
-	struct ovl_inode *oi = OVL_I(d_inode(dentry));
 	const struct cred *old_cred;
 	int err;
 
-	if (!d_inode(dentry))
-		return 0;
-
-	err = mutex_lock_interruptible(&oi->lock);
-	if (err)
-		return err;
-
 	if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
-		goto out;
+		return 0;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
 	/*
@@ -734,8 +726,22 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 	 */
 	err = ovl_set_nlink_upper(dentry);
 	revert_creds(old_cred);
+	return err;
+}
 
-out:
+int ovl_nlink_start(struct dentry *dentry, bool *locked)
+{
+	struct ovl_inode *oi = OVL_I(d_inode(dentry));
+	int err;
+
+	if (!d_inode(dentry))
+		return 0;
+
+	err = mutex_lock_interruptible(&oi->lock);
+	if (err)
+		return err;
+
+	err = ovl_nlink_start_locked(dentry);
 	if (err)
 		mutex_unlock(&oi->lock);
 	else
@@ -744,18 +750,22 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 	return err;
 }
 
-void ovl_nlink_end(struct dentry *dentry, bool locked)
+void ovl_nlink_end_locked(struct dentry *dentry)
 {
-	if (locked) {
-		if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) &&
-		    d_inode(dentry)->i_nlink == 0) {
-			const struct cred *old_cred;
+	if (ovl_test_flag(OVL_INDEX, d_inode(dentry)) &&
+	    d_inode(dentry)->i_nlink == 0) {
+		const struct cred *old_cred;
 
-			old_cred = ovl_override_creds(dentry->d_sb);
-			ovl_cleanup_index(dentry);
-			revert_creds(old_cred);
-		}
+		old_cred = ovl_override_creds(dentry->d_sb);
+		ovl_cleanup_index(dentry);
+		revert_creds(old_cred);
+	}
+}
 
+void ovl_nlink_end(struct dentry *dentry, bool locked)
+{
+	if (locked) {
+		ovl_nlink_end_locked(dentry);
 		mutex_unlock(&OVL_I(d_inode(dentry))->lock);
 	}
 }
-- 
2.13.6
