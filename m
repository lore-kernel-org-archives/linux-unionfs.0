From: Chengguang Xu <cgxu519@icloud.com>
Subject: [PATCH v5] ovl: Check link ability between upperdir and workdir
Date: Sun, 21 Jan 2018 00:10:59 +0800
Message-ID: <1516464659-130410-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from pv33p00im-asmtp002.me.com ([17.142.194.251]:43283 "EHLO
        pv33p00im-asmtp002.me.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754913AbeATRMC (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 20 Jan 2018 12:12:02 -0500
Received: from process-dkim-sign-daemon.pv33p00im-asmtp002.me.com by
 pv33p00im-asmtp002.me.com
 (Oracle Communications Messaging Server 8.0.1.2.20170607 64bit (built Jun  7
 2017)) id <0P2V00E0034WE300@pv33p00im-asmtp002.me.com> for
 linux-unionfs@vger.kernel.org; Sat, 20 Jan 2018 16:11:27 +0000 (GMT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, Chengguang Xu <cgxu519@icloud.com>

Inspired by encountering unexpected write error with
error code -EXDEV when upperdir and workdir having
different project quotas. The reason of the error is
project quota asks files in it strictly inherit
project id of it’s own, so rename/link operations
between those directories will fail and it may cause
failure during copy-up/index-link operations in overlayfs.

So if upper filesystem supports O_TMPFILE, try to check
link ability between upperdir and workdir and if check
fails, print a proper warning message to indicate potential
possibility of write failure.

The failure of the check does not directly lead to
read-only mounting because in some use cases may only
write to upperdir and do not modify anything in lowerdirs.

Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
---
Changes since v4:
- Fix warning at the top of lookup_one_len() that 
triggers because of no locking of parent.

Changes since v3:
- Add more detail comment about motivation to changelog.

Changes since v2:
- Add comment about motivation.
- Modify warning message.

Changes since v1:
- Check link ablity between upperdir and workdir instead of checking
project ids of upperdir and workdir.
- Print a warning message instead of falling to readonly mode.

 fs/overlayfs/super.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 76440fe..82caf13 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -929,7 +929,7 @@ static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
 
 static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 {
-	struct dentry *temp;
+	struct dentry *uppertemp, *worktemp;
 	int err;
 
 	ofs->workdir = ovl_workdir_create(ofs, OVL_WORKDIR_NAME, false);
@@ -953,12 +953,31 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
 	if (!err)
 		pr_warn("overlayfs: upper fs needs to support d_type.\n");
 
-	/* Check if upper/work fs supports O_TMPFILE */
-	temp = ovl_do_tmpfile(ofs->workdir, S_IFREG | 0);
-	ofs->tmpfile = !IS_ERR(temp);
-	if (ofs->tmpfile)
-		dput(temp);
-	else
+	/*
+	 * Check if upper/work fs supports O_TMPFILE and if support, check
+	 * link ability between upperdir and workdir, this is inspired by
+	 * encountering unexpected write error when upperdir and workdir
+	 * having different project ids.
+	 */
+	uppertemp = ovl_do_tmpfile(ofs->upper_mnt->mnt_root, S_IFREG | 0);
+	ofs->tmpfile = !IS_ERR(uppertemp);
+	if (ofs->tmpfile) {
+		inode_lock_nested(ofs->workdir->d_inode, I_MUTEX_PARENT);
+		worktemp = ovl_lookup_temp(ofs->workdir);
+		if (!IS_ERR(worktemp)) {
+			err = ovl_do_link(uppertemp, ofs->workdir->d_inode,
+							worktemp, true);
+			inode_unlock(ofs->workdir->d_inode);
+			if (err)
+				pr_warn("overlayfs: cannot link files between upperdir and workdir, it may cause write error.\n");
+			else
+				ovl_cleanup(ofs->workdir->d_inode, worktemp);
+			dput(worktemp);
+		} else {
+			inode_unlock(ofs->workdir->d_inode);
+		}
+		dput(uppertemp);
+	} else
 		pr_warn("overlayfs: upper fs does not support tmpfile.\n");
 
 	/*
-- 
1.8.3.1
