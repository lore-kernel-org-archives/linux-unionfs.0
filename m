Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 2/4] ovl: use generic vfs_ioc_setflags_prepare() helper
Date: Mon, 15 Jul 2019 16:38:37 +0300
Message-Id: <20190715133839.9878-3-amir73il@gmail.com>
In-Reply-To: <20190715133839.9878-1-amir73il@gmail.com>
References: <20190715133839.9878-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Canonalize to ioctl FS_* flags instead of inode S_* flags.

Note that we do not call the helper vfs_ioc_fssetxattr_check()
for FS_IOC_FSSETXATTR ioctl. The reason is that underlying filesystem
will perform all the checks. We only need to perform the capability
check before overriding credentials.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 62 ++++++++++++++++++++++-----------------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index c6426e4d3f1f..1ba40845fba0 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -406,12 +406,28 @@ static long ovl_real_ioctl(struct file *file, unsigned int cmd,
 	return ret;
 }
 
+static unsigned int ovl_iflags_to_fsflags(unsigned int iflags)
+{
+	unsigned int flags = 0;
+
+	if (iflags & S_SYNC)
+		flags |= FS_SYNC_FL;
+	if (iflags & S_APPEND)
+		flags |= FS_APPEND_FL;
+	if (iflags & S_IMMUTABLE)
+		flags |= FS_IMMUTABLE_FL;
+	if (iflags & S_NOATIME)
+		flags |= FS_NOATIME_FL;
+
+	return flags;
+}
+
 static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
-				unsigned long arg, unsigned int iflags)
+				unsigned long arg, unsigned int flags)
 {
 	long ret;
 	struct inode *inode = file_inode(file);
-	unsigned int old_iflags;
+	unsigned int oldflags;
 
 	if (!inode_owner_or_capable(inode))
 		return -EACCES;
@@ -423,10 +439,9 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
 	inode_lock(inode);
 
 	/* Check the capability before cred override */
-	ret = -EPERM;
-	old_iflags = READ_ONCE(inode->i_flags);
-	if (((iflags ^ old_iflags) & (S_APPEND | S_IMMUTABLE)) &&
-	    !capable(CAP_LINUX_IMMUTABLE))
+	oldflags = ovl_iflags_to_fsflags(READ_ONCE(inode->i_flags));
+	ret = vfs_ioc_setflags_prepare(inode, oldflags, flags);
+	if (ret)
 		goto unlock;
 
 	ret = ovl_maybe_copy_up(file_dentry(file), O_WRONLY);
@@ -445,22 +460,6 @@ static long ovl_ioctl_set_flags(struct file *file, unsigned int cmd,
 
 }
 
-static unsigned int ovl_fsflags_to_iflags(unsigned int flags)
-{
-	unsigned int iflags = 0;
-
-	if (flags & FS_SYNC_FL)
-		iflags |= S_SYNC;
-	if (flags & FS_APPEND_FL)
-		iflags |= S_APPEND;
-	if (flags & FS_IMMUTABLE_FL)
-		iflags |= S_IMMUTABLE;
-	if (flags & FS_NOATIME_FL)
-		iflags |= S_NOATIME;
-
-	return iflags;
-}
-
 static long ovl_ioctl_set_fsflags(struct file *file, unsigned int cmd,
 				  unsigned long arg)
 {
@@ -469,24 +468,23 @@ static long ovl_ioctl_set_fsflags(struct file *file, unsigned int cmd,
 	if (get_user(flags, (int __user *) arg))
 		return -EFAULT;
 
-	return ovl_ioctl_set_flags(file, cmd, arg,
-				   ovl_fsflags_to_iflags(flags));
+	return ovl_ioctl_set_flags(file, cmd, arg, flags);
 }
 
-static unsigned int ovl_fsxflags_to_iflags(unsigned int xflags)
+static unsigned int ovl_fsxflags_to_fsflags(unsigned int xflags)
 {
-	unsigned int iflags = 0;
+	unsigned int flags = 0;
 
 	if (xflags & FS_XFLAG_SYNC)
-		iflags |= S_SYNC;
+		flags |= FS_SYNC_FL;
 	if (xflags & FS_XFLAG_APPEND)
-		iflags |= S_APPEND;
+		flags |= FS_APPEND_FL;
 	if (xflags & FS_XFLAG_IMMUTABLE)
-		iflags |= S_IMMUTABLE;
+		flags |= FS_IMMUTABLE_FL;
 	if (xflags & FS_XFLAG_NOATIME)
-		iflags |= S_NOATIME;
+		flags |= FS_NOATIME_FL;
 
-	return iflags;
+	return flags;
 }
 
 static long ovl_ioctl_set_fsxflags(struct file *file, unsigned int cmd,
@@ -499,7 +497,7 @@ static long ovl_ioctl_set_fsxflags(struct file *file, unsigned int cmd,
 		return -EFAULT;
 
 	return ovl_ioctl_set_flags(file, cmd, arg,
-				   ovl_fsxflags_to_iflags(fa.fsx_xflags));
+				   ovl_fsxflags_to_fsflags(fa.fsx_xflags));
 }
 
 long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
-- 
2.17.1
