Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52984 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751196AbeECP0v (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 May 2018 11:26:51 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 2/3] copy_file_range: splice with holes
Date: Thu,  3 May 2018 10:26:34 -0500
Message-Id: <20180503152635.14974-3-rgoldwyn@suse.de>
In-Reply-To: <20180503152635.14974-1-rgoldwyn@suse.de>
References: <20180503152635.14974-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, Anna.Schumaker@Netapp.com, darrick.wong@oracle.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

copy_file_range calls do_splice_direct() if fs->clone_file_range
or fs->copy_file_range() is not available. However, do_splice_direct()
converts holes to zeros. Detect holes in the file_in range, and
create them in the corresponding file_out range.

If there is already data present at the offset in file_out, attempt
to punch a hole there. If the operation is not supported, fall
back to performing splice on the whole range.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/read_write.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index e71270033402..6866e2a27594 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -20,6 +20,7 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/fs.h>
+#include <linux/falloc.h>
 #include "internal.h"
 
 #include <linux/uaccess.h>
@@ -1541,6 +1542,63 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
 }
 #endif
 
+
+static ssize_t splice_with_holes(struct file *file_in, loff_t *pos_in,
+		struct file *file_out, loff_t *pos_out,	size_t len)
+{
+	ssize_t ret = 0, total = 0;
+	loff_t size, end;
+
+	while (total < len) {
+		end = vfs_llseek(file_in, *pos_in, SEEK_HOLE);
+		if (end == *pos_in)
+			goto hole;
+		size = end - *pos_in;
+splice:
+		ret = do_splice_direct(file_in, pos_in, file_out, pos_out,
+				size, 0);
+		if (ret < 0)
+			goto out;
+		total += ret;
+		if (total == len)
+			break;
+hole:
+		end = vfs_llseek(file_in, *pos_in, SEEK_DATA);
+		if (end < 0) {
+			ret = end;
+			goto out;
+		}
+		size = end - *pos_in;
+		/* For files already containing data, punch holes */
+		if (i_size_read(file_out->f_inode) > *pos_out) {
+			ret = vfs_fallocate(file_out,
+					FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+					*pos_out, size);
+			if (ret < 0) {
+				/*
+				 * The filesystem does not support punching
+				 * holes. Perform splice on the entire range.
+				 */
+				if (ret == -EOPNOTSUPP) {
+					size = len - total;
+					goto splice;
+				}
+				goto out;
+			}
+		}
+		if (ret < 0) {
+			ret = end;
+			goto out;
+		}
+		*pos_out += size;
+		*pos_in = end;
+		total += size;
+	}
+
+out:
+	return total ? total : ret;
+}
+
 /*
  * copy_file_range() differs from regular file read and write in that it
  * specifically allows return partial success.  When it does so is up to
@@ -1604,8 +1662,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	}
 
 do_splice:
-	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
-			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
+	ret = splice_with_holes(file_in, &pos_in, file_out, &pos_out,
+			len > MAX_RW_COUNT ? MAX_RW_COUNT : len);
 
 done:
 	if (ret > 0) {
-- 
2.16.3

