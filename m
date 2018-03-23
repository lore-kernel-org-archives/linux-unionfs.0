Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180322113555.47858-3-yi.zhang@huawei.com>
References: <20180322113555.47858-1-yi.zhang@huawei.com> <20180322113555.47858-3-yi.zhang@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 23 Mar 2018 14:54:42 +0300
Message-ID: <CAOQ4uxhhdy5Kdb8=xYUU9=A+By=D9Bgk-xrcJ=ZjfGSZ=rw_qQ@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] ovl: update features on upper root dir from lower layers
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 22, 2018 at 1:35 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> If user mount overlay with lower dirs which used to be upper root dirs
> at previous mount of overlay, maybe some features was enabled and the
> the lower root dir may contain feature xattr, so features on the lower
> layers maybe more than that on the upper root dir. In that case, we
> should copy up (or append) all features from the lower layers to the
> upper root dir during mount time.

This logic is questionable:
- if lower has redirect feature, but overlay was never mounted with redirect=on
  then upper is free of redirects. by copying the feature to upper
layer we loose
  information
- if lower has index/nfs_export feature from the time it was upper, this feature
  flag is useless now, because where is the index dir from the time that lower
  was upper? we don't use it at all. So inheriting those features to upper is
  weird.

I see why we need to calculate composite layers features on mount time,
but don't see why we need to update the upper feature xattrs

>
> This patch doesn't add any features. After this patch, the upper root
> dir will contain all features on every lower root dir after mount.
>
> eg:
> upper: "trusted.overlay.feature_compat=a,b,c,d"
> lower0: "trusted.overlay.feature_compat=a,b,c"
> lower1: "trusted.overlay.feature_compat=b,c,d"
>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  fs/overlayfs/super.c | 39 ++++++++++++++++++++++++++++++++++++++-
>  1 file changed, 38 insertions(+), 1 deletion(-)
>
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 10772ae237b4..19b7d0869fbd 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -231,6 +231,31 @@ static char *ovl_get_feature(struct dentry *realroot, const char *set)
>  }
>
>  /*
> + * Set overlay feature on the upper root dentry.
> + *
> + * @root: overlay root dir
> + * @upper: upper root dir
> + * @set: feature set xattr name
> + * @feature: feature string
> + * Return 0 if success, errorno otherwise.
> + */
> +static int ovl_set_feature(struct dentry *root, struct dentry *upper,
> +                          const char *set, const char *feature)
> +{
> +       int err;
> +
> +       err = ovl_want_write(root);
> +       if (err)
> +               return err;
> +
> +       err = ovl_check_setxattr(root, upper, set, feature,
> +                                strlen(feature), 0);
> +
> +       ovl_drop_write(root);
> +       return err;
> +}
> +
> +/*
>   * Add new feature to (or generate new) features string, set update flag
>   * if new feature added.
>   *
> @@ -344,6 +369,7 @@ static int ovl_get_feature_set(struct dentry *root, const char *set,
>         struct ovl_entry *oe = root->d_fsdata;
>         char *buf = NULL;
>         int i;
> +       bool update = false;
>         int err;
>
>         WARN_ON(*feature || *unknown);
> @@ -373,12 +399,23 @@ static int ovl_get_feature_set(struct dentry *root, const char *set,
>                         continue;
>
>                 err = ovl_parse_feature(buf, supp, feature,
> -                                       unknown, NULL);
> +                                       unknown, &update);
>                 kfree(buf);
>                 if (err)
>                         return err;
>         }
>
> +       /*
> +        * If features on the lower layers are more than that on the
> +        * upper dir, update them.
> +        */
> +       if (upperroot && update) {
> +               err = ovl_set_feature(root, ovl_dentry_upper(root),
> +                                     set, *feature);
> +               if (err)
> +                       return err;
> +       }
> +
>         return 0;
>  }
>
> --
> 2.13.6
>
