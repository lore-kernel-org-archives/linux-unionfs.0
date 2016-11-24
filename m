From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 4/7] ovl: add infrastructure for intercepting file ops
Date: Thu, 24 Nov 2016 11:55:41 +0100
Message-ID: <1479984944-1017-6-git-send-email-mszeredi@redhat.com>
References: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Overlayfs needs to intercept a few file operations in order to properly
handle the following corner case:

 - file X is in overlayfs;

 - X resides on a lower (read-only) layer
	the lower file is L;

 - X is opened with O_RDONLY ->
	L is opened -> 'rofd';

 - X is opened with O_WRONLY ->
	this results in L being copied up to the upper layer file U
	U is opened -> 'rwfd';

 - write to 'rwfd' modifying U;

 - read from 'rofd' gets data from unmodified L;

While this is a rare occurrence, it has been known to cause problems.  To
prevent such inconsistencies, allow intercepting read operations and fix
them up in the unlikely case that it's needed.

This patch adds an ovl_fops structure that is going to contain the pieces
necessary for intercepting file operations:

 a) a new file_operations structure, based on the original but changing
    those operations that need to be intercepted;

 b) a pointer to the origin f_op.  Intercepted operations will normally
    just call the original, unless the file was copied up;

 c) a hash table entry to hook this up for reuse in subsequent opens.

The hash table is small (32 buckets) since there will only be a few
different file operations used (basically the number of different
filesystems used as lower layer of overlay).  The key to the has table is
the original fops pointer.

Insertion is done under a global mutex.  There will only be one insertion
event for each unique underlying file_operations structure, so this is
going to be rare.

The hash table is accessed using rcu, so this will add minimal overhead to
opens.  The override fops are removed only at module exit time, so we don't
even have to be worry about read-side rcu locking.

There are a few assumption this scheme makes about file operation
structures supplied by filesystems:

 1) the lifetime of the structures is equal to the lifetime of the
    filesystem module; ensure this by holding a ref to the
    sb->s_type->owner (normal filesystems don't fill in f_ops->owner).
    This means that once a filesystem has been used as lower layer of
    overlayfs its module cannot be removed until the overlay module itself
    is removed.  I don't believe this will be a problem.

 2) Filesystems should not make use of f_op in any way except possibly
    replacing it in ->open.  Overlayfs itself breaks this assumption, but
    recursion is handled by ->d_real so this is not an issue.  Add a
    ->magic field to the override fops structure to verify that the
    filesystem didn't mess with file->f_op.

Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
---
 fs/overlayfs/inode.c     | 144 ++++++++++++++++++++++++++++++++++++++++++++++-
 fs/overlayfs/overlayfs.h |   2 +
 fs/overlayfs/super.c     |   1 +
 3 files changed, 146 insertions(+), 1 deletion(-)

diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index 1981a5514f51..3e26615c4697 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -12,6 +12,7 @@
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
 #include <linux/module.h>
+#include <linux/hashtable.h>
 #include "overlayfs.h"
 
 static int ovl_copy_up_truncate(struct dentry *dentry)
@@ -334,16 +335,157 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.update_time	= ovl_update_time,
 };
 
+static DEFINE_READ_MOSTLY_HASHTABLE(ovl_fops_htable, 5);
+static DEFINE_MUTEX(ovl_fops_mutex);
+
+#define OVL_FOPS_MAGIC 0x73706f462a6c764f
+
+struct ovl_fops {
+	struct module *owner;
+	struct file_operations fops;
+	u64 magic;
+	const struct file_operations *orig_fops;
+	struct hlist_node entry;
+};
+
+void ovl_cleanup_fops_htable(void)
+{
+	int bkt;
+	struct hlist_node *tmp;
+	struct ovl_fops *ofop;
+
+	hash_for_each_safe(ovl_fops_htable, bkt, tmp, ofop, entry) {
+		module_put(ofop->owner);
+		fops_put(ofop->orig_fops);
+		kfree(ofop);
+	}
+}
+
+#define OVL_CALL_REAL_FOP(file, call) \
+	({ struct ovl_fops *__ofop =					 \
+			container_of(file->f_op, struct ovl_fops, fops); \
+	   WARN_ON(__ofop->magic != OVL_FOPS_MAGIC) ? -EIO :		 \
+		   __ofop->orig_fops->call;				 \
+	})
+
+static struct ovl_fops *ovl_fops_find(const struct file_operations *orig)
+{
+	struct ovl_fops *ofop;
+
+	hash_for_each_possible_rcu(ovl_fops_htable, ofop, entry, (long) orig) {
+		if (ofop->orig_fops == orig)
+			return ofop;
+	}
+	return NULL;
+}
+
+static struct ovl_fops *ovl_fops_get(struct file *file)
+{
+	const struct file_operations *orig = file->f_op;
+	struct ovl_fops *ofop = ovl_fops_find(orig);
+
+	if (likely(ofop))
+		return ofop;
+
+	mutex_lock(&ovl_fops_mutex);
+	ofop = ovl_fops_find(orig);
+	if (ofop)
+		goto out_unlock;
+
+	ofop = kzalloc(sizeof(struct ovl_fops), GFP_KERNEL);
+	if (ofop) {
+		/*
+		 * FS don't usually fill in fops->owner, so grab ref to
+		 * filesystem's module as well.
+		 */
+		ofop->owner = file_inode(file)->i_sb->s_type->owner;
+		__module_get(ofop->owner);
+
+		ofop->magic = OVL_FOPS_MAGIC;
+		ofop->orig_fops = fops_get(orig);
+
+		/* These will need to be intercepted: */
+		ofop->fops.read_iter = orig->read_iter;
+		ofop->fops.mmap = orig->mmap;
+		ofop->fops.fsync = orig->fsync;
+
+		/*
+		 * These should be intercepted, but they are very unlikely to be
+		 * a problem in practice.  Leave them alone for now.
+		 */
+		ofop->fops.copy_file_range = orig->copy_file_range;
+		ofop->fops.clone_file_range = orig->clone_file_range;
+		ofop->fops.dedupe_file_range = orig->dedupe_file_range;
+
+		/* Don't intercept these: */
+		ofop->fops.llseek = orig->llseek;
+		ofop->fops.unlocked_ioctl = orig->unlocked_ioctl;
+		ofop->fops.compat_ioctl = orig->compat_ioctl;
+		ofop->fops.flush = orig->flush;
+		ofop->fops.release = orig->release;
+		ofop->fops.get_unmapped_area = orig->get_unmapped_area;
+		ofop->fops.check_flags = orig->check_flags;
+
+		/* splice_read should be generic_file_splice_read */
+		WARN_ON(orig->splice_read != generic_file_splice_read);
+		ofop->fops.splice_read = generic_file_splice_read;
+
+		/* These make no sense for "normal" files: */
+		WARN_ON(orig->read);
+		WARN_ON(orig->iterate);
+		WARN_ON(orig->iterate_shared);
+		WARN_ON(orig->poll);
+		WARN_ON(orig->fasync);
+		WARN_ON(orig->show_fdinfo);
+
+		/*
+		 * Don't add those which are unneeded for O_RDONLY:
+		 *
+		 *  write
+		 *  write_iter
+		 *  splice_write
+		 *  sendpage
+		 *  fallocate
+		 *
+		 * Locking operations are already intercepted by vfs for ovl:
+		 *
+		 *  lock
+		 *  flock
+		 *  setlease
+		 */
+
+		hash_add_rcu(ovl_fops_htable, &ofop->entry, (long) orig);
+	}
+out_unlock:
+	mutex_unlock(&ovl_fops_mutex);
+
+	return ofop;
+}
+
 static int ovl_open(struct inode *inode, struct file *file)
 {
 	int ret = 0;
+	struct ovl_fops *ofop;
+	bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
 
 	/* Want fops from real inode */
 	replace_fops(file, inode->i_fop);
 	if (file->f_op->open)
 		ret = file->f_op->open(inode, file);
 
-	return ret;
+	/* No need to override fops for upper */
+	if (isupper || ret)
+		return ret;
+
+	ofop = ovl_fops_get(file);
+	if (unlikely(!ofop)) {
+		if (file->f_op->release)
+			file->f_op->release(inode, file);
+		return -ENOMEM;
+	}
+	replace_fops(file, &ofop->fops);
+
+	return 0;
 }
 
 static const struct file_operations ovl_file_operations = {
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index bdda37fa3f67..abc00f4ac247 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -209,6 +209,8 @@ static inline void ovl_copyattr(struct inode *from, struct inode *to)
 	to->i_ctime = from->i_ctime;
 }
 
+void ovl_cleanup_fops_htable(void);
+
 /* dir.c */
 extern const struct inode_operations ovl_dir_inode_operations;
 struct dentry *ovl_lookup_temp(struct dentry *workdir, struct dentry *dentry);
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index e847cc354599..89cbb11eef58 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -960,6 +960,7 @@ static int __init ovl_init(void)
 static void __exit ovl_exit(void)
 {
 	unregister_filesystem(&ovl_fs_type);
+	ovl_cleanup_fops_htable();
 }
 
 module_init(ovl_init);
-- 
2.5.5

