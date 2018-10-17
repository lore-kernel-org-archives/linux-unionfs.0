From: "Darrick J. Wong" <darrick.wong@oracle.com>
Subject: [PATCH 06/29] vfs: skip zero-length dedupe requests
Date: Wed, 17 Oct 2018 15:44:56 -0700
Message-ID: <153981629660.5568.10517610908803733732.stgit@magnolia>
References: <153981625504.5568.2708520119290577378.stgit@magnolia>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <153981625504.5568.2708520119290577378.stgit@magnolia>
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
index 0f0a6efdd502..f5395d8da741 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -2009,6 +2009,11 @@ int vfs_dedupe_file_range_one(struct file *src_file, loff_t src_pos,
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
