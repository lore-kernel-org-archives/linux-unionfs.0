From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: do not set overlay.opaque on non-dir create
Date: Wed, 26 Apr 2017 15:56:15 +0200
Message-ID: <CAJfpegtPddGm_CjLd4OX-AmfnHzrwnL3AVcQ9M5iO3ysa5mdgg@mail.gmail.com>
References: <1493062000-10208-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33746 "EHLO
        mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S3000817AbdDZN4R (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 09:56:17 -0400
Received: by mail-oi0-f68.google.com with SMTP id w12so294043oiw.0
        for <linux-unionfs@vger.kernel.org>; Wed, 26 Apr 2017 06:56:17 -0700 (PDT)
In-Reply-To: <1493062000-10208-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Mon, Apr 24, 2017 at 9:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> The optimization for opaque dir create was wrongly being applied
> also to non-dir create.
>
> Fixes: 97c684cc9110 ("ovl: create directories inside merged parent opaque")
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> Cc: <stable@vger.kernel.org> # v4.10

Thanks, applied.

Miklos

> ---
>  fs/overlayfs/dir.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 6ef35e8..5d64550 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -228,7 +228,7 @@ static int ovl_create_upper(struct dentry *dentry, struct inode *inode,
>         if (err)
>                 goto out_dput;
>
> -       if (ovl_type_merge(dentry->d_parent)) {
> +       if (ovl_type_merge(dentry->d_parent) && d_is_dir(newdentry)) {
>                 /* Setting opaque here is just an optimization, allow to fail */
>                 ovl_set_opaque(dentry, newdentry);
>         }
> --
> 2.7.4
>
