From: Murphy Zhou <jencce.kernel@gmail.com>
Subject: [PATCH] fs/overlayfs: add splice file read write helper
Date: Fri, 17 Jan 2020 20:49:29 +0800
Message-ID: <20200117124929.6nhgpd7mgcbwae5z@xzhoux.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-pg1-f194.google.com ([209.85.215.194]:36950 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726587AbgAQMth (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Jan 2020 07:49:37 -0500
Received: by mail-pg1-f194.google.com with SMTP id q127so11642751pga.4
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Jan 2020 04:49:37 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org

Now overlayfs falls back to use default file splice read
and write, which is not compatiple with overlayfs, returning
EFAULT. xfstests generic/591 can reproduce part of this.

Tested this patch with xfstests auto group tests.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 fs/overlayfs/file.c | 47 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index e235a63..0546e9f 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -9,6 +9,9 @@
 #include <linux/xattr.h>
 #include <linux/uio.h>
 #include <linux/uaccess.h>
+#include <linux/splice.h>
+#include <linux/mm.h>
+#include <linux/fs.h>
 #include "overlayfs.h"
 
 static char ovl_whatisit(struct inode *inode, struct inode *realinode)
@@ -291,6 +294,48 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	return ret;
 }
 
+static ssize_t ovl_splice_read(struct file *in, loff_t *ppos,
+			 struct pipe_inode_info *pipe, size_t len,
+			 unsigned int flags)
+{
+	ssize_t ret;
+	struct fd real;
+	const struct cred *old_cred;
+
+	ret = ovl_real_fdget(in, &real);
+	if (ret)
+		return ret;
+
+	old_cred = ovl_override_creds(file_inode(in)->i_sb);
+	ret = generic_file_splice_read(real.file, ppos, pipe, len, flags);
+	revert_creds(old_cred);
+
+	ovl_file_accessed(in);
+	fdput(real);
+	return ret;
+}
+
+static ssize_t
+ovl_splice_write(struct pipe_inode_info *pipe, struct file *out,
+			  loff_t *ppos, size_t len, unsigned int flags)
+{
+	struct fd real;
+	const struct cred *old_cred;
+	ssize_t ret;
+
+	ret = ovl_real_fdget(out, &real);
+	if (ret)
+		return ret;
+
+	old_cred = ovl_override_creds(file_inode(out)->i_sb);
+	ret = iter_file_splice_write(pipe, real.file, ppos, len, flags);
+	revert_creds(old_cred);
+
+	ovl_file_accessed(out);
+	fdput(real);
+	return ret;
+}
+
 static int ovl_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 {
 	struct fd real;
@@ -647,6 +692,8 @@ static loff_t ovl_remap_file_range(struct file *file_in, loff_t pos_in,
 	.fadvise	= ovl_fadvise,
 	.unlocked_ioctl	= ovl_ioctl,
 	.compat_ioctl	= ovl_compat_ioctl,
+	.splice_read    = ovl_splice_read,
+	.splice_write   = ovl_splice_write,
 
 	.copy_file_range	= ovl_copy_file_range,
 	.remap_file_range	= ovl_remap_file_range,
-- 
1.8.3.1
