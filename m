Return-Path: <olga.kornievskaia@gmail.com>
Return-Path: <olga.kornievskaia@gmail.com>
From: Olga Kornievskaia <olga.kornievskaia@gmail.com>
Subject: [PATCH v6 01/12] VFS: generic cross-device copy_file_range() support for all filesystems
Date: Mon, 29 Oct 2018 15:03:45 -0400
Message-Id: <20181029190357.38439-2-olga.kornievskaia@gmail.com>
In-Reply-To: <20181029190357.38439-1-olga.kornievskaia@gmail.com>
References: <20181029190357.38439-1-olga.kornievskaia@gmail.com>
To: trond.myklebust@hammerspace.com, anna.schumaker@netapp.com, viro@zeniv.linux.org.uk, smfrench@gmail.com, miklos@szeredi.hu
Cc: linux-nfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-cifs@vger.kernel.org, linux-unionfs@vger.kernel.org, linux-man@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

From: Olga Kornievskaia <kolga@netapp.com>

In preparation for enabling cross-device offloading of
copy_file_range() functionality, first enable generic cross-device
support by allowing copy_file_range() to fall back to a page cache
based physical data copy. This means the copy_file_range() syscall
will never fail with EXDEV, and so in future userspace will not need
to detect or provide a fallback for failed cross-device copies
anymore.

This requires pushing the cross device support checks down into the
filesystem ->copy_file_range methods and falling back to the page
cache copy if they return EXDEV. This will come in the following
patch. Now enforcing same superblock check for copy_file_range().

Further, clone_file_range() is only supported within a filesystem,
so we must also check that the files belong to the same superblock
before calling ->clone_file_range(). If they are on different
superblocks, skip the attempt to clone the file and instead try to
copy the file.

Signed-off-by: Olga Kornievskaia <kolga@netapp.com>
---
 fs/read_write.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 39b4a21..70f6939 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1575,10 +1575,6 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	    (file_out->f_flags & O_APPEND))
 		return -EBADF;
 
-	/* this could be relaxed once a method supports cross-fs copies */
-	if (inode_in->i_sb != inode_out->i_sb)
-		return -EXDEV;
-
 	if (len == 0)
 		return 0;
 
@@ -1588,7 +1584,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	 * Try cloning first, this is supported by more file systems, and
 	 * more efficient if both clone and copy are supported (e.g. NFS).
 	 */
-	if (file_in->f_op->clone_file_range) {
+	if (inode_in->i_sb == inode_out->i_sb &&
+	    file_in->f_op->clone_file_range) {
 		ret = file_in->f_op->clone_file_range(file_in, pos_in,
 				file_out, pos_out, len);
 		if (ret == 0) {
@@ -1597,7 +1594,8 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 		}
 	}
 
-	if (file_out->f_op->copy_file_range) {
+	if (inode_in->i_sb == inode_out->i_sb &&
+	    file_out->f_op->copy_file_range) {
 		ret = file_out->f_op->copy_file_range(file_in, pos_in, file_out,
 						      pos_out, len, flags);
 		if (ret != -EOPNOTSUPP)
-- 
1.8.3.1
