From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 24/29] xfs: fix pagecache truncation prior to
	reflink
Date: Wed, 17 Oct 2018 15:47:06 -0700
Message-ID: <153981642640.5568.16793693439327747778.stgit@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <ocfs2-devel-bounces@oss.oracle.com>
In-Reply-To: <153981625504.5568.2708520119290577378.stgit@magnolia>
List-Unsubscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=unsubscribe>
List-Archive: <http://oss.oracle.com/pipermail/ocfs2-devel>
List-Post: <mailto:ocfs2-devel@oss.oracle.com>
List-Help: <mailto:ocfs2-devel-request@oss.oracle.com?subject=help>
List-Subscribe: <https://oss.oracle.com/mailman/listinfo/ocfs2-devel>,
	<mailto:ocfs2-devel-request@oss.oracle.com?subject=subscribe>
Sender: ocfs2-devel-bounces@oss.oracle.com
Errors-To: ocfs2-devel-bounces@oss.oracle.com
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, Dave Chinner <dchinner@redhat.com>, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Prior to remapping blocks, it is necessary to remove pages from the
destination file's page cache.  Unfortunately, the truncation is not
aggressive enough -- if page size > block size, we'll end up zeroing
subpage blocks instead of removing them.  So, round the start offset
down and the end offset up to page boundaries.  We already wrote all
the dirty data so the larger range shouldn't be a problem.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Dave Chinner <dchinner@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/xfs/xfs_reflink.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)


diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 9b1ea42c81d1..e8e86646bb4b 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1369,8 +1369,9 @@ xfs_reflink_remap_prep(
 		goto out_unlock;
 
 	/* Zap any page cache for the destination file's range. */
-	truncate_inode_pages_range(&inode_out->i_data, pos_out,
-				   PAGE_ALIGN(pos_out + *len) - 1);
+	truncate_inode_pages_range(&inode_out->i_data,
+			round_down(pos_out, PAGE_SIZE),
+			round_up(pos_out + *len, PAGE_SIZE) - 1);
 
 	return 1;
 out_unlock:
