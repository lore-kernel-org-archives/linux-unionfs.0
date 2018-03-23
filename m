Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180322113555.47858-4-yi.zhang@huawei.com>
References: <20180322113555.47858-1-yi.zhang@huawei.com> <20180322113555.47858-4-yi.zhang@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 23 Mar 2018 15:50:21 +0300
Message-ID: <CAOQ4uxgv7wm+TqrNcr_8civ+TgZzAobGg6OoH0VsZyRyXPDzrQ@mail.gmail.com>
Subject: Re: [RFC PATCH 3/4] ovl: enable features according to mount options
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 22, 2018 at 1:35 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Unlike common disk filesystems, overlay filesystem enable features
> through mount options(e.g. -o index=on will enable index feature),
> so it's a good time to save enabled features on the upper root dir
> according to mount options. The given feature will be enabled when
> user give option "-o xxx=on" during mount time.
>
> This patch add three already support features: redirect_dir, index
> and nfs_export, the first one belongs to the incompatable feature set,
> and the other two belong to the ro_compatable feature set.
>
> eg:
> mount -t overlay -olowerdir=lower,upperdir=upper,workdir=work \
>   -oredirect_dir=on,index=on,nfs_export=on overlay merge
>
> trusted.overlay.feature_ro_compat="index,nfs_export"
> trusted.overlay.feature_incompat="redirect_dir"
>
> This patch also introduce three sets of feature check/set helper
> functions ovl_has_xxx_feature() and ovl_set_xxx_feature() which
> learn from ext4 filesystem driver.
> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> ---
>  fs/overlayfs/overlayfs.h | 73 ++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/overlayfs/ovl_entry.h |  2 ++
>  fs/overlayfs/super.c     | 71 ++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 146 insertions(+)
>
> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> index 121e81cc1550..53ed4e73f889 100644
> --- a/fs/overlayfs/overlayfs.h
> +++ b/fs/overlayfs/overlayfs.h
> @@ -47,6 +47,79 @@ enum ovl_entry_flag {
>  };
>
>  /* Features */
> +enum ovl_feature_flag {
> +       OVL_FEATURE_COMPAT,
> +       OVL_FEATURE_RO_COMPAT,
> +       OVL_FEATURE_INCOMPAT,
> +       OVL_FEATURE_MAX,
> +};
> +
> +#define OVL_FEATURE_RO_COMPAT_INDEX            "index"
> +#define OVL_FEATURE_RO_COMPAT_NFS_EXPORT       "nfs_export"
> +
> +#define OVL_FEATURE_INCOMPAT_REDIRECT_DIR      "redirect_dir"
> +
> +int ovl_set_feature_set(struct super_block *sb,
> +                       enum ovl_feature_flag flag, const char *new);
> +
> +#define OVL_FEATURE_COMPAT_FUNCS(name, flagname) \
> +static inline bool ovl_has_feature_##name(struct super_block *sb) \
> +{ \
> +       bool exist;\
> +       down_read(&OVL_FS(sb)->feature.lock); \
> +       exist = ((OVL_FS(sb)->feature.compat) && \
> +               (strstr(OVL_FS(sb)->feature.compat, \
> +                       OVL_FEATURE_COMPAT_##flagname))); \
> +       up_read(&OVL_FS(sb)->feature.lock); \
> +       return exist; \
> +} \
> +static inline int ovl_set_feature_##name(struct super_block *sb) \
> +{ \
> +       return ovl_set_feature_set(sb, OVL_FEATURE_COMPAT, \
> +                       OVL_FEATURE_COMPAT_##flagname); \
> +} \
> +
> +#define OVL_FEATURE_RO_COMPAT_FUNCS(name, flagname) \
> +static inline bool ovl_has_feature_##name(struct super_block *sb) \
> +{ \
> +       bool exist;\
> +       down_read(&OVL_FS(sb)->feature.lock); \
> +       exist = ((OVL_FS(sb)->feature.ro_compat) && \
> +               (strstr(OVL_FS(sb)->feature.ro_compat, \
> +                       OVL_FEATURE_RO_COMPAT_##flagname))); \
> +       up_read(&OVL_FS(sb)->feature.lock); \
> +       return exist; \
> +} \
> +static inline int ovl_set_feature_##name(struct super_block *sb) \
> +{ \
> +       return ovl_set_feature_set(sb, OVL_FEATURE_RO_COMPAT, \
> +                       OVL_FEATURE_RO_COMPAT_##flagname); \
> +} \
> +
> +#define OVL_FEATURE_INCOMPAT_FUNCS(name, flagname) \
> +static inline bool ovl_has_feature_##name(struct super_block *sb) \
> +{ \
> +       bool exist;\
> +       down_read(&OVL_FS(sb)->feature.lock); \
> +       exist = ((OVL_FS(sb)->feature.incompat) && \
> +               (strstr(OVL_FS(sb)->feature.incompat, \
> +                       OVL_FEATURE_INCOMPAT_##flagname))); \
> +       up_read(&OVL_FS(sb)->feature.lock); \
> +       return exist; \
> +} \
> +static inline int ovl_set_feature_##name(struct super_block *sb) \
> +{ \
> +       return ovl_set_feature_set(sb, OVL_FEATURE_INCOMPAT, \
> +                       OVL_FEATURE_INCOMPAT_##flagname); \
> +} \
> +

It is best that you copy the helpers from ext4 as is for bit flags.

> +
> +OVL_FEATURE_RO_COMPAT_FUNCS(index,             INDEX)
> +OVL_FEATURE_RO_COMPAT_FUNCS(nfs_export,                NFS_EXPORT)
> +
> +OVL_FEATURE_INCOMPAT_FUNCS(redirect_dir,       REDIRECT_DIR)
> +
> +
>  static inline bool ovl_has_unknown_compat_features(struct super_block *sb)
>  {
>         return (OVL_FS(sb)->feature.compat_unknown != NULL);
> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> index f8c5e0191a12..ff8bf783a097 100644
> --- a/fs/overlayfs/ovl_entry.h
> +++ b/fs/overlayfs/ovl_entry.h
> @@ -36,6 +36,8 @@ struct ovl_feature {
>         char *compat;
>         char *ro_compat;
>         char *incompat;
> +       struct rw_semaphore lock;       /* protect feature string */
> +
>         const char *compat_unknown;
>         const char *ro_compat_unknown;
>         const char *incompat_unknown;
> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> index 19b7d0869fbd..4787f9356dfd 100644
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -189,13 +189,22 @@ static const char *ovl_feature_compat_supp[] = {
>  };
>
>  static const char *ovl_feature_ro_compat_supp[] = {
> +       OVL_FEATURE_RO_COMPAT_INDEX,
> +       OVL_FEATURE_RO_COMPAT_NFS_EXPORT,
>         NULL
>  };
>
>  static const char *ovl_feature_incompat_supp[] = {
> +       OVL_FEATURE_INCOMPAT_REDIRECT_DIR,
>         NULL
>  };
>
> +static const char *ovl_feature_set[] = {
> +       OVL_XATTR_FEATURE_COMPAT,
> +       OVL_XATTR_FEATURE_RO_COMPAT,
> +       OVL_XATTR_FEATURE_INCOMPAT
> +};
> +
>  /*
>   * Get overlay feature from the real root dentry.
>   *
> @@ -431,6 +440,8 @@ static int ovl_init_features(struct dentry *root, struct ovl_feature *of)
>  {
>         int err;
>
> +       init_rwsem(&of->lock);
> +
>         err = ovl_get_feature_set(root, OVL_XATTR_FEATURE_COMPAT,
>                                   ovl_feature_compat_supp, &of->compat,
>                                   &of->compat_unknown);
> @@ -487,6 +498,49 @@ static bool ovl_check_feature_ok(struct super_block *sb, bool readonly)
>         return true;
>  }
>
> +/*
> + * Set one specified feature to the upper root dir
> + *
> + * @sb: overlay super block
> + * @flag: feature set flag, compat/ro compat/incompat
> + * @new: new feature want to set
> + * Return 0 if success, errno otherwise.
> + */
> +int ovl_set_feature_set(struct super_block *sb,
> +                       enum ovl_feature_flag flag, const char *new)
> +{
> +       struct ovl_feature *of = &OVL_FS(sb)->feature;
> +       bool update = false;
> +       char **feature;
> +       int err;
> +
> +       /* Don't set feature if no upper layer */
> +       if (!OVL_FS(sb)->upper_mnt)
> +               return 0;
> +
> +       down_write(&of->lock);
> +       if (flag == OVL_FEATURE_COMPAT)
> +               feature = &of->compat;
> +       else if (flag == OVL_FEATURE_RO_COMPAT)
> +               feature = &of->ro_compat;
> +       else
> +               feature = &of->incompat;
> +
> +       err = ovl_update_feature(feature, new, &update);
> +       if (err)
> +               goto out;
> +       if (!update)
> +               goto out;
> +
> +       /* Set updated compat features to upper root dir */
> +       err = ovl_set_feature(sb->s_root, ovl_dentry_upper(sb->s_root),
> +                             ovl_feature_set[flag],  *feature);
> +out:
> +       up_write(&of->lock);
> +       return err;
> +}
> +
> +
>  static struct kmem_cache *ovl_inode_cachep;
>
>  static struct inode *ovl_alloc_inode(struct super_block *sb)
> @@ -1689,6 +1743,23 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>         if (!ovl_check_feature_ok(sb, (sb_rdonly(sb))))
>                 goto out_free_root;
>
> +       /* Turn on features according to mount options */
> +       if (ofs->config.index && !ovl_has_feature_index(sb)) {
> +               err = ovl_set_feature_index(sb);
> +               if (err)
> +                       goto out_free_root;
> +       }
> +       if (ofs->config.nfs_export && !ovl_has_feature_nfs_export(sb)) {
> +               err = ovl_set_feature_nfs_export(sb);
> +               if (err)
> +                       goto out_free_root;
> +       }
> +       if (ofs->config.redirect_dir && !ovl_has_feature_redirect_dir(sb)) {
> +               err = ovl_set_feature_redirect_dir(sb);
> +               if (err)
> +                       goto out_free_root;
> +       }
> +

Let's move all these to a helper.
w.r.t. redirect_dir, I am not sure it makes sense to declare an
incompat feature on mount.
It would be wiser to set the incompat feature on first set of redirect.
If we store features are bit flags, then checking if feature is
enabled before setting redirect
is not expensive.

Thanks,
Amir.
