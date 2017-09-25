From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/4] ovl: fix may_write_real() for overlayfs directories
Date: Mon, 25 Sep 2017 12:36:18 +0300
Message-ID: <1506332181-19319-2-git-send-email-amir73il@gmail.com>
References: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33709 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934391AbdIYJfw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 25 Sep 2017 05:35:52 -0400
Received: by mail-wr0-f193.google.com with SMTP id b9so1615481wra.0
        for <linux-unionfs@vger.kernel.org>; Mon, 25 Sep 2017 02:35:51 -0700 (PDT)
In-Reply-To: <1506332181-19319-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Overlayfs directory file_inode() is the overlay inode whether the real
inode is upper or lower.

This fixes a regression in xfstest generic/158.

Fixes: 7c6893e3c9ab ("ovl: don't allow writing ioctl on lower layer")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/namespace.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/namespace.c b/fs/namespace.c
index 54059b142d6b..3b601f115b6c 100644
--- a/fs/namespace.c
+++ b/fs/namespace.c
@@ -468,7 +468,9 @@ static inline int may_write_real(struct file *file)
 
 	/* File refers to upper, writable layer? */
 	upperdentry = d_real(dentry, NULL, 0, D_REAL_UPPER);
-	if (upperdentry && file_inode(file) == d_inode(upperdentry))
+	if (upperdentry &&
+	    (file_inode(file) == d_inode(upperdentry) ||
+	     file_inode(file) == d_inode(dentry)))
 		return 0;
 
 	/* Lower layer: can't write to real file, sorry... */
-- 
2.7.4
