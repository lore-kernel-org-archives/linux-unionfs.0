From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 5.2
Date: Tue, 14 May 2019 09:55:55 +0200
Message-ID: <20190514075555.GB7850@veci.piliscsaba.redhat.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-update-5.2

Just bug fixes in this small update.

Thanks,
Miklos

---
Amir Goldstein (4):
      ovl: fix missing upper fs freeze protection on copy up for ioctl
      ovl: support stacked SEEK_HOLE/SEEK_DATA
      ovl: do not generate duplicate fsnotify events for "fake" path
      ovl: relax WARN_ON() for overlapping layers use case

Jiufei Xue (1):
      ovl: check the capability before cred overridden

---
 fs/overlayfs/copy_up.c   |   6 +--
 fs/overlayfs/dir.c       |   2 +-
 fs/overlayfs/file.c      | 133 +++++++++++++++++++++++++++++++++++++----------
 fs/overlayfs/inode.c     |   3 +-
 fs/overlayfs/overlayfs.h |   2 +-
 5 files changed, 113 insertions(+), 33 deletions(-)
