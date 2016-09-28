From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v5 17/17] vfs: Remove {get,set,remove}xattr inode operations
Date: Wed, 28 Sep 2016 16:58:03 +0200
Message-ID: <1475074683-26971-18-git-send-email-agruenba@redhat.com>
References: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
In-Reply-To: <1475074683-26971-1-git-send-email-agruenba@redhat.com>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

These inode operations are no longer used; remove them.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
---
 fs/9p/vfs_inode_dotl.c |  9 ---------
 fs/btrfs/inode.c       | 12 ------------
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
 fs/f2fs/namei.c        | 12 ------------
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
 fs/xattr.c             | 53 --------------------------------------------------
 fs/xfs/xfs_iops.c      | 15 --------------
 include/linux/fs.h     |  5 -----
 include/linux/xattr.h  |  4 ----
 mm/shmem.c             | 15 --------------
 net/socket.c           |  1 -
 52 files changed, 307 deletions(-)

diff --git a/fs/9p/vfs_inode_dotl.c b/fs/9p/vfs_inode_dotl.c
index eeabcb0..d8220ef 100644
--- a/fs/9p/vfs_inode_dotl.c
+++ b/fs/9p/vfs_inode_dotl.c
@@ -967,9 +967,6 @@ const struct inode_operations v9fs_dir_inode_operations_dotl = {
 	.rename = v9fs_vfs_rename,
 	.getattr = v9fs_vfs_getattr_dotl,
 	.setattr = v9fs_vfs_setattr_dotl,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
-	.removexattr = generic_removexattr,
 	.listxattr = v9fs_listxattr,
 	.get_acl = v9fs_iop_get_acl,
 };
@@ -977,9 +974,6 @@ const struct inode_operations v9fs_dir_inode_operations_dotl = {
 const struct inode_operations v9fs_file_inode_operations_dotl = {
 	.getattr = v9fs_vfs_getattr_dotl,
 	.setattr = v9fs_vfs_setattr_dotl,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
-	.removexattr = generic_removexattr,
 	.listxattr = v9fs_listxattr,
 	.get_acl = v9fs_iop_get_acl,
 };
@@ -989,8 +983,5 @@ const struct inode_operations v9fs_symlink_inode_operations_dotl = {
 	.get_link = v9fs_vfs_get_link_dotl,
 	.getattr = v9fs_vfs_getattr_dotl,
 	.setattr = v9fs_vfs_setattr_dotl,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
-	.removexattr = generic_removexattr,
 	.listxattr = v9fs_listxattr,
 };
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index e6811c4..d06c6a2 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -10570,10 +10570,7 @@ static const struct inode_operations btrfs_dir_inode_operations = {
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
@@ -10647,10 +10644,7 @@ static const struct address_space_operations btrfs_symlink_aops = {
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
@@ -10661,10 +10655,7 @@ static const struct inode_operations btrfs_special_inode_operations = {
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
@@ -10675,10 +10666,7 @@ static const struct inode_operations btrfs_symlink_inode_operations = {
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
index df4b3e6..e33bd09 100644
--- a/fs/ceph/dir.c
+++ b/fs/ceph/dir.c
@@ -1486,10 +1486,7 @@ const struct inode_operations ceph_dir_iops = {
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
index dd3a6db..e70b4f5 100644
--- a/fs/ceph/inode.c
+++ b/fs/ceph/inode.c
@@ -94,10 +94,7 @@ const struct inode_operations ceph_file_iops = {
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
@@ -1885,10 +1882,7 @@ static const struct inode_operations ceph_symlink_iops = {
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
index 14ae4b8..34aac1c 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -901,30 +901,21 @@ const struct inode_operations cifs_dir_inode_ops = {
 	.setattr = cifs_setattr,
 	.symlink = cifs_symlink,
 	.mknod   = cifs_mknod,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = generic_removexattr,
 };
 
 const struct inode_operations cifs_file_inode_ops = {
 	.setattr = cifs_setattr,
 	.getattr = cifs_getattr,
 	.permission = cifs_permission,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = generic_removexattr,
 };
 
 const struct inode_operations cifs_symlink_inode_ops = {
 	.readlink = generic_readlink,
 	.get_link = cifs_get_link,
 	.permission = cifs_permission,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = cifs_listxattr,
-	.removexattr = generic_removexattr,
 };
 
 static int cifs_clone_file_range(struct file *src_file, loff_t off,
diff --git a/fs/ecryptfs/inode.c b/fs/ecryptfs/inode.c
index 32fee25..3f2575d 100644
--- a/fs/ecryptfs/inode.c
+++ b/fs/ecryptfs/inode.c
@@ -1090,10 +1090,7 @@ const struct inode_operations ecryptfs_symlink_iops = {
 	.permission = ecryptfs_permission,
 	.setattr = ecryptfs_setattr,
 	.getattr = ecryptfs_getattr_link,
-	.setxattr = generic_setxattr,
-	.getxattr = generic_getxattr,
 	.listxattr = ecryptfs_listxattr,
-	.removexattr = generic_removexattr
 };
 
 const struct inode_operations ecryptfs_dir_iops = {
@@ -1108,20 +1105,14 @@ const struct inode_operations ecryptfs_dir_iops = {
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
index 5efeefe..538f776 100644
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
index d446203..ff32ea7 100644
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
index 261ac37..93072db 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -711,10 +711,7 @@ const struct file_operations ext4_file_operations = {
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
index 34c0142..ddc309e 100644
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
index 4d83d9e..128ea78 100644
--- a/fs/ext4/symlink.c
+++ b/fs/ext4/symlink.c
@@ -90,28 +90,19 @@ const struct inode_operations ext4_encrypted_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= ext4_encrypted_get_link,
 	.setattr	= ext4_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ext4_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 const struct inode_operations ext4_symlink_inode_operations = {
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
index 28f4f4c..2ebc4c7 100644
--- a/fs/f2fs/file.c
+++ b/fs/f2fs/file.c
@@ -732,10 +732,7 @@ const struct inode_operations f2fs_file_inode_operations = {
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
index 73fa356..1c481c9 100644
--- a/fs/f2fs/namei.c
+++ b/fs/f2fs/namei.c
@@ -1077,10 +1077,7 @@ const struct inode_operations f2fs_encrypted_symlink_inode_operations = {
 	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
 #ifdef CONFIG_F2FS_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= f2fs_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
 
@@ -1100,10 +1097,7 @@ const struct inode_operations f2fs_dir_inode_operations = {
 	.get_acl	= f2fs_get_acl,
 	.set_acl	= f2fs_set_acl,
 #ifdef CONFIG_F2FS_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= f2fs_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
 
@@ -1113,10 +1107,7 @@ const struct inode_operations f2fs_symlink_inode_operations = {
 	.getattr	= f2fs_getattr,
 	.setattr	= f2fs_setattr,
 #ifdef CONFIG_F2FS_FS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= f2fs_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
 
@@ -1126,9 +1117,6 @@ const struct inode_operations f2fs_special_inode_operations = {
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
index 3408a37..96ba565 100644
--- a/fs/fuse/dir.c
+++ b/fs/fuse/dir.c
@@ -1883,10 +1883,7 @@ static const struct inode_operations fuse_dir_inode_operations = {
 	.mknod		= fuse_mknod,
 	.permission	= fuse_permission,
 	.getattr	= fuse_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= fuse_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 static const struct file_operations fuse_dir_operations = {
@@ -1904,10 +1901,7 @@ static const struct inode_operations fuse_common_inode_operations = {
 	.setattr	= fuse_setattr,
 	.permission	= fuse_permission,
 	.getattr	= fuse_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= fuse_listxattr,
-	.removexattr	= generic_removexattr,
 };
 
 static const struct inode_operations fuse_symlink_inode_operations = {
@@ -1915,10 +1909,7 @@ static const struct inode_operations fuse_symlink_inode_operations = {
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
index e4da0ec..9cbd4b6 100644
--- a/fs/gfs2/inode.c
+++ b/fs/gfs2/inode.c
@@ -2036,10 +2036,7 @@ const struct inode_operations gfs2_file_iops = {
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
@@ -2058,10 +2055,7 @@ const struct inode_operations gfs2_dir_iops = {
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
@@ -2074,10 +2068,7 @@ const struct inode_operations gfs2_symlink_iops = {
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
index 7f44f1a..a181bd7 100644
--- a/fs/hfs/inode.c
+++ b/fs/hfs/inode.c
@@ -688,7 +688,5 @@ static const struct file_operations hfs_file_operations = {
 static const struct inode_operations hfs_file_inode_operations = {
 	.lookup		= hfs_file_lookup,
 	.setattr	= hfs_inode_setattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= generic_listxattr,
 };
diff --git a/fs/hfsplus/dir.c b/fs/hfsplus/dir.c
index 42e1286..9cbe430 100644
--- a/fs/hfsplus/dir.c
+++ b/fs/hfsplus/dir.c
@@ -562,10 +562,7 @@ const struct inode_operations hfsplus_dir_inode_operations = {
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
index 19462d7..4a7c924 100644
--- a/fs/hfsplus/inode.c
+++ b/fs/hfsplus/inode.c
@@ -333,10 +333,7 @@ int hfsplus_file_fsync(struct file *file, loff_t start, loff_t end,
 
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
index 8aa2f89..9b24243 100644
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
index fdf9e1c..c12476e 100644
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
index 814b0c5..e420c60 100644
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
index a6e430a..2b23ad9 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1126,9 +1126,6 @@ const struct inode_operations kernfs_dir_iops = {
 	.permission	= kernfs_iop_permission,
 	.setattr	= kernfs_iop_setattr,
 	.getattr	= kernfs_iop_getattr,
-	.setxattr	= generic_setxattr,
-	.removexattr	= generic_removexattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= kernfs_iop_listxattr,
 
 	.mkdir		= kernfs_iop_mkdir,
diff --git a/fs/kernfs/inode.c b/fs/kernfs/inode.c
index 6bc8754..2b735ce 100644
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
diff --git a/fs/nfs/nfs3proc.c b/fs/nfs/nfs3proc.c
index 698be93..dc925b5 100644
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
index a9dec32..0e32752 100644
--- a/fs/nfs/nfs4proc.c
+++ b/fs/nfs/nfs4proc.c
@@ -8941,20 +8941,14 @@ static const struct inode_operations nfs4_dir_inode_operations = {
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
index 0b055bf..63316db 100644
--- a/fs/ocfs2/file.c
+++ b/fs/ocfs2/file.c
@@ -2474,10 +2474,7 @@ const struct inode_operations ocfs2_file_iops = {
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
index a8f1225..6cc043e 100644
--- a/fs/ocfs2/namei.c
+++ b/fs/ocfs2/namei.c
@@ -2913,10 +2913,7 @@ const struct inode_operations ocfs2_dir_iops = {
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
index 28a0557..a9407ee 100644
--- a/fs/orangefs/inode.c
+++ b/fs/orangefs/inode.c
@@ -296,10 +296,7 @@ const struct inode_operations orangefs_file_inode_operations = {
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
index 62c5259..ccca518 100644
--- a/fs/orangefs/namei.c
+++ b/fs/orangefs/namei.c
@@ -462,9 +462,6 @@ const struct inode_operations orangefs_dir_inode_operations = {
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
index 8fecf82..10b0b06 100644
--- a/fs/orangefs/symlink.c
+++ b/fs/orangefs/symlink.c
@@ -14,6 +14,5 @@ const struct inode_operations orangefs_symlink_inode_operations = {
 	.setattr = orangefs_setattr,
 	.getattr = orangefs_getattr,
 	.listxattr = orangefs_listxattr,
-	.setxattr = generic_setxattr,
 	.permission = orangefs_permission,
 };
diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
index 1560fdc..463a184 100644
--- a/fs/overlayfs/dir.c
+++ b/fs/overlayfs/dir.c
@@ -1003,10 +1003,7 @@ const struct inode_operations ovl_dir_inode_operations = {
 	.mknod		= ovl_mknod,
 	.permission	= ovl_permission,
 	.getattr	= ovl_dir_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= generic_removexattr,
 	.get_acl	= ovl_get_acl,
 	.update_time	= ovl_update_time,
 };
diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
index c75625c..b4c3559 100644
--- a/fs/overlayfs/inode.c
+++ b/fs/overlayfs/inode.c
@@ -367,10 +367,7 @@ static const struct inode_operations ovl_file_inode_operations = {
 	.setattr	= ovl_setattr,
 	.permission	= ovl_permission,
 	.getattr	= ovl_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= generic_removexattr,
 	.get_acl	= ovl_get_acl,
 	.update_time	= ovl_update_time,
 };
@@ -380,10 +377,7 @@ static const struct inode_operations ovl_symlink_inode_operations = {
 	.get_link	= ovl_get_link,
 	.readlink	= ovl_readlink,
 	.getattr	= ovl_getattr,
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= ovl_listxattr,
-	.removexattr	= generic_removexattr,
 	.update_time	= ovl_update_time,
 };
 
diff --git a/fs/reiserfs/file.c b/fs/reiserfs/file.c
index 90f815b..2f8c5c9 100644
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
index d688ef4..79b9c31 100644
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
index 4b86d3a..1d55aea 100644
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
index 7bbf420..4360c66 100644
--- a/fs/ubifs/file.c
+++ b/fs/ubifs/file.c
@@ -1621,10 +1621,7 @@ const struct address_space_operations ubifs_file_address_operations = {
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
@@ -1635,10 +1632,7 @@ const struct inode_operations ubifs_symlink_inode_operations = {
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
index 2432442..3368659 100644
--- a/fs/xattr.c
+++ b/fs/xattr.c
@@ -741,22 +741,6 @@ SYSCALL_DEFINE2(fremovexattr, int, fd, const char __user *, name)
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
-	handler = xattr_resolve_name(inode, &name);
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
@@ -792,44 +776,7 @@ generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size)
 	}
 	return size;
 }
-
-/*
- * Find the handler for the prefix and dispatch its set() operation.
- */
-int
-generic_setxattr(struct dentry *dentry, struct inode *inode, const char *name,
-		 const void *value, size_t size, int flags)
-{
-	const struct xattr_handler *handler;
-
-	if (size == 0)
-		value = "";  /* empty EA, do not remove */
-	handler = xattr_resolve_name(inode, &name);
-	if (IS_ERR(handler))
-		return PTR_ERR(handler);
-	return handler->set(handler, dentry, inode, name, value, size, flags);
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
-	handler = xattr_resolve_name(d_inode(dentry), &name);
-	if (IS_ERR(handler))
-		return PTR_ERR(handler);
-	return handler->set(handler, dentry, d_inode(dentry), name, NULL,
-			    0, XATTR_REPLACE);
-}
-
-EXPORT_SYMBOL(generic_getxattr);
 EXPORT_SYMBOL(generic_listxattr);
-EXPORT_SYMBOL(generic_setxattr);
-EXPORT_SYMBOL(generic_removexattr);
 
 /**
  * xattr_full_name  -  Compute full attribute name from suffix
diff --git a/fs/xfs/xfs_iops.c b/fs/xfs/xfs_iops.c
index b24c310..37eeb37 100644
--- a/fs/xfs/xfs_iops.c
+++ b/fs/xfs/xfs_iops.c
@@ -1036,9 +1036,6 @@ static const struct inode_operations xfs_inode_operations = {
 	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.fiemap			= xfs_vn_fiemap,
 	.update_time		= xfs_vn_update_time,
@@ -1064,9 +1061,6 @@ static const struct inode_operations xfs_dir_inode_operations = {
 	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
 	.tmpfile		= xfs_vn_tmpfile,
@@ -1092,9 +1086,6 @@ static const struct inode_operations xfs_dir_ci_inode_operations = {
 	.set_acl		= xfs_set_acl,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
 	.tmpfile		= xfs_vn_tmpfile,
@@ -1105,9 +1096,6 @@ static const struct inode_operations xfs_symlink_inode_operations = {
 	.get_link		= xfs_vn_get_link,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
 };
@@ -1117,9 +1105,6 @@ static const struct inode_operations xfs_inline_symlink_inode_operations = {
 	.get_link		= xfs_vn_get_link_inline,
 	.getattr		= xfs_vn_getattr,
 	.setattr		= xfs_vn_setattr,
-	.setxattr		= generic_setxattr,
-	.getxattr		= generic_getxattr,
-	.removexattr		= generic_removexattr,
 	.listxattr		= xfs_vn_listxattr,
 	.update_time		= xfs_vn_update_time,
 };
diff --git a/include/linux/fs.h b/include/linux/fs.h
index 91a7245..788261b 100644
--- a/include/linux/fs.h
+++ b/include/linux/fs.h
@@ -1739,12 +1739,7 @@ struct inode_operations {
 			struct inode *, struct dentry *, unsigned int);
 	int (*setattr) (struct dentry *, struct iattr *);
 	int (*getattr) (struct vfsmount *mnt, struct dentry *, struct kstat *);
-	int (*setxattr) (struct dentry *, struct inode *,
-			 const char *, const void *, size_t, int);
-	ssize_t (*getxattr) (struct dentry *, struct inode *,
-			     const char *, void *, size_t);
 	ssize_t (*listxattr) (struct dentry *, char *, size_t);
-	int (*removexattr) (struct dentry *, const char *);
 	int (*fiemap)(struct inode *, struct fiemap_extent_info *, u64 start,
 		      u64 len);
 	int (*update_time)(struct inode *, struct timespec *, int);
diff --git a/include/linux/xattr.h b/include/linux/xattr.h
index 6ae6b2e..e77605a 100644
--- a/include/linux/xattr.h
+++ b/include/linux/xattr.h
@@ -55,11 +55,7 @@ int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
 int __vfs_removexattr(struct dentry *, const char *);
 int vfs_removexattr(struct dentry *, const char *);
 
-ssize_t generic_getxattr(struct dentry *dentry, struct inode *inode, const char *name, void *buffer, size_t size);
 ssize_t generic_listxattr(struct dentry *dentry, char *buffer, size_t buffer_size);
-int generic_setxattr(struct dentry *dentry, struct inode *inode,
-		     const char *name, const void *value, size_t size, int flags);
-int generic_removexattr(struct dentry *dentry, const char *name);
 ssize_t vfs_getxattr_alloc(struct dentry *dentry, const char *name,
 			   char **xattr_value, size_t size, gfp_t flags);
 
diff --git a/mm/shmem.c b/mm/shmem.c
index 971fc83..6505c8b 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3288,10 +3288,7 @@ static const struct inode_operations shmem_short_symlink_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= simple_get_link,
 #ifdef CONFIG_TMPFS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= shmem_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
 
@@ -3299,10 +3296,7 @@ static const struct inode_operations shmem_symlink_inode_operations = {
 	.readlink	= generic_readlink,
 	.get_link	= shmem_get_link,
 #ifdef CONFIG_TMPFS_XATTR
-	.setxattr	= generic_setxattr,
-	.getxattr	= generic_getxattr,
 	.listxattr	= shmem_listxattr,
-	.removexattr	= generic_removexattr,
 #endif
 };
 
@@ -3796,10 +3790,7 @@ static const struct inode_operations shmem_inode_operations = {
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
@@ -3818,10 +3809,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
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
@@ -3831,10 +3819,7 @@ static const struct inode_operations shmem_dir_inode_operations = {
 
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
index e54d871..6c53778 100644
--- a/net/socket.c
+++ b/net/socket.c
@@ -528,7 +528,6 @@ static ssize_t sockfs_listxattr(struct dentry *dentry, char *buffer,
 }
 
 static const struct inode_operations sockfs_inode_ops = {
-	.getxattr = generic_getxattr,
 	.listxattr = sockfs_listxattr,
 };
 
-- 
2.7.4
