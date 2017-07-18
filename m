From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/2] ovl: check for bad and whiteout index on lookup
Date: Tue, 18 Jul 2017 21:07:43 +0300
Message-ID: <1500401263-25562-3-git-send-email-amir73il@gmail.com>
References: <1500401263-25562-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:34957 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbdGRSHh (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 18 Jul 2017 14:07:37 -0400
Received: by mail-wr0-f194.google.com with SMTP id c24so1781202wra.2
        for <linux-unionfs@vger.kernel.org>; Tue, 18 Jul 2017 11:07:36 -0700 (PDT)
In-Reply-To: <1500401263-25562-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Index should always be of the same file type as origin, except for
the case of a whiteout index.  A whiteout index should only exist
if all lower aliases have been unlinked, which means that finding
a lower origin on lookup whose index is a whiteout should be treated
as a lookup error.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/namei.c | 22 +++++++++++++++++-----
 1 file changed, 17 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
index 229a88ff335c..8aef2b304b2d 100644
--- a/fs/overlayfs/namei.c
+++ b/fs/overlayfs/namei.c
@@ -513,6 +513,7 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 		goto out;
 	}
 
+	inode = d_inode(index);
 	if (d_is_negative(index)) {
 		if (upper && d_inode(origin)->i_nlink > 1) {
 			pr_warn_ratelimited("overlayfs: hard link with origin but no index (ino=%lu).\n",
@@ -522,11 +523,22 @@ static struct dentry *ovl_lookup_index(struct dentry *dentry,
 
 		dput(index);
 		index = NULL;
-	} else if (upper && d_inode(index) != d_inode(upper)) {
-		inode = d_inode(index);
-		pr_warn_ratelimited("overlayfs: wrong index found (index ino: %lu, upper ino: %lu).\n",
-				    d_inode(index)->i_ino,
-				    d_inode(upper)->i_ino);
+	} else if (upper && d_inode(upper) != inode) {
+		pr_warn_ratelimited("overlayfs: wrong index found (index=%pd2, ino=%lu, upper ino=%lu).\n",
+				    index, inode->i_ino, d_inode(upper)->i_ino);
+		goto fail;
+	} else if (ovl_dentry_weird(index) || ovl_is_whiteout(index) ||
+		   ((inode->i_mode ^ d_inode(origin)->i_mode) & S_IFMT)) {
+		/*
+		 * Index should always be of the same file type as origin
+		 * except for the case of a whiteout index. A whiteout
+		 * index should only exist if all lower aliases have been
+		 * unlinked, which means that finding a lower origin on lookup
+		 * whose index is a whiteout should be treated as an error.
+		 */
+		pr_warn_ratelimited("overlayfs: bad index found (index=%pd2, ftype=%x, origin ftype=%x).\n",
+				    index, d_inode(index)->i_mode & S_IFMT,
+				    d_inode(origin)->i_mode & S_IFMT);
 		goto fail;
 	}
 
-- 
2.7.4
