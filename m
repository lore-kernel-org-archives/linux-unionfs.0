Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 2/6] ovl: fix GPF in swapfile_activate of file from overlayfs over xfs
Date: Mon, 27 Aug 2018 15:56:00 +0300
Message-Id: <1535374564-8257-3-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
References: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Since overlayfs implements stacked file operations, the underlying
filesystems are not supposed to be exposed to the overlayfs file,
whose f_inode is an overlayfs inode.

Assigning an overlayfs file to swap_file results in an attempt of xfs
code to dereference an xfs_inode struct from an ovl_inode pointer:

 CPU: 0 PID: 2462 Comm: swapon Not tainted
 4.18.0-xfstests-12721-g33e17876ea4e #3402
 RIP: 0010:xfs_find_bdev_for_inode+0x23/0x2f
 Call Trace:
  xfs_iomap_swapfile_activate+0x1f/0x43
  __se_sys_swapon+0xb1a/0xee9

Fix this by not assigning the real inode mapping to f_mapping, which
will cause swapon() to return an error (-EINVAL). Although it makes
sense not to allow setting swpafile on an overlayfs file, some users
may depend on it, so we may need to fix this up in the future.

Keeping f_mapping pointing to overlay inode mapping will cause O_DIRECT
open to fail. Fix this by installing ovl_aops with noop_direct_IO in
overlay inode mapping.

Keeping f_mapping pointing to overlay inode mapping will cause other
a_ops related operations to fail (e.g. readahead()). Those will be
fixed by follow up patches.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: f7c72396d0de ("ovl: add O_DIRECT support")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c  | 3 ---
 fs/overlayfs/inode.c | 6 ++++++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 32e9282893c9..a4acd84591d4 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -131,9 +131,6 @@ static int ovl_open(struct inode *inode, struct file *file)
 	if (IS_ERR(realfile))
 		return PTR_ERR(realfile);
 
-	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
-	file->f_mapping = realfile->f_mapping;
-
 	file->private_data = realfile;
 
 	return 0;
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 5014749fd4b4..b6ac545b5a32 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -504,6 +504,11 @@ static const struct inode_operations ovl_special_inode_operations = {
 	.update_time	= ovl_update_time,
 };
 
+const struct address_space_operations ovl_aops = {
+	/* For O_DIRECT dentry_open() checks f_mapping->a_ops->direct_IO */
+	.direct_IO		= noop_direct_IO,
+};
+
 /*
  * It is possible to stack overlayfs instance on top of another
  * overlayfs instance as lower layer. We need to annonate the
@@ -575,6 +580,7 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev,
 	case S_IFREG:
 		inode->i_op = &ovl_file_inode_operations;
 		inode->i_fop = &ovl_file_operations;
+		inode->i_mapping->a_ops = &ovl_aops;
 		break;
 
 	case S_IFDIR:
-- 
2.7.4
