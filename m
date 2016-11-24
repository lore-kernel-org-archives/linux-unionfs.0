From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5/7] ovl: intercept read_iter
Date: Thu, 24 Nov 2016 11:55:42 +0100
Message-ID: <1479984944-1017-7-git-send-email-mszeredi@redhat.com>
References: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:35142 "EHLO
        mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S964844AbcKXKz6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2016 05:55:58 -0500
Received: by mail-wm0-f44.google.com with SMTP id a197so109471690wmd.0
        for <linux-unionfs@vger.kernel.org>; Thu, 24 Nov 2016 02:55:57 -0800 (PST)
In-Reply-To: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org

...in order to handle the corner case when the file is copyied up after
being opened read-only.

Can be verified with the following script:

 - 8< - - - - - 8< - - - - - 8< - - - - - 8< - - - -
cd /
rm -rf /tmp/ovl-rorw-test
mkdir /tmp/ovl-rorw-test
cd /tmp/ovl-rorw-test
mkdir -p mnt lower upper work
echo baba > lower/foo
mount -t overlay overlay -olowerdir=lower,upperdir=upper,workdir=work mnt
exec 3< mnt/foo
echo bubu > mnt/foo
cat <&3
exec 3>&-
umount mnt
 - 8< - - - - - 8< - - - - - 8< - - - - - 8< - - - -

Correct output is "bubu", incorrect output is "baba".

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 3e26615c4697..09c6f99bd5db 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
 #include <linux/module.h>
+#include <linux/file.h>
 #include <linux/hashtable.h>
 #include "overlayfs.h"
 
@@ -368,6 +369,29 @@ void ovl_cleanup_fops_htable(void)
 		   __ofop->orig_fops->call;				 \
 	})
 
+static bool ovl_file_is_lower(struct file *file)
+{
+	return !OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
+}
+
+static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct file *file = iocb->ki_filp;
+	ssize_t ret;
+
+	if (likely(ovl_file_is_lower(file)))
+		return OVL_CALL_REAL_FOP(file, read_iter(iocb, to));
+
+	file = filp_clone_open(file);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
+
+	ret = vfs_iter_read(file, to, &iocb->ki_pos);
+	fput(file);
+
+	return ret;
+}
+
 static struct ovl_fops *ovl_fops_find(const struct file_operations *orig)
 {
 	struct ovl_fops *ofop;
@@ -404,8 +428,11 @@ static struct ovl_fops *ovl_fops_get(struct file *file)
 		ofop->magic = OVL_FOPS_MAGIC;
 		ofop->orig_fops = fops_get(orig);
 
+		/* Intercept these: */
+		if (orig->read_iter)
+			ofop->fops.read_iter = ovl_read_iter;
+
 		/* These will need to be intercepted: */
-		ofop->fops.read_iter = orig->read_iter;
 		ofop->fops.mmap = orig->mmap;
 		ofop->fops.fsync = orig->fsync;
 
-- 
2.5.5
