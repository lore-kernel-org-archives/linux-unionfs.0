Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/7] Sort out overlay ino numbers
Date: Wed,  1 Jan 2020 19:58:07 +0200
Message-Id: <20200101175814.14144-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

Most of this series is sorting out internal overlayfs messy code
having to do with i_ino.

The value of i_ino was very inconsistent in different setups, so this
series also sorts this out and adds documentation of expected values
for st_ino/d_ino/i_ino in different setups.

Patch #5 fixes a potential inode number collision bug (st_ino;st_dev).
It happens with the "less tested" case of xino bits overflow.
I have recently posted [1] some xfstests which also test overlay i_ino.
They require a /proc/locks fix that was merged to v5.5-rc4.
The test overlay/071 also tests a case of xino bits overflow.

Patch #6 includes a change of behavior, which auto enables xino for
tmpfs/xfs.

The series is available on branch ovl-ino on my github [2] and depends
on the previously posted ovl-layers pathces [3].

[1] https://lore.kernel.org/fstests/20191230141423.31695-1-amir73il@gmail.com
[2] https://github.com/amir73il/linux/commits/ovl-ino
[3] https://marc.info/?l=linux-unionfs&m=157700209100564&w=2

Amir Goldstein (7):
  ovl: fix value of i_ino for lower hardlink corner case
  ovl: fix out of date comment and unreachable code
  ovl: factor out helper ovl_get_root()
  ovl: simplify i_ino initialization
  ovl: avoid possible inode number collisions with xino=on
  ovl: enable xino automatically in more cases
  ovl: document xino expected behavior

 Documentation/filesystems/overlayfs.rst |  38 ++++++++-
 fs/overlayfs/inode.c                    | 101 ++++++++++++++++++------
 fs/overlayfs/overlayfs.h                |  21 ++++-
 fs/overlayfs/readdir.c                  |  17 ++--
 fs/overlayfs/super.c                    |  83 ++++++++++++-------
 fs/overlayfs/util.c                     |  20 -----
 6 files changed, 198 insertions(+), 82 deletions(-)

-- 
2.17.1
