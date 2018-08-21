From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.19
Date: Tue, 21 Aug 2018 21:54:46 +0200
Message-ID: <20180821195446.GA9512@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-4.19

This contains two new features:

 1) Stack file operations: this allows removal of several hacks from the
    VFS, proper interaction of read-only open files with copy-up,
    possibility to implement fs modifying ioctls properly, and others.

 2) Metadata only copy-up: when file is on lower layer and only metadata is
    modified (except size) then only copy up the metadata and continue to
    use the data from the lower file.

The vfs bits have been reworked based on Al's open cleanup work.

Thanks,
Miklos

----------------------------------------------------------------
Al Viro (1):
      new helper: open_with_fake_path()

Amir Goldstein (1):
      ovl: fix wrong use of impure dir cache in ovl_iterate()

Miklos Szeredi (36):
      vfs: limit size of dedupe
      vfs: dedupe: return int
      vfs: dedupe: rationalize args
      vfs: dedupe: extract helper for a single dedup
      vfs: make open_with_fake_path() not contribute to nr_files
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
      ovl: obsolete "check_copy_up" module option
      ovl: fix documentation of non-standard behavior

Vivek Goyal (28):
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
      ovl: add helper to force data copy-up
      ovl: Do not do metadata only copy-up for truncate operation
      ovl: Do not do metacopy only for ioctl modifying file attr
      ovl: Enable metadata only feature

 Documentation/filesystems/Locking       |   3 +-
 Documentation/filesystems/overlayfs.txt |  81 +++--
 Documentation/filesystems/vfs.txt       |  16 +-
 fs/btrfs/ctree.h                        |   5 +-
 fs/btrfs/ioctl.c                        |  11 +-
 fs/file_table.c                         |  69 +++--
 fs/inode.c                              |  46 +--
 fs/internal.h                           |  11 +-
 fs/ioctl.c                              |   1 +
 fs/locks.c                              |  20 +-
 fs/namei.c                              |   2 +-
 fs/namespace.c                          |  69 +----
 fs/ocfs2/file.c                         |  17 +-
 fs/open.c                               |  44 +--
 fs/overlayfs/Kconfig                    |  19 ++
 fs/overlayfs/Makefile                   |   4 +-
 fs/overlayfs/copy_up.c                  | 190 ++++++++----
 fs/overlayfs/dir.c                      | 105 +++++--
 fs/overlayfs/export.c                   |   3 +
 fs/overlayfs/file.c                     | 511 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    | 175 +++++++----
 fs/overlayfs/namei.c                    | 195 +++++++-----
 fs/overlayfs/overlayfs.h                |  47 ++-
 fs/overlayfs/ovl_entry.h                |   6 +-
 fs/overlayfs/readdir.c                  |  19 +-
 fs/overlayfs/super.c                    | 103 ++++---
 fs/overlayfs/util.c                     | 252 +++++++++++++++-
 fs/read_write.c                         |  94 +++---
 fs/xattr.c                              |   9 +-
 fs/xfs/xfs_file.c                       |  29 +-
 include/linux/dcache.h                  |  15 +-
 include/linux/fs.h                      |  29 +-
 include/linux/fsnotify.h                |  14 +-
 33 files changed, 1619 insertions(+), 595 deletions(-)
 create mode 100644 fs/overlayfs/file.c
