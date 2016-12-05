From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3] ovl: lockdep annotate of nested stacked overlayfs inode lock
Date: Mon,  5 Dec 2016 13:56:34 +0200
Message-ID: <1480938994-17423-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f194.google.com ([209.85.210.194]:34942 "EHLO
        mail-wj0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751266AbcLEL45 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 5 Dec 2016 06:56:57 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Quentin Casasnovas <quentin.casasnovas@oracle.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

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
different key for dir vs. non-dir.

Here is an edited snip from /proc/lockdep_chains after
iterate_dir() of nested overlayfs:

 [...] &ovl_i_mutex_dir_key[nested]   (stack_depth=2)
 [...] &ovl_i_mutex_dir_key[nested]#2 (stack_depth=1)
 [...] &type->i_mutex_dir_key         (stack_depth=0)

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/inode.c     | 36 ++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |  1 +
 fs/overlayfs/ovl_entry.h |  1 +
 fs/overlayfs/super.c     | 11 +++++++++++
 fs/overlayfs/util.c      |  7 +++++++
 5 files changed, 56 insertions(+)

v3:
- discard different annotation for nesting level 0
- compile away without CONFIG_LOCKDEP

v2:
- specific implementation in overlayfs

v1:
- generic implemetnation in vfs

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 83eaa56..51754bb 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -528,6 +528,40 @@ static const struct file_operations ovl_file_operations = {
 	.open		= ovl_open,
 };
 
+/*
+ * It is possible to stack overlayfs instance on top of another
+ * overlayfs instance as lower layer. We need to annonate the
+ * stackable i_mutex locks according to stack level of the super
+ * block instance. An overlayfs instance can never be in stack
+ * depth 0 (there is always a real fs below it).  An overlayfs
+ * inode lock will use the lockdep annotaion ovl_i_mutex_key[nested].
+ *
+ * For example, here is a snip from /proc/lockdep_chains after
+ * dir_iterate of nested overlayfs:
+ *
+ * [...] &ovl_i_mutex_dir_key[nested]   (stack_depth=2)
+ * [...] &ovl_i_mutex_dir_key[nested]#2 (stack_depth=1)
+ * [...] &type->i_mutex_dir_key         (stack_depth=0)
+ */
+#define OVL_MAX_NESTING FILESYSTEM_MAX_STACK_DEPTH
+
+static struct lock_class_key ovl_i_mutex_key[OVL_MAX_NESTING];
+static struct lock_class_key ovl_i_mutex_dir_key[OVL_MAX_NESTING];
+
+static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
+{
+#ifdef CONFIG_LOCKDEP
+	int nested = ovl_nested(inode->i_sb);
+
+	if (S_ISDIR(inode->i_mode))
+		lockdep_set_class(&inode->i_rwsem,
+				  &ovl_i_mutex_dir_key[nested]);
+	else
+		lockdep_set_class(&inode->i_rwsem,
+				  &ovl_i_mutex_key[nested]);
+#endif
+}
+
 static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
 {
 	inode->i_ino = get_next_ino();
@@ -537,6 +571,8 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
 	inode->i_acl = inode->i_default_acl = ACL_DONT_CACHE;
 #endif
 
+	ovl_lockdep_annotate_inode_mutex_key(inode);
+
 	switch (mode & S_IFMT) {
 	case S_IFREG:
 		inode->i_op = &ovl_file_inode_operations;
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 744d744..0fdf10e 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -141,6 +141,7 @@ static inline struct inode *ovl_inode_real(struct inode *inode, bool *is_upper)
 int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
 struct dentry *ovl_workdir(struct dentry *dentry);
+int ovl_nested(struct super_block *sb);
 const struct cred *ovl_override_creds(struct super_block *sb);
 struct ovl_entry *ovl_alloc_entry(unsigned int numlower);
 bool ovl_dentry_remote(struct dentry *dentry);
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index d14bca1..8bc9c54 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -23,6 +23,7 @@ struct ovl_fs {
 	struct vfsmount **lower_mnt;
 	struct dentry *workdir;
 	long namelen;
+	int nested;
 	/* pathnames of lower and upper dirs, for show_options */
 	struct ovl_config config;
 	/* creds of process who forced instantiation of super block */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index f9a2021..8d9eadb 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -509,6 +509,17 @@ static int ovl_lower_dir(const char *name, struct path *path,
 		goto out_put;
 
 	*stack_depth = max(*stack_depth, path->mnt->mnt_sb->s_stack_depth);
+	/*
+	 * ofs->nested should mean the level of nesting of overlayfs
+	 * instances, but since FILESYSTEM_MAX_STACK_DEPTH it is not likely
+	 * to ever grow much higher than 2, use sb->s_stack_depth of lower
+	 * as a good enough approximation that guaranties:
+	 * 1. overlayfs over non-overlayfs will have ofs->nested=0
+	 * 2. a stack of several overlayfs instances will each have
+	 *    a different value of ofs->nested
+	 */
+	if (path->mnt->mnt_sb->s_magic == OVERLAYFS_SUPER_MAGIC)
+		ofs->nested = *stack_depth;
 
 	if (ovl_dentry_remote(path->dentry))
 		*remote = true;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 952286f..21a85fc 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -32,6 +32,13 @@ struct dentry *ovl_workdir(struct dentry *dentry)
 	return ofs->workdir;
 }
 
+int ovl_nested(struct super_block *sb)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+
+	return ofs->nested;
+}
+
 const struct cred *ovl_override_creds(struct super_block *sb)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
-- 
2.7.4
