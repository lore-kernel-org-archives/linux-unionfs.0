Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-26-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-26-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 10:35:24 +0300
Message-ID: <CAOQ4uxgZb3Sp70xihz3BQi6AnR+5W2PMPd3B862RgiYUOEe9AA@mail.gmail.com>
Subject: Re: [PATCH v13 25/28] ovl: Use out_err insteada of out_nomem
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now we use goto out_nomem which assumes error code is -ENOMEM. But
> there are other errors returned like -ESTALE as well. So instead of out_nomem,
> use out_err which will do ERR_PTR(err). That way one can putt error code
> in err and jump to out_err.
>
> This just code reorganization and no change of functionality.
>
> I am about to add more code and this organization helps laying more code
> and error paths on top of it.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/inode.c | 17 ++++++++++-------
>  1 file changed, 10 insertions(+), 7 deletions(-)
>
> diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> index cd03f3e642fd..3dccfa1ee123 100644
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -693,6 +693,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>         struct inode *inode;
>         bool bylower = ovl_hash_bylower(sb, upperdentry, lowerdentry, index);
>         bool is_dir, metacopy = false;
> +       int err = -ENOMEM;
>
>         if (!realinode)
>                 realinode = d_inode(lowerdentry);
> @@ -710,7 +711,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>                 inode = iget5_locked(sb, (unsigned long) key,
>                                      ovl_inode_test, ovl_inode_set, key);
>                 if (!inode)
> -                       goto out_nomem;
> +                       goto out_err;
>                 if (!(inode->i_state & I_NEW)) {
>                         /*
>                          * Verify that the underlying files stored in the inode
> @@ -719,8 +720,8 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>                         if (!ovl_verify_inode(inode, lowerdentry, upperdentry,
>                                               true)) {
>                                 iput(inode);
> -                               inode = ERR_PTR(-ESTALE);
> -                               goto out;
> +                               err = -ESTALE;
> +                               goto out_err;
>                         }
>
>                         dput(upperdentry);
> @@ -735,8 +736,10 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>         } else {
>                 /* Lower hardlink that will be broken on copy up */
>                 inode = new_inode(sb);
> -               if (!inode)
> -                       goto out_nomem;
> +               if (!inode) {
> +                       err = -ENOMEM;

I recon Miklos prefers setting err value before condition.
same with ESTALE above

> +                       goto out_err;
> +               }
>         }
>         ovl_fill_inode(inode, realinode->i_mode, realinode->i_rdev);
>         ovl_inode_init(inode, upperdentry, lowerdentry);
> @@ -766,7 +769,7 @@ struct inode *ovl_get_inode(struct super_block *sb, struct dentry *upperdentry,
>  out:
>         return inode;
>
> -out_nomem:
> -       inode = ERR_PTR(-ENOMEM);
> +out_err:
> +       inode = ERR_PTR(err);
>         goto out;
>  }
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
