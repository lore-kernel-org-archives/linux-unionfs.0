Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1522834036-132136-1-git-send-email-cgxu519@gmx.com>
References: <1522834036-132136-1-git-send-email-cgxu519@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 4 Apr 2018 13:44:37 +0300
Message-ID: <CAOQ4uxgeD6zHm+D1B2H-P4WUpAgK2BgpSw6KXsiyiEaJpSpR9Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] ovl: add option parsing support for remount
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 4, 2018 at 12:27 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Some overlayfs mount options cannot be changed via remount,
> but remount operation does not return proper error even if
> we specify different value to unchangeable options.
>
> This patch add option parsing support for remount so we can
> recogonize unchangeable options in remount.
>
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>
> Changes since v1:
> - Add remount option validation to parse_opt()
>
>  fs/overlayfs/super.c | 133 ++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 127 insertions(+), 6 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 7c24619..4112720 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -425,6 +425,16 @@ static char *ovl_next_opt(char **s)
>
>  static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
>  {
> +
> +       if (!mode) {
> +               config->redirect_mode = kstrdup(ovl_redirect_mode_def(),
> +                                                       GFP_KERNEL);
> +               if (!config->redirect_mode)
> +                       return -ENOMEM;
> +
> +               mode = config->redirect_mode;
> +       }

This makes @mode argument to function redundant.

> +
>         if (strcmp(mode, "on") == 0) {
>                 config->redirect_dir = true;
>                 /*
> @@ -446,13 +456,49 @@ static int ovl_parse_redirect_mode(struct ovl_config *config, const char *mode)
>         return 0;
>  }
>
> -static int ovl_parse_opt(char *opt, struct ovl_config *config)
> +static char *ovl_token_to_string(int token)
>  {
> -       char *p;
> +       switch (token) {
> +       case OPT_UPPERDIR: return "upperdir";
> +       case OPT_LOWERDIR: return "lowerdir";
> +       case OPT_WORKDIR: return "workdir";
> +       case OPT_DEFAULT_PERMISSIONS: return "default_permissions";
> +       case OPT_REDIRECT_DIR: return "redirect_dir";
> +       case OPT_INDEX_ON:
> +       case OPT_INDEX_OFF: return "index";
> +       case OPT_NFS_EXPORT_ON:
> +       case OPT_NFS_EXPORT_OFF: return "nfs_export";
> +       default: return "???";
> +       }
> +}

You don't need this. The option name is available in args[0]
variable when calling the parsing macros and I don't think
you need to bother with stripping the =xxx part.

>
> -       config->redirect_mode = kstrdup(ovl_redirect_mode_def(), GFP_KERNEL);
> -       if (!config->redirect_mode)
> -               return -ENOMEM;
> +static int ovl_valid_remount_string_option(int token, const char *new,
> +                                               const char *old)
> +{
> +       if (!old || strcmp(new, old)) {
> +               pr_err("overlayfs: option %s cannot be changed on remount.\n",
> +                               ovl_token_to_string(token));
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static int ovl_valid_remount_bool_option(int token, const bool new,
> +                                               const bool old)
> +{
> +       if (new != old) {
> +               pr_err("overlayfs: option %s cannot be changed on remount.\n",
> +                               ovl_token_to_string(token));
> +               return -EINVAL;
> +       }
> +       return 0;
> +}
> +
> +static int ovl_parse_opt(char *opt, struct ovl_config *config,
> +                                       struct ovl_config *old_config)
> +{
> +       char *p;
> +       int err;
>
>         while ((p = ovl_next_opt(&opt)) != NULL) {
>                 int token;
> @@ -468,6 +514,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                         config->upperdir = match_strdup(&args[0]);
>                         if (!config->upperdir)
>                                 return -ENOMEM;
> +                       if (old_config) {
> +                               err = ovl_valid_remount_string_option(
> +                                       token,
> +                                       config->upperdir,
> +                                       old_config->upperdir);
> +                               if (err)
> +                                       return err;
> +                       }

Brevity: instead of adding 8 lines to each case, you can squeeze the entire
handling of string option to a single macro, e.g.:

        err = (ovl_parse_string_option(upperdir, &args[0], config, oldconfig);
        if (err)
            return err;

Same for ovl_parse_bool_option.

Later, when you want to introduce an option that could be changed
on remount or only changed from NULL, just add new macro flavors:

ovl_parse_remount_[string|bool]_option
ovl_parse_test_and_remount_[string|bool]_option

Let me know if you are not clear on how.

Thanks,
Amir.
