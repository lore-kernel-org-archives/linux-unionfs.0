From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH] fsnotify: support overlayfs
Date: Tue, 19 Jul 2016 14:45:15 +0200
Message-ID: <1468932315-27384-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:33678 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753249AbcGSMpS (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Tue, 19 Jul 2016 08:45:18 -0400
Received: by mail-wm0-f43.google.com with SMTP id r190so25982364wmr.0
        for <linux-unionfs@vger.kernel.org>; Tue, 19 Jul 2016 05:45:18 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eric Paris <eparis@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Aihua Zhang <zhangaihua1@huawei.com>

From: Aihua Zhang <zhangaihua1@huawei.com>

When an event occurs direct it to the overlay inode instead of the real
underlying inode.

This will work even if the file was first on the lower layer and then
copied up, while the watch is there.  This is because the watch is on the
overlay inode, which stays the same through the copy-up.

For filesystems other than overlayfs this is a no-op, except for the
performance impact of an extra pointer dereferece.

Verified to work correctly with the inotify/fanotify tests in LTP.

Signed-off-by: Aihua Zhang <zhangaihua1@huawei.com>
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 include/linux/fsnotify.h | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 0141f257d67b..bca822bb3ce3 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -29,7 +29,11 @@ static inline int fsnotify_parent(struct path *path, struct dentry *dentry, __u3
 static inline int fsnotify_perm(struct file *file, int mask)
 {
 	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	/*
+	 * Do not use file_inode() here or anywhere in this file to get the
+	 * inode.  That would break *notity on overlayfs.
+	 */
+	struct inode *inode = path->dentry->d_inode;
 	__u32 fsnotify_mask = 0;
 	int ret;
 
@@ -185,7 +189,7 @@ static inline void fsnotify_mkdir(struct inode *inode, struct dentry *dentry)
 static inline void fsnotify_access(struct file *file)
 {
 	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_ACCESS;
 
 	if (S_ISDIR(inode->i_mode))
@@ -203,7 +207,7 @@ static inline void fsnotify_access(struct file *file)
 static inline void fsnotify_modify(struct file *file)
 {
 	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_MODIFY;
 
 	if (S_ISDIR(inode->i_mode))
@@ -221,7 +225,7 @@ static inline void fsnotify_modify(struct file *file)
 static inline void fsnotify_open(struct file *file)
 {
 	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = path->dentry->d_inode;
 	__u32 mask = FS_OPEN;
 
 	if (S_ISDIR(inode->i_mode))
@@ -237,7 +241,7 @@ static inline void fsnotify_open(struct file *file)
 static inline void fsnotify_close(struct file *file)
 {
 	struct path *path = &file->f_path;
-	struct inode *inode = file_inode(file);
+	struct inode *inode = path->dentry->d_inode;
 	fmode_t mode = file->f_mode;
 	__u32 mask = (mode & FMODE_WRITE) ? FS_CLOSE_WRITE : FS_CLOSE_NOWRITE;
 
-- 
2.5.5
