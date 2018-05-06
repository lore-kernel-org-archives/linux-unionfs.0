Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] Improve generic test coverage for overlayfs
Date: Sun,  6 May 2018 09:36:06 +0300
Message-Id: <1525588568-1714-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Eryu,

With current upstream kernel and xfs base FSTYP, this is the test coverage
I got from running: ./check -overlay -g generic/auto

Ran: 495; Not run: 192; Failures: 0

These patches improve test coverage by running and passing two more tests
and improving the reason in report for not running two of the tests.

Thanks,
Amir.

Amir Goldstein (2):
  common/rc: decouple xfs_io flink check from xfs_io -T check
  generic/{159,160}: require chattr instead of lsattr

 common/rc         | 15 +++++++++++----
 tests/btrfs/058   |  4 +---
 tests/generic/004 |  1 +
 tests/generic/159 |  2 +-
 tests/generic/160 |  2 +-
 tests/generic/389 |  1 +
 6 files changed, 16 insertions(+), 9 deletions(-)

-- 
2.7.4
