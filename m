Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-25-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-25-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 10:41:00 +0300
Message-ID: <CAOQ4uxhqEixOYR=6KSeGEYbGMDRO7n83KTNBFTwaVNfsXOHUiA@mail.gmail.com>
Subject: Re: [PATCH v13 24/28] ovl: Do not error if REDIRECT XATTR is missing
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Currently we first call vfs_getxattr() to get size of REDIRECT xatttr and
> then make another call vfs_getxattr() to read the xattr in buffer.
>
> This is all part of ovl_lookup() and we do not have ovl_inode->lock. That
> means it is possible that inode got copied up on another cpu and is not
> a metacopy inode anymore. And that also means REDIRECT xattr got removed.
> And that means that while first call to vfs_getxattr() succeeded, second
> call can fail with -ENODATA.
>
> Do not error out if -ENODATA is received from second call. With metacopy
> enabled, it is not an error case anymore.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/namei.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index a7a9588f64b7..a97666245726 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -47,8 +47,15 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
>                 goto invalid;
>
>         res = vfs_getxattr(dentry, OVL_XATTR_REDIRECT, buf, res);
> -       if (res < 0)
> +       if (res < 0) {
> +               /*
> +                * Redirect xattr can be removed if a parallel data
> +                * copy up took place.
> +                */
> +               if (res == -ENODATA)
> +                       goto err_free;
>                 goto fail;
> +       }
>         if (res == 0)
>                 goto invalid;
>         if (buf[0] == '/') {
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
