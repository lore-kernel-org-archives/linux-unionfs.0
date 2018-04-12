From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 16/35] ovl: readd lsattr/chattr support
Date: Thu, 12 Apr 2018 17:08:07 +0200
Message-ID: <20180412150826.20988-17-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Implement FS_IOC_GETFLAGS and FS_IOC_SETFLAGS.

Needs vfs_ioctl() exported to modules.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/internal.h       |  1 -
 fs/ioctl.c          |  1 +
 fs/overlayfs/file.c | 59 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h  |  2 ++
 4 files changed, 62 insertions(+), 1 deletion(-)

diff --git a/fs/internal.h b/fs/internal.h
index 3319bf39e339..d5108d9c6a2f 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -176,7 +176,6 @@ extern const struct dentry_operations ns_dentry_operations;
  */
 extern int do_vfs_ioctl(struct file *file, unsigned int fd, unsigned int cmd,
 		    unsigned long arg);
-extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 /*
  * iomap support:
diff --git a/fs/ioctl.c b/fs/ioctl.c
index 5ace7efb0d04..696f4c46a868 100644
--- a/fs/ioctl.c
+++ b/fs/ioctl.c
@@ -49,6 +49,7 @@ long vfs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
  out:
 	return error;
 }
+EXPORT_SYMBOL(vfs_ioctl);
 
 static int ioctl_fibmap(struct file *filp, int __user *p)
 {
diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 05e3e2f80b89..cc004ff1b05b 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -8,6 +8,7 @@
 
 #include <linux/cred.h>
 #include <linux/file.h>
+#include <linux/mount.h>
 #include <linux/xattr.h>
 #include <linux/uio.h>
 #include "overlayfs.h"
@@ -291,6 +292,63 @@ long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	return ret;
 }
 
+static long ovl_real_ioctl(struct file *file, unsigned int cmd,
+			   unsigned long arg)
+{
+	struct fd real;
+	const struct cred *old_cred;
+	long ret;
+
+	ret = ovl_real_file(file, &real);
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
+long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
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
 const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 	.release	= ovl_release,
@@ -300,4 +358,5 @@ const struct file_operations ovl_file_operations = {
 	.fsync		= ovl_fsync,
 	.mmap		= ovl_mmap,
 	.fallocate	= ovl_fallocate,
+	.unlocked_ioctl	= ovl_ioctl,
 };
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 0b215faa30ae..1add10f04b56 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1621,6 +1621,8 @@ int vfs_mkobj(struct dentry *, umode_t,
 		int (*f)(struct dentry *, umode_t, void *),
 		void *);
 
+extern long vfs_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+
 /*
  * VFS file helper functions.
  */
-- 
2.14.3
