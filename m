From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 1/9] vfs: extract common parts of {compat_,}do_readv_writev()
Date: Fri, 17 Feb 2017 17:09:30 +0100
Message-ID: <1487347778-18596-2-git-send-email-mszeredi@redhat.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/read_write.c | 80 +++++++++++++++++++++------------------------------------
 1 file changed, 29 insertions(+), 51 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 5816d4c4cab0..b7cf7e2cb8c5 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -834,25 +834,15 @@ ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 	return ret;
 }
 
-static ssize_t do_readv_writev(int type, struct file *file,
-			       const struct iovec __user * uvector,
-			       unsigned long nr_segs, loff_t *pos,
-			       int flags)
+static ssize_t __do_readv_writev(int type, struct file *file,
+				 struct iov_iter *iter, loff_t *pos, int flags)
 {
 	size_t tot_len;
-	struct iovec iovstack[UIO_FASTIOV];
-	struct iovec *iov = iovstack;
-	struct iov_iter iter;
-	ssize_t ret;
+	ssize_t ret = 0;
 	io_fn_t fn;
 	iter_fn_t iter_fn;
 
-	ret = import_iovec(type, uvector, nr_segs,
-			   ARRAY_SIZE(iovstack), &iov, &iter);
-	if (ret < 0)
-		return ret;
-
-	tot_len = iov_iter_count(&iter);
+	tot_len = iov_iter_count(iter);
 	if (!tot_len)
 		goto out;
 	ret = rw_verify_area(type, file, pos, tot_len);
@@ -869,15 +859,14 @@ static ssize_t do_readv_writev(int type, struct file *file,
 	}
 
 	if (iter_fn)
-		ret = do_iter_readv_writev(file, &iter, pos, iter_fn, flags);
+		ret = do_iter_readv_writev(file, iter, pos, iter_fn, flags);
 	else
-		ret = do_loop_readv_writev(file, &iter, pos, fn, flags);
+		ret = do_loop_readv_writev(file, iter, pos, fn, flags);
 
 	if (type != READ)
 		file_end_write(file);
 
 out:
-	kfree(iov);
 	if ((ret + (type == READ)) > 0) {
 		if (type == READ)
 			fsnotify_access(file);
@@ -887,6 +876,27 @@ static ssize_t do_readv_writev(int type, struct file *file,
 	return ret;
 }
 
+static ssize_t do_readv_writev(int type, struct file *file,
+			       const struct iovec __user *uvector,
+			       unsigned long nr_segs, loff_t *pos,
+			       int flags)
+{
+	struct iovec iovstack[UIO_FASTIOV];
+	struct iovec *iov = iovstack;
+	struct iov_iter iter;
+	ssize_t ret;
+
+	ret = import_iovec(type, uvector, nr_segs,
+			   ARRAY_SIZE(iovstack), &iov, &iter);
+	if (ret < 0)
+		return ret;
+
+	ret = __do_readv_writev(type, file, &iter, pos, flags);
+	kfree(iov);
+
+	return ret;
+}
+
 ssize_t vfs_readv(struct file *file, const struct iovec __user *vec,
 		  unsigned long vlen, loff_t *pos, int flags)
 {
@@ -1064,51 +1074,19 @@ static ssize_t compat_do_readv_writev(int type, struct file *file,
 			       unsigned long nr_segs, loff_t *pos,
 			       int flags)
 {
-	compat_ssize_t tot_len;
 	struct iovec iovstack[UIO_FASTIOV];
 	struct iovec *iov = iovstack;
 	struct iov_iter iter;
 	ssize_t ret;
-	io_fn_t fn;
-	iter_fn_t iter_fn;
 
 	ret = compat_import_iovec(type, uvector, nr_segs,
 				  UIO_FASTIOV, &iov, &iter);
 	if (ret < 0)
 		return ret;
 
-	tot_len = iov_iter_count(&iter);
-	if (!tot_len)
-		goto out;
-	ret = rw_verify_area(type, file, pos, tot_len);
-	if (ret < 0)
-		goto out;
-
-	if (type == READ) {
-		fn = file->f_op->read;
-		iter_fn = file->f_op->read_iter;
-	} else {
-		fn = (io_fn_t)file->f_op->write;
-		iter_fn = file->f_op->write_iter;
-		file_start_write(file);
-	}
-
-	if (iter_fn)
-		ret = do_iter_readv_writev(file, &iter, pos, iter_fn, flags);
-	else
-		ret = do_loop_readv_writev(file, &iter, pos, fn, flags);
-
-	if (type != READ)
-		file_end_write(file);
-
-out:
+	ret = __do_readv_writev(type, file, &iter, pos, flags);
 	kfree(iov);
-	if ((ret + (type == READ)) > 0) {
-		if (type == READ)
-			fsnotify_access(file);
-		else
-			fsnotify_modify(file);
-	}
+
 	return ret;
 }
 
-- 
2.5.5
