Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45351 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755727AbeEHVYY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 8 May 2018 17:24:24 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 2/4] copy_file_range: Perform splice if in/out SB are not same
Date: Tue,  8 May 2018 16:24:03 -0500
Message-Id: <20180508212405.15297-3-rgoldwyn@suse.de>
In-Reply-To: <20180508212405.15297-1-rgoldwyn@suse.de>
References: <20180508212405.15297-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, david@fromorbit.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

While performing copy_file_range(), if superblocks of file_in and
file_out don't match, instead of returning -EXDEV, perform
splice for a faster copy.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/read_write.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 7d9dfb62ba7d..2c9e7a5ea806 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1546,6 +1546,8 @@ ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 			    size_t len, unsigned int flags,
 			    unsigned int splice_flags)
 {
+	struct inode *inode_in = file_inode(file_in);
+	struct inode *inode_out = file_inode(file_out);
 	ssize_t ret = 0;
 
 	if (flags != 0)
@@ -1554,6 +1556,9 @@ ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (len == 0)
 		return 0;
 
+	if (inode_in->i_sb != inode_out->i_sb)
+		goto splice;
+
 	/*
 	 * Try cloning first, this is supported by more file systems, and
 	 * more efficient if both clone and copy are supported (e.g. NFS).
@@ -1571,7 +1576,7 @@ ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 		if (ret != -EOPNOTSUPP)
 			return ret;
 	}
-
+splice:
 	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
 			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, splice_flags);
 	return ret;
@@ -1608,10 +1613,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	    (file_out->f_flags & O_APPEND))
 		return -EBADF;
 
-	/* this could be relaxed once a method supports cross-fs copies */
-	if (inode_in->i_sb != inode_out->i_sb)
-		return -EXDEV;
-
 	file_start_write(file_out);
 
 	ret = do_copy_file_range(file_in, pos_in,
-- 
2.16.3

