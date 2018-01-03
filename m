From: Amir Goldstein <amir73il@gmail.com>
Subject: [RFC][PATCH 1/2] vfs: update overlay inode times on write
Date: Wed,  3 Jan 2018 17:11:43 +0200
Message-ID: <1514992304-8021-2-git-send-email-amir73il@gmail.com>
References: <1514992304-8021-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1514992304-8021-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>, "J . Bruce Fields" <bfields@fieldses.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Currently with overlayfs, the real upper inode's i_mtime is updated on
write, but not overlay vfs inode. The vfs inode's i_mtime is used by nfsd
to check if nfs client cache is stale, so updating the overlay vfs inode
i_mtime on write is required for overlayfs NFS export support.

The non uptodate mtime issue was found and verified with the
nfstest_posix test when run over NFS exported overlayfs:

 $ nfstest_posix --runtest=write
 ...
 FAIL: write - file st_mtime should be updated

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/inode.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/inode.c b/fs/inode.c
index 03102d6ef044..a252256f4e51 100644
--- a/fs/inode.c
+++ b/fs/inode.c
@@ -1567,8 +1567,7 @@ EXPORT_SYMBOL(bmap);
 /*
  * Update times in overlayed inode from underlying real inode
  */
-static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
-			       bool rcu)
+static void update_ovl_d_inode_times(struct dentry *dentry, bool rcu)
 {
 	struct dentry *upperdentry;
 
@@ -1585,6 +1584,7 @@ static void update_ovl_inode_times(struct dentry *dentry, struct inode *inode,
 	 * stale mtime/ctime.
 	 */
 	if (upperdentry) {
+		struct inode *inode = d_inode(dentry);
 		struct inode *realinode = d_inode(upperdentry);
 
 		if ((!timespec_equal(&inode->i_mtime, &realinode->i_mtime) ||
@@ -1607,7 +1607,8 @@ static int relatime_need_update(const struct path *path, struct inode *inode,
 	if (!(path->mnt->mnt_flags & MNT_RELATIME))
 		return 1;
 
-	update_ovl_inode_times(path->dentry, inode, rcu);
+	update_ovl_d_inode_times(path->dentry, rcu);
+
 	/*
 	 * Is mtime younger than atime? If yes, update atime:
 	 */
@@ -1876,6 +1877,8 @@ int file_update_time(struct file *file)
 	ret = update_time(inode, &now, sync_it);
 	__mnt_drop_write_file(file);
 
+	update_ovl_d_inode_times(file->f_path.dentry, false);
+
 	return ret;
 }
 EXPORT_SYMBOL(file_update_time);
-- 
2.7.4
