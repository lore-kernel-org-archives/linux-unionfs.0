From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.20-rc7
Date: Wed, 12 Dec 2018 10:45:18 +0100
Message-ID: <20181212094518.GB15517@veci.piliscsaba.redhat.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-4.20-rc7

Needed to revert a patch, because it possibly introduces a security hole.
Since the patch is basically a conceptual cleanup, not a bug fix, it's safe
to revert.  I'm not giving up on this, and discussions seemed to have
reached an agreement over how to move forward, but that can wait 'till the
next release.

The other two patches are fixes for bugs introduced in recent releases.

Thanks,
Miklos

----------------------------------------------------------------
Amir Goldstein (2):
      ovl: fix missing override creds in link of a metacopy upper
      ovl: fix decode of dir file handle with multi lower layers

Miklos Szeredi (1):
      Revert "ovl: relax permission checking on underlying layers"

---
 fs/overlayfs/dir.c    | 14 +++++++++++++-
 fs/overlayfs/export.c |  6 +++---
 fs/overlayfs/inode.c  | 17 ++++-------------
 3 files changed, 20 insertions(+), 17 deletions(-)
