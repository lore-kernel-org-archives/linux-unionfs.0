Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <1522558675-70756-2-git-send-email-cgxu519@gmx.com>
References: <1522558675-70756-1-git-send-email-cgxu519@gmx.com> <1522558675-70756-2-git-send-email-cgxu519@gmx.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sun, 1 Apr 2018 10:39:04 +0300
Message-ID: <CAOQ4uxhyT5V4+8OBgDk3aVHcXtmvN62ZYiHppoAGMbNNCSmDYw@mail.gmail.com>
Subject: Re: [PATCH 2/2] ovl: return error when specifying unchangeable
 options in remount
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Sun, Apr 1, 2018 at 7:57 AM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Check remount options and return error if there is any unchangeable
> option.
>
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
>  fs/overlayfs/super.c | 110 +++++++++++++++++++++++++++++++++++++++++----------
>  1 file changed, 89 insertions(+), 21 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 5c8944b..ba00295 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -353,27 +353,6 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
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
>  enum {
>         OPT_LOWERDIR,
>         OPT_UPPERDIR,
> @@ -534,6 +513,95 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config, bool remount)
>         return ovl_parse_redirect_mode(config, config->redirect_mode);
>  }
>
> +static bool ovl_string_option_equal(const char *new, const char *old)
> +{
> +       if (new) {
> +               if (old) {
> +                       if (!strcmp(new, old))
> +                               return true;
> +                       else
> +                               return false;
> +               } else {
> +                       return false;
> +               }
> +       } else {
> +               if (old)
> +                       return false;
> +               else
> +                       return true;
> +       }
> +}
> +

Or maybe just:
{  return old && !strcmp(new, old); }

You really only need to check when new is non NULL.

But you don't even need this much if you follow my suggestion below.

> +static int ovl_remount(struct super_block *sb, int *flags, char *data)
> +{
> +       struct ovl_fs *ofs = sb->s_fs_info;
> +       struct ovl_config *old_config = &ofs->config;
> +       struct ovl_config *new_config;
> +       bool remount = true;

No need for helper var.

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
> +       err = ovl_parse_opt((char *)data, new_config, remount);
> +       if (err)
> +               goto out_err;
> +
> +       err = -EINVAL;
> +       if (new_config->lowerdir &&
> +                       !ovl_string_option_equal(new_config->lowerdir,
> +                                       old_config->lowerdir))
> +               goto out_err;
> +
> +       if (new_config->upperdir &&
> +                       !ovl_string_option_equal(new_config->upperdir,
> +                                       old_config->upperdir))
> +               goto out_err;
> +
> +       if (new_config->workdir &&
> +                       !ovl_string_option_equal(new_config->workdir,
> +                                       old_config->workdir))
> +               goto out_err;
> +
> +       if (new_config->redirect_mode &&
> +               !ovl_string_option_equal(new_config->redirect_mode,
> +                                       old_config->redirect_mode))
> +               goto out_err;
> +
> +       if (new_config->index != old_config->index)
> +               goto out_err;
> +
> +       if (new_config->nfs_export != old_config->nfs_export)
> +               goto out_err;
> +
> +       return 0;
> +out_err:

This error really calls for error in dmesg preferably pointing user
to the offending mount option.

For this reason, I think it might be better to implement those checks
inside ovl_parse_opt() while parsing each option.

Instead of passing bool remount, you can pass ovl_config *oldconfig
to signify remount.

For string options, you can replace the following code with a small helper
or macro to also include the remount logic:

                        kfree(config->upperdir);
                        config->upperdir = match_strdup(&args[0]);
                        if (!config->upperdir)
                                return -ENOMEM;
                        if (oldconfig && old->config->upperdir &&
!strcmp(config->upperdir, old->config->upperdir)
                                goto remount_err; // where you can
print an error with args[0]


For bool options you just need to add a test at the end
to compare values with oldconfig if oldconfig is not NULL
and error, because it is OK to pass options index=on,index=off,..
as long as the last is same as oldconfig.


> +       kfree(new_config->lowerdir);
> +       kfree(new_config->upperdir);
> +       kfree(new_config->workdir);
> +       kfree(new_config->redirect_mode);
> +       kfree(new_config);

That's code duplication with ovl_free_fs()
Please use ovl_free_config() helper.

Thanks,
Amir.
