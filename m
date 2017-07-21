From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.13-rc1
Date: Fri, 21 Jul 2017 21:41:04 +0200
Message-ID: <20170721194104.GC5256@veci.piliscsaba.szeredi.hu>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This fixes a crash with SELinux and several other old and new bugs.

Thanks,
Miklos

---
Amir Goldstein (6):
      ovl: fix random return value on mount
      ovl: mark parent impure on ovl_link()
      ovl: fix origin verification of index dir
      ovl: remove unneeded check for IS_ERR()
      ovl: do not cleanup directory and whiteout index entries
      ovl: check for bad and whiteout index on lookup

Miklos Szeredi (1):
      ovl: fix xattr get and set with selinux

---
 fs/overlayfs/dir.c       | 22 ++++++++++++++++++----
 fs/overlayfs/inode.c     | 32 +++++++++++++++++---------------
 fs/overlayfs/namei.c     | 41 ++++++++++++++++++++++++++++++++---------
 fs/overlayfs/overlayfs.h | 10 ++++++----
 fs/overlayfs/readdir.c   |  5 ++++-
 fs/overlayfs/super.c     | 13 +++++--------
 fs/overlayfs/util.c      |  7 ++++++-
 7 files changed, 88 insertions(+), 42 deletions(-)
