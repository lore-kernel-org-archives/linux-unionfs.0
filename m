From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 1/2] vfs: add file_path() helper
Date: Fri, 19 Jun 2015 10:29:13 +0200
Message-ID: <20150619082913.GB24181@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wg0-f50.google.com ([74.125.82.50]:33655 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752983AbbFSI3K (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Fri, 19 Jun 2015 04:29:10 -0400
Received: by wgez8 with SMTP id z8so83446777wge.0
        for <linux-unionfs@vger.kernel.org>; Fri, 19 Jun 2015 01:29:08 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>

From: Miklos Szeredi <mszeredi@suse.cz>

Turn
	d_path(&file->f_path, ...);
into
	file_path(file, ...);

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 arch/arc/kernel/troubleshoot.c               |   10 +++-------
 arch/blackfin/kernel/trace.c                 |    2 +-
 arch/tile/kernel/stack.c                     |    2 +-
 arch/tile/mm/elf.c                           |    2 +-
 drivers/block/loop.c                         |    2 +-
 drivers/md/bitmap.c                          |    2 +-
 drivers/md/md.c                              |    2 +-
 drivers/usb/gadget/function/f_mass_storage.c |    2 +-
 drivers/usb/gadget/function/storage_common.c |    2 +-
 fs/binfmt_elf.c                              |    4 ++--
 fs/coredump.c                                |    2 +-
 fs/ext4/super.c                              |    2 +-
 fs/open.c                                    |    6 ++++++
 include/linux/fs.h                           |    2 ++
 kernel/events/core.c                         |    2 +-
 mm/memory.c                                  |    2 +-
 16 files changed, 25 insertions(+), 21 deletions(-)

--- a/arch/arc/kernel/troubleshoot.c
+++ b/arch/arc/kernel/troubleshoot.c
@@ -67,15 +67,12 @@ static void print_task_path_n_nm(struct
 	mmput(mm);
 
 	if (exe_file) {
-		path = exe_file->f_path;
-		path_get(&exe_file->f_path);
+		path_nm = file_path(exe_file, buf, 255);
 		fput(exe_file);
-		path_nm = d_path(&path, buf, 255);
-		path_put(&path);
 	}
 
 done:
-	pr_info("Path: %s\n", path_nm);
+	pr_info("Path: %s\n", !IS_ERR(path_nm) ? path_nm : "?");
 }
 
 static void show_faulting_vma(unsigned long address, char *buf)
@@ -99,8 +96,7 @@ static void show_faulting_vma(unsigned l
 	if (vma && (vma->vm_start <= address)) {
 		struct file *file = vma->vm_file;
 		if (file) {
-			struct path *path = &file->f_path;
-			nm = d_path(path, buf, PAGE_SIZE - 1);
+			nm = file_path(file, buf, PAGE_SIZE - 1);
 			inode = file_inode(vma->vm_file);
 			dev = inode->i_sb->s_dev;
 			ino = inode->i_ino;
--- a/arch/blackfin/kernel/trace.c
+++ b/arch/blackfin/kernel/trace.c
@@ -136,7 +136,7 @@ void decode_address(char *buf, unsigned
 				struct file *file = vma->vm_file;
 
 				if (file) {
-					char *d_name = d_path(&file->f_path, _tmpbuf,
+					char *d_name = file_path(file, _tmpbuf,
 						      sizeof(_tmpbuf));
 					if (!IS_ERR(d_name))
 						name = d_name;
--- a/arch/tile/kernel/stack.c
+++ b/arch/tile/kernel/stack.c
@@ -334,7 +334,7 @@ static void describe_addr(struct KBacktr
 	}
 
 	if (vma->vm_file) {
-		p = d_path(&vma->vm_file->f_path, buf, bufsize);
+		p = file_path(vma->vm_file, buf, bufsize);
 		if (IS_ERR(p))
 			p = "?";
 		name = kbasename(p);
--- a/arch/tile/mm/elf.c
+++ b/arch/tile/mm/elf.c
@@ -56,7 +56,7 @@ static int notify_exec(struct mm_struct
 	if (exe_file == NULL)
 		goto done_free;
 
-	path = d_path(&exe_file->f_path, buf, PAGE_SIZE);
+	path = file_path(exe_file, buf, PAGE_SIZE);
 	if (IS_ERR(path))
 		goto done_put;
 
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -839,7 +839,7 @@ static void bitmap_file_kick(struct bitm
 		if (bitmap->storage.file) {
 			path = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			if (path)
-				ptr = d_path(&bitmap->storage.file->f_path,
+				ptr = file_path(bitmap->storage.file,
 					     path, PAGE_SIZE);
 
 			printk(KERN_ALERT
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2501,6 +2501,8 @@ extern struct file * open_exec(const cha
 extern int is_subdir(struct dentry *, struct dentry *);
 extern int path_is_under(struct path *, struct path *);
 
+extern char *file_path(struct file *, char *, int);
+
 #include <linux/err.h>
 
 /* needed for stackable file system support */
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2936,7 +2936,7 @@ int fsg_common_create_lun(struct fsg_com
 	if (fsg_lun_is_open(lun)) {
 		p = "(error)";
 		if (pathbuf) {
-			p = d_path(&lun->filp->f_path, pathbuf, PATH_MAX);
+			p = file_path(lun->filp, pathbuf, PATH_MAX);
 			if (IS_ERR(p))
 				p = "(error)";
 		}
--- a/drivers/usb/gadget/function/storage_common.c
+++ b/drivers/usb/gadget/function/storage_common.c
@@ -341,7 +341,7 @@ ssize_t fsg_show_file(struct fsg_lun *cu
 
 	down_read(filesem);
 	if (fsg_lun_is_open(curlun)) {	/* Get the complete pathname */
-		p = d_path(&curlun->filp->f_path, buf, PAGE_SIZE - 1);
+		p = file_path(curlun->filp, buf, PAGE_SIZE - 1);
 		if (IS_ERR(p))
 			rc = PTR_ERR(p);
 		else {
--- a/fs/binfmt_elf.c
+++ b/fs/binfmt_elf.c
@@ -1530,7 +1530,7 @@ static int fill_files_note(struct memelf
 		file = vma->vm_file;
 		if (!file)
 			continue;
-		filename = d_path(&file->f_path, name_curpos, remaining);
+		filename = file_path(file, name_curpos, remaining);
 		if (IS_ERR(filename)) {
 			if (PTR_ERR(filename) == -ENAMETOOLONG) {
 				vfree(data);
@@ -1540,7 +1540,7 @@ static int fill_files_note(struct memelf
 			continue;
 		}
 
-		/* d_path() fills at the end, move name down */
+		/* file_path() fills at the end, move name down */
 		/* n = strlen(filename) + 1: */
 		n = (name_curpos + remaining) - filename;
 		remaining = filename - name_curpos;
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -138,7 +138,7 @@ static int cn_print_exe_file(struct core
 		goto put_exe_file;
 	}
 
-	path = d_path(&exe_file->f_path, pathbuf, PATH_MAX);
+	path = file_path(exe_file, pathbuf, PATH_MAX);
 	if (IS_ERR(path)) {
 		ret = PTR_ERR(path);
 		goto free_buf;
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -451,7 +451,7 @@ void __ext4_error_file(struct file *file
 	es = EXT4_SB(inode->i_sb)->s_es;
 	es->s_last_error_ino = cpu_to_le32(inode->i_ino);
 	if (ext4_error_ratelimit(inode->i_sb)) {
-		path = d_path(&(file->f_path), pathname, sizeof(pathname));
+		path = file_path(file, pathname, sizeof(pathname));
 		if (IS_ERR(path))
 			path = "(unknown)";
 		va_start(args, fmt);
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -5812,7 +5812,7 @@ static void perf_event_mmap_event(struct
 		 * need to add enough zero bytes after the string to handle
 		 * the 64bit alignment we do later.
 		 */
-		name = d_path(&file->f_path, buf, PATH_MAX - sizeof(u64));
+		name = file_path(file, buf, PATH_MAX - sizeof(u64));
 		if (IS_ERR(name)) {
 			name = "//toolong";
 			goto cpy_name;
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3724,7 +3724,7 @@ void print_vma_addr(char *prefix, unsign
 		if (buf) {
 			char *p;
 
-			p = d_path(&f->f_path, buf, PAGE_SIZE);
+			p = file_path(f, buf, PAGE_SIZE);
 			if (IS_ERR(p))
 				p = "?";
 			printk("%s%s[%lx+%lx]", prefix, kbasename(p),
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5744,7 +5744,7 @@ static int get_bitmap_file(struct mddev
 	/* bitmap disabled, zero the first byte and copy out */
 	if (!mddev->bitmap_info.file)
 		file->pathname[0] = '\0';
-	else if ((ptr = d_path(&mddev->bitmap_info.file->f_path,
+	else if ((ptr = file_path(mddev->bitmap_info.file,
 			       file->pathname, sizeof(file->pathname))),
 		 IS_ERR(ptr))
 		err = PTR_ERR(ptr);
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -568,7 +568,7 @@ static ssize_t loop_attr_backing_file_sh
 
 	spin_lock_irq(&lo->lo_lock);
 	if (lo->lo_backing_file)
-		p = d_path(&lo->lo_backing_file->f_path, buf, PAGE_SIZE - 1);
+		p = file_path(lo->lo_backing_file, buf, PAGE_SIZE - 1);
 	spin_unlock_irq(&lo->lo_lock);
 
 	if (IS_ERR_OR_NULL(p))
--- a/fs/open.c
+++ b/fs/open.c
@@ -853,6 +853,12 @@ struct file *dentry_open(const struct pa
 }
 EXPORT_SYMBOL(dentry_open);
 
+char *file_path(struct file *filp, char *buf, int buflen)
+{
+	return d_path(&filp->f_path, buf, buflen);
+}
+EXPORT_SYMBOL(file_path);
+
 /**
  * vfs_open - open the file at the given path
  * @path: path to open
