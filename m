Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45342 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755727AbeEHVYW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 May 2018 17:24:22 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/4] copy_file_range: refactor vfs_copy_file_range
Date: Tue,  8 May 2018 16:24:02 -0500
Message-Id: <20180508212405.15297-2-rgoldwyn@suse.de>
In-Reply-To: <20180508212405.15297-1-rgoldwyn@suse.de>
References: <20180508212405.15297-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Preparatory patch to carve out do_copy_file_range() from
vfs_copy_file_range

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/read_write.c | 67 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 38 insertions(+), 29 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index c4eabbfc90df..7d9dfb62ba7d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1541,6 +1541,42 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
 }
 #endif
 
+ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
+			    struct file *file_out, loff_t pos_out,
+			    size_t len, unsigned int flags,
+			    unsigned int splice_flags)
+{
+	ssize_t ret = 0;
+
+	if (flags != 0)
+		return -EINVAL;
+
+	if (len == 0)
+		return 0;
+
+	/*
+	 * Try cloning first, this is supported by more file systems, and
+	 * more efficient if both clone and copy are supported (e.g. NFS).
+	 */
+	if (file_in->f_op->clone_file_range) {
+		ret = file_in->f_op->clone_file_range(file_in, pos_in,
+				file_out, pos_out, len);
+		if (ret == 0)
+			return len;
+	}
+
+	if (file_out->f_op->copy_file_range) {
+		ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
+						      pos_out, len, flags);
+		if (ret != -EOPNOTSUPP)
+			return ret;
+	}
+
+	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
+			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, splice_flags);
+	return ret;
+}
+
 /*
  * copy_file_range() differs from regular file read and write in that it
  * specifically allows return partial success.  When it does so is up to
@@ -1554,9 +1590,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	struct inode *inode_out = file_inode(file_out);
 	ssize_t ret;
 
-	if (flags != 0)
-		return -EINVAL;
-
 	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
 		return -EISDIR;
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
@@ -1579,35 +1612,11 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (inode_in->i_sb != inode_out->i_sb)
 		return -EXDEV;
 
-	if (len == 0)
-		return 0;
-
 	file_start_write(file_out);
 
-	/*
-	 * Try cloning first, this is supported by more file systems, and
-	 * more efficient if both clone and copy are supported (e.g. NFS).
-	 */
-	if (file_in->f_op->clone_file_range) {
-		ret = file_in->f_op->clone_file_range(file_in, pos_in,
-				file_out, pos_out, len);
-		if (ret == 0) {
-			ret = len;
-			goto done;
-		}
-	}
-
-	if (file_out->f_op->copy_file_range) {
-		ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
-						      pos_out, len, flags);
-		if (ret != -EOPNOTSUPP)
-			goto done;
-	}
-
-	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
-			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
+	ret = do_copy_file_range(file_in, pos_in,
+			file_out, pos_out, len, flags, 0);
 
-done:
 	if (ret > 0) {
 		fsnotify_access(file_in);
 		add_rchar(current, ret);
-- 
2.16.3

