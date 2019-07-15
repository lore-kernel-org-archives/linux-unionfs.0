Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/4] ovl: support [S|G]ETFLAGS ioctl for directories
Date: Mon, 15 Jul 2019 16:38:36 +0300
Message-Id: <20190715133839.9878-2-amir73il@gmail.com>
In-Reply-To: <20190715133839.9878-1-amir73il@gmail.com>
References: <20190715133839.9878-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

[S|G]ETFLAGS and FS[S|G]ETXATTR ioctls are applicable to both files and
directories, so add ioctl operations to dir as well.

ifdef away compat ioctl implementation to conform to standard practice.

With this change, xfstest generic/079 which tests these ioctls on files
and directories passes.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c      | 10 ++++++----
 fs/overlayfs/overlayfs.h |  2 ++
 fs/overlayfs/readdir.c   |  4 ++++
 3 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index e235a635d9ec..c6426e4d3f1f 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -502,7 +502,7 @@ static long ovl_ioctl_set_fsxflags(struct file *file, unsigned int cmd,
 				   ovl_fsxflags_to_iflags(fa.fsx_xflags));
 }
 
-static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
 
@@ -527,8 +527,8 @@ static long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-static long ovl_compat_ioctl(struct file *file, unsigned int cmd,
-			     unsigned long arg)
+#ifdef CONFIG_COMPAT
+long ovl_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	switch (cmd) {
 	case FS_IOC32_GETFLAGS:
@@ -545,6 +545,7 @@ static long ovl_compat_ioctl(struct file *file, unsigned int cmd,
 
 	return ovl_ioctl(file, cmd, arg);
 }
+#endif
 
 enum ovl_copyop {
 	OVL_COPY,
@@ -646,8 +647,9 @@ const struct file_operations ovl_file_operations = {
 	.fallocate	= ovl_fallocate,
 	.fadvise	= ovl_fadvise,
 	.unlocked_ioctl	= ovl_ioctl,
+#ifdef CONFIG_COMPAT
 	.compat_ioctl	= ovl_compat_ioctl,
-
+#endif
 	.copy_file_range	= ovl_copy_file_range,
 	.remap_file_range	= ovl_remap_file_range,
 };
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 6934bcf030f0..7c94cc3521cb 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -416,6 +416,8 @@ struct dentry *ovl_create_temp(struct dentry *workdir, struct ovl_cattr *attr);
 
 /* file.c */
 extern const struct file_operations ovl_file_operations;
+long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
+long ovl_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 
 /* copy_up.c */
 int ovl_copy_up(struct dentry *dentry);
diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
index 47a91c9733a5..eff8fbfccc7c 100644
--- a/fs/overlayfs/readdir.c
+++ b/fs/overlayfs/readdir.c
@@ -907,6 +907,10 @@ const struct file_operations ovl_dir_operations = {
 	.llseek		= ovl_dir_llseek,
 	.fsync		= ovl_dir_fsync,
 	.release	= ovl_dir_release,
+	.unlocked_ioctl	= ovl_ioctl,
+#ifdef CONFIG_COMPAT
+	.compat_ioctl	= ovl_compat_ioctl,
+#endif
 };
 
 int ovl_check_empty_dir(struct dentry *dentry, struct list_head *list)
-- 
2.17.1
