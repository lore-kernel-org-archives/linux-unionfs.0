From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] ovl: fix overlay: warning prefix
Date: Mon, 11 Dec 2017 19:52:55 +0200
Message-ID: <CAOQ4uxi9N9=Qeb63Dp9xS8Vu5rVtVdREc8awdZDi_k2A-cFDOg@mail.gmail.com>
References: <1511375254-15206-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f194.google.com ([209.85.213.194]:37876 "EHLO
        mail-yb0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751999AbdLKRw5 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 11 Dec 2017 12:52:57 -0500
Received: by mail-yb0-f194.google.com with SMTP id 5so6335543ybp.4
        for <linux-unionfs@vger.kernel.org>; Mon, 11 Dec 2017 09:52:56 -0800 (PST)
In-Reply-To: <1511375254-15206-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>

On Wed, Nov 22, 2017 at 8:27 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> Conform two stray warning messages to the standard overlayfs: prefix.
>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/dir.c     | 3 ++-
>  fs/overlayfs/readdir.c | 2 +-
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index 5ec5ee8e0589..0ce535e7519e 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -887,7 +887,8 @@ static int ovl_set_redirect(struct dentry *dentry, bool samedir)
>                 spin_unlock(&dentry->d_lock);
>         } else {
>                 kfree(redirect);
> -               pr_warn_ratelimited("overlay: failed to set redirect (%i)\n", err);
> +               pr_warn_ratelimited("overlayfs: failed to set redirect (%i)\n",
> +                                   err);
>                 /* Fall back to userspace copy-up */
>                 err = -EXDEV;
>         }
> diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
> index 362561457cdb..7fc142d183e8 100644
> --- a/fs/overlayfs/readdir.c
> +++ b/fs/overlayfs/readdir.c
> @@ -499,7 +499,7 @@ static int ovl_cache_update_ino(struct path *path, struct ovl_cache_entry *p)
>         return err;
>
>  fail:
> -       pr_warn_ratelimited("overlay: failed to look up (%s) for ino (%i)\n",
> +       pr_warn_ratelimited("overlayfs: failed to look up (%s) for ino (%i)\n",
>                             p->name, err);
>         goto out;
>  }
> --

Ping
