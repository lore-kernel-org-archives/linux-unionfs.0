From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] ovl: take mnt_want_write() for work/index dir setup
Date: Wed,  3 Jan 2018 18:54:41 +0200
Message-ID: <1514998482-26662-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36523 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750819AbeACQyG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 3 Jan 2018 11:54:06 -0500
Received: by mail-wm0-f66.google.com with SMTP id b76so3788602wmg.1
        for <linux-unionfs@vger.kernel.org>; Wed, 03 Jan 2018 08:54:05 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

There are several write operations on upper fs not covered by
mnt_want_write():

- test set/remove OPAQUE xattr
- test create O_TMPFILE
- set ORIGIN xattr in ovl_verify_origin()
- cleanup of index entries in ovl_indexdir_cleanup()

Some of these go way back, but this patch only applies over the
v4.14 re-factoring of ovl_fill_super().

Cc: <stable@vger.kernel.org> #v4.14
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/super.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76440feb79f6..5f6d2385c0b3 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -520,10 +520,6 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 	bool retried = false;
 	bool locked = false;
 
-	err = mnt_want_write(mnt);
-	if (err)
-		goto out_err;
-
 	inode_lock_nested(dir, I_MUTEX_PARENT);
 	locked = true;
 
@@ -588,7 +584,6 @@ static struct dentry *ovl_workdir_create(struct ovl_fs *ofs,
 		goto out_err;
 	}
 out_unlock:
-	mnt_drop_write(mnt);
 	if (locked)
 		inode_unlock(dir);
 
@@ -929,12 +924,17 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
 
 static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 {
+	struct vfsmount *mnt = ofs->upper_mnt;
 	struct dentry *temp;
 	int err;
 
+	err = mnt_want_write(mnt);
+	if (err)
+		return err;
+
 	ofs->workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
 	if (!ofs->workdir)
-		return 0;
+		goto out;
 
 	/*
 	 * Upper should support d_type, else whiteouts are visible.  Given
@@ -944,7 +944,7 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	 */
 	err = ovl_check_d_type_supported(workpath);
 	if (err < 0)
-		return err;
+		goto out;
 
 	/*
 	 * We allowed this configuration and don't want to break users over
@@ -968,6 +968,7 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	if (err) {
 		ofs->noxattr = true;
 		pr_warn("overlayfs: upper fs does not support xattr.\n");
+		err = 0;
 	} else {
 		vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
 	}
@@ -979,7 +980,9 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 		pr_warn("overlayfs: upper fs does not support file handles, falling back to index=off.\n");
 	}
 
-	return 0;
+out:
+	mnt_drop_write(mnt);
+	return err;
 }
 
 static int ovl_get_workdir(struct ovl_fs *ofs, struct path *upperpath)
@@ -1026,8 +1029,13 @@ static int ovl_get_workdir(struct ovl_fs *ofs, struct path *upperpath)
 static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
 			    struct path *upperpath)
 {
+	struct vfsmount *mnt = ofs->upper_mnt;
 	int err;
 
+	err = mnt_want_write(mnt);
+	if (err)
+		return err;
+
 	/* Verify lower root is upper root origin */
 	err = ovl_verify_origin(upperpath->dentry, oe->lowerstack[0].dentry,
 				false, true);
@@ -1055,6 +1063,7 @@ static int ovl_get_indexdir(struct ovl_fs *ofs, struct ovl_entry *oe,
 		pr_warn("overlayfs: try deleting index dir or mounting with '-o index=off' to disable inodes index.\n");
 
 out:
+	mnt_drop_write(mnt);
 	return err;
 }
 
-- 
2.7.4
