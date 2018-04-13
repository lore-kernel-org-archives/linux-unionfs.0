MIME-Version: 1.0
In-Reply-To: <1523623156-6035-4-git-send-email-cgxu519@gmx.com>
References: <1523623156-6035-1-git-send-email-cgxu519@gmx.com>
	<1523623156-6035-4-git-send-email-cgxu519@gmx.com>
Date: Fri, 13 Apr 2018 15:50:16 +0200
Message-ID: <CAJfpegvndV9Q1PELjrbzTS+Smk=QmO69NqB83JW2nwyVBJ-XTg@mail.gmail.com>
Subject: Re: [PATCH v4 3/3] ovl: return error when specifying unchangeable
 options in remount
From: Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset="UTF-8"
To: Chengguang Xu <cgxu519@gmx.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Apr 13, 2018 at 2:39 PM, Chengguang Xu <cgxu519@gmx.com> wrote:
> Check remount options and return error if there is any unchangeable
> option.
>
> Signed-off-by: Chengguang Xu <cgxu519@gmx.com>
> ---
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
>  fs/overlayfs/super.c | 69 +++++++++++++++++++++++++++++++++++++++++++++++++---
>  1 file changed, 65 insertions(+), 4 deletions(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 0293635a..36587cbf 100644
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
> @@ -542,14 +547,70 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>         return ovl_parse_redirect_mode(config);
>  }
>
> +static bool ovl_opt_bool_neq(bool new, bool old, const char *name)
> +{
> +       if (new != old) {
> +               pr_err("overlayfs: option \"%s\" cannot be %s on remount.\n",
> +                                       name, new ? "enabled" : "disabled");
> +               return true;
> +       }
> +       return false;
> +}
> +
> +static bool ovl_opt_string_neq(const char *new, const char *old,
> +                                               const char *name)
> +{
> +       if (new && (!old || strcmp(new, old))) {
> +               pr_err("overlayfs: option \"%s\" cannot be changed on remount.\n",
> +                                                                       name);
> +               return true;
> +       }
> +       return false;
> +}
> +
> +#define ovl_config_opt_neq(old, new, name, type) \
> +       ovl_opt_##type##_neq((old)->name, (new)->name, #name)
> +
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
> +       nc = kzalloc(sizeof(struct ovl_config), GFP_KERNEL);
> +       if (!nc)
> +               return -ENOMEM;
> +
> +       nc->index = oc->index;
> +       nc->nfs_export = oc->nfs_export;

What about the other options?

We should copy all of the old config to the new config here.

If an option is not given, it should be assumed to stay the same as
the previous value (i.e. no need to supply options to remount that you
don't want to change).

Thanks,
Miklos
