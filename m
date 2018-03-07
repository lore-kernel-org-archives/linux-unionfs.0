Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180306205408.23383-14-vgoyal@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com> <20180306205408.23383-14-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 7 Mar 2018 14:16:25 +0200
Message-ID: <CAOQ4uxgLiSNpQq0AE2aXdH3zMCPsdCNgxYtp71CauuGgrd20TQ@mail.gmail.com>
Subject: Re: [PATCH v12 13/17] ovl: Check redirects for metacopy files
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Mar 6, 2018 at 10:54 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Right now we rely on path based lookup for data origin of metacopy upper.
> This will work only if upper has not been renamed. We solved this problem
> already for merged directories using redirect. Use same logic for metacopy
> files.
>
> This patch just goes on to check redirects for metacopy files.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 220e754c974b..a4a5c5f5540d 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -265,22 +265,22 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                 goto put_and_out;
>         }
>         if (!d_can_lookup(this)) {
> -               if (d->is_dir)
> -                       goto put_and_out;
> +               d->is_dir = false;

That test was supposed to catch non-dir under dir from an upper layer
but you are loosing the information stored in d->dir.

>                 err = ovl_check_metacopy_xattr(this);
>                 if (err < 0)
>                         goto out_err;
>                 if (!err) {
>                         d->stop = true;
>                         d->metacopy = false;
> +                       goto out;
>                 } else
>                         d->metacopy = true;
> -               goto out;
> -       }
> -       d->is_dir = true;
> -       if (!d->last && ovl_is_opaquedir(this)) {
> -               d->stop = d->opaque = true;
> -               goto out;
> +       } else {
> +               d->is_dir = true;
> +               if (!d->last && ovl_is_opaquedir(this)) {
> +                       d->stop = d->opaque = true;
> +                       goto out;

I think there is a bug here - not related to your change, but semi related
to your recent fix patch (patch 1 in this series).

d->last is set to true when lookup in parent poe->numlower layer,
but parent may be pure upper for example and redirect from child can still
continue lookup to lower layers. If a directory is marked both "redirect" and
"opaque" (which is an inconsistency). In that case, d->last will be true
and opaque xattr will not be checked, but redirect will be checked.

Since AFAIK d->last is an optimization, I think it could be relaxed to
lower.layer->idx == roe->numlower - 1
and then for the d->last case, we can skip both opaque and redirect checks
and skip redirect check for both directory and metadata.


> +               }
>         }
>         err = ovl_check_redirect(this, d, prelen, post);
>         if (err)

Thanks,
Amir.
