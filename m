Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 4/4] ovl: add support for SHUTDOWN ioctl
Date: Mon, 15 Jul 2019 16:38:39 +0300
Message-Id: <20190715133839.9878-5-amir73il@gmail.com>
In-Reply-To: <20190715133839.9878-1-amir73il@gmail.com>
References: <20190715133839.9878-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Keep accounting of active users accessing underlying layers.
On SHUTDOWN ioctl, deny new users from accessing underlying layers.

After SHUTDOWN ioctl, when active users count drops to zero, we release
the inuse exclusive locks on upperdir and workdir, because no user can
access those dirs from this instance anymore.

This will allow container runtimes to issue the SHUTDOWN ioctl before
unmounting overlayfs to mitigate overlayfs mount failures that result
from mount leaks of old overlayfs mounts.

Signed-off-by: Amir Goldstein <amir73il@gmail.com>
---
 fs/overlayfs/file.c      | 34 ++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h | 10 +++++++-
 fs/overlayfs/ovl_entry.h |  7 ++++++
 fs/overlayfs/super.c     |  9 +++-----
 fs/overlayfs/util.c      | 49 ++++++++++++++++++++++++++++++++++++++++
 5 files changed, 102 insertions(+), 7 deletions(-)

diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
index dbcf7549068d..2668a48046ef 100644
--- a/fs/overlayfs/file.c
+++ b/fs/overlayfs/file.c
@@ -530,6 +530,33 @@ static long ovl_ioctl_set_fsxflags(struct file *file, unsigned int cmd,
 				   ovl_fsxflags_to_fsflags(fa.fsx_xflags));
 }
 
+static int ovl_ioctl_shutdown(struct super_block *sb, unsigned long arg)
+{
+	struct ovl_fs *ofs = sb->s_fs_info;
+	__u32 flags;
+
+	if (!capable(CAP_SYS_ADMIN))
+		return -EPERM;
+
+	if (get_user(flags, (__u32 __user *)arg))
+		return -EFAULT;
+
+	if (flags != OVL_SHUTDOWN_FLAGS_NOSYNC)
+		return -EINVAL;
+
+	down_write(&sb->s_umount);
+
+	if (!ofs->goingdown) {
+		pr_info("overlayfs: shutdown requested\n");
+		ofs->goingdown = true;
+		ovl_drop_active(ofs);
+	}
+
+	up_write(&sb->s_umount);
+
+	return 0;
+}
+
 long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 {
 	long ret;
@@ -548,6 +575,10 @@ long ovl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		ret = ovl_ioctl_set_fsxflags(file, cmd, arg);
 		break;
 
+	case OVL_IOC_SHUTDOWN:
+		ret = ovl_ioctl_shutdown(file_inode(file)->i_sb, arg);
+		break;
+
 	default:
 		ret = -ENOTTY;
 	}
@@ -567,6 +598,9 @@ long ovl_compat_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 		cmd = FS_IOC_SETFLAGS;
 		break;
 
+	case OVL_IOC_SHUTDOWN:
+		break;
+
 	default:
 		return -ENOIOCTLCMD;
 	}
diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
index 72f0d84d2d4b..8f282c722b00 100644
--- a/fs/overlayfs/overlayfs.h
+++ b/fs/overlayfs/overlayfs.h
@@ -28,6 +28,14 @@ enum ovl_path_type {
 #define OVL_XATTR_UPPER OVL_XATTR_PREFIX "upper"
 #define OVL_XATTR_METACOPY OVL_XATTR_PREFIX "metacopy"
 
+/*
+ * Should be same as XFS_IOC_GOINGDOWN.
+ * We only support the NOSYNC flag.
+ */
+#define OVL_IOC_SHUTDOWN		_IOR('X', 125, __u32)
+#define OVL_SHUTDOWN_FLAGS_NOSYNC	0x2
+
+
 enum ovl_inode_flag {
 	/* Pure upper dir that may contain non pure upper entries */
 	OVL_IMPURE,
@@ -201,6 +209,7 @@ static inline bool ovl_open_flags_need_copy_up(int flags)
 }
 
 /* util.c */
+void ovl_drop_active(struct ovl_fs *ofs);
 int ovl_want_write(struct dentry *dentry);
 void ovl_drop_write(struct dentry *dentry);
 struct dentry *ovl_workdir(struct dentry *dentry);
@@ -301,7 +310,6 @@ static inline void ovl_inode_unlock(struct inode *inode)
 	mutex_unlock(&OVL_I(inode)->lock);
 }
 
-
 /* namei.c */
 int ovl_check_fh_len(struct ovl_fh *fh, int fh_len);
 struct dentry *ovl_decode_real_fh(struct ovl_fh *fh, struct vfsmount *mnt,
diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
index a8279280e88d..5449222621c0 100644
--- a/fs/overlayfs/ovl_entry.h
+++ b/fs/overlayfs/ovl_entry.h
@@ -71,6 +71,13 @@ struct ovl_fs {
 	struct inode *indexdir_trap;
 	/* Inode numbers in all layers do not use the high xino_bits */
 	unsigned int xino_bits;
+	/*
+	 * Number of users currently accessing underlying layers (+1)
+	 * When zero, access to underlying layers is denied.
+	 */
+	atomic_t active;
+	/* Filesystem will shutdown when the last active reference drops */
+	bool goingdown;
 };
 
 /* private information held for every overlayfs dentry */
diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
index afbcb116a7f1..119610bef31a 100644
--- a/fs/overlayfs/super.c
+++ b/fs/overlayfs/super.c
@@ -212,17 +212,14 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 {
 	unsigned i;
 
+	ovl_drop_active(ofs);
 	iput(ofs->workbasedir_trap);
 	iput(ofs->indexdir_trap);
 	iput(ofs->workdir_trap);
 	iput(ofs->upperdir_trap);
 	dput(ofs->indexdir);
 	dput(ofs->workdir);
-	if (ofs->workdir_locked)
-		ovl_inuse_unlock(ofs->workbasedir);
 	dput(ofs->workbasedir);
-	if (ofs->upperdir_locked)
-		ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
 	mntput(ofs->upper_mnt);
 	for (i = 0; i < ofs->numlower; i++) {
 		iput(ofs->lower_layers[i].trap);
@@ -237,8 +234,6 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 	kfree(ofs->config.upperdir);
 	kfree(ofs->config.workdir);
 	kfree(ofs->config.redirect_mode);
-	if (ofs->creator_cred)
-		put_cred(ofs->creator_cred);
 	kfree(ofs);
 }
 
@@ -1570,6 +1565,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
 	if (!ofs)
 		goto out;
 
+	atomic_set(&ofs->active, 1);
+
 	ofs->creator_cred = cred = prepare_creds();
 	if (!cred)
 		goto out_err;
diff --git a/fs/overlayfs/util.c b/fs/overlayfs/util.c
index 146b351a0d84..5e622c00bd82 100644
--- a/fs/overlayfs/util.c
+++ b/fs/overlayfs/util.c
@@ -15,16 +15,58 @@
 #include <linux/ratelimit.h>
 #include "overlayfs.h"
 
+static bool ovl_get_active(struct ovl_fs *ofs)
+{
+	if (!atomic_inc_not_zero(&ofs->active))
+		return false;
+
+	/*
+	 * Not handing out any more active references when filesystem is
+	 * going down. The atomic ops on ofs->active serve as memory barriers
+	 * for the ofs->goingdown test.
+	 */
+	if (!ofs->goingdown)
+		return true;
+
+	ovl_drop_active(ofs);
+	return false;
+}
+
+void ovl_drop_active(struct ovl_fs *ofs)
+{
+	if (atomic_dec_and_test(&ofs->active)) {
+		/*
+		 * No users will ever access underlying layers from this
+		 * instance, so we can release exclusive inuse locks.
+		 */
+		if (ofs->workdir_locked)
+			ovl_inuse_unlock(ofs->workbasedir);
+		if (ofs->upperdir_locked)
+			ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
+		/* "revoke" credentials to access underlying layers */
+		put_cred(ofs->creator_cred);
+		ofs->creator_cred = NULL;
+		if (ofs->goingdown)
+			pr_info("overlayfs: filesystem is shutdown\n");
+	}
+}
+
 int ovl_want_write(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+
+	if (!ovl_get_active(ofs))
+		return -EIO;
+
 	return mnt_want_write(ofs->upper_mnt);
 }
 
 void ovl_drop_write(struct dentry *dentry)
 {
 	struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
+
 	mnt_drop_write(ofs->upper_mnt);
+	ovl_drop_active(ofs);
 }
 
 struct dentry *ovl_workdir(struct dentry *dentry)
@@ -37,6 +79,12 @@ int ovl_override_creds(struct super_block *sb, const struct cred **old_cred)
 {
 	struct ovl_fs *ofs = sb->s_fs_info;
 
+	if (!ovl_get_active(ofs))
+		return -EIO;
+
+	if (WARN_ON_ONCE(!ofs->creator_cred))
+		return -EIO;
+
 	*old_cred = override_creds(ofs->creator_cred);
 	return 0;
 }
@@ -44,6 +92,7 @@ int ovl_override_creds(struct super_block *sb, const struct cred **old_cred)
 void ovl_revert_creds(struct super_block *sb, const struct cred *old_cred)
 {
 	revert_creds(old_cred);
+	ovl_drop_active(sb->s_fs_info);
 }
 
 struct super_block *ovl_same_sb(struct super_block *sb)
-- 
2.17.1
