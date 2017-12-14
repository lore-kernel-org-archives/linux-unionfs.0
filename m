From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [PATCH for xfstests 0/4] overlay: add fsck.overlay basic tests
Date: Thu, 14 Dec 2017 14:48:42 +0800
Message-ID: <20171214064846.21587-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:2680 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751035AbdLNGmx (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 14 Dec 2017 01:42:53 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, darrick.wong@oracle.com, yi.zhang@huawei.com, miaoxie@huawei.com

Hi all:

Here is the test cases for fsck.overlay split from fsck.overlay program.
Add fsck helper and hook to _check_test_fs/_check_scratch_fs as Amir
suggested, it will work only if fsck.overlay exists. Implement three basic
cases to test fsck how to deal with whiteouts/opaque xattr/redirect xattr.

zhangyi (F) (4):
  overlay: add filesystem check helper
  overlay: add fsck.overlay whiteout test
  overlay: add fsck.overlay opaque directory test
  overlay: add fsck.overlay redirect directory test

 common/config         |   1 +
 common/overlay        |  78 +++++++++++++++++++++
 common/rc             |   4 +-
 tests/overlay/201     |  98 ++++++++++++++++++++++++++
 tests/overlay/201.out |   3 +
 tests/overlay/202     | 141 ++++++++++++++++++++++++++++++++++++++
 tests/overlay/202.out |   5 ++
 tests/overlay/203     | 185 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/203.out |   8 +++
 tests/overlay/group   |   3 +
 10 files changed, 524 insertions(+), 2 deletions(-)
 create mode 100755 tests/overlay/201
 create mode 100644 tests/overlay/201.out
 create mode 100755 tests/overlay/202
 create mode 100644 tests/overlay/202.out
 create mode 100755 tests/overlay/203
 create mode 100644 tests/overlay/203.out

-- 
2.5.0
