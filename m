Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52971 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751140AbeECP0s (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 3 May 2018 11:26:48 -0400
From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/3] Perform splice in copy_file_range if in/out SB are not same
Date: Thu,  3 May 2018 10:26:33 -0500
Message-Id: <20180503152635.14974-2-rgoldwyn@suse.de>
In-Reply-To: <20180503152635.14974-1-rgoldwyn@suse.de>
References: <20180503152635.14974-1-rgoldwyn@suse.de>
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: hch@lst.de, smfrench@gmail.com, linux-unionfs@vger.kernel.org, Anna.Schumaker@Netapp.com, darrick.wong@oracle.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-ID: <linux-unionfs@vger.kernel.org>

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

While performing copy_file_range(), if superblocks of file_in and
file_out don't match, instead of returning -EXDEV, perform
splice for a faster copy.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 fs/read_write.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index c4eabbfc90df..e71270033402 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1575,15 +1575,14 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	    (file_out->f_flags & O_APPEND))
 		return -EBADF;
 
-	/* this could be relaxed once a method supports cross-fs copies */
-	if (inode_in->i_sb != inode_out->i_sb)
-		return -EXDEV;
-
 	if (len == 0)
 		return 0;
 
 	file_start_write(file_out);
 
+	if (inode_in->i_sb != inode_out->i_sb)
+		goto do_splice;
+
 	/*
 	 * Try cloning first, this is supported by more file systems, and
 	 * more efficient if both clone and copy are supported (e.g. NFS).
@@ -1604,6 +1603,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 			goto done;
 	}
 
+do_splice:
 	ret = do_splice_direct(file_in, &pos_in, file_out, &pos_out,
 			len > MAX_RW_COUNT ? MAX_RW_COUNT : len, 0);
 
-- 
2.16.3

