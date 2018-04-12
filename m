From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH 00/35] overlayfs: stack file operations
Date: Thu, 12 Apr 2018 17:07:51 +0200
Message-ID: <20180412150826.20988-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Up till now overlayfs didn't stack regular file operations.  Instead, when
a file was opened on an overlay, the file from one of the underlying layers
would be opened and any file operations performed would directly go to the
underlying file on a real filesystem.

This works well mostly, but various hacks were added to the VFS to work
around issues with this:

 - d_path() and friends
 - relatime handling
 - file locking
 - fsnotify
 - writecount handling

There are also issues that are unresolved before this patchset:

 - ioctl's that need write access but can be performed on a O_RDONLY fd
 - ro/rw inconsistency: file on lower layer opened for read-only will
   return stale data on read after copy-up and modification
 - ro/rw inconsistency for mmap: file on lower layer mapped shared will
   contain stale data after copy-up and modification

This patch series reverts the VFS hacks (with the exception of d_path) and
fixes the unresoved issues.  We need to keep d_path related hacks, because
memory maps are still not stacked, yet d_path() should keep working on
vma->vm_file->f_path.

No regressions were observed after running various test suites (xfstests,
ltp, unionmount-testsuite, pjd-fstest).

Performance impact of stacking was found to be minimal.  Memory use for
open overlay files increases by about 256bytes or 12%.

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw

Thanks,
Miklos
---

Miklos Szeredi (35):
  vfs: clean up dedup
  vfs: add path_open()
  vfs: optionally don't account file in nr_files
  ovl: copy up times
  ovl: copy up inode flags
  Revert "Revert "ovl: get_write_access() in truncate""
  ovl: copy up file size as well
  ovl: deal with overlay files in ovl_d_real()
  ovl: stack file ops
  ovl: add helper to return real file
  ovl: readd read_iter
  ovl: readd write_iter
  ovl: readd fsync
  ovl: readd mmap
  ovl: readd fallocate
  ovl: readd lsattr/chattr support
  ovl: readd fiemap
  ovl: readd O_DIRECT support
  ovl: readd reflink/copyfile/dedup support
  vfs: don't open real
  vfs: add f_op->pre_mmap()
  ovl: copy-up on MAP_SHARED
  vfs: simplify dentry_open()
  Revert "ovl: fix relatime for directories"
  Revert "vfs: update ovl inode before relatime check"
  Revert "ovl: fix may_write_real() for overlayfs directories"
  Revert "ovl: don't allow writing ioctl on lower layer"
  Revert "vfs: add flags to d_real()"
  Revert "vfs: do get_write_access() on upper layer of overlayfs"
  Revert "vfs: make argument of d_real_inode() const"
  Revert "vfs: add d_real_inode() helper"
  Partially revert "locks: fix file locking on overlayfs"
  Revert "fsnotify: support overlayfs"
  vfs: simplify d_op->d_real()
  ovl: fix documentation of non-standard behavior

 Documentation/filesystems/Locking       |   4 +-
 Documentation/filesystems/overlayfs.txt |  64 +++--
 Documentation/filesystems/vfs.txt       |  25 +-
 fs/file_table.c                         |  13 +-
 fs/inode.c                              |  46 +---
 fs/internal.h                           |  17 +-
 fs/ioctl.c                              |   1 +
 fs/locks.c                              |  20 +-
 fs/namei.c                              |   2 +-
 fs/namespace.c                          |  66 +----
 fs/open.c                               |  79 +++---
 fs/overlayfs/Kconfig                    |  21 ++
 fs/overlayfs/Makefile                   |   4 +-
 fs/overlayfs/dir.c                      |   5 +
 fs/overlayfs/file.c                     | 466 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    |  52 +++-
 fs/overlayfs/overlayfs.h                |  26 ++
 fs/overlayfs/ovl_entry.h                |   1 +
 fs/overlayfs/super.c                    |  82 +++---
 fs/overlayfs/util.c                     |  20 ++
 fs/read_write.c                         |  90 +++---
 fs/xattr.c                              |   9 +-
 include/linux/dcache.h                  |  41 +--
 include/linux/fs.h                      |  32 ++-
 include/linux/fsnotify.h                |  14 +-
 include/uapi/linux/fs.h                 |   1 -
 mm/util.c                               |   5 +
 27 files changed, 831 insertions(+), 375 deletions(-)
 create mode 100644 fs/overlayfs/file.c

-- 
2.14.3
