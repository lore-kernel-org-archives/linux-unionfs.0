Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <7a428c6b-355d-a860-b65d-3c4792caf841@gmail.com>
References: <20180322113555.47858-1-yi.zhang@huawei.com> <CAOQ4uxhSieuSYqq8W=HGE+wmKZ3=3kDkeFw7-Dz5p4nVNUjH3g@mail.gmail.com>
 <7a428c6b-355d-a860-b65d-3c4792caf841@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Sat, 24 Mar 2018 17:09:56 +0300
Message-ID: <CAOQ4uxiVTUWtCW3oMFVOK91-YfREUePjTWeCQxun2-_zaH42mg@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] ovl: implement overlay feature set
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yizhang089@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Sat, Mar 24, 2018 at 3:57 PM, zhangyi (F) <yizhang089@gmail.com> wrote:
> Hi Amir, thanks for your suggestions.
>
>
> On 2018/3/23 20:32, Amir Goldstein Wrote:
>>
>> On Thu, Mar 22, 2018 at 1:35 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
>>>
>>> Hi All,
>>>
>>> This is overlay feature set support patches, introduce incompatable,
>>> read-only compatable and incompatable feature set, store on the upper
>>> root dir via "trusted.overlay.feature_[compat|ro_compat|incompat]"
>>> xattrs.
>>>
>>
>> Hi Zhangyi!
>>
>> Thanks again for working on this.
>>
>> For the "features" feature to be complete I think one more thing is
>> required.
>>
>> I suggest to refer to the era before "features" as overlayfs on-disk
>> format v1
>> and to the era after "features" + fsck.overlayfs as on-disk format v2.
>> On-disk format v2 is identified by the existence of the features xattrs,
>> even
>> if the are empty.
>>
>> Every layer in the overlay can be of either format v1 or v2, but when you
>> run
>> fsck.overlay it will scan all layers for undeclared features and
>> "upgrade" the layers
>> to v2, by explicitly stating the empty or non-empty feature sets of the
>> layer.
>>  > So the thing that is missing IMO is -
>> a Kconfig option (say OVERLAY_FS_V2 ot OVERLAY_FS_FEATURES)
>> which defaults to n, but allows distros to opt-in for "v2 only".
>> With that config option set, overlay will refuse to mount v1 layers, or in
>> other
>> words, fsck.overlay must be run before first time mount, or a simple
>> mkfs.overlay
>> to initialize the features xattrs
>>
> Let me see, if "OVERLAY_FS_V2=y",
> - overlay will refuse to mount overlayfs which was mounted on old kernel,
> user should run fsck.overlay to check features in each layer
> and set feature xattr on the layer's root dir. So the feature xattr on one
> root dir only contain this layer's features.
> - overlay will refuse to mount overlayfs whose upper is empty(no feature
> xattr), maybe new created image and never mounted before,
> uesr should run a simple mkfs.overlay to init the feature xattr for all
> layers (maybe accept -o options to enable features).

Yes.

>
> and if "OVERLAY_FS_V2=n",
> This is what we do now in kernel, features xattr will set in the upper root
> dir according to mount options (or maybe where we set xattrs used by
> features, like redirect). And one more thing should do is init an empty
> feature xattr if user don't give any feature mount options.
>
> Right?

Yes.

>
>> Another option is to relax the requirement for declaring lower layers
>> features
>> and leave only the requirement that upper root dir is either empty or has
>> the
>> features xattrs. In any case, on first mount with an empty upper dir,
>> features xattrs
>> should be initialized. Maybe that calls for yet another Kconfig option,
>> i.e.
>> OVERLAY_FS_LOWER_V2.
>>
> Sorry, I don't follow this option.
> Do you mean this option is a sub-option of OVERLAY_FS_V2 ?
> If "OVERLAY_FS_LOWER_V2=y", refuse to mount just if there is no feature
> xattrs on the upper root dir (empty or non-empty will pass). Introduce this
> option because overlayfs only set feature xattrs on the upper layer, so
> there is no feature xattrs on the lower root dir, right or some other
> reasons ?

Right. There are use cases, like lower is read-only media where setting
feature xattr on lower is not an option.

We must support this use case.
So either we relax the requirement for feature xattr to exist in lower
and assume that no features xattr is same as empty features xattr
or we introduce a config option OVERLAY_FS_LOWER_V2 to
allow distro to make this decision.

>
> Now, the quesion is:
> The feature xattrs on the upper root dir should contain all features in the
> overlayfs(1), or features just in the upper layer(2), not sure which one is
> better ?
>
> If (1), say "this overlayfs image have index feature, not this layer", it's
> easy to do but we will meet the indexdir problem you mentioned in 2/4.
> if (2), the auto fix (e.g. fix redirect feature if we detect redirect xattr)
> becomes useless becase we cannot set feature xattr to the lower root dir, so
> need to remove this implement or give a warn to ask fsck.overlay to handle
> this. But we can distinguish features in the upper layer and lowers layer,
> maybe useful in the future.
>

Right. if detecting redirect in lower layers is important we can introduce a
different set of features (i.e. trusted.overlay.merge_XXX_features) so we
do not polute the layer specific detected features.
I think a warning and advice to run fsck is good enough for now.
patch 4/4 is still relevant for redirect that is detected in upper layer.

This is in line with the pylosophy that lower layers are allowed to be
"bare" v1 with no features, but lower layers that were once an upper
layer are expected to be converted to v2. If someone has an old overlay
with lower layers that were once v1 upper layers, then this should trigger
a warning and running fsck is the recommended remedy.

Thanks,
Amir.
