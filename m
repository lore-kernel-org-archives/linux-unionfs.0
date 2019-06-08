Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20190608183534.2963-1-mcoffin13@gmail.com>
In-Reply-To: <20190608183534.2963-1-mcoffin13@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 8 Jun 2019 22:10:42 +0300
Message-ID: <CAOQ4uxiX7Rh+46ydXYakKiZ+jP4=uyak8NjWOJK5WTcvuRcHSA@mail.gmail.com>
Subject: Re: [PATCH] overlay: Display redirect_dir mount option when it is set automatically
Content-Type: text/plain; charset="UTF-8"
To: Matt Coffin <mcoffin13@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Jun 8, 2019 at 9:35 PM Matt Coffin <mcoffin13@gmail.com> wrote:
>
> [Why]

The why and how are very important, but please loose the annotations.

> Currently, if metacopy is enabled via a module param/kernel config, then
> the setting for redirect_dir is overriden, unless passed as a mount
> option specifically. Despite this overriding, the redirect_dir option is
> not printed when displaying the mount options (see /proc/mounts), so it
> is hard for a user to know that it has happened.
>
> [How]
> A bit of code that does the overriding based on the mount options was
> setting redirect_dir, but not updating the redirect_mode string. By
> adding that update, the information is now printed (and the config
> struct has the correct information in all places).

You need to Sign-off your patch.
Please run ./scripts/checkpatch.pl before posting
It will tell you that and so will:
https://github.com/torvalds/linux/blob/master/Documentation/process/submitting-patches.rst

> ---
>  fs/overlayfs/super.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 5ec4fc2f5d7e..46fab4660bfe 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -598,6 +598,9 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         config->metacopy = false;
>                 } else {
>                         /* Automatically enable redirect otherwise. */
> +                       pr_info("overlayfs: enabling redirect_dir due to implicit metacopy=%d\n",
...metacopy=on\n"

We know the value and better display to user in mount option format.

> +                               config->metacopy);
> +                       config->redirect_mode = "on";

I'm afraid that string is allocated:

                        kfree(config->redirect_mode);
                        config->redirect_mode = kstrdup("on", GFP_KERNEL);
                        if (!config->redirect_mode)
                                return -ENOMEM;

Better wrap that up in a helper ovl_set_redirect_mode("on").

Thanks,
Amir.
