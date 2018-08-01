Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxg38tQN1g9oTeu6ZZ8SncUoQCoeZgFAZQ0ZL5UGsXktkA@mail.gmail.com>
References: <20180731093727.26855-1-yi.zhang@huawei.com> <20180731093727.26855-5-yi.zhang@huawei.com>
 <CAOQ4uxg38tQN1g9oTeu6ZZ8SncUoQCoeZgFAZQ0ZL5UGsXktkA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 1 Aug 2018 14:04:52 +0300
Message-ID: <CAOQ4uxhaoP3GsQAx47eLMvEHVLRHk_13ePT_R0=zob1mr1Knaw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 4/9] ovl: add helper funcs to set upper layer
 feature set
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Aug 1, 2018 at 11:51 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> overlayfs will want to add the upper layer's feature bitset if some
>> overlay file system features were set. For example: redirect dir feature
>> will be set when user rename a lower/merge dir if redirect dir feature
>> is enabled. So add helper functions to set feature sets to the upper
>> layer for future use.
>>
>> This patch introduce helper functions only, does not set any feature
>> bits.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> ---
>>  fs/overlayfs/feature.c   | 85 ++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/overlayfs/overlayfs.h | 46 ++++++++++++++++++++++++++
>>  fs/overlayfs/ovl_entry.h |  2 ++
>>  fs/overlayfs/super.c     |  1 +
>>  4 files changed, 134 insertions(+)
>>
>> diff --git a/fs/overlayfs/feature.c b/fs/overlayfs/feature.c
>> index fac4d7544475..7c66e71bdd98 100644
>> --- a/fs/overlayfs/feature.c
>> +++ b/fs/overlayfs/feature.c
>> @@ -10,6 +10,8 @@
>>
>>  #include <linux/fs.h>
>>  #include <linux/xattr.h>
>> +#include <linux/mount.h>
>> +#include <linux/ratelimit.h>
>>  #include "overlayfs.h"
>>
>>  /*
>> @@ -63,6 +65,89 @@ static struct ovl_d_feature *ovl_get_feature(struct dentry *realroot)
>>  }
>>
>>  /*
>> + * Set overlay features to the upper root dir.
>> + *
>> + * @upper_layer: overlay upper layer information,
>> + * @upper: upper root dentry.
>> + *
>> + * Return 0 if success, error number otherwise.
>> + */
>> +static int ovl_set_feature(struct ovl_layer *upper_layer,
>> +                          struct dentry *upper)
>> +{
>> +       struct vfsmount *upper_mnt = upper_layer->mnt;
>> +       struct ovl_d_feature odf = {};
>> +       int err;
>> +
>> +       odf.magic = OVL_FEATURE_MAGIC;
>> +       odf.compat = cpu_to_be64(upper_layer->compat);
>> +       odf.ro_compat = cpu_to_be64(upper_layer->ro_compat);
>> +       odf.incompat = cpu_to_be64(upper_layer->incompat);
>> +
>> +       err = mnt_want_write(upper_mnt);
>> +       if (err)
>> +               return err;
>> +
>> +       err = ovl_do_setxattr(upper, OVL_XATTR_FEATURE,
>> +                             &odf, sizeof(odf), 0);
>> +       if (err)
>> +               pr_err_ratelimited("overlayfs: failed to set features (%i)\n", err);
>> +
>> +       mnt_drop_write(upper_mnt);
>> +       return err;
>> +}
>> +
>> +/*
>> + * Add feature bit mask to the upper root dir.
>> + *
>> + * @ofs: overlay filesystem information
>> + * @type: feature set type, compat, ro compat or incompat
>> + * @mask: new features mask want to add
>> + *
>> + * Return 0 if success, error number otherwise.
>> + */
>> +int ovl_set_upper_feature(struct ovl_fs *ofs,
>> +                         enum ovl_feature_type type,
>> +                         u64 mask)
>> +{
>> +       struct ovl_layer *upper_layer = ofs->upper_layer;
>> +       u64 *features;
>> +       int err;
>> +
>> +       if (!upper_layer)
>> +               return -EINVAL;
>> +
>> +       switch (type) {
>> +       case OVL_FEATURE_COMPAT:
>> +               features = &upper_layer->compat;
>> +               break;
>> +       case OVL_FEATURE_RO_COMPAT:
>> +               features = &upper_layer->ro_compat;
>> +               break;
>> +       case OVL_FEATURE_INCOMPAT:
>> +               features = &upper_layer->incompat;
>> +               break;
>> +       default:
>> +               return -EINVAL;
>> +       }
>> +
>> +       spin_lock(&upper_layer->lock);
>> +       if ((*features) & mask) {
>> +               spin_unlock(&upper_layer->lock);
>> +               return 0;
>> +       }
>> +
>> +       (*features) |= mask;
>> +       spin_unlock(&upper_layer->lock);
>> +
>
> Seems like you can move the above test and set into
> ovl_set_feature() and you can also use upperdir->d_lock
> and don't need to introduce a new spinlock for this.
>

Also, since there is no clear bit functionality, it is worth
testing the bit before the lock and then repeat the test under
lock if first test fails.

Thanks,
Amir.
