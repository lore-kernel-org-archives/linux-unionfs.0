From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.15-rc4
Date: Fri, 15 Dec 2017 16:25:22 +0100
Message-ID: <20171215152522.GA31123@veci.piliscsaba.redhat.com>
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

 - fix incomplete syncing of filesystem
 - fix regression in readdir on ovl over 9p
 - only following redirects when needed
 - misc fixes and cleanups

Thanks,
Miklos

---
Amir Goldstein (2):
      ovl: update ctx->pos on impure dir iteration
      ovl: fix overlay: warning prefix

Chengguang Xu (1):
      ovl: Sync upper dirty data when syncing overlayfs

Miklos Szeredi (1):
      ovl: don't follow redirects if redirect_dir=off

Vasyl Gomonovych (1):
      ovl: Use PTR_ERR_OR_ZERO()

Vivek Goyal (1):
      ovl: Pass ovl_get_nlink() parameters in right order

---
 Documentation/filesystems/overlayfs.txt | 34 +++++++++++++
 fs/overlayfs/Kconfig                    | 10 ++++
 fs/overlayfs/dir.c                      |  3 +-
 fs/overlayfs/namei.c                    | 18 ++++++-
 fs/overlayfs/overlayfs.h                |  2 +-
 fs/overlayfs/ovl_entry.h                |  2 +
 fs/overlayfs/readdir.c                  |  7 ++-
 fs/overlayfs/super.c                    | 87 +++++++++++++++++++++++++--------
 8 files changed, 137 insertions(+), 26 deletions(-)
