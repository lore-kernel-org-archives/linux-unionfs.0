From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH 0/7] overlayfs: fix ro/rw fd data inconsistecies
Date: Thu, 24 Nov 2016 15:14:03 +0100
Message-ID: <CAJfpegtdfSBPti9scGe7ztQ_DdsKAemfkQ=kxkbJbctj173Mnw@mail.gmail.com>
References: <1479984944-1017-1-git-send-email-mszeredi@redhat.com> <1479984944-1017-2-git-send-email-mszeredi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1479984944-1017-2-git-send-email-mszeredi@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, Miklos Szeredi <mszeredi@redhat.com>
List-Id: linux-unionfs@vger.kernel.org

On Thu, Nov 24, 2016 at 11:55 AM, Miklos Szeredi <mszeredi@redhat.com> wrote:
> A file is opened for read-only, opened read-write (resulting in a copy up)
> and modified.  The data read back from the the read-only fd will be stale
> in this case (the read-only file descriptor still refers to the lower,
> unmodified file).
>
> This patchset fixes issues related to this corner case.
>
> The VFS impact is minimal and performance in the non-corner cases shouldn't
> suffer.

Git tree is here:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #overlayfs-rorw

Thanks,
Miklos

> ---
> Miklos Szeredi (7):
>   vfs: allow overlayfs to intercept file ops
>   vfs: export filp_clone_open()
>   mm: ovl: copy-up on MAP_SHARED
>   ovl: add infrastructure for intercepting file ops
>   ovl: intercept read_iter
>   ovl: intercept mmap
>   ovl: intercept fsync
>
>  fs/internal.h            |   1 -
>  fs/open.c                |   2 +-
>  fs/overlayfs/inode.c     | 225 +++++++++++++++++++++++++++++++++++++++++++++++
>  fs/overlayfs/overlayfs.h |   2 +
>  fs/overlayfs/super.c     |   1 +
>  include/linux/fs.h       |   1 +
>  mm/util.c                |  22 +++++
>  7 files changed, 252 insertions(+), 2 deletions(-)
>
> --
> 2.5.5
>
