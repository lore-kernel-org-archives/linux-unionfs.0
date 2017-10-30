From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v5 0/4] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Mon, 30 Oct 2017 22:27:23 +0200
Message-ID: <1509395247-15180-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:54426 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751608AbdJ3U0r (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 30 Oct 2017 16:26:47 -0400
Received: by mail-wr0-f193.google.com with SMTP id o44so13884244wrf.11
        for <linux-unionfs@vger.kernel.org>; Mon, 30 Oct 2017 13:26:46 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, zhangyi <yi.zhang@huawei.com>, linux-unionfs@vger.kernel.org

Miklos,

I rebased and pushed a new version of Chandan's patches to my
overlayfs devel branch [1].

I am posting this for review here as v5, although I lost count on the real
revision number.

Beyond rebase, cleanup and checkpatch warning fixes I made the following
cosmetic modifications since previous version:

1. s/struct ovl_lower_mnt/struct ovl_layer
2. s/struct ovl_lower/struct ovl_path
3. s/ofs->lower_mnt/ofs->lower_layers
4. ovl_find_layer() mini helper for ovl_lookup()
5. split cleanup patch of include ovl_entry.h

The cosmetic changes make the struct member variables names .layer and
.lower_layers consistent with their type (struct ovl_layer).
The type name struct ovl_path fits better IMO to the argument list of
ovl_check_origin() which will later be used to check "upper origin"
as well (index=all patches).

I tested these patches with upstream xfstest overlay/041 by Chandan
and with unionmount test './run --ov --verify' that is avialble on my
unionmount devel branch [2].

My overlayfs devel branch [1] contains also the patches by Zhangyi
for not exposing whiteouts when lower dir is gone missing. I tested these
changes with upstream xfstest overlay/031 by Zhangyi.

Please consider the patches from my devel branch [1] for v4.15.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/overlayfs-devel
[2] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel

Amir Goldstein (2):
  ovl: move include of ovl_entry.h into overlayfs.h
  ovl: relax same fs constrain for constant st_ino

Chandan Rajendra (2):
  ovl: allocate anonymous devs for lowerdirs
  ovl: relax same fs constraint for constant d_ino

 fs/overlayfs/copy_up.c   |  1 -
 fs/overlayfs/inode.c     | 51 +++++++++++++++++++++---------
 fs/overlayfs/namei.c     | 53 ++++++++++++++++++-------------
 fs/overlayfs/overlayfs.h |  5 +--
 fs/overlayfs/ovl_entry.h | 14 +++++++--
 fs/overlayfs/readdir.c   | 24 +++++++-------
 fs/overlayfs/super.c     | 81 ++++++++++++++++++++++++++++++------------------
 fs/overlayfs/util.c      |  8 +++--
 8 files changed, 152 insertions(+), 85 deletions(-)

-- 
2.7.4
