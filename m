Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from out30-43.freemail.mail.aliyun.com ([115.124.30.43]:36377 "EHLO
        out30-43.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725827AbfEFL5X (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 6 May 2019 07:57:23 -0400
From: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Subject: [PATCH v2] overlayfs: check the capability before cred overridden
Date: Mon,  6 May 2019 19:57:19 +0800
Message-Id: <20190506115719.123863-1-jiufei.xue@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, joseph.qi@linux.alibaba.com
List-ID: <linux-unionfs@vger.kernel.org>

We found that it return success when we set IMMUTABLE_FL flag to a
file in docker even though the docker didn't have the capability
CAP_LINUX_IMMUTABLE.

The commit d1d04ef8572b ("ovl: stack file ops") and
dab5ca8fd9dd ("ovl: add lsattr/chattr support") implemented chattr
operations on a regular overlay file. ovl_real_ioctl() overridden the
current process's subjective credentials with ofs->creator_cred which
have the capability CAP_LINUX_IMMUTABLE so that it will return success
in vfs_ioctl()->cap_capable().

Fix this by checking the capability before cred overriden. And here we
only care about APPEND_FL and IMMUTABLE_FL, so get these information from
inode.

Changes since v1:
 - remove S_DIRSYNC since ovl_copyflags() does not copy FS_DIRSYNC_FL,
   pointed out by Amir Goldstein.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/overlayfs/file.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 84dd957efa24..b5aee3c12579 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -11,6 +11,7 @@
 #include <linux/mount.h>
 #include <linux/xattr.h>
 #include <linux/uio.h>
+#include <linux/uaccess.h>
 #include "overlayfs.h"
 
 static char ovl_whatisit(struct inode *inode, struct inode *realinode)
@@ -372,10 +373,28 @@ static long ovl_real_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
+static unsigned int ovl_get_inode_flags(struct inode *inode)
+{
+	unsigned int flags = inode->i_flags;
+	unsigned int ovl_iflags = 0;
+
+	if (flags & S_SYNC)
+		ovl_iflags |= FS_SYNC_FL;
+	if (flags & S_APPEND)
+		ovl_iflags |= FS_APPEND_FL;
+	if (flags & S_IMMUTABLE)
+		ovl_iflags |= FS_IMMUTABLE_FL;
+	if (flags & S_NOATIME)
+		ovl_iflags |= FS_NOATIME_FL;
+
+	return ovl_iflags;
+}
+
 static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
+	unsigned int flags;
 
 	switch (cmd) {
 	case FS_IOC_GETFLAGS:
@@ -386,6 +405,15 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		if (!inode_owner_or_capable(inode))
 			return -EACCES;
 
+		if (get_user(flags, (int __user *) arg))
+			return -EFAULT;
+
+		/* Check the capability before cred overridden */
+		if ((flags ^ ovl_get_inode_flags(inode)) & (FS_APPEND_FL | FS_IMMUTABLE_FL)) {
+			if (!capable(CAP_LINUX_IMMUTABLE))
+				return -EPERM;
+		}
+
 		ret = mnt_want_write_file(file);
 		if (ret)
 			return ret;
-- 
2.19.1.856.g8858448bb
