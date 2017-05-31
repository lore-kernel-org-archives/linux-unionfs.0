From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.12-rc4
Date: Wed, 31 May 2017 10:57:06 +0200
Message-ID: <20170531085706.GA28077@veci.piliscsaba.szeredi.hu>
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

Fix regressions:

 - missing CONFIG_EXPORTFS dependency
 - failure if upper fs doesn't support xattr
 - bad error cleanup

This also adds the concept of "impure" directories complementing the "origin"
marking introduced in -rc1.  Together they enable getting consistent st_ino and
d_ino for directory listings.

And there's a bug fix and a cleanup as well.

Thanks,
Miklos

---
Amir Goldstein (5):
      ovl: fix creds leak in copy up error path
      ovl: check on mount time if upper fs supports setting xattr
      ovl: handle rename when upper doesn't support xattr
      ovl: mark upper dir with type origin entries "impure"
      ovl: mark upper merge dir with type origin entries "impure"

Arnd Bergmann (1):
      ovl: select EXPORTFS

Miklos Szeredi (3):
      ovl: don't fail copy-up if upper doesn't support xattr
      ovl: remove unused arg from ovl_lookup_temp()
      ovl: filter trusted xattr for non-admin

---
 fs/overlayfs/Kconfig     |  1 +
 fs/overlayfs/copy_up.c   | 24 +++++++++++-----
 fs/overlayfs/dir.c       | 61 ++++++++++++++++++++++++++++++----------
 fs/overlayfs/inode.c     | 12 +++++++-
 fs/overlayfs/namei.c     | 16 ++++-------
 fs/overlayfs/overlayfs.h | 16 +++++++++--
 fs/overlayfs/ovl_entry.h |  2 ++
 fs/overlayfs/super.c     | 18 +++++++++++-
 fs/overlayfs/util.c      | 72 ++++++++++++++++++++++++++++++++++++++++++------
 9 files changed, 178 insertions(+), 44 deletions(-)
