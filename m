From: Woody Suwalski <terraluna977@gmail.com>
Subject: Re: [PULL for 3.18] overlay filesystem v24
Date: Mon, 29 Sep 2014 17:45:33 -0400
Message-ID: <5429D2FD.5090602@gmail.com>
References: <20140929141457.GB5011@tucsk.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ig0-f182.google.com ([209.85.213.182]:55155 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751215AbaI2VrK (ORCPT
	<rfc822;linux-unionfs@vger.kernel.org>);
	Mon, 29 Sep 2014 17:47:10 -0400
In-Reply-To: <20140929141457.GB5011@tucsk.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>, Al Viro <viro@zeniv.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Linux-Fsdevel <linux-fsdevel@vger.kernel.org>, Kernel Mailing List <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-unionfs@vger.kernel.org

I remember like if it was yesterday... ;-)
Around 3.8 Linus decided to include overlayfs in the kernel, so in 3.10 
we were supposed to get it... And we keep waiting...

Woody

Miklos Szeredi wrote:
> I'd like to propose overlayfs for inclusion into 3.18.
>
> Al, would you mind giving it a review?
>
> Git tree is here:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs.current
>
> Thanks,
> Miklos
>
> ---
> Andy Whitcroft (1):
>        overlayfs: add statfs support
>
> Erez Zadok (1):
>        overlayfs: implement show_options
>
> Miklos Szeredi (11):
>        vfs: add i_op->dentry_open()
>        vfs: export do_splice_direct() to modules
>        vfs: export __inode_permission() to modules
>        vfs: introduce clone_private_mount()
>        vfs: export check_sticky()
>        vfs: add whiteout support
>        vfs: add RENAME_WHITEOUT
>        ext4: support RENAME_WHITEOUT
>        shmem: support RENAME_WHITEOUT
>        overlay filesystem
>        fs: limit filesystem stacking depth
>
> Neil Brown (1):
>        overlay: overlay filesystem documentation
>
> Sedat Dilek (1):
>        vfs: dcache: Export d_ancestor to modules
>
> ---
>   Documentation/filesystems/Locking       |   2 +
>   Documentation/filesystems/overlayfs.txt | 198 +++++++
>   Documentation/filesystems/vfs.txt       |   7 +
>   MAINTAINERS                             |   7 +
>   fs/Kconfig                              |   1 +
>   fs/Makefile                             |   1 +
>   fs/btrfs/ioctl.c                        |  20 +-
>   fs/dcache.c                             |   1 +
>   fs/ecryptfs/main.c                      |   7 +
>   fs/ext4/namei.c                         |  95 +++-
>   fs/internal.h                           |   7 -
>   fs/namei.c                              |  41 +-
>   fs/namespace.c                          |  27 +
>   fs/open.c                               |  23 +-
>   fs/overlayfs/Kconfig                    |  10 +
>   fs/overlayfs/Makefile                   |   7 +
>   fs/overlayfs/copy_up.c                  | 431 +++++++++++++++
>   fs/overlayfs/dir.c                      | 914 ++++++++++++++++++++++++++++++++
>   fs/overlayfs/inode.c                    | 408 ++++++++++++++
>   fs/overlayfs/overlayfs.h                | 187 +++++++
>   fs/overlayfs/readdir.c                  | 518 ++++++++++++++++++
>   fs/overlayfs/super.c                    | 762 ++++++++++++++++++++++++++
>   fs/splice.c                             |   1 +
>   include/linux/fs.h                      |  37 ++
>   include/linux/mount.h                   |   3 +
>   include/uapi/linux/fs.h                 |   1 +
>   mm/shmem.c                              |  36 +-
>   27 files changed, 3694 insertions(+), 58 deletions(-)
>   create mode 100644 Documentation/filesystems/overlayfs.txt
>   create mode 100644 fs/overlayfs/Kconfig
>   create mode 100644 fs/overlayfs/Makefile
>   create mode 100644 fs/overlayfs/copy_up.c
>   create mode 100644 fs/overlayfs/dir.c
>   create mode 100644 fs/overlayfs/inode.c
>   create mode 100644 fs/overlayfs/overlayfs.h
>   create mode 100644 fs/overlayfs/readdir.c
>   create mode 100644 fs/overlayfs/super.c
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

