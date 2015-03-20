From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: d_path() and overlay fs
Date: Fri, 20 Mar 2015 17:01:23 +0100
Message-ID: <20150320160123.GE20913@tucsk>
References: <20150320132914.GA1749@ws.net.home>
 <CA+5PVA6P3cEy9L+PngXdkVki=x32jZmtPJ2b5oT6SLL=U1NAnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+5PVA6P3cEy9L+PngXdkVki=x32jZmtPJ2b5oT6SLL=U1NAnw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Karel Zak <kzak@redhat.com>, Alexander Viro <viro@zeniv.linux.org.uk>, dhowells@redhat.com, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Fri, Mar 20, 2015 at 09:41:25AM -0400, Josh Boyer wrote:
> On Fri, Mar 20, 2015 at 9:29 AM, Karel Zak <kzak@redhat.com> wrote:
> >
> >  Hi,
> >
> >  kernel-4.0.0-0.rc4.git1.3.fc23 (I have nothing more recent right now,
> >  sorry it the problem is already fixed).
> 
> That equates to Linux v4.0-rc4-88-g7b09ac704bac upstream.
> 
> Fedora has Linux v4.0-rc4-199-gb314acaccd7e queued to build today,
> which does include an overlayfs fix pull but I have no idea if it
> solves the issue.

It does not.

However the following patch should.  It's not much tested and I understand that
it doesn't solve the whole problem that dhowells is working on (selinux in
particular)

But it does take care of the majority of f_path users that actually want the
covering path.

Comments, testing welcome.

Thanks,
Miklos

---
 arch/arc/kernel/troubleshoot.c               |   10 ++------
 arch/blackfin/kernel/trace.c                 |    2 -
 arch/tile/kernel/stack.c                     |    2 -
 arch/tile/mm/elf.c                           |    2 -
 drivers/block/loop.c                         |    2 -
 drivers/md/bitmap.c                          |    4 +--
 drivers/md/md.c                              |    2 -
 drivers/usb/gadget/function/f_mass_storage.c |    2 -
 drivers/usb/gadget/function/storage_common.c |    2 -
 fs/binfmt_elf.c                              |    4 +--
 fs/coredump.c                                |    2 -
 fs/ext4/super.c                              |    2 -
 fs/file_table.c                              |    1 
 fs/open.c                                    |   32 +++++++++++++++++++++++----
 fs/proc/base.c                               |    6 ++---
 fs/proc/fd.c                                 |    9 +++++--
 fs/proc/nommu.c                              |    2 -
 fs/proc/task_mmu.c                           |    4 +--
 fs/proc/task_nommu.c                         |    2 -
 fs/seq_file.c                                |   17 ++++++++++++++
 include/linux/fs.h                           |    4 +++
 include/linux/seq_file.h                     |    1 
 kernel/events/core.c                         |    2 -
 mm/memory.c                                  |    2 -
 mm/swapfile.c                                |    2 -
 25 files changed, 83 insertions(+), 37 deletions(-)

--- a/fs/file_table.c
+++ b/fs/file_table.c
@@ -219,6 +219,7 @@ static void __fput(struct file *file)
 		put_write_access(inode);
 		__mnt_drop_write(mnt);
 	}
+	path_put(&file->f_covering_path);
 	file->f_path.dentry = NULL;
 	file->f_path.mnt = NULL;
 	file->f_inode = NULL;
--- a/fs/open.c
+++ b/fs/open.c
@@ -849,6 +849,24 @@ struct file *dentry_open(const struct pa
 }
 EXPORT_SYMBOL(dentry_open);
 
+void f_covering_path(struct file *filp, struct path *path)
+{
+	if (filp->f_covering_path.dentry)
+		*path = filp->f_covering_path;
+	else
+		*path = filp->f_path;
+}
+EXPORT_SYMBOL(f_covering_path);
+
+char *file_path(struct file *filp, char *buf, int buflen)
+{
+	struct path path;
+
+	f_covering_path(filp, &path);
+	return d_path(&path, buf, buflen);
+}
+EXPORT_SYMBOL(file_path);
+
 /**
  * vfs_open - open the file at the given path
  * @path: path to open
@@ -859,13 +877,19 @@ int vfs_open(const struct path *path, st
 	     const struct cred *cred)
 {
 	struct inode *inode = path->dentry->d_inode;
+	int err;
 
-	if (inode->i_op->dentry_open)
-		return inode->i_op->dentry_open(path->dentry, filp, cred);
-	else {
+	if (inode->i_op->dentry_open) {
+		err = inode->i_op->dentry_open(path->dentry, filp, cred);
+		if (!err && filp->f_path.dentry != path->dentry) {
+			filp->f_covering_path = *path;
+			path_get(&filp->f_covering_path);
+		}
+	} else {
 		filp->f_path = *path;
-		return do_dentry_open(filp, NULL, cred);
+		err = do_dentry_open(filp, NULL, cred);
 	}
+	return err;
 }
 EXPORT_SYMBOL(vfs_open);
 
--- a/fs/proc/base.c
+++ b/fs/proc/base.c
@@ -1363,8 +1363,8 @@ static int proc_exe_link(struct dentry *
 	exe_file = get_mm_exe_file(mm);
 	mmput(mm);
 	if (exe_file) {
-		*exe_path = exe_file->f_path;
-		path_get(&exe_file->f_path);
+		f_covering_path(exe_file, exe_path);
+		path_get(exe_path);
 		fput(exe_file);
 		return 0;
 	} else
@@ -1735,7 +1735,7 @@ static int proc_map_files_get_link(struc
 	down_read(&mm->mmap_sem);
 	vma = find_exact_vma(mm, vm_start, vm_end);
 	if (vma && vma->vm_file) {
-		*path = vma->vm_file->f_path;
+		f_covering_path(vma->vm_file, path);
 		path_get(path);
 		rc = 0;
 	}
--- a/fs/proc/fd.c
+++ b/fs/proc/fd.c
@@ -49,9 +49,12 @@ static int seq_show(struct seq_file *m,
 	}
 
 	if (!ret) {
+		struct path path;
+
+		f_covering_path(file, &path);
 		seq_printf(m, "pos:\t%lli\nflags:\t0%o\nmnt_id:\t%i\n",
 			   (long long)file->f_pos, f_flags,
-			   real_mount(file->f_path.mnt)->mnt_id);
+			   real_mount(path.mnt)->mnt_id);
 		if (file->f_op->show_fdinfo)
 			file->f_op->show_fdinfo(m, file);
 		ret = seq_has_overflowed(m);
@@ -157,8 +160,8 @@ static int proc_fd_link(struct dentry *d
 		spin_lock(&files->file_lock);
 		fd_file = fcheck_files(files, fd);
 		if (fd_file) {
-			*path = fd_file->f_path;
-			path_get(&fd_file->f_path);
+			f_covering_path(fd_file, path);
+			path_get(path);
 			ret = 0;
 		}
 		spin_unlock(&files->file_lock);
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -833,6 +833,7 @@ struct file {
 	struct list_head	f_tfile_llink;
 #endif /* #ifdef CONFIG_EPOLL */
 	struct address_space	*f_mapping;
+	struct path             f_covering_path;
 } __attribute__((aligned(4)));	/* lest something weird decides that 2 is OK */
 
 struct file_handle {
@@ -2466,6 +2467,9 @@ extern struct file * open_exec(const cha
 extern int is_subdir(struct dentry *, struct dentry *);
 extern int path_is_under(struct path *, struct path *);
 
+extern char *file_path(struct file *, char *, int);
+extern void f_covering_path(struct file *, struct path *);
+
 #include <linux/err.h>
 
 /* needed for stackable file system support */
--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -620,7 +620,7 @@ static ssize_t loop_attr_backing_file_sh
 
 	spin_lock_irq(&lo->lo_lock);
 	if (lo->lo_backing_file)
-		p = d_path(&lo->lo_backing_file->f_path, buf, PAGE_SIZE - 1);
+		p = file_path(lo->lo_backing_file, buf, PAGE_SIZE - 1);
 	spin_unlock_irq(&lo->lo_lock);
 
 	if (IS_ERR_OR_NULL(p))
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -123,6 +123,7 @@ __printf(2, 3) int seq_printf(struct seq
 __printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
 
 int seq_path(struct seq_file *, const struct path *, const char *);
+int seq_file_path(struct seq_file *, struct file *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
 int seq_path_root(struct seq_file *m, const struct path *path,
 		  const struct path *root, const char *esc);
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -487,6 +487,23 @@ int seq_path(struct seq_file *m, const s
 }
 EXPORT_SYMBOL(seq_path);
 
+/**
+ * seq_file_path - seq_file interface to print a pathname of a file
+ * @m: the seq_file handle
+ * @file: the struct file to print
+ * @esc: set of characters to escape in the output
+ *
+ * return the absolute path to the file.
+ */
+int seq_file_path(struct seq_file *m, struct file *file, const char *esc)
+{
+	struct path path;
+
+	f_covering_path(file, &path);
+	return seq_path(m, &path, esc);
+}
+EXPORT_SYMBOL(seq_file_path);
+
 /*
  * Same as seq_path, but relative to supplied root.
  */
--- a/fs/proc/nommu.c
+++ b/fs/proc/nommu.c
@@ -64,7 +64,7 @@ static int nommu_region_show(struct seq_
 
 	if (file) {
 		seq_pad(m, ' ');
-		seq_path(m, &file->f_path, "");
+		seq_file_path(m, file, "");
 	}
 
 	seq_putc(m, '\n');
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -310,7 +310,7 @@ show_map_vma(struct seq_file *m, struct
 	 */
 	if (file) {
 		seq_pad(m, ' ');
-		seq_path(m, &file->f_path, "\n");
+		seq_file_path(m, file, "\n");
 		goto done;
 	}
 
@@ -1509,7 +1509,7 @@ static int show_numa_map(struct seq_file
 
 	if (file) {
 		seq_puts(m, " file=");
-		seq_path(m, &file->f_path, "\n\t= ");
+		seq_file_path(m, file, "\n\t= ");
 	} else if (vma->vm_start <= mm->brk && vma->vm_end >= mm->start_brk) {
 		seq_puts(m, " heap");
 	} else {
--- a/fs/proc/task_nommu.c
+++ b/fs/proc/task_nommu.c
@@ -180,7 +180,7 @@ static int nommu_vma_show(struct seq_fil
 
 	if (file) {
 		seq_pad(m, ' ');
-		seq_path(m, &file->f_path, "");
+		seq_file_path(m, file, "");
 	} else if (mm) {
 		pid_t tid = pid_of_stack(priv, vma, is_pid);
 
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2032,7 +2032,7 @@ static int swap_show(struct seq_file *sw
 	}
 
 	file = si->swap_file;
-	len = seq_path(swap, &file->f_path, " \t\n\\");
+	len = seq_file_path(swap, file, " \t\n\\");
 	seq_printf(swap, "%*s%s\t%u\t%u\t%d\n",
 			len < 40 ? 40 - len : 1, " ",
 			S_ISBLK(file_inode(file)->i_mode) ?
--- a/arch/arc/kernel/troubleshoot.c
+++ b/arch/arc/kernel/troubleshoot.c
@@ -67,15 +67,12 @@ void print_task_path_n_nm(struct task_st
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
 EXPORT_SYMBOL(print_task_path_n_nm);
 
@@ -100,8 +97,7 @@ static void show_faulting_vma(unsigned l
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
@@ -333,7 +333,7 @@ static void describe_addr(struct KBacktr
 	}
 
 	if (vma->vm_file) {
-		p = d_path(&vma->vm_file->f_path, buf, bufsize);
+		p = file_path(vma->vm_file, buf, bufsize);
 		if (IS_ERR(p))
 			p = "?";
 		name = kbasename(p);
--- a/arch/tile/mm/elf.c
+++ b/arch/tile/mm/elf.c
@@ -59,7 +59,7 @@ static int notify_exec(struct mm_struct
 	if (buf == NULL)
 		return 0;
 
-	path = d_path(&mm->exe_file->f_path, buf, PAGE_SIZE);
+	path = file_path(mm->exe_file, buf, PAGE_SIZE);
 	if (IS_ERR(path)) {
 		free_page((unsigned long)buf);
 		return 0;
--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -785,7 +785,7 @@ static void bitmap_file_kick(struct bitm
 		if (bitmap->storage.file) {
 			path = kmalloc(PAGE_SIZE, GFP_KERNEL);
 			if (path)
-				ptr = d_path(&bitmap->storage.file->f_path,
+				ptr = file_path(bitmap->storage.file,
 					     path, PAGE_SIZE);
 
 			printk(KERN_ALERT
@@ -1786,7 +1786,7 @@ void bitmap_status(struct seq_file *seq,
 		   chunk_kb ? "KB" : "B");
 	if (bitmap->storage.file) {
 		seq_printf(seq, ", file: ");
-		seq_path(seq, &bitmap->storage.file->f_path, " \t\n");
+		seq_file_path(seq, bitmap->storage.file, " \t\n");
 	}
 
 	seq_printf(seq, "\n");
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5660,7 +5660,7 @@ static int get_bitmap_file(struct mddev
 	/* bitmap disabled, zero the first byte and copy out */
 	if (!mddev->bitmap_info.file)
 		file->pathname[0] = '\0';
-	else if ((ptr = d_path(&mddev->bitmap_info.file->f_path,
+	else if ((ptr = file_path(mddev->bitmap_info.file,
 			       file->pathname, sizeof(file->pathname))),
 		 IS_ERR(ptr))
 		err = PTR_ERR(ptr);
--- a/drivers/usb/gadget/function/f_mass_storage.c
+++ b/drivers/usb/gadget/function/f_mass_storage.c
@@ -2973,7 +2973,7 @@ int fsg_common_create_lun(struct fsg_com
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
@@ -1535,7 +1535,7 @@ static int fill_files_note(struct memelf
 		file = vma->vm_file;
 		if (!file)
 			continue;
-		filename = d_path(&file->f_path, name_curpos, remaining);
+		filename = file_path(file, name_curpos, remaining);
 		if (IS_ERR(filename)) {
 			if (PTR_ERR(filename) == -ENAMETOOLONG) {
 				vfree(data);
@@ -1545,7 +1545,7 @@ static int fill_files_note(struct memelf
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
@@ -466,7 +466,7 @@ void __ext4_error_file(struct file *file
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
@@ -5594,7 +5594,7 @@ static void perf_event_mmap_event(struct
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
@@ -3627,7 +3627,7 @@ void print_vma_addr(char *prefix, unsign
 		if (buf) {
 			char *p;
 
-			p = d_path(&f->f_path, buf, PAGE_SIZE);
+			p = file_path(f, buf, PAGE_SIZE);
 			if (IS_ERR(p))
 				p = "?";
 			printk("%s%s[%lx+%lx]", prefix, kbasename(p),
