Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1523761833-7304-4-git-send-email-cgxu519@gmx.com>
References: <1523761833-7304-1-git-send-email-cgxu519@gmx.com> <1523761833-7304-4-git-send-email-cgxu519@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 15 Apr 2018 13:06:30 +0300
Message-ID: <CAOQ4uxiFhU3YfEhHja3Wh6bq7nMZTgUX3UH3bPjBLGPN4W+0Pg@mail.gmail.com>
Subject: Re: [PATCH v6 3/3] ovl: print warning when specifying unchangeable
 options in remount
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Apr 15, 2018 at 6:10 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Check remount options and print warning if there is any unchangeable
> option.
>
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
> Changes since v5:
> - Add validation of option 'xino'.
> - Replace pr_err() using pr_warn().
> - Do not check return code of ovl_config_opt_neq().
>
> Changes since v4:
> - Only print warning when detecting unchangeable options in remount.
> - Add validation of option 'default_permissions'.
> - Fix potential memleak in ovl_remount().
>
> Changes since v3:
> - Fix error prone macro helper.
> - Make another new patch to only include code around.
>
> Changes since v2:
> - Introduce two macro helpers to simplify remount option validation.
>
> Changes since v1:
> - Refactor ovl_free_fs(), move config freeing operations to ovl_free_config().
>
>  fs/overlayfs/super.c | 70 ++++++++++++++++++++++++++++++++++++++++++++++++----
>  1 file changed, 65 insertions(+), 5 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 0293635a..bb394f3 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -230,6 +230,14 @@ static void ovl_destroy_inode(struct inode *inode)
>         call_rcu(&inode->i_rcu, ovl_i_callback);
>  }
>
> +static void ovl_free_config(struct ovl_config *config)
> +{
> +       kfree(config->lowerdir);
> +       kfree(config->upperdir);
> +       kfree(config->workdir);
> +       kfree(config->redirect_mode);
> +}
> +
>  static void ovl_free_fs(struct ovl_fs *ofs)
>  {
>         unsigned i;
> @@ -249,10 +257,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>         kfree(ofs->lower_layers);
>         kfree(ofs->lower_fs);
>
> -       kfree(ofs->config.lowerdir);
> -       kfree(ofs->config.upperdir);
> -       kfree(ofs->config.workdir);
> -       kfree(ofs->config.redirect_mode);
> +       ovl_free_config(&ofs->config);
>         if (ofs->creator_cred)
>                 put_cred(ofs->creator_cred);
>         kfree(ofs);
> @@ -542,14 +547,69 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>         return ovl_parse_redirect_mode(config);
>  }
>
> +static void ovl_opt_int_neq(const int new, const int old, const char *name)
> +{
> +       if (new != old)
> +               pr_warn("overlayfs: option \"%s\" cannot be changed on remount, ignore.\n",
> +                                       name);
> +}
> +
> +static void ovl_opt_bool_neq(const bool new, const bool old, const char *name)
> +{
> +       if (new != old)
> +               pr_warn("overlayfs: option \"%s\" cannot be %s on remount, ignore.\n",
> +                                       name, new ? "enabled" : "disabled");
> +}
> +
> +static void ovl_opt_str_neq(const char *new, const char *old, const char *name)
> +{
> +       if (new && (!old || strcmp(new, old)))
> +               pr_warn("overlayfs: option \"%s\" cannot be changed on remount, ignore.\n",
> +                                       name);
> +}
> +
> +#define ovl_config_opt_neq(old, new, name, type) \
> +       ovl_opt_##type##_neq((old)->name, (new)->name, #name)
> +
> +/*
> + * In current stage we only print warning message but not return error code
> + * when detecting the behavior of setting new value to unchangeable options.
> + */
>  static int ovl_remount(struct super_block *sb, int *flags, char *data)
>  {
>         struct ovl_fs *ofs = sb->s_fs_info;
> +       struct ovl_config *oc = &ofs->config;
> +       struct ovl_config *nc;
> +       int err;
>
>         if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
>                 return -EROFS;
>
> -       return 0;
> +       nc = kzalloc(sizeof(struct ovl_config), GFP_KERNEL);
> +       if (!nc)
> +               return -ENOMEM;
> +
> +       nc->index = oc->index;
> +       nc->nfs_export = oc->nfs_export;
> +       nc->default_permissions = oc->default_permissions;

Missed a spot: initialize nc->xino.

> +
> +       err = ovl_parse_opt((char *)data, nc);
> +       if (err)
> +               goto out_err;
> +
> +       ovl_config_opt_neq(nc, oc, index, bool);
> +       ovl_config_opt_neq(nc, oc, nfs_export, bool);
> +       ovl_config_opt_neq(nc, oc, default_permissions, bool);
> +       ovl_config_opt_neq(nc, oc, xino, int);
> +       ovl_config_opt_neq(nc, oc, lowerdir, str);
> +       ovl_config_opt_neq(nc, oc, upperdir, str);
> +       ovl_config_opt_neq(nc, oc, workdir, str);
> +       ovl_config_opt_neq(nc, oc, redirect_mode, str);
> +
> +out_err:
> +       ovl_free_config(nc);
> +       kfree(nc);
> +       return err;
>  }
>
>  static const struct super_operations ovl_super_operations = {
> --
> 1.8.3.1
>
