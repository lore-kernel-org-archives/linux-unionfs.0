Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932857AbeEJB6e (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 May 2018 21:58:34 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 3/4] copy_file_range: splice with holes
Date: Wed,  9 May 2018 20:58:19 -0500
Message-Id: <20180510015820.17700-4-rgoldwyn@suse.de>
In-Reply-To: <20180510015820.17700-1-rgoldwyn@suse.de>
References: <20180510015820.17700-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, linux-unionfs@vger.kernel.org, david@fromorbit.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>
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
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c | 62 +++++++++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 58 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 1b8fc9eada69..e765fec656af 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -20,6 +20,7 @@
 #include <linux/compat.h>
 #include <linux/mount.h>
 #include <linux/fs.h>
+#include <linux/falloc.h>
 #include "internal.h"
 
 #include <linux/uaccess.h>
@@ -1547,7 +1548,8 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 {
 	struct inode *inode_in = file_inode(file_in);
 	struct inode *inode_out = file_inode(file_out);
-	ssize_t ret = 0;
+	ssize_t ret = 0, total = 0;
+	loff_t size, end;
 
 	if (len == 0)
 		return 0;
@@ -1572,10 +1574,62 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 		if (ret != -EOPNOTSUPP)
 			return ret;
 	}
+
 splice:
-	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
-			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
-	return ret;
+	while (total < len) {
+		end = vfs_llseek(file_in, pos_in, SEEK_HOLE);
+
+		/* Starting position is already in a hole */
+		if (end == pos_in)
+			goto hole;
+		size = end - pos_in;
+do_splice:
+		if (size > len - total)
+			size = len - total;
+		ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
+				size, 0);
+		if (ret < 0)
+			goto out;
+		total += ret;
+		if (total == len)
+			break;
+hole:
+		end = vfs_llseek(file_in, pos_in, SEEK_DATA);
+		if (end < 0) {
+			ret = end;
+			goto out;
+		}
+		size = end - pos_in;
+		if (size > len - total)
+			size = len - total;
+		/* Data on offset, punch holes */
+		if (i_size_read(file_out->f_inode) > pos_out) {
+			ret = vfs_fallocate(file_out,
+					FALLOC_FL_PUNCH_HOLE | FALLOC_FL_KEEP_SIZE,
+					pos_out, size);
+			if (ret < 0) {
+				/*
+				 * The filesystem does not support punching
+				 * holes. Perform splice on the remaining range.
+				 */
+				if (ret == -EOPNOTSUPP) {
+					size = len - total;
+					goto do_splice;
+				}
+				goto out;
+			}
+		}
+		if (ret < 0) {
+			ret = end;
+			goto out;
+		}
+		pos_out += size;
+		pos_in = end;
+		total += size;
+	}
+
+out:
+	return total ? total : ret;
 }
 
 /*
-- 
2.16.3

