Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 0/3] Overlayfs mkdir related fixes
Date: Sat, 12 May 2018 12:17:08 +0300
Message-Id: <1526116631-24186-1-git-send-email-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

This series supersedes the patch
"ovl: be more prudent when instantiating a new dentry",
which is based on overlayfs-rorw.

The series is based and tested on top of a merge of overlayfs-rorw and
Al's fixes branch and should apply pretty cleanly to fixes branch.

BTW, I noticed there is a small conflict between Al's for-next and
your dedupe-cleanup branch, so you might want to rebase that.

Thanks,
Amir.

Changes since v1:
- Rebase on top of Al's fixes branch
- Use d_instantiate_new() helper
- Add re-factoring + Al's vfs_mkdir() safely patch

Al Viro (1):
  ovl: make ovl_create_real() cope with vfs_mkdir() safely

Amir Goldstein (2):
  ovl: use d_instantiate_new() to instantiate a new dentry
  ovl: create helper ovl_create_temp()

 fs/overlayfs/copy_up.c   | 27 ++++----------
 fs/overlayfs/dir.c       | 96 +++++++++++++++++++++++++++++++++---------------
 fs/overlayfs/inode.c     |  6 +++
 fs/overlayfs/overlayfs.h | 12 +++++-
 fs/overlayfs/super.c     |  2 +-
 5 files changed, 90 insertions(+), 53 deletions(-)

-- 
2.7.4
