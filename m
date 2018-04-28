Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180426191013.13219-20-vgoyal@redhat.com>
References: <20180426191013.13219-1-vgoyal@redhat.com> <20180426191013.13219-20-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 28 Apr 2018 01:32:33 -0700
Message-ID: <CAOQ4uxiCtAuH1w4DkAjPfAJfoSoUPq4wdMx-XGPPfsPXVeHbNg@mail.gmail.com>
Subject: Re: [PATCH v14 19/31] ovl: Check redirects for metacopy files
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 26, 2018 at 12:10 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now we rely on path based lookup for data origin of metacopy upper.
> This will work only if upper has not been renamed. We solved this problem
> already for merged directories using redirect. Use same logic for metacopy
> files.
>
> This patch just goes on to check redirects for metacopy files.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Reviewed-by: Amir Goldstein <amir73il@gmail.com>


> ---
>  fs/overlayfs/namei.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 880c7faea41a..41cbde97a212 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -268,7 +268,8 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                         goto out_err;
>                 d->stop = !err;
>                 d->metacopy = !!err;
> -               goto out;
> +               if (!d->metacopy || d->last)
> +                       goto out;
>         } else {
>                 if (last_element) {
>                         if (d->metacopy) {
> @@ -874,7 +875,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 }
>                 if (upperdentry && !d.is_dir) {
>                         unsigned int origin_ctr = 0;
> -                       BUG_ON(d.redirect);
>                         /*
>                          * Lookup copy up origin by decoding origin file handle.
>                          * We may get a disconnected dentry, which is fine,
> --
> 2.13.6
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
