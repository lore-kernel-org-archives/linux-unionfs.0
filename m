From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/5] ovl: constant inode numbers (cont.)
Date: Thu,  1 Jun 2017 12:02:54 +0300
Message-ID: <1496307779-2766-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33432 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751093AbdFAJCs (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Jun 2017 05:02:48 -0400
Received: by mail-wm0-f66.google.com with SMTP id b84so9580447wmh.0
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Jun 2017 02:02:48 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, linux-unionfs@vger.kernel.org

Miklos,

This series covers many of the constant inode number leftovers from v4.12.

Current status is:
- For non-hardlinks, st_ino is constant and consistent with d_ino
- For samefs and for non-dir, st_ino/d_ino is also persistent
- For samefs, st_dev;st_ino is also system-wide unique

The remaining leftovers:
- Constant st_ino/d_ino for hardlinks (WIP by me)
- System-wide unique st_dev;st_ino for non-samefs (WIP by Chandan?)

Tested constant and consistent d_ino with improved xfstest overlay/017,
already upstream, which currently fails only on the hardlink copy up test.

v3:
- Relax same fs contrains from v4.12
- Non "impure" dir optimizations

v2:
- Lookup overlay entry with lookup_one_len_noperm()

v1:
- Resurect Miklos's constant d_ino POC
- Lookup overlay entry with lookup_one_len()

Amir Goldstein (5):
  ovl: relax same fs constrain for ovl_check_origin()
  ovl: relax same fs constrain for constant st_ino
  vfs: factor out lookup_one_len_init()
  vfs: add helper lookup_one_len_noperm()
  ovl: consistent st_ino/d_ino

 fs/namei.c               | 117 +++++++++++++++++++++++------------------
 fs/overlayfs/inode.c     |  32 +++++++-----
 fs/overlayfs/namei.c     |  50 +++++++++++-------
 fs/overlayfs/overlayfs.h |   2 +-
 fs/overlayfs/readdir.c   | 133 ++++++++++++++++++++++++++++++++++++++++++++---
 include/linux/namei.h    |   1 +
 6 files changed, 244 insertions(+), 91 deletions(-)

-- 
2.7.4
