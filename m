From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 08/11] ovl: cleanup dir index when dir nlink drops to zero
Date: Tue, 17 Oct 2017 19:00:19 +0300
Message-ID: <1508256022-10267-9-git-send-email-amir73il@gmail.com>
References: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:51967 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934507AbdJQP77 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:59:59 -0400
Received: by mail-wm0-f65.google.com with SMTP id f4so4945291wme.0
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:59:58 -0700 (PDT)
In-Reply-To: <1508256022-10267-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

When non-dir index union nlink drops to zero the non-dir index
is cleaned. Do the same for directory type index entries when
union directory is removed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 3cd16bc20fcd..22cdf9ecd7ec 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -466,7 +466,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 		goto fail;
 
 	inode = d_inode(upperdentry);
-	if (inode->i_nlink != 1) {
+	if (!S_ISDIR(inode->i_mode) && inode->i_nlink != 1) {
 		pr_warn_ratelimited("overlayfs: cleanup linked index (%pd2, ino=%lu, nlink=%u)\n",
 				    upperdentry, inode->i_ino, inode->i_nlink);
 		/*
@@ -537,7 +537,7 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 	const struct cred *old_cred;
 	int err;
 
-	if (!d_inode(dentry) || d_is_dir(dentry))
+	if (!d_inode(dentry))
 		return 0;
 
 	/*
@@ -564,7 +564,7 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 	if (err)
 		return err;
 
-	if (!ovl_test_flag(OVL_INDEX, d_inode(dentry)))
+	if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 		goto out;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
-- 
2.7.4
