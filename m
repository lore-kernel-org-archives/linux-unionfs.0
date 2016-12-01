From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 1/8] vfs: allow overlayfs to intercept file ops
Date: Thu,  1 Dec 2016 11:14:56 +0100
Message-ID: <1480587303-25088-2-git-send-email-mszeredi@redhat.com>
References: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Almost all of the time overlayfs just wants to let underlying filesystems
handle file operations on regular files.

There is a rare corner case, namely when a file residing a read-only
(lower) layer is:

 - opened for O_RDONLY
 - opened for O_WRONLY
 - contents modified
 - contents read back though O_RDONLY fd

Currently overlayfs gives inconsistent result in this case, since the
O_RDONLY file refers to the lower, unmodified file, even after the copy up
has happened.

This happens very rarely, so

a) we want the normal cases (when no copy up happens) still go as fast as
   possible;

b) we can let the corner case go slow.

The proposed solution is to allow overlayfs to intercept file operations if
it wants (O_RDONLY open of file on lower layer), but still let the file be
owned by the underlying layer.  This means everything in filp, including
the private_data, is controlled by the underlying layer (as it has been
until now) with the exception of f_op, which comes from overlayfs.

This patch doesn't change the actual behavior, it just adds the vfs change
necessary and then unconditionally sets the f_op back to the underlying
file's ops.

For non-overlayfs, this doesn't change anything.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/open.c            |  2 +-
 fs/overlayfs/inode.c | 18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/open.c b/fs/open.c
index 8a0254b56780..453ef5581389 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -734,7 +734,7 @@ static int do_dentry_open(struct file *f,
 	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))
 		f->f_mode |= FMODE_ATOMIC_POS;
 
-	f->f_op = fops_get(inode->i_fop);
+	f->f_op = fops_get(f->f_path.dentry->d_inode->i_fop);
 	if (unlikely(WARN_ON(!f->f_op))) {
 		error = -ENODEV;
 		goto cleanup_all;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index a10e948d24fa..1981a5514f51 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -11,6 +11,7 @@
 #include <linux/slab.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
+#include <linux/module.h>
 #include "overlayfs.h"
 
 static int ovl_copy_up_truncate(struct dentry *dentry)
@@ -333,6 +334,22 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.update_time	= ovl_update_time,
 };
 
+static int ovl_open(struct inode *inode, struct file *file)
+{
+	int ret = 0;
+
+	/* Want fops from real inode */
+	replace_fops(file, inode->i_fop);
+	if (file->f_op->open)
+		ret = file->f_op->open(inode, file);
+
+	return ret;
+}
+
+static const struct file_operations ovl_file_operations = {
+	.open		= ovl_open,
+};
+
 static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
 {
 	inode->i_ino = get_next_ino();
@@ -345,6 +362,7 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
 	switch (mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &ovl_file_inode_operations;
+		inode->i_fop = &ovl_file_operations;
 		break;
 
 	case S_IFDIR:
-- 
2.5.5
