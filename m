Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1526531236-21809-1-git-send-email-cgxu519@gmx.com>
References: <1526531236-21809-1-git-send-email-cgxu519@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Thu, 17 May 2018 08:34:37 +0300
Message-ID: <CAOQ4uxjaVnx11bWk4GwvYzG2CviyzB4t_wPRY06DHrzOsdtO+g@mail.gmail.com>
Subject: Re: [PATCH] ovl: add warning and replace errno when failing from copy-up
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, May 17, 2018 at 7:27 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Currently when failing from copy-up there is no meaningful message
> to indicate what was happeing and also directly exposing copy-up
> error to user probably makes confusing. For example, if copy-up failed
> by upperdir/workdir are belong to different project quotas, write mode
> open will present error as -EXDEV(Cross-device link).
>
> This patch adds proper warning message and replaces errno with -EIO
> when failing from copy-up.
>
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>  fs/overlayfs/copy_up.c | 10 ++++++++++
>  fs/overlayfs/export.c  |  4 +---
>  2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 8bede07..4e1f890 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -825,6 +825,16 @@ int ovl_copy_up_flags(struct dentry *dentry, int flags)
>         }
>         revert_creds(old_cred);
>
> +       if (err) {
> +               if (err == -EXDEV)
> +                       pr_warn_ratelimited("overlayfs: copy up failed, probably caused by project quota. (%pd2, err=%i)\n",
> +                                   dentry, err);
> +               else
> +                       pr_warn_ratelimited("overlayfs: copy up failed. (%pd2, err=%i)\n",
> +                                   dentry, err);
> +               err = -EIO;
> +       }
> +

I understand what you are trying to do and it makes sense, but I think
it is wrong
to replace meaningful errors like ENOSPC EDQUOT with EIO.

It's true that for some operations (e.g. chmod) these errors didn't
use to make sense,
but the COW ENOSPC behavior has been with us for a long time, not only with
overlayfs, and IMO there is no escape from updating the manual pages and
educating the world about the consequences of COW file systems.

Therefore, I suggest that you replace only EXDEV with EIO and maybe
other special cases that you find and leave the general case as is
(with addition of the warning).


>         return err;
>  }
>
> diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> index 425a946..c66477f 100644
> --- a/fs/overlayfs/export.c
> +++ b/fs/overlayfs/export.c
> @@ -30,9 +30,7 @@ static int ovl_encode_maybe_copy_up(struct dentry *dentry)
>         if (!err) {
>                 err = ovl_copy_up(dentry);
>                 ovl_drop_write(dentry);
> -       }
> -
> -       if (err) {
> +       } else {
>                 pr_warn_ratelimited("overlayfs: failed to copy up on encode (%pd2, err=%i)\n",
>                                     dentry, err);

I think you should leave this warning as is. It's a special cases for
NFS export that
is here to hint on the reason for failure to export overlayfs.
The warning on copy up failure along is not a good enough hint.

Thanks,
Amir.
