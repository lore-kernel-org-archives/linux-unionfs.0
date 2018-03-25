Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/3] Yet another overlayfs exportfs test
Date: Sun, 25 Mar 2018 17:53:08 +0300
Message-Id: <1521989591-9496-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Eryu,

This test should pass on upstream kernel.
It provides test coverage for a state of inode/dentry cache that
was not covered by previous tests.
I had to extend open_by_handle again to reproduce the uncovered
cache state.

Miklos,

I used tracing on index lookup with this test to verify correctness
of ("ovl: lookup in inode cache first when decoding lower file handle").
With your review fix, index lookup is called for non-dir after mount
cycle, but not called after opening by file handle again, when the
diconnected dentries are still in cache.

Thanks,
Amir.

Amir Goldstein (3):
  open_by_handle: add -n option to suppress drop caches
  open_by_handle: add -s option to sleep and keep files open by handle
  overlay: test decoding overlay file handles with warm/cold dentry
    cache

 src/open_by_handle.c  |  57 ++++++++++++++-------
 tests/overlay/058     | 137 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/058.out |   9 ++++
 tests/overlay/group   |   1 +
 4 files changed, 186 insertions(+), 18 deletions(-)
 create mode 100755 tests/overlay/058
 create mode 100644 tests/overlay/058.out

-- 
2.7.4
