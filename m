Return-Path: <yi.zhang@huawei.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH 0/4] ovl: implement overlay feature set
Date: Thu, 22 Mar 2018 19:35:51 +0800
Message-ID: <20180322113555.47858-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi All,

This is overlay feature set support patches, introduce incompatable,
read-only compatable and incompatable feature set, store on the upper
root dir via "trusted.overlay.feature_[compat|ro_compat|incompat]"
xattrs.

This patch set base on Linux 4.16-rc6.

Patch 1: Implement feature xattr and mount check, refuse mount if no
         backward incompatible feature is detected.
Patch 2: Copy up feature xattr from the lower root dirs to the upper
         root dir to prevent feature lost.
Patch 3: Add three already support feature: redirect dir, index and
         nfs_export, enable them when user give enable mount option.
patch 4: Fix redircet feature once a redirect xattr is detected for
         the case of overlay was mounted in the old kernel.
(PS: Not sure this patch is necessary, maybe just give a warning message
and handle this by fsck.overlay? If necessary, check indexdir during
mount time is also necessary too).

zhangyi (F) (4):
  ovl: add feature set support
  ovl: update features on upper root dir from lower layers
  ovl: enable features according to mount options
  ovl: fix redirect feature for backward compatibility

 fs/overlayfs/namei.c     |  12 ++
 fs/overlayfs/overlayfs.h |  90 +++++++++++
 fs/overlayfs/ovl_entry.h |  18 +++
 fs/overlayfs/super.c     | 410 ++++++++++++++++++++++++++++++++++++++++++++++-
 4 files changed, 525 insertions(+), 5 deletions(-)

-- 
2.13.6
