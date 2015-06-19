From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PATCH 2/2] vfs: add seq_file_path() helper
Date: Fri, 19 Jun 2015 10:30:28 +0200
Message-ID: <20150619083028.GC24181@tucsk>
References: <20150619082913.GB24181@tucsk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20150619082913.GB24181@tucsk>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: David Howells <dhowells@redhat.com>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

From: Miklos Szeredi <mszeredi@suse.cz>

Turn
	seq_path(..., &file->f_path, ...);
into
	seq_file_path(..., file, ...);

Signed-off-by: Miklos Szeredi <mszeredi@suse.cz>
---
 drivers/md/bitmap.c      |    2 +-
 fs/proc/nommu.c          |    2 +-
 fs/proc/task_mmu.c       |    4 ++--
 fs/proc/task_nommu.c     |    2 +-
 fs/seq_file.c            |   14 ++++++++++++++
 include/linux/seq_file.h |    1 +
 mm/swapfile.c            |    2 +-
 7 files changed, 21 insertions(+), 6 deletions(-)

--- a/drivers/md/bitmap.c
+++ b/drivers/md/bitmap.c
@@ -1927,7 +1927,7 @@ void bitmap_status(struct seq_file *seq,
 		   chunk_kb ? "KB" : "B");
 	if (bitmap->storage.file) {
 		seq_printf(seq, ", file: ");
-		seq_path(seq, &bitmap->storage.file->f_path, " \t\n");
+		seq_file_path(seq, bitmap->storage.file, " \t\n");
 	}
 
 	seq_printf(seq, "\n");
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
 
--- a/fs/seq_file.c
+++ b/fs/seq_file.c
@@ -487,6 +487,20 @@ int seq_path(struct seq_file *m, const s
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
+	return seq_path(m, &file->f_path, esc);
+}
+EXPORT_SYMBOL(seq_file_path);
+
 /*
  * Same as seq_path, but relative to supplied root.
  */
--- a/include/linux/seq_file.h
+++ b/include/linux/seq_file.h
@@ -123,6 +123,7 @@ __printf(2, 3) int seq_printf(struct seq
 __printf(2, 0) int seq_vprintf(struct seq_file *, const char *, va_list args);
 
 int seq_path(struct seq_file *, const struct path *, const char *);
+int seq_file_path(struct seq_file *, struct file *, const char *);
 int seq_dentry(struct seq_file *, struct dentry *, const char *);
 int seq_path_root(struct seq_file *m, const struct path *path,
 		  const struct path *root, const char *esc);
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
