Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:10229 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726982AbeHFDV4 (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 5 Aug 2018 23:21:56 -0400
Subject: Re: [RFC PATCH v2 8/9] ovl: force mount underlying layers which have
 feature sets
References: <20180731093727.26855-1-yi.zhang@huawei.com>
 <20180731093727.26855-9-yi.zhang@huawei.com>
 <CAOQ4uxgZcwxENyf5STfNgL6juLoHvOBnWkORpifp0pv04oi8Ww@mail.gmail.com>
 <0b7e233d-2557-5391-3331-186e97ee2120@huawei.com>
 <CAOQ4uxjxY1Urjy2fUEkV24ZfxbDjAu1vkJcERNc_7uZVmJ+2YA@mail.gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <8f1be586-ac8a-2428-bb5e-76b5be62c076@huawei.com>
Date: Mon, 6 Aug 2018 09:15:06 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxjxY1Urjy2fUEkV24ZfxbDjAu1vkJcERNc_7uZVmJ+2YA@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On 2018/8/4 5:33, Amir Goldstein Wrote:
> On Aug 3, 2018 1:25 PM, "zhangyi (F)" <yi.zhang@huawei.com <mailto:yi.zhang@huawei.com>> wrote:
[..]
> 
>     Now, I think it's better to show the background and summarize all the 5 introductions,
>     9 situations and the corresponding process logic, please give a quick look and comment
>     if something is not fine.
> 
>     0. Background:
>     Current overlayfs cannot detect unknown incompatible features. It is dangerous if we
>     mount an overlay image which contains such features on the old kernel and then mount on
>     the new kernel again, because the old kernel may corrupt the incompatible feature objects.
>     At the same time, the fsck.overlay program also cannot detect unknown features, it is
>     dangerous too if we use old fsck.overlay to check and repair the overlayfs which contains
>     unkown features.
> 
>     Now, we know two incompatible features (redirect dir and metadata copyup) and two read-only
>     compatible features (index and nfs_export), and there may be more incompatible features
>     in the future. So, in order to do compatibility checking accurately, we it's better to
>     introduce feature set as many other disk filesystems. But the overlayfs doesn't has
>     superblock, so we plan to save feature bitset as "trusted.overlay.feature" xattr valued
>     a feature structure, which use _be64 to present each layer's feature set.
> 
>     BTW, In order to let the feature set xattr backward compatible, we cannot require the
>     feature set directly, so we refer the old layer on-disk format v1 and new layer contains
>     fature set xattr on-disk format v2, and introduce two Kconfig options and the counterpart
>     module & mount options to handle this, see below for detail.
> 
>     1. Introductions:
>     1) Two on-disk formats.
>     - Format v1: the layer of overlayfs which doesn't has feature set xattr,
>     - Format v2: the layer of overlayfs which has feature set xattr.
> 
>     Note both on-disk format v1 & v2 indicate the layer's format, not the whole overlay image.
> 
>     2) Three options indicated by Kconfig/module/mount options.
>     - OVERLAY_FS_V1: all layers can be either on-disk format v1 or v2.
>     - OVERLAY_FS_UPPER_V2: the upper layer should be v2 and the lower layers can be either v1 or v2.
>     - OVERLAY_FS_V2: all layers should be on-disk format v2.
> 
> 
>     2. Situations: ("-" means this layer doesn't has feature xattr, "+" means has feature xattr)
> 
>                        lowers(-),upper(-）  lowers(-),upper (+)   lowers(+),upper(+)
>     OVERLAYFS_V1               (1)                 (2)                   (3)
>     OVERLAYFS_UPPER_V2         (4)                 (5)                   (6)
>     OVERLAYFS_V2               (7)                 (8)                   (9)
> 
>     (1) Allow to mount, do all things as current kernel, besides initiate feature set
>         xattr when redirect dir xattr was set, index dir exists, nfs_export enabled and
>         metadata xattr was set or redirect xattr was set to file. But I think create an
>         empty feature xattr (or only have compatible "feature set" feature bit) is not
>         necessary(*).
>     (2) The same as (1) above, but also check features bitset in the upper is compatible
>         for mounting operation, will refuse to mount if not.
>     (3) The same as (2) above, but also check feature bitset in lower layers.
>     (4) Refuse to mount, mkfs.overlay is required for the new underlying layers and
>         fsck.overlay is required for the layers which had already been mounted, to initiate
>         feature set xattr. fsck.overlay can also use to set feature xattr for the new
>         underlying layers, but mkfs.overlay is recommend because it can aviod unnecessary
>         consistency check.
>     (5) Allow to mount, and will check feature bitset in the upper layer and add feature
>         bit as (1) does.
>     (6) The same as (5) above, and also check feature bitset in lower layers.
>     (7) Refuse to mount, need mkfs.overlay and fsck.overlay to initiate feature set xattr
>         for all layers, if lower layer is real read-only and cannot change to format v2,
>         suggest to mount with OVERLAY_FS_UPPER_V2.
>     (8) Refuse to mount too, the same as (7) does.
>     (9) Allow to mount, the same as (6) does.
> 
>     Do you think these implementations is OK, any suggestions?
> 
> 
> Looks good to me expect for comment on empty feature set below.
> 
> 
>     (*) Two reasons: 1) an "empty" feature xattr is useless for compatibility checking when
>         OVERLAY_FS_V1, 2) user need to run fsck.overlay before change to OVERLAY_FS_*_v2
>         form OVERLAY_FS_V1 becasue the feature set xattr created by OVERLAYFS_V1 may be
>         inconsistent, fsck will create an consistent feature set xattr. So I think doesn't
>         need to create an "empty" feature xattr.
> 
> 
> I think an empty feature set *is* usefull in one situation.
> Kernel can do a quick check if upper root dir is empty. In that case only, kernel is allowed to set an empty feature set which is really consistent without running mkfs nor fsck.
> 
> This approach may not be so safe but is gives a pretty good trade off of usability imo.
> Existing container run times don't need to change implementation of overlay image creation and distro os defaults could still be changed to OVERLAY_FS_UPPER_V2.
> 
> Changing default to OVERLAY_FS_V2 requires runtime to use overlayfs progs.
> 

Make sense, will do.

Cheers,
Yi.

