From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs fixes for 4.14-rc4
Date: Fri, 6 Oct 2017 14:14:05 +0200
Message-ID: <20171006121405.GA32700@veci.piliscsaba.szeredi.hu>
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

Fix a regression in 4.14 and one in 4.13.  The latter is a case when Docker is
doing something it really shouldn't and gets away with it.  We now print a
warning instead of erroring out.  There are also fixes to several error paths.

Thanks,
Miklos

---
Amir Goldstein (6):
      ovl: fix may_write_real() for overlayfs directories
      ovl: fix error value printed in ovl_lookup_index()
      ovl: fix dput() of ERR_PTR in ovl_cleanup_index()
      ovl: fix dentry leak in ovl_indexdir_cleanup()
      ovl: fix missing unlock_rename() in ovl_do_copy_up()
      ovl: fix regression caused by exclusive upper/work dir protection

---
 Documentation/filesystems/overlayfs.txt |  5 ++++-
 fs/namespace.c                          |  4 +++-
 fs/overlayfs/copy_up.c                  |  6 ++----
 fs/overlayfs/dir.c                      | 20 --------------------
 fs/overlayfs/namei.c                    |  1 +
 fs/overlayfs/overlayfs.h                |  1 +
 fs/overlayfs/ovl_entry.h                |  3 +++
 fs/overlayfs/readdir.c                  |  6 ++++--
 fs/overlayfs/super.c                    | 27 +++++++++++++++++++--------
 fs/overlayfs/util.c                     | 24 +++++++++++++++++++++++-
 10 files changed, 60 insertions(+), 37 deletions(-)
