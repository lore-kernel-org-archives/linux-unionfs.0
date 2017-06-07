From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 01/20] vfs: introduce inode 'inuse' lock
Date: Wed,  7 Jun 2017 10:51:05 +0300
Message-ID: <1496821884-5178-2-git-send-email-amir73il@gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35880 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751190AbdFGHvM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 03:51:12 -0400
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Added an i_state flag I_INUSE and helpers to set/clear/test and
wait until it is cleared.

The 'inuse' lock is an 'advisory' inode lock, that can be used to extend
exclusive create protection beyond parent->i_mutex lock among cooperating
users.

This is going to be used by overlayfs to get exclusive ownership on upper
and work dirs among overlayfs mounts and to sychronize concurrent copy up
of lower hardlinks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/inode.c         | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h | 16 ++++++++++++
 2 files changed, 90 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index db5914783a71..546cd503148a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2120,3 +2120,77 @@ struct timespec current_time(struct inode *inode)
 	return timespec_trunc(now, inode->i_sb->s_time_gran);
 }
 EXPORT_SYMBOL(current_time);
+
+/**
+ * inode_inuse_trylock - try to get an exclusive 'inuse' lock on inode
+ * @inode: inode being locked
+ *
+ * The 'inuse' lock is an 'advisory' lock that can be used to extend exclusive
+ * create protection beyond parent->i_mutex lock among cooperating users.
+ * Used by overlayfs to get exclusive ownership on upper and work dirs among
+ * overlayfs mounts.
+ *
+ * Caller must hold a reference to inode to prevent it from being freed while
+ * it is marked inuse.
+ *
+ * Return true if I_INUSE flag was set by this call.
+ */
+bool inode_inuse_trylock(struct inode *inode)
+{
+	bool locked = false;
+
+	spin_lock(&inode->i_lock);
+	if (!WARN_ON(!atomic_read(&inode->i_count)) &&
+	    !WARN_ON(inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE)) &&
+	    !(inode->i_state & I_INUSE)) {
+		inode->i_state |= I_INUSE;
+		locked = true;
+	}
+	spin_unlock(&inode->i_lock);
+	return locked;
+}
+EXPORT_SYMBOL(inode_inuse_trylock);
+
+/**
+ * inode_inuse_unlock - release exclusive 'inuse' lock
+ * @inode:	inode inuse to unlock
+ *
+ * Clear the I_INUSE state and wake up any waiters.
+ *
+ * Caller must hold a reference to inode and must have successfully marked
+ * the inode 'inuse' prior to this call.
+ */
+void inode_inuse_unlock(struct inode *inode)
+{
+	spin_lock(&inode->i_lock);
+	WARN_ON(!atomic_read(&inode->i_count));
+	WARN_ON(inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE));
+	WARN_ON(!(inode->i_state & I_INUSE));
+	inode->i_state &= ~I_INUSE;
+	smp_mb();
+	wake_up_bit(&inode->i_state, __I_INUSE);
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL(inode_inuse_unlock);
+
+/**
+ * wait_on_inode_inuse - wait for release of exclusive 'inuse' lock
+ * @inode:	inode inuse to wait on
+ *
+ * Can be used in combination with parent i_mutex, to protect access to a
+ * newly created inode, until that inode has been properly initialized by
+ * the user that grabbed the 'inuse' exclusive lock after creating the inode.
+ *
+ * Caller must hold a reference to inode to prevent waiting on an inode that
+ * is not 'inuse' and is already being freed.
+ *
+ * Return 0 if the 'inuse' bit is clear or has been cleared while waiting.
+ */
+int wait_on_inode_inuse(struct inode *inode, unsigned mode)
+{
+	if (WARN_ON(!atomic_read(&inode->i_count)))
+		return -EINVAL;
+	might_sleep();
+	return wait_on_bit(&inode->i_state, __I_INUSE, mode);
+}
+EXPORT_SYMBOL(wait_on_inode_inuse);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aab10f93ef23..e064612b45ef 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1929,6 +1929,12 @@ static inline bool HAS_UNMAPPED_ID(struct inode *inode)
  *			wb stat updates to grab mapping->tree_lock.  See
  *			inode_switch_wb_work_fn() for details.
  *
+ * I_INUSE		An 'advisory' bit to get exclusive ownership on inode
+ *			using inode_inuse_trylock().  It can be used to extend
+ *			exclusive create protection beyond parent->i_mutex lock.
+ *			Used by overlayfs to get exclusive ownership on upper
+ *			and work dirs among overlayfs mounts.
+ *
  * Q: What is the difference between I_WILL_FREE and I_FREEING?
  */
 #define I_DIRTY_SYNC		(1 << 0)
@@ -1949,6 +1955,8 @@ static inline bool HAS_UNMAPPED_ID(struct inode *inode)
 #define __I_DIRTY_TIME_EXPIRED	12
 #define I_DIRTY_TIME_EXPIRED	(1 << __I_DIRTY_TIME_EXPIRED)
 #define I_WB_SWITCH		(1 << 13)
+#define __I_INUSE		14
+#define I_INUSE			(1 << __I_INUSE)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
@@ -3258,5 +3266,13 @@ static inline bool dir_relax_shared(struct inode *inode)
 
 extern bool path_noexec(const struct path *path);
 extern void inode_nohighmem(struct inode *inode);
+extern bool inode_inuse_trylock(struct inode *inode);
+extern void inode_inuse_unlock(struct inode *inode);
+extern int wait_on_inode_inuse(struct inode *inode, unsigned mode);
+
+static inline bool inode_inuse(struct inode *inode)
+{
+	return inode->i_state & I_INUSE;
+}
 
 #endif /* _LINUX_FS_H */
-- 
2.7.4
