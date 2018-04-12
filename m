From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 12/35] ovl: readd write_iter
Date: Thu, 12 Apr 2018 17:08:03 +0200
Message-ID: <20180412150826.20988-13-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
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
index a19429c5965d..b98204c1c19c 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -184,9 +184,48 @@ static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *iter)
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
+	ret = ovl_real_file(file, &real);
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
