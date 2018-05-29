From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 24/39] ovl: add reflink/copyfile/dedup support
Date: Tue, 29 May 2018 16:43:24 +0200
Message-ID: <20180529144339.16538-25-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Since set of arguments are so similar, handle in a common helper.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 88 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 88 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index e5e7ccaaf9ec..ef4bcc80572f 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -385,6 +385,90 @@ static long ovl_compat_ioctl(struct file *file, unsigned int cmd,
 	return ovl_ioctl(file, cmd, arg);
 }
 
+enum ovl_copyop {
+	OVL_COPY,
+	OVL_CLONE,
+	OVL_DEDUPE,
+};
+
+static s64 ovl_copyfile(struct file *file_in, loff_t pos_in,
+			struct file *file_out, loff_t pos_out,
+			u64 len, unsigned int flags, enum ovl_copyop op)
+{
+	struct inode *inode_out = file_inode(file_out);
+	struct fd real_in, real_out;
+	const struct cred *old_cred;
+	s64 ret;
+
+	ret = ovl_real_fdget(file_out, &real_out);
+	if (ret)
+		return ret;
+
+	ret = ovl_real_fdget(file_in, &real_in);
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
+		ret = vfs_dedupe_file_range_one(real_in.file, pos_in,
+						real_out.file, pos_out, len);
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
+static loff_t ovl_dedupe_file_range(struct file *file_in, loff_t pos_in,
+				    struct file *file_out, loff_t pos_out,
+				    loff_t len)
+{
+	/*
+	 * Don't copy up because of a dedupe request, this wouldn't make sense
+	 * most of the time (data would be duplicated instead of deduplicated).
+	 */
+	if (!ovl_inode_upper(file_inode(file_in)) ||
+	    !ovl_inode_upper(file_inode(file_out)))
+		return -EPERM;
+
+	return ovl_copyfile(file_in, pos_in, file_out, pos_out, len, 0,
+			    OVL_DEDUPE);
+}
+
 const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 	.release	= ovl_release,
@@ -396,4 +480,8 @@ const struct file_operations ovl_file_operations = {
 	.fallocate	= ovl_fallocate,
 	.unlocked_ioctl	= ovl_ioctl,
 	.compat_ioctl	= ovl_compat_ioctl,
+
+	.copy_file_range	= ovl_copy_file_range,
+	.clone_file_range	= ovl_clone_file_range,
+	.dedupe_file_range	= ovl_dedupe_file_range,
 };
-- 
2.14.3
