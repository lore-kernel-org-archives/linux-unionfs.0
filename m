From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: redirect_dir=nofollow should not follow redirect for
 opaque lower
Date: Sun, 4 Feb 2018 22:35:22 +0200
Message-ID: <CAOQ4uxhA-XPEYm7SYSnCn1Yaw7vSHcRcNv1LdoMPgVRnVipQPA@mail.gmail.com>
References: <20180202152324.GA2721@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f194.google.com ([209.85.161.194]:36457 "EHLO
        mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751797AbeBDUfZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 4 Feb 2018 15:35:25 -0500
Received: by mail-yw0-f194.google.com with SMTP id q6so17053934ywg.3
        for <linux-unionfs@vger.kernel.org>; Sun, 04 Feb 2018 12:35:25 -0800 (PST)
In-Reply-To: <20180202152324.GA2721@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Feb 2, 2018 at 5:23 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> redirect_dir=nofollow should not follow a redirect. But in a specific
> configuration it can still follow it.  For example try this.
>
> $ mkdir -p lower0 lower1/foo upper work merged
> $ touch lower1/foo/lower-file.txt
> $ setfattr -n "trusted.overlay.opaque" -v "y" lower1/foo
> $ mount -t overlay -o lowerdir=lower1:lower0,workdir=work,upperdir=upper,redirect_dir=on none merged
> $ cd merged
> $ mv foo foo-renamed
> $ umount merged
>
> # mount again. This time with redirect_dir=nofollow
> $ mount -t overlay -o lowerdir=lower1:lower0,workdir=work,upperdir=upper,redirect_dir=nofollow none merged
> $ ls merged/foo-renamed/
> # This lists lower-file.txt, while it should not have.
>
> Basically, we are doing redirect check after we check for d.stop. And
> if this is not last lower, and we find an opaque lower, d.stop will be
> set.
>
> ovl_lookup_single()
>         if (!d->last && ovl_is_opaquedir(this)) {
>                 d->stop = d->opaque = true;
>                 goto out;
>         }
>
> To fix this, first check redirect is allowed. And after that check if
> d.stop has been set or not.
>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>

Looks good.
Probably should have Fixes and Cc: stable

> ---
>  fs/overlayfs/namei.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index beb945e1963c..ef3e7ea76296 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -678,9 +678,6 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                 stack[ctr].layer = lower.layer;
>                 ctr++;
>
> -               if (d.stop)
> -                       break;
> -
>                 /*
>                  * Following redirects can have security consequences: it's like
>                  * a symlink into the lower layer without the permission checks.
> @@ -697,6 +694,9 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         goto out_put;
>                 }
>
> +               if (d.stop)
> +                       break;
> +
>                 if (d.redirect && d.redirect[0] == '/' && poe != roe) {
>                         poe = roe;
>
> --
> 2.13.6
>
