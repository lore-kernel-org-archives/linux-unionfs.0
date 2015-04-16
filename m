From: David Howells <dhowells@redhat.com>
Subject: [PATCH 4/4] Overlayfs: Wrap RCU-mode accesses to ->d_inode on
 subordinate filesystems
Date: Thu, 16 Apr 2015 15:43:19 +0100
Message-ID: <20150416144319.12620.61390.stgit@warthog.procyon.org.uk>
References: <20150416144241.12620.85836.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45873 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933614AbbDPOnY (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 16 Apr 2015 10:43:24 -0400
In-Reply-To: <20150416144241.12620.85836.stgit@warthog.procyon.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: viro@zeniv.linux.org.uk, miklos@szeredi.hu
Cc: dhowells@redhat.com, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

There is a place in overlayfs where it may touch a lower-layer inode during
RCU-mode pathwalk.  In this situation the combination of d_backing_inode() and
ACCESS_ONCE() does not compile, so institute and use a d_backing_inode_rcu()
function that combines these.

Signed-off-by: David Howells <dhowells@redhat.com>
---

 fs/overlayfs/inode.c   |    2 +-
 include/linux/dcache.h |   18 ++++++++++++++++++
 2 files changed, 19 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index ead6a7a6fe9d..7e3a7e3ff095 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -99,7 +99,7 @@ int ovl_permission(struct inode *inode, int mask)
 	realdentry = ovl_entry_real(oe, &is_upper);
 
 	/* Careful in RCU walk mode */
-	realinode = ACCESS_ONCE(realdentry->d_inode);
+	realinode = d_backing_inode_rcu(realdentry);
 	if (!realinode) {
 		WARN_ON(!(mask & MAY_NOT_BLOCK));
 		err = -ENOENT;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index df334cbacc6d..50004f2429a1 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -562,6 +562,24 @@ static inline struct inode *d_backing_inode(const struct dentry *upper)
 }
 
 /**
+ * d_backing_inode_rcu - Get upper or lower inode we should be using with ACCESS_ONCE()
+ * @upper: The upper layer
+ *
+ * This is the helper that should be used to get at the inode that will be used
+ * if this dentry were to be opened as a file.  The inode may be on the upper
+ * dentry or it may be on a lower dentry pinned by the upper.  Further, the
+ * upper dentry might not have an inode set.
+ *
+ * Normal filesystems should not use this to access their own inodes.
+ */
+static inline struct inode *d_backing_inode_rcu(const struct dentry *upper)
+{
+	struct inode *inode = ACCESS_ONCE(upper->d_inode);
+
+	return inode;
+}
+
+/**
  * d_backing_dentry - Get upper or lower dentry we should be using
  * @upper: The upper layer
  *

