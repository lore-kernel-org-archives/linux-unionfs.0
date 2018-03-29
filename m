Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
References: <1522333133-24772-1-git-send-email-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Mar 2018 17:24:34 +0300
Message-ID: <CAOQ4uxjMSfrthtPZuyGP9UX+tx3PgMTDOMkuDzWbLFi6LfBsTw@mail.gmail.com>
Subject: Re: [PATCH v9 0/7] Overlayfs: constant st_ino/d_ino for non-samefs
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 5:18 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> This series provides a solution for some interesting non-samefs cases:
> - All the ext* family
> - Many other fs with default encode_fh
> - xfs and tmpfs with overlay "xino" mount option
>
> The patches are also available on my ovl-xino branch [2]. They are based
> on some earlier fix patches and they do not conflict with the NFS export
> optimization patches (ovl-nfs-export branch).
>
> I tested this with upstream overlay/nonsamefs xfstest group:
> - Tests pass for ext4
> - Tests fail for xfs
> - Tests pass for xfs with OVERLAY_MOUNT_OPTIONS=-oxino
>
> I also added --xino option to unionmount-testsuite [2], along with
> the --verify option, the test verifies constant st_ino and that all
> objects are on overlay st_dev.
>
> Changes since v8:
> - Use unique fsid instead of layer id
> - Assign pseudo_dev per fsid instead of per layer
> - Limit "xino" feature to 64bit systems
> - Assign xino value i_ino as well for NFSv3 readdir
> - Add "xino" documentation patch

And:
- Instead of -EOVERFLOW on stat(2) fallback to non-xino behavior

>
> Thanks,
> Amir.
>
> [1] https://github.com/amir73il/linux/commits/ovl-xino
> [2] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
>
> Amir Goldstein (7):
>   ovl: factor out ovl_map_dev_ino() helper
>   ovl: allocate anon bdev per unique lower fs
>   ovl: constant st_ino for non-samefs with xino
>   ovl: consistent i_ino for non-samefs with xino
>   ovl: consistent d_ino for non-samefs with xino
>   ovl: add support for "xino" mount option
>   ovl: update documentation w.r.t "xino" feature
>
>  Documentation/filesystems/overlayfs.txt |  39 +++++++--
>  fs/overlayfs/export.c                   |   2 +-
>  fs/overlayfs/inode.c                    | 140 +++++++++++++++++++++-----------
>  fs/overlayfs/namei.c                    |   4 +-
>  fs/overlayfs/overlayfs.h                |   6 +-
>  fs/overlayfs/ovl_entry.h                |  21 +++--
>  fs/overlayfs/readdir.c                  |  45 ++++++++--
>  fs/overlayfs/super.c                    | 120 ++++++++++++++++++++++-----
>  fs/overlayfs/util.c                     |  38 ++++++++-
>  9 files changed, 318 insertions(+), 97 deletions(-)
>
> --
> 2.7.4
>
