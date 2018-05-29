From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 00/11] overlayfs fixes
Date: Tue, 29 May 2018 16:41:32 +0200
Message-ID: <20180529144143.16378-1-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This series contains various fixes, including handling the case when
vfs_mkdir() returns success, but requires a new lookup for an instantiated
dentry.

---
Amir Goldstein (8):
  ovl: update documentation for unionmount-testsuite
  ovl: remove WARN_ON() real inode attributes mismatch
  ovl: strip debug argument from ovl_do_ helpers
  ovl: struct cattr cleanups
  ovl: return dentry from ovl_create_real()
  ovl: create helper ovl_create_temp()
  ovl: make ovl_create_real() cope with vfs_mkdir() safely
  ovl: use inode_insert5() to hash a newly created inode

Miklos Szeredi (2):
  ovl: clean up copy-up error paths
  vfs: factor out inode_insert5()

Vivek Goyal (1):
  ovl: Pass argument to ovl_get_inode() in a structure

 Documentation/filesystems/overlayfs.txt |   7 +-
 fs/inode.c                              | 164 ++++++++++++-------------
 fs/overlayfs/copy_up.c                  |  83 ++++---------
 fs/overlayfs/dir.c                      | 207 +++++++++++++++++++++-----------
 fs/overlayfs/export.c                   |   8 +-
 fs/overlayfs/inode.c                    |  28 +++--
 fs/overlayfs/namei.c                    |  10 +-
 fs/overlayfs/overlayfs.h                |  65 +++++-----
 fs/overlayfs/super.c                    |   9 +-
 include/linux/fs.h                      |   4 +
 10 files changed, 315 insertions(+), 270 deletions(-)

-- 
2.14.3
