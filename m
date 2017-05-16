From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: fix creds leak in copy up error path
Date: Tue, 16 May 2017 11:25:17 +0200
Message-ID: <CAJfpegvn8JxYrW6ky+Uov__7C++GKnKBpEbLO2V-EgOkR16dGQ@mail.gmail.com>
References: <1494913546-2723-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36374 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752158AbdEPJZS (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 16 May 2017 05:25:18 -0400
Received: by mail-oi0-f67.google.com with SMTP id w138so2434277oiw.3
        for <linux-unionfs@vger.kernel.org>; Tue, 16 May 2017 02:25:18 -0700 (PDT)
In-Reply-To: <1494913546-2723-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, "# v4 . 11" <stable@vger.kernel.org>

On Tue, May 16, 2017 at 7:45 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Fixes: 42f269b92540 ("ovl: rearrange code in ovl_copy_up_locked()")
> Cc: <stable@vger.kernel.org> # v4.11
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>

Thanks, applied.

Miklos


> ---
>  fs/overlayfs/copy_up.c | 11 ++++++-----
>  1 file changed, 6 insertions(+), 5 deletions(-)
>
> Miklos,
>
> Found that fall out while trying to 'simplify' this function. (see WIP at
> https://github.com/amir73il/linux/commits/ovl-index-dir).
>
> Amir.
>
> diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> index 9008ab9..061a844 100644
> --- a/fs/overlayfs/copy_up.c
> +++ b/fs/overlayfs/copy_up.c
> @@ -343,12 +343,13 @@ static int ovl_copy_up_locked(struct dentry *workdir, struct dentry *upperdir,
>                 temp = ovl_do_tmpfile(upperdir, stat->mode);
>         else
>                 temp = ovl_lookup_temp(workdir, dentry);
> -       err = PTR_ERR(temp);
> -       if (IS_ERR(temp))
> -               goto out1;
> -
>         err = 0;
> -       if (!tmpfile)
> +       if (IS_ERR(temp)) {
> +               err = PTR_ERR(temp);
> +               temp = NULL;
> +       }
> +
> +       if (!err && !tmpfile)
>                 err = ovl_create_real(wdir, temp, &cattr, NULL, true);
>
>         if (new_creds) {
> --
> 2.7.4
>
