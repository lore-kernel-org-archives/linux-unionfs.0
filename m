From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.8-rc4
Date: Fri, 2 Sep 2016 14:56:13 +0200
Message-ID: <20160902125613.GL25404@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

Most of this is regression fixes for posix acl behavior introduced in
4.8-rc1 (these were caught by the pjd-fstest suite).  The are also
miscellaneous fixes marked as stable material and cleanups.

Other than overlayfs code, it touches <linux/fs.h> to add a constant with
which to disable posix acl caching.  No changes needed to the actual
caching code, it automatically does the right thing, although later we may
want to optimize this case.

I'm now testing overlayfs with the following test suites to catch
regressions:

 - unionmount-testsuite
 - xfstests
 - pjd-fstest

Thanks,
Miklos

---
Andreas Gruenbacher (4):
      ovl: Fix OVL_XATTR_PREFIX
      ovl: Get rid of ovl_xattr_noacl_handlers array
      ovl: Switch to generic_removexattr
      ovl: Switch to generic_getxattr

Colin Ian King (1):
      ovl: fix spelling mistake: "directries" -> "directories"

Miklos Szeredi (9):
      ovl: don't copy up opaqueness
      ovl: handle umask and posix_acl_default correctly on creation
      ovl: remove posix_acl_default from workdir
      ovl: proper cleanup of workdir
      ovl: use cached acl on underlying layer
      ovl: don't cache acl on overlay layer
      ovl: copyattr after setting POSIX ACL
      ovl: listxattr: use strnlen()
      ovl: update doc

---
 Documentation/filesystems/overlayfs.txt |   8 +--
 fs/overlayfs/copy_up.c                  |   2 +
 fs/overlayfs/dir.c                      |  58 ++++++++++++++++-
 fs/overlayfs/inode.c                    | 108 +++++++++++++-------------------
 fs/overlayfs/overlayfs.h                |  17 ++---
 fs/overlayfs/readdir.c                  |  63 ++++++++++++++++++-
 fs/overlayfs/super.c                    |  93 ++++++++++++++++++++-------
 include/linux/fs.h                      |   1 +
 8 files changed, 246 insertions(+), 104 deletions(-)
