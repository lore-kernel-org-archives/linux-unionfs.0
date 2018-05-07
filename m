From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 18/35] ovl: add lsattr/chattr support
Date: Mon,  7 May 2018 10:37:50 +0200
Message-ID: <20180507083807.28792-19-mszeredi@redhat.com>
References: <20180507083807.28792-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507083807.28792-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Implement FS_IOC_GETFLAGS and FS_IOC_SETFLAGS.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 3a85bbfa266a..2028f6886649 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -8,6 +8,7 @@
 
 #include <linux/cred.h>
 #include <linux/file.h>
+#include <linux/mount.h>
 #include <linux/xattr.h>
 #include <linux/uio.h>
 #include "overlayfs.h"
@@ -302,6 +303,82 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 	return ret;
 }
 
+static long ovl_real_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct fd real;
+	const struct cred *old_cred;
+	long ret;
+
+	ret = ovl_real_fdget(file, &real);
+	if (ret)
+		return ret;
+
+	old_cred = ovl_override_creds(file_inode(file)->i_sb);
+	ret = vfs_ioctl(real.file, cmd, arg);
+	revert_creds(old_cred);
+
+	fdput(real);
+
+	return ret;
+}
+
+static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	long ret;
+	struct inode *inode = file_inode(file);
+
+	switch (cmd) {
+	case FS_IOC_GETFLAGS:
+		ret = ovl_real_ioctl(file, cmd, arg);
+		break;
+
+	case FS_IOC_SETFLAGS:
+		if (!inode_owner_or_capable(inode))
+			return -EACCES;
+
+		ret = mnt_want_write_file(file);
+		if (ret)
+			return ret;
+
+		ret = ovl_copy_up(file_dentry(file));
+		if (!ret) {
+			ret = ovl_real_ioctl(file, cmd, arg);
+
+			inode_lock(inode);
+			ovl_copyflags(ovl_inode_real(inode), inode);
+			inode_unlock(inode);
+		}
+
+		mnt_drop_write_file(file);
+		break;
+
+	default:
+		ret = -ENOTTY;
+	}
+
+	return ret;
+}
+
+static long ovl_compat_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	switch (cmd) {
+	case FS_IOC32_GETFLAGS:
+		cmd = FS_IOC_GETFLAGS;
+		break;
+
+	case FS_IOC32_SETFLAGS:
+		cmd = FS_IOC_SETFLAGS;
+		break;
+
+	default:
+		return -ENOIOCTLCMD;
+	}
+
+	return ovl_ioctl(file, cmd, arg);
+}
+
 const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 	.release	= ovl_release,
@@ -311,4 +388,6 @@ const struct file_operations ovl_file_operations = {
 	.fsync		= ovl_fsync,
 	.mmap		= ovl_mmap,
 	.fallocate	= ovl_fallocate,
+	.unlocked_ioctl	= ovl_ioctl,
+	.compat_ioctl	= ovl_compat_ioctl,
 };
-- 
2.14.3
