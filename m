Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1523547406-67046-2-git-send-email-cgxu519@gmx.com>
References: <1523547406-67046-1-git-send-email-cgxu519@gmx.com> <1523547406-67046-2-git-send-email-cgxu519@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 13 Apr 2018 10:10:32 +0300
Message-ID: <CAOQ4uxgtyQUDdw6+En=_4_HjOnN3Tn70otNDqg_rKmHXUSw1Ow@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] ovl: return error when specifying unchangeable
 options in remount
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Apr 12, 2018 at 6:36 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Check remount options and return error if there is any unchangeable
> option.
>
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
> Changes since v2:
> - Introduce two macro helpers to simplify remount option validation.
>
> Changes since v1:
> - Refactor ovl_free_fs(), move config freeing operations to ovl_free_config()
>
>  fs/overlayfs/super.c | 103 ++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 78 insertions(+), 25 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index a2a7b7a..dd9f828 100644
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
> @@ -379,27 +384,6 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>         return 0;
>  }
>
> -static int ovl_remount(struct super_block *sb, int *flags, char *data)
> -{
> -       struct ovl_fs *ofs = sb->s_fs_info;
> -
> -       if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
> -               return -EROFS;
> -
> -       return 0;
> -}
> -
> -static const struct super_operations ovl_super_operations = {
> -       .alloc_inode    = ovl_alloc_inode,
> -       .destroy_inode  = ovl_destroy_inode,
> -       .drop_inode     = generic_delete_inode,
> -       .put_super      = ovl_put_super,
> -       .sync_fs        = ovl_sync_fs,
> -       .statfs         = ovl_statfs,
> -       .show_options   = ovl_show_options,
> -       .remount_fs     = ovl_remount,
> -};
> -

It would have been better to add a patch that only moves code around
without changing it. Makes reviewing the actual changes easier.

>  enum {
>         OPT_LOWERDIR,
>         OPT_UPPERDIR,
> @@ -563,6 +547,75 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>         return ovl_parse_redirect_mode(config, config->redirect_mode);
>  }
>
> +#define ovl_option_bool_neq(new, old, x, y, z) \
> +do { \
> +       if (new->x != old->x) { \
> +               pr_err("overlayfs: option %s cannot be changed on remount.\n", y); \
> +               goto z; \
> +       } \
> +} while (0)
> +
> +#define ovl_option_string_neq(new, old, x, y, z) \
> +do { \
> +       if (new->x && (!old->x || strcmp(new->x, old->x))) { \
> +               pr_err("overlayfs: option %s cannot be changed on remount.\n", y); \
> +               goto z; \
> +       } \
> +} while (0)
> +
> +static int ovl_remount(struct super_block *sb, int *flags, char *data)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +       struct ovl_config *old_config = &ofs->config;
> +       struct ovl_config *new_config;
> +       int err;
> +
> +       if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
> +               return -EROFS;
> +
> +       new_config = kzalloc(sizeof(struct ovl_config), GFP_KERNEL);
> +       if (!new_config)
> +               return -ENOMEM;
> +
> +       new_config->index = old_config->index;
> +       new_config->nfs_export = old_config->nfs_export;
> +
> +       err = ovl_parse_opt((char *)data, new_config);
> +       if (err)
> +               goto out_err;
> +
> +       err = -EINVAL;
> +       ovl_option_bool_neq(new_config, old_config, index,
> +                                               "index", out_err);
> +       ovl_option_bool_neq(new_config, old_config, nfs_export,
> +                                               "nfs_export", out_err);
> +       ovl_option_string_neq(new_config, old_config, lowerdir,
> +                                               "lowerdir", out_err);
> +       ovl_option_string_neq(new_config, old_config, upperdir,
> +                                               "upperdir", out_err);
> +       ovl_option_string_neq(new_config, old_config, workdir,
> +                                               "workdir", out_err);
> +       ovl_option_string_neq(new_config, old_config, redirect_mode,
> +                                               "redirect_mode", out_err);
> +       return 0;
> +

Ok. Those macros are ill for several reasons.
Let's just blame me for proposing the macros inside ovl_parse_opt().
I agree that doing the validations inside ovl_remount() is cleaner.

If at all macros are in order in this context, they should look
something like this:

static bool ovl_opt_bool_neq(bool new, bool old, const char *name)
{
       if (new != old) {
               pr_err("overlayfs: option \"%s\" cannot be %s on
remount.\n", name,
                         new ? "enabled" : "disabled");
               return true;
       }
       return false;
}

#define ovl_config_opt_neq(old, new, name, type) \
       ovl_opt_##type##_neq((old)->name, (new)->name, #name)

   if (ovl_config_opt_neq(new_config, old_config, index, bool))
        goto out_err;

Thanks,
Amir.
