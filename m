Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20b9c6b4-4be7-ee17-e244-cc7d56c7a175@gmail.com>
References: <20180322113555.47858-1-yi.zhang@huawei.com> <20180322113555.47858-2-yi.zhang@huawei.com>
 <CAOQ4uxi_0u3NOm0HkiSDBChHuCD_NiiWUo5nMxxmK8iAbxavwg@mail.gmail.com> <20b9c6b4-4be7-ee17-e244-cc7d56c7a175@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 24 Mar 2018 16:56:56 +0300
Message-ID: <CAOQ4uxhpx=7jYzKn-DWJ=oaXiR40Zgqx55VkWGtYhO=gWJ9qMQ@mail.gmail.com>
Subject: Re: [RFC PATCH 1/4] ovl: add feature set support
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: "zhangyi (F)" <yizhang089@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Mar 24, 2018 at 3:55 PM, zhangyi (F) <yizhang089@gmail.com> wrote:
> On 2018/3/23 20:12, Amir Goldstein Wrote:
>>
>> On Thu, Mar 22, 2018 at 1:35 PM, zhangyi (F) <yi.zhang@huawei.com> wrote=
:
>>>
>>> In order to distinguish the backward compatible and backward
>>> incompatible features in overlay filesystem, we introduce
>>> "compat/ro_compat/incompat" three kinds of feature set and
>>> store them on the upper root dir via xattr:
>>> "trusted.overlay.feature_[compat|ro_compat|incompat]=3Dxxx,xxx"
>>>
>>> Mount operation should fail if one unknown incompatible feature is
>>> detected on the upper root dir, and read-write mount operation should
>>> fail if one unknown ro_compat feature is detected on the upper root
>>> dir. At the same time, lower layers may also have some backward
>>> incompatible features when they used to be upper root dir, so do the
>>> same check as upper root dir.
>>>
>>> This patch doesn't add any features, so if any feature xattrs is
>>> detected on the underlying root dir, it will be recognized as unknown
>>> feature.
>>>
>>> Suggested-by: Amir Goldstein <amir73il@gmail.com>
>>
>>
>> To be fair, I *suggested* to use Miklos' suggestion...
>>
>
> Oh=EF=BC=8Csorry=EF=BC=8CI will add.
>
>
>>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>>> ---
>>>   fs/overlayfs/overlayfs.h |  17 +++
>>>   fs/overlayfs/ovl_entry.h |  16 +++
>>>   fs/overlayfs/super.c     | 302
>>> ++++++++++++++++++++++++++++++++++++++++++++++-
>>
>>
>> This series adds a lot of code to super.c which is big enough already
>> I suggest to start features.c.
>>
>>
>>>   3 files changed, 330 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>>> index 225ff1171147..121e81cc1550 100644
>>> --- a/fs/overlayfs/overlayfs.h
>>> +++ b/fs/overlayfs/overlayfs.h
>>> @@ -28,6 +28,9 @@ enum ovl_path_type {
>>>   #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
>>>   #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
>>>   #define OVL_XATTR_UPPER OVL_XATTR_PREFIX "upper"
>>> +#define OVL_XATTR_FEATURE_COMPAT OVL_XATTR_PREFIX "feature_compat"
>>> +#define OVL_XATTR_FEATURE_RO_COMPAT OVL_XATTR_PREFIX "feature_ro_compa=
t"
>>> +#define OVL_XATTR_FEATURE_INCOMPAT OVL_XATTR_PREFIX "feature_incompat"
>>>
>>>   enum ovl_inode_flag {
>>>          /* Pure upper dir that may contain non pure upper entries */
>>> @@ -43,6 +46,20 @@ enum ovl_entry_flag {
>>>          OVL_E_CONNECTED,
>>>   };
>>>
>>> +/* Features */
>>> +static inline bool ovl_has_unknown_compat_features(struct super_block
>>> *sb)
>>> +{
>>> +       return (OVL_FS(sb)->feature.compat_unknown !=3D NULL);
>>> +}
>>> +static inline bool ovl_has_unknown_ro_compat_features(struct super_blo=
ck
>>> *sb)
>>> +{
>>> +       return (OVL_FS(sb)->feature.ro_compat_unknown !=3D NULL);
>>> +}
>>> +static inline bool ovl_has_unknown_incompat_features(struct super_bloc=
k
>>> *sb)
>>> +{
>>> +       return (OVL_FS(sb)->feature.incompat_unknown !=3D NULL);
>>> +}
>>> +
>>>   /*
>>>    * The tuple (fh,uuid) is a universal unique identifier for a copy up
>>> origin,
>>>    * where:
>>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>>> index bfef6edcc111..f8c5e0191a12 100644
>>> --- a/fs/overlayfs/ovl_entry.h
>>> +++ b/fs/overlayfs/ovl_entry.h
>>> @@ -32,6 +32,15 @@ struct ovl_path {
>>>          struct dentry *dentry;
>>>   };
>>>
>>> +struct ovl_feature {
>>> +       char *compat;
>>> +       char *ro_compat;
>>> +       char *incompat;
>>> +       const char *compat_unknown;
>>> +       const char *ro_compat_unknown;
>>> +       const char *incompat_unknown;
>>> +};
>>> +
>>
>>
>> IMO those should be 64bit bit flags, like in other fs,
>> see more below.
>>
>>>   /* private information held for overlayfs's superblock */
>>>   struct ovl_fs {
>>>          struct vfsmount *upper_mnt;
>>> @@ -55,6 +64,8 @@ struct ovl_fs {
>>>          /* Did we take the inuse lock? */
>>>          bool upperdir_locked;
>>>          bool workdir_locked;
>>> +       /* features */
>>> +       struct ovl_feature feature;
>>>   };
>>>
>>>   /* private information held for every overlayfs dentry */
>>> @@ -94,6 +105,11 @@ static inline struct ovl_inode *OVL_I(struct inode
>>> *inode)
>>>          return container_of(inode, struct ovl_inode, vfs_inode);
>>>   }
>>>
>>> +static inline struct ovl_fs *OVL_FS(struct super_block *sb)
>>> +{
>>> +       return sb->s_fs_info;
>>> +}
>>> +
>>>   static inline struct dentry *ovl_upperdentry_dereference(struct
>>> ovl_inode *oi)
>>>   {
>>>          return READ_ONCE(oi->__upperdentry);
>>> diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>>> index 7c24619ae7fc..10772ae237b4 100644
>>> --- a/fs/overlayfs/super.c
>>> +++ b/fs/overlayfs/super.c
>>> @@ -184,6 +184,272 @@ static const struct dentry_operations
>>> ovl_reval_dentry_operations =3D {
>>>          .d_weak_revalidate =3D ovl_dentry_weak_revalidate,
>>>   };
>>>
>>> +static const char *ovl_feature_compat_supp[] =3D {
>>> +       NULL
>>> +};
>>> +
>>> +static const char *ovl_feature_ro_compat_supp[] =3D {
>>> +       NULL
>>> +};
>>> +
>>> +static const char *ovl_feature_incompat_supp[] =3D {
>>> +       NULL
>>> +};
>>> +
>>> +/*
>>> + * Get overlay feature from the real root dentry.
>>> + *
>>> + * @realroot: real underlying root dir dentry
>>> + * @set: feature set xattr name
>>> + * Return feature string if success, NULL if no feature and
>>> + * error number if error.
>>> + */
>>> +static char *ovl_get_feature(struct dentry *realroot, const char *set)
>>> +{
>>> +       int res;
>>> +       char *buf;
>>> +
>>> +       res =3D vfs_getxattr(realroot, set, NULL, 0);
>>> +       if (res <=3D 0) {
>>> +               if (res =3D=3D -EOPNOTSUPP || res =3D=3D -ENODATA)
>>> +                       res =3D 0;
>>> +               return ERR_PTR(res);
>>> +       }
>>> +
>>> +       buf =3D kmalloc(res + 1, GFP_KERNEL);
>>> +       if (!buf)
>>> +               return ERR_PTR(-ENOMEM);
>>> +
>>> +       res =3D vfs_getxattr(realroot, set, buf, res);
>>> +       if (res <=3D 0) {
>>> +               kfree(buf);
>>> +               return ERR_PTR(res);
>>> +       }
>>> +
>>> +       buf[res] =3D '\0';
>>> +       return buf;
>>> +}
>>> +
>>> +/*
>>> + * Add new feature to (or generate new) features string, set update fl=
ag
>>> + * if new feature added.
>>> + *
>>> + * @feature: output feature string
>>> + * @add: feature want to add
>>> + * @update: set when new feature add, no change otherwise
>>> + * Return 0 if success, error number otherwise.
>>> + */
>>> +static int ovl_update_feature(char **feature, const char *add,
>>> +                             bool *update)
>>> +{
>>> +       char *p =3D *feature;
>>> +       char *tmp;
>>> +       int size;
>>> +
>>> +       if (p && strstr(p, add))
>>> +               return 0;
>>> +
>>> +       size =3D strlen(add) + 1;
>>> +       if (p) {
>>> +               size +=3D strlen(p) + 1;
>>> +               tmp =3D kmalloc(size, GFP_KERNEL);
>>> +               if (!tmp)
>>> +                       return -ENOMEM;
>>> +
>>> +               snprintf(tmp, size, "%s,%s", p, add);
>>> +               kfree(p);
>>> +       } else {
>>> +               tmp =3D kmalloc(size, GFP_KERNEL);
>>> +               if (!tmp)
>>> +                       return -ENOMEM;
>>> +
>>> +               strncpy(tmp, add, size);
>>> +       }
>>> +
>>> +       if (update)
>>> +               *update =3D true;
>>> +       *feature =3D tmp;
>>> +       return 0;
>>> +}
>>> +
>>> +/*
>>> + * Parse features and split out unknown features, set update flag
>>> + * if new feature added.
>>> + *
>>> + * @features: input feature string which need to parse
>>> + * @supp: support feature list
>>> + * @feature: output feature string
>>> + * @unknown: unknown feature string
>>> + * @update: set when new feature add, no change otherwise
>>> + * Return 0 if success, errno otherwise.
>>> + */
>>> +static int ovl_parse_feature(char *features, const char *supp[],
>>> +                            char **feature, const char **unknown,
>>> +                            bool *update)
>>> +{
>>> +       const char **fs;
>>> +       char *tmpf =3D NULL, *tmpu =3D NULL;
>>> +       char *p;
>>> +       int err =3D 0;
>>> +
>>> +       if (!features)
>>> +               return 0;
>>> +
>>> +       while ((p =3D strsep(&features, ",")) !=3D NULL) {
>>> +               /* Add to or generate parsed feature string */
>>> +               err =3D ovl_update_feature(&tmpf, p, update);
>>> +               if (err)
>>> +                       goto err;
>>> +
>>> +               /* Check support or not */
>>> +               for (fs =3D supp; *fs; fs++) {
>>> +                       if (strcmp(p, *fs) =3D=3D 0)
>>> +                               break;
>>> +               }
>>> +
>>> +               if (*fs)
>>> +                       continue;
>>> +
>>> +               /* Non-supported feature found, add to unknown */
>>> +               err =3D ovl_update_feature(&tmpu, p, NULL);
>>> +               if (err)
>>> +                       goto err;
>>> +       }
>>> +
>>> +       *feature =3D tmpf;
>>> +       *unknown =3D tmpu;
>>> +       return 0;
>>> +err:
>>> +       kfree(tmpf);
>>> +       kfree(tmpu);
>>> +       return err;
>>> +}
>>> +
>>
>>
>> The past ~200 lines are a re-implementation (probably buggy) of tokenize
>> and for what? saving the features as strings in xattrs is questionable -
>> it serves no purpose other than human convenience when reading features
>> xattrs.
>> We can store a 64bit binary flags blob in big endian order, just like
>
>
> IIUC, I find ext4 and btrfs use little-endian but xfs use big-endian, is
> little-endian better? because our cpu endian is more likely use
> little-endian by default.

I have no strong feeling. I was under the impression that file systems
ext4 included usually stores on-disk data as big-endiad.
The only slight advantage of big-endian for humans in this context
is that getfattr -e hex displays a bitmask that is easier to read
at least when you look at the #define values of the flags.

>
>> any other fs,
>> and then we need no parsing, no string find and no string insertion
>> helpers.
>>
>> Not to mention that some fs have limited size of xattr, which is going
>> to limit us in
>> the future with the amount of features and feature name lengths.
>>
>
> It's fine to me, I was trying to use u64 bit mask but found it's not
> readable, so I chose to use strings, but it has a lot of disadvantages as
> you said. I'd like to change to use u64 bit mask, and it means there is o=
ne
> more thing should do, we should introduce a feature translation tools
> (something like "dumpe2fs -h" or "tune2fs -l", and the feature xattr is m=
ore
> like a simple overlay super block) to show features to user, right?
>

It's nice to have and optional IMO, but not a must.
Since fsck.overlay is going to play a big part in the transition from
v1 to v2, detecting and setting features, I think it could also be the tool
to report existing features (-h flag?).

Thanks,
Amir.
