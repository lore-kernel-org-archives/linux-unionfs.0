Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180731093727.26855-7-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com> <20180731093727.26855-7-yi.zhang@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 1 Aug 2018 14:15:19 +0300
Message-ID: <CAOQ4uxjbX8aE+Wn46Zkqv5oWGe7xrbyhfGMD=rQLYhu1hr3X-Q@mail.gmail.com>
Subject: Re: [RFC PATCH v2 6/9] ovl: add index feature if index dir exists
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Index feature is backward read-only compatible becasue it only affect
> the upper layer, and old kernel (which not support this feature) may
> corrupt the relationship between files in upper dir and index dir when
> change the copied-up linked files.
>
> If the index feature is enabled, kernel will create an index dir in the
> work base dir, so this patch check and set upper layer's index feature
> when overlayfs get or create the index dir.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  fs/overlayfs/overlayfs.h |  4 +++-
>  fs/overlayfs/super.c     | 11 +++++++++--
>  2 files changed, 12 insertions(+), 3 deletions(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 7ed8ed49266f..21a41c12168c 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -59,7 +59,8 @@ struct ovl_d_feature {
>  #define OVL_FEATURE_COMPAT_SUPP                (0)
>  #define OVL_FEATURE_COMPAT_UNKNOWN             (~OVL_FEATURE_COMPAT_SUPP)
>
> -#define OVL_FEATURE_RO_COMPAT_SUPP             (0)
> +#define OVL_FEATURE_RO_COMPAT_INDEX            (1 << 0)
> +#define OVL_FEATURE_RO_COMPAT_SUPP             (OVL_FEATURE_RO_COMPAT_INDEX)
>  #define OVL_FEATURE_RO_COMPAT_UNKNOWN          (~OVL_FEATURE_RO_COMPAT_SUPP)
>
>  #define OVL_FEATURE_INCOMPAT_REDIRECT_DIR      (1 << 0)
> @@ -130,6 +131,7 @@ static inline int ovl_set_feature_##name(struct ovl_fs *ofs) \
>                         OVL_FEATURE_INCOMPAT_##flagname); \
>  } \
>
> +OVL_FEATURE_RO_COMPAT_FUNCS(index,             INDEX)
>  OVL_FEATURE_INCOMPAT_FUNCS(redirect_dir,       REDIRECT_DIR)
>
>  /*
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index a5bbbddf741c..197329f7d284 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1443,8 +1443,15 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                 if (err)
>                         goto out_free_oe;
>
> -               /* Force r/o mount with no index dir */
> -               if (!ofs->indexdir) {
> +               if (ofs->indexdir) {
> +                       /* Set index feature if index dir exists */
> +                       if (!ovl_has_feature_index(ofs->upper_layer)) {
> +                               err = ovl_set_feature_index(ofs);

ovl_set_feature_index() is enough. it should test the bit internally.

Thanks,
Amir.
