From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.19-rc4
Date: Thu, 13 Sep 2018 20:30:30 +0200
Message-ID: <20180913183030.GB23439@veci.piliscsaba.redhat.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-4.19-rc4

This fixes a regression in the recent file stacking update, reported and fixed
by Amir Goldstein.  The fix is fairly trivial, but involves adding a fadvise()
f_op and the associated churn in the vfs.  As discussed on -fsdevel, there are
other possible uses for this method, than allowing proper stacking for overlays.

And there's one other fix for a syzkaller detected oops.

Thanks,
Miklos

---
Amir Goldstein (6):
      ovl: respect FIEMAP_FLAG_SYNC flag
      ovl: fix GPF in swapfile_activate of file from overlayfs over xfs
      Documentation/filesystems: update documentation of file_operations
      vfs: add the fadvise() file operation
      vfs: implement readahead(2) using POSIX_FADV_WILLNEED
      ovl: add ovl_fadvise()

Miklos Szeredi (1):
      ovl: fix oopses in ovl_fill_super() failure paths

---
 Documentation/filesystems/vfs.txt | 21 +++++++++-
 fs/overlayfs/file.c               | 23 +++++++++--
 fs/overlayfs/inode.c              | 10 +++++
 fs/overlayfs/super.c              | 26 +++++++------
 include/linux/fs.h                |  5 +++
 mm/Makefile                       |  3 +-
 mm/fadvise.c                      | 81 +++++++++++++++++++++++----------------
 mm/readahead.c                    | 45 ++++++++--------------
 8 files changed, 134 insertions(+), 80 deletions(-)
