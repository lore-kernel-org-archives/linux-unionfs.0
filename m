Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/3] Improved FS_IOC_FSSETXATTR tests
Date: Tue, 11 Jun 2019 19:08:36 +0300
Message-Id: <20190611160839.14777-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "Darrick J . Wong" <darrick.wong@oracle.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Eryu,

Overlayfs gained support for FS_IOC_FSSETXATTR ioctl in v5.2-rc4
with buggy capability check. The fix is trivial so it should land
upstream soon.

This series adds a generic test to cover the bug in overlayfs v5.2-rc4.
It also adds a proper _require directive to test filesystem support
for FS_IOC_FSSETXATTR and let the tests that use this ioctl require
filesystem support for it.

The only existing generic test that needed this requirement is the
recently added generic/553 copy_range immutable file test. When run on
overlayfs over xfs/ext4/btrfs, generic/553 would fail instead of _notrun
with kernel v5.2-rc3.

But the requirement fix is not only for overlayfs, other filesystems
that support FS_IOC_SETFLAGS but not FS_IOC_FSSETXATTR (e.g. ext2),
need those fixes to _notrun generic/553.

Thanks,
Amir.


Amir Goldstein (3):
  fstests: print out xfs_io parameter when command fails
  fstests: check for filesystem FS_IOC_FSSETXATTR support
  generic: check CAP_LINUX_IMMUTABLE capability with FS_IOC_FSSETXATTR

 common/rc                    | 30 ++++++++++-----
 doc/requirement-checking.txt |  2 +-
 tests/generic/553            |  3 +-
 tests/generic/555            | 74 ++++++++++++++++++++++++++++++++++++
 tests/generic/555.out        |  9 +++++
 tests/generic/group          |  1 +
 tests/xfs/260                |  2 +-
 tests/xfs/431                |  2 +-
 8 files changed, 108 insertions(+), 15 deletions(-)
 create mode 100755 tests/generic/555
 create mode 100644 tests/generic/555.out

-- 
2.17.1
