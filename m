Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 1 Apr 2018 10:11:30 +0300
Message-ID: <CAOQ4uxhRyG-0JYNWsVhkzQ0+ue-xdSVkfM7gX4LdNu9kkoWNTg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ovl: add option parsing support for remount
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Apr 1, 2018 at 7:57 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Some overlayfs mount options cannot be changed via remount,
> but remount operation does not return proper error even if
> we specify different value to unchangeable options.
>
> This patch add option parsing support for remount so we can
> recogonize unchangeable options in remount.
>
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>  fs/overlayfs/super.c | 19 +++++++++++++------
>  1 file changed, 13 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 7c24619..5c8944b 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -446,14 +446,10 @@ static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
>         return 0;
>  }
>
> -static int ovl_parse_opt(char *opt, struct ovl_config *config)
> +static int ovl_parse_opt(char *opt, struct ovl_config *config, bool remount)
>  {
>         char *p;
>
> -       config->redirect_mode = kstrdup(ovl_redirect_mode_def(), GFP_KERNEL);
> -       if (!config->redirect_mode)
> -               return -ENOMEM;
> -
>         while ((p = ovl_next_opt(&opt)) != NULL) {
>                 int token;
>                 substring_t args[MAX_OPT_ARGS];
> @@ -517,6 +513,9 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                 }
>         }
>
> +       if (remount)
> +               return 0;
> +
>         /* Workdir is useless in non-upper mount */
>         if (!config->upperdir && config->workdir) {
>                 pr_info("overlayfs: option \"workdir=%s\" is useless in a non-upper mount, ignore\n",
> @@ -525,6 +524,13 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                 config->workdir = NULL;
>         }
>
> +       if (!config->redirect_mode) {
> +               config->redirect_mode = kstrdup(ovl_redirect_mode_def(),
> +                                                       GFP_KERNEL);
> +               if (!config->redirect_mode)
> +                       return -ENOMEM;
> +       }
> +

You can move this chunk into ovl_parse_redirect_mode() no?

>         return ovl_parse_redirect_mode(config, config->redirect_mode);
>  }
>
> @@ -1250,6 +1256,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         struct ovl_entry *oe;
>         struct ovl_fs *ofs;
>         struct cred *cred;
> +       bool remount = false;

This helper var is not needed.

Thanks,
Amir.

>         int err;
>
>         err = -ENOMEM;
> @@ -1263,7 +1270,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>
>         ofs->config.index = ovl_index_def;
>         ofs->config.nfs_export = ovl_nfs_export_def;
> -       err = ovl_parse_opt((char *) data, &ofs->config);
> +       err = ovl_parse_opt((char *) data, &ofs->config, remount);
>         if (err)
>                 goto out_err;
>
> --
> 1.8.3.1
>
