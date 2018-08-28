Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 6/6] ovl: add ovl_fadvise()
Date: Tue, 28 Aug 2018 10:58:41 +0300
Message-Id: <1535443121-30934-2-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535443121-30934-1-git-send-email-amir73il@gmail.com>
References: <1535443121-30934-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Implement stacked fadvise to fix syscalls readahead(2) and fadvise64(2)
on an overlayfs file.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: d1d04ef8572b ("ovl: stack file ops")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Following v4 with ovl_override_creds.

Thanks,
Amir.

 fs/overlayfs/file.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index a4acd84591d4..89f9e97c0452 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -331,6 +331,25 @@ static long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len
 	return ret;
 }
 
+int ovl_fadvise(struct file *file, loff_t offset, loff_t len, int advice)
+{
+	struct fd real;
+	const struct cred *old_cred;
+	int ret;
+
+	ret = ovl_real_fdget(file, &real);
+	if (ret)
+		return ret;
+
+	old_cred = ovl_override_creds(file_inode(file)->i_sb);
+	ret = vfs_fadvise(real.file, offset, len, advice);
+	revert_creds(old_cred);
+
+	fdput(real);
+
+	return ret;
+}
+
 static long ovl_real_ioctl(struct file *file, unsigned int cmd,
 			   unsigned long arg)
 {
@@ -499,6 +518,7 @@ const struct file_operations ovl_file_operations = {
 	.fsync		= ovl_fsync,
 	.mmap		= ovl_mmap,
 	.fallocate	= ovl_fallocate,
+	.fadvise	= ovl_fadvise,
 	.unlocked_ioctl	= ovl_ioctl,
 	.compat_ioctl	= ovl_compat_ioctl,
 
-- 
2.7.4
