From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.9
Date: Wed, 5 Oct 2016 21:52:10 +0200
Message-ID: <20161005195210.GC31239@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33566 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751328AbcJETwP (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Oct 2016 15:52:15 -0400
Received: by mail-wm0-f66.google.com with SMTP id p138so246077wmb.0
        for <linux-unionfs@vger.kernel.org>; Wed, 05 Oct 2016 12:52:14 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Al,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-viro

This has an assortment of fixes and cleanups for overlayfs.

It also touches the VFS:

 - add the vfs_get_link() helper for calling i_op->get_link();
 - fix mnt_want_write_file() to freeze protect the underlying sb instead of
   overlay sb;
 - allow vfs_clone_file_range() to be called by overlayfs.

None of the above should have any effect on filesystems other than overlayfs.

Thanks,
Miklos

---
Amir Goldstein (3):
      vfs: allow vfs_clone_file_range() across mount points
      vfs: call vfs_clone_file_range() under mnt_want_write()
      ovl: use vfs_clone_file_range() for copy up if possible

Miklos Szeredi (8):
      ovl: copy_up_xattr(): use strnlen
      ovl: lookup: do getxattr with mounter's permission
      vfs: mnt_want_write_file() should freeze protect underlying sb
      ovl: make directory ino/dev numbers stable
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
 fs/overlayfs/dir.c     | 32 +++++++++++++++++++--
 fs/overlayfs/inode.c   | 44 +++++++----------------------
 fs/overlayfs/super.c   | 33 ++++++++++++++--------
 fs/read_write.c        | 13 ++++-----
 fs/xattr.c             | 13 ++++++---
 include/linux/fs.h     | 14 ++++++++++
 12 files changed, 160 insertions(+), 119 deletions(-)
