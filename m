From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.9-rc3
Date: Fri, 4 Nov 2016 10:30:50 +0100
Message-ID: <20161104093050.GB1839@veci.piliscsaba.szeredi.hu>
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

Fix two more POSIX ACL bugs introduced in 4.8 and add a missing fsync during
copy up to prevent possible data loss.

Also introduce the concept of feature flags to allow backward incompatible
changes to the overlay format.  This should have been there from day one; the
best we can do now is backport to stable kernels.  Add the check for features
without adding any actual features yet.

Thanks,
Miklos

---
Miklos Szeredi (4):
      ovl: update S_ISGID when setting posix ACLs
      ovl: fix get_acl() on tmpfs
      ovl: fsync after copy-up
      ovl: check fs features

---
 Documentation/filesystems/overlayfs.txt | 12 +++++++
 fs/overlayfs/copy_up.c                  |  2 ++
 fs/overlayfs/inode.c                    |  3 --
 fs/overlayfs/overlayfs.h                |  1 +
 fs/overlayfs/super.c                    | 56 +++++++++++++++++++++++++++++++++
 5 files changed, 71 insertions(+), 3 deletions(-)
