Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2] vfs: fix FIGETBSZ ioctl on an overlayfs file
Date: Thu, 11 Oct 2018 17:38:14 +0300
Message-Id: <20181011143814.14296-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Some anon_bdev filesystems (e.g. overlayfs, ceph) don't have s_blocksize
set. Returning zero from FIGETBSZ ioctl results in a Floating point
exception from the e2fsprogs utility filefrag, which divides the size of
the file with the value returned by FIGETBSZ.

Fix the interface by returning -EINVAL for these filesystems.

Fixes: d1d04ef8572b ("ovl: stack file ops")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/ioctl.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2005529af560..0400297c8d72 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -669,6 +669,9 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		return ioctl_fiemap(filp, arg);
 
 	case FIGETBSZ:
+		/* anon_bdev filesystems may not have a block size */
+		if (!inode->i_sb->s_blocksize)
+			return -EINVAL;
 		return put_user(inode->i_sb->s_blocksize, argp);
 
 	case FICLONE:
-- 
2.17.1
