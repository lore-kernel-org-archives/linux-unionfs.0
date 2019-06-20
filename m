From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 5.2-rc6
Date: Thu, 20 Jun 2019 22:12:18 +0200
Message-ID: <20190620201218.GB10138@miu.piliscsaba.redhat.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.2-rc6

Fix two regressions in this cycle, and a couple of older bugs.

Thanks,
Miklos

----------------------------------------------------------------
Amir Goldstein (2):
      ovl: fix wrong flags check in FS_IOC_FS[SG]ETXATTR ioctls
      ovl: make i_ino consistent with st_ino in more cases

Arnd Bergmann (1):
      ovl: fix bogus -Wmaybe-unitialized warning

Miklos Szeredi (1):
      ovl: don't fail with disconnected lower NFS

Nicolas Schier (1):
      ovl: fix typo in MODULE_PARM_DESC

---
 fs/overlayfs/copy_up.c |  2 +-
 fs/overlayfs/dir.c     |  2 +-
 fs/overlayfs/file.c    | 91 +++++++++++++++++++++++++++++++++++---------------
 fs/overlayfs/inode.c   | 12 +++----
 fs/overlayfs/super.c   | 42 ++++++++++-------------
 5 files changed, 90 insertions(+), 59 deletions(-)
