Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/6] Overlayfs stacked f_op fixes
Date: Sun, 26 Aug 2018 19:25:11 +0300
Message-Id: <1535300717-26686-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

Following are fixes to some stacked f_op regressions, also
availabel on my ovl-fixes branch [1].

Patches 2-3 fix fiemap() and swapon() regressions detected
by xfstests.

Per your suggestion, f_mapping now points to the overlay
inode mapping and as a result, swapfile support is disabled on
an overlayfs file.
Also disabled is FIBMAP on an overlayfs file - not a big loss.

Patch 1 adds the vfs helper file_real() to access overlayfs
real file and patches 4-6 use this helper to untangle from
the f_mapping change.

Please note that patch 4 fixes a problem that was verified
with an LTP test [2], but patches 5-6 fix theoretical problems
that I have not yet demonstrated with a test.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-fixes
[2] https://github.com/amir73il/ltp/commits/overlayfs-devel

Amir Goldstein (6):
  vfs: add helper to get "real" overlayfs file
  ovl: respect FIEMAP_FLAG_SYNC flag
  ovl: fix GPF in swapfile_activate of file from overlayfs over xfs
  vfs: fix readahead syscall on an overlayfs file
  vfs: fix fadvise64 syscall on an overlayfs file
  vfs: fix sync_file_range syscall on an overlayfs file

 fs/overlayfs/file.c  |  4 +---
 fs/overlayfs/inode.c | 10 ++++++++++
 fs/sync.c            | 14 ++++++++++----
 include/linux/fs.h   | 27 +++++++++++++++++++++++++++
 mm/fadvise.c         | 34 ++++++++++++++++++++--------------
 mm/readahead.c       |  9 +++++++--
 6 files changed, 75 insertions(+), 23 deletions(-)

-- 
2.7.4
