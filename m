Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:53001 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751307AbeECP0w (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 May 2018 11:26:52 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 3/3] ovl: Use splice_with_holes in copy_up
Date: Thu,  3 May 2018 10:26:35 -0500
Message-Id: <20180503152635.14974-4-rgoldwyn@suse.de>
In-Reply-To: <20180503152635.14974-1-rgoldwyn@suse.de>
References: <20180503152635.14974-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, Anna.Schumaker@Netapp.com, darrick.wong@oracle.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/overlayfs/copy_up.c |  2 +-
 fs/read_write.c        | 10 ++++++----
 include/linux/fs.h     |  2 ++
 3 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 8bede0742619..6634a85255ae 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -175,7 +175,7 @@ static int ovl_copy_up_data(struct path *old, struct path *new, loff_t len)
 			break;
 		}
 
-		bytes = do_splice_direct(old_file, &old_pos,
+		bytes = splice_with_holes(old_file, &old_pos,
 					 new_file, &new_pos,
 					 this_len, SPLICE_F_MOVE);
 		if (bytes <= 0) {
diff --git a/fs/read_write.c b/fs/read_write.c
index 6866e2a27594..0aa8390d4d39 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1543,8 +1543,9 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
 #endif
 
 
-static ssize_t splice_with_holes(struct file *file_in, loff_t *pos_in,
-		struct file *file_out, loff_t *pos_out,	size_t len)
+ssize_t splice_with_holes(struct file *file_in, loff_t *pos_in,
+		struct file *file_out, loff_t *pos_out,	size_t len,
+		unsigned int flags)
 {
 	ssize_t ret = 0, total = 0;
 	loff_t size, end;
@@ -1556,7 +1557,7 @@ static ssize_t splice_with_holes(struct file *file_in, loff_t *pos_in,
 		size = end - *pos_in;
 splice:
 		ret = do_splice_direct(file_in, pos_in, file_out, pos_out,
-				size, 0);
+				size, flags);
 		if (ret < 0)
 			goto out;
 		total += ret;
@@ -1598,6 +1599,7 @@ static ssize_t splice_with_holes(struct file *file_in, loff_t *pos_in,
 out:
 	return total ? total : ret;
 }
+EXPORT_SYMBOL(splice_with_holes);
 
 /*
  * copy_file_range() differs from regular file read and write in that it
@@ -1663,7 +1665,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 
 do_splice:
 	ret = splice_with_holes(file_in, &pos_in, file_out, &pos_out,
-			len > MAX_RW_COUNT ? MAX_RW_COUNT : len);
+			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
 
 done:
 	if (ret > 0) {
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 760d8da1b6c7..8f96400ab944 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1799,6 +1799,8 @@ extern ssize_t vfs_read(struct file *, char __user *, size_t, loff_t *);
 extern ssize_t vfs_write(struct file *, const char __user *, size_t, loff_t *);
 extern ssize_t vfs_readv(struct file *, const struct iovec __user *,
 		unsigned long, loff_t *, rwf_t);
+extern ssize_t splice_with_holes(struct file *, loff_t *, struct file *,
+				   loff_t *, size_t, unsigned int);
 extern ssize_t vfs_copy_file_range(struct file *, loff_t , struct file *,
 				   loff_t, size_t, unsigned int);
 extern int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
-- 
2.16.3

