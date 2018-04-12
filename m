From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 25/35] Revert "vfs: update ovl inode before relatime check"
Date: Thu, 12 Apr 2018 17:08:16 +0200
Message-ID: <20180412150826.20988-26-mszeredi@redhat.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This reverts commit 598e3c8f72f5b77c84d2cb26cfd936ffb3cfdbaa.

Overlayfs no longer relies on the vfs correct atime handling.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/inode.c         | 33 ++++++---------------------------
 fs/internal.h      |  7 -------
 fs/namei.c         |  2 +-
 include/linux/fs.h |  1 +
 4 files changed, 8 insertions(+), 35 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 163715de8cb2..4832a2b47f65 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1564,37 +1564,17 @@ sector_t bmap(struct inode *inode, sector_t block)
 }
 EXPORT_SYMBOL(bmap);
 
-/*
- * Update times in overlayed inode from underlying real inode
- */
-static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
-			       bool rcu)
-{
-	if (!rcu) {
-		struct inode *realinode = d_real_inode(dentry);
-
-		if (unlikely(inode != realinode) &&
-		    (!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
-		     !timespec_equal(&inode->i_ctime, &realinode->i_ctime))) {
-			inode->i_mtime = realinode->i_mtime;
-			inode->i_ctime = realinode->i_ctime;
-		}
-	}
-}
-
 /*
  * With relative atime, only update atime if the previous atime is
  * earlier than either the ctime or mtime or if at least a day has
  * passed since the last atime update.
  */
-static int relatime_need_update(const struct path *path, struct inode *inode,
-				struct timespec now, bool rcu)
+static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
+			     struct timespec now)
 {
 
-	if (!(path->mnt->mnt_flags & MNT_RELATIME))
+	if (!(mnt->mnt_flags & MNT_RELATIME))
 		return 1;
-
-	update_ovl_inode_times(path->dentry, inode, rcu);
 	/*
 	 * Is mtime younger than atime? If yes, update atime:
 	 */
@@ -1665,8 +1645,7 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
  *	This function automatically handles read only file systems and media,
  *	as well as the "noatime" flag and inode specific "noatime" markers.
  */
-bool __atime_needs_update(const struct path *path, struct inode *inode,
-			  bool rcu)
+bool atime_needs_update(const struct path *path, struct inode *inode)
 {
 	struct vfsmount *mnt = path->mnt;
 	struct timespec now;
@@ -1692,7 +1671,7 @@ bool __atime_needs_update(const struct path *path, struct inode *inode,
 
 	now = current_time(inode);
 
-	if (!relatime_need_update(path, inode, now, rcu))
+	if (!relatime_need_update(mnt, inode, now))
 		return false;
 
 	if (timespec_equal(&inode->i_atime, &now))
@@ -1707,7 +1686,7 @@ void touch_atime(const struct path *path)
 	struct inode *inode = d_inode(path->dentry);
 	struct timespec now;
 
-	if (!__atime_needs_update(path, inode, false))
+	if (!atime_needs_update(path, inode))
 		return;
 
 	if (!sb_start_write_trylock(inode->i_sb))
diff --git a/fs/internal.h b/fs/internal.h
index d5108d9c6a2f..f0eaa33890d9 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -127,13 +127,6 @@ extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
 extern void inode_add_lru(struct inode *inode);
 extern int dentry_needs_remove_privs(struct dentry *dentry);
 
-extern bool __atime_needs_update(const struct path *, struct inode *, bool);
-static inline bool atime_needs_update_rcu(const struct path *path,
-					  struct inode *inode)
-{
-	return __atime_needs_update(path, inode, true);
-}
-
 /*
  * fs-writeback.c
  */
diff --git a/fs/namei.c b/fs/namei.c
index cafa365eeb70..2b3931bf5fb4 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1009,7 +1009,7 @@ const char *get_link(struct nameidata *nd)
 	if (!(nd->flags & LOOKUP_RCU)) {
 		touch_atime(&last->link);
 		cond_resched();
-	} else if (atime_needs_update_rcu(&last->link, inode)) {
+	} else if (atime_needs_update(&last->link, inode)) {
 		if (unlikely(unlazy_walk(nd)))
 			return ERR_PTR(-ECHILD);
 		touch_atime(&last->link);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index e28a2cf50fa7..5e5dd484937f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2062,6 +2062,7 @@ enum file_time_flags {
 	S_VERSION = 8,
 };
 
+extern bool atime_needs_update(const struct path *, struct inode *);
 extern void touch_atime(const struct path *);
 static inline void file_accessed(struct file *file)
 {
-- 
2.14.3
