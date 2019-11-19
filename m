Return-Path: <jiufei.xue@linux.alibaba.com>
From: Jiufei Xue <jiufei.xue@linux.alibaba.com>
Subject: [PATCH 1/2] vfs: add vfs_iocb_iter_[read|write] helper functions
Date: Tue, 19 Nov 2019 10:14:02 +0800
Message-Id: <1574129643-14664-2-git-send-email-jiufei.xue@linux.alibaba.com>
In-Reply-To: <1574129643-14664-1-git-send-email-jiufei.xue@linux.alibaba.com>
References: <1574129643-14664-1-git-send-email-jiufei.xue@linux.alibaba.com>
To: miklos@szeredi.hu, amir73il@gmail.com
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

This isn't cause any behavior changes and will be used by overlay
async IO implementation.

Signed-off-by: Jiufei Xue <jiufei.xue@linux.alibaba.com>
---
 fs/read_write.c    | 58 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h | 16 +++++++++++++++
 2 files changed, 74 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index 5bbf587..3dfbcec 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -984,6 +984,64 @@ ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos,
 }
 EXPORT_SYMBOL(vfs_iter_write);
 
+ssize_t vfs_iocb_iter_read(struct file *file, struct kiocb *iocb,
+			   struct iov_iter *iter)
+{
+	ssize_t ret = 0;
+	ssize_t tot_len;
+
+	if (!file->f_op->read_iter)
+		return -EINVAL;
+	if (!(file->f_mode & FMODE_READ))
+		return -EBADF;
+	if (!(file->f_mode & FMODE_CAN_READ))
+		return -EINVAL;
+
+	tot_len = iov_iter_count(iter);
+	if (!tot_len)
+		return 0;
+
+	ret = rw_verify_area(READ, file, &iocb->ki_pos, tot_len);
+	if (ret < 0)
+		return ret;
+
+	ret = call_read_iter(file, iocb, iter);
+	if (ret >= 0)
+		fsnotify_access(file);
+
+	return ret;
+}
+EXPORT_SYMBOL(vfs_iocb_iter_read);
+
+ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
+			    struct iov_iter *iter)
+{
+	ssize_t ret = 0;
+	ssize_t tot_len;
+
+	if (!file->f_op->write_iter)
+		return -EINVAL;
+	if (!(file->f_mode & FMODE_WRITE))
+		return -EBADF;
+	if (!(file->f_mode & FMODE_CAN_WRITE))
+		return -EINVAL;
+
+	tot_len = iov_iter_count(iter);
+	if (!tot_len)
+		return 0;
+
+	ret = rw_verify_area(WRITE, file, &iocb->ki_pos, tot_len);
+	if (ret < 0)
+		return ret;
+
+	ret = call_write_iter(file, iocb, iter);
+	if (ret >= 0)
+		fsnotify_modify(file);
+
+	return ret;
+}
+EXPORT_SYMBOL(vfs_iocb_iter_write);
+
 ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 		  unsigned long vlen, loff_t *pos, rwf_t flags)
 {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e0d909d..c885279 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2071,6 +2071,18 @@ static inline void init_sync_kiocb(struct kiocb *kiocb, struct file *filp)
 	};
 }
 
+static inline void kiocb_clone(struct kiocb *kiocb, struct kiocb *kiocb_src,
+			       struct file *filp)
+{
+        *kiocb = (struct kiocb) {
+                .ki_filp = filp,
+                .ki_flags = kiocb_src->ki_flags,
+                .ki_hint = ki_hint_validate(file_write_hint(filp)),
+                .ki_ioprio = kiocb_src->ki_ioprio,
+                .ki_pos = kiocb_src->ki_pos,
+        };
+}
+
 /*
  * Inode state bits.  Protected by inode->i_lock
  *
@@ -3105,6 +3117,10 @@ ssize_t vfs_iter_read(struct file *file, struct iov_iter *iter, loff_t *ppos,
 		rwf_t flags);
 ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos,
 		rwf_t flags);
+ssize_t vfs_iocb_iter_read(struct file *file, struct kiocb *iocb,
+			   struct iov_iter *iter);
+ssize_t vfs_iocb_iter_write(struct file *file, struct kiocb *iocb,
+			    struct iov_iter *iter);
 
 /* fs/block_dev.c */
 extern ssize_t blkdev_read_iter(struct kiocb *iocb, struct iov_iter *to);
-- 
1.8.3.1
