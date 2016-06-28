From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL for 4.8] consolidate vfs API for overlayfs
Date: Tue, 28 Jun 2016 10:18:10 +0200
Message-ID: <20160628081810.GB2388@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-fsdevel-owner@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Al,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git d_real

This consolidates the d_real/d_select_inode API as well as some documentation
cleanups.

Thanks,
Miklos

---
Miklos Szeredi (3):
      vfs: merge .d_select_inode() into .d_real()
      vfs: document ->d_real()
      vfs: clean up documentation

---
 Documentation/filesystems/Locking |  4 ++--
 Documentation/filesystems/vfs.txt | 39 +++++++++++++++++++++++++--------------
 fs/dcache.c                       |  3 ---
 fs/namei.c                        |  2 +-
 fs/open.c                         | 17 +++++++++++++----
 fs/overlayfs/inode.c              | 31 ++++++++++---------------------
 fs/overlayfs/overlayfs.h          |  2 +-
 fs/overlayfs/super.c              | 17 +++++++++++++----
 include/linux/dcache.h            | 29 +++++++++++------------------
 include/linux/fs.h                |  2 +-
 10 files changed, 77 insertions(+), 69 deletions(-)
