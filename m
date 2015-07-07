From: David Howells <dhowells@redhat.com>
Subject: [PATCH] overlayfs: Warn on copy up if a process has a R/O fd open to the lower file
Date: Tue, 07 Jul 2015 15:04:44 +0100
Message-ID: <9569.1436277884@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:35568 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757489AbbGGOEu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 7 Jul 2015 10:04:50 -0400
Content-ID: <9568.1436277884.1@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: miklos@szeredi.hu, viro@ZenIV.linux.org.uk
Cc: dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

    
Print a warning when overlayfs copies up a file if the process that triggered
the copy up has a R/O fd open to the lower file being copied up.

This can help catch applications that do things like the following:

	fd1 = open("foo", O_RDONLY);
	fd2 = open("foo", O_RDWR);

where they expect fd1 and fd2 to refer to the same file - which will no longer
be the case post-copy up.

With this patch, the following commands:

	bash 5</mnt/a/foo128
	6<>/mnt/a/foo128

assuming /mnt/a/foo128 to be an un-copied up file on an overlay will produce
the following warning in the kernel log:

	overlayfs: Copying up foo129, but open R/O on fd 5 which will cease to
	be coherent [pid=3818 bash]

This is enabled by setting:

	/sys/module/overlay/parameters/check_copy_up

to 1.

The warnings are ratelimited and are also limited to one warning per file -
assuming the copy up completes in each case.

Signed-off-by: David Howells <dhowells@redhat.com>
---
diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 84d693d37428..e1aef2ba2f08 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -7,6 +7,7 @@
  * the Free Software Foundation.
  */
 
+#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/file.h>
@@ -16,10 +17,41 @@
 #include <linux/uaccess.h>
 #include <linux/sched.h>
 #include <linux/namei.h>
+#include <linux/fdtable.h>
+#include <linux/ratelimit.h>
 #include "overlayfs.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
 
+static bool __read_mostly ovl_check_copy_up;
+module_param_named(check_copy_up, ovl_check_copy_up, bool,
+		   S_IWUSR | S_IRUGO);
+MODULE_PARM_DESC(ovl_check_copy_up,
+		 "Warn on copy-up when causing process also has a R/O fd open");
+
+static int ovl_check_fd(const void *data, struct file *f, unsigned fd)
+{
+	const struct dentry *dentry = data;
+
+	if (f->f_inode == d_inode(dentry))
+		pr_warn_ratelimited("overlayfs: Warning: Copying up %pD, but open R/O on fd %u which will cease to be coherent [pid=%d %s]\n",
+				    f, fd, current->pid, current->comm);
+	return 0;
+}
+
+/*
+ * Check the fds open by this process and warn if something like the following
+ * scenario is about to occur:
+ *
+ *	fd1 = open("foo", O_RDONLY);
+ *	fd2 = open("foo", O_RDWR);
+ */
+static void ovl_do_check_copy_up(struct dentry *dentry)
+{
+	if (ovl_check_copy_up)
+		iterate_fd(current->files, 0, ovl_check_fd, dentry);
+}
+
 int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 {
 	ssize_t list_size, size;
@@ -302,6 +334,8 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (WARN_ON(!workdir))
 		return -EROFS;
 
+	ovl_do_check_copy_up(lowerpath->dentry);
+
 	ovl_path_upper(parent, &parentpath);
 	upperdir = parentpath.dentry;
 
