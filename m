From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH 0/4] overlay: add fsck.overlay basic tests
Date: Thu, 25 Jan 2018 14:34:09 +0800
Message-ID: <20180125063413.8720-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <fstests-owner@vger.kernel.org>
Sender: fstests-owner@vger.kernel.org
To: eguan@redhat.com
Cc: fstests@vger.kernel.org, linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-Id: linux-unionfs@vger.kernel.org

Hi Eryu:

This is the test cases for the fsck.overlay[1] split from my original
patchset[2]. These cases test orphan whiteout, invalid/duplicate reiderct
dirs and missing impure xattr, and these works (run) only if fsck.overlay
exists.

This revision have already completed review by Amir. Do you mind to do
a review and merge into HEAD ?

Thanks,
Yi.

[1] https://github.com/hisilicon/overlayfs-progs
[2] https://www.spinics.net/lists/linux-unionfs/msg03988.html

zhangyi (F) (4):
  overlay: add filesystem check helper
  overlay: add fsck.overlay whiteout test
  overlay: add fsck.overlay redirect directory test
  overlay: add fsck.overlay impure xattr test

 common/config         |   1 +
 common/overlay        |  14 +++
 tests/overlay/201     | 232 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/201.out |  10 ++
 tests/overlay/202     | 269 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/202.out |  11 +++
 tests/overlay/203     | 143 +++++++++++++++++++++++++++
 tests/overlay/203.out |   4 +
 tests/overlay/group   |   3 +
 9 files changed, 687 insertions(+)
 create mode 100755 tests/overlay/201
 create mode 100644 tests/overlay/201.out
 create mode 100755 tests/overlay/202
 create mode 100644 tests/overlay/202.out
 create mode 100755 tests/overlay/203
 create mode 100644 tests/overlay/203.out

-- 
2.5.0
