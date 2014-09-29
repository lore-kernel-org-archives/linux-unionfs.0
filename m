From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [PULL for 3.18] overlay filesystem v24
Date: Mon, 29 Sep 2014 16:14:57 +0200
Message-ID: <20140929141457.GB5011@tucsk.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:62537 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbaI2OPC (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 29 Sep 2014 10:15:02 -0400
Received: by mail-wi0-f177.google.com with SMTP id cc10so1142166wib.10
        for <linux-unionfs@vger.kernel.org>; Mon, 29 Sep 2014 07:15:01 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-unionfs@vger.kernel.org

I'd like to propose overlayfs for inclusion into 3.18.

Al, would you mind giving it a review?

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.current

Thanks,
Miklos

---
Andy Whitcroft (1):
      overlayfs: add statfs support

Erez Zadok (1):
      overlayfs: implement show_options

Miklos Szeredi (11):
      vfs: add i_op->dentry_open()
      vfs: export do_splice_direct() to modules
      vfs: export __inode_permission() to modules
      vfs: introduce clone_private_mount()
      vfs: export check_sticky()
      vfs: add whiteout support
      vfs: add RENAME_WHITEOUT
      ext4: support RENAME_WHITEOUT
      shmem: support RENAME_WHITEOUT
      overlay filesystem
      fs: limit filesystem stacking depth

Neil Brown (1):
      overlay: overlay filesystem documentation

Sedat Dilek (1):
      vfs: dcache: Export d_ancestor to modules

---
 Documentation/filesystems/Locking       |   2 +
 Documentation/filesystems/overlayfs.txt | 198 +++++++
 Documentation/filesystems/vfs.txt       |   7 +
 MAINTAINERS                             |   7 +
 fs/Kconfig                              |   1 +
 fs/Makefile                             |   1 +
 fs/btrfs/ioctl.c                        |  20 +-
 fs/dcache.c                             |   1 +
 fs/ecryptfs/main.c                      |   7 +
 fs/ext4/namei.c                         |  95 +++-
 fs/internal.h                           |   7 -
 fs/namei.c                              |  41 +-
 fs/namespace.c                          |  27 +
 fs/open.c                               |  23 +-
 fs/overlayfs/Kconfig                    |  10 +
 fs/overlayfs/Makefile                   |   7 +
 fs/overlayfs/copy_up.c                  | 431 +++++++++++++++
 fs/overlayfs/dir.c                      | 914 ++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    | 408 ++++++++++++++
 fs/overlayfs/overlayfs.h                | 187 +++++++
 fs/overlayfs/readdir.c                  | 518 ++++++++++++++++++
 fs/overlayfs/super.c                    | 762 ++++++++++++++++++++++++++
 fs/splice.c                             |   1 +
 include/linux/fs.h                      |  37 ++
 include/linux/mount.h                   |   3 +
 include/uapi/linux/fs.h                 |   1 +
 mm/shmem.c                              |  36 +-
 27 files changed, 3694 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs.txt
 create mode 100644 fs/overlayfs/Kconfig
 create mode 100644 fs/overlayfs/Makefile
 create mode 100644 fs/overlayfs/copy_up.c
 create mode 100644 fs/overlayfs/dir.c
 create mode 100644 fs/overlayfs/inode.c
 create mode 100644 fs/overlayfs/overlayfs.h
 create mode 100644 fs/overlayfs/readdir.c
 create mode 100644 fs/overlayfs/super.c
