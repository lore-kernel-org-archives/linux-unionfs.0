From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v5] ovl: lockdep annotate of nested stacked overlayfs inode lock
Date: Wed,  8 Mar 2017 10:41:06 +0200
Message-ID: <1488962466-3264-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35175 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750740AbdCHJJ0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 8 Mar 2017 04:09:26 -0500
Received: by mail-wm0-f66.google.com with SMTP id z63so4897942wmg.2
        for <linux-unionfs@vger.kernel.org>; Wed, 08 Mar 2017 01:09:24 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

An overlayfs instance can be the lower layer of another overlayfs
instance. This setup triggers a lockdep splat of possible recursive
locking of sb->s_type->i_mutex_key in iterate_dir(). Trimmed snip:

 [ INFO: possible recursive locking detected ]
 bash/2468 is trying to acquire lock:
  &sb->s_type->i_mutex_key#14, at: iterate_dir+0x7d/0x15c
 but task is already holding lock:
  &sb->s_type->i_mutex_key#14, at: iterate_dir+0x7d/0x15c

One problem observed with this splat is that ovl_new_inode()
does not call lockdep_annotate_inode_mutex_key() to annotate
the dir inode lock as &sb->s_type->i_mutex_dir_key like other
fs do.

The other problem is that the 2 nested levels of overlayfs inode
lock are annotated using the same key, which is the cause of the
false positive lockdep warning.

Fix this by annotating overlayfs inode lock in ovl_fill_inode()
according to stack level of the super block instance and use
different key for dir vs. non-dir like other fs do.

Here is an edited snip from /proc/lockdep_chains after
iterate_dir() of nested overlayfs:

 [...] &ovl_i_mutex_dir_key[depth]   (stack_depth=2)
 [...] &ovl_i_mutex_dir_key[depth]#2 (stack_depth=1)
 [...] &type->i_mutex_dir_key        (stack_depth=0)

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
v4 -> v5:
- Fix compiltion warning on build without CONFIG_LOCKDEP
- Define OVL_MAX_NESTING instead of using FILESYSTEM_MAX_STACK_DEPTH directly

 fs/overlayfs/inode.c | 38 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 38 insertions(+)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index f8fe6bf..328d8c5 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -303,6 +303,42 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.update_time	= ovl_update_time,
 };
 
+/*
+ * It is possible to stack overlayfs instance on top of another
+ * overlayfs instance as lower layer. We need to annonate the
+ * stackable i_mutex locks according to stack level of the super
+ * block instance. An overlayfs instance can never be in stack
+ * depth 0 (there is always a real fs below it).  An overlayfs
+ * inode lock will use the lockdep annotaion 'ovl_i_mutex_key[depth]'.
+ *
+ * For example, here is a snip from /proc/lockdep_chains after
+ * dir_iterate of nested overlayfs:
+ *
+ * [...] &ovl_i_mutex_dir_key[depth]   (stack_depth=2)
+ * [...] &ovl_i_mutex_dir_key[depth]#2 (stack_depth=1)
+ * [...] &type->i_mutex_dir_key        (stack_depth=0)
+ */
+#define OVL_MAX_NESTING FILESYSTEM_MAX_STACK_DEPTH
+
+static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
+{
+#ifdef CONFIG_LOCKDEP
+	static struct lock_class_key ovl_i_mutex_key[OVL_MAX_NESTING];
+	static struct lock_class_key ovl_i_mutex_dir_key[OVL_MAX_NESTING];
+	int depth = inode->i_sb->s_stack_depth - 1;
+
+	if (WARN_ON_ONCE(depth < 0))
+		depth = 0;
+
+	if (S_ISDIR(inode->i_mode))
+		lockdep_set_class(&inode->i_rwsem,
+				  &ovl_i_mutex_dir_key[depth]);
+	else
+		lockdep_set_class(&inode->i_rwsem,
+				  &ovl_i_mutex_key[depth]);
+#endif
+}
+
 static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
 {
 	inode->i_ino = get_next_ino();
@@ -312,6 +348,8 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
 	inode->i_acl = inode->i_default_acl = ACL_DONT_CACHE;
 #endif
 
+	ovl_lockdep_annotate_inode_mutex_key(inode);
+
 	switch (mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &ovl_file_inode_operations;
-- 
2.7.4
