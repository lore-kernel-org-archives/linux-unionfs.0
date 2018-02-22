Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [xfstests PATCH v4 0/5] overlay: add overlay filesystem dirs check
Date: Thu, 22 Feb 2018 10:18:29 +0800
Message-ID: <20180222021834.26145-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: eguan@redhat.com, fstests@vger.kernel.org
Cc: linux-unionfs@vger.kernel.org, miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi Eryu and Amir:

Sorry for the late, I have handle comments from last iteration in patch
{5,6}/6, patch 6/6 will post separately later, please review.

Thanks,
Yi.

Changes since v3:
- Move overlay checker after _unmount in overlay/{038,041}, and embed
  checker into unmount_dirs() in overlay/{051,053,055}.
- split out patch "overlay: correct test mount options"

Changes since v2:
- Rename _is_mounted to _is_dev_mounted and use findmnt instead of mount.
- Fix mistakes in patch 2/6 and introduce _is_dir_mountpoint helper, also
  introduce fsck options use for overlayfs.
- Add overlay/049 into patch 4/6 to skip fs check.
- Add nfs export cases into patch 5/6 to do correct dirs check.
- Add the "missing feature" of test mount options.

Changes since v1:
- Details comments in patch 1/5.
- Improve _overlay_check_scratch_dirs to accept extra options.
- Fix basic filesystem mounted check in _overlay_check_fs.
- Improve overlay/044 in patch 5/5 to add index=on option.

----------

Background:

This patchset implement filesystem check for overlay filesystem, base on
my "overlay: add fsck.overlay basic tests" patchset and works only if
fsck.overlay[1] exists (otherwise not run).

[1] https://github.com/hisilicon/overlayfs-progs


zhangyi (F) (5):
  common/rc: improve dev mounted check helper
  overlay: hook filesystem check helper
  overlay/003: fix fs check failure
  overlay: skip check for tests finished with corrupt filesystem
  overlay: correct scratch dirs check

 README.overlay    |  10 ++++-
 common/config     |   4 ++
 common/overlay    | 125 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 common/rc         |  47 +++++++++++---------
 common/xfs        |   2 +-
 tests/overlay/003 |   1 -
 tests/overlay/005 |   7 ++-
 tests/overlay/010 |   7 ++-
 tests/overlay/014 |  10 ++++-
 tests/overlay/019 |   2 +-
 tests/overlay/031 |   2 +-
 tests/overlay/035 |   7 ++-
 tests/overlay/036 |   6 ++-
 tests/overlay/037 |   7 ++-
 tests/overlay/038 |  10 ++++-
 tests/overlay/041 |  10 ++++-
 tests/overlay/043 |   7 ++-
 tests/overlay/044 |   8 +++-
 tests/overlay/049 |   2 +-
 tests/overlay/051 |  10 ++++-
 tests/overlay/053 |  10 ++++-
 tests/overlay/055 |  10 ++++-
 22 files changed, 260 insertions(+), 44 deletions(-)

-- 
2.5.0
