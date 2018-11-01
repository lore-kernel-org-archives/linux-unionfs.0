From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.20
Date: Thu, 1 Nov 2018 22:06:11 +0100
Message-ID: <20181101210611.GH23439@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-4.20

This contains a mix of fixes and cleanups.

Thanks,
Miklos

----------------------------------------------------------------
Amir Goldstein (7):
      ovl: fix error handling in ovl_verify_set_fh()
      vfs: fix FIGETBSZ ioctl on an overlayfs file
      ovl: fix recursive oi->lock in ovl_link()
      ovl: untangle copy up call chain
      ovl: relax requirement for non null uuid of lower fs
      ovl: remove the 'locked' argument of ovl_nlink_{start,end}
      ovl: abstract ovl_inode lock with a helper

Chengguang Xu (1):
      ovl: using posix_acl_xattr_size() to get size instead of posix_acl_to_xattr()

Miklos Szeredi (5):
      ovl: clean up error handling in ovl_get_tmpfile()
      ovl: relax permission checking on underlying layers
      ovl: fold copy-up helpers into callers
      ovl: check whiteout in ovl_create_over_whiteout()
      ovl: automatically enable redirect_dir on metacopy=on

---
 Documentation/filesystems/overlayfs.txt |   6 +
 fs/ioctl.c                              |   3 +
 fs/overlayfs/copy_up.c                  | 213 ++++++++++++++++++--------------
 fs/overlayfs/dir.c                      |  34 +++--
 fs/overlayfs/inode.c                    |  17 ++-
 fs/overlayfs/namei.c                    |   4 +-
 fs/overlayfs/overlayfs.h                |  14 ++-
 fs/overlayfs/super.c                    |  68 ++++++++--
 fs/overlayfs/util.c                     |  46 ++++---
 9 files changed, 260 insertions(+), 145 deletions(-)
