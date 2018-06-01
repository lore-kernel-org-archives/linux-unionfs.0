Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] Overlayfs tests for consistent ro/rw fd
Date: Fri,  1 Jun 2018 13:44:15 +0300
Message-Id: <1527849857-22951-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Eryu,

These changes prepare overlay tests to pass on Miklos
overlayfs-next branch.

Running -g overlay/quick on master only test overlay/016
is failing and tests overlay/060 (from Vivek) and overlay/061
are not run.

With overlayfs-next, all -g overlay/quick tests run and pass.

Thanks,
Amir.

Amir Goldstein (2):
  overlay: nicer report when features are not supported
  overlay/016: split into two tests

 common/overlay        |  9 +++---
 tests/overlay/016     | 14 ---------
 tests/overlay/016.out |  3 --
 tests/overlay/061     | 85 +++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/061.out |  4 +++
 tests/overlay/group   |  1 +
 6 files changed, 95 insertions(+), 21 deletions(-)
 create mode 100755 tests/overlay/061
 create mode 100644 tests/overlay/061.out

-- 
2.7.4
