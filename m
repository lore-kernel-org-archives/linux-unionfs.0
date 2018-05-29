From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 34/39] Revert "vfs: update ovl inode before relatime check"
Date: Tue, 29 May 2018 16:43:34 +0200
Message-ID: <20180529144339.16538-35-mszeredi@redhat.com>
References: <20180529144339.16538-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180529144339.16538-1-mszeredi@redhat.com>
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
index ad0259bafe2d..348e93f468cc 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1553,37 +1553,17 @@ sector_t bmap(struct inode *inode, sector_t block)
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
@@ -1654,8 +1634,7 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
  *	This function automatically handles read only file systems and media,
  *	as well as the "noatime" flag and inode specific "noatime" markers.
  */
-bool __atime_needs_update(const struct path *path, struct inode *inode,
-			  bool rcu)
+bool atime_needs_update(const struct path *path, struct inode *inode)
 {
 	struct vfsmount *mnt = path->mnt;
 	struct timespec now;
@@ -1681,7 +1660,7 @@ bool __atime_needs_update(const struct path *path, struct inode *inode,
 
 	now = current_time(inode);
 
-	if (!relatime_need_update(path, inode, now, rcu))
+	if (!relatime_need_update(mnt, inode, now))
 		return false;
 
 	if (timespec_equal(&inode->i_atime, &now))
@@ -1696,7 +1675,7 @@ void touch_atime(const struct path *path)
 	struct inode *inode = d_inode(path->dentry);
 	struct timespec now;
 
-	if (!__atime_needs_update(path, inode, false))
+	if (!atime_needs_update(path, inode))
 		return;
 
 	if (!sb_start_write_trylock(inode->i_sb))
diff --git a/fs/internal.h b/fs/internal.h
index 29c9a2fab592..6ada1f356da6 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -138,13 +138,6 @@ extern long prune_icache_sb(struct super_block *sb, struct shrink_control *sc);
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
index 186bd2464fd5..54ab8ccb8d6d 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -1013,7 +1013,7 @@ const char *get_link(struct nameidata *nd)
 	if (!(nd->flags & LOOKUP_RCU)) {
 		touch_atime(&last->link);
 		cond_resched();
-	} else if (atime_needs_update_rcu(&last->link, inode)) {
+	} else if (atime_needs_update(&last->link, inode)) {
 		if (unlikely(unlazy_walk(nd)))
 			return ERR_PTR(-ECHILD);
 		touch_atime(&last->link);
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 6961feda6915..96a4b9fd1f5f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2066,6 +2066,7 @@ enum file_time_flags {
 	S_VERSION = 8,
 };
 
+extern bool atime_needs_update(const struct path *, struct inode *);
 extern void touch_atime(const struct path *);
 static inline void file_accessed(struct file *file)
 {
-- 
2.14.3
