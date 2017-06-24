From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH v3] ovl: fix rmdir problem on impure dir
Date: Sat, 24 Jun 2017 13:57:49 +0800
Message-ID: <1498283869-17623-1-git-send-email-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga03-in.huawei.com ([45.249.212.189]:7935 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750805AbdFXFyu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 24 Jun 2017 01:54:50 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com

If an "impure && not merged" upper dir have left whiteouts
(last mount created), ovl cannot clear this dir when we
removing it, which may lead to rmdir fail or temp file left
in workdir.

Simple reproducer:
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

This patch add explicitly check of OVL_XATTR_ORIGIN, use
(merge || origin) to indicate the dir may have whiteouts.
Finally, check and clean up the dir when deleting it.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>

---
V3:
 - use origin instead of impure flag
 - add check in ovl_rename()

V2:
 - fix comment in ovl_remove_and_whiteout()
 - post reproducer to xfstest

---
 fs/overlayfs/dir.c       | 20 ++++++++++++++++----
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/util.c      | 13 +++++++++++++
 3 files changed, 30 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index a63a716..cbad42f 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -178,6 +178,14 @@ static bool ovl_type_origin(struct dentry *dentry)
 	return OVL_TYPE_ORIGIN(ovl_path_type(dentry));
 }
 
+static bool ovl_is_origin(struct dentry *dentry)
+{
+	if (!OVL_TYPE_UPPER(ovl_path_type(dentry)))
+		return false;
+
+	return ovl_check_origin_xattr(ovl_dentry_upper(dentry));
+}
+
 static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 			    struct cattr *attr, struct dentry *hardlink)
 {
@@ -331,12 +339,14 @@ static struct dentry *ovl_check_empty_and_clear(struct dentry *dentry)
 	 * replace it with an exact replica of itself.
 	 *
 	 * If no upperdentry then skip clearing whiteouts.
+	 * Origined directory may have whiteouts, should clean up.
 	 *
 	 * Can race with copy-up, since we don't hold the upperdir mutex.
 	 * Doesn't matter, since copy-up can't create a non-empty directory
 	 * from an empty one.
 	 */
-	if (OVL_TYPE_UPPER(type) && OVL_TYPE_MERGE(type))
+	if (OVL_TYPE_UPPER(type) && (OVL_TYPE_MERGE(type) ||
+				     ovl_is_origin(dentry)))
 		ret = ovl_clear_empty(dentry, &list);
 
 out_free:
@@ -690,8 +700,9 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 	struct dentry *opaquedir = NULL;
 	int err;
 
-	/* Redirect dir can be !ovl_lower_positive && OVL_TYPE_MERGE */
-	if (is_dir && ovl_dentry_get_redirect(dentry)) {
+	/* Redirect/origined dir can be !ovl_lower_positive && not clean */
+	if (is_dir && (ovl_dentry_get_redirect(dentry) ||
+		       ovl_is_origin(dentry))) {
 		opaquedir = ovl_check_empty_and_clear(dentry);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir))
@@ -930,7 +941,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 
 	old_cred = ovl_override_creds(old->d_sb);
 
-	if (overwrite && new_is_dir && ovl_type_merge_or_lower(new)) {
+	if (overwrite && new_is_dir && (ovl_type_merge_or_lower(new) ||
+					ovl_is_origin(new))) {
 		opaquedir = ovl_check_empty_and_clear(new);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir)) {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 0623cebe..b518a23 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -220,6 +220,7 @@ void ovl_inode_init(struct inode *inode, struct inode *realinode,
 struct file *ovl_path_open(struct path *path, int flags);
 int ovl_copy_up_start(struct dentry *dentry);
 void ovl_copy_up_end(struct dentry *dentry);
+bool ovl_check_origin_xattr(struct dentry *dentry);
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name);
 int ovl_check_setxattr(struct dentry *dentry, struct dentry *upperdentry,
 		       const char *name, const void *value, size_t size,
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 8090489..57b7ba9 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -304,6 +304,19 @@ void ovl_copy_up_end(struct dentry *dentry)
 	spin_unlock(&ofs->copyup_wq.lock);
 }
 
+bool ovl_check_origin_xattr(struct dentry *dentry)
+{
+	int res;
+
+	res = vfs_getxattr(dentry, OVL_XATTR_ORIGIN, NULL, 0);
+
+	/* Zero size value means "copied up but origin unknown" */
+	if (res >= 0)
+		return true;
+
+	return false;
+}
+
 bool ovl_check_dir_xattr(struct dentry *dentry, const char *name)
 {
 	int res;
-- 
1.8.3.1
