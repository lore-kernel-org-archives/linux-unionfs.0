From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: System-wide unique st_dev
Date: Mon, 19 Jun 2017 20:45:37 +0300
Message-ID: <CAOQ4uxh-x2+csds8S-VJNen8J8W8RcTAfQUuzBQ2zJ2QSJsRNw@mail.gmail.com>
References: <20170619152210.15930-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f193.google.com ([74.125.82.193]:33801 "EHLO
        mail-ot0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751919AbdFSRpj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 19 Jun 2017 13:45:39 -0400
Received: by mail-ot0-f193.google.com with SMTP id p48so12366987otc.1
        for <linux-unionfs@vger.kernel.org>; Mon, 19 Jun 2017 10:45:38 -0700 (PDT)
In-Reply-To: <20170619152210.15930-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Mon, Jun 19, 2017 at 6:22 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On an overlayfs instance having lower and upper dirs on the same
> filesystem, stat(2) on a file residing on the lower dir will

This is not what the patch should do. The patch should deal with !samefs case.

> provide st_dev corresponding to the lower filesystem's bdev. Later, After
> the lower file is copied-up, stat(2) on the file provides st_dev
> corresponding to the overlayfs' pseudo device. Hence we have a mismatch
> in the st_dev value that is provided to the userspace.

All this is true, but you patch should not be bothering with constant st_dev
over copy up. my patches do that.
Your patch should provide the pseudo st_dev for lower, which my patch
"relax same fs constrain for constant st_ino" needs to be able to use
the lower (pseudo) dev as the constant st_dev across copy up.

Yes, it can be confusing. After everything falls into place you will have an
Ahh moment... Let me know if anything is unclear.

>
> This commit allocates pseudo bdevs for each of the lowerdirs and
> provides the value of such a pseudo bdev for stat(2) on files that
> either reside only on the lower dir or have been copied up from a
> file that was originally present on the lowedir.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/overlayfs/inode.c     | 24 ++++++++++++++++++++++--
>  fs/overlayfs/ovl_entry.h |  9 ++++++++-
>  fs/overlayfs/super.c     | 34 ++++++++++++++++++++++++++--------
>  3 files changed, 56 insertions(+), 11 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index d613e2c..8f6d66c 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -8,11 +8,28 @@
>   */
>
>  #include <linux/fs.h>
> +#include <linux/mount.h>
>  #include <linux/slab.h>
>  #include <linux/cred.h>
>  #include <linux/xattr.h>
>  #include <linux/posix_acl.h>
>  #include "overlayfs.h"
> +#include "ovl_entry.h"
> +
> +static dev_t ovl_get_pseudo_dev(struct ovl_fs *ofs, dev_t dev)
> +{
> +       int i;
> +
> +       if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb->s_dev == dev)
> +               return ofs->ovl_sb->s_dev;

You don't need to store ovl_sb.
Pass dentry into this function and use dentry->d_sb.

> +
> +       for (i = 0; i < ofs->numlower; i++) {
> +               if (ofs->lower_mnt[i].real_dev == dev)
> +                       return ofs->lower_mnt[i].pseudo_dev;
> +       }
> +
> +       return dev;
> +}
>
>  int ovl_setattr(struct dentry *dentry, struct iattr *attr)
>  {
> @@ -100,10 +117,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>                          * upper files, so we cannot use the lower origin st_ino
>                          * for those different files, even for the same fs case.
>                          */
> -                       if (is_dir || lowerstat.nlink == 1)
> +                       if (is_dir || lowerstat.nlink == 1) {
>                                 stat->ino = lowerstat.ino;
> +                               stat->dev = lowerstat.dev;
> +                       }
>                 }
> -               stat->dev = dentry->d_sb->s_dev;
> +               stat->dev = ovl_get_pseudo_dev(dentry->d_sb->s_fs_info,
> +                                       stat->dev);

samefs case should not be changed.
samefs means that all lower layers are same sb as upper so all get overlay dev
in stat(2).

The purpose of your work in to fix the !samefs case.
!samefs should return overlay dev for upper inodes and pseudo lower dev for
lower inodes.

Thanks,
Amir.
