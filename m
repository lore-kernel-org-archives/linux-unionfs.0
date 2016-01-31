From: Konstantin Khlebnikov <koct9i@gmail.com>
Subject: [PATCH] vfs: update atime using file->f_inode
Date: Sun, 31 Jan 2016 16:19:46 +0300
Message-ID: <145424638614.10446.16013603987277558993.stgit@zurg>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
List-Id: linux-unionfs@vger.kernel.org

This fixes some cases of missing atime update for overlayfs.

Signed-off-by: Konstantin Khlebnikov <koct9i@gmail.com>
---
 fs/inode.c         |   15 +++++++++++++--
 include/linux/fs.h |    6 +-----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 9f62db3bcc3e..6a4dd94c0ea3 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1631,10 +1631,9 @@ bool atime_needs_update(const struct path *path, struct inode *inode)
 	return true;
 }
 
-void touch_atime(const struct path *path)
+static void touch_inode_atime(const struct path *path, struct inode *inode)
 {
 	struct vfsmount *mnt = path->mnt;
-	struct inode *inode = d_inode(path->dentry);
 	struct timespec now;
 
 	if (!atime_needs_update(path, inode))
@@ -1660,8 +1659,20 @@ void touch_atime(const struct path *path)
 skip_update:
 	sb_end_write(inode->i_sb);
 }
+
+void touch_atime(const struct path *path)
+{
+	touch_inode_atime(path, d_inode(path->dentry));
+}
 EXPORT_SYMBOL(touch_atime);
 
+void file_accessed(const struct file *file)
+{
+	if (!(file->f_flags & O_NOATIME))
+		touch_inode_atime(&file->f_path, file_inode(file));
+}
+EXPORT_SYMBOL(file_accessed);
+
 /*
  * The logic we want is
  *
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 1a2046275cdf..22c89094a7e3 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1951,11 +1951,7 @@ enum file_time_flags {
 
 extern bool atime_needs_update(const struct path *, struct inode *);
 extern void touch_atime(const struct path *);
-static inline void file_accessed(struct file *file)
-{
-	if (!(file->f_flags & O_NOATIME))
-		touch_atime(&file->f_path);
-}
+extern void file_accessed(const struct file *file);
 
 int sync_inode(struct inode *inode, struct writeback_control *wbc);
 int sync_inode_metadata(struct inode *inode, int wait);
