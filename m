From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 17/39] ovl: add ovl_write_iter()
Date: Tue, 29 May 2018 16:43:17 +0200
Message-ID: <20180529144339.16538-18-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Implement stacked writes.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index bbc40a14acf8..a7af56861aa5 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -195,9 +195,48 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
 	return ret;
 }
 
+static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
+{
+	struct file *file = iocb->ki_filp;
+	struct inode *inode = file_inode(file);
+	struct fd real;
+	const struct cred *old_cred;
+	ssize_t ret;
+
+	if (!iov_iter_count(iter))
+		return 0;
+
+	inode_lock(inode);
+	/* Update mode */
+	ovl_copyattr(ovl_inode_real(inode), inode);
+	ret = file_remove_privs(file);
+	if (ret)
+		goto out_unlock;
+
+	ret = ovl_real_fdget(file, &real);
+	if (ret)
+		goto out_unlock;
+
+	old_cred = ovl_override_creds(file_inode(file)->i_sb);
+	ret = vfs_iter_write(real.file, iter, &iocb->ki_pos,
+			     ovl_iocb_to_rwf(iocb));
+	revert_creds(old_cred);
+
+	/* Update size */
+	ovl_copyattr(ovl_inode_real(inode), inode);
+
+	fdput(real);
+
+out_unlock:
+	inode_unlock(inode);
+
+	return ret;
+}
+
 const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 	.release	= ovl_release,
 	.llseek		= ovl_llseek,
 	.read_iter	= ovl_read_iter,
+	.write_iter	= ovl_write_iter,
 };
-- 
2.14.3
