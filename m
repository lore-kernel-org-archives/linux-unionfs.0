Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/2] Fix failing overlay nonsamefs fstests
Date: Wed, 18 Apr 2018 17:16:56 +0300
Message-Id: <1524061018-20413-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Eryu,

The modified 3 tests were introduced to track a non-standard
behavior of overlayfs w.r.t. inode numbers with nonsamefs
configuration.

This behavior cannot be fixed with all underlying filesystems
unless user opts-in for the xino feature.

xino feature was introduced in kernel v4.17-rc1. This patch
set converts the tests to notrun instead of failing on old kernels
and opts-in for xino with new kernels.

FYI, Miklos has a patch set in review to fix the last of the
non-standard behavior tracking test that is still failing (overlay/016).
After that patch set is merged, all overlay tests will be expected to
pass on master - new era ;-)

Thanks,
Amir.

Amir Goldstein (2):
  common/rc: factor out _require_scratch_fs_option
  overlay/04{1,3,4}: enable xino feature

 common/rc         | 29 ++++++++++++++++++++++-------
 tests/overlay/041 | 15 +++++++++++----
 tests/overlay/043 | 13 ++++++++++---
 tests/overlay/044 | 15 +++++++++++----
 4 files changed, 54 insertions(+), 18 deletions(-)

-- 
2.7.4
