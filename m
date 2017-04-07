From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 2/3] vfs: truncate check IS_APPEND() on real inode
Date: Fri,  7 Apr 2017 12:01:40 +0300
Message-ID: <1491555701-16608-3-git-send-email-amir73il@gmail.com>
References: <1491555701-16608-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35056 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756059AbdDGJBm (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 7 Apr 2017 05:01:42 -0400
In-Reply-To: <1491555701-16608-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

truncate an overlayfs inode was checking IS_APPEND() on
overlay inode, but overlay inode does not have the S_APPEND flag.

Move the IS_APPEND() check to after we have the upperdentry
and pass it the real upper inode.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/open.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index b7d5ab1..425db52 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -87,10 +87,6 @@ long vfs_truncate(const struct path *path, loff_t length)
 	if (error)
 		goto mnt_drop_write_and_out;
 
-	error = -EPERM;
-	if (IS_APPEND(inode))
-		goto mnt_drop_write_and_out;
-
 	/*
 	 * If this is an overlayfs then do as if opening the file so we get
 	 * write access on the upper inode, not on the overlay inode.  For
@@ -101,7 +97,11 @@ long vfs_truncate(const struct path *path, loff_t length)
 	if (IS_ERR(upperdentry))
 		goto mnt_drop_write_and_out;
 
-	error = get_write_access(upperdentry->d_inode);
+	error = -EPERM;
+	if (IS_APPEND(d_inode(upperdentry)))
+		goto mnt_drop_write_and_out;
+
+	error = get_write_access(d_inode(upperdentry));
 	if (error)
 		goto mnt_drop_write_and_out;
 
@@ -120,7 +120,7 @@ long vfs_truncate(const struct path *path, loff_t length)
 		error = do_truncate(path->dentry, length, 0, NULL);
 
 put_write_and_out:
-	put_write_access(upperdentry->d_inode);
+	put_write_access(d_inode(upperdentry));
 mnt_drop_write_and_out:
 	mnt_drop_write(path->mnt);
 out:
-- 
2.7.4
