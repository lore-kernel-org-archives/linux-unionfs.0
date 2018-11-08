Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/3] Enable new features for nested overlayfs setups
Date: Thu,  8 Nov 2018 13:49:39 +0200
Message-Id: <20181108114942.32531-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

Based on your feedback on v1 [1], following patches implement
"nested xino", where "nested" doesn't have to be overlayfs over
overlayfs. It can be overlayfs over another fs that publishes
ino domain information, or another stacked fs aware of ino
domains over overlayfs.

Series is available on my ovl-nested branch [2].
xfstests are also available on my github [3].
Note that the tests in group "overlay/exportfs.nested" already pass
on current master.

The test group "overlay/union" uses the xfstests harness to run
various unionmount-testsuite setups (e.g. samefs, non-samefs,
non-samefs with some layers on same fs). This test group requires
the symlink src/unionmount-testsuite to run the test suite.

Thanks,
Amir.

Changes since v1:
- "relax requirement for non null uuid" already merged
- Teach vfs about inode number domains
- Don't special case overlayfs as a lower fs

[1] https://marc.info/?l=linux-unionfs&m=154039437114960&w=2
[2] https://github.com/amir73il/linux/commits/ovl-nested
[3] https://github.com/amir73il/xfstests/commits/ovl-nested

Amir Goldstein (3):
  vfs: introduce the concept of inode number domains
  ovl: limit xino for some nested overlay cases
  ovl: relax xino for some nested overlay cases

 fs/overlayfs/ovl_entry.h |   7 +-
 fs/overlayfs/super.c     | 200 ++++++++++++++++++++++++++++++---------
 fs/overlayfs/util.c      |   2 +-
 fs/super.c               |   2 +
 include/linux/fs.h       |  18 +++-
 5 files changed, 179 insertions(+), 50 deletions(-)

-- 
2.17.1
