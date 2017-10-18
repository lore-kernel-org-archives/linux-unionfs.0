From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 03/11] ovl: During copy up, first copy up metadata and
 then data
Date: Wed, 18 Oct 2017 07:13:37 +0300
Message-ID: <CAOQ4uxheY+6QkSLn+3+E5V=iyvesu-dL739Urzy1vK3OG0y4Ow@mail.gmail.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com> <1508274358-17456-4-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-qt0-f196.google.com ([209.85.216.196]:50224 "EHLO
        mail-qt0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753499AbdJRENi (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 00:13:38 -0400
Received: by mail-qt0-f196.google.com with SMTP id d9so1391839qtd.7
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 21:13:38 -0700 (PDT)
In-Reply-To: <1508274358-17456-4-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> This just helps with later patches where after copying up metadata, we
> skip data copying step, if needed.

This patch looks fine, but I must be missing how it helps with later patches.
If it doesn't help please remove it.

>
> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/copy_up.c | 34 +++++++++++++++++-----------------
>  1 file changed, 17 insertions(+), 17 deletions(-)
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 0a6294ea64d5..4c0acb2a23ea 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -445,6 +445,23 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>  {
>         int err;
>
> +       err = ovl_copy_xattr(c->lowerpath.dentry, temp);
> +       if (err)
> +               return err;
> +
> +       /*
> +        * Store identifier of lower inode in upper inode xattr to
> +        * allow lookup of the copy up origin inode.
> +        *
> +        * Don't set origin when we are breaking the association with a lower
> +        * hard link.
> +        */
> +       if (c->origin) {
> +               err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
> +               if (err)
> +                       return err;
> +       }
> +
>         if (S_ISREG(c->stat.mode)) {
>                 struct path upperpath;
>
> @@ -457,29 +474,12 @@ static int ovl_copy_up_inode(struct ovl_copy_up_ctx *c, struct dentry *temp)
>                         return err;
>         }
>
> -       err = ovl_copy_xattr(c->lowerpath.dentry, temp);
> -       if (err)
> -               return err;
> -
>         inode_lock(temp->d_inode);
>         err = ovl_set_attr(temp, &c->stat);
>         inode_unlock(temp->d_inode);
>         if (err)
>                 return err;
>
> -       /*
> -        * Store identifier of lower inode in upper inode xattr to
> -        * allow lookup of the copy up origin inode.
> -        *
> -        * Don't set origin when we are breaking the association with a lower
> -        * hard link.
> -        */
> -       if (c->origin) {
> -               err = ovl_set_origin(c->dentry, c->lowerpath.dentry, temp);
> -               if (err)
> -                       return err;
> -       }
> -
>         return 0;
>  }
>
> --
> 2.13.5
>
