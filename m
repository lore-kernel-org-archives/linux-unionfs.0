Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180308221804.15708-3-vgoyal@redhat.com>
References: <20180308221804.15708-1-vgoyal@redhat.com> <20180308221804.15708-3-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 9 Mar 2018 00:27:21 +0200
Message-ID: <CAOQ4uxgubChWBGWOk-V-0+2OZcUYYRnyrt8OELhY+gZKO3PnLA@mail.gmail.com>
Subject: Re: [PATCH 2/3] ovl: Do not check for redirect if this is last layer
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 9, 2018 at 12:18 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If we are looking in last layer, then there should not be any need to
> process redirect. redirect information is used only for lookup in next
> lower layer and there is no more lower layer to look into. So no need
> to process redirects.
>
> IOW, ignore redirects on lowest layer.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>

> ---
>  fs/overlayfs/namei.c | 15 +++++++++------
>  1 file changed, 9 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 2e173cfbda0e..32d1d96f80b6 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -248,13 +248,16 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                 goto out;
>         }
>         d->is_dir = true;
> -       if (!d->last && ovl_is_opaquedir(this)) {
> -               d->stop = d->opaque = true;
> -               goto out;

I preferred to go with if (d->last) goto out; I like to avoid nesting
when possible.
but choose whichever you like.

> +       if (!d->last) {
> +               if (ovl_is_opaquedir(this)) {
> +                       d->stop = d->opaque = true;
> +                       goto out;
> +               }
> +
> +               err = ovl_check_redirect(this, d, prelen, post);
> +               if (err)
> +                       goto out_err;
>         }
> -       err = ovl_check_redirect(this, d, prelen, post);
> -       if (err)
> -               goto out_err;
>  out:
>         *ret = this;
>         return 0;
> --
> 2.13.6
>
