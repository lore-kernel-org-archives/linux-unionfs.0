From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 01/35] vfs: clean up dedup
Date: Thu, 12 Apr 2018 17:07:52 +0200
Message-ID: <20180412150826.20988-2-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Extract vfs_dedupe_file_range_one() helper to deal with a single dedup
request.

Export this helper to modules, so it can be used by overlayfs to stack the
dedupe method.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/read_write.c    | 90 ++++++++++++++++++++++++++++++------------------------
 include/linux/fs.h |  3 ++
 2 files changed, 53 insertions(+), 40 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index f8547b82dfb3..82aa0d32d0cd 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1937,6 +1937,44 @@ int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 }
 EXPORT_SYMBOL(vfs_dedupe_file_range_compare);
 
+ssize_t vfs_dedupe_file_range_one(struct file *src_file, u64 src_pos, u64 len,
+			      struct file *dst_file, u64 dst_pos)
+{
+	ssize_t ret;
+
+	ret = mnt_want_write_file(dst_file);
+	if (ret)
+		return ret;
+
+	ret = clone_verify_area(dst_file, dst_pos, len, true);
+	if (ret < 0)
+		goto out_drop_write;
+
+	ret = -EINVAL;
+	if (!(capable(CAP_SYS_ADMIN) || (dst_file->f_mode & FMODE_WRITE)))
+		goto out_drop_write;
+
+	ret = -EXDEV;
+	if (src_file->f_path.mnt != dst_file->f_path.mnt)
+		goto out_drop_write;
+
+	ret = -EISDIR;
+	if (S_ISDIR(file_inode(dst_file)->i_mode))
+		goto out_drop_write;
+
+	ret = -EINVAL;
+	if (!dst_file->f_op->dedupe_file_range)
+		goto out_drop_write;
+
+	ret = dst_file->f_op->dedupe_file_range(src_file, src_pos, len,
+						dst_file, dst_pos);
+out_drop_write:
+	mnt_drop_write_file(dst_file);
+
+	return ret;
+}
+EXPORT_SYMBOL(vfs_dedupe_file_range_one);
+
 int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 {
 	struct file_dedupe_range_info *info;
@@ -1945,10 +1983,7 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	u64 len;
 	int i;
 	int ret;
-	bool is_admin = capable(CAP_SYS_ADMIN);
 	u16 count = same->dest_count;
-	struct file *dst_file;
-	loff_t dst_off;
 	ssize_t deduped;
 
 	if (!(file->f_mode & FMODE_READ))
@@ -1983,54 +2018,29 @@ int vfs_dedupe_file_range(struct file *file, struct file_dedupe_range *same)
 	}
 
 	for (i = 0, info = same->info; i < count; i++, info++) {
-		struct inode *dst;
 		struct fd dst_fd = fdget(info->dest_fd);
+		struct file *dst_file = dst_fd.file;
 
-		dst_file = dst_fd.file;
 		if (!dst_file) {
 			info->status = -EBADF;
 			goto next_loop;
 		}
-		dst = file_inode(dst_file);
-
-		ret = mnt_want_write_file(dst_file);
-		if (ret) {
-			info->status = ret;
-			goto next_loop;
-		}
-
-		dst_off = info->dest_offset;
-		ret = clone_verify_area(dst_file, dst_off, len, true);
-		if (ret < 0) {
-			info->status = ret;
-			goto next_file;
-		}
-		ret = 0;
 
 		if (info->reserved) {
 			info->status = -EINVAL;
-		} else if (!(is_admin || (dst_file->f_mode & FMODE_WRITE))) {
-			info->status = -EINVAL;
-		} else if (file->f_path.mnt != dst_file->f_path.mnt) {
-			info->status = -EXDEV;
-		} else if (S_ISDIR(dst->i_mode)) {
-			info->status = -EISDIR;
-		} else if (dst_file->f_op->dedupe_file_range == NULL) {
-			info->status = -EINVAL;
-		} else {
-			deduped = dst_file->f_op->dedupe_file_range(file, off,
-							len, dst_file,
-							info->dest_offset);
-			if (deduped == -EBADE)
-				info->status = FILE_DEDUPE_RANGE_DIFFERS;
-			else if (deduped < 0)
-				info->status = deduped;
-			else
-				info->bytes_deduped += deduped;
+			goto next_loop;
 		}
 
-next_file:
-		mnt_drop_write_file(dst_file);
+		deduped = vfs_dedupe_file_range_one(file, off, len,
+						    dst_file,
+						    info->dest_offset);
+		if (deduped == -EBADE)
+			info->status = FILE_DEDUPE_RANGE_DIFFERS;
+		else if (deduped < 0)
+			info->status = deduped;
+		else
+			info->bytes_deduped += deduped;
+
 next_loop:
 		fdput(dst_fd);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index c6baf767619e..f0f87f2beb79 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1809,6 +1809,9 @@ extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 					 loff_t len, bool *is_same);
 extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
+extern ssize_t vfs_dedupe_file_range_one(struct file *src_file, u64 src_pos,
+					 u64 len, struct file *dst_file,
+					 u64 dst_pos);
 
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
-- 
2.14.3
