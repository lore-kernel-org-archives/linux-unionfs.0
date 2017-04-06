From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/4] vfs: ftruncate check IS_APPEND() on backing inode
Date: Thu,  6 Apr 2017 11:13:47 +0300
Message-ID: <1491466429-30333-3-git-send-email-amir73il@gmail.com>
References: <1491466429-30333-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f196.google.com ([209.85.128.196]:35015 "EHLO
        mail-wr0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752189AbdDFINs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 6 Apr 2017 04:13:48 -0400
In-Reply-To: <1491466429-30333-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

ftruncate an overlayfs inode was checking IS_APPEND() on
overlay inode, but overlay inode does not have the S_APPEND
flag and IS_APPEND() is always checked on backing inode in
other places.

Set 'inode' var to file_inode() so all checks are performed on
backing inode and use locks_inode() explicitly for calling
locks_verify_truncate().

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/open.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index 53b1b33..0e3c12b 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -165,7 +165,6 @@ COMPAT_SYSCALL_DEFINE2(truncate, const char __user *, path, compat_off_t, length
 static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 {
 	struct inode *inode;
-	struct dentry *dentry;
 	struct fd f;
 	int error;
 
@@ -181,8 +180,7 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 	if (f.file->f_flags & O_LARGEFILE)
 		small = 0;
 
-	dentry = f.file->f_path.dentry;
-	inode = dentry->d_inode;
+	inode = file_inode(f.file);
 	error = -EINVAL;
 	if (!S_ISREG(inode->i_mode) || !(f.file->f_mode & FMODE_WRITE))
 		goto out_putf;
@@ -197,11 +195,12 @@ static long do_sys_ftruncate(unsigned int fd, loff_t length, int small)
 		goto out_putf;
 
 	file_start_write(f.file);
-	error = locks_verify_truncate(inode, f.file, length);
+	error = locks_verify_truncate(locks_inode(f.file), f.file, length);
 	if (!error)
 		error = security_path_truncate(&f.file->f_path);
 	if (!error)
-		error = do_truncate(dentry, length, ATTR_MTIME|ATTR_CTIME, f.file);
+		error = do_truncate(f.file->f_path.dentry, length,
+				    ATTR_MTIME|ATTR_CTIME, f.file);
 	file_end_write(f.file);
 out_putf:
 	fdput(f);
-- 
2.7.4
