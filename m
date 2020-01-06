Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20191223064025.23801-1-amir73il@gmail.com>
In-Reply-To: <20191223064025.23801-1-amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 6 Jan 2020 08:35:25 +0200
Message-ID: <CAOQ4uxh4NygFUFvUp3xs8rZRUkc3SDxO1DL6YrNhx3j0SBgAJg@mail.gmail.com>
Subject: Re: [PATCH] ovl: fix wrong WARN_ON() in ovl_cache_update_ino()
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, Dec 23, 2019 at 8:40 AM Amir Goldstein <amir73il@gmail.com> wrote:
>
> The WARN_ON() that child entry is always on overlay st_dev became wrong
> when we allowed this function to update d_ino in non-samefs setup with
> xino enabled.
>
> It is not true in case of xino bits overflow on a non-dir inode.
> Leave the WARN_ON() only for directories, where assertion is still true.
>
> Fixes: adbf4f7ea834 ("ovl: consistent d_ino for non-samefs with xino")
> Cc: <stable@vger.kernel.org> # v4.17+
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>

Miklos,

If you have time, please send this one to Linus for v5.5.
It is a simple fix and the only one causing failure in the new xfstests [1]
that I posted.

Thanks,
Amir.

[1] https://lore.kernel.org/fstests/20191230141423.31695-1-amir73il@gmail.com/

>
>  fs/overlayfs/readdir.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 47a91c9733a5..7255e6a5838f 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -504,7 +504,13 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
>                 if (err)
>                         goto fail;
>
> -               WARN_ON_ONCE(dir->d_sb->s_dev != stat.dev);
> +               /*
> +                * Directory inode is always on overlay st_dev.
> +                * Non-dir with ovl_same_dev() could be on pseudo st_dev in case
> +                * of xino bits overflow.
> +                */
> +               WARN_ON_ONCE(S_ISDIR(stat.mode) &&
> +                            dir->d_sb->s_dev != stat.dev);
>                 ino = stat.ino;
>         } else if (xinobits && !OVL_TYPE_UPPER(type)) {
>                 ino = ovl_remap_lower_ino(ino, xinobits,
> --
> 2.17.1
>
