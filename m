From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/25] vfs: skip zero-length dedupe requests
Date: Wed, 10 Oct 2018 21:13:06 -0700
Message-ID: <153923118667.5546.2251008065628647198.stgit@magnolia>
References: <153923113649.5546.9840926895953408273.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <153923113649.5546.9840926895953408273.stgit@magnolia>
Sender: linux-btrfs-owner@vger.kernel.org
To: david@fromorbit.com, darrick.wong@oracle.com
Cc: sandeen@redhat.com, linux-nfs@vger.kernel.org, linux-cifs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, linux-xfs@vger.kernel.org, linux-mm@kvack.org, linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@lst.de>, ocfs2-devel@oss.oracle.com
List-Id: linux-unionfs@vger.kernel.org

From: Darrick J. Wong <darrick.wong@oracle.com>

Don't bother calling the filesystem for a zero-length dedupe request;
we can return zero and exit.

Signed-off-by: Darrick J. Wong <darrick.wong@oracle.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c |    5 +++++
 1 file changed, 5 insertions(+)


diff --git a/fs/read_write.c b/fs/read_write.c
index 8498991e2f33..48d83231968f 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1996,6 +1996,11 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
 	if (!dst_file->f_op->dedupe_file_range)
 		goto out_drop_write;
 
+	if (len == 0) {
+		ret = 0;
+		goto out_drop_write;
+	}
+
 	ret = dst_file->f_op->dedupe_file_range(src_file, src_pos,
 						dst_file, dst_pos, len);
 out_drop_write:
