From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 18/39] ovl: add ovl_fsync()
Date: Tue, 29 May 2018 16:43:18 +0200
Message-ID: <20180529144339.16538-19-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Implement stacked fsync().

Don't sync if lower (noticed by Amir Goldstein).

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/file.c | 23 +++++++++++++++++++++++
 1 file changed, 23 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index a7af56861aa5..7b47dce4b072 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -233,10 +233,33 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	return ret;
 }
 
+static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	struct fd real;
+	const struct cred *old_cred;
+	int ret;
+
+	ret = ovl_real_fdget(file, &real);
+	if (ret)
+		return ret;
+
+	/* Don't sync lower file for fear of receiving EROFS error */
+	if (file_inode(real.file) == ovl_inode_upper(file_inode(file))) {
+		old_cred = ovl_override_creds(file_inode(file)->i_sb);
+		ret = vfs_fsync_range(real.file, start, end, datasync);
+		revert_creds(old_cred);
+	}
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
 	.read_iter	= ovl_read_iter,
 	.write_iter	= ovl_write_iter,
+	.fsync		= ovl_fsync,
 };
-- 
2.14.3
