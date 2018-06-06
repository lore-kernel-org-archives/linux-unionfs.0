From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.18
Date: Wed, 6 Jun 2018 21:34:29 +0200
Message-ID: <20180606193429.GF23785@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org, viro@zeniv.linux.org.uk, hch@infradead.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-4.18

This contains a fix for the vfs_mkdir() issue discovered by Al, as well as
other fixes and cleanups.

It's the first overlayfs pull request for 4.18, the only VFS bit here is a
new inode hash insertion helper.  That helper can be used internally by the
other two (iget5_locked() and insert_inode_locked4()) so it's a cleanup as
well.  Alas, no ack from Al (no nak either, mind).

I'll follow up with a more controversal pull request that has the meat of
the overlayfs developement.  The VFS bits got some acks from Christoph
recently, and one nak that I've purged from the set.

All of this has been posted and reviewed and generally gone through the
normal development cycle, it's just hard to get the attention of top level
vfs maintainers...

Thanks,
Miklos

---
Al Viro (1):
      ovl: make ovl_create_real() cope with vfs_mkdir() safely

Amir Goldstein (6):
      ovl: update documentation for unionmount-testsuite
      ovl: remove WARN_ON() real inode attributes mismatch
      ovl: strip debug argument from ovl_do_ helpers
      ovl: struct cattr cleanups
      ovl: create helper ovl_create_temp()
      ovl: use inode_insert5() to hash a newly created inode

Miklos Szeredi (5):
      ovl: Kconfig documentation fixes
      ovl: return dentry from ovl_create_real()
      ovl: return EIO on internal error
      ovl: clean up copy-up error paths
      vfs: factor out inode_insert5()

Vivek Goyal (1):
      ovl: Pass argument to ovl_get_inode() in a structure

---
 Documentation/filesystems/overlayfs.txt |   7 +-
 fs/inode.c                              | 164 ++++++++++++-------------
 fs/overlayfs/Kconfig                    |   6 +-
 fs/overlayfs/copy_up.c                  |  83 ++++---------
 fs/overlayfs/dir.c                      | 208 +++++++++++++++++++++-----------
 fs/overlayfs/export.c                   |   8 +-
 fs/overlayfs/inode.c                    |  28 +++--
 fs/overlayfs/namei.c                    |  10 +-
 fs/overlayfs/overlayfs.h                |  65 +++++-----
 fs/overlayfs/super.c                    |   9 +-
 include/linux/fs.h                      |   4 +
 11 files changed, 319 insertions(+), 273 deletions(-)
