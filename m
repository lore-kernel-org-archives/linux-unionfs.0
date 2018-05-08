Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45380 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755727AbeEHVY2 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 May 2018 17:24:28 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 4/4] ovl: Use do_copy_file_range() in copy_up_data()
Date: Tue,  8 May 2018 16:24:05 -0500
Message-Id: <20180508212405.15297-5-rgoldwyn@suse.de>
In-Reply-To: <20180508212405.15297-1-rgoldwyn@suse.de>
References: <20180508212405.15297-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

This will preserve the holes and will clone(), if available.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/overlayfs/copy_up.c | 28 ++++++++--------------------
 fs/read_write.c        |  3 ++-
 include/linux/fs.h     |  3 +++
 3 files changed, 13 insertions(+), 21 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8bede0742619..1f89380873ce 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -138,8 +138,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 {
 	struct file *old_file;
 	struct file *new_file;
-	loff_t old_pos = 0;
-	loff_t new_pos = 0;
+	loff_t pos = 0;
 	int error = 0;
 
 	if (len == 0)
@@ -155,38 +154,27 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 		goto out_fput;
 	}
 
-	/* Try to use clone_file_range to clone up within the same fs */
-	error = vfs_clone_file_range(old_file, 0, new_file, 0, len);
-	if (!error)
-		goto out;
-	/* Couldn't clone, so now we try to copy the data */
-	error = 0;
-
-	/* FIXME: copy up sparse files efficiently */
-	while (len) {
+	while (pos < len) {
 		size_t this_len = OVL_COPY_UP_CHUNK_SIZE;
 		long bytes;
 
-		if (len < this_len)
-			this_len = len;
+		if (len - pos < this_len)
+			this_len = len - pos;
 
 		if (signal_pending_state(TASK_KILLABLE, current)) {
 			error = -EINTR;
 			break;
 		}
 
-		bytes = do_splice_direct(old_file, &old_pos,
-					 new_file, &new_pos,
-					 this_len, SPLICE_F_MOVE);
+		bytes = do_copy_file_range(old_file, pos,
+					 new_file, pos,
+					 this_len, 0, SPLICE_F_MOVE);
 		if (bytes <= 0) {
 			error = bytes;
 			break;
 		}
-		WARN_ON(old_pos != new_pos);
-
-		len -= bytes;
+		pos += bytes;
 	}
-out:
 	if (!error)
 		error = vfs_fsync(new_file, 0);
 	fput(new_file);
diff --git a/fs/read_write.c b/fs/read_write.c
index 5df9d6e8ebee..57b5b74c982a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1542,7 +1542,7 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
 }
 #endif
 
-static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
+ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
 			    size_t len, unsigned int flags,
 			    unsigned int splice_flags)
@@ -1631,6 +1631,7 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 out:
 	return total ? total : ret;
 }
+EXPORT_SYMBOL(do_copy_file_range);
 
 /*
  * copy_file_range() differs from regular file read and write in that it
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 760d8da1b6c7..d5349b17fa10 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1799,6 +1799,9 @@ extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, rwf_t);
+extern ssize_t do_copy_file_range(struct file *, loff_t , struct file *,
+				   loff_t , size_t, unsigned int,
+				   unsigned int);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
 extern int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
-- 
2.16.3

