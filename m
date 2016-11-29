From: Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: [PATCH] ovl: show non default redirect_dir mount option
Date: Tue, 29 Nov 2016 22:09:40 +0100
Message-ID: <CAJfpegve58zQXxs2Bx5tf1_z+zrcpjNq6Sz7-LgaL2yz+9jhkw@mail.gmail.com>
References: <1479808029-16934-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36595 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755127AbcK2VJr (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 29 Nov 2016 16:09:47 -0500
Received: by mail-oi0-f66.google.com with SMTP id u15so20243560oie.3
        for <linux-unionfs@vger.kernel.org>; Tue, 29 Nov 2016 13:09:46 -0800 (PST)
In-Reply-To: <1479808029-16934-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, Nov 22, 2016 at 10:47 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> When redirect_dir option is turned off or on by mount
> option to override the module default param value,
> show the value of redirect_dir in /proc/mounts.

Added.

Thanks,
Miklos

>
> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
> ---
>  fs/overlayfs/super.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 2aa2da4..82c54ca 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -228,6 +228,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         }
>         if (ufs->config.default_permissions)
>                 seq_puts(m, ",default_permissions");
> +       if (ufs->config.redirect_dir != ovl_redirect_dir_default)
> +               seq_printf(m, ",redirect_dir=%s",
> +                          ufs->config.redirect_dir ? "on" : "off");
>         return 0;
>  }
>
> --
> 2.7.4
>
