From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 15/35] ovl: readd fallocate
Date: Thu, 12 Apr 2018 17:08:06 +0200
Message-ID: <20180412150826.20988-16-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Implement stacked fallocate.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index f1cc2fdc62c1..05e3e2f80b89 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -268,6 +268,29 @@ static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 	return ret;
 }
 
+long ovl_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
+{
+	struct inode *inode = file_inode(file);
+	struct fd real;
+	const struct cred *old_cred;
+	int ret;
+
+	ret = ovl_real_file(file, &real);
+	if (ret)
+		return ret;
+
+	old_cred = ovl_override_creds(file_inode(file)->i_sb);
+	ret = vfs_fallocate(real.file, mode, offset, len);
+	revert_creds(old_cred);
+
+	/* Update size */
+	ovl_copyattr(ovl_inode_real(inode), inode);
+
+	fdput(real);
+
+	return ret;
+}
+
 const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 	.release	= ovl_release,
@@ -276,4 +299,5 @@ const struct file_operations ovl_file_operations = {
 	.write_iter	= ovl_write_iter,
 	.fsync		= ovl_fsync,
 	.mmap		= ovl_mmap,
+	.fallocate	= ovl_fallocate,
 };
-- 
2.14.3
