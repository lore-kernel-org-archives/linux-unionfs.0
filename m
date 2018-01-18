From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstest PATCH v4 0/7] overlay: add fsck.overlay basic tests
Date: Thu, 18 Jan 2018 12:00:26 +0800
Message-ID: <20180118040033.19555-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4660 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753017AbeARDxe (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 17 Jan 2018 22:53:34 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Hi All:

Here is the forth version of test cases for the upcoming fsck.overlay,
corresponding to fsck.overlay v4 (will post to github repository soon[1]).

Changes since v3:
- Modify minor suggestions in 202.
- Add _require_overlay_scratch_dirs helper.
- Replace _require_scratch helper in test cases that finished with
  corrupt filesystem and use optionally test dirs.

[1] https://github.com/hisilicon/overlayfs-progs

----------

Changes since v2:
- Modify some minor suggestions from Amir and Vivek, and simplify code
  in all three test cases.
- Fix duplicate redirect xattr test in 202.
- Add impure xattr test case of general merge directory in 'no impure'
  parent directory.
- Fix fs check failure in other overlay fs test cases. PS: The
  multi-lowers problem in overlay/010 also appears in many other tests,
  _require_scratch() will mis-check the pre-defined underlying dirs
  (not the real test dirs). I think they also need to be modified as this
  patch(06/07) does to check the correct dirs, and I can fix them if you
  think necessary.

Changes since v1:

- Fix _check_scratch_fs hook.
- Remove valid/invalid opaque xattr test.
- Add whiteout test cases of valid/invalid whiteouts in opaque/redirect
  parent directory.
- Add impure xattr test.

zhangyi (F) (7):
  overlay: add filesystem check helper
  overlay: add fsck.overlay whiteout test
  overlay: add fsck.overlay redirect directory test
  overlay: add fsck.overlay impure xattr test
  overlay/003: fix fs check failure
  overlay: skip check for tests finished with corrupt filesystem
  overlay: replace _require_scratch() in optionally dirs cases

 common/config         |   1 +
 common/overlay        |  88 +++++++++++++++++
 common/rc             |   4 +-
 tests/overlay/003     |   1 -
 tests/overlay/005     |   6 +-
 tests/overlay/010     |   6 +-
 tests/overlay/014     |  11 ++-
 tests/overlay/019     |   2 +-
 tests/overlay/031     |   2 +-
 tests/overlay/035     |   6 +-
 tests/overlay/036     |   5 +-
 tests/overlay/037     |   6 +-
 tests/overlay/038     |  10 +-
 tests/overlay/041     |  10 +-
 tests/overlay/043     |   6 +-
 tests/overlay/044     |   6 +-
 tests/overlay/201     | 232 +++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/201.out |  10 ++
 tests/overlay/202     | 269 ++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/overlay/202.out |  11 +++
 tests/overlay/203     | 143 +++++++++++++++++++++++++++
 tests/overlay/203.out |   4 +
 tests/overlay/group   |   3 +
 23 files changed, 827 insertions(+), 15 deletions(-)
 create mode 100755 tests/overlay/201
 create mode 100644 tests/overlay/201.out
 create mode 100755 tests/overlay/202
 create mode 100644 tests/overlay/202.out
 create mode 100755 tests/overlay/203
 create mode 100644 tests/overlay/203.out

-- 
2.9.5
