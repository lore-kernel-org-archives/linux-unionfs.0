From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] vfs: fix may_write_real() for overlayfs directories
Date: Mon, 18 Sep 2017 23:21:47 +0300
Message-ID: <1505766107-15205-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35216 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750711AbdIRUVN (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 18 Sep 2017 16:21:13 -0400
Received: by mail-wm0-f66.google.com with SMTP id e64so1982962wmi.2
        for <linux-unionfs@vger.kernel.org>; Mon, 18 Sep 2017 13:21:12 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Eryu Guan <eguan@redhat.com>, linux-unionfs@vger.kernel.org

Overlayfs directory file_inode() is the overlay inode whether the real
inode is upper or lower.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

This is a correctness fix.
I only noticed it because may_write_real() change broke xfstest generic/158.
The test tries to dedupe a directory, expects EINVAL and gets EPERM on
overlayfs instead.

I am not sure if there are cases where this incorrectness could lead to
EPERM when directory is upper and operation on dir should succeed.

Amir.


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
