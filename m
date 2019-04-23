Return-Path: <xzhou@redhat.com>
From: Murphy Zhou <jencce.kernel@gmail.com>
Subject: [PATCH] ovl: add RWF_NONITIFY flag to skip wrong duplicate fanotify event
Date: Tue, 23 Apr 2019 14:50:24 +0800
Message-Id: <20190423065024.12695-1-jencce.kernel@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: miklos@szeredi.hu, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
Cc: amir73il@gmail.com, Murphy Zhou <jencce.kernel@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

Overlays ovl_iter_write calls vfs_iter_write to write on real file,
in which calls fsnotify_modify on this change, however vfs_write also
calls fsnotify_modify after ovl_iter_write. The first notification
sent by vfs_iter_write grabs marks from upper inode and overlay mnt,
because of its fake path. The second one sent by vfs_write grabs marks
from ovl inode and ovl mnt.

LTP fanotify06 add modify mark for mnt point, then add ignore modify
mask on testfile, then truncate and write the file. Because the ignore
mask is marked on ovl inode, not the upper inode, the first event is not
masked like the second one. So we get a modification event even with a
mask on the file.

Proposing fixing this by add a new RWF flag to skip fsnotify on this IO.
vfs_iter_write used by ovl can use this flag to skip one duplicate event.

Signed-off-by: Murphy Zhou <jencce.kernel@gmail.com>
---
 fs/overlayfs/file.c     | 2 +-
 fs/read_write.c         | 2 +-
 include/uapi/linux/fs.h | 5 ++++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index 84dd957efa24..0827199a5311 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -242,7 +242,7 @@ static ssize_t ovl_write_iter(struct kiocb *iocb, struct iov_iter *iter)
 	old_cred = ovl_override_creds(file_inode(file)->i_sb);
 	file_start_write(real.file);
 	ret = vfs_iter_write(real.file, iter, &iocb->ki_pos,
-			     ovl_iocb_to_rwf(iocb));
+			     ovl_iocb_to_rwf(iocb)|RWF_NONOTIFY);
 	file_end_write(real.file);
 	revert_creds(old_cred);
 
diff --git a/fs/read_write.c b/fs/read_write.c
index 61b43ad7608e..aec751cacedf 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -957,7 +957,7 @@ static ssize_t do_iter_write(struct file *file, struct iov_iter *iter,
 		ret = do_iter_readv_writev(file, iter, pos, WRITE, flags);
 	else
 		ret = do_loop_readv_writev(file, iter, pos, WRITE, flags);
-	if (ret > 0)
+	if (ret > 0 && !(flags & RWF_NONOTIFY))
 		fsnotify_modify(file);
 	return ret;
 }
diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
index 121e82ce296b..103f1a9375f2 100644
--- a/include/uapi/linux/fs.h
+++ b/include/uapi/linux/fs.h
@@ -342,8 +342,11 @@ typedef int __bitwise __kernel_rwf_t;
 /* per-IO O_APPEND */
 #define RWF_APPEND	((__force __kernel_rwf_t)0x00000010)
 
+/* do not notify this IO */
+#define RWF_NONOTIFY	((__force __kernel_rwf_t)0x00000020)
+
 /* mask of flags supported by the kernel */
 #define RWF_SUPPORTED	(RWF_HIPRI | RWF_DSYNC | RWF_SYNC | RWF_NOWAIT |\
-			 RWF_APPEND)
+			 RWF_APPEND | RWF_NONOTIFY)
 
 #endif /* _UAPI_LINUX_FS_H */
-- 
2.21.0
