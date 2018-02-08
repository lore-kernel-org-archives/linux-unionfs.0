From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v3 0/5] overlay: add fsck.overlay basic tests
Date: Thu, 8 Feb 2018 11:19:08 +0800
Message-ID: <20180208031913.14013-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga06-in.huawei.com ([45.249.212.32]:51454 "EHLO huawei.com"
        rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750767AbeBHDKm (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Feb 2018 22:10:42 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Hi Eryu:

This revision handle your comments in last iteration, please review.

Thanks,
Yi.

Changes since v2:
- Move overlayfs xattrs constants to common/overlay.
- Fix _require_attrs in 201 and 203.
- Fix syntax error in string compare, and modify fsck error handle.
- Modify some code style.

Changes since v1:
- improve _overlay_fsck_dirs helper to accept more than one options.

----------

Background:

This is the test cases for the fsck.overlay[1] to test orphan whiteout,
invalid/duplicate reiderct dirs, and the missing impure xattr. These
works only when fsck.overlay exists. (These patchset split form origin
patchset[2])

[1] https://github.com/hisilicon/overlayfs-progs
[2] https://www.spinics.net/lists/linux-unionfs/msg03988.html


zhangyi (F) (5):
  overlay: add filesystem check helper
  overlay: define common overlay xattr keys
  overlay: add fsck.overlay whiteout test
  overlay: add fsck.overlay redirect directory test
  overlay: add fsck.overlay impure xattr test

 common/config         |   1 +
 common/overlay        |  24 +++++
 tests/overlay/201     | 228 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/201.out |  10 ++
 tests/overlay/202     | 264 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/202.out |  11 +++
 tests/overlay/203     | 141 +++++++++++++++++++++++++++
 tests/overlay/203.out |   4 +
 tests/overlay/group   |   3 +
 9 files changed, 686 insertions(+)
 create mode 100755 tests/overlay/201
 create mode 100644 tests/overlay/201.out
 create mode 100755 tests/overlay/202
 create mode 100644 tests/overlay/202.out
 create mode 100755 tests/overlay/203
 create mode 100644 tests/overlay/203.out

-- 
2.5.0
