Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 0/9] Overlayfs create object related fixes
Date: Fri, 18 May 2018 11:29:28 +0300
Message-Id: <1526632177-28832-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

This is v4 of create object fixes, which addresses your comments on v3
and implement Vivek's suggestion to use ovl_get_inode() from create code.
Please note the change of semantics in ovl_instantiate() w.r.t the
reference on @inode argument - it now takes its own reference only if it
uses @inode to instantiate newdentry.

The series is based and tested on top of a merge of overlayfs-rorw
and Al's fixes branch.  It passed xfstests generic/quick and overlay/auto
including overlay/stress and all unionmount configurations.

Thanks,
Amir.

Changes since v3:
- Back to Al's version of ovl_create_real()
- Remvoe helper ovl_create_real_dir()
- Add Vivek's ovl_get_inode() cleanup patch
- Use new iget5_prealloc()
- Remove cc: stable because this is not a critical fix

Changes since v2:
- Don't use d_instantiate_new() helper
- Explain inode hash race (Vivek)
- Relax WARN_ON() to pass overlay/019 test
- Create hepler ovl_create_real_dir()
- pr_warn() when real mkdir succeeds and lookup fails

Changes since v1:
- Rebase on top of Al's fixes branch
- Use d_instantiate_new() helper
- Add re-factoring + Al's vfs_mkdir() safely patch

Amir Goldstein (7):
  ovl: remove WARN_ON() real inode attributes mismatch
  ovl: strip debug argument from ovl_do_ helpers
  ovl: struct cattr cleanups
  ovl: create helper ovl_create_temp()
  ovl: make ovl_create_real() cope with vfs_mkdir() safely
  vfs: export alloc_inode() and destroy_inode()
  ovl: use iget5_prealloc() to hash a newly created inode

Miklos Szeredi (1):
  vfs: factor out iget5_prealloc()

Vivek Goyal (1):
  ovl: Pass argument to ovl_get_inode() in a structure

 fs/inode.c               | 133 +++++++++++++++++-------------
 fs/overlayfs/copy_up.c   |  34 +++-----
 fs/overlayfs/dir.c       | 209 +++++++++++++++++++++++++++++------------------
 fs/overlayfs/export.c    |   8 +-
 fs/overlayfs/inode.c     |  28 +++++--
 fs/overlayfs/namei.c     |  10 ++-
 fs/overlayfs/overlayfs.h |  64 ++++++++-------
 fs/overlayfs/super.c     |   9 +-
 include/linux/fs.h       |  14 +++-
 9 files changed, 299 insertions(+), 210 deletions(-)

-- 
2.7.4
