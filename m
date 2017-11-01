From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v6 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Wed,  1 Nov 2017 22:22:44 +0200
Message-ID: <1509567773-25590-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f195.google.com ([209.85.128.195]:53580 "EHLO
        mail-wr0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755206AbdKAUWM (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 1 Nov 2017 16:22:12 -0400
Received: by mail-wr0-f195.google.com with SMTP id u40so3000838wrf.10
        for <linux-unionfs@vger.kernel.org>; Wed, 01 Nov 2017 13:22:11 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

Miklos,

My trigger for fixing up the non-samefs patches is that I found out
while testing NFS export that reconnecting a dir dentry doesn't work
for non-samefs case.
I tracked the problem down to the default implementation of get_name()
in expfs.c that looks up a child inode in parent dir by d_ino.

First, I rebased NFS export patches onto Chandan's patches and tested,
but that still didn't fix the problem. I found and fixed more cases
that we need to include in impure dir cache (see 2 last patches) and
now my dir file handle unit tests [2] pass.

Changes since v5:
- Justification for moving ovl_entry.h into overlayfs.h
- Split allocate anonymous devs patch to 3 patches
- Explain why we need to return pseudo st_dev for lower
- Fix d_ino of subdirs in non-samefs setup

Besides the NFS export unit tests, I tested these patches with upstream
xfstest overlay/041 by Chandan and with unionmount test
'./run --ov --verify' that is avialble on my unionmount devel branch [3].

I asked Chandan to post fixes to his xfstests to cover the impure cases
I fixes.

Please verify that I didn't mess up authorship when posting Chandan's
patches as I did with zhangyi's patch yesterday. On my branch [1], all
the commits have correct authorship now.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-nonsamefs-v6
[2] https://github.com/amir73il/xfstests/commits/ovl-nfs-export
[3] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel

Amir Goldstein (5):
  ovl: move include of ovl_entry.h into overlayfs.h
  ovl: relax same fs constraint for constant st_ino
  ovl: update cache version of impure parent on rename
  ovl: update merge dir cache for non-samefs case
  ovl: update non-merge dir cache for non-samefs case

Chandan Rajendra (4):
  ovl: re-structure overlay lower layers in-memory
  ovl: allocate anonymous devs for lowerdirs
  ovl: return anonymous st_dev for lower inodes
  ovl: fix d_ino of current pure upper in non-samefs case

 fs/overlayfs/copy_up.c   |  1 -
 fs/overlayfs/dir.c       | 12 ++++---
 fs/overlayfs/inode.c     | 51 +++++++++++++++++++++---------
 fs/overlayfs/namei.c     | 53 ++++++++++++++++++-------------
 fs/overlayfs/overlayfs.h |  7 +++--
 fs/overlayfs/ovl_entry.h | 14 +++++++--
 fs/overlayfs/readdir.c   | 50 +++++++++++++++++++++++-------
 fs/overlayfs/super.c     | 81 ++++++++++++++++++++++++++++++------------------
 fs/overlayfs/util.c      | 17 +++++++---
 9 files changed, 191 insertions(+), 95 deletions(-)

-- 
2.7.4
