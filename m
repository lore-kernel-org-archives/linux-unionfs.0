From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 2/3] vfs: Add d_select_inode for overlayfs translation
Date: Tue,  1 Mar 2016 12:12:07 -0600
Message-ID: <1456855928-29913-3-git-send-email-rgoldwyn@suse.de>
References: <1456855928-29913-1-git-send-email-rgoldwyn@suse.de>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1456855928-29913-1-git-send-email-rgoldwyn@suse.de>
Sender: linux-fsdevel-owner@vger.kernel.org
To: miklos@szeredi.hu
Cc: linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-nfs@vger.kernel.org, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: linux-unionfs@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

d_select_inode() is a helper function to translate dentry to inodes
while using in conjunction with overlayfs so dentries evaluate to
true lower inodes.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 include/linux/dcache.h | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 7781ce11..dbaa420 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -541,6 +541,21 @@ static inline struct inode *d_inode(const struct dentry *dentry)
 }
 
 /**
+ * d_select_inode - Get the actual inode of this dentry
+ * @dentry: The dentry to query
+ * @flags: open flags passed
+ *
+ * This is the helper to select the underlying true inode associated with
+ * a dentry to cover cases of translating overlay filesystem.
+ */
+static inline struct inode *d_select_inode(struct dentry *dentry, int flags)
+{
+	if (dentry->d_flags & DCACHE_OP_SELECT_INODE)
+		return dentry->d_op->d_select_inode(dentry, flags);
+	return dentry->d_inode;
+}
+
+/**
  * d_inode_rcu - Get the actual inode of this dentry with ACCESS_ONCE()
  * @dentry: The dentry to query
  *
-- 
2.6.2

