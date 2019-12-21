Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH] ovl: use ovl_inode_lock in ovl_llseek()
Date: Sat, 21 Dec 2019 18:52:43 +0200
Message-Id: <20191221165243.13026-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chengguang Xu <cgxu519@mykernel.net>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

In ovl_llseek() we use the overlay inode rwsem to protect against
concurrent modifications to real file f_pos, because we copy the overlay
file f_pos to/from the real file f_pos.

This caused a lockdep warning of locking order violation when the
ovl_llseek() operation was called on a lower nested overlay layer while
the upper layer fs sb_writers is held (with patch improving copy-up
efficiency for big sparse file).

Use the internal ovl_inode_lock() instead of the overlay inode rwsem
in those cases. It is meant to be used for protecting against concurrent
changes to overlay inode internal state changes.

The locking order rules are documented to explain this case.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---

Miklos,

>From all the potential cases to replace inode_lock with ovl_inode_lock,
this is the only one left with justification.

ovl_write_iter() and ovl_ioctl_set_flags() will require more changes and
they cannot be called on a lower overlay.

ovl_dir_llseek() needs to use the same lock used by ovl_iterate() when
modifying realfile->f_pos (i_rwsem).

ovl_dir_fsync() could use ovl_inode_lock insead of i_rwsem for
od->upperfile test&set, but there is no strong justification to make
that change now.

Thanks,
Amir.

 fs/overlayfs/file.c  |  4 ++--
 fs/overlayfs/inode.c | 21 +++++++++++++++++++++
 2 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index e235a635d9ec..859efeaaefab 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -171,7 +171,7 @@ static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
 	 * limitations that are more strict than ->s_maxbytes for specific
 	 * files, so we use the real file to perform seeks.
 	 */
-	inode_lock(inode);
+	ovl_inode_lock(inode);
 	real.file->f_pos = file->f_pos;
 
 	old_cred = ovl_override_creds(inode->i_sb);
@@ -179,7 +179,7 @@ static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
 	revert_creds(old_cred);
 
 	file->f_pos = real.file->f_pos;
-	inode_unlock(inode);
+	ovl_inode_unlock(inode);
 
 	fdput(real);
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index b045cf1826fc..481a19965dd1 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -527,6 +527,27 @@ static const struct address_space_operations ovl_aops = {
  * [...] &ovl_i_mutex_dir_key[depth]   (stack_depth=2)
  * [...] &ovl_i_mutex_dir_key[depth]#2 (stack_depth=1)
  * [...] &type->i_mutex_dir_key        (stack_depth=0)
+ *
+ * Locking order w.r.t ovl_want_write() is important for nested overlayfs.
+ *
+ * This chain is valid:
+ * - inode->i_rwsem			(inode_lock[2])
+ * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
+ * - OVL_I(inode)->lock			(ovl_inode_lock[2])
+ * - OVL_I(lowerinode)->lock		(ovl_inode_lock[1])
+ *
+ * And this chain is valid:
+ * - inode->i_rwsem			(inode_lock[2])
+ * - OVL_I(inode)->lock			(ovl_inode_lock[2])
+ * - lowerinode->i_rwsem		(inode_lock[1])
+ * - OVL_I(lowerinode)->lock		(ovl_inode_lock[1])
+ *
+ * But lowerinode->i_rwsem SHOULD NOT be acquired while ovl_want_write() is
+ * held, because it is in reverse order of the non-nested case using the same
+ * upper fs:
+ * - inode->i_rwsem			(inode_lock[1])
+ * - upper_mnt->mnt_sb->s_writers	(ovl_want_write[0])
+ * - OVL_I(inode)->lock			(ovl_inode_lock[1])
  */
 #define OVL_MAX_NESTING FILESYSTEM_MAX_STACK_DEPTH
 
-- 
2.17.1
