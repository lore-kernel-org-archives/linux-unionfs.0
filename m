Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180731093727.26855-8-yi.zhang@huawei.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com> <20180731093727.26855-8-yi.zhang@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 1 Aug 2018 14:20:57 +0300
Message-ID: <CAOQ4uxg9RH-k6MtqPHaZamDtUQkbU2GT-sR_mHYeoNvV-yn4yg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 7/9] ovl: add nfs_export feature when nfs_export is enabled
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> nfs_export feature is base on index feature and also backward read-only
> compatible. Check the upper layer's nfs_export feature when index dir
> exists and nfs_export was enabled through mount option, set this feature
> if it was not yet set.
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  fs/overlayfs/overlayfs.h |  5 ++++-
>  fs/overlayfs/super.c     | 11 +++++++++++
>  2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 21a41c12168c..0f95e60cae69 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -60,7 +60,9 @@ struct ovl_d_feature {
>  #define OVL_FEATURE_COMPAT_UNKNOWN             (~OVL_FEATURE_COMPAT_SUPP)
>
>  #define OVL_FEATURE_RO_COMPAT_INDEX            (1 << 0)
> -#define OVL_FEATURE_RO_COMPAT_SUPP             (OVL_FEATURE_RO_COMPAT_INDEX)
> +#define OVL_FEATURE_RO_COMPAT_NFS_EXPORT       (1 << 1)
> +#define OVL_FEATURE_RO_COMPAT_SUPP             (OVL_FEATURE_RO_COMPAT_INDEX | \
> +                                                OVL_FEATURE_RO_COMPAT_NFS_EXPORT)
>  #define OVL_FEATURE_RO_COMPAT_UNKNOWN          (~OVL_FEATURE_RO_COMPAT_SUPP)
>
>  #define OVL_FEATURE_INCOMPAT_REDIRECT_DIR      (1 << 0)
> @@ -132,6 +134,7 @@ static inline int ovl_set_feature_##name(struct ovl_fs *ofs) \
>  } \
>
>  OVL_FEATURE_RO_COMPAT_FUNCS(index,             INDEX)
> +OVL_FEATURE_RO_COMPAT_FUNCS(nfs_export,        NFS_EXPORT)
>  OVL_FEATURE_INCOMPAT_FUNCS(redirect_dir,       REDIRECT_DIR)
>
>  /*
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 197329f7d284..860a533ae5a9 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -1450,6 +1450,17 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>                                 if (err)
>                                         goto out_free_oe;
>                         }
> +
> +                       /*
> +                        * Set nfs_export feature if index dir exists and
> +                        * nfs_export mount option enabled.
> +                        */
> +                       if (ofs->config.nfs_export &&
> +                           !ovl_has_feature_nfs_export(ofs->upper_layer)) {
> +                               err = ovl_set_feature_nfs_export(ofs);
> +                               if (err)
> +                                       goto out_free_oe;
> +                       }

With metacopy patches, nfs_export can be disabled after this point
and it is anyway nicer to set the bit just before enabling nfs export,
i.e.:

        if (ofs->config.nfs_export) {
+             err = ovl_set_feature_nfs_export(ofs);
+             if (err)
+                     goto out_free_oe;
               sb->s_export_op = &ovl_export_operations;
        }

Thanks,
Amir.
