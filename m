From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix another overlay: warning prefix
Date: Tue, 2 Jan 2018 14:47:09 +0200
Message-ID: <CAOQ4uxh4KJEQLtLLXc2yQ9Y4Lp_8OHdfwiaq46T0V5vGY9FtNw@mail.gmail.com>
References: <1513599956-29976-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f172.google.com ([209.85.213.172]:33198 "EHLO
        mail-yb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751392AbeABMrK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 2 Jan 2018 07:47:10 -0500
Received: by mail-yb0-f172.google.com with SMTP id f16so4122178ybn.0
        for <linux-unionfs@vger.kernel.org>; Tue, 02 Jan 2018 04:47:10 -0800 (PST)
In-Reply-To: <1513599956-29976-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Mon, Dec 18, 2017 at 2:25 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>
> Miklos,
>
> You just sneaked another one in...
>
> Amir.
>
>  fs/overlayfs/namei.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> index beb945e1963c..9cf15463754c 100644
> --- a/fs/overlayfs/namei.c
> +++ b/fs/overlayfs/namei.c
> @@ -693,7 +693,8 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
>                  */
>                 err = -EPERM;
>                 if (d.redirect && !ofs->config.redirect_follow) {
> -                       pr_warn_ratelimited("overlay: refusing to follow redirect for (%pd2)\n", dentry);
> +                       pr_warn_ratelimited("overlayfs: refusing to follow redirect for (%pd2)\n",
> +                                           dentry);
>                         goto out_put;
>                 }
>
> --


Miklos,

In case you are back from the new year's vacation,
ping on this trivial "typo regression" from v4.15-rc4.

Amir.
