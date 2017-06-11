From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC] ovl: System-wide unique st_dev
Date: Sun, 11 Jun 2017 18:33:54 +0300
Message-ID: <CAOQ4uxgRVFoVZDLgpFP2yfTjRHcsK+22ksNNqpEKd0rLXaHdXQ@mail.gmail.com>
References: <20170611134430.4360-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34902 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751679AbdFKPd4 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 11 Jun 2017 11:33:56 -0400
Received: by mail-ot0-f195.google.com with SMTP id t31so9343951ota.2
        for <linux-unionfs@vger.kernel.org>; Sun, 11 Jun 2017 08:33:55 -0700 (PDT)
In-Reply-To: <20170611134430.4360-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Sun, Jun 11, 2017 at 4:44 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> The following sequence of commands causes a lowerdir file and an
> overlay file to have the same values for st_ino/st_dev,

You meant different st_dev values...

All in all, looks very good to me. Nice work!
See some nits and suggestions below.

Did you get any progress with tests yet?

>
> $ xfs_io -f -c "pwrite 0 4k" /mnt/lowerdir/testfile -c sync
> $ xfs_io -a -c "pwrite 4k 4k" /mnt/ovl/testfile # Copy-up occurs here

Honestly, I think you could find a simpler example and also one that
demonstrates
the bug, something like:

$ echo 123 > /mnt/lowerdir/testfile
$ echo 456 > /mnt/ovl/testfile
$ cat /mnt/lowerdir/testfile /mnt/ovl/testfile
123
456
$ diff /mnt/lowerdir/testfile /mnt/ovl/testfile && echo "123  == 456 ???"

But that diff example will only demonstrate a bug on top of my branch,
and I don't think that is the right order for this patch. it should
come *before*
the relax samefs patch, so maybe just drop the example?

>
> This commit solves the bug by reporting pseudo device numbers for files
> on lowerdir.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
>  fs/overlayfs/inode.c     | 23 ++++++++++++++++++++---
>  fs/overlayfs/ovl_entry.h |  8 +++++++-
>  fs/overlayfs/super.c     | 33 +++++++++++++++++++++++++--------
>  3 files changed, 52 insertions(+), 12 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index 5f285c1..154c87892 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -13,6 +13,19 @@
>  #include <linux/xattr.h>
>  #include <linux/posix_acl.h>
>  #include "overlayfs.h"
> +#include "ovl_entry.h"
> +
> +static dev_t get_lowerdir_pseudo_dev(struct ovl_fs *ufs, dev_t dev)

I suggest to call this ovl_get_pseudo_dev (see below why) and
I suggest to check if dev == upper real dev and return the overlay dev.

> +{
> +       int i;
> +
> +       for (i = 0; i < ufs->numlower; i++) {
> +               if (ufs->lower_mnt[i].real_dev == dev)
> +                       return ufs->lower_mnt[i].pseudo_dev;
> +       }
> +
> +       BUG();

No need to BUG() here WARN() and return dev will not cause any
catastrophic bug. overlay will just behave as it does today..

> +}
>
>  int ovl_setattr(struct dentry *dentry, struct iattr *attr)
>  {
> @@ -61,6 +74,7 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>                 u32 request_mask, unsigned int flags)
>  {
>         struct dentry *dentry = path->dentry;
> +       struct ovl_fs *ufs;

I prefer ofs. The use of ufs is mostly when the info is not yet attached to sb.
Not sure if this was intentional, but its convenient.

>         enum ovl_path_type type;
>         struct path realpath;
>         const struct cred *old_cred;
> @@ -103,10 +117,13 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>                         if (is_dir || lowerstat.nlink == 1)
>                                 stat->ino = lowerstat.ino;
>
> -                       if (samefs)
> +                       if (samefs) {
>                                 WARN_ON_ONCE(stat->dev != lowerstat.dev);
> -                       else
> -                               stat->dev = lowerstat.dev;
> +                       } else {
> +                               ufs = dentry->d_sb->s_fs_info;
> +                               stat->dev = get_lowerdir_pseudo_dev(ufs,
> +                                                               lowerstat.dev);

if (!is_dir && !samefs) { stat->dev = ovl_get_pseudo_dev ... }
should be outside the OVL_TYPE_ORIGIN condition, because
it also applies to pure lower and pure upper inodes (not copied up).

For pure upper it is just nicer and du -xs will work better on
pure upper dirs.
For lower, it is a must, because overlay inode needs to preserve
st_dev across copy up, so it needs to have the pseudo lower st_dev
before that lower becomes the origin of a copy up.


> +                       }
>                 }
>                 if (samefs)
>                         stat->dev = dentry->d_sb->s_dev;
