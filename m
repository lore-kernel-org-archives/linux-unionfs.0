Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180308221804.15708-4-vgoyal@redhat.com>
References: <20180308221804.15708-1-vgoyal@redhat.com> <20180308221804.15708-4-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 9 Mar 2018 00:34:57 +0200
Message-ID: <CAOQ4uxjXWE57eZoGzytqjHVon=x4Q5Xu1oXb_z5CNsAuowVN_g@mail.gmail.com>
Subject: Re: [PATCH 3/3] ovl: set d->is_dir and d->opaque for last path element
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 9, 2018 at 12:18 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> Certain properties in ovl_lookup_data should be set only for the last
> element of the path. IOW, of we are calling ovl_lookup_single() for an
> absolute redirect, then d->is_dir and d->opaque do not make much sense
> for intermediate path elements. Instead set them only if dentry being
> lookup is last path element.

Yeh, that's what I said, but I realized later that this is not accurate.
it's true for d->is_dir, but not true for d->opaque.
opaqueness of path elements *can* determine that the redirect result is
opaque, for example when redirecting to /a/b/c and /a is opaque, then
the resolved redirection is opaque *unless* either /a/b or /a/b/c has
an absolute redirect to escape the opaqueness of /a.

Hence my fix patch.

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 32d1d96f80b6..dfefe6277659 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -220,6 +220,7 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>  {
>         struct dentry *this;
>         int err;
> +       bool last_element = !post[0];
>
>         this = lookup_one_len_unlocked(name, base, namelen);
>         if (IS_ERR(this)) {
> @@ -247,9 +248,10 @@ static int ovl_lookup_single(struct dentry *base, struct ovl_lookup_data *d,
>                         goto put_and_out;
>                 goto out;
>         }
> -       d->is_dir = true;
> +       if (last_element)
> +               d->is_dir = true;
>         if (!d->last) {
> -               if (ovl_is_opaquedir(this)) {
> +               if (last_element && ovl_is_opaquedir(this)) {
>                         d->stop = d->opaque = true;
>                         goto out;
>                 }
> --
> 2.13.6
>
