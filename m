Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:55639 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756386AbeEJB63 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 9 May 2018 21:58:29 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/4] copy_file_range: refactor vfs_copy_file_range
Date: Wed,  9 May 2018 20:58:17 -0500
Message-Id: <20180510015820.17700-2-rgoldwyn@suse.de>
In-Reply-To: <20180510015820.17700-1-rgoldwyn@suse.de>
References: <20180510015820.17700-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, linux-unionfs@vger.kernel.org, david@fromorbit.com, viro@zeniv.linux.org.uk, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Preparatory patch to carve out do_copy_file_range() from
vfs_copy_file_range

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/read_write.c | 60 ++++++++++++++++++++++++++++++++-------------------------
 1 file changed, 34 insertions(+), 26 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index c4eabbfc90df..525f2a67e15a 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1541,6 +1541,38 @@ COMPAT_SYSCALL_DEFINE4(sendfile64, int, out_fd, int, in_fd,
 }
 #endif
 
+static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
+			    struct file *file_out, loff_t pos_out,
+			    size_t len, unsigned int flags)
+{
+	ssize_t ret = 0;
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
+			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
+	return ret;
+}
+
 /*
  * copy_file_range() differs from regular file read and write in that it
  * specifically allows return partial success.  When it does so is up to
@@ -1579,35 +1611,11 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
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
+			file_out, pos_out, len, flags);
 
-done:
 	if (ret > 0) {
 		fsnotify_access(file_in);
 		add_rchar(current, ret);
-- 
2.16.3

