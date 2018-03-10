Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180309204444.13237-5-vgoyal@redhat.com>
References: <20180309204444.13237-1-vgoyal@redhat.com> <20180309204444.13237-5-vgoyal@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 10 Mar 2018 22:07:07 +0200
Message-ID: <CAOQ4uxidLEToWz-p-RUDFyhdNEy2-Pn3PvTD=yCV9t+kxw-LMw@mail.gmail.com>
Subject: Re: [PATCH v2 4/4] ovl: fix lookup with middle layer opaque dir and
 absolute path redirects
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 9, 2018 at 10:44 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> From: Amir Goldstein <amir73il@gmail.com>
>
> As of now if we encounter an opaque dir while looking for a dentry, we set
> d->last=true. This means that there is no need to look further in any of
> the lower layers. This works fine as long as there are no redirets or
> relative redircts. But what if there is an absolute redirect on the
> children dentry of opaque directory. We still need to continue to look into
> next lower layer. This patch fixes it.
>
> Here is first example to demonstrate the issue. Say you have following setup.
>
> upper:  /redirect (redirect=/a/b/c)
> lower1: /a/[b]/c       ([b] is opaque) (c has absolute redirect=/a/b/d/foo)

According to the text below you meant redirect=/a/b/d

> lower0: /a/b/d/foo
>
> Now "redirect" dir should merge with lower1:/a/b/c/ and lower0:/a/b/d. Note,
> despite the fact lower1:/a/[b] is opaque, we need to continue to look into
> lower0 because children c has an absolute redirect.
>
> Following is second example.

Let's refer to the below as a reproducer then

>
> Watch me make foo disappear:
>
>  $ mkdir lower middle upper work work2 merged
>  $ mkdir lower/origin
>  $ touch lower/origin/foo
>  $ mount -t overlay none merged/ \
>          -olowerdir=lower,upperdir=middle,workdir=work2
>  $ mkdir merged/pure
>  $ mv merged/origin merged/pure/redirect
>  $ umount merged
>  $ mount -t overlay none merged/ \
>          -olowerdir=middle:lower,upperdir=upper,workdir=work
>  $ mv merged/pure/redirect merged/redirect
>
> Now you see foo inside a twice redirected merged dir:
>
>  $ ls merged/redirect
>  foo
>  $ umount merged
>  $ mount -t overlay none merged/ \
>          -olowerdir=middle:lower,upperdir=upper,workdir=work
>
> After mount cycle you don't see foo inside the same dir:
>
>  $ ls merged/redirect
>
> During middle layer lookup, the opaqueness of middle/pure is left in
> the lookup state and then middle/pure/redirect is wrongly treated as
> opaque.
>
> Fixes: 02b69b284cd7 ("ovl: lookup redirects")
> Cc: <stable@vger.kernel.org> #v4.10
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index de08a67405d0..096d5853af7d 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -56,6 +56,14 @@ static int ovl_check_redirect(struct dentry *dentry, struct ovl_lookup_data *d,
>                         if (s == next)
>                                 goto invalid;
>                 }
> +               /*
> +                * One of the ancestor path elements in an absolute path
> +                * lookup in ovl_lookup_layer() could have been opaque, but it
> +                * possible for a decendant path element to reset opaqueness in
> +                * case this path element has an absolute redirect to a lower
> +                * layer.
> +                */

Now the comment is out of sync with new semantics, it is not opaquness
that is being reset. it's stop and continue lookup in lower layers.

> +               d->stop = false;
>         } else {
>                 if (strchr(buf, '/') != NULL)
>                         goto invalid;
> --
> 2.13.6
>
