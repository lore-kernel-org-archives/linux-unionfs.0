From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH 0/5] overlay: add overlay filesystem dirs check
Date: Thu, 25 Jan 2018 14:39:44 +0800
Message-ID: <20180125063949.12916-1-yi.zhang@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:4697 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751109AbeAYGbg (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 25 Jan 2018 01:31:36 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, eguan@redhat.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com

Hi, All:

This patchset implement filesystem check for overlay filesystem, base on
my "overlay: add fsck.overlay basic tests" patchset and works only if
fsck.overlay[1] exists (otherwise not run).

Patch 1 improve and fix _is_mounted helper in common/rc.
Patch 2 hook fsck helper to _check_test_fs & _check_scratch_fs, and
introduce helpers for optionally scratch dirs.
Patch 3~5 modify overlay test cases to do fs check correctly.

This patchset split from my original patchset[2] which have several
iterations.

Changes from last[2]:
- Modify _is_mounted helper to hanlde $FSTYP and corresponding use
  in Patch 2.

Thanks,
Yi.

[1] https://github.com/hisilicon/overlayfs-progs
[2] https://www.spinics.net/lists/linux-unionfs/msg03988.html

zhangyi (F) (5):
  common/rc: improve mounted check helper
  overlay: hook filesystem check helper
  overlay/003: fix fs check failure
  overlay: skip check for tests finished with corrupt filesystem
  overlay: correct scratch dirs check

 common/overlay    | 120 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc         |  29 ++++++-------
 tests/overlay/003 |   1 -
 tests/overlay/005 |   6 ++-
 tests/overlay/010 |   6 ++-
 tests/overlay/014 |  10 ++++-
 tests/overlay/019 |   2 +-
 tests/overlay/031 |   2 +-
 tests/overlay/035 |   6 ++-
 tests/overlay/036 |   5 ++-
 tests/overlay/037 |   6 ++-
 tests/overlay/038 |  10 ++++-
 tests/overlay/041 |  10 ++++-
 tests/overlay/043 |   6 ++-
 tests/overlay/044 |   6 ++-
 15 files changed, 195 insertions(+), 30 deletions(-)

-- 
2.5.0
