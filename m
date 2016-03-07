From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.5-rc7
Date: Mon, 7 Mar 2016 09:49:33 +0100
Message-ID: <20160307084933.GB8655@tucsk>
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

This contains overlayfs bug fixes.  All marked as -stable material.

Thanks,
Miklos

---
Konstantin Khlebnikov (3):
      ovl: fix working on distributed fs as lower layer
      ovl: ignore lower entries when checking purity of non-directory entries
      ovl: copy new uid/gid into overlayfs runtime inode

Rui Wang (1):
      ovl: fix getcwd() failure after unsuccessful rmdir

---
 fs/overlayfs/dir.c   | 10 +++++++++-
 fs/overlayfs/inode.c |  2 ++
 fs/overlayfs/super.c | 13 ++++++++-----
 3 files changed, 19 insertions(+), 6 deletions(-)
