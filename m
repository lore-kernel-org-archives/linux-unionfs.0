From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 16/23] ovl: cleanup dir index when dir nlink drops to zero
Date: Thu,  4 Jan 2018 18:40:11 +0200
Message-ID: <1515084018-25134-17-git-send-email-amir73il@gmail.com>
References: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:38558 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753512AbeADQjr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:47 -0500
Received: by mail-wr0-f196.google.com with SMTP id y9so2016258wrb.5
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:46 -0800 (PST)
In-Reply-To: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

When non-dir index union nlink drops to zero the non-dir index
is cleaned. Do the same for directory type index entries when
union directory is removed.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/util.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 35a49a1fe3e7..7b54b4ecab3b 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -518,7 +518,7 @@ static void ovl_cleanup_index(struct dentry *dentry)
 		goto fail;
 
 	inode = d_inode(upperdentry);
-	if (inode->i_nlink != 1) {
+	if (!S_ISDIR(inode->i_mode) && inode->i_nlink != 1) {
 		pr_warn_ratelimited("overlayfs: cleanup linked index (%pd2, ino=%lu, nlink=%u)\n",
 				    upperdentry, inode->i_ino, inode->i_nlink);
 		/*
@@ -567,7 +567,7 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 	const struct cred *old_cred;
 	int err;
 
-	if (!d_inode(dentry) || d_is_dir(dentry))
+	if (!d_inode(dentry))
 		return 0;
 
 	/*
@@ -594,7 +594,7 @@ int ovl_nlink_start(struct dentry *dentry, bool *locked)
 	if (err)
 		return err;
 
-	if (!ovl_test_flag(OVL_INDEX, d_inode(dentry)))
+	if (d_is_dir(dentry) || !ovl_test_flag(OVL_INDEX, d_inode(dentry)))
 		goto out;
 
 	old_cred = ovl_override_creds(dentry->d_sb);
-- 
2.7.4
