From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.14-rc7
Date: Fri, 27 Oct 2017 14:55:36 +0200
Message-ID: <20171027125536.GD32700@veci.piliscsaba.szeredi.hu>
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

Fix several issues, most of them introduced in the last release.

Thanks,
Miklos

---
Amir Goldstein (3):
      ovl: fix EIO from lookup of non-indexed upper
      ovl: handle ENOENT on index lookup
      ovl: do not cleanup unsupported index entries

Dan Carpenter (1):
      ovl: Return -ENOMEM if an allocation fails ovl_lookup()

Hirofumi Nakagawa (1):
      ovl: add NULL check in ovl_alloc_inode

---
 fs/overlayfs/inode.c     | 20 ++++++++++++++++----
 fs/overlayfs/namei.c     | 32 ++++++++++++++++----------------
 fs/overlayfs/overlayfs.h |  3 ++-
 fs/overlayfs/readdir.c   | 11 +++++------
 fs/overlayfs/super.c     |  3 +++
 5 files changed, 42 insertions(+), 27 deletions(-)
