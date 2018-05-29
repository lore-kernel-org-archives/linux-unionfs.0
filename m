From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 16/39] ovl: add ovl_read_iter()
Date: Tue, 29 May 2018 16:43:16 +0200
Message-ID: <20180529144339.16538-17-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Implement stacked reading.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 67 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 67 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index db8778e7c37a..bbc40a14acf8 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -9,6 +9,7 @@
 #include <linux/cred.h>
 #include <linux/file.h>
 #include <linux/xattr.h>
+#include <linux/uio.h>
 #include "overlayfs.h"
 
 static struct file *ovl_open_realfile(const struct file *file)
@@ -129,8 +130,74 @@ static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
 					i_size_read(realinode));
 }
 
+static void ovl_file_accessed(struct file *file)
+{
+	struct inode *inode, *upperinode;
+
+	if (file->f_flags & O_NOATIME)
+		return;
+
+	inode = file_inode(file);
+	upperinode = ovl_inode_upper(inode);
+
+	if (!upperinode)
+		return;
+
+	if ((!timespec_equal(&inode->i_mtime, &upperinode->i_mtime) ||
+	     !timespec_equal(&inode->i_ctime, &upperinode->i_ctime))) {
+		inode->i_mtime = upperinode->i_mtime;
+		inode->i_ctime = upperinode->i_ctime;
+	}
+
+	touch_atime(&file->f_path);
+}
+
+static rwf_t ovl_iocb_to_rwf(struct kiocb *iocb)
+{
+	int ifl = iocb->ki_flags;
+	rwf_t flags = 0;
+
+	if (ifl & IOCB_NOWAIT)
+		flags |= RWF_NOWAIT;
+	if (ifl & IOCB_HIPRI)
+		flags |= RWF_HIPRI;
+	if (ifl & IOCB_DSYNC)
+		flags |= RWF_DSYNC;
+	if (ifl & IOCB_SYNC)
+		flags |= RWF_SYNC;
+
+	return flags;
+}
+
+static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+	struct fd real;
+	const struct cred *old_cred;
+	ssize_t ret;
+
+	if (!iov_iter_count(iter))
+		return 0;
+
+	ret = ovl_real_fdget(file, &real);
+	if (ret)
+		return ret;
+
+	old_cred = ovl_override_creds(file_inode(file)->i_sb);
+	ret = vfs_iter_read(real.file, iter, &iocb->ki_pos,
+			    ovl_iocb_to_rwf(iocb));
+	revert_creds(old_cred);
+
+	ovl_file_accessed(file);
+
+	fdput(real);
+
+	return ret;
+}
+
 const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 	.release	= ovl_release,
 	.llseek		= ovl_llseek,
+	.read_iter	= ovl_read_iter,
 };
-- 
2.14.3
