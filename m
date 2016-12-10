From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.10
Date: Sat, 10 Dec 2016 21:49:26 +0100
Message-ID: <20161210204926.GL2622@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32916 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752165AbcLJUta (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 10 Dec 2016 15:49:30 -0500
Received: by mail-wm0-f68.google.com with SMTP id u144so2995303wmu.0
        for <linux-unionfs@vger.kernel.org>; Sat, 10 Dec 2016 12:49:30 -0800 (PST)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Al,

I usually send overlayfs pulls directly to Linus, but it it suits you, please
feel free to pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This update contains:

 - try to clone on copy-up;
 - allow renaming a directory;
 - fix data inconsistency of read-only fds after copy up;
 - misc cleanups and fixes.

Thanks,
Miklos

---
Al Viro (1):
      ovl: clean up kstat usage

Amir Goldstein (9):
      vfs: allow vfs_clone_file_range() across mount points
      vfs: call vfs_clone_file_range() under freeze protection
      vfs: fix vfs_clone_file_range() for overlayfs files
      ovl: use vfs_clone_file_range() for copy up if possible
      ovl: fix nested overlayfs mount
      ovl: check for emptiness of redirect dir
      ovl: show redirect_dir mount option
      ovl: create directories inside merged parent opaque
      ovl: fold ovl_copy_up_truncate() into ovl_copy_up()

Geliang Tang (1):
      ovl: fix return value of ovl_fill_super

Miklos Szeredi (32):
      Revert "af_unix: fix hard linked sockets on overlay"
      Revert "vfs: rename: check backing inode being equal"
      vfs: no mnt_want_write_file() in vfs_{copy,clone}_file_range()
      vfs: allow overlayfs to intercept file ops
      vfs: export filp_clone_open()
      mm: ovl: copy-up on MAP_SHARED
      ovl: update doc
      Revert "ovl: get_write_access() in truncate"
      ovl: rename ovl_rename2() to ovl_rename()
      ovl: treat special files like a regular fs
      ovl: don't check rename to self
      ovl: don't check sticky
      ovl: add ovl_dentry_is_whiteout()
      ovl: check lower existence when removing
      ovl: get rid of PURE type
      ovl: rename: simplify handling of lower/merged directory
      ovl: check lower existence of rename target
      ovl: simplify lookup
      ovl: use d_is_dir()
      ovl: split super.c
      ovl: check namelen
      ovl: consolidate lookup for underlying layers
      ovl: lookup redirects
      ovl: redirect on rename-dir
      ovl: allow redirect_dir to default to "on"
      ovl: allow setting max size of redirect
      ovl: opaque cleanup
      ovl: add infrastructure for intercepting file ops
      ovl: intercept read_iter
      ovl: intercept mmap
      ovl: intercept fsync
      Revert "ovl: Warn on copy up if a process has a R/O fd open to the lower file"

---
 Documentation/filesystems/overlayfs.txt |  23 +-
 fs/internal.h                           |   1 -
 fs/ioctl.c                              |   6 +-
 fs/namei.c                              |   6 +-
 fs/nfsd/vfs.c                           |   3 +-
 fs/open.c                               |   2 +-
 fs/overlayfs/Kconfig                    |  14 +
 fs/overlayfs/Makefile                   |   2 +-
 fs/overlayfs/copy_up.c                  |  95 ++----
 fs/overlayfs/dir.c                      | 375 ++++++++++++---------
 fs/overlayfs/inode.c                    | 305 +++++++++++++----
 fs/overlayfs/namei.c                    | 401 +++++++++++++++++++++++
 fs/overlayfs/overlayfs.h                |  64 ++--
 fs/overlayfs/ovl_entry.h                |  53 +++
 fs/overlayfs/super.c                    | 558 ++++----------------------------
 fs/overlayfs/util.c                     | 265 +++++++++++++++
 fs/read_write.c                         |  23 +-
 include/linux/fs.h                      |  14 +
 mm/util.c                               |  22 ++
 net/unix/af_unix.c                      |   6 +-
 20 files changed, 1391 insertions(+), 847 deletions(-)
 create mode 100644 fs/overlayfs/namei.c
 create mode 100644 fs/overlayfs/ovl_entry.h
 create mode 100644 fs/overlayfs/util.c
