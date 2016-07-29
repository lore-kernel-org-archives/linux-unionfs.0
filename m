From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.8
Date: Fri, 29 Jul 2016 13:20:24 +0200
Message-ID: <20160729112024.GB25404@veci.piliscsaba.szeredi.hu>
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

First of all, this fixes a regression in overlayfs introduced by the dentry hash
salting.  I've moved the patch fixing this to the front of the queue, so if (god
forbid) something needs to be bisected in overlayfs this regression won't
interfere with that.

The biggest part is preparation for selinux support, done by Vivek Goyal.
Essentially this makes all operations on underlying filesystems be done with
credentials of mounter.  This makes everything nicely consistent.

There are also fixes for a number of known and recently discovered non-standard
behavior (thanks to Eryu Guan for testing and improving the test suites).

Thanks,
Miklos

---
Al Viro (1):
      qstr: constify instances in overlayfs

Andreas Gruenbacher (1):
      ovl: store ovl_entry in inode->i_private for all inodes

Miklos Szeredi (13):
      ovl: check mounter creds on underlying lookup
      ovl: use generic_delete_inode
      ovl: simplify permission checking
      ovl: fix sgid on directory
      ovl: update atime on upper
      ovl: permission: return ECHILD instead of ENOENT
      ovl: store real inode pointer in ->i_private
      ovl: share inode for hard link
      ovl: fix POSIX ACL setting
      ovl: fix warning
      ovl: disallow overlayfs as upperdir
      ovl: clear nlink on rmdir
      ovl: simplify empty checking

Vivek Goyal (7):
      ovl: move some common code in a function
      ovl: define ->get_acl() for overlay inodes
      ovl: modify ovl_permission() to do checks on two inodes
      ovl: do operations on underlying file system in mounter's context
      ovl: do not require mounter to have MAY_WRITE on lower
      ovl: dilute permission checks on lower only if not special file
      ovl: append MAY_READ when diluting write checks

Wei Yongjun (1):
      ovl: remove duplicated include from super.c

---
 fs/overlayfs/copy_up.c   |   1 +
 fs/overlayfs/dir.c       | 226 +++++++++++++++++++++++++------------------
 fs/overlayfs/inode.c     | 246 ++++++++++++++++++++++++++++-------------------
 fs/overlayfs/overlayfs.h |  30 ++++--
 fs/overlayfs/super.c     | 178 +++++++++++++++++++++++++++-------
 5 files changed, 445 insertions(+), 236 deletions(-)
