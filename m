From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATH 1/4] vfs: reinterpret sillyrename flag as delete lock
Date: Fri, 11 Nov 2016 00:44:40 +0200
Message-ID: <1478817883-27662-2-git-send-email-amir73il@gmail.com>
References: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1478817883-27662-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Konstantin Khlebnikov <koct9i@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

The dentry flag DCACHE_NFSFS_RENAMED indicates the the entry
was sillyrenamed, as do some of the comment above may_delete().

It is better if the flag name indicates its true meaning instead
of refering to nfs internal implementation. In fact, afs was using
the flag with no relation to nfs silly rename.

Re-brand the flag as DCACHE_DELETE_LOCK and modify places
in the code that check/set it to use helpers cant_delete()
and dont_delete().

The old flag DCACHE_NFSFS_RENAMED remains and is being used only
in places really related to the nfs silly rename implementation.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/afs/dir.c           |  6 ++----
 fs/btrfs/ioctl.c       |  5 ++---
 fs/namei.c             |  5 ++---
 include/linux/dcache.h | 13 +++++++++++++
 4 files changed, 19 insertions(+), 10 deletions(-)

diff --git a/fs/afs/dir.c b/fs/afs/dir.c
index 51a241e..a0d79a7 100644
--- a/fs/afs/dir.c
+++ b/fs/afs/dir.c
@@ -678,9 +678,7 @@ static int afs_d_revalidate(struct dentry *dentry, unsigned int flags)
 
 	/* the dirent, if it exists, now points to a different vnode */
 not_found:
-	spin_lock(&dentry->d_lock);
-	dentry->d_flags |= DCACHE_NFSFS_RENAMED;
-	spin_unlock(&dentry->d_lock);
+	dont_delete(dentry);
 
 out_bad:
 	_debug("dropping dentry %pd2", dentry);
@@ -701,7 +699,7 @@ static int afs_d_delete(const struct dentry *dentry)
 {
 	_enter("%pd", dentry);
 
-	if (dentry->d_flags & DCACHE_NFSFS_RENAMED)
+	if (cant_delete(dentry))
 		goto zap;
 
 	if (d_really_is_positive(dentry) &&
diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 7acbd2c..46048e54 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -785,8 +785,7 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
  *  7. If we were asked to remove a directory and victim isn't one - ENOTDIR.
  *  8. If we were asked to remove a non-directory and victim isn't one - EISDIR.
  *  9. We can't remove a root or mountpoint.
- * 10. We don't allow removal of NFS sillyrenamed files; it's handled by
- *     nfs_async_unlink().
+ * 10. We don't allow removal of delete locked files.
  */
 
 static int btrfs_may_delete(struct inode *dir, struct dentry *victim, int isdir)
@@ -816,7 +815,7 @@ static int btrfs_may_delete(struct inode *dir, struct dentry *victim, int isdir)
 		return -EISDIR;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
-	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
+	if (cant_delete(victim))
 		return -EBUSY;
 	return 0;
 }
diff --git a/fs/namei.c b/fs/namei.c
index 31d04d9..6040d1e 100644
--- a/fs/namei.c
+++ b/fs/namei.c
@@ -2762,8 +2762,7 @@ EXPORT_SYMBOL(__check_sticky);
  *  8. If we were asked to remove a directory and victim isn't one - ENOTDIR.
  *  9. If we were asked to remove a non-directory and victim isn't one - EISDIR.
  * 10. We can't remove a root or mountpoint.
- * 11. We don't allow removal of NFS sillyrenamed files; it's handled by
- *     nfs_async_unlink().
+ * 11. We don't allow removal of delete locked files.
  */
 static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 {
@@ -2795,7 +2794,7 @@ static int may_delete(struct inode *dir, struct dentry *victim, bool isdir)
 		return -EISDIR;
 	if (IS_DEADDIR(dir))
 		return -ENOENT;
-	if (victim->d_flags & DCACHE_NFSFS_RENAMED)
+	if (cant_delete(victim))
 		return -EBUSY;
 	return 0;
 }
diff --git a/include/linux/dcache.h b/include/linux/dcache.h
index 5beed7b..94cd40c 100644
--- a/include/linux/dcache.h
+++ b/include/linux/dcache.h
@@ -180,6 +180,7 @@ struct dentry_operations {
 #define DCACHE_OP_WEAK_REVALIDATE	0x00000800
 
 #define DCACHE_NFSFS_RENAMED		0x00001000
+#define DCACHE_DELETE_LOCK		0x00001000 /* May not delete/rename */
      /* this dentry has been "silly renamed" and has to be deleted on the last
       * dput() */
 #define DCACHE_COOKIE			0x00002000 /* For use by dcookie subsystem */
@@ -350,6 +351,18 @@ static inline void dont_mount(struct dentry *dentry)
 	spin_unlock(&dentry->d_lock);
 }
 
+static inline int cant_delete(const struct dentry *dentry)
+{
+	return (dentry->d_flags & DCACHE_DELETE_LOCK);
+}
+
+static inline void dont_delete(struct dentry *dentry)
+{
+	spin_lock(&dentry->d_lock);
+	dentry->d_flags |= DCACHE_DELETE_LOCK;
+	spin_unlock(&dentry->d_lock);
+}
+
 extern void __d_lookup_done(struct dentry *);
 
 static inline int d_in_lookup(struct dentry *dentry)
-- 
2.7.4

