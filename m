From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 5.5-rc2
Date: Fri, 13 Dec 2019 17:26:12 +0100
Message-ID: <20191213162612.GA5081@miu.piliscsaba.redhat.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.5-rc2

Fix some bugs and documentation.

Thanks,
Miklos

----------------------------------------------------------------
Amir Goldstein (7):
      ovl: fix lookup failure on multi lower squashfs
      ovl: make sure that real fid is 32bit aligned in memory
      ovl: don't use a temp buf for encoding real fh
      ovl: fix corner case of non-unique st_dev;st_ino
      ovl: relax WARN_ON() on rename to self
      docs: filesystems: overlayfs: Rename overlayfs.txt to .rst
      docs: filesystems: overlayfs: Fix restview warnings

---
 .../filesystems/{overlayfs.txt => overlayfs.rst}   | 10 +--
 MAINTAINERS                                        |  2 +-
 fs/overlayfs/copy_up.c                             | 53 +++++++-------
 fs/overlayfs/dir.c                                 |  2 +-
 fs/overlayfs/export.c                              | 80 +++++++++++++---------
 fs/overlayfs/inode.c                               |  8 ++-
 fs/overlayfs/namei.c                               | 52 ++++++++------
 fs/overlayfs/overlayfs.h                           | 34 +++++++--
 fs/overlayfs/ovl_entry.h                           |  2 +
 fs/overlayfs/super.c                               | 24 +++++--
 10 files changed, 166 insertions(+), 101 deletions(-)
 rename Documentation/filesystems/{overlayfs.txt => overlayfs.rst} (99%)
