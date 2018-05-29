From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 38/39] Revert "fsnotify: support overlayfs"
Date: Tue, 29 May 2018 16:43:38 +0200
Message-ID: <20180529144339.16538-39-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This reverts commit f3fbbb079263bd29ae592478de6808db7e708267.

Overlayfs now works correctly without adding hacks to fsnotify.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 include/linux/fsnotify.h | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index bdaf22582f6e..fd1ce10553bf 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -30,11 +30,7 @@ static inline int fsnotify_parent(const struct path *path, struct dentry *dentry
 static inline int fsnotify_perm(struct file *file, int mask)
 {
 	const struct path *path = &file->f_path;
-	/*
-	 * Do not use file_inode() here or anywhere in this file to get the
-	 * inode.  That would break *notity on overlayfs.
-	 */
-	struct inode *inode = path->dentry->d_inode;
+	struct inode *inode = file_inode(file);
 	__u32 fsnotify_mask = 0;
 	int ret;
 
@@ -178,7 +174,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 static inline void fsnotify_access(struct file *file)
 {
 	const struct path *path = &file->f_path;
-	struct inode *inode = path->dentry->d_inode;
+	struct inode *inode = file_inode(file);
 	__u32 mask = FS_ACCESS;
 
 	if (S_ISDIR(inode->i_mode))
@@ -196,7 +192,7 @@ static inline void fsnotify_access(struct file *file)
 static inline void fsnotify_modify(struct file *file)
 {
 	const struct path *path = &file->f_path;
-	struct inode *inode = path->dentry->d_inode;
+	struct inode *inode = file_inode(file);
 	__u32 mask = FS_MODIFY;
 
 	if (S_ISDIR(inode->i_mode))
@@ -214,7 +210,7 @@ static inline void fsnotify_modify(struct file *file)
 static inline void fsnotify_open(struct file *file)
 {
 	const struct path *path = &file->f_path;
-	struct inode *inode = path->dentry->d_inode;
+	struct inode *inode = file_inode(file);
 	__u32 mask = FS_OPEN;
 
 	if (S_ISDIR(inode->i_mode))
@@ -230,7 +226,7 @@ static inline void fsnotify_open(struct file *file)
 static inline void fsnotify_close(struct file *file)
 {
 	const struct path *path = &file->f_path;
-	struct inode *inode = path->dentry->d_inode;
+	struct inode *inode = file_inode(file);
 	fmode_t mode = file->f_mode;
 	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
 
-- 
2.14.3
