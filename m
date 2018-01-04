From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 00/23] Overlayfs consistency verification with full index
Date: Thu,  4 Jan 2018 18:39:55 +0200
Message-ID: <1515084018-25134-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:44726 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752515AbeADQj3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 4 Jan 2018 11:39:29 -0500
Received: by mail-wr0-f194.google.com with SMTP id l41so2010187wre.11
        for <linux-unionfs@vger.kernel.org>; Thu, 04 Jan 2018 08:39:28 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Miklos,

This is the 2nd revision of the prep patch series for NFS export.
I am posing the prep patches only to overlayfs list and will post
NFS export implementation to fsdevel.

In the 1st revision the mount option 'index=all' was used to request
a full index. This revision re-brands the feature as 'verify=on',
including a config/module option and documentation that explains the
benefits of full index (i.e. avoid multiple redirect).

The prep series goes on a bit beyond implementation of 'verify=on'.
Patches 17-23 create the whiteout index entries and make some more
changes that are prerequisites for NFS export implementation.

To sanity test full index, I have implemented _overlay_check_fs()
helper for xfstests [3], which is a very basic "fsck" of the index dir.
This helper is called at the end of each overlay xfstest to verify the
sanity of the index entries. There is also a new test to verify multiple
redirect dir is detected on lookup.

The series is based on top of my ovl-fixes [1] branch, which includes
some patches I had already posted. The complete NFS export work is
available here [2].

Amir.

[1] https://github.com/amir73il/linux/commits/ovl-fixes
[2] https://github.com/amir73il/linux/commits/ovl-nfs-export-v2
[3] https://github.com/amir73il/xfstests/commits/ovl-index-all

Amir Goldstein (23):
  ovl: disable index when no xattr support
  ovl: ignore index mount option when no upper layer
  ovl: store layer index in ovl_layer
  ovl: factor out ovl_check_origin_fh()
  ovl: pass ovl_layer array to ovl_check_origin_fh()
  ovl: add support for "verify" feature
  ovl: verify stored origin fh matches lower dir
  ovl: unbless lower st_ino of files under unverified redirected dir
  ovl: lookup index for directories
  ovl: verify whiteout index entries on mount
  ovl: verify directory index entries on mount
  ovl: cleanup temp index entries
  ovl: create ovl_need_index() helper
  ovl: index all files on copy up with 'verify=on'
  ovl: index directories on copy up with 'verify=on'
  ovl: cleanup dir index when dir nlink drops to zero
  ovl: whiteout index when union nlink drops to zero
  ovl: whiteout orphan index entries on mount
  ovl: factor out ovl_get_index_fh() helper
  ovl: do not pass overlay dentry to ovl_get_inode()
  ovl: grab i_count reference of lower inode
  ovl: use d_splice_alias() in place of d_add() in lookup
  ovl: copy up of disconnected dentries

 Documentation/filesystems/overlayfs.txt |  16 ++
 fs/dcache.c                             |   1 +
 fs/overlayfs/Kconfig                    |  18 ++
 fs/overlayfs/copy_up.c                  | 179 ++++++++++---
 fs/overlayfs/dir.c                      |  58 +++--
 fs/overlayfs/inode.c                    |  38 ++-
 fs/overlayfs/namei.c                    | 442 +++++++++++++++++++++++---------
 fs/overlayfs/overlayfs.h                |  29 ++-
 fs/overlayfs/ovl_entry.h                |   3 +
 fs/overlayfs/readdir.c                  |  37 ++-
 fs/overlayfs/super.c                    |  74 ++++--
 fs/overlayfs/util.c                     |  94 +++++--
 12 files changed, 752 insertions(+), 237 deletions(-)

-- 
2.7.4
