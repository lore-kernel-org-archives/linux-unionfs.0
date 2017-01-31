From: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 2/5] vfs: deny copy_file_range() for non regular files
Date: Tue, 31 Jan 2017 10:34:56 +0200
Message-ID: <1485851699-25313-3-git-send-email-amir73il@gmail.com>
References: <1485851699-25313-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485851699-25313-1-git-send-email-amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-api-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Miklos Szeredi <miklos-sUDqSbJrdHQHWmgEVkV9KA@public.gmane.org>
Cc: Jan Kara <jack-IBi9RG/b67k@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, linux-unionfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-unionfs@vger.kernel.org

There is no in-tree file system that implements copy_file_range()
for non regular files.

Deny an attempt to copy_file_range() a directory with EISDIR
and any other non regualr file with EINVAL to conform with
behavior of vfs_{clone,dedup}_file_range().

This change is needed prior to converting sb_start_write()
to  file_start_write() in the vfs helper.

Cc: linux-api-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Al Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Signed-off-by: Amir Goldstein <amir73il-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 fs/read_write.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/read_write.c b/fs/read_write.c
index 5816d4c..511178d 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1518,6 +1518,11 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (flags != 0)
 		return -EINVAL;
 
+	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
+		return -EISDIR;
+	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+		return -EINVAL;
+
 	ret = rw_verify_area(READ, file_in, &pos_in, len);
 	if (unlikely(ret))
 		return ret;
-- 
2.7.4
