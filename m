From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 5.3
Date: Tue, 17 Sep 2019 10:31:35 +0200
Message-ID: <20190917083135.GA19549@miu.piliscsaba.redhat.com>
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

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git tags/ovl-fixes-5.3

Fix a regression in docker introduced by overlayfs changes in 4.19.  Also
fix a couple of miscellaneous bugs.

Thanks,
Miklos

----------------------------------------------------------------
Amir Goldstein (1):
      ovl: fix regression caused by overlapping layers detection

Ding Xiang (1):
      ovl: Fix dereferencing possible ERR_PTR()

Mark Salyzyn (1):
      ovl: filter of trusted xattr results in audit

---
 Documentation/filesystems/overlayfs.txt |  2 +-
 fs/overlayfs/export.c                   |  3 +-
 fs/overlayfs/inode.c                    |  3 +-
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/super.c                    | 73 +++++++++++++++++++++------------
 5 files changed, 52 insertions(+), 30 deletions(-)
