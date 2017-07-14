From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH V2] ovl: Allocate anonymous devs for lowerdirs
Date: Fri, 14 Jul 2017 11:38:31 +0200
Message-ID: <CAJfpegs9W=qQRXBeF7h4t4bxnXvbGnTbUi+iGaZhft79Mvxgtw@mail.gmail.com>
References: <20170623110118.19975-1-chandan@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:35378 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753479AbdGNJid (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 14 Jul 2017 05:38:33 -0400
Received: by mail-oi0-f66.google.com with SMTP id l130so9631607oib.2
        for <linux-unionfs@vger.kernel.org>; Fri, 14 Jul 2017 02:38:33 -0700 (PDT)
In-Reply-To: <20170623110118.19975-1-chandan@linux.vnet.ibm.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>

On Fri, Jun 23, 2017 at 1:01 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
> provides unique values for st_dev. The unique values are obtained by
> allocating anonymous bdevs for each of the lowerdirs in the overlayfs
> instance.
>
> Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
> ---
> Changelog:
> v1->v2: Drop code that provided unique st_dev across copy up.
>
>  fs/overlayfs/inode.c     | 20 ++++++++++++++++++++
>  fs/overlayfs/ovl_entry.h |  8 +++++++-
>  fs/overlayfs/super.c     | 33 +++++++++++++++++++++++++--------
>  3 files changed, 52 insertions(+), 9 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index d613e2c..e30bdca 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -8,11 +8,29 @@
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
> +static dev_t ovl_get_pseudo_dev(struct dentry *dentry, dev_t dev)
> +{
> +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> +       int i;
> +
> +       if (ofs->upper_mnt && ofs->upper_mnt->mnt_sb->s_dev == dev)
> +               return dev;
> +
> +       for (i = 0; i < ofs->numlower; i++) {
> +               if (ofs->lower_mnt[i].real_dev == dev)
> +                       return ofs->lower_mnt[i].pseudo_dev;
> +       }
> +
> +       return dev;
> +}

This is a good way to test out the functionality.  But there's a
trivial way to optimize away the O(num of layers) from this function:
instead of using struct path for lower stack, use

struct ovl_lower {
        struct ovl_lower_mnt *layer;
        struct dentry *dentry;
};

That means one more dereference to get the vfsmount, but I don't think
we need to care about that.

>
>  int ovl_setattr(struct dentry *dentry, struct iattr *attr)
>  {
> @@ -116,6 +134,8 @@ int ovl_getattr(const struct path *path, struct kstat *stat,
>                  */
>                 stat->dev = dentry->d_sb->s_dev;
>                 stat->ino = dentry->d_inode->i_ino;
> +       } else {
> +               stat->dev = ovl_get_pseudo_dev(dentry, stat->dev);
>         }
>
>         /*
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index 34bc4a9..92aebe9 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -16,11 +16,17 @@ struct ovl_config {
>         bool redirect_dir;
>  };
>
> +struct ovl_lower_mnt {
> +       struct vfsmount *mnt;
> +       dev_t real_dev;

Why store the real_dev?  It's stored in mnt->mnt_sb->s_dev, right?

> +       dev_t pseudo_dev;
> +};
> +
>  /* private information held for overlayfs's superblock */
>  struct ovl_fs {
>         struct vfsmount *upper_mnt;
>         unsigned numlower;
> -       struct vfsmount **lower_mnt;
> +       struct ovl_lower_mnt *lower_mnt;
>         struct dentry *workdir;
>         long namelen;
>         /* pathnames of lower and upper dirs, for show_options */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 4882ffb..c922a92 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -172,8 +172,10 @@ static void ovl_put_super(struct super_block *sb)
>
>         dput(ufs->workdir);
>         mntput(ufs->upper_mnt);
> -       for (i = 0; i < ufs->numlower; i++)
> -               mntput(ufs->lower_mnt[i]);
> +       for (i = 0; i < ufs->numlower; i++) {
> +               mntput(ufs->lower_mnt[i].mnt);
> +               free_anon_bdev(ufs->lower_mnt[i].pseudo_dev);
> +       }
>         kfree(ufs->lower_mnt);
>
>         kfree(ufs->config.lowerdir);
> @@ -908,15 +910,25 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         }
>
>         err = -ENOMEM;
> -       ufs->lower_mnt = kcalloc(numlower, sizeof(struct vfsmount *), GFP_KERNEL);
> +       ufs->lower_mnt = kcalloc(numlower, sizeof(struct ovl_lower_mnt),
> +                               GFP_KERNEL);
>         if (ufs->lower_mnt == NULL)
>                 goto out_put_workdir;
>         for (i = 0; i < numlower; i++) {
> -               struct vfsmount *mnt = clone_private_mount(&stack[i]);
> +               struct vfsmount *mnt;
> +               dev_t dev;
>
> +               err = get_anon_bdev(&dev);
> +               if (err) {
> +                       pr_err("overlayfs: failed to get anonymous bdev for lowerpath\n");
> +                       goto out_put_lower_mnt;
> +               }
> +
> +               mnt = clone_private_mount(&stack[i]);
>                 err = PTR_ERR(mnt);
>                 if (IS_ERR(mnt)) {
>                         pr_err("overlayfs: failed to clone lowerpath\n");
> +                       free_anon_bdev(dev);
>                         goto out_put_lower_mnt;
>                 }
>                 /*
> @@ -925,7 +937,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                  */
>                 mnt->mnt_flags |= MNT_READONLY | MNT_NOATIME;
>
> -               ufs->lower_mnt[ufs->numlower] = mnt;
> +               ufs->lower_mnt[ufs->numlower].mnt = mnt;
> +               ufs->lower_mnt[ufs->numlower].real_dev = mnt->mnt_sb->s_dev;
> +               ufs->lower_mnt[ufs->numlower].pseudo_dev = dev;
>                 ufs->numlower++;
>
>                 /* Check if all lower layers are on same sb */
> @@ -980,7 +994,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         }
>         for (i = 0; i < numlower; i++) {
>                 oe->lowerstack[i].dentry = stack[i].dentry;
> -               oe->lowerstack[i].mnt = ufs->lower_mnt[i];
> +               oe->lowerstack[i].mnt = ufs->lower_mnt[i].mnt;
>         }
>         kfree(stack);
>
> @@ -999,8 +1013,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>  out_put_cred:
>         put_cred(ufs->creator_cred);
>  out_put_lower_mnt:
> -       for (i = 0; i < ufs->numlower; i++)
> -               mntput(ufs->lower_mnt[i]);
> +       for (i = 0; i < ufs->numlower; i++) {
> +               if (ufs->lower_mnt[i].mnt)
> +                       free_anon_bdev(ufs->lower_mnt[i].pseudo_dev);
> +               mntput(ufs->lower_mnt[i].mnt);
> +       }
>         kfree(ufs->lower_mnt);
>  out_put_workdir:
>         dput(ufs->workdir);
> --
> 2.9.4
>
