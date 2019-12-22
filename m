Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/5] Sort out overlay layers and fs arrays
Date: Sun, 22 Dec 2019 10:07:54 +0200
Message-Id: <20191222080759.32035-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

This is the promised follow up to "fix corner case of non-unique
st_dev;st_ino" that was merged to v5.5-rc2.
The full details are available in the 1st posting of this patch set [1].

These patches have been tested with many different layer configurations
using the tests in [2][3] among them also configurations of multi lower
layer, where some lower fs are on safe fs as upper.

Note that this patchset introduces a change of behavior for overlayfs.
stat(2) on pure upper objects no longer report the real st_dev.
Upper fs is now also assigned a pseudo dev number, like all lower fs
and it is used when reporting stat(2) for pure upper objects as well as
for objects on lower layer which uses the same fs as upper fs.

These patches are also available on my github ovl-layers branch [4].
As mentioned before, I have a follow up series on branch ovl-ino [5]
that fixes another rare case of st_dev;st_ino collision and some more
improvements and fixes to xino. I still did not complete the tests for
that follow up series.

Thanks,
Amir.

Changes since v1:
- "fix corner case of non-unique st_dev;st_ino" already merged
- Replaced maxfsid notation with numfsid


[1] https://marc.info/?l=linux-unionfs&m=157400544101251&w=2
[2] https://github.com/amir73il/xfstests/commits/ovl-nested
[3] https://github.com/amir73il/unionmount-testsuite/commits/ovl-nested
[4] https://github.com/amir73il/linux/commits/ovl-layers
[5] https://github.com/amir73il/linux/commits/ovl-ino

Amir Goldstein (5):
  ovl: generalize the lower_layers[] array
  ovl: simplify ovl_same_sb() helper
  ovl: generalize the lower_fs[] array
  ovl: fix corner case of conflicting lower layer uuid
  ovl: fix corner case of non-constant st_dev;st_ino

 fs/overlayfs/export.c    |   6 +-
 fs/overlayfs/inode.c     |  43 +++++---------
 fs/overlayfs/namei.c     |  10 ++--
 fs/overlayfs/overlayfs.h |  23 ++++++-
 fs/overlayfs/ovl_entry.h |  15 +++--
 fs/overlayfs/readdir.c   |  11 ++--
 fs/overlayfs/super.c     | 125 ++++++++++++++++++++++-----------------
 fs/overlayfs/util.c      |  18 ++----
 8 files changed, 134 insertions(+), 117 deletions(-)

-- 
2.17.1
