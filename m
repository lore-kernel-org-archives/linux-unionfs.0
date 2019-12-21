Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/3] Nested overlay exportfs tests
Date: Sat, 21 Dec 2019 20:51:46 +0200
Message-Id: <20191221185149.17509-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Eryu,

There is a somewhat convoluted story behind those tests...

At the time when overlay NFS export support was merged (v4.16),
nested overlay NFS export was not supported, because of the requirement
that all layers must have non null s_uuid. I had private patches to add
support for nested overlay NFS export, which I tested with these tests.

In kernel v4.20, commit 9df085f3c9a2 ("ovl: relax requirement for non
null uuid ...") was merged to enable NFS export of overlayfs with lower
squashfs. As a by-product from this change, nested overlay NFS export
is since supported.

v5.5-rc2 includes a fix to the v4.20 commit above ("ovl: fix lookup
failure on multi lower squashfs"). I used these tests to verify that
the change did not break the single lower layer with no uuid case.

v5.5-rc2 also includes a fix to how overlayfs encodes file handles in
memory ("ovl: make sure that real fid is 32bit aligned in memory").
I also use those test to verify this change and they flushed out several
bugs in my initial implementation that the existing overlay/exportfs
test did not catch.

Since those test have proven to be useful in catching bugs not directly
related to the less interesting case of nested overlay NFS export, I
decided it is now prime time for me to post them.

Thanks,
Amir.

Amir Goldstein (3):
  overlay: create the overlay/nested test group
  overlay: test file handles with nested overlay on the same fs
  overlay: test file handles with nested overlay on another fs

 tests/overlay/068     | 304 +++++++++++++++++++++++++++++++++++++++++
 tests/overlay/068.out |  50 +++++++
 tests/overlay/069     | 306 ++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/069.out |  50 +++++++
 tests/overlay/group   |   6 +-
 5 files changed, 714 insertions(+), 2 deletions(-)
 create mode 100755 tests/overlay/068
 create mode 100644 tests/overlay/068.out
 create mode 100755 tests/overlay/069
 create mode 100644 tests/overlay/069.out

-- 
2.17.1
