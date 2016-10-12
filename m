From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [POC/RFC PATCH] overlayfs: fix data inconsistency at copy up
Date: Wed, 12 Oct 2016 15:33:26 +0200
Message-ID: <20161012133326.GD31239@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Jeremy Eder <jeder@redhat.com>, David Howells <dhowells@redhat.com>, Ratna Bolla <rbolla@portworx.com>, Gou Rao <grao@portworx.com>, Vinod Jayaraman <jv@portworx.com>, Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, Dave Chinner <david@fromorbit.com>
List-Id: linux-unionfs@vger.kernel.org

This is a proof of concept patch to fix the following.

/ovl is in overlay mount and /ovl/foo exists on the lower layer only.

 rofd = open("/ovl/foo", O_RDONLY);
 rwfd = open("/ovl/foo", O_WRONLY); /* this causes copy up */
 write(rwfd, "bar", 3);
 read(rofd, buf, 3); 
 assert(memcmp(buf, "bar", 3) == 0);

Similar problem exists with an MAP_SHARED mmap created from rofd.

While this has only caused few problems (yum/dnf failure is the only one I know
of) and easily worked around in userspace, many see it as a proof that overlayfs
can never be a proper "POSIX" filesystem.

To quell those worries, here's a simple patch that should address the above.

The only VFS change is that f_op is initialized from f_path.dentry->d_inode
instead of file_inode(filp) in open.  The effect of this is that overlayfs can
intercept open and other file operations, while the file still effectively
belongs to the underlying fs.

The patch does not give up on the nice properties of overlayfs, like sharing the
page cache with the underlying files.  It does cause copy up in one case where
previously there wasn't one and that's the O_RDONLY/MAP_SHARED case.  I haven't
done much research into this, but running some tests in chroot didn't trigger
this.

Comments, testing are welcome.

Thanks,
Miklos

---
 fs/internal.h            |   1 -
 fs/open.c                |   2 +-
 fs/overlayfs/dir.c       |   2 +-
 fs/overlayfs/inode.c     | 175 +++++++++++++++++++++++++++++++++++++++++++----
 fs/overlayfs/overlayfs.h |   2 +-
 fs/overlayfs/super.c     |   7 +-
 include/linux/fs.h       |   1 +
 7 files changed, 169 insertions(+), 21 deletions(-)

diff --git a/fs/internal.h b/fs/internal.h
index f4da3341b4a3..361ba1c12698 100644
--- a/fs/internal.h
+++ b/fs/internal.h
@@ -112,7 +112,6 @@ extern long do_handle_open(int mountdirfd,
 			   struct file_handle __user *ufh, int open_flag);
 extern int open_check_o_direct(struct file *f);
 extern int vfs_open(const struct path *, struct file *, const struct cred *);
-extern struct file *filp_clone_open(struct file *);
 
 /*
  * inode.c
diff --git a/fs/open.c b/fs/open.c
index a7719cfb7257..e21f1a6f77b7 100644
--- a/fs/open.c
+++ b/fs/open.c
@@ -728,7 +728,7 @@ static int do_dentry_open(struct file *f,
 	if (S_ISREG(inode->i_mode) || S_ISDIR(inode->i_mode))
 		f->f_mode |= FMODE_ATOMIC_POS;
 
-	f->f_op = fops_get(inode->i_fop);
+	f->f_op = fops_get(f->f_path.dentry->d_inode->i_fop);
 	if (unlikely(WARN_ON(!f->f_op))) {
 		error = -ENODEV;
 		goto cleanup_all;
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 5f90ddf778ba..1ea511be6e37 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -534,7 +534,7 @@ static int ovl_create_object(struct dentry *dentry, int mode, dev_t rdev,
 		goto out;
 
 	err = -ENOMEM;
-	inode = ovl_new_inode(dentry->d_sb, mode);
+	inode = ovl_new_inode(dentry->d_sb, mode, rdev);
 	if (!inode)
 		goto out_drop_write;
 
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index c18d6a4ff456..744c8eb7e947 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -11,6 +11,9 @@
 #include <linux/slab.h>
 #include <linux/xattr.h>
 #include <linux/posix_acl.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/file.h>
 #include "overlayfs.h"
 
 static int ovl_copy_up_truncate(struct dentry *dentry)
@@ -381,7 +384,154 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.update_time	= ovl_update_time,
 };
 
-static void ovl_fill_inode(struct inode *inode, umode_t mode)
+static const struct file_operations ovl_file_operations;
+
+static const struct file_operations *ovl_real_fop(struct file *file)
+{
+	return file_inode(file)->i_fop;
+}
+
+static int ovl_open(struct inode *realinode, struct file *file)
+{
+	int ret = 0;
+	const struct file_operations *fop = ovl_real_fop(file);
+	bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
+
+	/* Don't intercept upper file operations */
+	if (isupper)
+		replace_fops(file, fop);
+
+	if (fop->open)
+		ret = fop->open(realinode, file);
+
+	if (!isupper && WARN_ON(file->f_op != &ovl_file_operations)) {
+		if (fop->release)
+			fop->release(realinode, file);
+		return -EINVAL;
+	}
+
+	return ret;
+}
+
+static int ovl_release(struct inode *realinode, struct file *file)
+{
+	const struct file_operations *fop = ovl_real_fop(file);
+
+	if (fop->release)
+		return fop->release(realinode, file);
+
+	return 0;
+}
+
+static ssize_t ovl_read_iter(struct kiocb *iocb, struct iov_iter *to)
+{
+	struct file *file = iocb->ki_filp;
+	bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
+	ssize_t ret = -EINVAL;
+
+	if (likely(!isupper)) {
+		const struct file_operations *fop = ovl_real_fop(file);
+
+		if (likely(fop->read_iter))
+			ret = fop->read_iter(iocb, to);
+	} else {
+		struct file *upperfile = filp_clone_open(file);
+
+		if (IS_ERR(upperfile)) {
+			ret = PTR_ERR(upperfile);
+		} else {
+			ret = vfs_iter_read(upperfile, to, &iocb->ki_pos);
+			fput(upperfile);
+		}
+	}
+
+	return ret;
+}
+
+static loff_t ovl_llseek(struct file *file, loff_t offset, int whence)
+{
+	const struct file_operations *fop = ovl_real_fop(file);
+
+	if (fop->llseek)
+		return fop->llseek(file, offset, whence);
+
+	return -EINVAL;
+}
+
+static int ovl_mmap(struct file *file, struct vm_area_struct *vma)
+{
+	const struct file_operations *fop = ovl_real_fop(file);
+	bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
+	int err;
+
+	/*
+	 * Treat MAP_SHARED as hint about future writes to the file (through
+	 * another file descriptor).  Caller might not have had such an intent,
+	 * but we hope MAP_PRIVATE will be used in most such cases.
+	 *
+	 * If we don't copy up now and the file is modified, it becomes really
+	 * difficult to change the mapping to match that of the file's content
+	 * later.
+	 */
+	if (unlikely(isupper || vma->vm_flags & VM_MAYSHARE)) {
+		if (!isupper) {
+			err = ovl_copy_up(file->f_path.dentry);
+			if (err)
+				goto out;
+		}
+
+		file = filp_clone_open(file);
+		err = PTR_ERR(file);
+		if (IS_ERR(file))
+			goto out;
+
+		fput(vma->vm_file);
+		/* transfer ref: */
+		vma->vm_file = file;
+		fop = file->f_op;
+	}
+	err = -EINVAL;
+	if (fop->mmap)
+		err = fop->mmap(file, vma);
+out:
+	return err;
+}
+
+static int ovl_fsync(struct file *file, loff_t start, loff_t end,
+		     int datasync)
+{
+	bool isupper = OVL_TYPE_UPPER(ovl_path_type(file->f_path.dentry));
+	int ret = -EINVAL;
+
+	if (likely(!isupper)) {
+		const struct file_operations *fop = ovl_real_fop(file);
+
+		if (likely(fop->fsync))
+		       ret = fop->fsync(file, start, end, datasync);
+	} else {
+		struct file *upperfile = filp_clone_open(file);
+
+		if (IS_ERR(upperfile)) {
+			ret = PTR_ERR(upperfile);
+		} else {
+			ret = vfs_fsync_range(upperfile, start, end, datasync);
+			fput(upperfile);
+		}
+	}
+
+	return ret;
+}
+
+static const struct file_operations ovl_file_operations = {
+	.open		= ovl_open,
+	.release	= ovl_release,
+	.read_iter	= ovl_read_iter,
+	.llseek		= ovl_llseek,
+	.mmap		= ovl_mmap,
+	.fsync		= ovl_fsync,
+};
+
+static void ovl_fill_inode(struct inode *inode, umode_t mode, dev_t rdev)
 {
 	inode->i_ino = get_next_ino();
 	inode->i_mode = mode;
@@ -390,8 +540,12 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode)
 	inode->i_acl = inode->i_default_acl = ACL_DONT_CACHE;
 #endif
 
-	mode &= S_IFMT;
-	switch (mode) {
+	switch (mode & S_IFMT) {
+	case S_IFREG:
+		inode->i_op = &ovl_file_inode_operations;
+		inode->i_fop = &ovl_file_operations;
+		break;
+
 	case S_IFDIR:
 		inode->i_op = &ovl_dir_inode_operations;
 		inode->i_fop = &ovl_dir_operations;
@@ -402,26 +556,19 @@ static void ovl_fill_inode(struct inode *inode, umode_t mode)
 		break;
 
 	default:
-		WARN(1, "illegal file type: %i\n", mode);
-		/* Fall through */
-
-	case S_IFREG:
-	case S_IFSOCK:
-	case S_IFBLK:
-	case S_IFCHR:
-	case S_IFIFO:
 		inode->i_op = &ovl_file_inode_operations;
+		init_special_inode(inode, mode, rdev);
 		break;
 	}
 }
 
-struct inode *ovl_new_inode(struct super_block *sb, umode_t mode)
+struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev)
 {
 	struct inode *inode;
 
 	inode = new_inode(sb);
 	if (inode)
-		ovl_fill_inode(inode, mode);
+		ovl_fill_inode(inode, mode, rdev);
 
 	return inode;
 }
@@ -445,7 +592,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode)
 	inode = iget5_locked(sb, (unsigned long) realinode,
 			     ovl_inode_test, ovl_inode_set, realinode);
 	if (inode && inode->i_state & I_NEW) {
-		ovl_fill_inode(inode, realinode->i_mode);
+		ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
 		set_nlink(inode, realinode->i_nlink);
 		unlock_new_inode(inode);
 	}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index e218e741cb99..95d0d86c2d54 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -195,7 +195,7 @@ int ovl_open_maybe_copy_up(struct dentry *dentry, unsigned int file_flags);
 int ovl_update_time(struct inode *inode, struct timespec *ts, int flags);
 bool ovl_is_private_xattr(const char *name);
 
-struct inode *ovl_new_inode(struct super_block *sb, umode_t mode);
+struct inode *ovl_new_inode(struct super_block *sb, umode_t mode, dev_t rdev);
 struct inode *ovl_get_inode(struct super_block *sb, struct inode *realinode);
 static inline void ovl_copyattr(struct inode *from, struct inode *to)
 {
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index 7e3f0127fc1a..daed68d13467 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -305,7 +305,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
 {
 	struct dentry *real;
 
-	if (d_is_dir(dentry)) {
+	if (!d_is_reg(dentry)) {
 		if (!inode || inode == d_inode(dentry))
 			return dentry;
 		goto bug;
@@ -579,7 +579,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
 		if (upperdentry && !d_is_dir(upperdentry)) {
 			inode = ovl_get_inode(dentry->d_sb, realinode);
 		} else {
-			inode = ovl_new_inode(dentry->d_sb, realinode->i_mode);
+			inode = ovl_new_inode(dentry->d_sb, realinode->i_mode,
+					      realinode->i_rdev);
 			if (inode)
 				ovl_inode_init(inode, realinode, !!upperdentry);
 		}
@@ -1292,7 +1293,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!oe)
 		goto out_put_cred;
 
-	root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR));
+	root_dentry = d_make_root(ovl_new_inode(sb, S_IFDIR, 0));
 	if (!root_dentry)
 		goto out_free_oe;
 
diff --git a/include/linux/fs.h b/include/linux/fs.h
index bc65d5918140..cc7d1203b846 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -2342,6 +2342,7 @@ extern struct file *filp_open(const char *, int, umode_t);
 extern struct file *file_open_root(struct dentry *, struct vfsmount *,
 				   const char *, int, umode_t);
 extern struct file * dentry_open(const struct path *, int, const struct cred *);
+extern struct file *filp_clone_open(struct file *);
 extern int filp_close(struct file *, fl_owner_t id);
 
 extern struct filename *getname_flags(const char __user *, int, int *);
