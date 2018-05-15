Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/4] Overlayfs mkdir related fixes
Date: Tue, 15 May 2018 13:26:08 +0300
Message-Id: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

This is v3 of mkdir fixes, which addresses comments from Vivek
and yourself as well as fix some issues found in tests of v2.
The series is based and tested on top of a merge of overlayfs-rorw
and Al's fixes branch.

Thanks,
Amir.

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

Al Viro (1):
  ovl: make ovl_create_real() cope with vfs_mkdir() safely

Amir Goldstein (3):
  ovl: use insert_inode_locked4() to hash a newly created inode
  ovl: relax WARN_ON() real inode attributes mismatch
  ovl: create helper ovl_create_temp()

 fs/overlayfs/copy_up.c   |  27 +++-------
 fs/overlayfs/dir.c       | 125 +++++++++++++++++++++++++++++++++++------------
 fs/overlayfs/inode.c     |  18 +++++++
 fs/overlayfs/overlayfs.h |  12 ++++-
 fs/overlayfs/super.c     |   2 +-
 5 files changed, 130 insertions(+), 54 deletions(-)

-- 
2.7.4
