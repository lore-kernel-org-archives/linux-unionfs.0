Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/5] Nested overlay tests
Date: Mon, 30 Dec 2019 16:14:18 +0200
Message-Id: <20191230141423.31695-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jeff Layton <jlayton@poochiereds.net>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Hi Eryu,

This v2 post includes two more nested overlay tests.

As described in previous post [1] the purpose of these tests
is not so much to validate the setup of nested overlayfs, which
is a less common setup, but to provide test coverage for some
overlayfs fixes that were merge in v5.5-rc2 as well as some fixes
that have been posted since.

Specifically, test overlay/071 exercises a "nested xino setup".
This setup results in "xino bit overlflow", a corner case that did
not have test coverage until now. This test fails on current upstream
because of an overlayfs bug [2].

On top of that, both overlay/070 and overlay/071 fail on current
upstream, because of a /proc/locks format bug [3].

Thanks,
Amir.

[1] https://lore.kernel.org/fstests/20191221185149.17509-1-amir73il@gmail.com/
[2] https://marc.info/?l=linux-unionfs&m=157708323410613&w=2
[3] https://lore.kernel.org/linux-fsdevel/e5d1c0a5e5e92083d8ce0bc1e48194a6d70fb918.camel@kernel.org/

Amir Goldstein (5):
  overlay: create the overlay/nested test group
  overlay: test file handles with nested overlay over samefs lower
  overlay: test file handles with nested overlay over non-samefs lower
  overlay: test constant ino with nested overlay over samefs lower
  overlay: test constant ino with nested overlay over non-samefs lower

 tests/overlay/068     | 304 ++++++++++++++++++++++++++++++++++++++++
 tests/overlay/068.out |  50 +++++++
 tests/overlay/069     | 313 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/069.out |  50 +++++++
 tests/overlay/070     | 222 ++++++++++++++++++++++++++++++
 tests/overlay/070.out |   2 +
 tests/overlay/071     | 236 +++++++++++++++++++++++++++++++
 tests/overlay/071.out |   2 +
 tests/overlay/group   |   8 +-
 9 files changed, 1185 insertions(+), 2 deletions(-)
 create mode 100755 tests/overlay/068
 create mode 100644 tests/overlay/068.out
 create mode 100755 tests/overlay/069
 create mode 100644 tests/overlay/069.out
 create mode 100755 tests/overlay/070
 create mode 100644 tests/overlay/070.out
 create mode 100755 tests/overlay/071
 create mode 100644 tests/overlay/071.out

-- 
2.17.1
