Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx3-rdu2.redhat.com ([66.187.233.73]:46872 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751938AbeC2TjD (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 29 Mar 2018 15:39:03 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: [PATCH v13 15/28] ovl: Move some of ovl_nlink_start() functionality in ovl_nlink_prep()
Date: Thu, 29 Mar 2018 15:38:41 -0400
Message-Id: <20180329193854.13814-16-vgoyal@redhat.com>
In-Reply-To: <20180329193854.13814-1-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, vgoyal@redhat.com
List-ID: <linux-unionfs@vger.kernel.org>

Soon I want to write patches to enable redirects on non-dir files. That means
it is possible that we have to deal with the case where multiple dentries
might be sharing inode and ovl_inode->redirect field setting/resetting
will need to be protected by taking ovl_inode->lock. Current dentry based
locking alone will not be sufficient for this case.

As of now, nlink based code takes ovl_inode->lock in some cases. For redirect
case, during ovl_rename() I might have to take ovl_inode->lock both on
old as well as new ovl_inode. And that means that I need to make sure
there are no deadlocks.

I want to separate out logic for taking lock in a new function. Hence will
need to break down ovl_nlink_start() a bit.

ovl_nlink_start() does the copy up and then takes ovl_inode->lock. Move
copy up related portions in a separate function called ovl_nlink_prep().

This patch is just code reorganization and no funcitonal change.

Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
---
 fs/overlayfs/dir.c       | 14 ++++++++++++++
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 26 ++++++++++++++++++--------
 3 files changed, 33 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 7617a03acc30..1f003be4a19e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -595,6 +595,10 @@ static int ovl_link(struct dentry *old, struct inode *newdir,
 	if (err)
 		goto out_drop_write;
 
+	err = ovl_nlink_prep(old);
+	if (err)
+		goto out_drop_write;
+
 	err = ovl_nlink_start(old, &locked);
 	if (err)
 		goto out_drop_write;
@@ -752,6 +756,10 @@ static int ovl_do_remove(struct dentry *dentry, bool is_dir)
 	if (err)
 		goto out_drop_write;
 
+	err = ovl_nlink_prep(dentry);
+	if (err)
+		goto out_drop_write;
+
 	err = ovl_nlink_start(dentry, &locked);
 	if (err)
 		goto out_drop_write;
@@ -960,6 +968,12 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 		if (err)
 			goto out_drop_write;
 	} else {
+		err = ovl_nlink_prep(new);
+		if (err)
+			goto out_drop_write;
+	}
+
+	if (overwrite) {
 		err = ovl_nlink_start(new, &new_locked);
 		if (err)
 			goto out_drop_write;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 214d9f08c574..aa5b0c121fc7 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -271,6 +271,7 @@ bool ovl_test_flag(unsigned long flag, struct inode *inode);
 bool ovl_inuse_trylock(struct dentry *dentry);
 void ovl_inuse_unlock(struct dentry *dentry);
 bool ovl_need_index(struct dentry *dentry);
+int ovl_nlink_prep(struct dentry *dentry);
 int ovl_nlink_start(struct dentry *dentry, bool *locked);
 void ovl_nlink_end(struct dentry *dentry, bool locked);
 int ovl_lock_rename_workdir(struct dentry *workdir, struct dentry *upperdir);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 394674c4c820..ed93e233894f 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -675,15 +675,9 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	goto out;
 }
 
-/*
- * Operations that change overlay inode and upper inode nlink need to be
- * synchronized with copy up for persistent nlink accounting.
- */
-int ovl_nlink_start(struct dentry *dentry, bool *locked)
+int ovl_nlink_prep(struct dentry *dentry)
 {
-	struct ovl_inode *oi = OVL_I(d_inode(dentry));
-	const struct cred *old_cred;
-	int err;
+	int err = 0;
 
 	if (!d_inode(dentry))
 		return 0;
@@ -708,6 +702,22 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 			return err;
 	}
 
+	return err;
+}
+
+/*
+ * Operations that change overlay inode and upper inode nlink need to be
+ * synchronized with copy up for persistent nlink accounting.
+ */
+int ovl_nlink_start(struct dentry *dentry, bool *locked)
+{
+	struct ovl_inode *oi = OVL_I(d_inode(dentry));
+	const struct cred *old_cred;
+	int err;
+
+	if (!d_inode(dentry))
+		return 0;
+
 	err = mutex_lock_interruptible(&oi->lock);
 	if (err)
 		return err;
-- 
2.13.6

