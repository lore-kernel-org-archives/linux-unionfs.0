Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:33922 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751933AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 17/28] ovl: During rename lock both source and target ovl_inode
Date: Thu, 29 Mar 2018 15:38:43 -0400
Message-Id: <20180329193854.13814-18-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

In some cases we need to take both source (old) and target(new) dentry
ovl_inode->lock. This patch adds support for that. Locks are taken in
order of increasing inode address to avoid deadlock. This code has been
taken from lock_two_nondirectories().

As of now, metacopy needs this lock if we are planning to update redirect
information on source/target ovl_inode. nlink related accounting takes this
lock on target for the case of overwrite.

One change w.r.t existing code is mutex_lock() vs mutex_lock_interruptible().
Now ovl_rename() code path has switched to mutex_lock() variant for
ovl_inode->lock. There is no particular reason, I just found it easier
to reuse lock_two_nondirectories(), that's why. Hoping its not a concern.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/dir.c | 87 ++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 82 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1f003be4a19e..3ea052b6bac7 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -896,12 +896,84 @@ static int ovl_set_redirect(struct dentry *dentry, bool samedir)
 	return err;
 }
 
+static void ovl_lock_two_nondirectories(struct ovl_inode *oi1,
+				       struct ovl_inode *oi2)
+{
+	if (oi1 > oi2)
+		swap(oi1, oi2);
+
+	if (oi1)
+                mutex_lock(&oi1->lock);
+        if (oi2 && oi2 != oi1)
+                mutex_lock_nested(&oi2->lock, I_MUTEX_NONDIR2);
+}
+
+static void ovl_rename_lock_ovl_inodes(struct dentry *old, struct dentry *new,
+				       bool overwrite, bool *old_locked,
+				       bool *new_locked)
+{
+	bool lock_old = false, lock_new = false;
+	struct ovl_inode * oi1 = NULL, *oi2 = NULL;
+
+	/*
+	 * First determine which inodes need to be locked.
+	 *
+	 * If "old" is metacopy, oi->redirect will be set. So we need lock
+	 * on old ovl_inode. If "new" is metacopy, and it is not being
+	 * overwritten, then oi->redirect will be set and we will need
+	 * lock on new ovl_inode.
+	 */
+
+	if (ovl_is_metacopy_dentry(old))
+		lock_old = true;
+
+	if (!overwrite && ovl_is_metacopy_dentry(new))
+		lock_new = true;
+	/*
+	 * For nlink, if we are overwriting and new->inode is not empty,
+	 * then we need to take lock on new ovl_inode.
+	 */
+	if (overwrite && d_inode(new))
+		lock_new = true;
+
+	oi1 = OVL_I(d_inode(old));
+	if (lock_new)
+		oi2 = OVL_I(d_inode(new));
+
+	if (lock_old && lock_new) {
+		ovl_lock_two_nondirectories(oi1, oi2);
+		*old_locked = *new_locked = true;
+		return;
+	}
+
+	if (lock_old) {
+		mutex_lock(&oi1->lock);
+		*old_locked = true;
+		return;
+	}
+
+	if (lock_new) {
+		mutex_lock(&oi2->lock);
+		*new_locked = true;
+	}
+}
+
+static void ovl_rename_unlock_ovl_inodes(struct dentry *old, struct dentry *new,
+				         bool old_locked, bool new_locked)
+{
+	if (old_locked)
+		mutex_unlock(&OVL_I(d_inode(old))->lock);
+
+	if (new_locked && d_inode(old) != d_inode(new))
+		mutex_unlock(&OVL_I(d_inode(new))->lock);
+}
+
 static int ovl_rename(struct inode *olddir, struct dentry *old,
 		      struct inode *newdir, struct dentry *new,
 		      unsigned int flags)
 {
 	int err;
-	bool new_locked = false;
+	bool old_locked = false, new_locked = false;
 	struct dentry *old_upperdir;
 	struct dentry *new_upperdir;
 	struct dentry *olddentry;
@@ -973,10 +1045,12 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 			goto out_drop_write;
 	}
 
-	if (overwrite) {
-		err = ovl_nlink_start(new, &new_locked);
+	ovl_rename_lock_ovl_inodes(old, new, overwrite, &old_locked,
+				   &new_locked);
+	if (overwrite && new_locked) {
+		err = ovl_nlink_start_locked(new);
 		if (err)
-			goto out_drop_write;
+			goto out_unlock_inodes;
 	}
 
 	old_cred = ovl_override_creds(old->d_sb);
@@ -1102,7 +1176,10 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 	unlock_rename(new_upperdir, old_upperdir);
 out_revert_creds:
 	revert_creds(old_cred);
-	ovl_nlink_end(new, new_locked);
+	if (new_locked)
+		ovl_nlink_end_locked(new);
+out_unlock_inodes:
+	ovl_rename_unlock_ovl_inodes(old, new, old_locked, new_locked);
 out_drop_write:
 	ovl_drop_write(old);
 out:
-- 
2.13.6

