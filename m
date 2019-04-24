Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] fsnotify: do not generate duplicate events for "fake" path
Date: Wed, 24 Apr 2019 13:09:51 +0300
Message-Id: <20190424100951.16678-1-amir73il@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: Murphy Zhou <jencce.kernel@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Overlayfs "fake" path is used for stacked file operations on
underlying files.  Operations on files with "fake" path must not
generate events on mount marks and on parent watches, because
those events have already been generated at overlayfs layer.

The reported event->fd for inode/sb marks will have the wrong path
(overlayfs path), but we have no choice but to report them anyway.

Link: https://lore.kernel.org/linux-fsdevel/20190423065024.12695-1-jencce.kernel@gmail.com/
Reported-by: Murphy Zhou <jencce.kernel@gmail.com>
Fixes: d1d04ef8572b ("ovl: stack file ops")
Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Jan,

This is a slightly simplified and cleaner version of the patch I posted
yesterday on the linked bug report thread.

I have posted an additional overlayfs test case to fanotify06 on LTP
list.

Thanks,
Amir.

 fs/notify/fsnotify.c     |  3 ++-
 include/linux/fsnotify.h | 23 ++++++++++++++++++++---
 2 files changed, 22 insertions(+), 4 deletions(-)

diff --git a/fs/notify/fsnotify.c b/fs/notify/fsnotify.c
index df06f3da166c..6f752b13e3fd 100644
--- a/fs/notify/fsnotify.c
+++ b/fs/notify/fsnotify.c
@@ -334,7 +334,8 @@ int fsnotify(struct inode *to_tell, __u32 mask, const void *data, int data_is,
 	int ret = 0;
 	__u32 test_mask = (mask & ALL_FSNOTIFY_EVENTS);
 
-	if (data_is == FSNOTIFY_EVENT_PATH) {
+	if (data_is == FSNOTIFY_EVENT_PATH &&
+	    !fsnotify_is_fake_path(to_tell, data)) {
 		mnt = real_mount(((const struct path *)data)->mnt);
 		mnt_or_sb_mask |= mnt->mnt_fsnotify_mask;
 	}
diff --git a/include/linux/fsnotify.h b/include/linux/fsnotify.h
index 09587e2860b5..c51f57d3a025 100644
--- a/include/linux/fsnotify.h
+++ b/include/linux/fsnotify.h
@@ -40,6 +40,20 @@ static inline int fsnotify_parent(const struct path *path,
 	return __fsnotify_parent(path, dentry, mask);
 }
 
+/*
+ * Overlayfs "fake" path is used for stacked file operations on underlying
+ * files.  file->f_path is from overlayfs layer and file->f_inode is from
+ * underlying layer.  We must not generate events on mount and on parent
+ * based on fake path, because those events have already been generated at
+ * overlayfs layer.  The reported event->fd for inode/sb marks will have the
+ * wrong path (overlayfs path), but we have no choice but to report them as is.
+ */
+static inline bool fsnotify_is_fake_path(struct inode *inode,
+					 const struct path *path)
+{
+	return unlikely(inode->i_sb != path->dentry->d_sb);
+}
+
 /*
  * Simple wrapper to consolidate calls fsnotify_parent()/fsnotify() when
  * an event is on a path.
@@ -47,10 +61,13 @@ static inline int fsnotify_parent(const struct path *path,
 static inline int fsnotify_path(struct inode *inode, const struct path *path,
 				__u32 mask)
 {
-	int ret = fsnotify_parent(path, NULL, mask);
+	if (!fsnotify_is_fake_path(inode, path)) {
+		int ret = fsnotify_parent(path, NULL, mask);
+
+		if (ret)
+			return ret;
+	}
 
-	if (ret)
-		return ret;
 	return fsnotify(inode, mask, path, FSNOTIFY_EVENT_PATH, NULL, 0);
 }
 
-- 
2.17.1
