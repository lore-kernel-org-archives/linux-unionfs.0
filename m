Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:59652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754127AbeENO4q (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 14 May 2018 10:56:46 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 2/4] copy_file_range: Perform splice if in/out SB are not same
Date: Mon, 14 May 2018 09:56:35 -0500
Message-Id: <20180514145637.22711-3-rgoldwyn@suse.de>
In-Reply-To: <20180514145637.22711-1-rgoldwyn@suse.de>
References: <20180514145637.22711-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, linux-unionfs@vger.kernel.org, david@fromorbit.com, amir73il@gmail.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

While performing copy_file_range(), if superblocks of file_in and
file_out don't match, instead of returning -EXDEV, perform
splice for a faster copy.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 525f2a67e15a..1b8fc9eada69 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1545,11 +1545,16 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 			    struct file *file_out, loff_t pos_out,
 			    size_t len, unsigned int flags)
 {
+	struct inode *inode_in = file_inode(file_in);
+	struct inode *inode_out = file_inode(file_out);
 	ssize_t ret = 0;
 
 	if (len == 0)
 		return 0;
 
+	if (inode_in->i_sb != inode_out->i_sb)
+		goto splice;
+
 	/*
 	 * Try cloning first, this is supported by more file systems, and
 	 * more efficient if both clone and copy are supported (e.g. NFS).
@@ -1567,7 +1572,7 @@ static ssize_t do_copy_file_range(struct file *file_in, loff_t pos_in,
 		if (ret != -EOPNOTSUPP)
 			return ret;
 	}
-
+splice:
 	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
 			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
 	return ret;
@@ -1607,10 +1612,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
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

