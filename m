From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 36/39] Revert "vfs: do get_write_access() on upper layer of overlayfs"
Date: Tue, 29 May 2018 16:43:36 +0200
Message-ID: <20180529144339.16538-37-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This reverts commit 4d0c5ba2ff79ef9f5188998b29fd28fcb05f3667.

We now get write access on both overlay and underlying layers so this patch
is no longer needed for correct operation.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/locks.c |  3 +--
 fs/open.c  | 15 ++-------------
 2 files changed, 3 insertions(+), 15 deletions(-)

diff --git a/fs/locks.c b/fs/locks.c
index 62bbe8b31f26..9c0e5f3da66c 100644
--- a/fs/locks.c
+++ b/fs/locks.c
@@ -1654,8 +1654,7 @@ check_conflicting_open(const struct dentry *dentry, const long arg, int flags)
 	if (flags & FL_LAYOUT)
 		return 0;
 
-	if ((arg == F_RDLCK) &&
-	    (atomic_read(&d_real_inode(dentry)->i_writecount) > 0))
+	if ((arg == F_RDLCK) && (atomic_read(&inode->i_writecount) > 0))
 		return -EAGAIN;
 
 	if ((arg == F_WRLCK) && ((d_count(dentry) > 1) ||
diff --git a/fs/open.c b/fs/open.c
index 127b49819afb..0d63b57c7f89 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -68,7 +68,6 @@ int do_truncate(struct dentry *dentry, loff_t length, unsigned int time_attrs,
 long vfs_truncate(const struct path *path, loff_t length)
 {
 	struct inode *inode;
-	struct dentry *upperdentry;
 	long error;
 
 	inode = path->dentry->d_inode;
@@ -91,17 +90,7 @@ long vfs_truncate(const struct path *path, loff_t length)
 	if (IS_APPEND(inode))
 		goto mnt_drop_write_and_out;
 
-	/*
-	 * If this is an overlayfs then do as if opening the file so we get
-	 * write access on the upper inode, not on the overlay inode.  For
-	 * non-overlay filesystems d_real() is an identity function.
-	 */
-	upperdentry = d_real(path->dentry, NULL, O_WRONLY);
-	error = PTR_ERR(upperdentry);
-	if (IS_ERR(upperdentry))
-		goto mnt_drop_write_and_out;
-
-	error = get_write_access(upperdentry->d_inode);
+	error = get_write_access(inode);
 	if (error)
 		goto mnt_drop_write_and_out;
 
@@ -120,7 +109,7 @@ long vfs_truncate(const struct path *path, loff_t length)
 		error = do_truncate(path->dentry, length, 0, NULL);
 
 put_write_and_out:
-	put_write_access(upperdentry->d_inode);
+	put_write_access(inode);
 mnt_drop_write_and_out:
 	mnt_drop_write(path->mnt);
 out:
-- 
2.14.3
