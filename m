From: Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [GIT PULL] overlay filesystem v25
Date: Fri, 24 Oct 2014 04:24:22 +0100
Message-ID: <20141024032422.GI7996@ZenIV.linux.org.uk>
References: <20141023232539.GA4662@tucsk.piliscsaba.szeredi.hu>
 <20141024022055.GH7996@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from zeniv.linux.org.uk ([195.92.253.2]:38321 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927AbaJXDYZ (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Thu, 23 Oct 2014 23:24:25 -0400
Content-Disposition: inline
In-Reply-To: <20141024022055.GH7996@ZenIV.linux.org.uk>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org

On Fri, Oct 24, 2014 at 03:20:55AM +0100, Al Viro wrote:
> Why the hell do you hold ->i_mutex across the entire opening of underlying
> directory?  All you need is to serialize one assignment; the side that loses
> the race will simply fput() what it opened...
> 
> Oh, well - that goes under "weird pessimisations, easy to fix in followups"...

OK, pulled into vfs.git, followups in question added.  Also there: fix for
a long-standing leak in d_splice_alias() failure exits.  Guys, could you
check that current vfs.git#for-linus survives your local tests?  Seems to
survive here; if I don't hear of any problems by tomorrow morning, to Linus
it goes...  FWIW, for that pull request stats would be

Shortlog:
Al Viro (5):
      fix inode leaks on d_splice_alias() failure exits
      overlayfs: don't hold ->i_mutex over opening the real directory
      overlayfs: make ovl_cache_entry->name an array instead of pointer
      overlayfs: embed root into overlay_readdir_data
      overlayfs: embed middle into overlay_readdir_data

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

Diffstat:
 Documentation/filesystems/Locking       |    2 +
 Documentation/filesystems/overlayfs.txt |  198 +++++++
 Documentation/filesystems/vfs.txt       |    7 +
 MAINTAINERS                             |    7 +
 fs/Kconfig                              |    1 +
 fs/Makefile                             |    1 +
 fs/btrfs/ioctl.c                        |   20 +-
 fs/dcache.c                             |    2 +
 fs/ecryptfs/main.c                      |    7 +
 fs/ext4/namei.c                         |   95 +++-
 fs/internal.h                           |    7 -
 fs/namei.c                              |   41 +-
 fs/namespace.c                          |   27 +
 fs/open.c                               |   23 +-
 fs/overlayfs/Kconfig                    |   10 +
 fs/overlayfs/Makefile                   |    7 +
 fs/overlayfs/copy_up.c                  |  414 ++++++++++++++
 fs/overlayfs/dir.c                      |  921 +++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c                    |  425 ++++++++++++++
 fs/overlayfs/overlayfs.h                |  191 +++++++
 fs/overlayfs/readdir.c                  |  589 ++++++++++++++++++++
 fs/overlayfs/super.c                    |  796 ++++++++++++++++++++++++++
 fs/splice.c                             |    1 +
 include/linux/fs.h                      |   39 ++
 include/linux/mount.h                   |    3 +
 include/uapi/linux/fs.h                 |    1 +
 mm/shmem.c                              |   36 +-
 27 files changed, 3813 insertions(+), 58 deletions(-)
 create mode 100644 Documentation/filesystems/overlayfs.txt
 create mode 100644 fs/overlayfs/Kconfig
 create mode 100644 fs/overlayfs/Makefile
 create mode 100644 fs/overlayfs/copy_up.c
 create mode 100644 fs/overlayfs/dir.c
 create mode 100644 fs/overlayfs/inode.c
 create mode 100644 fs/overlayfs/overlayfs.h
 create mode 100644 fs/overlayfs/readdir.c
 create mode 100644 fs/overlayfs/super.c
