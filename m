From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [RFC 8/8] xattr: Remove generic xattr handlers
Date: Tue,  3 May 2016 00:45:18 +0200
Message-ID: <1462229118-13123-9-git-send-email-agruenba@redhat.com>
References: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1462229118-13123-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fuse-devel@lists.sourceforge.net, Mimi Zohar <zohar@linux.vnet.ibm.com>, linux-ima-devel@lists.sourceforge.net, linux-security-module@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge.hallyn@canonical.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>
List-Id: linux-unionfs@vger.kernel.org

The generic xattr handlers are now unused; remove them.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/9p/vfs_inode_dotl.c |  9 ---------
 fs/bad_inode.c         |  3 ---
 fs/btrfs/inode.c       | 12 -----------
 fs/ceph/dir.c          |  3 ---
 fs/ceph/inode.c        |  6 ------
 fs/cifs/cifsfs.c       |  9 ---------
 fs/ecryptfs/inode.c    |  9 ---------
 fs/ext2/file.c         |  3 ---
 fs/ext2/namei.c        |  6 ------
 fs/ext2/symlink.c      |  6 ------
 fs/ext4/file.c         |  3 ---
 fs/ext4/namei.c        |  6 ------
 fs/ext4/symlink.c      |  9 ---------
 fs/f2fs/file.c         |  3 ---
 fs/f2fs/namei.c        | 12 -----------
 fs/fuse/dir.c          |  9 ---------
 fs/gfs2/inode.c        |  9 ---------
 fs/hfs/inode.c         |  2 --
 fs/hfsplus/dir.c       |  3 ---
 fs/hfsplus/inode.c     |  3 ---
 fs/jffs2/dir.c         |  3 ---
 fs/jffs2/file.c        |  3 ---
 fs/jffs2/symlink.c     |  3 ---
 fs/jfs/file.c          |  3 ---
 fs/jfs/namei.c         |  3 ---
 fs/jfs/symlink.c       |  6 ------
 fs/kernfs/dir.c        |  3 ---
 fs/kernfs/inode.c      |  3 ---
 fs/kernfs/symlink.c    |  3 ---
 fs/libfs.c             |  3 ---
 fs/nfs/nfs3proc.c      |  6 ------
 fs/nfs/nfs4proc.c      |  6 ------
 fs/ocfs2/file.c        |  3 ---
 fs/ocfs2/namei.c       |  3 ---
 fs/ocfs2/symlink.c     |  3 ---
 fs/orangefs/inode.c    |  3 ---
 fs/orangefs/namei.c    |  3 ---
 fs/orangefs/symlink.c  |  1 -
 fs/overlayfs/dir.c     |  3 ---
 fs/overlayfs/inode.c   |  6 ------
 fs/reiserfs/file.c     |  3 ---
 fs/reiserfs/namei.c    |  9 ---------
 fs/squashfs/inode.c    |  1 -
 fs/squashfs/namei.c    |  1 -
 fs/squashfs/symlink.c  |  1 -
 fs/squashfs/xattr.h    |  1 -
 fs/ubifs/dir.c         |  3 ---
 fs/ubifs/file.c        |  6 ------
 fs/xattr.c             | 54 --------------------------------------------------
 fs/xfs/xfs_iops.c      | 12 -----------
 include/linux/fs.h     |  4 ----
 include/linux/xattr.h  |  3 ---
 mm/shmem.c             | 15 --------------
 net/socket.c           |  1 -
 54 files changed, 309 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index a34702c..f0f36b8 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -973,9 +973,6 @@ const struct inode_operations v9fs_dir_inode_operations_dotl = {
 	.rename = v9fs_vfs_rename,
 	.getattr = v9fs_vfs_getattr_dotl,
 	.setattr = v9fs_vfs_setattr_dotl,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
-	.removexattr = generic_removexattr,
 	.listxattr = v9fs_listxattr,
 	.get_acl = v9fs_iop_get_acl,
 };
@@ -983,9 +980,6 @@ const struct inode_operations v9fs_dir_inode_operations_dotl = {
 const struct inode_operations v9fs_file_inode_operations_dotl = {
 	.getattr = v9fs_vfs_getattr_dotl,
 	.setattr = v9fs_vfs_setattr_dotl,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
-	.removexattr = generic_removexattr,
 	.listxattr = v9fs_listxattr,
 	.get_acl = v9fs_iop_get_acl,
 };
@@ -995,8 +989,5 @@ const struct inode_operations v9fs_symlink_inode_operations_dotl = {
 	.get_link = v9fs_vfs_get_link_dotl,
 	.getattr = v9fs_vfs_getattr_dotl,
 	.setattr = v9fs_vfs_setattr_dotl,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
-	.removexattr = generic_removexattr,
 	.listxattr = v9fs_listxattr,
 };
diff --git a/fs/bad_inode.c b/fs/bad_inode.c
index e9227ea2d..334144c 100644
--- a/fs/bad_inode.c
+++ b/fs/bad_inode.c
@@ -151,10 +151,7 @@ static const struct inode_operations bad_inode_ops =
 	.permission	= bad_inode_permission,
 	.getattr	= bad_inode_getattr,
 	.setattr	= bad_inode_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= bad_inode_listxattr,
-	.removexattr	= generic_removexattr,
 	.xattr		= bad_inode_xattr_handlers,
 };
 
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 0077b3b..a1090e3 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10160,10 +10160,7 @@ static const struct inode_operations btrfs_dir_inode_operations = {
 	.symlink	= btrfs_symlink,
 	.setattr	= btrfs_setattr,
 	.mknod		= btrfs_mknod,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= btrfs_listxattr,
-	.removexattr	= generic_removexattr,
 	.permission	= btrfs_permission,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
@@ -10237,10 +10234,7 @@ static const struct address_space_operations btrfs_symlink_aops = {
 static const struct inode_operations btrfs_file_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr      = btrfs_listxattr,
-	.removexattr	= generic_removexattr,
 	.permission	= btrfs_permission,
 	.fiemap		= btrfs_fiemap,
 	.get_acl	= btrfs_get_acl,
@@ -10251,10 +10245,7 @@ static const struct inode_operations btrfs_special_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= btrfs_listxattr,
-	.removexattr	= generic_removexattr,
 	.get_acl	= btrfs_get_acl,
 	.set_acl	= btrfs_set_acl,
 	.update_time	= btrfs_update_time,
@@ -10265,10 +10256,7 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
 	.getattr	= btrfs_getattr,
 	.setattr	= btrfs_setattr,
 	.permission	= btrfs_permission,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= btrfs_listxattr,
-	.removexattr	= generic_removexattr,
 	.update_time	= btrfs_update_time,
 };
 
diff --git a/fs/ceph/dir.c b/fs/ceph/dir.c
index 2e0afdc..ed5753e 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1343,10 +1343,7 @@ const struct inode_operations ceph_dir_iops = {
 	.permission = ceph_permission,
 	.getattr = ceph_getattr,
 	.setattr = ceph_setattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = ceph_listxattr,
-	.removexattr = generic_removexattr,
 	.get_acl = ceph_get_acl,
 	.set_acl = ceph_set_acl,
 	.mknod = ceph_mknod,
diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
index addf8ef..aa64564 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -93,10 +93,7 @@ const struct inode_operations ceph_file_iops = {
 	.permission = ceph_permission,
 	.setattr = ceph_setattr,
 	.getattr = ceph_getattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = ceph_listxattr,
-	.removexattr = generic_removexattr,
 	.get_acl = ceph_get_acl,
 	.set_acl = ceph_set_acl,
 };
@@ -1771,10 +1768,7 @@ static const struct inode_operations ceph_symlink_iops = {
 	.get_link = simple_get_link,
 	.setattr = ceph_setattr,
 	.getattr = ceph_getattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = ceph_listxattr,
-	.removexattr = generic_removexattr,
 };
 
 int __ceph_setattr(struct inode *inode, struct iattr *attr)
diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 43cc522b..45d1e4c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -894,10 +894,7 @@ const struct inode_operations cifs_dir_inode_ops = {
 	.setattr = cifs_setattr,
 	.symlink = cifs_symlink,
 	.mknod   = cifs_mknod,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = generic_removexattr,
 };
 
 const struct inode_operations cifs_file_inode_ops = {
@@ -905,10 +902,7 @@ const struct inode_operations cifs_file_inode_ops = {
 	.setattr = cifs_setattr,
 	.getattr = cifs_getattr, /* do we need this anymore? */
 	.permission = cifs_permission,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = generic_removexattr,
 };
 
 const struct inode_operations cifs_symlink_inode_ops = {
@@ -918,10 +912,7 @@ const struct inode_operations cifs_symlink_inode_ops = {
 	/* BB add the following two eventually */
 	/* revalidate: cifs_revalidate,
 	   setattr:    cifs_notify_change, *//* BB do we need notify change */
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = generic_removexattr,
 };
 
 static int cifs_clone_file_range(struct file *src_file, loff_t off,
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index f8729cb..cb7231f 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1083,10 +1083,7 @@ const struct inode_operations ecryptfs_symlink_iops = {
 	.permission = ecryptfs_permission,
 	.setattr = ecryptfs_setattr,
 	.getattr = ecryptfs_getattr_link,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = ecryptfs_listxattr,
-	.removexattr = generic_removexattr
 };
 
 const struct inode_operations ecryptfs_dir_iops = {
@@ -1101,20 +1098,14 @@ const struct inode_operations ecryptfs_dir_iops = {
 	.rename = ecryptfs_rename,
 	.permission = ecryptfs_permission,
 	.setattr = ecryptfs_setattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = ecryptfs_listxattr,
-	.removexattr = generic_removexattr
 };
 
 const struct inode_operations ecryptfs_main_iops = {
 	.permission = ecryptfs_permission,
 	.setattr = ecryptfs_setattr,
 	.getattr = ecryptfs_getattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = ecryptfs_listxattr,
-	.removexattr = generic_removexattr
 };
 
 static int ecryptfs_xattr_get(const struct xattr_handler *handler,
diff --git a/fs/ext2/file.c b/fs/ext2/file.c
index c1400b1..8c28f44 100644
--- a/fs/ext2/file.c
+++ b/fs/ext2/file.c
@@ -178,10 +178,7 @@ const struct file_operations ext2_file_operations = {
 
 const struct inode_operations ext2_file_inode_operations = {
 #ifdef CONFIG_EXT2_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext2_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 	.setattr	= ext2_setattr,
 	.get_acl	= ext2_get_acl,
diff --git a/fs/ext2/namei.c b/fs/ext2/namei.c
index 1a7eb49..d4d79f2 100644
--- a/fs/ext2/namei.c
+++ b/fs/ext2/namei.c
@@ -428,10 +428,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 	.mknod		= ext2_mknod,
 	.rename		= ext2_rename,
 #ifdef CONFIG_EXT2_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext2_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 	.setattr	= ext2_setattr,
 	.get_acl	= ext2_get_acl,
@@ -441,10 +438,7 @@ const struct inode_operations ext2_dir_inode_operations = {
 
 const struct inode_operations ext2_special_inode_operations = {
 #ifdef CONFIG_EXT2_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext2_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 	.setattr	= ext2_setattr,
 	.get_acl	= ext2_get_acl,
diff --git a/fs/ext2/symlink.c b/fs/ext2/symlink.c
index 3495d8a..8437b19 100644
--- a/fs/ext2/symlink.c
+++ b/fs/ext2/symlink.c
@@ -25,10 +25,7 @@ const struct inode_operations ext2_symlink_inode_operations = {
 	.get_link	= page_get_link,
 	.setattr	= ext2_setattr,
 #ifdef CONFIG_EXT2_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext2_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
  
@@ -37,9 +34,6 @@ const struct inode_operations ext2_fast_symlink_inode_operations = {
 	.get_link	= simple_get_link,
 	.setattr	= ext2_setattr,
 #ifdef CONFIG_EXT2_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext2_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 6659e21..e497d4e 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -712,10 +712,7 @@ const struct file_operations ext4_file_operations = {
 const struct inode_operations ext4_file_inode_operations = {
 	.setattr	= ext4_setattr,
 	.getattr	= ext4_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext4_listxattr,
-	.removexattr	= generic_removexattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
 	.fiemap		= ext4_fiemap,
diff --git a/fs/ext4/namei.c b/fs/ext4/namei.c
index 5611ec9..ad89756 100644
--- a/fs/ext4/namei.c
+++ b/fs/ext4/namei.c
@@ -3882,10 +3882,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 	.tmpfile	= ext4_tmpfile,
 	.rename2	= ext4_rename2,
 	.setattr	= ext4_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext4_listxattr,
-	.removexattr	= generic_removexattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
 	.fiemap         = ext4_fiemap,
@@ -3893,10 +3890,7 @@ const struct inode_operations ext4_dir_inode_operations = {
 
 const struct inode_operations ext4_special_inode_operations = {
 	.setattr	= ext4_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext4_listxattr,
-	.removexattr	= generic_removexattr,
 	.get_acl	= ext4_get_acl,
 	.set_acl	= ext4_set_acl,
 };
diff --git a/fs/ext4/symlink.c b/fs/ext4/symlink.c
index 6f7ee30..61f440d 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -94,10 +94,7 @@ const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= ext4_encrypted_get_link,
 	.setattr	= ext4_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext4_listxattr,
-	.removexattr	= generic_removexattr,
 };
 #endif
 
@@ -105,18 +102,12 @@ const struct inode_operations ext4_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= page_get_link,
 	.setattr	= ext4_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext4_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 const struct inode_operations ext4_fast_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= simple_get_link,
 	.setattr	= ext4_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext4_listxattr,
-	.removexattr	= generic_removexattr,
 };
diff --git a/fs/f2fs/file.c b/fs/f2fs/file.c
index b41c357..54494c2 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -725,10 +725,7 @@ const struct inode_operations f2fs_file_inode_operations = {
 	.get_acl	= f2fs_get_acl,
 	.set_acl	= f2fs_set_acl,
 #ifdef CONFIG_F2FS_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= f2fs_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 	.fiemap		= f2fs_fiemap,
 };
diff --git a/fs/f2fs/namei.c b/fs/f2fs/namei.c
index db874ad..5b20a9a 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1066,10 +1066,7 @@ const struct inode_operations f2fs_encrypted_symlink_inode_operations = {
 	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
 #ifdef CONFIG_F2FS_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= f2fs_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
 
@@ -1089,10 +1086,7 @@ const struct inode_operations f2fs_dir_inode_operations = {
 	.get_acl	= f2fs_get_acl,
 	.set_acl	= f2fs_set_acl,
 #ifdef CONFIG_F2FS_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= f2fs_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
 
@@ -1102,10 +1096,7 @@ const struct inode_operations f2fs_symlink_inode_operations = {
 	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
 #ifdef CONFIG_F2FS_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= f2fs_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
 
@@ -1115,9 +1106,6 @@ const struct inode_operations f2fs_special_inode_operations = {
 	.get_acl	= f2fs_get_acl,
 	.set_acl	= f2fs_set_acl,
 #ifdef CONFIG_F2FS_FS_XATTR
-	.setxattr       = generic_setxattr,
-	.getxattr       = generic_getxattr,
 	.listxattr	= f2fs_listxattr,
-	.removexattr    = generic_removexattr,
 #endif
 };
diff --git a/fs/fuse/dir.c b/fs/fuse/dir.c
index c36b3a3..dcb16a4 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1884,10 +1884,7 @@ static const struct inode_operations fuse_dir_inode_operations = {
 	.mknod		= fuse_mknod,
 	.permission	= fuse_permission,
 	.getattr	= fuse_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= fuse_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 static const struct file_operations fuse_dir_operations = {
@@ -1905,10 +1902,7 @@ static const struct inode_operations fuse_common_inode_operations = {
 	.setattr	= fuse_setattr,
 	.permission	= fuse_permission,
 	.getattr	= fuse_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= fuse_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 static const struct inode_operations fuse_symlink_inode_operations = {
@@ -1916,10 +1910,7 @@ static const struct inode_operations fuse_symlink_inode_operations = {
 	.get_link	= fuse_get_link,
 	.readlink	= generic_readlink,
 	.getattr	= fuse_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= fuse_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 void fuse_init_common(struct inode *inode)
diff --git a/fs/gfs2/inode.c b/fs/gfs2/inode.c
index 3398342..3ef6938 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -1994,10 +1994,7 @@ const struct inode_operations gfs2_file_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = gfs2_listxattr,
-	.removexattr = generic_removexattr,
 	.fiemap = gfs2_fiemap,
 	.get_acl = gfs2_get_acl,
 	.set_acl = gfs2_set_acl,
@@ -2016,10 +2013,7 @@ const struct inode_operations gfs2_dir_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = gfs2_listxattr,
-	.removexattr = generic_removexattr,
 	.fiemap = gfs2_fiemap,
 	.get_acl = gfs2_get_acl,
 	.set_acl = gfs2_set_acl,
@@ -2032,10 +2026,7 @@ const struct inode_operations gfs2_symlink_iops = {
 	.permission = gfs2_permission,
 	.setattr = gfs2_setattr,
 	.getattr = gfs2_getattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = gfs2_listxattr,
-	.removexattr = generic_removexattr,
 	.fiemap = gfs2_fiemap,
 };
 
diff --git a/fs/hfs/inode.c b/fs/hfs/inode.c
index bb9549b..4b7a510 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -687,7 +687,5 @@ static const struct file_operations hfs_file_operations = {
 static const struct inode_operations hfs_file_inode_operations = {
 	.lookup		= hfs_file_lookup,
 	.setattr	= hfs_inode_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= generic_listxattr,
 };
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index a4e867e..5ff4e29 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -556,10 +556,7 @@ const struct inode_operations hfsplus_dir_inode_operations = {
 	.symlink		= hfsplus_symlink,
 	.mknod			= hfsplus_mknod,
 	.rename			= hfsplus_rename,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
 	.listxattr		= hfsplus_listxattr,
-	.removexattr		= generic_removexattr,
 #ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
 	.get_acl		= hfsplus_get_posix_acl,
 	.set_acl		= hfsplus_set_posix_acl,
diff --git a/fs/hfsplus/inode.c b/fs/hfsplus/inode.c
index 1a6394c..4a80a7e1 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -334,10 +334,7 @@ int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
 
 static const struct inode_operations hfsplus_file_inode_operations = {
 	.setattr	= hfsplus_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= hfsplus_listxattr,
-	.removexattr	= generic_removexattr,
 #ifdef CONFIG_HFSPLUS_FS_POSIX_ACL
 	.get_acl	= hfsplus_get_posix_acl,
 	.set_acl	= hfsplus_set_posix_acl,
diff --git a/fs/jffs2/dir.c b/fs/jffs2/dir.c
index 9130c7a..3779744 100644
--- a/fs/jffs2/dir.c
+++ b/fs/jffs2/dir.c
@@ -61,10 +61,7 @@ const struct inode_operations jffs2_dir_inode_operations =
 	.get_acl =	jffs2_get_acl,
 	.set_acl =	jffs2_set_acl,
 	.setattr =	jffs2_setattr,
-	.setxattr =	generic_setxattr,
-	.getxattr =	generic_getxattr,
 	.listxattr =	jffs2_listxattr,
-	.removexattr =	generic_removexattr
 };
 
 /***********************************************************************/
diff --git a/fs/jffs2/file.c b/fs/jffs2/file.c
index bf543cb..5817c25 100644
--- a/fs/jffs2/file.c
+++ b/fs/jffs2/file.c
@@ -66,10 +66,7 @@ const struct inode_operations jffs2_file_inode_operations =
 	.get_acl =	jffs2_get_acl,
 	.set_acl =	jffs2_set_acl,
 	.setattr =	jffs2_setattr,
-	.setxattr =	generic_setxattr,
-	.getxattr =	generic_getxattr,
 	.listxattr =	jffs2_listxattr,
-	.removexattr =	generic_removexattr
 };
 
 const struct address_space_operations jffs2_file_address_operations =
diff --git a/fs/jffs2/symlink.c b/fs/jffs2/symlink.c
index afe2d75..8f3f085 100644
--- a/fs/jffs2/symlink.c
+++ b/fs/jffs2/symlink.c
@@ -16,8 +16,5 @@ const struct inode_operations jffs2_symlink_inode_operations =
 	.readlink =	generic_readlink,
 	.get_link =	simple_get_link,
 	.setattr =	jffs2_setattr,
-	.setxattr =	generic_setxattr,
-	.getxattr =	generic_getxattr,
 	.listxattr =	jffs2_listxattr,
-	.removexattr =	generic_removexattr
 };
diff --git a/fs/jfs/file.c b/fs/jfs/file.c
index 7f1a585..f6eb041 100644
--- a/fs/jfs/file.c
+++ b/fs/jfs/file.c
@@ -140,10 +140,7 @@ int jfs_setattr(struct dentry *dentry, struct iattr *iattr)
 }
 
 const struct inode_operations jfs_file_inode_operations = {
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= jfs_listxattr,
-	.removexattr	= generic_removexattr,
 	.setattr	= jfs_setattr,
 #ifdef CONFIG_JFS_POSIX_ACL
 	.get_acl	= jfs_get_acl,
diff --git a/fs/jfs/namei.c b/fs/jfs/namei.c
index 7040062..e4c944b 100644
--- a/fs/jfs/namei.c
+++ b/fs/jfs/namei.c
@@ -1537,10 +1537,7 @@ const struct inode_operations jfs_dir_inode_operations = {
 	.rmdir		= jfs_rmdir,
 	.mknod		= jfs_mknod,
 	.rename		= jfs_rename,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= jfs_listxattr,
-	.removexattr	= generic_removexattr,
 	.setattr	= jfs_setattr,
 #ifdef CONFIG_JFS_POSIX_ACL
 	.get_acl	= jfs_get_acl,
diff --git a/fs/jfs/symlink.c b/fs/jfs/symlink.c
index c94c7e4..c82404f 100644
--- a/fs/jfs/symlink.c
+++ b/fs/jfs/symlink.c
@@ -25,19 +25,13 @@ const struct inode_operations jfs_fast_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= simple_get_link,
 	.setattr	= jfs_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= jfs_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 const struct inode_operations jfs_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= page_get_link,
 	.setattr	= jfs_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= jfs_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index f67d896..af660a7 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1125,9 +1125,6 @@ const struct inode_operations kernfs_dir_iops = {
 	.permission	= kernfs_iop_permission,
 	.setattr	= kernfs_iop_setattr,
 	.getattr	= kernfs_iop_getattr,
-	.setxattr	= generic_setxattr,
-	.removexattr	= generic_removexattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= kernfs_iop_listxattr,
 
 	.mkdir		= kernfs_iop_mkdir,
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 0f13396..9ee7b70 100644
--- a/fs/kernfs/inode.c
+++ b/fs/kernfs/inode.c
@@ -28,9 +28,6 @@ static const struct inode_operations kernfs_iops = {
 	.permission	= kernfs_iop_permission,
 	.setattr	= kernfs_iop_setattr,
 	.getattr	= kernfs_iop_getattr,
-	.setxattr	= generic_setxattr,
-	.removexattr	= generic_removexattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= kernfs_iop_listxattr,
 };
 
diff --git a/fs/kernfs/symlink.c b/fs/kernfs/symlink.c
index 549a14c7..9b43ca0 100644
--- a/fs/kernfs/symlink.c
+++ b/fs/kernfs/symlink.c
@@ -134,9 +134,6 @@ static const char *kernfs_iop_get_link(struct dentry *dentry,
 }
 
 const struct inode_operations kernfs_symlink_iops = {
-	.setxattr	= generic_setxattr,
-	.removexattr	= generic_removexattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= kernfs_iop_listxattr,
 	.readlink	= generic_readlink,
 	.get_link	= kernfs_iop_get_link,
diff --git a/fs/libfs.c b/fs/libfs.c
index a7cea0a..11b49bf 100644
--- a/fs/libfs.c
+++ b/fs/libfs.c
@@ -1137,9 +1137,6 @@ static const struct inode_operations empty_dir_inode_operations = {
 	.permission	= generic_permission,
 	.setattr	= empty_dir_setattr,
 	.getattr	= empty_dir_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
-	.removexattr	= generic_removexattr,
 	.listxattr	= empty_dir_listxattr,
 	.xattr		= empty_dir_xattr_handlers,
 };
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index cb28cce..0be4e42 100644
--- a/fs/nfs/nfs3proc.c
+++ b/fs/nfs/nfs3proc.c
@@ -899,9 +899,6 @@ static const struct inode_operations nfs3_dir_inode_operations = {
 	.setattr	= nfs_setattr,
 #ifdef CONFIG_NFS_V3_ACL
 	.listxattr	= nfs3_listxattr,
-	.getxattr	= generic_getxattr,
-	.setxattr	= generic_setxattr,
-	.removexattr	= generic_removexattr,
 	.get_acl	= nfs3_get_acl,
 	.set_acl	= nfs3_set_acl,
 #endif
@@ -913,9 +910,6 @@ static const struct inode_operations nfs3_file_inode_operations = {
 	.setattr	= nfs_setattr,
 #ifdef CONFIG_NFS_V3_ACL
 	.listxattr	= nfs3_listxattr,
-	.getxattr	= generic_getxattr,
-	.setxattr	= generic_setxattr,
-	.removexattr	= generic_removexattr,
 	.get_acl	= nfs3_get_acl,
 	.set_acl	= nfs3_set_acl,
 #endif
diff --git a/fs/nfs/nfs4proc.c b/fs/nfs/nfs4proc.c
index 7a7ac1d..48b970d 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8853,20 +8853,14 @@ static const struct inode_operations nfs4_dir_inode_operations = {
 	.permission	= nfs_permission,
 	.getattr	= nfs_getattr,
 	.setattr	= nfs_setattr,
-	.getxattr	= generic_getxattr,
-	.setxattr	= generic_setxattr,
 	.listxattr	= nfs4_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 static const struct inode_operations nfs4_file_inode_operations = {
 	.permission	= nfs_permission,
 	.getattr	= nfs_getattr,
 	.setattr	= nfs_setattr,
-	.getxattr	= generic_getxattr,
-	.setxattr	= generic_setxattr,
 	.listxattr	= nfs4_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 const struct nfs_rpc_ops nfs_v4_clientops = {
diff --git a/fs/ocfs2/file.c b/fs/ocfs2/file.c
index c6fdcbd..0200a4f 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2460,10 +2460,7 @@ const struct inode_operations ocfs2_file_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ocfs2_listxattr,
-	.removexattr	= generic_removexattr,
 	.fiemap		= ocfs2_fiemap,
 	.get_acl	= ocfs2_iop_get_acl,
 	.set_acl	= ocfs2_iop_set_acl,
diff --git a/fs/ocfs2/namei.c b/fs/ocfs2/namei.c
index 6b3e871..24eaca1 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2932,10 +2932,7 @@ const struct inode_operations ocfs2_dir_iops = {
 	.setattr	= ocfs2_setattr,
 	.getattr	= ocfs2_getattr,
 	.permission	= ocfs2_permission,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ocfs2_listxattr,
-	.removexattr	= generic_removexattr,
 	.fiemap         = ocfs2_fiemap,
 	.get_acl	= ocfs2_iop_get_acl,
 	.set_acl	= ocfs2_iop_set_acl,
diff --git a/fs/ocfs2/symlink.c b/fs/ocfs2/symlink.c
index 6c2a3e3..6ad8eec 100644
--- a/fs/ocfs2/symlink.c
+++ b/fs/ocfs2/symlink.c
@@ -91,9 +91,6 @@ const struct inode_operations ocfs2_symlink_inode_operations = {
 	.get_link	= page_get_link,
 	.getattr	= ocfs2_getattr,
 	.setattr	= ocfs2_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ocfs2_listxattr,
-	.removexattr	= generic_removexattr,
 	.fiemap		= ocfs2_fiemap,
 };
diff --git a/fs/orangefs/inode.c b/fs/orangefs/inode.c
index 2382e26..a4d26c1 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -313,10 +313,7 @@ struct inode_operations orangefs_file_inode_operations = {
 	.set_acl = orangefs_set_acl,
 	.setattr = orangefs_setattr,
 	.getattr = orangefs_getattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = orangefs_listxattr,
-	.removexattr = generic_removexattr,
 	.permission = orangefs_permission,
 };
 
diff --git a/fs/orangefs/namei.c b/fs/orangefs/namei.c
index 5a60c50..d396d03 100644
--- a/fs/orangefs/namei.c
+++ b/fs/orangefs/namei.c
@@ -454,9 +454,6 @@ struct inode_operations orangefs_dir_inode_operations = {
 	.rename = orangefs_rename,
 	.setattr = orangefs_setattr,
 	.getattr = orangefs_getattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
-	.removexattr = generic_removexattr,
 	.listxattr = orangefs_listxattr,
 	.permission = orangefs_permission,
 };
diff --git a/fs/orangefs/symlink.c b/fs/orangefs/symlink.c
index 6418dd6..dade1ef 100644
--- a/fs/orangefs/symlink.c
+++ b/fs/orangefs/symlink.c
@@ -14,6 +14,5 @@ struct inode_operations orangefs_symlink_inode_operations = {
 	.setattr = orangefs_setattr,
 	.getattr = orangefs_getattr,
 	.listxattr = orangefs_listxattr,
-	.setxattr = generic_setxattr,
 	.permission = orangefs_permission,
 };
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 16ba0f8..6438002 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -967,8 +967,5 @@ const struct inode_operations ovl_dir_inode_operations = {
 	.mknod		= ovl_mknod,
 	.permission	= ovl_permission,
 	.getattr	= ovl_dir_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= generic_removexattr,
 };
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index d08c926..10dda4b 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -374,10 +374,7 @@ static const struct inode_operations ovl_file_inode_operations = {
 	.setattr	= ovl_setattr,
 	.permission	= ovl_permission,
 	.getattr	= ovl_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 static const struct inode_operations ovl_symlink_inode_operations = {
@@ -385,10 +382,7 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.get_link	= ovl_get_link,
 	.readlink	= ovl_readlink,
 	.getattr	= ovl_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 struct inode *ovl_new_inode(struct super_block *sb, umode_t mode,
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index 9ffaf71..6574a03 100644
--- a/fs/reiserfs/file.c
+++ b/fs/reiserfs/file.c
@@ -260,10 +260,7 @@ const struct file_operations reiserfs_file_operations = {
 
 const struct inode_operations reiserfs_file_inode_operations = {
 	.setattr = reiserfs_setattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = reiserfs_listxattr,
-	.removexattr = generic_removexattr,
 	.permission = reiserfs_permission,
 	.get_acl = reiserfs_get_acl,
 	.set_acl = reiserfs_set_acl,
diff --git a/fs/reiserfs/namei.c b/fs/reiserfs/namei.c
index 8a36696..fd7d060 100644
--- a/fs/reiserfs/namei.c
+++ b/fs/reiserfs/namei.c
@@ -1650,10 +1650,7 @@ const struct inode_operations reiserfs_dir_inode_operations = {
 	.mknod = reiserfs_mknod,
 	.rename = reiserfs_rename,
 	.setattr = reiserfs_setattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = reiserfs_listxattr,
-	.removexattr = generic_removexattr,
 	.permission = reiserfs_permission,
 	.get_acl = reiserfs_get_acl,
 	.set_acl = reiserfs_set_acl,
@@ -1667,10 +1664,7 @@ const struct inode_operations reiserfs_symlink_inode_operations = {
 	.readlink = generic_readlink,
 	.get_link	= page_get_link,
 	.setattr = reiserfs_setattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = reiserfs_listxattr,
-	.removexattr = generic_removexattr,
 	.permission = reiserfs_permission,
 };
 
@@ -1679,10 +1673,7 @@ const struct inode_operations reiserfs_symlink_inode_operations = {
  */
 const struct inode_operations reiserfs_special_inode_operations = {
 	.setattr = reiserfs_setattr,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = reiserfs_listxattr,
-	.removexattr = generic_removexattr,
 	.permission = reiserfs_permission,
 	.get_acl = reiserfs_get_acl,
 	.set_acl = reiserfs_set_acl,
diff --git a/fs/squashfs/inode.c b/fs/squashfs/inode.c
index 0927b1e..e9793b1 100644
--- a/fs/squashfs/inode.c
+++ b/fs/squashfs/inode.c
@@ -425,7 +425,6 @@ failed_read:
 
 
 const struct inode_operations squashfs_inode_ops = {
-	.getxattr = generic_getxattr,
 	.listxattr = squashfs_listxattr
 };
 
diff --git a/fs/squashfs/namei.c b/fs/squashfs/namei.c
index 67cad77..40c10d9 100644
--- a/fs/squashfs/namei.c
+++ b/fs/squashfs/namei.c
@@ -247,6 +247,5 @@ failed:
 
 const struct inode_operations squashfs_dir_inode_ops = {
 	.lookup = squashfs_lookup,
-	.getxattr = generic_getxattr,
 	.listxattr = squashfs_listxattr
 };
diff --git a/fs/squashfs/symlink.c b/fs/squashfs/symlink.c
index dbcc2f5..637d7e1 100644
--- a/fs/squashfs/symlink.c
+++ b/fs/squashfs/symlink.c
@@ -120,7 +120,6 @@ const struct address_space_operations squashfs_symlink_aops = {
 const struct inode_operations squashfs_symlink_inode_ops = {
 	.readlink = generic_readlink,
 	.get_link = page_get_link,
-	.getxattr = generic_getxattr,
 	.listxattr = squashfs_listxattr
 };
 
diff --git a/fs/squashfs/xattr.h b/fs/squashfs/xattr.h
index c83f5d9..afe70f8 100644
--- a/fs/squashfs/xattr.h
+++ b/fs/squashfs/xattr.h
@@ -42,6 +42,5 @@ static inline int squashfs_xattr_lookup(struct super_block *sb,
 	return 0;
 }
 #define squashfs_listxattr NULL
-#define generic_getxattr NULL
 #define squashfs_xattr_handlers NULL
 #endif
diff --git a/fs/ubifs/dir.c b/fs/ubifs/dir.c
index 4d07d15..2d75a9f 100644
--- a/fs/ubifs/dir.c
+++ b/fs/ubifs/dir.c
@@ -1182,10 +1182,7 @@ const struct inode_operations ubifs_dir_inode_operations = {
 	.rename      = ubifs_rename,
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
-	.setxattr    = generic_setxattr,
-	.getxattr    = generic_getxattr,
 	.listxattr   = ubifs_listxattr,
-	.removexattr = generic_removexattr,
 #ifdef CONFIG_UBIFS_ATIME_SUPPORT
 	.update_time = ubifs_update_time,
 #endif
diff --git a/fs/ubifs/file.c b/fs/ubifs/file.c
index e149437..2f1df7e 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1597,10 +1597,7 @@ const struct address_space_operations ubifs_file_address_operations = {
 const struct inode_operations ubifs_file_inode_operations = {
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
-	.setxattr    = generic_setxattr,
-	.getxattr    = generic_getxattr,
 	.listxattr   = ubifs_listxattr,
-	.removexattr = generic_removexattr,
 #ifdef CONFIG_UBIFS_ATIME_SUPPORT
 	.update_time = ubifs_update_time,
 #endif
@@ -1611,10 +1608,7 @@ const struct inode_operations ubifs_symlink_inode_operations = {
 	.get_link    = simple_get_link,
 	.setattr     = ubifs_setattr,
 	.getattr     = ubifs_getattr,
-	.setxattr    = generic_setxattr,
-	.getxattr    = generic_getxattr,
 	.listxattr   = ubifs_listxattr,
-	.removexattr = generic_removexattr,
 #ifdef CONFIG_UBIFS_ATIME_SUPPORT
 	.update_time = ubifs_update_time,
 #endif
diff --git a/fs/xattr.c b/fs/xattr.c
index a3fa123..48b8d5e 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -40,9 +40,6 @@ strcmp_prefix(const char *a, const char *a_prefix)
  * null-terminated array of struct xattr_handler (one for each prefix) and
  * hang a pointer to it off of the xattr field of the inode operations or
  * the s_xattr field of the superblock.
- *
- * The generic_fooxattr() functions will use this list to dispatch xattr
- * operations to the correct xattr_handler.
  */
 #define for_each_xattr_handler(handlers, handler)		\
 		for ((handler) = *(handlers)++;			\
@@ -730,22 +727,6 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
 }
 
 /*
- * Find the handler for the prefix and dispatch its get() operation.
- */
-ssize_t
-generic_getxattr(struct dentry *dentry, struct inode *inode,
-		 const char *name, void *buffer, size_t size)
-{
-	const struct xattr_handler *handler;
-
-	handler = xattr_resolve_name(dentry, &name);
-	if (IS_ERR(handler))
-		return PTR_ERR(handler);
-	return handler->get(handler, dentry, inode,
-			    name, buffer, size);
-}
-
-/*
  * Combine the results of the list() operation from every xattr_handler in the
  * list.
  */
@@ -782,42 +763,7 @@ generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 	}
 	return size;
 }
-
-/*
- * Find the handler for the prefix and dispatch its set() operation.
- */
-int
-generic_setxattr(struct dentry *dentry, const char *name, const void *value, size_t size, int flags)
-{
-	const struct xattr_handler *handler;
-
-	if (size == 0)
-		value = "";  /* empty EA, do not remove */
-	handler = xattr_resolve_name(dentry, &name);
-	if (IS_ERR(handler))
-		return PTR_ERR(handler);
-	return handler->set(handler, dentry, name, value, size, flags);
-}
-
-/*
- * Find the handler for the prefix and dispatch its set() operation to remove
- * any associated extended attribute.
- */
-int
-generic_removexattr(struct dentry *dentry, const char *name)
-{
-	const struct xattr_handler *handler;
-
-	handler = xattr_resolve_name(dentry, &name);
-	if (IS_ERR(handler))
-		return PTR_ERR(handler);
-	return handler->set(handler, dentry, name, NULL, 0, XATTR_REPLACE);
-}
-
-EXPORT_SYMBOL(generic_getxattr);
 EXPORT_SYMBOL(generic_listxattr);
-EXPORT_SYMBOL(generic_setxattr);
-EXPORT_SYMBOL(generic_removexattr);
 
 /**
  * xattr_full_name  -  Compute full attribute name from suffix
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index fb7dc61..3d3a589 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1091,9 +1091,6 @@ static const struct inode_operations xfs_inode_operations = {
 	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.fiemap			= xfs_vn_fiemap,
 	.update_time		= xfs_vn_update_time,
@@ -1119,9 +1116,6 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
 	.tmpfile		= xfs_vn_tmpfile,
@@ -1147,9 +1141,6 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
 	.tmpfile		= xfs_vn_tmpfile,
@@ -1160,9 +1151,6 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.get_link		= xfs_vn_get_link,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
 };
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 4f25cd3..d6d186f 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1701,11 +1701,7 @@ struct inode_operations {
 			struct inode *, struct dentry *, unsigned int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
-	int (*setxattr) (struct dentry *, const char *,const void *,size_t,int);
-	ssize_t (*getxattr) (struct dentry *, struct inode *,
-			     const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
-	int (*removexattr) (struct dentry *, const char *);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
 	int (*update_time)(struct inode *, struct timespec *, int);
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 76557ce..38728b0 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -56,10 +56,7 @@ int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
 int __vfs_removexattr(struct dentry *, const char *);
 int vfs_removexattr(struct dentry *, const char *);
 
-ssize_t generic_getxattr(struct dentry *dentry, struct inode *inode, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
-int generic_setxattr(struct dentry *dentry, const char *name, const void *value, size_t size, int flags);
-int generic_removexattr(struct dentry *dentry, const char *name);
 ssize_t vfs_getxattr_alloc(struct dentry *dentry, const char *name,
 			   char **xattr_value, size_t size, gfp_t flags);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 00d5d02..7ce1d8a 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2698,10 +2698,7 @@ static const struct inode_operations shmem_short_symlink_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= simple_get_link,
 #ifdef CONFIG_TMPFS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= shmem_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
 
@@ -2709,10 +2706,7 @@ static const struct inode_operations shmem_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= shmem_get_link,
 #ifdef CONFIG_TMPFS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= shmem_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
 
@@ -3183,10 +3177,7 @@ static const struct inode_operations shmem_inode_operations = {
 	.getattr	= shmem_getattr,
 	.setattr	= shmem_setattr,
 #ifdef CONFIG_TMPFS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= shmem_listxattr,
-	.removexattr	= generic_removexattr,
 	.set_acl	= simple_set_acl,
 #endif
 };
@@ -3205,10 +3196,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 	.tmpfile	= shmem_tmpfile,
 #endif
 #ifdef CONFIG_TMPFS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= shmem_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_setattr,
@@ -3218,10 +3206,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 
 static const struct inode_operations shmem_special_inode_operations = {
 #ifdef CONFIG_TMPFS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= shmem_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 #ifdef CONFIG_TMPFS_POSIX_ACL
 	.setattr	= shmem_setattr,
diff --git a/net/socket.c b/net/socket.c
index 3ef77ab..7976fa8 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -519,7 +519,6 @@ static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
 }
 
 static const struct inode_operations sockfs_inode_ops = {
-	.getxattr = generic_getxattr,
 	.listxattr = sockfs_listxattr,
 };
 
-- 
2.5.5
