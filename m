Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-18-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-18-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 00:36:38 -0700
Message-ID: <CAOQ4uxiQD6dEWUtUEhsQW3=YKJUnCN7HccKjAx5uCptm4mB7wg@mail.gmail.com>
Subject: Re: [PATCH v14 17/31] ovl: Do not expose metacopy only dentry from d_real()
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Metacopy dentry/inode is internal to overlay and is never exposed
> outside of it. Modify d_real() to look for only dentries/inode which
> have data and which are not metacopy.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Looks fine, but not adding reviewed-by for patches that
are about to change after rebase over newer version of -rorw.

> ---
>  fs/overlayfs/super.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index b81ec9d22ac5..4efb7cd76cc1 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -100,7 +100,7 @@ static struct dentry *ovl_d_real(struct dentry *dentry,
>         if (!d_is_reg(dentry))
>                 goto bug;
>
> -       real = ovl_dentry_real(dentry);
> +       real = ovl_dentry_real_data(dentry);
>         if (inode == d_inode(real))
>                 return real;
>
> --
> 2.13.6
>
