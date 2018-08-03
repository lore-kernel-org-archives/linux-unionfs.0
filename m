Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10223 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727387AbeHCOHs (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Aug 2018 10:07:48 -0400
Received: from DGGEMS408-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 723B2D8CAC302
        for <linux-unionfs@vger.kernel.org>; Fri,  3 Aug 2018 20:11:42 +0800 (CST)
Subject: Re: [RFC PATCH v2 2/9] ovl: read feature set from each layer's root
 dir
References: <20180731093727.26855-1-yi.zhang@huawei.com>
 <20180731093727.26855-3-yi.zhang@huawei.com>
 <CAOQ4uxhchdsSudHSnDOQ=yfUoAyUffgOj6-y5CgNc5idMkWuCw@mail.gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <efbcd164-4ab1-cc49-2944-3b441f05fa4c@huawei.com>
Date: Fri, 3 Aug 2018 20:11:36 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhchdsSudHSnDOQ=yfUoAyUffgOj6-y5CgNc5idMkWuCw@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/8/1 15:44, Amir Goldstein Wrote:
> On Tue, Jul 31, 2018 at 12:37 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> In order to distinguish the backward compatible and backward
>> incompatible features in overlay filesystem, we introduce compatible,
>> read-only compatible and incompatible these three kinds of features,
>> store them as __be64 bit mask on each layer's root directory via
>> "trusted.overlay.feature" xattr, which contains the features of this
>> layer.
>>
>> This patch just read feature bitsets from each layer, doesn't add any
>> already known features and doesn't yet use the feature bitsets.
>>
>> Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
>> Suggested-by: Miklos Szeredi <miklos@szeredi.hu>
>> Suggested-by: Amir Goldstein <amir73il@gmail.com>
>> ---
[..]
>> +
>> +/*
>> + * Get overlay features from the layer's root dir.
>> + *
>> + * @realroot: real root dir dentry
>> + *
>> + * Return on-disk overlay feature struct if success, NULL if no feature
>> + * and error ptr if error.
>> + */
>> +static struct ovl_d_feature *ovl_get_feature(struct dentry *realroot)
> 
> It may be more appropriate to use plural (features) for function, struct
> and xattr name. Don't feel so strongly about it.
> 

Will do.

>> +{
>> +       struct ovl_d_feature *odf = NULL;
>> +       int res;
>> +
>> +       res = vfs_getxattr(realroot, OVL_XATTR_FEATURE, NULL, 0);
>> +       if (res <= 0) {
>> +               if (res == -EOPNOTSUPP || res == -ENODATA)
>> +                       return NULL;
>> +               goto fail;
>> +       }
>> +
>> +       odf = kzalloc(res, GFP_KERNEL);
> 
> Don't really see the point in allocating this struct. You can keep the
> features buffer on the stack and check res != sizeof(struct ovl_d_feature)
> before reading into the buffer.
> 

Will do.

>> +       if (!odf)
>> +               return ERR_PTR(-ENOMEM);
>> +
>> +       res = vfs_getxattr(realroot, OVL_XATTR_FEATURE, odf, res);
>> +       if (res < 0)
>> +               goto fail;
>> +
>> +       /* Check validity */
>> +       if (res < sizeof(struct ovl_d_feature)) {
>> +               res = -EINVAL;
>> +               goto invalid;
>> +       }
>> +       if (odf->magic != OVL_FEATURE_MAGIC) {
>> +               res = -EINVAL;
>> +               goto invalid;
>> +       }
>> +
>> +       return odf;
>> +out:
>> +       kfree(odf);
>> +       return ERR_PTR(res);
>> +fail:
>> +       pr_err("overlayfs: failed to get features (%i)\n", res);
>> +       goto out;
>> +invalid:
>> +       pr_err("overlayfs: invalid features (%*phN)\n", res, odf);
>> +       goto out;
>> +}
>> +
>> +/*
>> + * Get features from each underlying root dir.
>> + *
>> + * @ofs: overlay filesystem information
>> + * @oe: overlay lower stack
>> + *
>> + * Return 0 if success, errno otherwise.
>> + */
>> +int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe)
>> +{
>> +       struct ovl_layer *upper_layer = ofs->upper_layer;
>> +       struct dentry *upper = ofs->upperdir;
>> +       struct ovl_d_feature *odf;
>> +       int i;
>> +
>> +       /* Get features from the upper root dir */
>> +       if (upper_layer) {
>> +               odf = ovl_get_feature(upper);
>> +               if (IS_ERR(odf))
>> +                       return PTR_ERR(odf);
>> +
>> +               if (odf) {
>> +                       upper_layer->compat = be64_to_cpu(odf->compat);
>> +                       upper_layer->ro_compat = be64_to_cpu(odf->ro_compat);
>> +                       upper_layer->incompat = be64_to_cpu(odf->incompat);
>> +                       upper_layer->feature = true;
>> +                       kfree(odf);
>> +               } else {
>> +                       upper_layer->feature = false;
>> +               }
> 
> Please pass ovl_layer * into ovl_get_feature[s]() and do all this
> inside the helper - it is repeated for lower layers.
> 

Will do.

>> +       }
>> +
>> +       /* Get features from each lower's root dir */
>> +       for (i = 0; i < oe->numlower; i++) {
>> +               struct ovl_path *lowerpath = &oe->lowerstack[i];
>> +               struct ovl_layer *lower_layer = &ofs->lower_layers[i];
>> +
>> +               odf = ovl_get_feature(lowerpath->dentry);
>> +               if (IS_ERR(odf))
>> +                       return PTR_ERR(odf);
>> +
>> +               if (!odf) {
>> +                       lower_layer->feature = false;
>> +                       continue;
>> +               }
>> +
>> +               lower_layer->compat = be64_to_cpu(odf->compat);
>> +               lower_layer->ro_compat = be64_to_cpu(odf->ro_compat);
>> +               lower_layer->incompat = be64_to_cpu(odf->incompat);
>> +               lower_layer->feature = true;
>> +               kfree(odf);
>> +       }
>> +
>> +       return 0;
>> +}
>> diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>> index 7538b9b56237..745f3b89a99e 100644
>> --- a/fs/overlayfs/overlayfs.h
>> +++ b/fs/overlayfs/overlayfs.h
>> @@ -28,6 +28,7 @@ enum ovl_path_type {
>>  #define OVL_XATTR_IMPURE OVL_XATTR_PREFIX "impure"
>>  #define OVL_XATTR_NLINK OVL_XATTR_PREFIX "nlink"
>>  #define OVL_XATTR_UPPER OVL_XATTR_PREFIX "upper"
>> +#define OVL_XATTR_FEATURE OVL_XATTR_PREFIX "feature"
>>
>>  enum ovl_inode_flag {
>>         /* Pure upper dir that may contain non pure upper entries */
>> @@ -43,6 +44,17 @@ enum ovl_entry_flag {
>>         OVL_E_CONNECTED,
>>  };
>>
>> +/* Features */
>> +#define OVL_FEATURE_MAGIC 0xfe
>> +
>> +/* On-disk format of overlay layer features */
>> +struct ovl_d_feature {
> u8 version; (it may be 2 if we want to relate to ovl format v2)
> 

IIUC, we refer the layer contains this feature set xattr is format v2,
and the layer doesn't contains is format v1. So why we need this "version"
parameter, always 2 when we set feature set xattr and prepare for the
future when we want to change this sturcture ?

>> +       u8 magic;               /* 0xfe */
> 
> u16 pad; (just for semantically defining the on-disk format zero padding)
> 
>> +       __be64 compat;          /* compatible features */
>> +       __be64 ro_compat;       /* read-only compatible features */
>> +       __be64 incompat;        /* incompatible features */
>> +} __packed;
>> +
>>  /*
>>   * The tuple (fh,uuid) is a universal unique identifier for a copy up origin,
>>   * where:
>> @@ -379,3 +391,6 @@ int ovl_set_origin(struct dentry *dentry, struct dentry *lower,
>>
>>  /* export.c */
>>  extern const struct export_operations ovl_export_operations;
>> +
>> +/* feature.c */
>> +int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe);
>> diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>> index 38ff6689a293..b1b6627f3350 100644
>> --- a/fs/overlayfs/ovl_entry.h
>> +++ b/fs/overlayfs/ovl_entry.h
>> @@ -34,6 +34,11 @@ struct ovl_layer {
>>         int idx;
>>         /* One fsid per unique underlying sb (upper fsid == 0) */
>>         int fsid;
>> +       /* Features of this layer */
>> +       u64 compat;
>> +       u64 ro_compat;
>> +       u64 incompat;
>> +       bool feature;
> 
> Not that size of ovl_layer matters so much, but technically, the
> boolean 'feature' can be represented with a single compat feature bit
> if we define that the on-disk format is never initialized with all zeros,
> so checking !layer->feature is equivalent to checking !layer->compat.
> 
> For example the feature OVL_FEATURE_COMPAT_V2
> will always be set if features xattrs exists.
> I write 'compat' only because old kernel *will* mount an overlay
> with this feature set (not knowing to check it), but fsck.overlay
> should not have any "official" version that does not check the
> "V2" feature.
> 
> I did not yet look at all the patches to determine if the 'feature'
> boolean is useful by itself, so not ruling it out completely.
> 
Sounds good, will do.

Thanks,
Yi.

