From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.18
Date: Tue, 29 May 2018 15:21:48 +0200
Message-ID: <20180529132148.GC23785@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Al,

I'm sending this pull request to you instead of Linus, because a bigger than
usual chunk involves the VFS.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git for-viro

This update contains the following:

 - Deal with vfs_mkdir() not instantiating dentry.

 - Stack file operations.  This solves the ro/rw file descriptor inconsistency,
   weirdness with ioctl, as well as removing a bunch of overlay specific hacks
   from the VFS.

 - Allow metadata-only copy-up when data is unchanged.

 - Various cleanups in VFS and overlayfs.

Thanks,
Miklos

---
Amir Goldstein (8):
      ovl: update documentation for unionmount-testsuite
      ovl: remove WARN_ON() real inode attributes mismatch
      ovl: strip debug argument from ovl_do_ helpers
      ovl: struct cattr cleanups
      ovl: return dentry from ovl_create_real()
      ovl: create helper ovl_create_temp()
      ovl: make ovl_create_real() cope with vfs_mkdir() safely
      ovl: use inode_insert5() to hash a newly created inode

Miklos Szeredi (41):
      ovl: clean up copy-up error paths
      vfs: factor out inode_insert5()
      vfs: dedpue: return loff_t
      vfs: dedupe: rationalize args
      vfs: dedupe: extract helper for a single dedup
      vfs: add path_open()
      vfs: optionally don't account file in nr_files
      vfs: add f_op->pre_mmap()
      vfs: export vfs_ioctl() to modules
      vfs: export vfs_dedupe_file_range_one() to modules
      ovl: copy up times
      ovl: copy up inode flags
      Revert "Revert "ovl: get_write_access() in truncate""
      ovl: copy up file size as well
      ovl: deal with overlay files in ovl_d_real()
      ovl: stack file ops
      ovl: add helper to return real file
      ovl: add ovl_read_iter()
      ovl: add ovl_write_iter()
      ovl: add ovl_fsync()
      ovl: add ovl_mmap()
      ovl: add ovl_fallocate()
      ovl: add lsattr/chattr support
      ovl: add ovl_fiemap()
      ovl: add O_DIRECT support
      ovl: add reflink/copyfile/dedup support
      vfs: don't open real
      ovl: copy-up on MAP_SHARED
      ovl: obsolete "check_copy_up" module option
      ovl: fix documentation of non-standard behavior
      vfs: simplify dentry_open()
      Revert "ovl: fix may_write_real() for overlayfs directories"
      Revert "ovl: don't allow writing ioctl on lower layer"
      vfs: fix freeze protection in mnt_want_write_file() for overlayfs
      Revert "ovl: fix relatime for directories"
      Revert "vfs: update ovl inode before relatime check"
      Revert "vfs: add flags to d_real()"
      Revert "vfs: do get_write_access() on upper layer of overlayfs"
      Partially revert "locks: fix file locking on overlayfs"
      Revert "fsnotify: support overlayfs"
      vfs: remove open_flags from d_real()

Vivek Goyal (29):
      ovl: Pass argument to ovl_get_inode() in a structure
      ovl: Initialize ovl_inode->redirect in ovl_get_inode()
      ovl: Move the copy up helpers to copy_up.c
      ovl: Provide a mount option metacopy=on/off for metadata copyup
      ovl: During copy up, first copy up metadata and then data
      ovl: Copy up only metadata during copy up where it makes sense
      ovl: Add helper ovl_already_copied_up()
      ovl: A new xattr OVL_XATTR_METACOPY for file on upper
      ovl: Use out_err instead of out_nomem
      ovl: Modify ovl_lookup() and friends to lookup metacopy dentry
      ovl: Copy up meta inode data from lowest data inode
      ovl: Add helper ovl_dentry_lowerdata() to get lower data dentry
      ovl: Fix ovl_getattr() to get number of blocks from lower
      ovl: Store lower data inode in ovl_inode
      ovl: Add helper ovl_inode_realdata()
      ovl: Open file with data except for the case of fsync
      ovl: Do not expose metacopy only dentry from d_real()
      ovl: Move some dir related ovl_lookup_single() code in else block
      ovl: Check redirects for metacopy files
      ovl: Treat metacopy dentries as type OVL_PATH_MERGE
      ovl: Add an inode flag OVL_CONST_INO
      ovl: Do not set dentry type ORIGIN for broken hardlinks
      ovl: Set redirect on metacopy files upon rename
      ovl: Set redirect on upper inode when it is linked
      ovl: Check redirect on index as well
      ovl: Disbale metacopy for MAP_SHARED mmap()
      ovl: Do not do metadata only copy-up for truncate operation
      ovl: Do not do metacopy only for ioctl modifying file attr
      ovl: Enable metadata only feature

---
 Documentation/filesystems/Locking       |   4 +-
 Documentation/filesystems/overlayfs.txt |  97 ++++--
 Documentation/filesystems/vfs.txt       |  19 +-
 fs/btrfs/ctree.h                        |   5 +-
 fs/btrfs/ioctl.c                        |   7 +-
 fs/file_table.c                         |  13 +-
 fs/inode.c                              | 210 +++++--------
 fs/internal.h                           |  17 +-
 fs/ioctl.c                              |   1 +
 fs/locks.c                              |  20 +-
 fs/namei.c                              |   2 +-
 fs/namespace.c                          |  69 +----
 fs/ocfs2/file.c                         |  10 +-
 fs/open.c                               |  74 ++---
 fs/overlayfs/Kconfig                    |  40 +++
 fs/overlayfs/Makefile                   |   4 +-
 fs/overlayfs/copy_up.c                  | 273 +++++++++-------
 fs/overlayfs/dir.c                      | 312 +++++++++++++------
 fs/overlayfs/export.c                   |  11 +-
 fs/overlayfs/file.c                     | 530 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    | 203 ++++++++----
 fs/overlayfs/namei.c                    | 205 +++++++-----
 fs/overlayfs/overlayfs.h                | 119 ++++---
 fs/overlayfs/ovl_entry.h                |   7 +-
 fs/overlayfs/super.c                    | 134 +++++---
 fs/overlayfs/util.c                     | 252 ++++++++++++++-
 fs/read_write.c                         |  91 +++---
 fs/xattr.c                              |   9 +-
 fs/xfs/xfs_file.c                       |   8 +-
 include/linux/dcache.h                  |  15 +-
 include/linux/fs.h                      |  36 ++-
 include/linux/fsnotify.h                |  14 +-
 include/uapi/linux/fs.h                 |   1 -
 mm/util.c                               |   5 +
 34 files changed, 1981 insertions(+), 836 deletions(-)
 create mode 100644 fs/overlayfs/file.c
