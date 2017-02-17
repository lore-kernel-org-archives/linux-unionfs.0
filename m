From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 9/9] vfs: intercept fsync on overlay files
Date: Fri, 17 Feb 2017 17:09:38 +0100
Message-ID: <1487347778-18596-10-git-send-email-mszeredi@redhat.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Fsync is really an inode operation (AFAICS) so a doing it on a O_RDONLY
file descriptor should flush any data written through an O_WRONLY file
descriptor for example.

To make this work correctly in case the file is copied up after being
opened for read, intercept the fsync operation, similarly to read_iter and
mmap.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlay_util.c            | 19 +++++++++++++++++++
 include/linux/fs.h           |  3 +++
 include/linux/overlay_util.h |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/fs/overlay_util.c b/fs/overlay_util.c
index 063f8c5719d1..dae9d23b1519 100644
--- a/fs/overlay_util.c
+++ b/fs/overlay_util.c
@@ -37,6 +37,25 @@ ssize_t overlay_read_iter(struct file *file, struct kiocb *kio,
 }
 EXPORT_SYMBOL(overlay_read_iter);
 
+int overlay_fsync(struct file *file, loff_t start, loff_t end,
+		  int datasync)
+{
+	int ret;
+
+	if (likely(overlay_file_consistent(file)))
+		return file->f_op->fsync(file, start, end, datasync);
+
+	file = filp_clone_open(file);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	ret = vfs_fsync_range(file, start, end, datasync);
+	fput(file);
+
+	return ret;
+}
+EXPORT_SYMBOL(overlay_fsync);
+
 int overlay_mmap(struct file *file, struct vm_area_struct *vma)
 {
 	if (unlikely(!overlay_file_consistent(file))) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1293005de2e3..1cfa3b33659c 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1748,6 +1748,9 @@ static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
 static inline int call_fsync(struct file *file, loff_t start, loff_t end,
 			     int datasync)
 {
+	if (unlikely(is_overlay_file(file)))
+		return overlay_fsync(file, start, end, datasync);
+
 	return file->f_op->fsync(file, start, end, datasync);
 }
 
diff --git a/include/linux/overlay_util.h b/include/linux/overlay_util.h
index 2cd66bc316cc..06a0dd923404 100644
--- a/include/linux/overlay_util.h
+++ b/include/linux/overlay_util.h
@@ -11,5 +11,7 @@ struct vm_area_struct;
 extern ssize_t overlay_read_iter(struct file *file, struct kiocb *kio,
 				 struct iov_iter *iter);
 extern int overlay_mmap(struct file *file, struct vm_area_struct *vma);
+extern int overlay_fsync(struct file *file, loff_t start, loff_t end,
+			 int datasync);
 
 #endif /* _LINUX_OVERLAY_FS_H */
-- 
2.5.5
