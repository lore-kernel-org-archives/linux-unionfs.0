Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] vfs: fix FIGETBSZ ioctl on an overlayfs file
Date: Thu, 11 Oct 2018 14:24:01 +0300
Message-Id: <20181011112401.5790-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Eryu Guan <guaneryu@gmail.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Implement the FIGETBSZ query with the statfs(2) filesystem
interface. Reading inode->i_sb->s_blocksize directly is incorrect
on stacked filesystems (i.e. overlayfs).

This fixes a Floating point exception in e2fsprogs utility filefrag,
which divides the size of the file with the value returned by FIGETBSZ.

Fixes: d1d04ef8572b ("ovl: stack file ops")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Consider this for-rc8?
There is another trivial kfree(ERR_PTR()) fix I posted yesterday.

xfstests actually has coverage for FIGETBSZ with fiemap-tester
program. However, the tests that use fiemap-tester (generic/094
generic/225) did not fail on v4.19-rc1, but rather thier runtime
dropped from > 10s to 0s, so I'll need to go fix those tests.

Thanks,
Amir.

 fs/ioctl.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/ioctl.c b/fs/ioctl.c
index 2005529af560..a0e55a8e94fd 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -17,6 +17,7 @@
 #include <linux/buffer_head.h>
 #include <linux/falloc.h>
 #include <linux/sched/signal.h>
+#include <linux/statfs.h>
 
 #include "internal.h"
 
@@ -219,6 +220,18 @@ static int ioctl_fiemap(struct file *filp, unsigned long arg)
 	return error;
 }
 
+static int ioctl_getbsize(struct file *file, int __user *argp)
+{
+	struct kstatfs buf;
+	int err;
+
+	err = vfs_statfs(&file->f_path, &buf);
+	if (err)
+		return err;
+
+	return put_user(buf.f_bsize, argp);
+}
+
 static long ioctl_file_clone(struct file *dst_file, unsigned long srcfd,
 			     u64 off, u64 olen, u64 destoff)
 {
@@ -669,7 +682,7 @@ int do_vfs_ioctl(struct file *filp, unsigned int fd, unsigned int cmd,
 		return ioctl_fiemap(filp, arg);
 
 	case FIGETBSZ:
-		return put_user(inode->i_sb->s_blocksize, argp);
+		return ioctl_getbsize(filp, argp);
 
 	case FICLONE:
 		return ioctl_file_clone(filp, arg, 0, 0, 0);
-- 
2.17.1
