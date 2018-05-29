From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 33/39] Revert "ovl: fix relatime for directories"
Date: Tue, 29 May 2018 16:43:33 +0200
Message-ID: <20180529144339.16538-34-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This reverts commit cd91304e7190b4c4802f8e413ab2214b233e0260.

Overlayfs no longer relies on the vfs correct atime handling.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/inode.c             | 21 ++++-----------------
 fs/overlayfs/super.c   |  3 ---
 include/linux/dcache.h |  3 ---
 3 files changed, 4 insertions(+), 23 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 1bea65d37afe..ad0259bafe2d 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1559,24 +1559,11 @@ EXPORT_SYMBOL(bmap);
 static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
 			       bool rcu)
 {
-	struct dentry *upperdentry;
+	if (!rcu) {
+		struct inode *realinode = d_real_inode(dentry);
 
-	/*
-	 * Nothing to do if in rcu or if non-overlayfs
-	 */
-	if (rcu || likely(!(dentry->d_flags & DCACHE_OP_REAL)))
-		return;
-
-	upperdentry = d_real(dentry, NULL, 0, D_REAL_UPPER);
-
-	/*
-	 * If file is on lower then we can't update atime, so no worries about
-	 * stale mtime/ctime.
-	 */
-	if (upperdentry) {
-		struct inode *realinode = d_inode(upperdentry);
-
-		if ((!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
+		if (unlikely(inode != realinode) &&
+		    (!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
 		     !timespec_equal(&inode->i_ctime, &realinode->i_ctime))) {
 			inode->i_mtime = realinode->i_mtime;
 			inode->i_ctime = realinode->i_ctime;
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 900ed4c39919..65ec661c60e6 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -107,9 +107,6 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 	if (inode && d_inode(dentry) == inode)
 		return dentry;
 
-	if (flags & D_REAL_UPPER)
-		return ovl_dentry_upper(dentry);
-
 	if (!d_is_reg(dentry)) {
 		if (!inode || inode == d_inode(dentry))
 			return dentry;
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 66c6e17e61e5..ddae4103d324 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -564,9 +564,6 @@ static inline struct dentry *d_backing_dentry(struct dentry *upper)
 	return upper;
 }
 
-/* d_real() flags */
-#define D_REAL_UPPER	0x2	/* return upper dentry or NULL if non-upper */
-
 /**
  * d_real - Return the real dentry
  * @dentry: the dentry to query
-- 
2.14.3
