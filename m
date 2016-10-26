From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] vfs: fix vfs_clone_file_range() for overlayfs files
Date: Wed, 26 Oct 2016 22:34:01 +0300
Message-ID: <1477510441-24861-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Christoph Hellwig <hch@lst.de>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

With overlayfs, it is wrong to compare file_inode(inode)->i_sb
of regular files with those of non-regular files, because the
former reference the real (upper/lower) sb and the latter reference
the overlayfs sb.

Move the test for same super block after the sanity tests for
clone range of directory and non-regular file.

This change fixes xfstest generic/157, which returned EXDEV instead
of EISDIR/EINVAL in the following test cases over overlayfs:

  echo "Try to reflink a dir"
  _reflink_range $testdir1/dir1 0 $testdir1/file2 0 $blksz

  echo "Try to reflink a device"
  _reflink_range $testdir1/dev1 0 $testdir1/file2 0 $blksz

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/read_write.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/fs/read_write.c b/fs/read_write.c
index 1244bd5..d547301 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1657,6 +1657,11 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	struct inode *inode_out = file_inode(file_out);
 	int ret;
 
+	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
+		return -EISDIR;
+	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
+		return -EINVAL;
+
 	/*
 	 * FICLONE/FICLONERANGE ioctls enforce that src and dest files are on
 	 * the same mount. Practically, they only need to be on the same file
@@ -1665,11 +1670,6 @@ int vfs_clone_file_range(struct file *file_in, loff_t pos_in,
 	if (inode_in->i_sb != inode_out->i_sb)
 		return -EXDEV;
 
-	if (S_ISDIR(inode_in->i_mode) || S_ISDIR(inode_out->i_mode))
-		return -EISDIR;
-	if (!S_ISREG(inode_in->i_mode) || !S_ISREG(inode_out->i_mode))
-		return -EINVAL;
-
 	if (!(file_in->f_mode & FMODE_READ) ||
 	    !(file_out->f_mode & FMODE_WRITE) ||
 	    (file_out->f_flags & O_APPEND))
-- 
2.7.4

