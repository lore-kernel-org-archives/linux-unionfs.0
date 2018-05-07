From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH v2 09/35] ovl: copy up file size as well
Date: Mon,  7 May 2018 10:37:41 +0200
Message-ID: <20180507083807.28792-10-mszeredi@redhat.com>
References: <20180507083807.28792-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180507083807.28792-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Copy i_size of the underlying inode to the overlay inode in ovl_copyattr().

This is in preparation for stacking I/O operations on overlay files.

This patch shouldn't have any observable effect.

Remove stale comment from ovl_setattr() [spotted by Vivek Goyal].

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c     | 9 ---------
 fs/overlayfs/overlayfs.h | 2 ++
 2 files changed, 2 insertions(+), 9 deletions(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index f7b1910bb9d4..ba3f832cc39a 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -22,15 +22,6 @@ int ovl_setattr(struct dentry *dentry, struct iattr *attr)
 	struct dentry *upperdentry;
 	const struct cred *old_cred;
 
-	/*
-	 * Check for permissions before trying to copy-up.  This is redundant
-	 * since it will be rechecked later by ->setattr() on upper dentry.  But
-	 * without this, copy-up can be triggered by just about anybody.
-	 *
-	 * We don't initialize inode->size, which just means that
-	 * inode_newsize_ok() will always check against MAX_LFS_FILESIZE and not
-	 * check for a swapfile (which this won't be anyway).
-	 */
 	err = setattr_prepare(dentry, attr);
 	if (err)
 		return err;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 4e26778774c3..b9f7c632ab9c 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -9,6 +9,7 @@
 
 #include <linux/kernel.h>
 #include <linux/uuid.h>
+#include <linux/fs.h>
 #include "ovl_entry.h"
 
 enum ovl_path_type {
@@ -348,6 +349,7 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 	to->i_atime = from->i_atime;
 	to->i_mtime = from->i_mtime;
 	to->i_ctime = from->i_ctime;
+	i_size_write(to, i_size_read(from));
 }
 
 static inline void ovl_copyflags(struct inode *from, struct inode *to)
-- 
2.14.3
