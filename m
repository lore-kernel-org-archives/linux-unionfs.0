Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:39555 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731500AbeGaLEg (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 31 Jul 2018 07:04:36 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 1BB47F1FBB8A7
        for <linux-unionfs@vger.kernel.org>; Tue, 31 Jul 2018 17:25:08 +0800 (CST)
From: "zhangyi (F)" <yi.zhang@huawei.com>
Subject: [RFC PATCH v2 0/9] ovl: add feature set support
Date: Tue, 31 Jul 2018 17:37:18 +0800
Message-ID: <20180731093727.26855-1-yi.zhang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-unionfs-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: miklos@szeredi.hu, amir73il@gmail.com, yi.zhang@huawei.com, miaoxie@huawei.com, yangerkun@huawei.com
List-ID: <linux-unionfs@vger.kernel.org>

Hi all,

These patch set is the second version to add feature set support for
overlayfs, have already been handle most suggestions from Amir in the
last iteration. It do the following things.

- Introduce compatible, read-only compatible and incompatible these
  three kinds of feature set which indicates the features in one layer
  (not the whole overlay image), save as __be64 bit mask on each layer's
  root directory via a "trusted.overlay.featre" xattr.
- Kernel will refuse to mount if unknown incompatible feature are found
  in any one layer, and refuse to mount read-write if unknown
  ro-compatible feature are found in the upper layer.
- Set feature bitset when redirect dir xattr, index and nfs_export
  feature were set or enabled.
- Refer the layer which have feature set xattr as on-disk format v2,
  and the layer that don't have as on-disk format v1.
- Introduce two Kconfig options (OVERLAY_FS_V2 and OVERLAY_FS_UPPER_V2)
  and the counterpart module and mount options. when OVERLAY_FS_V2 (or
  the counterpart module and mount option) is set, on-disk format v2
  becomes necessary on all layers, when OVERLAY_FS_UPPER_V2 is set,
  on-disk format v2 is only necessary on the upper layer.
- Check redirect dir feature when redirect xattr is found on the
  underlying directory, fsck.overlay is required if redirect dir feature
  missing.

This patch set base on Linux-4.18-rc6 and is just request for comments,
any comment is helpful, does not yet take care of the upcoming metadata
copy-up feature and update the document, I can handle these in the next
iteration.


The counterpart fsck.overlay and mkfs.overlay program available here[*],
You may want to review it together. From 8b540194 "fsck.overlay: factor
out common header part from fsck" to the latest one d22ebd9a2
"mkfs.overlay: update README and turn on mkfs program", total 29 patches.
I can post the tools patch set if you want.

The fsck.overlay do the following:
- Add "overlayfs_v2=<off/upper/on>" fsck option as same as mount option.
- If "overlayfs_v2=off", fsck will ask user to create a new feature set
  xattr for on-disk format v1 layers, and will add the missing feature
  bit, but these are not required (except fix the corrupt feature set
  xattr).
- If "overlayfs_v2=on", consistent feature set xattr are required for
  all layers, fsck will convert layer format v1 to v2 and ensure the
  consistency of the feature set on all layers.
- If "overlayfs_v2=upper", release the requirement of feature set xattr
  on lower layers, but fsck will still warn if unrepaired corrupt
  feature xattr left over on the read-only lower layer.
- Display features to human readable string.

The mkfs.overlay do the following:
- Create new feature set xattr for each underlying layer.
- Do some basic check of the underlying layers, will refuse to make a
  new overlay iamge if an old overlayfs already existed or any one layer
  is mounted.
- Accept redirect dir, index and nfs_export feature options, and set
  the corresponding feature bitset.
- Use for new underlying layers only, doesn't give "force" options.

Thanks,
Yi.

------------------

[*] https://github.com/hisilicon/overlayfs-progs/commits/feature-set


Changes since v1:
- Feature set xattr contains features in one layer instead of the whole
  overlay image.
- Use bitset to store features instead of readable string.
- Compress all three kind of feature sets into one feature xattr instead
  of three xattrs.
- Introduce on-disk format v2 which layer's feature set xatte becomes
  necessary and add two Kconfig options, two module options and two
  mount options to enable the requirement of on-disk format v2.
- Do not auto fix redirect dir feature when redirect xattr was detected
  on directory, just give a warning message to teach user to run fsck.
- Set redirect dir feature when overlayfs set redirect xattr on
  directory.


zhangyi (F) (9):
  ovl: store ovl upper root path in ovl_fs
  ovl: read feature set from each layer's root dir
  ovl: check file system features can be mounted properly
  ovl: add helper funcs to set upper layer feature set
  ovl: add redirect dir feature when set redirect xattr to dir
  ovl: add index feature if index dir exists
  ovl: add nfs_export feature when nfs_export is enabled
  ovl: force mount underlying layers which have feature sets
  ovl: check redirect_dir feature when detect redirect xattr on dir

 fs/overlayfs/Kconfig     |  40 +++++++
 fs/overlayfs/Makefile    |   2 +-
 fs/overlayfs/dir.c       |  11 ++
 fs/overlayfs/export.c    |  12 +-
 fs/overlayfs/feature.c   | 298 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/inode.c     |   4 +-
 fs/overlayfs/namei.c     |  35 +++++-
 fs/overlayfs/overlayfs.h |  99 ++++++++++++++++
 fs/overlayfs/ovl_entry.h |  23 +++-
 fs/overlayfs/readdir.c   |   2 +-
 fs/overlayfs/super.c     | 118 ++++++++++++++++---
 fs/overlayfs/util.c      |  10 +-
 12 files changed, 617 insertions(+), 37 deletions(-)
 create mode 100644 fs/overlayfs/feature.c

-- 
2.13.6

