From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH] vfs: update ovl inode before relatime check
Date: Tue, 19 Jul 2016 14:38:41 +0200
Message-ID: <1468931921-26746-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On overlayfs relatime_need_update() needs inode times to be correct on
overlay inode.  But i_mtime and i_ctime are updated by filesystem code on
underlying inode only, so they will be out-of-date on the overlay inode.

This patch copies the times from the underlying inode if needed.  This
can't be done if called from RCU lookup (link following) but link m/ctime
are not updated by fs, so this is all right.

This patch doesn't change functionality for anything but overlayfs.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/inode.c | 38 ++++++++++++++++++++++++++++++++------
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 4ccbc21b30ce..6a2d447c8775 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1534,16 +1534,36 @@ sector_t bmap(struct inode *inode, sector_t block)
 EXPORT_SYMBOL(bmap);
 
 /*
+ * Update times in overlayed inode from underlying real inode
+ */
+static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
+			       bool rcu)
+{
+	if (!rcu) {
+		struct inode *realinode = d_real_inode(dentry);
+
+		if (unlikely(inode != realinode)) {
+			inode->i_mtime = realinode->i_mtime;
+			inode->i_ctime = realinode->i_ctime;
+			WARN_ON_ONCE(!timespec_equal(&inode->i_atime,
+						     &realinode->i_atime));
+		}
+	}
+}
+
+/*
  * With relative atime, only update atime if the previous atime is
  * earlier than either the ctime or mtime or if at least a day has
  * passed since the last atime update.
  */
-static int relatime_need_update(struct vfsmount *mnt, struct inode *inode,
-			     struct timespec now)
+static int relatime_need_update(const struct path *path, struct inode *inode,
+				struct timespec now, bool rcu)
 {
 
-	if (!(mnt->mnt_flags & MNT_RELATIME))
+	if (!(path->mnt->mnt_flags & MNT_RELATIME))
 		return 1;
+
+	update_ovl_inode_times(path->dentry, inode, rcu);
 	/*
 	 * Is mtime younger than atime? If yes, update atime:
 	 */
@@ -1610,7 +1630,8 @@ static int update_time(struct inode *inode, struct timespec *time, int flags)
  *	This function automatically handles read only file systems and media,
  *	as well as the "noatime" flag and inode specific "noatime" markers.
  */
-bool atime_needs_update(const struct path *path, struct inode *inode)
+static bool __atime_needs_update(const struct path *path, struct inode *inode,
+				 bool rcu)
 {
 	struct vfsmount *mnt = path->mnt;
 	struct timespec now;
@@ -1629,7 +1650,7 @@ bool atime_needs_update(const struct path *path, struct inode *inode)
 
 	now = current_fs_time(inode->i_sb);
 
-	if (!relatime_need_update(mnt, inode, now))
+	if (!relatime_need_update(path, inode, now, rcu))
 		return false;
 
 	if (timespec_equal(&inode->i_atime, &now))
@@ -1638,13 +1659,18 @@ bool atime_needs_update(const struct path *path, struct inode *inode)
 	return true;
 }
 
+bool atime_needs_update(const struct path *path, struct inode *inode)
+{
+	return __atime_needs_update(path, inode, true);
+}
+
 void touch_atime(const struct path *path)
 {
 	struct vfsmount *mnt = path->mnt;
 	struct inode *inode = d_inode(path->dentry);
 	struct timespec now;
 
-	if (!atime_needs_update(path, inode))
+	if (!__atime_needs_update(path, inode, false))
 		return;
 
 	if (!sb_start_write_trylock(inode->i_sb))
-- 
2.5.5
