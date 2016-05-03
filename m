From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.6-rc7
Date: Tue, 3 May 2016 22:04:03 +0200
Message-ID: <20160503200403.GB10623@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Al,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

This fixes two issues with overlayfs.

Thanks,
Miklos

---
Miklos Szeredi (3):
      vfs: rename: check backing inode being equal
      vfs: export lookup_hash() to modules
      ovl: ignore permissions on underlying lookup

---
 fs/namei.c            | 48 ++++++++++++++++++++++++++++++++++++++----------
 fs/overlayfs/super.c  |  2 +-
 include/linux/namei.h |  2 ++
 3 files changed, 41 insertions(+), 11 deletions(-)
