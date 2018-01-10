From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix overlay: warning prefix
Date: Wed, 10 Jan 2018 13:45:46 +0200
Message-ID: <CAOQ4uxgR-Srh5_9sK1o+NZW=0beWNbiF8BM4nF434sx0dL0Pkw@mail.gmail.com>
References: <1515575854-67252-1-git-send-email-cgxu519@icloud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f195.google.com ([209.85.213.195]:38710 "EHLO
        mail-yb0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933998AbeAJLpr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 10 Jan 2018 06:45:47 -0500
Received: by mail-yb0-f195.google.com with SMTP id b132so4096150yba.5
        for <linux-unionfs@vger.kernel.org>; Wed, 10 Jan 2018 03:45:47 -0800 (PST)
In-Reply-To: <1515575854-67252-1-git-send-email-cgxu519@icloud.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu519@icloud.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Jan 10, 2018 at 11:17 AM, Chengguang Xu <cgxu519@icloud.com> wrote:
> Conform one stray warning message to the standard overlayfs: prefix.
>
> Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> ---
>  fs/overlayfs/namei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index beb945e..d0a801b 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -693,7 +693,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                  */
>                 err = -EPERM;
>                 if (d.redirect && !ofs->config.redirect_follow) {
> -                       pr_warn_ratelimited("overlay: refusing to follow redirect for (%pd2)\n", dentry);
> +                       pr_warn_ratelimited("overlayfs: refusing to follow redirect for (%pd2)\n", dentry);
>                         goto out_put;
>                 }
>
> --


I already posted this fix, but as long as the fix gets merged...

Thanks,
Amir.
