From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.16-rc5
Date: Fri, 9 Mar 2018 12:33:48 +0100
Message-ID: <20180309113348.GC19579@veci.piliscsaba.redhat.com>
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

This fixes a corner case for NFS exporting (introduced in this cycle) as well as
fixing miscellaneous bugs.

Thanks,
Miklos

---
Amir Goldstein (3):
      ovl: hash non-dir by lower inode for fsnotify
      ovl: check lower ancestry on encode of lower dir file handle
      ovl: check ERR_PTR() return value from ovl_lookup_real()

Fengguang Wu (1):
      ovl: fix ptr_ret.cocci warnings

Miklos Szeredi (1):
      ovl: update Kconfig texts

Vivek Goyal (1):
      ovl: redirect_dir=nofollow should not follow redirect for opaque lower

---
 fs/overlayfs/Kconfig     |  14 +++
 fs/overlayfs/export.c    | 216 ++++++++++++++++++++++++++++++++++++-----------
 fs/overlayfs/inode.c     |  58 +++++++++----
 fs/overlayfs/namei.c     |   6 +-
 fs/overlayfs/overlayfs.h |   1 +
 fs/overlayfs/super.c     |   1 +
 6 files changed, 228 insertions(+), 68 deletions(-)
