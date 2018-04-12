From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 14/35] ovl: readd mmap
Date: Thu, 12 Apr 2018 17:08:05 +0200
Message-ID: <20180412150826.20988-15-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Implement stacked mmap.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 4417527667ff..f1cc2fdc62c1 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -241,6 +241,33 @@ static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 	return ret;
 }
 
+static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	struct fd real;
+	const struct cred *old_cred;
+	int ret;
+
+	ret = ovl_real_file(file, &real);
+	if (ret)
+		return ret;
+
+	/* transfer ref: */
+	fput(vma->vm_file);
+	vma->vm_file = get_file(real.file);
+	fdput(real);
+
+	if (!vma->vm_file->f_op->mmap)
+		return -ENODEV;
+
+	old_cred = ovl_override_creds(file_inode(file)->i_sb);
+	ret = call_mmap(vma->vm_file, vma);
+	revert_creds(old_cred);
+
+	ovl_file_accessed(file);
+
+	return ret;
+}
+
 const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 	.release	= ovl_release,
@@ -248,4 +275,5 @@ const struct file_operations ovl_file_operations = {
 	.read_iter	= ovl_read_iter,
 	.write_iter	= ovl_write_iter,
 	.fsync		= ovl_fsync,
+	.mmap		= ovl_mmap,
 };
-- 
2.14.3
