Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/4] Fix failing overlay nonsamefs fstests
Date: Wed, 25 Apr 2018 23:53:23 -0600
Message-Id: <1524722007-30891-1-git-send-email-amir73il@gmail.com>
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Eryu,

xino feature was introduced in kernel v4.17-rc1 to fix constant inode
numbers on non samefs setup. This patch set converts the relevant tests
to notrun instead of failing on old kernels and opts-in for xino with
new kernels.

The first patch is a re-factoring of helpers from v1 patches I ended
not using in v2 patches, but seems useful, so you may take it or leave
it out as you wish.

Thanks,
Amir.

Changes since v1:
- Fix fsck run failure in 041
- Fix missing redirect_dir requirement in 043
- Fix check for xino enabled

Amir Goldstein (4):
  common/rc: factor out _require_scratch_fs_option
  overlay/041: fix call to _overlay_check_scratch_dirs
  overlay/043: require and enable redirect_dir
  overlay/04{1,3,4}: enable xino feature

 common/rc         | 29 ++++++++++++++++++++++-------
 tests/overlay/041 | 21 +++++++++++++--------
 tests/overlay/043 | 17 ++++++++++++++---
 tests/overlay/044 | 16 ++++++++++++----
 4 files changed, 61 insertions(+), 22 deletions(-)

-- 
2.7.4
