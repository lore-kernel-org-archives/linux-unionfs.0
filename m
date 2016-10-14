From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL (updated)] overlayfs update for 4.9
Date: Fri, 14 Oct 2016 11:39:21 +0200
Message-ID: <20161014093921.GG31239@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull updated branch from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

Left out the mnt_want_write_file() and clone_file_range() patches altogether, so
this is now really overlayfs only.  There's vfs_get_link() and that's
technically in the VFS but it's a new helper (and ecryptfs can use it too so no
point in making it private to overlayfs).

The merge contains a conflict against the xattr update from Andreas.  The
resolution is to take my version as we now can and should do permission checks
on the underlying layers (with mounter's permission).

This update contains fixes to the "use mounter's permission to access underlying
layers" area, miscellaneous fixes and cleanups.  No new features this time.

Thanks,
Miklos

---
Miklos Szeredi (6):
      ovl: copy_up_xattr(): use strnlen
      ovl: lookup: do getxattr with mounter's permission
      ovl: explain error values when removing acl from workdir
      ovl: use generic_readlink
      vfs: add vfs_get_link() helper
      ovl: use vfs_get_link()

Richard Weinberger (1):
      ovl: Fix info leak in ovl_lookup_temp()

Vivek Goyal (1):
      ovl: during copy up, switch to mounter's creds early

---
 fs/namei.c             | 25 +++++++++++++++++++
 fs/overlayfs/copy_up.c | 67 +++++++++++++++-----------------------------------
 fs/overlayfs/dir.c     |  5 +++-
 fs/overlayfs/inode.c   | 44 ++++++++-------------------------
 fs/overlayfs/super.c   | 33 ++++++++++++++++---------
 include/linux/fs.h     |  1 +
 6 files changed, 82 insertions(+), 93 deletions(-)
