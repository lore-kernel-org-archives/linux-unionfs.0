From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 1/2] vfs: introduce inode 'inuse' lock
Date: Tue, 23 May 2017 12:50:32 +0300
Message-ID: <1495533033-22367-2-git-send-email-amir73il@gmail.com>
References: <1495533033-22367-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:33451 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S935917AbdEWJuY (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 May 2017 05:50:24 -0400
In-Reply-To: <1495533033-22367-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Added an i_state flag I_INUSE and helpers to set/clear/test the bit.

The 'inuse' lock is an 'advisory' inode lock, which also provides
may_delete() protection, so can be used to extend exclusive create
protection beyond parent->i_mutex lock among cooperating users.

This is going to be used by overlayfs to get exclusive ownership
on upper and work dirs among overlayfs mounts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/btrfs/ioctl.c   |  3 +++
 fs/inode.c         | 40 ++++++++++++++++++++++++++++++++++++++++
 fs/namei.c         |  3 +++
 include/linux/fs.h | 16 ++++++++++++++++
 4 files changed, 62 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index e176375..17fa239 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -782,6 +782,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
  *  9. We can't remove a root or mountpoint.
  * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
  *     nfs_async_unlink().
+ * 11. We don't allow removal of inodes marked 'inuse'.
  */
 
 static int btrfs_may_delete(struct inode *dir, struct dentry *victim, int isdir)
@@ -813,6 +814,8 @@ static int btrfs_may_delete(struct inode *dir, struct dentry *victim, int isdir)
 		return -ENOENT;
 	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
 		return -EBUSY;
+	if (inode_inuse(d_inode(victim)))
+		return -EBUSY;
 	return 0;
 }
 
diff --git a/fs/inode.c b/fs/inode.c
index db59147..0552c8b 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2120,3 +2120,43 @@ struct timespec current_time(struct inode *inode)
 	return timespec_trunc(now, inode->i_sb->s_time_gran);
 }
 EXPORT_SYMBOL(current_time);
+
+/**
+ * inode_inuse_trylock - try to get an exclusive 'inuse' lock on inode
+ * @inode: inode being locked
+ *
+ * The 'inuse' lock is an 'advisory' inode lock, which also provides
+ * may_delete() protection, so can be used to extend exclusive create
+ * protection beyond parent->i_mutex lock among cooperating users.
+ * Used by overlayfs to get exclusive ownership on upper and work dirs
+ * among overlayfs mounts.
+ *
+ * Return true if I_INUSE flag was set by this call.
+ */
+bool inode_inuse_trylock(struct inode *inode)
+{
+	bool locked = false;
+
+	spin_lock(&inode->i_lock);
+	if (!(inode->i_state & (I_FREEING|I_WILL_FREE|I_INUSE))) {
+		inode->i_state |= I_INUSE;
+		locked = true;
+	}
+	spin_unlock(&inode->i_lock);
+	return locked;
+}
+EXPORT_SYMBOL(inode_inuse_trylock);
+
+/*
+ * Non-cooperating users should not be calling this functions and cooperating
+ * users should call this function only if they have the exclusive 'inuse' lock.
+ */
+void inode_inuse_unlock(struct inode *inode)
+{
+	WARN_ON(!inode_inuse(inode));
+
+	spin_lock(&inode->i_lock);
+	inode->i_state &= ~I_INUSE;
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL(inode_inuse_unlock);
diff --git a/fs/namei.c b/fs/namei.c
index 837da8b..c371b25 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2790,6 +2790,7 @@ EXPORT_SYMBOL(__check_sticky);
  * 10. We can't remove a root or mountpoint.
  * 11. We don't allow removal of NFS sillyrenamed files; it's handled by
  *     nfs_async_unlink().
+ * 12. We don't allow removal of inodes marked 'inuse'.
  */
 static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 {
@@ -2823,6 +2824,8 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 		return -ENOENT;
 	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
 		return -EBUSY;
+	if (inode_inuse(d_inode(victim)))
+		return -EBUSY;
 	return 0;
 }
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aab10f9..1420e8b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1864,6 +1864,7 @@ struct super_operations {
 #define IS_AUTOMOUNT(inode)	((inode)->i_flags & S_AUTOMOUNT)
 #define IS_NOSEC(inode)		((inode)->i_flags & S_NOSEC)
 #define IS_DAX(inode)		((inode)->i_flags & S_DAX)
+#define IS_INUSE(inode)		((inode)->i_flags & S_INUSE)
 
 #define IS_WHITEOUT(inode)	(S_ISCHR(inode->i_mode) && \
 				 (inode)->i_rdev == WHITEOUT_DEV)
@@ -1929,6 +1930,13 @@ static inline bool HAS_UNMAPPED_ID(struct inode *inode)
  *			wb stat updates to grab mapping->tree_lock.  See
  *			inode_switch_wb_work_fn() for details.
  *
+ * I_INUSE		An 'advisory' bit to get exclusive ownership on inode
+ *			using inode_inuse_trylock().  Also provides may_delete()
+ *			protection, so can be used to extend exclusive create
+ *			protection beyond parent->i_mutex lock.
+ *			Used by overlayfs to get exclusive ownership on upper
+ *			and work dirs among overlayfs mounts.
+ *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  */
 #define I_DIRTY_SYNC		(1 << 0)
@@ -1949,6 +1957,7 @@ static inline bool HAS_UNMAPPED_ID(struct inode *inode)
 #define __I_DIRTY_TIME_EXPIRED	12
 #define I_DIRTY_TIME_EXPIRED	(1 << __I_DIRTY_TIME_EXPIRED)
 #define I_WB_SWITCH		(1 << 13)
+#define I_INUSE			(1 << 14)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
@@ -3258,5 +3267,12 @@ static inline bool dir_relax_shared(struct inode *inode)
 
 extern bool path_noexec(const struct path *path);
 extern void inode_nohighmem(struct inode *inode);
+extern bool inode_inuse_trylock(struct inode *inode);
+extern void inode_inuse_unlock(struct inode *inode);
+
+static inline bool inode_inuse(struct inode *inode)
+{
+	return inode->i_state & I_INUSE;
+}
 
 #endif /* _LINUX_FS_H */
-- 
2.7.4
