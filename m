From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 18/29] vfs: clean up
 generic_remap_file_range_prep return value
Date: Wed, 17 Oct 2018 15:46:25 -0700
Message-ID: <153981638588.5568.15494557106783144592.stgit@magnolia>
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
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, ocfs2-devel@oss.oracle.com, linux-fsdevel@vger.kernel.org, linux-btrfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Since the remap prep function can update the length of the remap
request, we can change this function to return the usual return status
instead of the odd behavior it has now.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 fs/ocfs2/refcounttree.c |    2 +-
 fs/read_write.c         |    6 +++---
 fs/xfs/xfs_reflink.c    |    4 ++--
 3 files changed, 6 insertions(+), 6 deletions(-)


diff --git a/fs/ocfs2/refcounttree.c b/fs/ocfs2/refcounttree.c
index 6a42c04ac0ab..46bbd315c39f 100644
--- a/fs/ocfs2/refcounttree.c
+++ b/fs/ocfs2/refcounttree.c
@@ -4852,7 +4852,7 @@ int ocfs2_reflink_remap_range(struct file *file_in,
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			&len, remap_flags);
-	if (ret <= 0)
+	if (ret < 0 || len == 0)
 		goto out_unlock;
 
 	/* Lock out changes to the allocation maps and remap. */
diff --git a/fs/read_write.c b/fs/read_write.c
index e4d295d0d236..6b40a43edf18 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1848,8 +1848,8 @@ static int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
  * sense, and then flush all dirty data.  Caller must ensure that the
  * inodes have been locked against any other modifications.
  *
- * Returns: 0 for "nothing to clone", 1 for "something to clone", or
- * the usual negative error code.
+ * If there's an error, then the usual negative error code is returned.
+ * Otherwise returns 0 with *len set to the request length.
  */
 int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 				  struct file *file_out, loff_t pos_out,
@@ -1945,7 +1945,7 @@ int generic_remap_file_range_prep(struct file *file_in, loff_t pos_in,
 			return ret;
 	}
 
-	return 1;
+	return 0;
 }
 EXPORT_SYMBOL(generic_remap_file_range_prep);
 
diff --git a/fs/xfs/xfs_reflink.c b/fs/xfs/xfs_reflink.c
index 3dbe5fb7e9c0..9b1ea42c81d1 100644
--- a/fs/xfs/xfs_reflink.c
+++ b/fs/xfs/xfs_reflink.c
@@ -1329,7 +1329,7 @@ xfs_reflink_remap_prep(
 
 	ret = generic_remap_file_range_prep(file_in, pos_in, file_out, pos_out,
 			len, remap_flags);
-	if (ret <= 0)
+	if (ret < 0 || *len == 0)
 		goto out_unlock;
 
 	/*
@@ -1409,7 +1409,7 @@ xfs_reflink_remap_range(
 	/* Prepare and then clone file data. */
 	ret = xfs_reflink_remap_prep(file_in, pos_in, file_out, pos_out,
 			&len, remap_flags);
-	if (ret <= 0)
+	if (ret < 0 || len == 0)
 		return ret;
 
 	trace_xfs_reflink_remap_range(src, pos_in, len, dest, pos_out);
