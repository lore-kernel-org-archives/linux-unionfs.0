From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 3/4] vfs: truncate check IS_APPEND() on backing inode
Date: Thu,  6 Apr 2017 11:13:48 +0300
Message-ID: <1491466429-30333-4-git-send-email-amir73il@gmail.com>
References: <1491466429-30333-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33657 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751764AbdDFINu (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Apr 2017 04:13:50 -0400
In-Reply-To: <1491466429-30333-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

truncate an overlayfs inode was checking IS_APPEND() on
overlay inode, but overlay inode does not have the S_APPEND
flag and IS_APPEND() is always checked on backing inode in
other places.

Move the IS_APPEND() check to after we have the upperdentry
and use the d_backing_inode() macro to explicitly highlight
the places where the backing inode is used.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/open.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 0e3c12b..baf67cd 100644
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
+	if (IS_APPEND(d_backing_inode(upperdentry)))
+		goto mnt_drop_write_and_out;
+
+	error = get_write_access(d_backing_inode(upperdentry));
 	if (error)
 		goto mnt_drop_write_and_out;
 
@@ -120,7 +120,7 @@ long vfs_truncate(const struct path *path, loff_t length)
 		error = do_truncate(path->dentry, length, 0, NULL);
 
 put_write_and_out:
-	put_write_access(upperdentry->d_inode);
+	put_write_access(d_backing_inode(upperdentry));
 mnt_drop_write_and_out:
 	mnt_drop_write(path->mnt);
 out:
-- 
2.7.4
