From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH v9 08/15] ovl: Copy up only metadata during copy up where
 it makes sense
Date: Mon, 8 Jan 2018 11:35:09 +0100
Message-ID: <CAJfpegsXEgz6=y7eLe5kJLKHtCyEP5LxzXkg2zB5JjgNJ3=bfg@mail.gmail.com>
References: <20171129155448.32721-1-vgoyal@redhat.com> <20171129155448.32721-9-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:35501 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755823AbeAHKfK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 8 Jan 2018 05:35:10 -0500
Received: by mail-qk0-f195.google.com with SMTP id w184so5314189qka.2
        for <linux-unionfs@vger.kernel.org>; Mon, 08 Jan 2018 02:35:09 -0800 (PST)
In-Reply-To: <20171129155448.32721-9-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-unionfs@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>

On Wed, Nov 29, 2017 at 4:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If it makes sense to copy up only metadata during copy up, do it. This
> is done for regular files which are not opened for WRITE and have origin
> being saved.
>
> Right now ->metacopy is set to 0 always. Last patch in the series will
> remove the hard coded statement and enable metacopy feature.
>
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c | 38 +++++++++++++++++++++++++++++++-------
>  1 file changed, 31 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 31711edf5bde..c5804b87f3c7 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -232,6 +232,26 @@ int ovl_set_attr(struct dentry *upperdentry, struct kstat *stat)
>         return err;
>  }
>
> +static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
> +                                 int flags)
> +{
> +       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> +
> +       /* TODO: Will enable metacopy in last patch of series */
> +       return false;
> +
> +       if (!ofs->config.metacopy)
> +               return false;
> +
> +       if (!S_ISREG(mode))
> +               return false;
> +
> +       if (flags && ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)))
> +               return false;
> +
> +       return true;
> +}
> +
>  struct ovl_fh *ovl_encode_fh(struct dentry *lower, bool is_upper)
>  {
>         struct ovl_fh *fh;
> @@ -305,11 +325,8 @@ static int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
>                         return PTR_ERR(fh);
>         }
>
> -       /*
> -        * Do not fail when upper doesn't support xattrs.
> -        */
>         err = ovl_check_setxattr(dentry, upper, OVL_XATTR_ORIGIN, fh,
> -                                fh ? fh->len : 0, 0);
> +                                fh ? fh->len : 0, -EOPNOTSUPP);
>         kfree(fh);
>
>         return err;
> @@ -326,6 +343,7 @@ struct ovl_copy_up_ctx {
>         struct qstr destname;
>         struct dentry *workdir;
>         bool tmpfile;
> +       bool metacopy;
>  };
>
>  static int ovl_link_up(struct ovl_copy_up_ctx *c)
> @@ -453,10 +471,14 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>          *
>          */
>         err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
> -       if (err)
> -               return err;
> +       if (err) {
> +               if (err != -EOPNOTSUPP)
> +                       return err;
> +               /* Upper does not support xattr. Copy up data as well */
> +               c->metacopy = false;

Isn't this supposed to be checked in ovl_get_super()?

Thanks,
Miklos
