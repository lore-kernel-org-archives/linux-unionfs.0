From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 3/5] vfs: wrap write f_ops with file_{start,end}_write()
Date: Tue, 31 Jan 2017 10:34:57 +0200
Message-ID: <1485851699-25313-4-git-send-email-amir73il@gmail.com>
References: <1485851699-25313-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:33407 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750890AbdAaIf2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jan 2017 03:35:28 -0500
In-Reply-To: <1485851699-25313-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Jan Kara <jack@suse.com>, Christoph Hellwig <hch@lst.de>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Before calling write f_ops, call file_start_write() instead
of sb_start_write().

Replace {sb,file}_start_write() for {copy,clone}_file_range() and
for fallocate().

Beyond correct semantics, this avoids freeze protection to sb when
operating on special inodes, such as fallocate() on a blockdev.

Reviewed-by: Jan Kara <jack@suse.cz>
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/open.c          |  4 ++--
 fs/read_write.c    |  4 ++--
 include/linux/fs.h | 26 +++++++++++++-------------
 3 files changed, 17 insertions(+), 17 deletions(-)

diff --git a/fs/open.c b/fs/open.c
index f9118f4..949cef2 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -314,7 +314,7 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (!file->f_op->fallocate)
 		return -EOPNOTSUPP;
 
-	sb_start_write(inode->i_sb);
+	file_start_write(file);
 	ret = file->f_op->fallocate(file, mode, offset, len);
 
 	/*
@@ -327,7 +327,7 @@ int vfs_fallocate(struct file *file, int mode, loff_t offset, loff_t len)
 	if (ret == 0)
 		fsnotify_modify(file);
 
-	sb_end_write(inode->i_sb);
+	file_end_write(file);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(vfs_fallocate);
diff --git a/fs/read_write.c b/fs/read_write.c
index 511178d..820a3f0 100644
--- a/fs/read_write.c
+++ b/fs/read_write.c
@@ -1543,7 +1543,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	if (len == 0)
 		return 0;
 
-	sb_start_write(inode_out->i_sb);
+	file_start_write(file_out);
 
 	/*
 	 * Try cloning first, this is supported by more file systems, and
@@ -1579,7 +1579,7 @@ ssize_t vfs_copy_file_range(struct file *file_in, loff_t pos_in,
 	inc_syscr(current);
 	inc_syscw(current);
 
-	sb_end_write(inode_out->i_sb);
+	file_end_write(file_out);
 
 	return ret;
 }
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4a7f3cc..78c81e6 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1741,19 +1741,6 @@ extern int vfs_dedupe_file_range_compare(struct inode *src, loff_t srcoff,
 extern int vfs_dedupe_file_range(struct file *file,
 				 struct file_dedupe_range *same);
 
-static inline int do_clone_file_range(struct file *file_in, loff_t pos_in,
-				      struct file *file_out, loff_t pos_out,
-				      u64 len)
-{
-	int ret;
-
-	sb_start_write(file_inode(file_out)->i_sb);
-	ret = vfs_clone_file_range(file_in, pos_in, file_out, pos_out, len);
-	sb_end_write(file_inode(file_out)->i_sb);
-
-	return ret;
-}
-
 struct super_operations {
    	struct inode *(*alloc_inode)(struct super_block *sb);
 	void (*destroy_inode)(struct inode *);
@@ -2564,6 +2551,19 @@ static inline void file_end_write(struct file *file)
 	__sb_end_write(file_inode(file)->i_sb, SB_FREEZE_WRITE);
 }
 
+static inline int do_clone_file_range(struct file *file_in, loff_t pos_in,
+				      struct file *file_out, loff_t pos_out,
+				      u64 len)
+{
+	int ret;
+
+	file_start_write(file_out);
+	ret = vfs_clone_file_range(file_in, pos_in, file_out, pos_out, len);
+	file_end_write(file_out);
+
+	return ret;
+}
+
 /*
  * get_write_access() gets write permission for a file.
  * put_write_access() releases this write permission.
-- 
2.7.4
