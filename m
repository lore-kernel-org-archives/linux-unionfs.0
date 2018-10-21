From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 01/28] vfs: vfs_clone_file_prep_inodes should return EINVAL
 for a clone from beyond EOF
Date: Sun, 21 Oct 2018 09:15:10 -0700
Message-ID: <154013851007.29026.6847850518000401463.stgit@magnolia>
References: <154013850285.29026.16168387526580596209.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <154013850285.29026.16168387526580596209.stgit@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

vfs_clone_file_prep_inodes cannot return 0 if it is asked to remap from
a zero byte file because that's what btrfs does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/read_write.c |    3 ---
 1 file changed, 3 deletions(-)


diff --git a/fs/read_write.c b/fs/read_write.c
index 8a2737f0d61d..260797b01851 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1740,10 +1740,7 @@ int vfs_clone_file_prep_inodes(struct inode *inode_in, loff_t pos_in,
 	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
 		return -EINVAL;
 
-	/* Are we going all the way to the end? */
 	isize = i_size_read(inode_in);
-	if (isize == 0)
-		return 0;
 
 	/* Zero length dedupe exits immediately; reflink goes to EOF. */
 	if (*len == 0) {
