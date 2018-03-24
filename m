Return-Path: <yizhang089@gmail.com>
Return-Path: <yizhang089@gmail.com>
Subject: Re: [RFC PATCH 1/4] ovl: add feature set support
References: <20180322113555.47858-1-yi.zhang@huawei.com>
 <20180322113555.47858-2-yi.zhang@huawei.com>
 <CAOQ4uxi_0u3NOm0HkiSDBChHuCD_NiiWUo5nMxxmK8iAbxavwg@mail.gmail.com>
From: "zhangyi (F)" <yizhang089@gmail.com>
Message-ID: <20b9c6b4-4be7-ee17-e244-cc7d56c7a175@gmail.com>
Date: Sat, 24 Mar 2018 20:55:52 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxi_0u3NOm0HkiSDBChHuCD_NiiWUo5nMxxmK8iAbxavwg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
To: Amir Goldstein <amir73il@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/3/23 20:12, Amir Goldstein Wrote:
> On Thu, Mar 22, 2018 at 1:35 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> In order to distinguish the backward compatible and backward
>> incompatible features in overlay filesystem, we introduce
>> "compat/ro_compat/incompat" three kinds of feature set and
>> store them on the upper root dir via xattr:
>> "trusted.overlay.feature_[compat|ro_compat|incompat]=xxx,xxx"
>>
>> Mount operation should fail if one unknown incompatible feature is
>> detected on the upper root dir, and read-write mount operation should
>> fail if one unknown ro_compat feature is detected on the upper root
>> dir. At the same time, lower layers may also have some backward
>> incompatible features when they used to be upper root dir, so do the
>> same check as upper root dir.
>>
>> This patch doesn't add any features, so if any feature xattrs is
>> detected on the underlying root dir, it will be recognized as unknown
>> feature.
>>
>> Suggested-by: Amir Goldstein <amir73il@gmail.com>
> 
> To be fair, I *suggested* to use Miklos' suggestion...
> 

Oh，sorry，I will add.

>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>   fs/overlayfs/overlayfs.h |  17 +++
>>   fs/overlayfs/ovl_entry.h |  16 +++
>>   fs/overlayfs/super.c     | 302 ++++++++++++++++++++++++++++++++++++++++++++++-
> 
> This series adds a lot of code to super.c which is big enough already
> I suggest to start features.c.
> 
> 
>>   3 files changed, 330 insertions(+), 5 deletions(-)
>>
>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>> index 225ff1171147..121e81cc1550 100644
>> --- a/fs/overlayfs/overlayfs.h
>> +++ b/fs/overlayfs/overlayfs.h
>> @@ -28,6 +28,9 @@ enum ovl_path_type {
>>   #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
>>   #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
>>   #define OVL_XATTR_UPPER OVL_XATTR_PREFIX "upper"
>> +#define OVL_XATTR_FEATURE_COMPAT OVL_XATTR_PREFIX "feature_compat"
>> +#define OVL_XATTR_FEATURE_RO_COMPAT OVL_XATTR_PREFIX "feature_ro_compat"
>> +#define OVL_XATTR_FEATURE_INCOMPAT OVL_XATTR_PREFIX "feature_incompat"
>>
>>   enum ovl_inode_flag {
>>          /* Pure upper dir that may contain non pure upper entries */
>> @@ -43,6 +46,20 @@ enum ovl_entry_flag {
>>          OVL_E_CONNECTED,
>>   };
>>
>> +/* Features */
>> +static inline bool ovl_has_unknown_compat_features(struct super_block *sb)
>> +{
>> +       return (OVL_FS(sb)->feature.compat_unknown != NULL);
>> +}
>> +static inline bool ovl_has_unknown_ro_compat_features(struct super_block *sb)
>> +{
>> +       return (OVL_FS(sb)->feature.ro_compat_unknown != NULL);
>> +}
>> +static inline bool ovl_has_unknown_incompat_features(struct super_block *sb)
>> +{
>> +       return (OVL_FS(sb)->feature.incompat_unknown != NULL);
>> +}
>> +
>>   /*
>>    * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
>>    * where:
>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>> index bfef6edcc111..f8c5e0191a12 100644
>> --- a/fs/overlayfs/ovl_entry.h
>> +++ b/fs/overlayfs/ovl_entry.h
>> @@ -32,6 +32,15 @@ struct ovl_path {
>>          struct dentry *dentry;
>>   };
>>
>> +struct ovl_feature {
>> +       char *compat;
>> +       char *ro_compat;
>> +       char *incompat;
>> +       const char *compat_unknown;
>> +       const char *ro_compat_unknown;
>> +       const char *incompat_unknown;
>> +};
>> +
> 
> IMO those should be 64bit bit flags, like in other fs,
> see more below.
> 
>>   /* private information held for overlayfs's superblock */
>>   struct ovl_fs {
>>          struct vfsmount *upper_mnt;
>> @@ -55,6 +64,8 @@ struct ovl_fs {
>>          /* Did we take the inuse lock? */
>>          bool upperdir_locked;
>>          bool workdir_locked;
>> +       /* features */
>> +       struct ovl_feature feature;
>>   };
>>
>>   /* private information held for every overlayfs dentry */
>> @@ -94,6 +105,11 @@ static inline struct ovl_inode *OVL_I(struct inode *inode)
>>          return container_of(inode, struct ovl_inode, vfs_inode);
>>   }
>>
>> +static inline struct ovl_fs *OVL_FS(struct super_block *sb)
>> +{
>> +       return sb->s_fs_info;
>> +}
>> +
>>   static inline struct dentry *ovl_upperdentry_dereference(struct ovl_inode *oi)
>>   {
>>          return READ_ONCE(oi->__upperdentry);
>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>> index 7c24619ae7fc..10772ae237b4 100644
>> --- a/fs/overlayfs/super.c
>> +++ b/fs/overlayfs/super.c
>> @@ -184,6 +184,272 @@ static const struct dentry_operations ovl_reval_dentry_operations = {
>>          .d_weak_revalidate = ovl_dentry_weak_revalidate,
>>   };
>>
>> +static const char *ovl_feature_compat_supp[] = {
>> +       NULL
>> +};
>> +
>> +static const char *ovl_feature_ro_compat_supp[] = {
>> +       NULL
>> +};
>> +
>> +static const char *ovl_feature_incompat_supp[] = {
>> +       NULL
>> +};
>> +
>> +/*
>> + * Get overlay feature from the real root dentry.
>> + *
>> + * @realroot: real underlying root dir dentry
>> + * @set: feature set xattr name
>> + * Return feature string if success, NULL if no feature and
>> + * error number if error.
>> + */
>> +static char *ovl_get_feature(struct dentry *realroot, const char *set)
>> +{
>> +       int res;
>> +       char *buf;
>> +
>> +       res = vfs_getxattr(realroot, set, NULL, 0);
>> +       if (res <= 0) {
>> +               if (res == -EOPNOTSUPP || res == -ENODATA)
>> +                       res = 0;
>> +               return ERR_PTR(res);
>> +       }
>> +
>> +       buf = kmalloc(res + 1, GFP_KERNEL);
>> +       if (!buf)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       res = vfs_getxattr(realroot, set, buf, res);
>> +       if (res <= 0) {
>> +               kfree(buf);
>> +               return ERR_PTR(res);
>> +       }
>> +
>> +       buf[res] = '\0';
>> +       return buf;
>> +}
>> +
>> +/*
>> + * Add new feature to (or generate new) features string, set update flag
>> + * if new feature added.
>> + *
>> + * @feature: output feature string
>> + * @add: feature want to add
>> + * @update: set when new feature add, no change otherwise
>> + * Return 0 if success, error number otherwise.
>> + */
>> +static int ovl_update_feature(char **feature, const char *add,
>> +                             bool *update)
>> +{
>> +       char *p = *feature;
>> +       char *tmp;
>> +       int size;
>> +
>> +       if (p && strstr(p, add))
>> +               return 0;
>> +
>> +       size = strlen(add) + 1;
>> +       if (p) {
>> +               size += strlen(p) + 1;
>> +               tmp = kmalloc(size, GFP_KERNEL);
>> +               if (!tmp)
>> +                       return -ENOMEM;
>> +
>> +               snprintf(tmp, size, "%s,%s", p, add);
>> +               kfree(p);
>> +       } else {
>> +               tmp = kmalloc(size, GFP_KERNEL);
>> +               if (!tmp)
>> +                       return -ENOMEM;
>> +
>> +               strncpy(tmp, add, size);
>> +       }
>> +
>> +       if (update)
>> +               *update = true;
>> +       *feature = tmp;
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Parse features and split out unknown features, set update flag
>> + * if new feature added.
>> + *
>> + * @features: input feature string which need to parse
>> + * @supp: support feature list
>> + * @feature: output feature string
>> + * @unknown: unknown feature string
>> + * @update: set when new feature add, no change otherwise
>> + * Return 0 if success, errno otherwise.
>> + */
>> +static int ovl_parse_feature(char *features, const char *supp[],
>> +                            char **feature, const char **unknown,
>> +                            bool *update)
>> +{
>> +       const char **fs;
>> +       char *tmpf = NULL, *tmpu = NULL;
>> +       char *p;
>> +       int err = 0;
>> +
>> +       if (!features)
>> +               return 0;
>> +
>> +       while ((p = strsep(&features, ",")) != NULL) {
>> +               /* Add to or generate parsed feature string */
>> +               err = ovl_update_feature(&tmpf, p, update);
>> +               if (err)
>> +                       goto err;
>> +
>> +               /* Check support or not */
>> +               for (fs = supp; *fs; fs++) {
>> +                       if (strcmp(p, *fs) == 0)
>> +                               break;
>> +               }
>> +
>> +               if (*fs)
>> +                       continue;
>> +
>> +               /* Non-supported feature found, add to unknown */
>> +               err = ovl_update_feature(&tmpu, p, NULL);
>> +               if (err)
>> +                       goto err;
>> +       }
>> +
>> +       *feature = tmpf;
>> +       *unknown = tmpu;
>> +       return 0;
>> +err:
>> +       kfree(tmpf);
>> +       kfree(tmpu);
>> +       return err;
>> +}
>> +
> 
> The past ~200 lines are a re-implementation (probably buggy) of tokenize
> and for what? saving the features as strings in xattrs is questionable -
> it serves no purpose other than human convenience when reading features xattrs.
> We can store a 64bit binary flags blob in big endian order, just like

IIUC, I find ext4 and btrfs use little-endian but xfs use big-endian, is
little-endian better? because our cpu endian is more likely use 
little-endian by default.

> any other fs,
> and then we need no parsing, no string find and no string insertion helpers.
> 
> Not to mention that some fs have limited size of xattr, which is going
> to limit us in
> the future with the amount of features and feature name lengths.
> 

It's fine to me, I was trying to use u64 bit mask but found it's not 
readable, so I chose to use strings, but it has a lot of disadvantages 
as you said. I'd like to change to use u64 bit mask, and it means there 
is one more thing should do, we should introduce a feature translation 
tools (something like "dumpe2fs -h" or "tune2fs -l", and the feature 
xattr is more like a simple overlay super block) to show features to 
user, right?

> 
>> +/*
>> + * Get one set of features from the underlying root dir and parse
>> + * them to get the unknown features.
>> + *
>> + * @root: overlay root dentry
>> + * @set: feature set xattr name
>> + * @supp: supported feature list
>> + * @feature: output features string
>> + * @unknown: unknown features string
>> + * Return 0 if success, errno otherwise.
>> + */
>> +static int ovl_get_feature_set(struct dentry *root, const char *set,
>> +                              const char *supp[], char **feature,
>> +                              const char **unknown)
>> +{
>> +       struct dentry *upperroot = ovl_dentry_upper(root);
>> +       struct ovl_entry *oe = root->d_fsdata;
>> +       char *buf = NULL;
>> +       int i;
>> +       int err;
>> +
>> +       WARN_ON(*feature || *unknown);
>> +
>> +       /* Get features from the upper root dir */
>> +       if (upperroot) {
>> +               buf = ovl_get_feature(upperroot, set);
>> +               if (IS_ERR(buf))
>> +                       return PTR_ERR(buf);
>> +               if (!buf)
>> +                       goto get_lower;
>> +
>> +               err = ovl_parse_feature(buf, supp, feature,
>> +                                       unknown, NULL);
>> +               kfree(buf);
>> +               if (err)
>> +                       return err;
>> +       }
>> +
>> +get_lower:
>> +       /* Get features from each lower root dir beside the bottom layer */
>> +       for (i = 0; i < oe->numlower-1; i++) {
>> +               buf = ovl_get_feature(oe->lowerstack[i].dentry, set);
>> +               if (IS_ERR(buf))
>> +                       return PTR_ERR(buf);
>> +               if (!buf)
>> +                       continue;
>> +
>> +               err = ovl_parse_feature(buf, supp, feature,
>> +                                       unknown, NULL);
>> +               kfree(buf);
>> +               if (err)
>> +                       return err;
>> +       }
>> +
>> +       return 0;
>> +}
>> +
>> +/*
>> + * Get all features from the upper and lower root dir and parse them to get
>> + * unknown features.
>> + *
>> + * @root: overlay root dir dentry
>> + * @of: overlay feature set want to init
>> + * Return 0 if success, errno otherwise.
>> + */
>> +static int ovl_init_features(struct dentry *root, struct ovl_feature *of)
>> +{
>> +       int err;
>> +
>> +       err = ovl_get_feature_set(root, OVL_XATTR_FEATURE_COMPAT,
>> +                                 ovl_feature_compat_supp, &of->compat,
>> +                                 &of->compat_unknown);
>> +       if (err)
>> +               return err;
>> +
>> +       err = ovl_get_feature_set(root, OVL_XATTR_FEATURE_RO_COMPAT,
>> +                                 ovl_feature_ro_compat_supp, &of->ro_compat,
>> +                                 &of->ro_compat_unknown);
>> +       if (err)
>> +               return err;
>> +
>> +       err = ovl_get_feature_set(root, OVL_XATTR_FEATURE_INCOMPAT,
>> +                                 ovl_feature_incompat_supp, &of->incompat,
>> +                                 &of->incompat_unknown);
>> +       return err;
>> +}
>> +
>> +/*
>> + * Check whether this filesystem can be mounted based on
>> + * the features present and the read-only/read-write mount requested.
>> + * Returns true if this filesystem can be mounted as requested,
>> + * false if it cannot be.
>> + */
>> +static bool ovl_check_feature_ok(struct super_block *sb, bool readonly)
>> +{
>> +       struct ovl_feature *of = &OVL_FS(sb)->feature;
>> +
>> +       if (ovl_has_unknown_incompat_features(sb)) {
>> +               pr_err("overlayfs: unknown optional incompat features "
>> +                      "enabled: %s\n", of->incompat_unknown);
>> +               pr_err("overlayfs: filesystem cannot not be safely mounted "
>> +                      "by this kernel\n");
>> +               return false;
>> +       }
>> +
>> +       if (ovl_has_unknown_ro_compat_features(sb)) {
>> +               pr_err("overlayfs: unknown optional ro_compat features "
>> +                      "enabled: %s\n", of->ro_compat_unknown);
>> +
>> +               if (readonly)
>> +                       return true;
>> +
>> +               pr_err("overlayfs: filesystem cannot not be safely mounted "
>> +                      "read-write by this kernel\n");
>> +               return false;
>> +       }
>> +
>> +       if (ovl_has_unknown_compat_features(sb)) {
>> +               pr_warn("overlayfs: unknown optional compat features "
>> +                       "enabled: %s\n", of->compat_unknown);
>> +       }
>> +
>> +       return true;
>> +}
>> +
>>   static struct kmem_cache *ovl_inode_cachep;
>>
>>   static struct inode *ovl_alloc_inode(struct super_block *sb)
>> @@ -242,6 +508,13 @@ static void ovl_free_fs(struct ovl_fs *ofs)
>>          }
>>          kfree(ofs->lower_layers);
>>
>> +       kfree(ofs->feature.compat);
>> +       kfree(ofs->feature.ro_compat);
>> +       kfree(ofs->feature.incompat);
>> +       kfree(ofs->feature.compat_unknown);
>> +       kfree(ofs->feature.ro_compat_unknown);
>> +       kfree(ofs->feature.incompat_unknown);
>> +
> 
> If we are not getting rid of the strings, at least use a helper to
> free ovl_features.
> 

Yes, will do.

>>          kfree(ofs->config.lowerdir);
>>          kfree(ofs->config.upperdir);
>>          kfree(ofs->config.workdir);
>> @@ -357,7 +630,8 @@ static int ovl_remount(struct super_block *sb, int *flags, char *data)
>>   {
>>          struct ovl_fs *ofs = sb->s_fs_info;
>>
>> -       if (!(*flags & SB_RDONLY) && ovl_force_readonly(ofs))
>> +       if (!(*flags & SB_RDONLY) &&
>> +            (ovl_force_readonly(ofs) || !ovl_check_feature_ok(sb, false)))
>>                  return -EROFS;
>>
>>          return 0;
>> @@ -902,6 +1176,7 @@ static const struct xattr_handler *ovl_xattr_handlers[] = {
>>          NULL
>>   };
>>
>> +
>>   static int ovl_get_upper(struct ovl_fs *ofs, struct path *upperpath)
>>   {
>>          struct vfsmount *upper_mnt;
>> @@ -1284,11 +1559,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>>
>>                  err = ovl_get_upper(ofs, &upperpath);
>>                  if (err)
>> -                       goto out_err;
>> +                       goto out_free_upper;
>>
>>                  err = ovl_get_workdir(ofs, &upperpath);
>>                  if (err)
>> -                       goto out_err;
>> +                       goto out_free_upper;
>>
>>                  if (!ofs->workdir)
>>                          sb->s_flags |= SB_RDONLY;
>> @@ -1300,7 +1575,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>>          oe = ovl_get_lowerstack(sb, ofs);
>>          err = PTR_ERR(oe);
>>          if (IS_ERR(oe))
>> -               goto out_err;
>> +               goto out_free_upper;
>>
>>          /* If the upper fs is nonexistent, we mark overlayfs r/o too */
>>          if (!ofs->upper_mnt)
>> @@ -1365,13 +1640,30 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>>
>>          sb->s_root = root_dentry;
>>
>> +       /*
>> +        * Get features from the upper and lower root dir, and check
>> +        * them could be mounted properly by this kernel.
>> +        */
>> +       err = ovl_init_features(sb->s_root, &ofs->feature);
>> +       if (err)
>> +               goto out_free_root;
>> +
>> +       err = -EINVAL;
>> +       if (!ovl_check_feature_ok(sb, (sb_rdonly(sb))))
>> +               goto out_free_root;
>> +
> 
> feature check should be much sooner.
> Why do it after setting up root dentry?
> Miklos did a lot of cleanup on fill_super and this is messing it up.
> 

It can move earlier beside use sb as input, will do.

Thanks,
Yi.

>>          return 0;
>>
>> +out_free_root:
>> +       dput(sb->s_root);
>> +       sb->s_root = NULL;
>> +       goto out_err;
>>   out_free_oe:
>>          ovl_entry_stack_free(oe);
>>          kfree(oe);
>> -out_err:
>> +out_free_upper:
> 
> 
> IMO, you could and should avoid adding this goto tag.
> 
> Thanks,
> Amir.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
