From: <zhangaihua1@huawei.com>
Subject: [PATCH] ovl:support fsinotify on overlayfs.
Date: Thu, 7 Jul 2016 15:37:53 +0800
Message-ID: <1467877073-32109-1-git-send-email-zhangaihua1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org
Cc: zhangaihua <zhangaihua1@huawei.com>
List-Id: linux-unionfs@vger.kernel.org

From: zhangaihua <zhangaihua1@huawei.com>

fix the inode to suppoert fsinotify, the inode should point
to overlay rather than upper.

before patch:
[root@localhost bin]# ./inotify01
inotify01    1  TPASS  :  get event: wd=1 mask=4 cookie=0 len=0
inotify01    2  TFAIL  :  inotify01.c:185: didn't get event: mask=20
inotify01    3  TFAIL  :  inotify01.c:185: didn't get event: mask=1
inotify01    4  TFAIL  :  inotify01.c:185: didn't get event: mask=10
inotify01    5  TFAIL  :  inotify01.c:185: didn't get event: mask=20
inotify01    6  TFAIL  :  inotify01.c:185: didn't get event: mask=2
inotify01    7  TFAIL  :  inotify01.c:185: didn't get event: mask=8

after patch:
[root@localhost bin]# ./inotify01
inotify01    1  TPASS  :  get event: wd=1 mask=4 cookie=0 len=0
inotify01    2  TPASS  :  get event: wd=1 mask=20 cookie=0 len=0
inotify01    3  TPASS  :  get event: wd=1 mask=1 cookie=0 len=0
inotify01    4  TPASS  :  get event: wd=1 mask=10 cookie=0 len=0
inotify01    5  TPASS  :  get event: wd=1 mask=20 cookie=0 len=0
inotify01    6  TPASS  :  get event: wd=1 mask=2 cookie=0 len=0
inotify01    7  TPASS  :  get event: wd=1 mask=8 cookie=0 len=0

Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
---
 include/linux/fsnotify.h |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 7ee1774..ccd8395 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -194,7 +194,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 static inline void fsnotify_access(struct file *file)
 {
 	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_ACCESS;
 
 	if (S_ISDIR(inode->i_mode))
@@ -212,8 +212,8 @@ static inline void fsnotify_access(struct file *file)
 static inline void fsnotify_modify(struct file *file)
 {
 	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = path->dentry->d_inode;
	 __u32 mask = FS_MODIFY; 

 	if (S_ISDIR(inode->i_mode))
 		mask |= FS_ISDIR;
@@ -230,7 +230,7 @@ static inline void fsnotify_modify(struct file *file)
 static inline void fsnotify_open(struct file *file)
 {
 	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_OPEN;
 
 	if (S_ISDIR(inode->i_mode))
@@ -246,8 +246,8 @@ static inline void fsnotify_open(struct file *file)
 static inline void fsnotify_close(struct file *file)
 {
 	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = path->dentry->d_inode;
	fmode_t mode = file->f_mode;
 	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
 
 	if (S_ISDIR(inode->i_mode))
-- 
1.7.1
