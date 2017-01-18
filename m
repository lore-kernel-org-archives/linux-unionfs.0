From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2] ovl: fix possible use after free on redirect dir lookup
Date: Wed, 18 Jan 2017 13:40:57 +0200
Message-ID: <CAOQ4uxjihZFvNiJBf2DVKgJ6mVJwsNK0LPGtC-mtfd8g3AdnLA@mail.gmail.com>
References: <1484656498-5265-1-git-send-email-amir73il@gmail.com>
 <1484727330-7260-1-git-send-email-amir73il@gmail.com> <20170118103834.GG27207@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36844 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754130AbdARLlD (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Jan 2017 06:41:03 -0500
Received: by mail-oi0-f66.google.com with SMTP id u143so706698oif.3
        for <linux-unionfs@vger.kernel.org>; Wed, 18 Jan 2017 03:40:58 -0800 (PST)
In-Reply-To: <20170118103834.GG27207@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

On Wed, Jan 18, 2017 at 12:38 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Amir,
>
> Thanks for spotting this bug and for the patch.
>
> I simplified it a bit (appended)
>

Simpler indeed.

> I don't think it's justified to copy the string just for the sake of an
> assertation, so got rid of that.  Also tweaked the breakout condition to make
> things clearer.
>

I agree that copying the string is an overkill, but if this bug has
taught us anything
is that the assertion was not sufficient, so I don't think we should
leave no assert
at all. please see my suggested assert below (with which I tested your patch).

> Only compile tested.  Please let me know if this works or not.
>

It works.

> Thanks,
> Miklos
>
> ---
> From: Amir Goldstein <amir73il@gmail.com>
> Subject: ovl: fix possible use after free on redirect dir lookup
>
> ovl_lookup_layer() iterates on path elements of d->name.name
> but also frees and allocates a new pointer for d->name.name.
>
> For the case of lookup in upper layer, the initial d->name.name
> pointer is stable (dentry->d_name), but for lower layers, the
> initial d->name.name can be d->redirect, which can be freed during
> iteration.
>
> [SzM]
> Keep the count of remaining characters in the redirect path and calculate
> the current position from that.  This works becuase only the prefix is
> modified, the ending always stays the same.
>
> Fixes: 02b69b284cd7 ("ovl: lookup redirects")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/namei.c |   25 ++++++++++++++-----------
>  1 file changed, 14 insertions(+), 11 deletions(-)
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -154,29 +154,32 @@ static int ovl_lookup_single(struct dent
>  static int ovl_lookup_layer(struct dentry *base, struct ovl_lookup_data *d,
>                             struct dentry **ret)
>  {
> -       const char *s = d->name.name;
> +       /* Counting down from the end, since the prefix can change */
> +       size_t rem = d->name.len;
>         struct dentry *dentry = NULL;
>         int err;
>
> -       if (*s != '/')
> +       if (d->name.name[0] != '/')
>                 return ovl_lookup_single(base, d, d->name.name, d->name.len,
>                                          0, "", ret);
>
> -       while (*s++ == '/' && !IS_ERR_OR_NULL(base) && d_can_lookup(base)) {
> +       rem--;
> +       while (!IS_ERR_OR_NULL(base) && d_can_lookup(base)) {
> +               const char *s = d->name.name + d->name.len - rem;
>                 const char *next = strchrnul(s, '/');
> -               size_t slen = strlen(s);
> +               size_t thislen = next - s;
> +               bool end = !next[0];
>
> -               if (WARN_ON(slen > d->name.len) ||
> -                   WARN_ON(strcmp(d->name.name + d->name.len - slen, s)))
> -                       return -EIO;
> -
> -               err = ovl_lookup_single(base, d, s, next - s,
> -                                       d->name.len - slen, next, &base);


+               /* Verify we did not go off the rails */
+               if (WARN_ON(s[-1] != '/'))
+                       return -EIO;
+

> +               err = ovl_lookup_single(base, d, s, thislen,
> +                                       d->name.len - rem, next, &base);
>                 dput(dentry);
>                 if (err)
>                         return err;
>                 dentry = base;
> -               s = next;
> +               if (end)
> +                       break;
> +
> +               rem -= thislen + 1;
>         }
>         *ret = dentry;
>         return 0;
