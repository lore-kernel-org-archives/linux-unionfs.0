From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/4] vfs: ftruncate freeze protect backing inode
Date: Thu,  6 Apr 2017 11:13:46 +0300
Message-ID: <1491466429-30333-2-git-send-email-amir73il@gmail.com>
References: <1491466429-30333-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:33612 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751713AbdDFINr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Apr 2017 04:13:47 -0400
In-Reply-To: <1491466429-30333-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

ftruncate an overlayfs inode was wrongly freeze protecting the
overlay file system instead of the backing file system.

Use file_start_write() instead of sb_start_write(), which
does the right thing and will also freeze protect both overlay and
backing fs when the time comes.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/open.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 949cef2..53b1b33 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -196,13 +196,13 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (IS_APPEND(inode))
 		goto out_putf;
 
-	sb_start_write(inode->i_sb);
+	file_start_write(f.file);
 	error = locks_verify_truncate(inode, f.file, length);
 	if (!error)
 		error = security_path_truncate(&f.file->f_path);
 	if (!error)
 		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, f.file);
-	sb_end_write(inode->i_sb);
+	file_end_write(f.file);
 out_putf:
 	fdput(f);
 out:
-- 
2.7.4
