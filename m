Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329090856.39966-1-yangerkun@huawei.com>
References: <20180329090856.39966-1-yangerkun@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Mar 2018 14:39:20 +0300
Message-ID: <CAOQ4uxgjpJgMaNe1L3-LQ9mSQ1MUtyj82MnimPi09KwYjme=iw@mail.gmail.com>
Subject: Re: [RFC PATCH 2/2] overlay: add no wait share flock for
 lowers/upper/work dirs to help check mount
Content-Type: text/plain; charset="UTF-8"
To: yangerkun <yangerkun@huawei.com>
Cc: Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 12:08 PM, yangerkun <yangerkun@huawei.com> wrote:
> In order to help check any dirs has been used in overlay, add share
> flock to lowerdirs/upperdir/workdir, so user space can use flock -x to
> help check mount.

Rephrase: so fsck.overlay can use flock -x to get an exclusive access
to fix overlay layers.

Yangerkun,

Besides addressing fsck.overlay exclusive access requirement, this work
should also make ovl_inuse_lock() obsolete. It should be replaced by an
exclusive flock on upperdir/workdir.

Please write a new xfstest (you can clone overlay/036) that tests
the interaction of overlayfs mount with flock -x and flock -s from usersapce.

Thanks for working on this.
See more comments below.

>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  fs/overlayfs/ovl_entry.h |  3 ++
>  fs/overlayfs/super.c     | 87 ++++++++++++++++++++++++++++++++++++++++++++++++
>  2 files changed, 90 insertions(+)
>
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index bfef6ed..69dd89c 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -35,10 +35,13 @@ struct ovl_path {
>  /* private information held for overlayfs's superblock */
>  struct ovl_fs {
>         struct vfsmount *upper_mnt;
> +       struct file *upperfile;
>         unsigned numlower;
>         struct ovl_layer *lower_layers;
> +       struct file **lowerfiles;

Instead of lowerfiles array add file to struct ovl_layer.

>         /* workbasedir is the path at workdir= mount option */
>         struct dentry *workbasedir;
> +       struct file *workbasefile;

workbasedir it almost only used for the old ovl_inuse_lock() and you can
get it from workbasefile. No reason to keep both around.

>         /* workdir is the 'work' directory under workbasedir */
>         struct dentry *workdir;
>         /* index directory listing overlay inodes by origin file handle */
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 9ee37c7..e311c66 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -16,6 +16,7 @@
>  #include <linux/module.h>
>  #include <linux/statfs.h>
>  #include <linux/seq_file.h>
> +#include <linux/file.h>
>  #include <linux/posix_acl_xattr.h>
>  #include "overlayfs.h"
>
> @@ -233,15 +234,31 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>         if (ofs->workdir_locked)
>                 ovl_inuse_unlock(ofs->workbasedir);
>         dput(ofs->workbasedir);
> +
> +       if (ofs->workbasefile)
> +               fput(ofs->workbasefile);
> +
>         if (ofs->upperdir_locked)
>                 ovl_inuse_unlock(ofs->upper_mnt->mnt_root);
>         mntput(ofs->upper_mnt);
> +
> +       if (ofs->upperfile)
> +               fput(ofs->upperfile);
> +
>         for (i = 0; i < ofs->numlower; i++) {
>                 mntput(ofs->lower_layers[i].mnt);
>                 free_anon_bdev(ofs->lower_layers[i].pseudo_dev);
>         }
>         kfree(ofs->lower_layers);
>
> +       if (ofs->lowerfiles) {
> +               for (i = 0; i < ofs->numlower; i++) {
> +                       if (ofs->lowerfiles[i])
> +                               fput(ofs->lowerfiles[i]);
> +               }
> +               kfree(ofs->lowerfiles);
> +       }
> +
>         kfree(ofs->config.lowerdir);
>         kfree(ofs->config.upperdir);
>         kfree(ofs->config.workdir);
> @@ -902,15 +919,49 @@ static int ovl_other_xattr_set(const struct xattr_handler *handler,
>         NULL
>  };
>
> +static int ovl_add_share_flock(struct file *filp)

This name is strange. ovl_flock() seems descriptive enough
and it should take a 'cmd' argument, so you can use it also for
exclusive flock.

> +{
> +       int err;
> +       struct file_lock *fl = locks_alloc_lock();
> +
> +       if (!fl)
> +               return -ENOMEM;
> +       fl->fl_file = filp;
> +       fl->fl_owner = filp;
> +       fl->fl_pid = current->tgid;
> +       fl->fl_flags = FL_FLOCK;
> +       fl->fl_type = F_RDLCK;
> +       fl->fl_end = OFFSET_MAX;

I would consider making non static and exporting flock_make_lock()

> +
> +       err = flock_setlk(filp, fl);
> +       locks_free_lock(fl);
> +       return err;
> +}
> +
>  static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
>  {
>         struct vfsmount *upper_mnt;
> +       struct file *upperfile;
>         int err;
>
>         err = ovl_mount_dir(ofs->config.upperdir, upperpath);
>         if (err)
>                 goto out;
>
> +       upperfile = ovl_path_open(upperpath, O_DIRECTORY);
> +       if (IS_ERR(upperfile)) {
> +               pr_err("overlayfs: unable to open upperdir.\n");
> +               err = PTR_ERR(upperfile);
> +               goto out;
> +       }
> +
> +       ofs->upperfile = upperfile;
> +       err = ovl_add_share_flock(upperfile);

It should be an exclusive lock if index feature is enabled,
instead of ovll_inuse_lock().

Thanks,
Amir.
