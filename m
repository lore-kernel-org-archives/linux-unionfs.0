From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 5.2-rc4
Date: Thu, 6 Jun 2019 15:44:18 +0200
Message-ID: <20190606134418.GB26408@miu.piliscsaba.redhat.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.2-rc4

Here's one fix for a class of bugs triggered by syzcaller, and one that
makes xfstests fail less.

Thanks,
Miklos

----------------------------------------------------------------
Amir Goldstein (2):
      ovl: support the FS_IOC_FS[SG]ETXATTR ioctls
      ovl: detect overlapping layers

Miklos Szeredi (1):
      ovl: doc: add non-standard corner cases

---
 Documentation/filesystems/overlayfs.txt |  16 ++-
 fs/overlayfs/file.c                     |   9 +-
 fs/overlayfs/inode.c                    |  48 +++++++++
 fs/overlayfs/namei.c                    |   8 ++
 fs/overlayfs/overlayfs.h                |   3 +
 fs/overlayfs/ovl_entry.h                |   6 ++
 fs/overlayfs/super.c                    | 169 ++++++++++++++++++++++++++++----
 fs/overlayfs/util.c                     |  12 +++
 8 files changed, 249 insertions(+), 22 deletions(-)
