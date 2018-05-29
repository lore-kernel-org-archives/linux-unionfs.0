From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 06/39] vfs: add f_op->pre_mmap()
Date: Tue, 29 May 2018 16:43:06 +0200
Message-ID: <20180529144339.16538-7-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This is needed by overlayfs to be able to copy up a file from a read-only
lower layer to a writable layer when being mapped shared.  When copying up,
overlayfs takes VFS locks that would violate locking order when nested
inside mmap_sem.

Add a new f_op->pre_mmap method, which is called before taking mmap_sem.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 Documentation/filesystems/Locking | 1 +
 Documentation/filesystems/vfs.txt | 3 +++
 include/linux/fs.h                | 1 +
 mm/util.c                         | 5 +++++
 4 files changed, 10 insertions(+)

diff --git a/Documentation/filesystems/Locking b/Documentation/filesystems/Locking
index 75d2d57e2c44..60e76060baff 100644
--- a/Documentation/filesystems/Locking
+++ b/Documentation/filesystems/Locking
@@ -442,6 +442,7 @@ prototypes:
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
+	int (*pre_mmap) (struct file *, unsigned long, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *);
diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 5fd325df59e2..2bc77ea8aef4 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -859,6 +859,7 @@ struct file_operations {
 	unsigned int (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
+	int (*pre_mmap) (struct file *, unsigned long, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	int (*mremap)(struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
@@ -906,6 +907,8 @@ otherwise noted.
   compat_ioctl: called by the ioctl(2) system call when 32 bit system calls
  	 are used on 64 bit kernels.
 
+  pre_mmap: called before mmap, without mmap_sem being held yet.
+
   mmap: called by the mmap(2) system call
 
   open: called by the VFS when an inode should be opened. When the VFS
diff --git a/include/linux/fs.h b/include/linux/fs.h
index ecc854c75611..1ea3f153b7f8 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1716,6 +1716,7 @@ struct file_operations {
 	__poll_t (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
+	int (*pre_mmap) (struct file *, unsigned long, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
 	unsigned long mmap_supported_flags;
 	int (*open) (struct inode *, struct file *);
diff --git a/mm/util.c b/mm/util.c
index 45fc3169e7b0..11cd375e1a19 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -352,6 +352,11 @@ unsigned long vm_mmap_pgoff(struct file *file, unsigned long addr,
 
 	ret = security_mmap_file(file, prot, flag);
 	if (!ret) {
+		if (file && file->f_op->pre_mmap) {
+			ret = file->f_op->pre_mmap(file, prot, flag);
+			if (ret)
+				return ret;
+		}
 		if (down_write_killable(&mm->mmap_sem))
 			return -EINTR;
 		ret = do_mmap_pgoff(file, addr, len, prot, flag, pgoff,
-- 
2.14.3
