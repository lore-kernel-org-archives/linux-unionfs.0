Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180306205408.23383-16-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-16-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Mar 2018 10:21:30 +0200
Message-ID: <CAOQ4uxhey5gG+oB1BUM465-S29rBgU90T8iAwE3Nb5KxWoWepA@mail.gmail.com>
Subject: Re: [PATCH v12 15/17] ovl: Remove redirect when data of a metacopy
 file is copied up
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> When a metacopy file is no longer a metacopy and data has been copied up,
> remove REDIRECT xattr. Its not needed anymore.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 0c8d2755bd25..704febd2e2fa 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -775,6 +775,15 @@ static int ovl_copy_up_meta_inode_data(struct ovl_copy_up_ctx *c)
>         if (err)
>                 return err;
>
> +       /*
> +        * A metacopy files does not need redirect xattr once data has
> +        * been copied up.
> +        */
> +       err = vfs_removexattr(upperpath.dentry, OVL_XATTR_REDIRECT);
> +       if (err && err != -ENODATA && err != -EOPNOTSUPP)
> +               return err;
> +
> +       err = 0;
>         ovl_set_upperdata(d_inode(c->dentry));
>         return err;

By intuition, I would say that removing redirect should be done after setting
upperdata flag. Not sure if it really matters in real life.
Maybe when racing a lookup of a metacopy hardlink and copy up data of
an upper alias?

Also, it would make sense to also ovl_dentry_set_redirect(c->dentry, NULL)
probably use a helper ovl_clear_redirect() for the locking.

But that highlights a serious problem with current patches -
Access to OVL_I(inode)->redirect is protected with parent mutex in ovl_lookup()
and additionally with dentry->d_lock in ovl_rename()
That is sufficient for directories which can only have a single dentry
alias to an
inode but not at all sufficient for non-directories.

Thanks,
Amir.
