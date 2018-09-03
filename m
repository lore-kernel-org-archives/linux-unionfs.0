Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/3] Enable new features for more overlayfs setups
Date: Mon,  3 Sep 2018 09:12:08 +0300
Message-Id: <20180903061211.20830-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, =?UTF-8?q?Rafa=C5=82=20Mi=C5=82ecki?= <zajec5@gmail.com>, Ralph Sennhauser <ralph.sennhauser@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

The following series enables recent overlayfs features for the
case of lower with no uuid and in particular a nested overlay.
Several posts [1] [2] suggest that both squashfs as lower fs
and nested overlay are used by OpenWrt users.

Turns out it is rather easy to enable xino, index and nfs_export
for some common setups.

Persistent and consistent inode numbers for lower squashfs were
tested with unionmount test:
 run --ov --squashfs --verify

Tests for xino and NFS export with nested overlay are available
in my xfstests tree [3]. I did not test NFS export with lower squashfs -
leaving that to interesed OpenWrt users. Intereseted party can
use my ovl-nested [4] branch for testing.

I am not sure how many users need these features for nested overlay,
but nested overlay with index is a pre-requisite for multiple overlayfs
snapshots support.

Note that patch [3/3] is an optimization that is not required for
passing the nested exportfs xfstest tests, but could be useful for
real lower (under nested) fs with large file handle sizes.

Thanks,
Amir.

[1] https://lkml.org/lkml/2017/12/13/220
[2] https://www.spinics.net/lists/linux-unionfs/msg01682.html
[3] https://github.com/amir73il/xfstests/commits/ovl-nested
[4] https://github.com/amir73il/linux/commits/ovl-nested

Amir Goldstein (3):
  ovl: relax requirement for non null uuid of lower fs
  ovl: disable xino for some nested overlay cases
  ovl: compact nested ovl_fh

 fs/overlayfs/copy_up.c   | 20 +++++++++++++++-
 fs/overlayfs/export.c    | 15 ++++++++++--
 fs/overlayfs/namei.c     | 34 +++++++++++++++++++--------
 fs/overlayfs/overlayfs.h | 16 ++++++++++---
 fs/overlayfs/super.c     | 50 ++++++++++++++++++++++++++++++++++++----
 fs/overlayfs/util.c      | 14 ++++++++---
 6 files changed, 126 insertions(+), 23 deletions(-)

-- 
2.17.1
