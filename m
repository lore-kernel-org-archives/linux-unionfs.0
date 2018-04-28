Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-17-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-17-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 01:49:38 -0700
Message-ID: <CAOQ4uxjjD0o3H54OozyUfoUSJUw9iqQKvi1m+sTd9hfiA3YOgA@mail.gmail.com>
Subject: Re: [PATCH v14 16/31] ovl: Always open file/inode which contains data
 and not metacopy
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> ovl_open() should open file which contains data and not open metacopy
> inode.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

This looks fine, but I don't see a reason to separate it from 26/31
first allow only data open, then allow also meta open..
Anyway, I am not sure about the cleanest way to sort all the cases.

> ---
>  fs/overlayfs/file.c | 16 ++++++++++++----
>  1 file changed, 12 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/file.c b/fs/overlayfs/file.c
> index 23638d8ebab5..558a859b2658 100644
> --- a/fs/overlayfs/file.c
> +++ b/fs/overlayfs/file.c
> @@ -18,18 +18,26 @@ static struct file *ovl_open_realfile(const struct file *file)
>  {
>         struct inode *inode = file_inode(file);
>         struct inode *upperinode = ovl_inode_upper(inode);
> -       struct inode *realinode = upperinode ?: ovl_inode_lower(inode);
> +       struct inode *realinode;
>         struct file *realfile;
> +       bool upperreal = false;
>         const struct cred *old_cred;
>
> +       if (upperinode && ovl_has_upperdata(inode))
> +               upperreal = true;
> +
> +       /* Always open file which contains data. Do not open metacopy. */
> +       realinode = upperreal ? upperinode : ovl_inode_lowerdata(inode);
> +
>         old_cred = ovl_override_creds(inode->i_sb);
>         realfile = path_open(&file->f_path, file->f_flags | O_NOATIME,
>                              realinode, current_cred(), false);
>         revert_creds(old_cred);
>
>         pr_debug("open(%p[%pD2/%c], 0%o) -> (%p, 0%o)\n",
> -                file, file, upperinode ? 'u' : 'l', file->f_flags,
> -                realfile, IS_ERR(realfile) ? 0 : realfile->f_flags);
> +                file, file, upperreal ? 'u' : 'l',
> +                file->f_flags, realfile,
> +                IS_ERR(realfile) ? 0 : realfile->f_flags);
>
>         return realfile;
>  }
> @@ -80,7 +88,7 @@ static int ovl_real_file(const struct file *file, struct fd *real)
>         real->file = file->private_data;
>
>         /* Has it been copied up since we'd opened it? */
> -       if (unlikely(file_inode(real->file) != ovl_inode_real(inode))) {
> +       if (unlikely(file_inode(real->file) != ovl_inode_real_data(inode))) {
>                 real->flags = FDPUT_FPUT;
>                 real->file = ovl_open_realfile(file);
>
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
