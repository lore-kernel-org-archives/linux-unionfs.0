From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH V2] ovl:fix rmdir problem on impure dir
Date: Mon, 19 Jun 2017 12:00:32 +0800
Message-ID: <1497844832-24767-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:7886 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751771AbdFSD5c (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 18 Jun 2017 23:57:32 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: eguan@redhat.com, amir73il@gmail.com, miklos@szeredi.hu, yi.zhang@huawei.com, miaoxie@huawei.com

There is another problem about impure upper dir which have left
whiteout files(the first one is whiteout exposure). If an
"impure && not merged" upper dir have left whiteout files
(last mount created), ovl cannot clear this dir when we
removing it, which may lead to rmdir fail or temp file left
in workdir.

Reproducer:
  mkdir lower upper work merge
  mkdir -p lower/dir
  touch lower/dir/a
  mount -t overlay overlay -olowerdir=lower,upperdir=upper,\
    workdir=work merge
  rm merge/dir/a
  umount merge
  rm -rf lower/*
  touch lower/dir  (*)
  mount -t overlay overlay -olowerdir=lower,upperdir=upper,\
    workdir=work merge
  rm -rf merge/dir

Syslog dump:
  overlayfs: cleanup of 'work/#7' failed (-39)

(*): if we are not creat this file, the result is different:
  rm: cannot remove "dir/": Directory not empty

This patch add impure flag on parent dir in ovl_remove_and_whiteout()
to indicate the dir is impure, and then check and clean it when
removing this dir.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

---
V2:
 - fix comment in ovl_remove_and_whiteout()
 - post reproducer to xfstest

---
 fs/overlayfs/dir.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a63a716..9bedad0 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -336,7 +336,8 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
 	 * Doesn't matter, since copy-up can't create a non-empty directory
 	 * from an empty one.
 	 */
-	if (OVL_TYPE_UPPER(type) && OVL_TYPE_MERGE(type))
+	if (OVL_TYPE_UPPER(type) && (OVL_TYPE_MERGE(type) ||
+				     ovl_dentry_is_impure(dentry)))
 		ret = ovl_clear_empty(dentry, &list);
 
 out_free:
@@ -633,6 +634,11 @@ static int ovl_remove_and_whiteout(struct dentry *dentry, bool is_dir)
 			goto out;
 	}
 
+	/* Mark parent "impure" because it may now contain whiteouts */
+	err = ovl_set_impure(dentry->d_parent, upperdir);
+	if (err)
+		goto out_dput;
+
 	err = ovl_lock_rename_workdir(workdir, upperdir);
 	if (err)
 		goto out_dput;
@@ -690,8 +696,9 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 	struct dentry *opaquedir = NULL;
 	int err;
 
-	/* Redirect dir can be !ovl_lower_positive && OVL_TYPE_MERGE */
-	if (is_dir && ovl_dentry_get_redirect(dentry)) {
+	/* Redirect/Impure dir can be !ovl_lower_positive && not clean */
+	if (is_dir && (ovl_dentry_get_redirect(dentry) ||
+		       ovl_dentry_is_impure(dentry))) {
 		opaquedir = ovl_check_empty_and_clear(dentry);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir))
-- 
1.8.3.1
