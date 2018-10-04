From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.19-rc7
Date: Thu, 4 Oct 2018 21:00:12 +0200
Message-ID: <20181004190012.GD23439@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Greg,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-4.19-rc7

This update fixes a couple of regressions in the stacked file update added
in this cycle, as well as some older bugs uncovered by syzkaller.

There's also one trivial naming change that touches other parts of the fs
subsystem.

Thanks,
Miklos

---
Amir Goldstein (5):
      ovl: fix memory leak on unlink of indexed file
      ovl: fix freeze protection bypass in ovl_write_iter()
      ovl: fix freeze protection bypass in ovl_clone_file_range()
      vfs: swap names of {do,vfs}_clone_file_range()
      ovl: fix access beyond unterminated strings

Miklos Szeredi (1):
      ovl: fix format of setxattr debug

Wei Yongjun (1):
      ovl: make symbol 'ovl_aops' static

---
 fs/ioctl.c               |  2 +-
 fs/nfsd/vfs.c            |  3 ++-
 fs/overlayfs/copy_up.c   |  2 +-
 fs/overlayfs/file.c      |  2 ++
 fs/overlayfs/inode.c     |  2 +-
 fs/overlayfs/namei.c     |  2 +-
 fs/overlayfs/overlayfs.h |  4 ++--
 fs/overlayfs/util.c      |  3 ++-
 fs/read_write.c          | 17 +++++++++++++++--
 include/linux/fs.h       | 17 +++--------------
 10 files changed, 30 insertions(+), 24 deletions(-)
