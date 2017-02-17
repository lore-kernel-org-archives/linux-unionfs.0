From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 2/9] vfs: pass type instead of fn to do_{loop,iter}_readv_writev()
Date: Fri, 17 Feb 2017 17:09:31 +0100
Message-ID: <1487347778-18596-3-git-send-email-mszeredi@redhat.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/read_write.c | 37 ++++++++++++++++++-------------------
 1 file changed, 18 insertions(+), 19 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index b7cf7e2cb8c5..c9da4492a462 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -23,9 +23,6 @@
 #include <linux/uaccess.h>
 #include <asm/unistd.h>
 
-typedef ssize_t (*io_fn_t)(struct file *, char __user *, size_t, loff_t *);
-typedef ssize_t (*iter_fn_t)(struct kiocb *, struct iov_iter *);
-
 const struct file_operations generic_ro_fops = {
 	.llseek		= generic_file_llseek,
 	.read_iter	= generic_file_read_iter,
@@ -675,7 +672,7 @@ unsigned long iov_shorten(struct iovec *iov, unsigned long nr_segs, size_t to)
 EXPORT_SYMBOL(iov_shorten);
 
 static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
-		loff_t *ppos, iter_fn_t fn, int flags)
+		loff_t *ppos, int type, int flags)
 {
 	struct kiocb kiocb;
 	ssize_t ret;
@@ -692,7 +689,10 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 		kiocb.ki_flags |= (IOCB_DSYNC | IOCB_SYNC);
 	kiocb.ki_pos = *ppos;
 
-	ret = fn(&kiocb, iter);
+	if (type == READ)
+		ret = filp->f_op->read_iter(&kiocb, iter);
+	else
+		ret = filp->f_op->write_iter(&kiocb, iter);
 	BUG_ON(ret == -EIOCBQUEUED);
 	*ppos = kiocb.ki_pos;
 	return ret;
@@ -700,7 +700,7 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 
 /* Do it by hand, with file-ops */
 static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
-		loff_t *ppos, io_fn_t fn, int flags)
+		loff_t *ppos, int type, int flags)
 {
 	ssize_t ret = 0;
 
@@ -711,7 +711,13 @@ static ssize_t do_loop_readv_writev(struct file *filp, struct iov_iter *iter,
 		struct iovec iovec = iov_iter_iovec(iter);
 		ssize_t nr;
 
-		nr = fn(filp, iovec.iov_base, iovec.iov_len, ppos);
+		if (type == READ) {
+			nr = filp->f_op->read(filp, iovec.iov_base,
+					      iovec.iov_len, ppos);
+		} else {
+			nr = filp->f_op->write(filp, iovec.iov_base,
+					       iovec.iov_len, ppos);
+		}
 
 		if (nr < 0) {
 			if (!ret)
@@ -839,8 +845,6 @@ static ssize_t __do_readv_writev(int type, struct file *file,
 {
 	size_t tot_len;
 	ssize_t ret = 0;
-	io_fn_t fn;
-	iter_fn_t iter_fn;
 
 	tot_len = iov_iter_count(iter);
 	if (!tot_len)
@@ -849,19 +853,14 @@ static ssize_t __do_readv_writev(int type, struct file *file,
 	if (ret < 0)
 		goto out;
 
-	if (type == READ) {
-		fn = file->f_op->read;
-		iter_fn = file->f_op->read_iter;
-	} else {
-		fn = (io_fn_t)file->f_op->write;
-		iter_fn = file->f_op->write_iter;
+	if (type != READ)
 		file_start_write(file);
-	}
 
-	if (iter_fn)
-		ret = do_iter_readv_writev(file, iter, pos, iter_fn, flags);
+	if ((type == READ && file->f_op->read_iter) ||
+	    (type == WRITE && file->f_op->write_iter))
+		ret = do_iter_readv_writev(file, iter, pos, type, flags);
 	else
-		ret = do_loop_readv_writev(file, iter, pos, fn, flags);
+		ret = do_loop_readv_writev(file, iter, pos, type, flags);
 
 	if (type != READ)
 		file_end_write(file);
-- 
2.5.5
