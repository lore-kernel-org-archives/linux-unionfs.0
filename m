Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/4] Misc. fsck.overlay test fixes
Date: Tue, 28 May 2019 18:17:19 +0300
Message-Id: <20190528151723.12525-1-amir73il@gmail.com>
To: Eryu Guan <guaneryu@gmail.com>
Cc: zhangyi <yi.zhang@huawei.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Eryu,

This is a re-post for zhangyi's fsck.overlay test fixes from
October [1]. Based on my own code review of those patches, I have
made some minor modifications and added some more fixes.

I have been carrying the two patches by zhangyi in my dev branch
for a while. Without them running overlay tests with fsck.overlay
installed is failing some tests.

Zhangyi,

Please review my changes, some based on your suggestions.
Feel free to re-post "fsck.overlay stress test" and
"fsck.overlay exception tests". My goal with this posting
was just to fix failures of existing tests when fsck.overlay
is installed.

Thanks,
Amir.

Changes from v2:
- Dropped patches of new tests
- Move fsck exit code constants to common/config
- Fix _repair_scratch_fs

[1] https://marc.info/?l=fstests&m=153967515805435&w=2

Amir Goldstein (2):
  fstests: define constants for fsck exit codes
  overlay: fix _repair_scratch_fs

zhangyi (F) (2):
  overlay: correct fsck.overlay exit code
  overlay: fix exit code for some fsck.overlay valid cases

 common/config     | 11 +++++++++++
 common/overlay    | 36 ++++++++++++++++++++++++++++++++++
 common/rc         | 15 ++++++++++++---
 tests/overlay/045 | 46 ++++++++++++++++++++++++--------------------
 tests/overlay/046 | 49 ++++++++++++++++++++++++-----------------------
 tests/overlay/056 |  9 +++------
 6 files changed, 112 insertions(+), 54 deletions(-)

-- 
2.17.1
