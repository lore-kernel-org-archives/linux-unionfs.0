From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 17/23] ovl: whiteout index when union nlink drops to zero
Date: Thu,  4 Jan 2018 18:40:12 +0200
Message-ID: <1515084018-25134-18-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:35770 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753310AbeADQjs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:48 -0500
Received: by mail-wr0-f194.google.com with SMTP id l19so2019602wrc.2
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:47 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

With the 'verify' feature enabled, when overlay inode nlink drops to
zero, instead of removing the index entry, replace it with a whiteout
index entry.

This is needed for NFS export in order to prevent future open by handle
from opening the lower file directly.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 58 +++++++++++++++++++++++++++++-------------------
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/util.c      | 17 +++++++++-----
 3 files changed, 48 insertions(+), 29 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index f9788bc116a8..f1104e56a29e 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -63,8 +63,7 @@ struct dentry *ovl_lookup_temp(struct dentry *workdir)
 }
 
 /* caller holds i_mutex on workdir */
-static struct dentry *ovl_whiteout(struct dentry *workdir,
-				   struct dentry *dentry)
+static struct dentry *ovl_whiteout(struct dentry *workdir)
 {
 	int err;
 	struct dentry *whiteout;
@@ -83,6 +82,38 @@ static struct dentry *ovl_whiteout(struct dentry *workdir,
 	return whiteout;
 }
 
+/* Caller must hold i_mutex on both workdir and dir */
+int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
+			     struct dentry *dentry)
+{
+	struct inode *wdir = workdir->d_inode;
+	struct dentry *whiteout;
+	int err;
+	int flags = 0;
+
+	whiteout = ovl_whiteout(workdir);
+	err = PTR_ERR(whiteout);
+	if (IS_ERR(whiteout))
+		return err;
+
+	if (d_is_dir(dentry))
+		flags = RENAME_EXCHANGE;
+
+	err = ovl_do_rename(wdir, whiteout, dir, dentry, flags);
+	if (err)
+		goto kill_whiteout;
+	if (flags)
+		ovl_cleanup(wdir, dentry);
+
+out:
+	dput(whiteout);
+	return err;
+
+kill_whiteout:
+	ovl_cleanup(wdir, whiteout);
+	goto out;
+}
+
 int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct cattr *attr, struct dentry *hardlink, bool debug)
 {
@@ -626,14 +657,10 @@ static bool ovl_matches_upper(struct dentry *dentry, struct dentry *upper)
 static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 {
 	struct dentry *workdir = ovl_workdir(dentry);
-	struct inode *wdir = workdir->d_inode;
 	struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
-	struct inode *udir = upperdir->d_inode;
-	struct dentry *whiteout;
 	struct dentry *upper;
 	struct dentry *opaquedir = NULL;
 	int err;
-	int flags = 0;
 
 	if (WARN_ON(!workdir))
 		return -EROFS;
@@ -662,24 +689,13 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 		goto out_dput_upper;
 	}
 
-	whiteout = ovl_whiteout(workdir, dentry);
-	err = PTR_ERR(whiteout);
-	if (IS_ERR(whiteout))
-		goto out_dput_upper;
-
-	if (d_is_dir(upper))
-		flags = RENAME_EXCHANGE;
-
-	err = ovl_do_rename(wdir, whiteout, udir, upper, flags);
+	err = ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), upper);
 	if (err)
-		goto kill_whiteout;
-	if (flags)
-		ovl_cleanup(wdir, upper);
+		goto out_d_drop;
 
 	ovl_dentry_version_inc(dentry->d_parent, true);
 out_d_drop:
 	d_drop(dentry);
-	dput(whiteout);
 out_dput_upper:
 	dput(upper);
 out_unlock:
@@ -688,10 +704,6 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 	dput(opaquedir);
 out:
 	return err;
-
-kill_whiteout:
-	ovl_cleanup(wdir, whiteout);
-	goto out_d_drop;
 }
 
 static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 759cb3a465b4..9d0dd8b70e03 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -311,6 +311,8 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
 struct dentry *ovl_lookup_temp(struct dentry *workdir);
+int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
+			     struct dentry *dentry);
 struct cattr {
 	dev_t rdev;
 	umode_t mode;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 7b54b4ecab3b..ce4ac3846b14 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -505,7 +505,8 @@ bool ovl_need_index(struct dentry *dentry)
 /* Caller must hold OVL_I(inode)->lock */
 static void ovl_cleanup_index(struct dentry *dentry)
 {
-	struct inode *dir = ovl_indexdir(dentry->d_sb)->d_inode;
+	struct dentry *indexdir = ovl_indexdir(dentry->d_sb);
+	struct inode *dir = indexdir->d_inode;
 	struct dentry *lowerdentry = ovl_dentry_lower(dentry);
 	struct dentry *upperdentry = ovl_dentry_upper(dentry);
 	struct dentry *index = NULL;
@@ -536,13 +537,17 @@ static void ovl_cleanup_index(struct dentry *dentry)
 	}
 
 	inode_lock_nested(dir, I_MUTEX_PARENT);
-	/* TODO: whiteout instead of cleanup to block future open by handle */
-	index = lookup_one_len(name.name, ovl_indexdir(dentry->d_sb), name.len);
+	index = lookup_one_len(name.name, indexdir, name.len);
 	err = PTR_ERR(index);
-	if (!IS_ERR(index))
-		err = ovl_cleanup(dir, index);
-	else
+	if (IS_ERR(index)) {
 		index = NULL;
+	} else if (ovl_verify(dentry->d_sb)) {
+		/* Whiteout orphan index to block future open by handle */
+		err = ovl_cleanup_and_whiteout(indexdir, dir, index);
+	} else {
+		/* Cleanup orphan index entries */
+		err = ovl_cleanup(dir, index);
+	}
 
 	inode_unlock(dir);
 	if (err)
-- 
2.7.4
