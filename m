From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 01/17] vfs: add helper wait_on_inode_inuse()
Date: Fri,  2 Jun 2017 17:04:28 +0300
Message-ID: <1496412284-4113-2-git-send-email-amir73il@gmail.com>
References: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:36181 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750971AbdFBOEo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 2 Jun 2017 10:04:44 -0400
Received: by mail-wr0-f195.google.com with SMTP id e23so172212wre.3
        for <linux-unionfs@vger.kernel.org>; Fri, 02 Jun 2017 07:04:34 -0700 (PDT)
In-Reply-To: <1496412284-4113-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Adds a helper to wait until an inode's INUSE bit is cleared.

This is going to be used by overlayfs to sychronize concurrent copy up
of lower hardlinks.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/inode.c         | 24 ++++++++++++++++++++++++
 include/linux/fs.h |  1 +
 2 files changed, 25 insertions(+)

diff --git a/fs/inode.c b/fs/inode.c
index 216efeecdbdc..546cd503148a 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -2167,6 +2167,30 @@ void inode_inuse_unlock(struct inode *inode)
 	WARN_ON(inode->i_state & (I_NEW | I_FREEING | I_WILL_FREE));
 	WARN_ON(!(inode->i_state & I_INUSE));
 	inode->i_state &= ~I_INUSE;
+	smp_mb();
+	wake_up_bit(&inode->i_state, __I_INUSE);
 	spin_unlock(&inode->i_lock);
 }
 EXPORT_SYMBOL(inode_inuse_unlock);
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
index 2e29ff868e90..e064612b45ef 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -3268,6 +3268,7 @@ extern bool path_noexec(const struct path *path);
 extern void inode_nohighmem(struct inode *inode);
 extern bool inode_inuse_trylock(struct inode *inode);
 extern void inode_inuse_unlock(struct inode *inode);
+extern int wait_on_inode_inuse(struct inode *inode, unsigned mode);
 
 static inline bool inode_inuse(struct inode *inode)
 {
-- 
2.7.4
