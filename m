From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 1/5] vfs: deny fallocate() on directory
Date: Tue, 31 Jan 2017 10:34:55 +0200
Message-ID: <1485851699-25313-2-git-send-email-amir73il@gmail.com>
References: <1485851699-25313-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f195.google.com ([209.85.210.195]:34176 "EHLO
        mail-wj0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750776AbdAaIf2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jan 2017 03:35:28 -0500
In-Reply-To: <1485851699-25313-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org

There was an obscure use case of fallocate of directory inode
in the vfs helper with the comment:
"Let individual file system decide if it supports preallocation
 for directories or not."

But there is no in-tree file system that implements fallocate
for directory operations.

Deny an attempt to fallocate a directory with EISDIR error.

This change is needed prior to converting sb_start_write()
to  file_start_write(), so freeze protection is correctly
handled for cases of fallocate file and blockdev.

Cc: linux-api@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/open.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 9921f70..f9118f4 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -301,12 +301,10 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (S_ISFIFO(inode->i_mode))
 		return -ESPIPE;
 
-	/*
-	 * Let individual file system decide if it supports preallocation
-	 * for directories or not.
-	 */
-	if (!S_ISREG(inode->i_mode) && !S_ISDIR(inode->i_mode) &&
-	    !S_ISBLK(inode->i_mode))
+	if (S_ISDIR(inode->i_mode))
+		return -EISDIR;
+
+	if (!S_ISREG(inode->i_mode) && !S_ISBLK(inode->i_mode))
 		return -ENODEV;
 
 	/* Check for wrap through zero too */
-- 
2.7.4
