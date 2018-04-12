From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 19/35] ovl: readd reflink/copyfile/dedup support
Date: Thu, 12 Apr 2018 17:08:10 +0200
Message-ID: <20180412150826.20988-20-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Since set of arguments are so similar, handle in a common helper.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 9670e160967e..39b1b73334ad 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -352,6 +352,81 @@ long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
+enum ovl_copyop {
+	OVL_COPY,
+	OVL_CLONE,
+	OVL_DEDUPE,
+};
+
+static ssize_t ovl_copyfile(struct file *file_in, loff_t pos_in,
+			    struct file *file_out, loff_t pos_out,
+			    u64 len, unsigned int flags, enum ovl_copyop op)
+{
+	struct inode *inode_out = file_inode(file_out);
+	struct fd real_in, real_out;
+	const struct cred *old_cred;
+	int ret;
+
+	ret = ovl_real_file(file_out, &real_out);
+	if (ret)
+		return ret;
+
+	ret = ovl_real_file(file_in, &real_in);
+	if (ret) {
+		fdput(real_out);
+		return ret;
+	}
+
+	old_cred = ovl_override_creds(file_inode(file_out)->i_sb);
+	switch (op) {
+	case OVL_COPY:
+		ret = vfs_copy_file_range(real_in.file, pos_in,
+					  real_out.file, pos_out, len, flags);
+		break;
+
+	case OVL_CLONE:
+		ret = vfs_clone_file_range(real_in.file, pos_in,
+					   real_out.file, pos_out, len);
+		break;
+
+	case OVL_DEDUPE:
+		ret = vfs_dedupe_file_range_one(real_in.file, pos_in, len,
+						real_out.file, pos_out);
+		break;
+	}
+	revert_creds(old_cred);
+
+	/* Update size */
+	ovl_copyattr(ovl_inode_real(inode_out), inode_out);
+
+	fdput(real_in);
+	fdput(real_out);
+
+	return ret;
+}
+
+static ssize_t ovl_copy_file_range(struct file *file_in, loff_t pos_in,
+				   struct file *file_out, loff_t pos_out,
+				   size_t len, unsigned int flags)
+{
+	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, flags,
+			    OVL_COPY);
+}
+
+static int ovl_clone_file_range(struct file *file_in, loff_t pos_in,
+				struct file *file_out, loff_t pos_out, u64 len)
+{
+	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
+			    OVL_CLONE);
+}
+
+static ssize_t ovl_dedupe_file_range(struct file *file_in, u64 pos_in, u64 len,
+				 struct file *file_out, u64 pos_out)
+{
+	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
+			    OVL_DEDUPE);
+}
+
 const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 	.release	= ovl_release,
@@ -362,4 +437,8 @@ const struct file_operations ovl_file_operations = {
 	.mmap		= ovl_mmap,
 	.fallocate	= ovl_fallocate,
 	.unlocked_ioctl	= ovl_ioctl,
+
+	.copy_file_range	= ovl_copy_file_range,
+	.clone_file_range	= ovl_clone_file_range,
+	.dedupe_file_range	= ovl_dedupe_file_range,
 };
-- 
2.14.3
