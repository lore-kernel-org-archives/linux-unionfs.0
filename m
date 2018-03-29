Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329090845.39911-1-yangerkun@huawei.com>
References: <20180329090845.39911-1-yangerkun@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 29 Mar 2018 12:36:16 +0300
Message-ID: <CAOQ4uxgP33R-EbY7ErX8ixm0L4p7X-AdGdSVpDGfZG_0+_0p7A@mail.gmail.com>
Subject: Re: [RFC PATCH 1/2] fs/locks: add flock_setlk to help set flock
Content-Type: text/plain; charset="UTF-8"
To: yangerkun <yangerkun@huawei.com>
Cc: Jeff Layton <jlayton@kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, "zhangyi (F)" <yi.zhang@huawei.com>, Miao Xie <miaoxie@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 12:08 PM, yangerkun <yangerkun@huawei.com> wrote:
> Split sys_flock(), add flock_setlk() routine to help kernel set
> flock easily.
>
> Signed-off-by: yangerkun <yangerkun@huawei.com>
> ---
>  fs/locks.c         | 29 +++++++++++++++++------------
>  include/linux/fs.h |  1 +
>  2 files changed, 18 insertions(+), 12 deletions(-)
>
> diff --git a/fs/locks.c b/fs/locks.c
> index d6ff4be..aeef6cf 100644
> --- a/fs/locks.c
> +++ b/fs/locks.c
> @@ -1974,6 +1974,22 @@ int locks_lock_inode_wait(struct inode *inode, struct file_lock *fl)
>  }
>  EXPORT_SYMBOL(locks_lock_inode_wait);
>
> +int flock_setlk(struct file *filp, struct file_lock *lock)
> +{
> +       int err;
> +
> +       err = security_file_lock(filp, lock->fl_type);
> +       if (err)
> +               return err;
> +
> +       if (filp->f_op->flock && is_remote_lock(filp))
> +               return filp->f_op->flock(filp,
> +                                       (lock->fl_flags & FL_SLEEP) ? F_SETLKW : F_SETLK,
> +                                       lock);

Although this was moved as is, please add {} around non-oneliner.

> +       else
> +               return locks_lock_file_wait(filp, lock);

And leave this without else.

> +}
> +

You need to EXPORT_SYMBOL if you want to use this from overlayfs.

Thanks,
Amir.
