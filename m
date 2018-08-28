Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 5/6] vfs: implement readahead(2) using POSIX_FADV_WILLNEED
Date: Tue, 28 Aug 2018 11:00:33 +0300
Message-Id: <1535443233-31068-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

The implementation of readahead(2) syscall is identical to that of
fadvise64(POSIX_FADV_WILLNEED) with a few exceptions:
1. readahead(2) returns -EINVAL for !mapping->a_ops and fadvise64()
   ignores the request and returns 0.
2. fadvise64() checks for integer overflow corner case
3. fadvise64() calls the optional filesystem fadvice() file operation

Unite the two implementations by calling vfs_fadvice() from readahead(2)
syscall. Check the !mapping->a_ops in readahead(2) syscall to preserve
legacy behavior.

Suggested-by: Miklos Szeredi <mszeredi@redhat.com>
Fixes: d1d04ef8572b ("ovl: stack file ops")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

Following v4 addresses comment from dchinner.

Thanks,
Amir.

Changes from v3:
- fold do_readahead helper and reduce code nesting

 mm/readahead.c | 45 +++++++++++++++++----------------------------
 1 file changed, 17 insertions(+), 28 deletions(-)

diff --git a/mm/readahead.c b/mm/readahead.c
index a59ea70527b9..a9cda21aeb05 100644
--- a/mm/readahead.c
+++ b/mm/readahead.c
@@ -20,6 +20,7 @@
 #include <linux/file.h>
 #include <linux/mm_inline.h>
 #include <linux/blk-cgroup.h>
+#include <linux/fadvise.h>
 
 #include "internal.h"
 
@@ -575,24 +576,6 @@ page_cache_async_readahead(struct address_space *mapping,
 }
 EXPORT_SYMBOL_GPL(page_cache_async_readahead);
 
-static ssize_t
-do_readahead(struct address_space *mapping, struct file *filp,
-	     pgoff_t index, unsigned long nr)
-{
-	if (!mapping || !mapping->a_ops)
-		return -EINVAL;
-
-	/*
-	 * Readahead doesn't make sense for DAX inodes, but we don't want it
-	 * to report a failure either.  Instead, we just return success and
-	 * don't do any work.
-	 */
-	if (dax_mapping(mapping))
-		return 0;
-
-	return force_page_cache_readahead(mapping, filp, index, nr);
-}
-
 ssize_t ksys_readahead(int fd, loff_t offset, size_t count)
 {
 	ssize_t ret;
@@ -600,16 +583,22 @@ ssize_t ksys_readahead(int fd, loff_t offset, size_t count)
 
 	ret = -EBADF;
 	f = fdget(fd);
-	if (f.file) {
-		if (f.file->f_mode & FMODE_READ) {
-			struct address_space *mapping = f.file->f_mapping;
-			pgoff_t start = offset >> PAGE_SHIFT;
-			pgoff_t end = (offset + count - 1) >> PAGE_SHIFT;
-			unsigned long len = end - start + 1;
-			ret = do_readahead(mapping, f.file, start, len);
-		}
-		fdput(f);
-	}
+	if (!f.file || !(f.file->f_mode & FMODE_READ))
+		goto out;
+
+	/*
+	 * fadvise() silently ignores an advice for a file with !a_ops and
+	 * returns -EPIPE for a pipe. Keep this check here to comply with legacy
+	 * -EINVAL behavior of readahead(2).
+	 */
+	ret = -EINVAL;
+	if (!f.file->f_mapping || !f.file->f_mapping->a_ops ||
+	    !S_ISREG(file_inode(f.file)->i_mode))
+		goto out;
+
+	ret = vfs_fadvise(f.file, offset, count, POSIX_FADV_WILLNEED);
+out:
+	fdput(f);
 	return ret;
 }
 
-- 
2.7.4
