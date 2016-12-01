From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 8/8] Revert "ovl: Warn on copy up if a process has a R/O fd open to the lower file"
Date: Thu,  1 Dec 2016 11:15:03 +0100
Message-ID: <1480587303-25088-9-git-send-email-mszeredi@redhat.com>
References: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This reverts commit fb5bb2c3b73df060d588b6521de5ab03589283f7.

The check is no longer needed since the effected corner case is now handled
correctly by overlayfs.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/copy_up.c | 34 ----------------------------------
 1 file changed, 34 deletions(-)

diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
index 6c3aaf45e9cf..7bf7167ba61e 100644
--- a/fs/overlayfs/copy_up.c
+++ b/fs/overlayfs/copy_up.c
@@ -7,7 +7,6 @@
  * the Free Software Foundation.
  */
 
-#include <linux/module.h>
 #include <linux/fs.h>
 #include <linux/slab.h>
 #include <linux/file.h>
@@ -17,41 +16,10 @@
 #include <linux/uaccess.h>
 #include <linux/sched.h>
 #include <linux/namei.h>
-#include <linux/fdtable.h>
-#include <linux/ratelimit.h>
 #include "overlayfs.h"
 
 #define OVL_COPY_UP_CHUNK_SIZE (1 << 20)
 
-static bool __read_mostly ovl_check_copy_up;
-module_param_named(check_copy_up, ovl_check_copy_up, bool,
-		   S_IWUSR | S_IRUGO);
-MODULE_PARM_DESC(ovl_check_copy_up,
-		 "Warn on copy-up when causing process also has a R/O fd open");
-
-static int ovl_check_fd(const void *data, struct file *f, unsigned int fd)
-{
-	const struct dentry *dentry = data;
-
-	if (f->f_inode == d_inode(dentry))
-		pr_warn_ratelimited("overlayfs: Warning: Copying up %pD, but open R/O on fd %u which will cease to be coherent [pid=%d %s]\n",
-				    f, fd, current->pid, current->comm);
-	return 0;
-}
-
-/*
- * Check the fds open by this process and warn if something like the following
- * scenario is about to occur:
- *
- *	fd1 = open("foo", O_RDONLY);
- *	fd2 = open("foo", O_RDWR);
- */
-static void ovl_do_check_copy_up(struct dentry *dentry)
-{
-	if (ovl_check_copy_up)
-		iterate_fd(current->files, 0, ovl_check_fd, dentry);
-}
-
 int ovl_copy_xattr(struct dentry *old, struct dentry *new)
 {
 	ssize_t list_size, size, value_size = 0;
@@ -339,8 +307,6 @@ int ovl_copy_up_one(struct dentry *parent, struct dentry *dentry,
 	if (WARN_ON(!workdir))
 		return -EROFS;
 
-	ovl_do_check_copy_up(lowerdentry);
-
 	ovl_path_upper(parent, &parentpath);
 	upperdir = parentpath.dentry;
 
-- 
2.5.5
