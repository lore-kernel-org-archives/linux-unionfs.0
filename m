Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH v2 4/5] ovl: lazy copy up data on page fault
Date: Tue, 22 Jan 2019 14:34:56 +0200
Message-Id: <20190122123457.10600-5-amir73il@gmail.com>
In-Reply-To: <20190122123457.10600-1-amir73il@gmail.com>
References: <20190122123457.10600-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, cgxu519 <cgxu519@gmx.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

When overlay filemap operations are supported, all maps, including
private and non writable maps that are created from file that was
opened after copy up, map overlay inode pages. If the file was opened
O_RDWR with lazy copy up of data, the first page fault, read or write,
will trigger data copy up.

NOTE: SHARED maps that are created from file opened O_RDONLY before
data copy up will stay mapped to lower real file also after copy up.
This long standing inconsistency will need to be resolved by future
patches.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c | 59 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 57 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index e02b61af9488..35c75e9d8111 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -397,6 +397,49 @@ const struct address_space_operations ovl_aops = {
 	.direct_IO		= noop_direct_IO,
 };
 
+static vm_fault_t ovl_fault(struct vm_fault *vmf)
+{
+	struct file *file = vmf->vma->vm_file;
+	struct inode *inode = file_inode(file);
+	bool blocking = (vmf->flags & FAULT_FLAG_KILLABLE) ||
+			((vmf->flags & FAULT_FLAG_ALLOW_RETRY) &&
+			 !(vmf->flags & FAULT_FLAG_RETRY_NOWAIT));
+	int err = 0;
+
+	/*
+	 * Handle fault of pages in maps that were created from file that was
+	 * opened O_RDWR and before data copy up.
+	 */
+	if (!ovl_has_upperdata(inode)) {
+		/* TODO: async copy up data? */
+		if (!blocking)
+			goto out_err;
+
+		up_read(&vmf->vma->vm_mm->mmap_sem);
+		err = ovl_maybe_copy_up(file_dentry(file), O_WRONLY);
+		if (err)
+			goto out_err;
+
+		return VM_FAULT_RETRY;
+	}
+
+	return filemap_fault(vmf);
+
+out_err:
+	pr_warn_ratelimited("overlayfs: %s copy up data on page fault (%pd2, err=%i)\n",
+			    blocking ? "failed to" : "no wait for",
+			    file_dentry(file), err);
+
+	/* We must return VM_FAULT_RETRY if we released mmap_sem */
+	return blocking ? VM_FAULT_NOPAGE : VM_FAULT_RETRY;
+}
+
+static const struct vm_operations_struct ovl_file_vm_ops = {
+	.fault		= ovl_fault,
+	.map_pages	= filemap_map_pages,
+	.page_mkwrite   = filemap_page_mkwrite,
+};
+
 static int ovl_real_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	struct file *realfile = file->private_data;
@@ -430,8 +473,20 @@ static int ovl_real_mmap(struct file *file, struct vm_area_struct *vma)
 
 static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
 {
-	if (ovl_should_use_filemap_meta(file, true))
-		generic_file_mmap(file, vma);
+	/*
+	 * All maps (also private and non writable) that are created from file
+	 * that was opened after copy up, map overlay inode pages. If the file
+	 * was opened O_RDWR with lazy copy up of data, the first page fault
+	 * will trigger data copy up.
+	 *
+	 * FIXME: SHARED maps that are created from file opened O_RDONLY before
+	 * data copy up will stay mapped to lower real file also after copy up.
+	 */
+	if (ovl_should_use_filemap_meta(file, true)) {
+		vma->vm_ops = &ovl_file_vm_ops;
+		file_accessed(file);
+		return 0;
+	}
 
 	return ovl_real_mmap(file, vma);
 }
-- 
2.17.1
