From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.9
Date: Thu, 13 Oct 2016 16:37:51 +0200
Message-ID: <20161013143751.GE31239@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

I tried to submit this though Al because of the VFS changes, but failed
unfortunately.  The VFS changes are small and should only affect overlayfs, so
here it is.

This update contains the following changes:

 - a couple of fixes in the "use mounter's permission to access underlying
   layers" area;

 - mnt_want_write_file() should freeze protect the underlying layer, except in
   the case of i_ops, where the callee is expected to do that

 - use "clone_file_range" to copy up if possible, resulting in a substantial
   speedup;

 - misc fixes and cleanups.

Thanks,
Miklos

---
Amir Goldstein (3):
      vfs: allow vfs_clone_file_range() across mount points
      vfs: call vfs_clone_file_range() under mnt_want_write()
      ovl: use vfs_clone_file_range() for copy up if possible

Miklos Szeredi (7):
      ovl: copy_up_xattr(): use strnlen
      ovl: lookup: do getxattr with mounter's permission
      vfs: mnt_want_write_file() should freeze protect underlying sb
      ovl: explain error values when removing acl from workdir
      ovl: use generic_readlink
      vfs: add vfs_get_link() helper
      ovl: use vfs_get_link()

Richard Weinberger (1):
      ovl: Fix info leak in ovl_lookup_temp()

Vivek Goyal (1):
      ovl: during copy up, switch to mounter's creds early

---
 fs/ioctl.c             |  5 +++-
 fs/namei.c             | 25 +++++++++++++++++
 fs/namespace.c         |  7 +++--
 fs/nfsd/vfs.c          |  3 +-
 fs/open.c              | 15 +++++-----
 fs/overlayfs/copy_up.c | 75 +++++++++++++++++++-------------------------------
 fs/overlayfs/dir.c     |  5 +++-
 fs/overlayfs/inode.c   | 44 +++++++----------------------
 fs/overlayfs/super.c   | 33 ++++++++++++++--------
 fs/read_write.c        | 13 ++++-----
 fs/xattr.c             | 13 ++++++---
 include/linux/fs.h     | 14 ++++++++++
 12 files changed, 135 insertions(+), 117 deletions(-)
