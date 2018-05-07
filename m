Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180507174102.24086-19-vgoyal@redhat.com>
References: <20180507174102.24086-1-vgoyal@redhat.com> <20180507174102.24086-19-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Mon, 7 May 2018 22:39:26 +0300
Message-ID: <CAOQ4uxjhCjK96s7V8wrdTeKipqWcYqOARQCvT-f4eUMHFnBgEA@mail.gmail.com>
Subject: Re: [PATCH v15 18/30] ovl: Do not expose metacopy only dentry from d_real()
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Mon, May 7, 2018 at 8:40 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Metacopy dentry/inode is internal to overlay and is never exposed
> outside of it. Modify d_real() to look for only dentries/inode which
> have data and which are not metacopy.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/super.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index ce90b6e3ce76..c97b5abda954 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -101,10 +101,11 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>         }
>
>         real = ovl_dentry_upper(dentry);
> -       if (real && (!inode || inode == d_inode(real)))
> +       if (real && ovl_has_upperdata(d_inode(dentry)) &&
> +           (!inode || inode == d_inode(real)))
>                 return real;
>
> -       real = ovl_dentry_lower(dentry);
> +       real = ovl_dentry_lowerdata(dentry);
>         if (!real)
>                 goto bug;
>
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
