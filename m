From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 19/23] ovl: use ovl_inode mutex to synchronize concurrent copy up
Date: Wed, 14 Jun 2017 10:26:38 +0300
Message-ID: <1497425202-16270-20-git-send-email-amir73il@gmail.com>
References: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:32993 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754264AbdFNH05 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 14 Jun 2017 03:26:57 -0400
Received: by mail-wr0-f196.google.com with SMTP id v104so36664962wrb.0
        for <linux-unionfs@vger.kernel.org>; Wed, 14 Jun 2017 00:26:56 -0700 (PDT)
In-Reply-To: <1497425202-16270-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Use the new ovl_inode mutex to synchonize concurrent copy up
instead of the super block copy up workqueue.

Moving the synchronization object from the overlay dentry to
the overlay inode is needed for synchonizing concurrent copy up
of lower hardlinks to the same upper inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/ovl_entry.h |  2 --
 fs/overlayfs/super.c     |  1 -
 fs/overlayfs/util.c      | 24 ++++++------------------
 3 files changed, 6 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index 6e240bc5ac1d..288f52f24755 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -35,7 +35,6 @@ struct ovl_fs {
 	const struct cred *creator_cred;
 	bool tmpfile;
 	bool noxattr;
-	wait_queue_head_t copyup_wq;
 	/* sb common to all layers */
 	struct super_block *same_sb;
 };
@@ -50,7 +49,6 @@ struct ovl_entry {
 		struct {
 			u64 version;
 			const char *redirect;
-			bool copying;
 		};
 		struct rcu_head rcu;
 	};
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7b48bfed0121..0f36a09df34c 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -878,7 +878,6 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ufs)
 		goto out;
 
-	init_waitqueue_head(&ufs->copyup_wq);
 	ufs->config.redirect_dir = ovl_redirect_dir_def;
 	ufs->config.index = ovl_index_def;
 	err = ovl_parse_opt((char *) data, &ufs->config);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 65c1e09ae0d0..9c729322d3b0 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -257,7 +257,7 @@ void ovl_dentry_update(struct dentry *dentry, struct dentry *upperdentry)
 	struct ovl_entry *oe = dentry->d_fsdata;
 
 	WARN_ON(!inode_is_locked(upperdentry->d_parent->d_inode) &&
-		!oe->copying);
+		!mutex_is_locked(&OVL_I(d_inode(dentry))->oi_lock));
 	WARN_ON(oe->__upperdentry);
 	/*
 	 * Make sure upperdentry is consistent before making it visible to
@@ -368,32 +368,20 @@ struct file *ovl_path_open(struct path *path, int flags)
 
 int ovl_copy_up_start(struct dentry *dentry)
 {
-	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
-	struct ovl_entry *oe = dentry->d_fsdata;
 	int err;
 
-	spin_lock(&ofs->copyup_wq.lock);
-	err = wait_event_interruptible_locked(ofs->copyup_wq, !oe->copying);
-	if (!err) {
-		if (oe->__upperdentry)
-			err = 1; /* Already copied up */
-		else
-			oe->copying = true;
+	err = mutex_lock_interruptible(&OVL_I(d_inode(dentry))->oi_lock);
+	if (!err && ovl_dentry_upper(dentry)) {
+		err = 1; /* Already copied up */
+		mutex_unlock(&OVL_I(d_inode(dentry))->oi_lock);
 	}
-	spin_unlock(&ofs->copyup_wq.lock);
 
 	return err;
 }
 
 void ovl_copy_up_end(struct dentry *dentry)
 {
-	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
-	struct ovl_entry *oe = dentry->d_fsdata;
-
-	spin_lock(&ofs->copyup_wq.lock);
-	oe->copying = false;
-	wake_up_locked(&ofs->copyup_wq);
-	spin_unlock(&ofs->copyup_wq.lock);
+	mutex_unlock(&OVL_I(d_inode(dentry))->oi_lock);
 }
 
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name)
-- 
2.7.4
