From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 3/9] vfs: use helpers for calling f_op->{read,write}_iter()
Date: Fri, 17 Feb 2017 17:09:32 +0100
Message-ID: <1487347778-18596-4-git-send-email-mszeredi@redhat.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f177.google.com ([209.85.128.177]:34116 "EHLO
        mail-wr0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934564AbdBQQJr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Feb 2017 11:09:47 -0500
Received: by mail-wr0-f177.google.com with SMTP id z61so32489328wrc.1
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Feb 2017 08:09:46 -0800 (PST)
In-Reply-To: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 drivers/block/loop.c |  4 ++--
 fs/aio.c             |  4 ++--
 fs/read_write.c      | 12 ++++++------
 fs/splice.c          |  2 +-
 include/linux/fs.h   | 12 ++++++++++++
 5 files changed, 23 insertions(+), 11 deletions(-)

diff --git a/drivers/block/loop.c b/drivers/block/loop.c
index f347285c67ec..2cf2903a0715 100644
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -501,9 +501,9 @@ static int lo_rw_aio(struct loop_device *lo, struct loop_cmd *cmd,
 	cmd->iocb.ki_flags = IOCB_DIRECT;
 
 	if (rw == WRITE)
-		ret = file->f_op->write_iter(&cmd->iocb, &iter);
+		ret = call_write_iter(file, &cmd->iocb, &iter);
 	else
-		ret = file->f_op->read_iter(&cmd->iocb, &iter);
+		ret = call_read_iter(file, &cmd->iocb, &iter);
 
 	if (ret != -EIOCBQUEUED)
 		cmd->iocb.ki_complete(&cmd->iocb, ret, 0);
diff --git a/fs/aio.c b/fs/aio.c
index 873b4ca82ccb..63e97f3168e7 100644
--- a/fs/aio.c
+++ b/fs/aio.c
@@ -1495,7 +1495,7 @@ static ssize_t aio_read(struct kiocb *req, struct iocb *iocb, bool vectored,
 		return ret;
 	ret = rw_verify_area(READ, file, &req->ki_pos, iov_iter_count(&iter));
 	if (!ret)
-		ret = aio_ret(req, file->f_op->read_iter(req, &iter));
+		ret = aio_ret(req, call_read_iter(file, req, &iter));
 	kfree(iovec);
 	return ret;
 }
@@ -1520,7 +1520,7 @@ static ssize_t aio_write(struct kiocb *req, struct iocb *iocb, bool vectored,
 	if (!ret) {
 		req->ki_flags |= IOCB_WRITE;
 		file_start_write(file);
-		ret = aio_ret(req, file->f_op->write_iter(req, &iter));
+		ret = aio_ret(req, call_write_iter(file, req, &iter));
 		/*
 		 * We release freeze protection in aio_complete().  Fool lockdep
 		 * by telling it the lock got released so that it doesn't
diff --git a/fs/read_write.c b/fs/read_write.c
index c9da4492a462..0d697cc15717 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -367,7 +367,7 @@ ssize_t vfs_iter_read(struct file *file, struct iov_iter *iter, loff_t *ppos)
 	kiocb.ki_pos = *ppos;
 
 	iter->type |= READ;
-	ret = file->f_op->read_iter(&kiocb, iter);
+	ret = call_read_iter(file, &kiocb, iter);
 	BUG_ON(ret == -EIOCBQUEUED);
 	if (ret > 0)
 		*ppos = kiocb.ki_pos;
@@ -387,7 +387,7 @@ ssize_t vfs_iter_write(struct file *file, struct iov_iter *iter, loff_t *ppos)
 	kiocb.ki_pos = *ppos;
 
 	iter->type |= WRITE;
-	ret = file->f_op->write_iter(&kiocb, iter);
+	ret = call_write_iter(file, &kiocb, iter);
 	BUG_ON(ret == -EIOCBQUEUED);
 	if (ret > 0)
 		*ppos = kiocb.ki_pos;
@@ -436,7 +436,7 @@ static ssize_t new_sync_read(struct file *filp, char __user *buf, size_t len, lo
 	kiocb.ki_pos = *ppos;
 	iov_iter_init(&iter, READ, &iov, 1, len);
 
-	ret = filp->f_op->read_iter(&kiocb, &iter);
+	ret = call_read_iter(filp, &kiocb, &iter);
 	BUG_ON(ret == -EIOCBQUEUED);
 	*ppos = kiocb.ki_pos;
 	return ret;
@@ -493,7 +493,7 @@ static ssize_t new_sync_write(struct file *filp, const char __user *buf, size_t
 	kiocb.ki_pos = *ppos;
 	iov_iter_init(&iter, WRITE, &iov, 1, len);
 
-	ret = filp->f_op->write_iter(&kiocb, &iter);
+	ret = call_write_iter(filp, &kiocb, &iter);
 	BUG_ON(ret == -EIOCBQUEUED);
 	if (ret > 0)
 		*ppos = kiocb.ki_pos;
@@ -690,9 +690,9 @@ static ssize_t do_iter_readv_writev(struct file *filp, struct iov_iter *iter,
 	kiocb.ki_pos = *ppos;
 
 	if (type == READ)
-		ret = filp->f_op->read_iter(&kiocb, iter);
+		ret = call_read_iter(filp, &kiocb, iter);
 	else
-		ret = filp->f_op->write_iter(&kiocb, iter);
+		ret = call_write_iter(filp, &kiocb, iter);
 	BUG_ON(ret == -EIOCBQUEUED);
 	*ppos = kiocb.ki_pos;
 	return ret;
diff --git a/fs/splice.c b/fs/splice.c
index 873d83104e79..6518f058bd7f 100644
--- a/fs/splice.c
+++ b/fs/splice.c
@@ -306,7 +306,7 @@ ssize_t generic_file_splice_read(struct file *in, loff_t *ppos,
 	idx = to.idx;
 	init_sync_kiocb(&kiocb, in);
 	kiocb.ki_pos = *ppos;
-	ret = in->f_op->read_iter(&kiocb, &to);
+	ret = call_read_iter(in, &kiocb, &to);
 	if (ret > 0) {
 		*ppos = kiocb.ki_pos;
 		file_accessed(in);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 2ba074328894..efdaad954b70 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1712,6 +1712,18 @@ struct inode_operations {
 	int (*set_acl)(struct inode *, struct posix_acl *, int);
 } ____cacheline_aligned;
 
+static inline ssize_t call_read_iter(struct file *file, struct kiocb *kio,
+				     struct iov_iter *iter)
+{
+	return file->f_op->read_iter(kio, iter);
+}
+
+static inline ssize_t call_write_iter(struct file *file, struct kiocb *kio,
+				      struct iov_iter *iter)
+{
+	return file->f_op->write_iter(kio, iter);
+}
+
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
-- 
2.5.5
