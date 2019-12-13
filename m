Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <1e61319cf6d1f3c8f313a01b0198be4745f9f460.1576208513.git.lijiazi@xiaomi.com>
In-Reply-To: <1e61319cf6d1f3c8f313a01b0198be4745f9f460.1576208513.git.lijiazi@xiaomi.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 13 Dec 2019 14:19:36 +0200
Message-ID: <CAOQ4uxifkz9wFSo58SWeru58tOvfLC_S436QiSx0Hn-XaC-Vnw@mail.gmail.com>
Subject: Re: [PATCH] ovl: use pr_fmt auto generate prefix
Content-Type: text/plain; charset="UTF-8"
To: lijiazi <jqqlijiazi@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, lijiazi <lijiazi@xiaomi.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Dec 13, 2019 at 1:13 PM lijiazi <jqqlijiazi@gmail.com> wrote:
>
> Use pr_fmt auto generate "overlayfs: " prefix.
>
> Signed-off-by: lijiazi <lijiazi@xiaomi.com>
> ---
>  fs/overlayfs/Makefile    |  4 +--
>  fs/overlayfs/copy_up.c   |  2 +-
>  fs/overlayfs/dir.c       | 10 +++---
>  fs/overlayfs/export.c    | 12 +++----
>  fs/overlayfs/inode.c     |  6 ++--
>  fs/overlayfs/namei.c     | 26 +++++++--------
>  fs/overlayfs/overlayfs.h |  6 ++++
>  fs/overlayfs/readdir.c   |  8 ++---
>  fs/overlayfs/super.c     | 85 ++++++++++++++++++++++++------------------------
>  fs/overlayfs/util.c      | 14 ++++----
>  10 files changed, 90 insertions(+), 83 deletions(-)
>
> diff --git a/fs/overlayfs/Makefile b/fs/overlayfs/Makefile
> index 9164c58..73ba668 100644
> --- a/fs/overlayfs/Makefile
> +++ b/fs/overlayfs/Makefile
> @@ -3,7 +3,7 @@
>  # Makefile for the overlay filesystem.
>  #
>
> -obj-$(CONFIG_OVERLAY_FS) += overlay.o
> +obj-$(CONFIG_OVERLAY_FS) += overlayfs.o
>
> -overlay-objs := super.o namei.o util.o inode.o file.o dir.o readdir.o \
> +overlayfs-objs := super.o namei.o util.o inode.o file.o dir.o readdir.o \
>                 copy_up.o export.o

But see ef94b1864d1e ovl: rename filesystem type to "overlay"

You can just use the string "overlayfs:" instead of KBUILD_MODNAME.

Thanks,
Amir.
