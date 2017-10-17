From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/7] Implement overlayfs verify_dir mount option
Date: Tue, 17 Oct 2017 18:23:46 +0300
Message-ID: <1508253833-9866-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:54212 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S965102AbdJQPXW (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 17 Oct 2017 11:23:22 -0400
Received: by mail-wm0-f66.google.com with SMTP id q132so4700732wmd.2
        for <linux-unionfs@vger.kernel.org>; Tue, 17 Oct 2017 08:23:21 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org, zhangyi <yi.zhang@huawei.com>

Miklos,

This is the first of two prep patch sets [1][2] for NFS export [3].
NFS export is enabled with the 'verify_dir' and 'index=all'
mount options.

The requirement for 'verify_dir' can be relaxed if we attach
generation numbers to index entries as you suggested, but
this was not implemented for first version of NFS export.

The first two patches in this series, one from zhangyi and
one from me are not directly related to 'verify_dir', but
they make sense in this context, because 'verify_dir' may
refuse to follow to lower dir and leave a pure upper dir
with ORIGIN and whiteouts.
These two patches have been around for a while and already
have a merged xfstest to verify them (overlay/031).

The last two patches add the actual verification of lower
dir. They have been on my development branch for a few cycles
already and the feature is being exercised with snapshots test.

[1] https://github.com/amir73il/linux/commits/ovl-verify-dir
[2] https://github.com/amir73il/linux/commits/ovl-index-all
[3] https://github.com/amir73il/linux/commits/ovl-nfs-export

Amir Goldstein (7):
  ovl: fix rmdir problem on origin dir
  ovl: no direct iteration for dir with copy up origin
  ovl: remove unneeded arg from ovl_verify_origin()
  ovl: disable redirect_dir and index when no xattr support
  ovl: ignore redirect_dir and index when no upper layer
  ovl: add support for verify_dir mount option
  ovl: follow decoded origin file handle of merge dir

 Documentation/filesystems/overlayfs.txt | 20 ++++++++++
 fs/dcache.c                             |  1 +
 fs/overlayfs/dir.c                      | 21 +++++++---
 fs/overlayfs/namei.c                    | 60 +++++++++++++++++++++++++----
 fs/overlayfs/overlayfs.h                |  8 ++--
 fs/overlayfs/ovl_entry.h                |  1 +
 fs/overlayfs/readdir.c                  | 59 ++++++++++++++++++++++------
 fs/overlayfs/super.c                    | 68 +++++++++++++++++++++++----------
 fs/overlayfs/util.c                     | 20 ++++++++++
 9 files changed, 209 insertions(+), 49 deletions(-)

-- 
2.7.4
