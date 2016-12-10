From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] vfs prep for overlayfs update
Date: Sat, 10 Dec 2016 21:24:55 +0100
Message-ID: <20161210202455.GI2622@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Al,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git vfs-ovl

These are the bits of the upcoming overlayfs update that touch vfs/mm/af_unix.

 - Revert d_real_inode() comparisons that became obsolete;
 - add support for clone on copy-up;
 - add support for consistency of read/mmap after copy-up.

Thanks,
Miklos

---
Amir Goldstein (3):
      vfs: allow vfs_clone_file_range() across mount points
      vfs: call vfs_clone_file_range() under freeze protection
      vfs: fix vfs_clone_file_range() for overlayfs files

Miklos Szeredi (6):
      Revert "af_unix: fix hard linked sockets on overlay"
      Revert "vfs: rename: check backing inode being equal"
      vfs: no mnt_want_write_file() in vfs_{copy,clone}_file_range()
      vfs: allow overlayfs to intercept file ops
      vfs: export filp_clone_open()
      mm: ovl: copy-up on MAP_SHARED

---
 fs/internal.h        |  1 -
 fs/ioctl.c           |  6 +++++-
 fs/namei.c           |  6 +-----
 fs/nfsd/vfs.c        |  3 +--
 fs/open.c            |  2 +-
 fs/overlayfs/inode.c | 18 ++++++++++++++++++
 fs/read_write.c      | 23 ++++++++++-------------
 include/linux/fs.h   | 14 ++++++++++++++
 mm/util.c            | 22 ++++++++++++++++++++++
 net/unix/af_unix.c   |  6 +++---
 10 files changed, 75 insertions(+), 26 deletions(-)
