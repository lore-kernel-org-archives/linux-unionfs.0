Return-Path: <yizhang089@gmail.com>
Return-Path: <yizhang089@gmail.com>
Subject: Re: [RFC PATCH 0/4] ovl: implement overlay feature set
References: <20180322113555.47858-1-yi.zhang@huawei.com>
 <CAOQ4uxhSieuSYqq8W=HGE+wmKZ3=3kDkeFw7-Dz5p4nVNUjH3g@mail.gmail.com>
From: "zhangyi (F)" <yizhang089@gmail.com>
Message-ID: <7a428c6b-355d-a860-b65d-3c4792caf841@gmail.com>
Date: Sat, 24 Mar 2018 20:57:07 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxhSieuSYqq8W=HGE+wmKZ3=3kDkeFw7-Dz5p4nVNUjH3g@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Amir Goldstein <amir73il@gmail.com>, "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir, thanks for your suggestions.

On 2018/3/23 20:32, Amir Goldstein Wrote:
> On Thu, Mar 22, 2018 at 1:35 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>> Hi All,
>>
>> This is overlay feature set support patches, introduce incompatable,
>> read-only compatable and incompatable feature set, store on the upper
>> root dir via "trusted.overlay.feature_[compat|ro_compat|incompat]"
>> xattrs.
>>
> 
> Hi Zhangyi!
> 
> Thanks again for working on this.
> 
> For the "features" feature to be complete I think one more thing is required.
> 
> I suggest to refer to the era before "features" as overlayfs on-disk format v1
> and to the era after "features" + fsck.overlayfs as on-disk format v2.
> On-disk format v2 is identified by the existence of the features xattrs, even
> if the are empty.
> 
> Every layer in the overlay can be of either format v1 or v2, but when you run
> fsck.overlay it will scan all layers for undeclared features and
> "upgrade" the layers
> to v2, by explicitly stating the empty or non-empty feature sets of the layer.
>  > So the thing that is missing IMO is -
> a Kconfig option (say OVERLAY_FS_V2 ot OVERLAY_FS_FEATURES)
> which defaults to n, but allows distros to opt-in for "v2 only".
> With that config option set, overlay will refuse to mount v1 layers, or in other
> words, fsck.overlay must be run before first time mount, or a simple
> mkfs.overlay
> to initialize the features xattrs
> 
Let me see, if "OVERLAY_FS_V2=y",
- overlay will refuse to mount overlayfs which was mounted on old 
kernel, user should run fsck.overlay to check features in each layer
and set feature xattr on the layer's root dir. So the feature xattr on 
one root dir only contain this layer's features.
- overlay will refuse to mount overlayfs whose upper is empty(no feature 
xattr), maybe new created image and never mounted before,
uesr should run a simple mkfs.overlay to init the feature xattr for all 
layers (maybe accept -o options to enable features).

and if "OVERLAY_FS_V2=n",
This is what we do now in kernel, features xattr will set in the upper 
root dir according to mount options (or maybe where we set xattrs used 
by features, like redirect). And one more thing should do is init an 
empty feature xattr if user don't give any feature mount options.

Right?

> Another option is to relax the requirement for declaring lower layers features
> and leave only the requirement that upper root dir is either empty or has the
> features xattrs. In any case, on first mount with an empty upper dir,
> features xattrs
> should be initialized. Maybe that calls for yet another Kconfig option, i.e.
> OVERLAY_FS_LOWER_V2.
> 
Sorry, I don't follow this option.
Do you mean this option is a sub-option of OVERLAY_FS_V2 ?
If "OVERLAY_FS_LOWER_V2=y", refuse to mount just if there is no feature 
xattrs on the upper root dir (empty or non-empty will pass). Introduce 
this option because overlayfs only set feature xattrs on the upper 
layer, so there is no feature xattrs on the lower root dir, right or 
some other reasons ?

Now, the quesion is:
The feature xattrs on the upper root dir should contain all features in 
the overlayfs(1), or features just in the upper layer(2), not sure which 
one is better ?

If (1), say "this overlayfs image have index feature, not this layer", 
it's easy to do but we will meet the indexdir problem you mentioned in 2/4.
if (2), the auto fix (e.g. fix redirect feature if we detect redirect 
xattr) becomes useless becase we cannot set feature xattr to the lower 
root dir, so need to remove this implement or give a warn to ask 
fsck.overlay to handle this. But we can distinguish features in the 
upper layer and lowers layer, maybe useful in the future.

Thanks,
Yi

> 
>> This patch set base on Linux 4.16-rc6.
>>
>> Patch 1: Implement feature xattr and mount check, refuse mount if no
>>           backward incompatible feature is detected.
>> Patch 2: Copy up feature xattr from the lower root dirs to the upper
>>           root dir to prevent feature lost.
>> Patch 3: Add three already support feature: redirect dir, index and
>>           nfs_export, enable them when user give enable mount option.
>> patch 4: Fix redircet feature once a redirect xattr is detected for
>>           the case of overlay was mounted in the old kernel.
>> (PS: Not sure this patch is necessary, maybe just give a warning message
>> and handle this by fsck.overlay? If necessary, check indexdir during
>> mount time is also necessary too).
>>
>> zhangyi (F) (4):
>>    ovl: add feature set support
>>    ovl: update features on upper root dir from lower layers
>>    ovl: enable features according to mount options
>>    ovl: fix redirect feature for backward compatibility
>>
>>   fs/overlayfs/namei.c     |  12 ++
>>   fs/overlayfs/overlayfs.h |  90 +++++++++++
>>   fs/overlayfs/ovl_entry.h |  18 +++
>>   fs/overlayfs/super.c     | 410 ++++++++++++++++++++++++++++++++++++++++++++++-
>>   4 files changed, 525 insertions(+), 5 deletions(-)
>>
>> --
>> 2.13.6
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-unionfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
