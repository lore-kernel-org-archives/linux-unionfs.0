From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 09/11] ovl: whiteout index when union nlink drops to zero
Date: Tue, 17 Oct 2017 19:00:20 +0300
Message-ID: <1508256022-10267-10-git-send-email-amir73il@gmail.com>
References: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51185 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934507AbdJQQAB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 12:00:01 -0400
Received: by mail-wm0-f65.google.com with SMTP id u138so4847048wmu.5
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 09:00:00 -0700 (PDT)
In-Reply-To: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When overlay inode nlink drops to zero, instead of cleanup the index
entry, replace it with a whiteout index entry.
This is needed for NFS export in order to prevent future open by handle
to open the lower file directly.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c       | 58 +++++++++++++++++++++++++++++-------------------
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/util.c      | 20 +++++++++++------
 3 files changed, 50 insertions(+), 30 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index d916fc19e724..060a1bfa0531 100644
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
 
+/* Caller must hold 'lock_rename' on workdir+dir */
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
@@ -629,14 +660,10 @@ static bool ovl_matches_upper(struct dentry *dentry, struct dentry *upper)
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
@@ -665,24 +692,13 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
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
@@ -691,10 +707,6 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
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
index e4caad7bae19..17c039485dc9 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -327,6 +327,8 @@ int ovl_create_real(struct inode *dir, struct dentry *newdentry,
 		    struct cattr *attr,
 		    struct dentry *hardlink, bool debug);
 int ovl_cleanup(struct inode *dir, struct dentry *dentry);
+int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *dir,
+			     struct dentry *dentry);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 22cdf9ecd7ec..515ae156939f 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -453,7 +453,8 @@ void ovl_inuse_unlock(struct dentry *dentry)
 /* Caller must hold OVL_I(inode)->lock */
 static void ovl_cleanup_index(struct dentry *dentry)
 {
-	struct inode *dir = ovl_indexdir(dentry->d_sb)->d_inode;
+	struct dentry *workdir = ovl_workdir(dentry);
+	struct dentry *indexdir = ovl_indexdir(dentry->d_sb);
 	struct dentry *lowerdentry = ovl_dentry_lower(dentry);
 	struct dentry *upperdentry = ovl_dentry_upper(dentry);
 	struct dentry *index = NULL;
@@ -483,16 +484,21 @@ static void ovl_cleanup_index(struct dentry *dentry)
 		goto out;
 	}
 
-	inode_lock_nested(dir, I_MUTEX_PARENT);
-	/* TODO: whiteout instead of cleanup to block future open by handle */
+	err = -EIO;
+	if (lock_rename(workdir, indexdir) != NULL)
+		goto fail;
+
 	index = lookup_one_len(name.name, ovl_indexdir(dentry->d_sb), name.len);
 	err = PTR_ERR(index);
-	if (!IS_ERR(index))
-		err = ovl_cleanup(dir, index);
-	else
+	if (!IS_ERR(index)) {
+		/* Whiteout index to block future open by handle */
+		err = ovl_cleanup_and_whiteout(workdir, d_inode(indexdir),
+					       index);
+	} else {
 		index = NULL;
+	}
 
-	inode_unlock(dir);
+	unlock_rename(workdir, indexdir);
 	if (err)
 		goto fail;
 
-- 
2.7.4
