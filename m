From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v2] ovl: Check link ability between upperdir and workdir
Date: Mon, 18 Dec 2017 17:01:43 +0800
Message-ID: <1513587703-22542-1-git-send-email-cgxu519@icloud.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from [122.225.81.134] ([122.225.81.134]:11159 "EHLO
        juanniu018037.ss.mogujie.org" rhost-flags-FAIL-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S932714AbdLRJDL (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Dec 2017 04:03:11 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

If upper fs supports tmpfile, check link ability between
upperdir and workdir and print a warning message if check
fails.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
Changes since v1:
- Check link ablity between upperdir and workdir instead of checking
project ids of upperdir and workdir.
- Print a warning message instead of falling to readonly mode.

 fs/overlayfs/super.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76440fe..829aea9 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -929,7 +929,7 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
 
 static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 {
-	struct dentry *temp;
+	struct dentry *uppertemp, *worktemp;
 	int err;
 
 	ofs->workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
@@ -954,11 +954,22 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 		pr_warn("overlayfs: upper fs needs to support d_type.\n");
 
 	/* Check if upper/work fs supports O_TMPFILE */
-	temp = ovl_do_tmpfile(ofs->workdir, S_IFREG | 0);
-	ofs->tmpfile = !IS_ERR(temp);
-	if (ofs->tmpfile)
-		dput(temp);
-	else
+	uppertemp = ovl_do_tmpfile(ofs->upper_mnt->mnt_root, S_IFREG | 0);
+	ofs->tmpfile = !IS_ERR(uppertemp);
+	if (ofs->tmpfile) {
+		worktemp = ovl_lookup_temp(ofs->workdir);
+		if (!IS_ERR(worktemp)) {
+			inode_lock_nested(ofs->workdir->d_inode, I_MUTEX_PARENT);
+			err = ovl_do_link(uppertemp, ofs->workdir->d_inode, worktemp, true);
+			inode_unlock(ofs->workdir->d_inode);
+			if (err)
+				pr_warn("overlayfs: can not move files between upperdir and workdir, it may cause write error.\n");
+			else
+				ovl_cleanup(ofs->workdir->d_inode, worktemp);
+			dput(worktemp);
+		}
+		dput(uppertemp);
+	} else
 		pr_warn("overlayfs: upper fs does not support tmpfile.\n");
 
 	/*
-- 
1.8.3.1
