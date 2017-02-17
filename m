From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 8/9] vfs: use helper for calling f_op->fsync()
Date: Fri, 17 Feb 2017 17:09:37 +0100
Message-ID: <1487347778-18596-9-git-send-email-mszeredi@redhat.com>
References: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/sync.c          | 2 +-
 include/linux/fs.h | 6 ++++++
 ipc/shm.c          | 2 +-
 3 files changed, 8 insertions(+), 2 deletions(-)

diff --git a/fs/sync.c b/fs/sync.c
index 2a54c1f22035..11ba023434b1 100644
--- a/fs/sync.c
+++ b/fs/sync.c
@@ -192,7 +192,7 @@ int vfs_fsync_range(struct file *file, loff_t start, loff_t end, int datasync)
 		spin_unlock(&inode->i_lock);
 		mark_inode_dirty_sync(inode);
 	}
-	return file->f_op->fsync(file, start, end, datasync);
+	return call_fsync(file, start, end, datasync);
 }
 EXPORT_SYMBOL(vfs_fsync_range);
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6e74b726c3ca..1293005de2e3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1745,6 +1745,12 @@ static inline int call_mmap(struct file *file, struct vm_area_struct *vma)
 	return file->f_op->mmap(file, vma);
 }
 
+static inline int call_fsync(struct file *file, loff_t start, loff_t end,
+			     int datasync)
+{
+	return file->f_op->fsync(file, start, end, datasync);
+}
+
 ssize_t rw_copy_check_uvector(int type, const struct iovec __user * uvector,
 			      unsigned long nr_segs, unsigned long fast_segs,
 			      struct iovec *fast_pointer,
diff --git a/ipc/shm.c b/ipc/shm.c
index 4329fe3ef594..258aff2e03bb 100644
--- a/ipc/shm.c
+++ b/ipc/shm.c
@@ -452,7 +452,7 @@ static int shm_fsync(struct file *file, loff_t start, loff_t end, int datasync)
 
 	if (!sfd->file->f_op->fsync)
 		return -EINVAL;
-	return sfd->file->f_op->fsync(sfd->file, start, end, datasync);
+	return call_fsync(sfd->file, start, end, datasync);
 }
 
 static long shm_fallocate(struct file *file, int mode, loff_t offset,
-- 
2.5.5
