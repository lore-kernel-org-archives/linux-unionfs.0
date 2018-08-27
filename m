Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 3/6] Documentation/filesystems: update documentation of file_operations to kernel 4.18
Date: Mon, 27 Aug 2018 15:56:01 +0300
Message-Id: <1535374564-8257-4-git-send-email-amir73il@gmail.com>
In-Reply-To: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
References: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 Documentation/filesystems/vfs.txt | 22 ++++++++++++++++++----
 1 file changed, 18 insertions(+), 4 deletions(-)

diff --git a/Documentation/filesystems/vfs.txt b/Documentation/filesystems/vfs.txt
index 4b2084d0f1fb..e0ace944a0e1 100644
--- a/Documentation/filesystems/vfs.txt
+++ b/Documentation/filesystems/vfs.txt
@@ -848,7 +848,7 @@ struct file_operations
 ----------------------
 
 This describes how the VFS can manipulate an open file. As of kernel
-4.1, the following members are defined:
+4.18, the following members are defined:
 
 struct file_operations {
 	struct module *owner;
@@ -858,11 +858,11 @@ struct file_operations {
 	ssize_t (*read_iter) (struct kiocb *, struct iov_iter *);
 	ssize_t (*write_iter) (struct kiocb *, struct iov_iter *);
 	int (*iterate) (struct file *, struct dir_context *);
+	int (*iterate_shared) (struct file *, struct dir_context *);
 	__poll_t (*poll) (struct file *, struct poll_table_struct *);
 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
 	int (*mmap) (struct file *, struct vm_area_struct *);
-	int (*mremap)(struct file *, struct vm_area_struct *);
 	int (*open) (struct inode *, struct file *);
 	int (*flush) (struct file *, fl_owner_t id);
 	int (*release) (struct inode *, struct file *);
@@ -882,6 +882,9 @@ struct file_operations {
 #ifndef CONFIG_MMU
 	unsigned (*mmap_capabilities)(struct file *);
 #endif
+	ssize_t (*copy_file_range)(struct file *, loff_t, struct file *, loff_t, size_t, unsigned int);
+	int (*clone_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
+	int (*dedupe_file_range)(struct file *, loff_t, struct file *, loff_t, u64);
 };
 
 Again, all methods are called without any locks being held, unless
@@ -899,6 +902,9 @@ otherwise noted.
 
   iterate: called when the VFS needs to read the directory contents
 
+  iterate_shared: called when the VFS needs to read the directory contents
+	when filesystem supports concurrent dir iterators
+
   poll: called by the VFS when a process wants to check if there is
 	activity on this file and (optionally) go to sleep until there
 	is activity. Called by the select(2) and poll(2) system calls
@@ -906,7 +912,7 @@ otherwise noted.
   unlocked_ioctl: called by the ioctl(2) system call.
 
   compat_ioctl: called by the ioctl(2) system call when 32 bit system calls
- 	 are used on 64 bit kernels.
+	 are used on 64 bit kernels.
 
   mmap: called by the mmap(2) system call
 
@@ -931,7 +937,7 @@ otherwise noted.
 	(non-blocking) mode is enabled for a file
 
   lock: called by the fcntl(2) system call for F_GETLK, F_SETLK, and F_SETLKW
-  	commands
+	commands
 
   get_unmapped_area: called by the mmap(2) system call
 
@@ -951,6 +957,14 @@ otherwise noted.
 
   fallocate: called by the VFS to preallocate blocks or punch a hole.
 
+  copy_file_range: called by the copy_file_range(2) system call.
+
+  clone_file_range: called by the ioctl(2) system call for FICLONERANGE and
+	FICLONE commands.
+
+  dedupe_file_range: called by the ioctl(2) system call for FIDEDUPERANGE
+	command.
+
 Note that the file operations are implemented by the specific
 filesystem in which the inode resides. When opening a device node
 (character or block special) most filesystems will call special
-- 
2.7.4
