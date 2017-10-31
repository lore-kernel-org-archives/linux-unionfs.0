From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 3/3] ovl: fix rmdir problem on non-merge dir with origin xattr
Date: Tue, 31 Oct 2017 23:45:50 +0200
Message-ID: <1509486350-21362-4-git-send-email-amir73il@gmail.com>
References: <1509486350-21362-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:57010 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932584AbdJaVpO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Oct 2017 17:45:14 -0400
Received: by mail-wm0-f67.google.com with SMTP id z3so1540684wme.5
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Oct 2017 14:45:13 -0700 (PDT)
In-Reply-To: <1509486350-21362-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

An "origin && non-merge" upper dir may have leftover whiteouts that
were created in past mount. overlayfs does no clear this dir when we
delete it, which may lead to rmdir fail or temp file left in workdir.

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

(*): if we do not create the regular file, the result is different:
  rm: cannot remove "dir/": Directory not empty

This patch adds a check for the case of non-merge dir that may contain
whiteouts, and calls ovl_check_empty_dir() to check and clear whiteouts
from upper dir when an empty dir is being deleted.

Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/dir.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 4edef400fe51..ef533198be45 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -181,6 +181,11 @@ static bool ovl_type_origin(struct dentry *dentry)
 	return OVL_TYPE_ORIGIN(ovl_path_type(dentry));
 }
 
+static bool ovl_may_have_whiteouts(struct dentry *dentry)
+{
+	return ovl_test_flag(OVL_WHITEOUTS, d_inode(dentry));
+}
+
 static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
 			    struct cattr *attr, struct dentry *hardlink)
 {
@@ -697,8 +702,9 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
 	struct dentry *opaquedir = NULL;
 	int err;
 
-	/* Redirect dir can be !ovl_lower_positive && OVL_TYPE_MERGE */
-	if (is_dir && ovl_dentry_get_redirect(dentry)) {
+	/* Redirect/origin dir can be !ovl_lower_positive && not clean */
+	if (is_dir && (ovl_dentry_get_redirect(dentry) ||
+		       ovl_may_have_whiteouts(dentry))) {
 		opaquedir = ovl_check_empty_and_clear(dentry);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir))
@@ -945,7 +951,8 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
 
 	old_cred = ovl_override_creds(old->d_sb);
 
-	if (overwrite && new_is_dir && ovl_type_merge_or_lower(new)) {
+	if (overwrite && new_is_dir && (ovl_type_merge_or_lower(new) ||
+					ovl_may_have_whiteouts(new))) {
 		opaquedir = ovl_check_empty_and_clear(new);
 		err = PTR_ERR(opaquedir);
 		if (IS_ERR(opaquedir)) {
-- 
2.7.4
