Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180731093727.26855-6-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com> <20180731093727.26855-6-yi.zhang@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 1 Aug 2018 14:03:22 +0300
Message-ID: <CAOQ4uxgwUnna5zs1n2S9UkHKv4wH1n0QA-96kSsTJ+iDiah8gQ@mail.gmail.com>
Subject: Re: [RFC PATCH v2 5/9] ovl: add redirect dir feature when set
 redirect xattr to dir
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Redirect dir feature is backward incompatible because old kernel (which
> not support this feature) may corrupt the merge relationship between
> directories when change the directory which have redirect xattr.
>
> This patch check and set the upper layer's redirect dir feature when
> kernel set redirect xattr to directory in the upper layer.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  fs/overlayfs/dir.c       | 11 +++++++++++
>  fs/overlayfs/overlayfs.h |  5 ++++-
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
> index f480b1a2cd2e..238999e5f47b 100644
> --- a/fs/overlayfs/dir.c
> +++ b/fs/overlayfs/dir.c
> @@ -969,6 +969,7 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>         bool is_dir = d_is_dir(old);
>         bool new_is_dir = d_is_dir(new);
>         bool samedir = olddir == newdir;
> +       struct ovl_fs* ofs = old->d_sb->s_fs_info;
>         struct dentry *opaquedir = NULL;
>         const struct cred *old_cred = NULL;
>         LIST_HEAD(list);
> @@ -1061,6 +1062,16 @@ static int ovl_rename(struct inode *olddir, struct dentry *old,
>                 }
>         }
>
> +       if ((is_dir && ovl_type_merge_or_lower(old)) ||
> +           (!overwrite && new_is_dir && ovl_type_merge_or_lower(new))) {
> +               /*
> +                * Set redirect dir feature to the upper root dir if this
> +                * feature doesn't exist.
> +                */
> +               if (!ovl_has_feature_redirect_dir(ofs->upper_layer))
> +                       err = ovl_set_feature_redirect_dir(ofs);
> +       }
> +

Please just place a call to  ovl_set_feature_redirect_dir(ofs)
inside ovl_set_redirect(). There is no need to check all those
conditions.
Also, there is no need to check ovl_has_feature_redirect_dir()
as ovl_set_feature() already checks for existing bit.

Thanks,
Amir.

>         trap = lock_rename(new_upperdir, old_upperdir);
>
>         olddentry = lookup_one_len(old->d_name.name, old_upperdir,
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index d6231acc660a..7ed8ed49266f 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -62,7 +62,8 @@ struct ovl_d_feature {
>  #define OVL_FEATURE_RO_COMPAT_SUPP             (0)
>  #define OVL_FEATURE_RO_COMPAT_UNKNOWN          (~OVL_FEATURE_RO_COMPAT_SUPP)
>
> -#define OVL_FEATURE_INCOMPAT_SUPP              (0)
> +#define OVL_FEATURE_INCOMPAT_REDIRECT_DIR      (1 << 0)
> +#define OVL_FEATURE_INCOMPAT_SUPP              (OVL_FEATURE_INCOMPAT_REDIRECT_DIR)
>  #define OVL_FEATURE_INCOMPAT_UNKNOWN           (~OVL_FEATURE_INCOMPAT_SUPP)
>
>  static inline bool ovl_has_unknown_compat_features(struct ovl_layer *layer)
> @@ -129,6 +130,8 @@ static inline int ovl_set_feature_##name(struct ovl_fs *ofs) \
>                         OVL_FEATURE_INCOMPAT_##flagname); \
>  } \
>
> +OVL_FEATURE_INCOMPAT_FUNCS(redirect_dir,       REDIRECT_DIR)
> +
>  /*
>   * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
>   * where:
> --
> 2.13.6
>
