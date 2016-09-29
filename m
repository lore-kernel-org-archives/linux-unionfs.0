From: Andreas Gruenbacher <agruenba@redhat.com>
Subject: [PATCH v6 00/16] Xattr inode operation removal
Date: Thu, 29 Sep 2016 17:48:29 +0200
Message-ID: <1475164125-28635-1-git-send-email-agruenba@redhat.com>
Return-path: <ecryptfs-owner@vger.kernel.org>
Sender: ecryptfs-owner@vger.kernel.org
To: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, linux-fsdevel@vger.kernel.org, Tyler Hicks <tyhicks@canonical.com>, ecryptfs@vger.kernel.org, linux-unionfs@vger.kernel.org, David Howells <dhowells@redhat.com>, Serge Hallyn <serge@hallyn.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, linux-ima-devel@lists.sourceforge.net, Paul Moore <paul@paul-moore.com>, Stephen Smalley <sds@tycho.nsa.gov>, Eric Paris <eparis@parisplace.org>, Casey Schaufler <casey@schaufler-ca.com>, Oleg Drokin <oleg.drokin@intel.com>, Andreas Dilger <andreas.dilger@intel.com>
List-Id: linux-unionfs@vger.kernel.org

This is version 6 of the xattr inode operation removal patch queue, rebased on
top of the fuse/xattr branch, which is ahead of v4.8-rc8.  This queue merges
cleanly with the current vfs for-next branch (6731cb0f).

The patches are available in git form at:

  https://git.kernel.org/cgit/linux/kernel/git/agruen/linux.git/log/?h=work.xattr

Changes since the previous posting:

 * Drop patch "fuse: Switch to generic xattr handlers" from this queue in favor
   of "fuse: Use generic xattr ops" from fuse/xattr.

--

The purpose of this series is to remove unnecessary differences between the
xattr implementations on different filesystems and to simplify things.  With
the exception of redirectors like fuse, overlayfs, and ecryptfs, all
filesystems perform some de-multiplexing based on the xattr name, so it makes
sense to make that the default; filesystems that don't do any de-multiplexing
can easily use a catch-all xattr handler.


The patch series is structured as follows:

 * The first ten patches fix a few minor things and convert the remaining
   filesystems over to use xattr handlers.

 * A new IOP_XATTR inode operations flag is introduced: the flag is set when an
   inode supports xattrs.  On most filesystems, the IOP_XATTR flag is
   automatically initialized correctly when the inode is allocated based on
   whether or not the s_xattr field in the inode's superblock is defined.
   Filesystems that support xattrs on some but not all inodes can clear the
   IOP_XATTR flag appropriately.

 * The IOP_XATTR flag is then used to get rid of the two remaining places where
   xattr inode operations other than the generic ones are used: bad inodes and
   libfs empty directories.

 * After that, we get rid of the remaining direct accesses to xattr inode
   operations.

 * Finally, we stop calling the xattr inode operations and remove them.

Note that these patches only remove the getxattr, setxattr, and removexattr
inode operations. The listxattr inode operation does not do any attribute name
de-multiplexing, and remains unchanged except for checking the new IOP_XATTR
flag as well now.


Thanks,
Andreas

Andreas Gruenbacher (16):
  xattr: Remove unnecessary NULL attribute name check
  jffs2: Remove jffs2_{get,set,remove}xattr macros
  hfs: Switch to generic xattr handlers
  kernfs: Switch to generic xattr handlers
  sockfs: getxattr: Fail with -EOPNOTSUPP for invalid attribute names
  sockfs: Get rid of getxattr iop
  ecryptfs: Switch to generic xattr handlers
  lustre: Switch to generic xattr handlers
  vfs: Move xattr_resolve_name to the front of fs/xattr.c
  vfs: Add IOP_XATTR inode operations flag
  vfs: Use IOP_XATTR flag for bad-inode handling
  libfs: Use IOP_XATTR flag for empty directory handling
  xattr: Add __vfs_{get,set,remove}xattr helpers
  vfs: Check for the IOP_XATTR flag in listxattr
  xattr: Stop calling {get,set,remove}xattr inode operations
  vfs: Remove {get,set,remove}xattr inode operations

 Documentation/filesystems/Locking                  |  24 +-
 Documentation/filesystems/vfs.txt                  |  45 ++--
 drivers/staging/lustre/lustre/llite/file.c         |   3 -
 .../staging/lustre/lustre/llite/llite_internal.h   |   7 +-
 drivers/staging/lustre/lustre/llite/llite_lib.c    |   1 +
 drivers/staging/lustre/lustre/llite/namei.c        |   6 -
 drivers/staging/lustre/lustre/llite/symlink.c      |   3 -
 drivers/staging/lustre/lustre/llite/xattr.c        |  42 +++-
 fs/9p/vfs_inode_dotl.c                             |   9 -
 fs/bad_inode.c                                     |  21 +-
 fs/btrfs/inode.c                                   |  12 -
 fs/cachefiles/bind.c                               |   4 +-
 fs/cachefiles/namei.c                              |   4 +-
 fs/ceph/dir.c                                      |   3 -
 fs/ceph/inode.c                                    |   6 -
 fs/cifs/cifsfs.c                                   |   9 -
 fs/ecryptfs/ecryptfs_kernel.h                      |   2 +
 fs/ecryptfs/inode.c                                |  67 ++++--
 fs/ecryptfs/main.c                                 |   1 +
 fs/ecryptfs/mmap.c                                 |  13 +-
 fs/ext2/file.c                                     |   3 -
 fs/ext2/namei.c                                    |   6 -
 fs/ext2/symlink.c                                  |   6 -
 fs/ext4/file.c                                     |   3 -
 fs/ext4/namei.c                                    |   6 -
 fs/ext4/symlink.c                                  |   9 -
 fs/f2fs/file.c                                     |   3 -
 fs/f2fs/namei.c                                    |  12 -
 fs/fuse/dir.c                                      |   9 -
 fs/gfs2/inode.c                                    |   9 -
 fs/hfs/attr.c                                      |  83 ++++---
 fs/hfs/hfs_fs.h                                    |   6 +-
 fs/hfs/inode.c                                     |   5 +-
 fs/hfs/super.c                                     |   1 +
 fs/hfsplus/dir.c                                   |   3 -
 fs/hfsplus/inode.c                                 |   3 -
 fs/inode.c                                         |   2 +
 fs/jffs2/dir.c                                     |   3 -
 fs/jffs2/file.c                                    |   3 -
 fs/jffs2/symlink.c                                 |   3 -
 fs/jffs2/xattr.h                                   |   6 -
 fs/jfs/file.c                                      |   3 -
 fs/jfs/namei.c                                     |   3 -
 fs/jfs/symlink.c                                   |   6 -
 fs/kernfs/dir.c                                    |   3 -
 fs/kernfs/inode.c                                  | 155 +++++++------
 fs/kernfs/kernfs-internal.h                        |   7 +-
 fs/kernfs/mount.c                                  |   1 +
 fs/kernfs/symlink.c                                |   3 -
 fs/libfs.c                                         |  29 +--
 fs/nfs/nfs3proc.c                                  |   6 -
 fs/nfs/nfs4proc.c                                  |   6 -
 fs/ocfs2/file.c                                    |   3 -
 fs/ocfs2/namei.c                                   |   3 -
 fs/ocfs2/symlink.c                                 |   3 -
 fs/orangefs/inode.c                                |   3 -
 fs/orangefs/namei.c                                |   3 -
 fs/orangefs/symlink.c                              |   1 -
 fs/orangefs/xattr.c                                |   3 +
 fs/overlayfs/copy_up.c                             |   4 +-
 fs/overlayfs/dir.c                                 |   3 -
 fs/overlayfs/inode.c                               |   6 -
 fs/overlayfs/super.c                               |   4 +-
 fs/reiserfs/file.c                                 |   3 -
 fs/reiserfs/namei.c                                |   9 -
 fs/squashfs/inode.c                                |   1 -
 fs/squashfs/namei.c                                |   1 -
 fs/squashfs/symlink.c                              |   1 -
 fs/squashfs/xattr.c                                |  19 +-
 fs/squashfs/xattr.h                                |   1 -
 fs/ubifs/dir.c                                     |   3 -
 fs/ubifs/file.c                                    |   6 -
 fs/xattr.c                                         | 250 ++++++++++-----------
 fs/xfs/xfs_iops.c                                  |  15 --
 include/linux/fs.h                                 |  23 +-
 include/linux/xattr.h                              |   7 +-
 mm/shmem.c                                         |  15 --
 net/socket.c                                       |  70 +++---
 security/commoncap.c                               |  25 +--
 security/integrity/evm/evm_crypto.c                |   7 +-
 security/integrity/evm/evm_main.c                  |   4 +-
 security/integrity/ima/ima_appraise.c              |  21 +-
 security/selinux/hooks.c                           |  19 +-
 security/smack/smack_lsm.c                         |  12 +-
 84 files changed, 536 insertions(+), 700 deletions(-)

-- 
2.7.4
