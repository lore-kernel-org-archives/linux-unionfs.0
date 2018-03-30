Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-22-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-22-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 10:31:46 +0300
Message-ID: <CAOQ4uxhsijEOhGS8mBP_gtMFu0uERd6gK_2UfR-kN1D=wv5Kzw@mail.gmail.com>
Subject: Re: [PATCH v13 21/28] ovl: Set redirect on metacopy files upon rename
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Set redirect on metacopy files upon rename. This will help find data dentry
> in lower dirs.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/dir.c | 50 +++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 37 insertions(+), 13 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 3ea052b6bac7..7c0a02d9f6bd 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -968,6 +968,27 @@ static void ovl_rename_unlock_ovl_inodes(struct dentry *old, struct dentry *new,
>                 mutex_unlock(&OVL_I(d_inode(new))->lock);
>  }
>
> +static bool ovl_relative_redirect(struct dentry *dentry, bool samedir)
> +{
> +       if (d_is_dir(dentry))
> +               return samedir;
> +
> +       /*
> +        * For non-dir hardlinked files, we need absolute redirects
> +        * in general as two upper hardlinks could be in different
> +        * dirs. We could put a relative redirect now and convert
> +        * it to absolute redirect later. But when nlink > 1 and
> +        * indexing is on, that means relative redirect needs to be
> +        * converted to absolute during copy up of another lower
> +        * hardllink as well.
> +        *
> +        * So without optimizing too much, just check if non-dir
> +        * has nlink > 1 or not. If yes, set absolute redirect to
> +        * begin with.
> +        */
> +       return (d_inode(dentry)->i_nlink > 1 ? false : samedir);

I don't think this is wrong, but I don't like relying on the overlay inode
nlink. I wonder if you should separate the case of indexed and
non-indexed inode.

> +}
> +
>  static int ovl_rename(struct inode *olddir, struct dentry *old,
>                       struct inode *newdir, struct dentry *new,
>                       unsigned int flags)
> @@ -1131,22 +1152,25 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>                 goto out_dput;
>
>         err = 0;
> -       if (is_dir) {
> -               if (ovl_type_merge_or_lower(old))
> -                       err = ovl_set_redirect(old, samedir);
> -               else if (!old_opaque && ovl_type_merge(new->d_parent))
> -                       err = ovl_set_opaque_xerr(old, olddentry, -EXDEV);
> -               if (err)
> -                       goto out_dput;
> -       }
> -       if (!overwrite && new_is_dir) {
> +       if (ovl_type_merge_or_lower(old))
> +               err = ovl_set_redirect(old,
> +                                      ovl_relative_redirect(old, samedir));
> +       else if (is_dir && !old_opaque && ovl_type_merge(new->d_parent))
> +               err = ovl_set_opaque_xerr(old, olddentry, -EXDEV);
> +
> +       if (err)
> +               goto out_dput;
> +
> +       if (!overwrite) {
>                 if (ovl_type_merge_or_lower(new))
> -                       err = ovl_set_redirect(new, samedir);
> -               else if (!new_opaque && ovl_type_merge(old->d_parent))
> +                       err = ovl_set_redirect(new, ovl_relative_redirect(new,
> +                                              samedir));
> +               else if (new_is_dir && !new_opaque &&
> +                        ovl_type_merge(old->d_parent))
>                         err = ovl_set_opaque_xerr(new, newdentry, -EXDEV);
> -               if (err)
> -                       goto out_dput;
>         }
> +       if (err)
> +               goto out_dput;
>
>         err = ovl_do_rename(old_upperdir->d_inode, olddentry,
>                             new_upperdir->d_inode, newdentry, flags);
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
