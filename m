From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.12
Date: Wed, 10 May 2017 15:39:58 +0200
Message-ID: <20170510133958.GB25454@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

The biggest part of this is making st_dev/st_ino on the overlay behave like a
normal filesystem (i.e. st_ino doesn't change on copy up, st_dev is the same for
all files and directories).  Currently this only works if all layers are on the
same filesystem, but future work will move the general case towards more sane
behavior.

There are also miscellaneous fixes, including fixes to handling append-only
files.  There's a small change in the VFS, but that only has an effect on
overlayfs, since otherwise file->f_path.dentry->inode and file_inode(file) are
always the same.

Thanks,
Miklos

---
Amir Goldstein (13):
      ovl: lockdep annotate of nested stacked overlayfs inode lock
      vfs: ftruncate check IS_APPEND() on real upper inode
      ovl: check IS_APPEND() on real upper inode
      ovl: do not set overlay.opaque on non-dir create
      ovl: check if all layers are on the same fs
      ovl: store file handle of lower inode on copy up
      ovl: use an auxiliary var for overlay root entry
      ovl: lookup non-dir copy-up-origin by file handle
      ovl: set the ORIGIN type flag
      ovl: persistent inode number for directories
      ovl: constant st_ino/st_dev across copy up
      ovl: persistent inode numbers for upper hardlinks
      ovl: update documentation w.r.t. constant inode numbers

Kees Cook (1):
      ovl: Use designated initializers

Miklos Szeredi (1):
      ovl: merge getattr for dir and nondir

---
 Documentation/filesystems/overlayfs.txt |   9 +-
 fs/open.c                               |   3 +-
 fs/overlayfs/copy_up.c                  |  82 +++++++++++++++++++
 fs/overlayfs/dir.c                      |  37 ++-------
 fs/overlayfs/inode.c                    | 103 ++++++++++++++++++++++-
 fs/overlayfs/namei.c                    | 141 ++++++++++++++++++++++++++++++--
 fs/overlayfs/overlayfs.h                |  41 ++++++++++
 fs/overlayfs/ovl_entry.h                |   2 +
 fs/overlayfs/super.c                    |  40 +++++++--
 fs/overlayfs/util.c                     |  19 +++--
 10 files changed, 425 insertions(+), 52 deletions(-)
