From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 01/13] ovl: Put upperdentry if ovl_check_origin() fails
Date: Wed, 25 Oct 2017 23:08:05 +0300
Message-ID: <CAOQ4uxiTst9LbNTJyyfY8zpNNXvWka_Nb_pu0BhHD28+UEEVEQ@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com> <1508958575-14086-2-git-send-email-vgoyal@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f195.google.com ([209.85.161.195]:48385 "EHLO
        mail-yw0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751793AbdJYUIG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 25 Oct 2017 16:08:06 -0400
Received: by mail-yw0-f195.google.com with SMTP id q1so1079202ywh.5
        for <linux-unionfs@vger.kernel.org>; Wed, 25 Oct 2017 13:08:06 -0700 (PDT)
In-Reply-To: <1508958575-14086-2-git-send-email-vgoyal@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> If ovl_check_origin() fails, we should put upperdentry. We have a reference
> on it by now. So goto out_put_upper instead of out.
>

This one needs CC stable and Fixes: tags

> Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> ---
>  fs/overlayfs/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index 88ff1da..aec543d 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -633,7 +633,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                         err = ovl_check_origin(upperdentry, roe->lowerstack,
>                                                roe->numlower, &stack, &ctr);
>                         if (err)
> -                               goto out;
> +                               goto out_put_upper;
>                 }
>
>                 if (d.redirect) {
> --
> 2.5.5
>
