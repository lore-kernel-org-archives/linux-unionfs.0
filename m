Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH 0/3] overlay: enhance fsck.overlay test cases
Date: Sat, 28 Jul 2018 16:42:39 +0800
Message-ID: <20180728084242.33918-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: guaneryu@gmail.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi All,

These are fsck.overlay program related patch set. The first patch correct
the exit code of fsck.overlay in the existing 3 test cases, the second
patch introduce a stress case to test stability, and the final patch add
some exception cases to test exception handling process of fsck.overlay.

The fsck.overlay program also was undate at:

https://github.com/hisilicon/overlayfs-progs/tree/next

All these three patches have been tested with the new fsck.overlay,
please review.

Thanks!
Yi.

zhangyi (F) (3):
  overlay: correct fsck.overlay exit code
  overlay: add fsck.overlay stress test
  overlay: add fsck.overlay exception tests

 common/config         |  10 +++
 tests/overlay/045     |  59 ++++++++-----
 tests/overlay/046     |  62 ++++++++-----
 tests/overlay/056     |  22 +++--
 tests/overlay/061     |  81 +++++++++++++++++
 tests/overlay/061.out |   2 +
 tests/overlay/062     | 236 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/062.out |  10 +++
 tests/overlay/group   |   2 +
 9 files changed, 433 insertions(+), 51 deletions(-)
 create mode 100755 tests/overlay/061
 create mode 100644 tests/overlay/061.out
 create mode 100755 tests/overlay/062
 create mode 100644 tests/overlay/062.out

-- 
2.5.0
