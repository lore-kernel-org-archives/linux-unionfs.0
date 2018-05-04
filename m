From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [RFC PATCH 00/35] overlayfs: stack file operations
Date: Fri, 4 May 2018 17:23:26 +0200
Message-ID: <CAJfpegvnq-+wvmtfX65ts+9eRE-ONGcj6AJyRqhqF1Z=h9bOiA@mail.gmail.com>
References: <20180412150826.20988-1-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180412150826.20988-1-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: overlayfs <linux-unionfs@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, Vivek Goyal <vgoyal@redhat.com>, "J. R. Okajima" <hooanon05g@gmail.com>, Ritesh Harjani <riteshh@codeaurora.org>, Matthew Wilcox <willy@infradead.org>, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Apr 12, 2018 at 5:07 PM, Miklos Szeredi <mszeredi@redhat.com> wrote:

> Git tree is here:
>
>   git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-rorw

Thanks everyone for your review.

Force pushed new version to the above branch.

Hopefully no comment was missed (I didn't add more reverts yet, those
can wait).  I'll do a mailbomb as well next week and start processing
the metacopy patches.

Thanks,
Miklos
---

Miklos Szeredi (38):
      vfs: dedpue: return s64
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
      ovl: fix documentation of non-standard behavior

---
 Documentation/filesystems/Locking       |   4 +-
 Documentation/filesystems/overlayfs.txt |  60 ++--
 Documentation/filesystems/vfs.txt       |  19 +-
 fs/btrfs/ctree.h                        |   4 +-
 fs/btrfs/ioctl.c                        |   6 +-
 fs/file_table.c                         |  13 +-
 fs/inode.c                              |  46 +--
 fs/internal.h                           |  17 +-
 fs/ioctl.c                              |   1 +
 fs/locks.c                              |  20 +-
 fs/namei.c                              |   2 +-
 fs/namespace.c                          |  69 +----
 fs/ocfs2/file.c                         |  10 +-
 fs/open.c                               |  74 ++---
 fs/overlayfs/Kconfig                    |  21 ++
 fs/overlayfs/Makefile                   |   4 +-
 fs/overlayfs/dir.c                      |  33 ++-
 fs/overlayfs/file.c                     | 506 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    |  63 +++-
 fs/overlayfs/overlayfs.h                |  21 +-
 fs/overlayfs/ovl_entry.h                |   1 +
 fs/overlayfs/super.c                    |  65 ++--
 fs/overlayfs/util.c                     |  11 +-
 fs/read_write.c                         |  91 +++---
 fs/xattr.c                              |   9 +-
 fs/xfs/xfs_file.c                       |   8 +-
 include/linux/dcache.h                  |  15 +-
 include/linux/fs.h                      |  30 +-
 include/linux/fsnotify.h                |  14 +-
 include/uapi/linux/fs.h                 |   1 -
 mm/util.c                               |   5 +
 31 files changed, 886 insertions(+), 357 deletions(-)
 create mode 100644 fs/overlayfs/file.c
