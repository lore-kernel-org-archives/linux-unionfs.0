Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/6] Overlayfs stacked f_op fixes
Date: Mon, 27 Aug 2018 15:55:58 +0300
Message-Id: <1535374564-8257-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Dave Chinner <david@fromorbit.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

Following are fixes to some stacked f_op regressions, also
available on my ovl-fixes branch [1].

Patches 1-2 fix fiemap() and swapon() regressions detected
by xfstests (no change from v2).

Patches 3-6 implement the fadvise() file operation in overlayfs
to fix fadvise64(2) and readahead(2) syscalls, per your suggestion.

Correctness and error cases of readahead(2) were verified with the LTP
readahead tests including a new overlayfs readahead test [2].
Error cases of fadvise64(2) were verified with the LTP fadvise tests,
but correctness is not yet covered by those tests.

Thanks,
Amir.

Changes from v2:
- avoid file_real() vfs hack
- implement ovl_fadvise()
- update vfs.txt

[1] https://github.com/amir73il/linux/commits/ovl-fixes
[2] https://github.com/amir73il/ltp/commits/overlayfs-devel

Amir Goldstein (6):
  ovl: respect FIEMAP_FLAG_SYNC flag
  ovl: fix GPF in swapfile_activate of file from overlayfs over xfs
  Documentation/filesystems: update documentation of file_operations to
    kernel 4.18
  vfs: add the fadvise() file operation
  vfs: implement readahead(2) using POSIX_FADV_WILLNEED
  ovl: add ovl_fadvise()

 Documentation/filesystems/vfs.txt | 25 +++++++++++--
 fs/overlayfs/file.c               | 21 +++++++++--
 fs/overlayfs/inode.c              | 10 +++++
 include/linux/fs.h                |  5 +++
 mm/fadvise.c                      | 78 ++++++++++++++++++++++-----------------
 mm/readahead.c                    | 28 ++++++--------
 6 files changed, 110 insertions(+), 57 deletions(-)

-- 
2.7.4
