From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: check for emptiness of redirect dir
Date: Wed, 26 Oct 2016 12:45:19 +0200
Message-ID: <CAJfpegur95qHLSp8q7W3rpE9Z-8csf+zUuX3VyeK3YFiN7O2JA@mail.gmail.com>
References: <1477380887-21333-1-git-send-email-mszeredi@redhat.com> <1477474446-13429-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1477474446-13429-1-git-send-email-amir73il@gmail.com>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

On Wed, Oct 26, 2016 at 11:34 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Before introducing redirect_dir feature, the condition
> !ovl_lower_positive(dentry) for a directory, implied that
> it is a pure upper directory, which may be removed if empty.
>
> Now that directory can be redirect, it is possible that
> upper does not cover any lower (i.e. !ovl_lower_positive(dentry)),
> but the directory is a merge (with redirected path) and maybe
> non empty.
>
> Check for this case in ovl_remove_upper().
>
> This change fixes the following test case from rename-pop-dir.py
> of unionmount-testsuite:
>
>     """Remove dir and rename old name"""
>     d = ctx.non_empty_dir()
>     d2 = ctx.no_dir()
>
>     ctx.rmdir(d, err=ENOTEMPTY)
>     ctx.rename(d, d2)
>     ctx.rmdir(d, err=ENOENT)
>     ctx.rmdir(d2, err=ENOTEMPTY)
>
> ./run --ov rename-pop-dir
> /mnt/a/no_dir103: Expected error (Directory not empty) was not produced
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c | 31 ++++++++++++++++++++++---------
>  1 file changed, 22 insertions(+), 9 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 065e021..d750ed9 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -672,9 +672,18 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
>  {
>         struct dentry *upperdir = ovl_dentry_upper(dentry->d_parent);
>         struct inode *dir = upperdir->d_inode;
> -       struct dentry *upper;
> +       struct dentry *upper = NULL;
> +       struct dentry *opaquedir = NULL;
>         int err;
>
> +       /* Redirect dir can be !ovl_lower_positive && OVL_TYPE_MERGE */
> +       if (is_dir && ovl_dentry_is_redirect(dentry)) {
> +               opaquedir = ovl_check_empty_and_clear(dentry);
> +               err = PTR_ERR(opaquedir);
> +               if (IS_ERR(opaquedir))
> +                       return err;
> +       }
> +
>         inode_lock_nested(dir, I_MUTEX_PARENT);
>         upper = lookup_one_len(dentry->d_name.name, upperdir,
>                                dentry->d_name.len);
> @@ -683,14 +692,15 @@ static int ovl_remove_upper(struct dentry *dentry, bool is_dir)
>                 goto out_unlock;
>
>         err = -ESTALE;
> -       if (upper == ovl_dentry_upper(dentry)) {
> -               if (is_dir)
> -                       err = vfs_rmdir(dir, upper);
> -               else
> -                       err = vfs_unlink(dir, upper, NULL);
> -               ovl_dentry_version_inc(dentry->d_parent);
> -       }
> -       dput(upper);
> +       if ((opaquedir && upper != opaquedir) ||
> +            upper != ovl_dentry_upper(dentry))

This will always error out for the opaquedir case.  So it needs to be:

    if ((opaquedir && upper != opaquedir) ||
        (!opaquedir && upper != ovl_dentry_upper(dentry)))

Pushed to "redirect" branch with this fix.

Thanks,
Miklos
