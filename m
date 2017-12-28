From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH xfstest v2 0/4] overlay: add fsck.overlay basic tests
Date: Thu, 28 Dec 2017 19:49:29 +0800
Message-ID: <20171228114933.47759-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:3242 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751411AbdL1LmV (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 28 Dec 2017 06:42:21 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Hi all:

Here is the second version of test cases for the upcoming fsck.overlay,
corresponding to fsck.overlay v3. Test fsck.overlay check and fix
inconsistency of whiteout/redirect directory/impure xattr.

Changes since v1:

- Fix _check_scratch_fs hook.
- Remove valid/invalid opaque xattr test.
- Add whiteout test cases of valid/invalid whiteouts in opaque/redirect
  parent directory.
- Add impure xattr test.


zhangyi (F) (4):
  overlay: add filesystem check helper
  overlay: add fsck.overlay whiteout test
  overlay: add fsck.overlay redirect directory test
  overlay: add fsck.overlay impure xattr test

 common/config         |   1 +
 common/overlay        |  80 +++++++++++++++++
 common/rc             |   4 +-
 tests/overlay/201     | 232 +++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/201.out |  10 +++
 tests/overlay/202     | 234 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/202.out |  10 +++
 tests/overlay/203     | 124 ++++++++++++++++++++++++++
 tests/overlay/203.out |   3 +
 tests/overlay/group   |   3 +
 10 files changed, 699 insertions(+), 2 deletions(-)
 create mode 100755 tests/overlay/201
 create mode 100644 tests/overlay/201.out
 create mode 100755 tests/overlay/202
 create mode 100644 tests/overlay/202.out
 create mode 100755 tests/overlay/203
 create mode 100644 tests/overlay/203.out

-- 
2.5.0
