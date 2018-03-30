Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180329193854.13814-19-vgoyal@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-19-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 30 Mar 2018 13:02:32 +0300
Message-ID: <CAOQ4uxhVdgZPpKahSruuGNqYeU8TPn=h4=PGD2vRN7vxcF-FSQ@mail.gmail.com>
Subject: Re: [PATCH v13 18/28] ovl: Check redirects for metacopy files
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now we rely on path based lookup for data origin of metacopy upper.
> This will work only if upper has not been renamed. We solved this problem
> already for merged directories using redirect. Use same logic for metacopy
> files.
>
> This patch just goes on to check redirects for metacopy files.
>

The patch changes the logic very subtly, but it is really hard to
follow because of convoluted diff. Please make changes that don't
change logic in a separate patch.

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 1dba89e9543f..a7a9588f64b7 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -260,18 +260,19 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                         goto out_err;
>                 d->stop = !err;
>                 d->metacopy = !!err;
> -               goto out;
> -       }
> -       if (last_element)
> -               d->is_dir = true;
> -       if (d->last)
> -               goto out;
> -
> -       if (ovl_is_opaquedir(this)) {
> -               d->stop = true;
> +               if (!d->metacopy)
> +                       goto out;
> +       } else {
>                 if (last_element)
> -                       d->opaque = true;
> -               goto out;
> +                       d->is_dir = true;
> +               if (d->last)
> +                       goto out;

If I am not mistaken, d->last test is relevant to both did and non-dir,
because it also prevents the unneeded check redirect.

Thanks,
Amir.
