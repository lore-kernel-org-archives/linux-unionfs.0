Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180322113555.47858-1-yi.zhang@huawei.com>
References: <20180322113555.47858-1-yi.zhang@huawei.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Fri, 23 Mar 2018 15:32:10 +0300
Message-ID: <CAOQ4uxhSieuSYqq8W=HGE+wmKZ3=3kDkeFw7-Dz5p4nVNUjH3g@mail.gmail.com>
Subject: Re: [RFC PATCH 0/4] ovl: implement overlay feature set
Content-Type: text/plain; charset="UTF-8"
To: "zhangyi (F)" <yi.zhang@huawei.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Mar 22, 2018 at 1:35 PM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> Hi All,
>
> This is overlay feature set support patches, introduce incompatable,
> read-only compatable and incompatable feature set, store on the upper
> root dir via "trusted.overlay.feature_[compat|ro_compat|incompat]"
> xattrs.
>

Hi Zhangyi!

Thanks again for working on this.

For the "features" feature to be complete I think one more thing is required.

I suggest to refer to the era before "features" as overlayfs on-disk format v1
and to the era after "features" + fsck.overlayfs as on-disk format v2.
On-disk format v2 is identified by the existence of the features xattrs, even
if the are empty.

Every layer in the overlay can be of either format v1 or v2, but when you run
fsck.overlay it will scan all layers for undeclared features and
"upgrade" the layers
to v2, by explicitly stating the empty or non-empty feature sets of the layer.

So the thing that is missing IMO is -
a Kconfig option (say OVERLAY_FS_V2 ot OVERLAY_FS_FEATURES)
which defaults to n, but allows distros to opt-in for "v2 only".
With that config option set, overlay will refuse to mount v1 layers, or in other
words, fsck.overlay must be run before first time mount, or a simple
mkfs.overlay
to initialize the features xattrs

Another option is to relax the requirement for declaring lower layers features
and leave only the requirement that upper root dir is either empty or has the
features xattrs. In any case, on first mount with an empty upper dir,
features xattrs
should be initialized. Maybe that calls for yet another Kconfig option, i.e.
OVERLAY_FS_LOWER_V2.


> This patch set base on Linux 4.16-rc6.
>
> Patch 1: Implement feature xattr and mount check, refuse mount if no
>          backward incompatible feature is detected.
> Patch 2: Copy up feature xattr from the lower root dirs to the upper
>          root dir to prevent feature lost.
> Patch 3: Add three already support feature: redirect dir, index and
>          nfs_export, enable them when user give enable mount option.
> patch 4: Fix redircet feature once a redirect xattr is detected for
>          the case of overlay was mounted in the old kernel.
> (PS: Not sure this patch is necessary, maybe just give a warning message
> and handle this by fsck.overlay? If necessary, check indexdir during
> mount time is also necessary too).
>
> zhangyi (F) (4):
>   ovl: add feature set support
>   ovl: update features on upper root dir from lower layers
>   ovl: enable features according to mount options
>   ovl: fix redirect feature for backward compatibility
>
>  fs/overlayfs/namei.c     |  12 ++
>  fs/overlayfs/overlayfs.h |  90 +++++++++++
>  fs/overlayfs/ovl_entry.h |  18 +++
>  fs/overlayfs/super.c     | 410 ++++++++++++++++++++++++++++++++++++++++++++++-
>  4 files changed, 525 insertions(+), 5 deletions(-)
>
> --
> 2.13.6
>
