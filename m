From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 01/25] vfs: introduce inode 'inuse' lock
Date: Wed, 21 Jun 2017 15:28:32 +0300
Message-ID: <1498048136-28218-2-git-send-email-amir73il@gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:34663 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751641AbdFUM2o (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 08:28:44 -0400
Received: by mail-wr0-f195.google.com with SMTP id y25so23905609wrd.1
        for <linux-unionfs@vger.kernel.org>; Wed, 21 Jun 2017 05:28:44 -0700 (PDT)
In-Reply-To: <1498048136-28218-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Added an i_state flag I_INUSE and helpers to set/clear/test the bit.

The 'inuse' lock is an 'advisory' inode lock, that can be used to extend
exclusive create protection beyond parent->i_mutex lock among cooperating
users.

This is going to be used by overlayfs to get exclusive ownership on upper
and work dirs among overlayfs mounts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/inode.c         | 50 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h | 14 ++++++++++++++
 2 files changed, 64 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index db5914783a71..6a41b27467eb 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2120,3 +2120,53 @@ struct timespec current_time(struct inode *inode)
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
+ * Clear the I_INUSE state.
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
+	spin_unlock(&inode->i_lock);
+}
+EXPORT_SYMBOL(inode_inuse_unlock);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index aab10f93ef23..532802120258 100644
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
@@ -1949,6 +1955,7 @@ static inline bool HAS_UNMAPPED_ID(struct inode *inode)
 #define __I_DIRTY_TIME_EXPIRED	12
 #define I_DIRTY_TIME_EXPIRED	(1 << __I_DIRTY_TIME_EXPIRED)
 #define I_WB_SWITCH		(1 << 13)
+#define I_INUSE			(1 << 14)
 
 #define I_DIRTY (I_DIRTY_SYNC | I_DIRTY_DATASYNC | I_DIRTY_PAGES)
 #define I_DIRTY_ALL (I_DIRTY | I_DIRTY_TIME)
@@ -3258,5 +3265,12 @@ static inline bool dir_relax_shared(struct inode *inode)
 
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
