From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 02/25] vfs: vfs_clone_file_prep_inodes should return EINVAL
 for a clone from beyond EOF
Date: Wed, 10 Oct 2018 21:12:30 -0700
Message-ID: <153923115041.5546.14464512857556875980.stgit@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <153923113649.5546.9840926895953408273.stgit@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

vfs_clone_file_prep_inodes cannot return 0 if it is asked to remap from
a zero byte file because that's what btrfs does.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
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
