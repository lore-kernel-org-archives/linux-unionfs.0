From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/2] ovl: fix IS_APPEND() checks
Date: Sat,  8 Apr 2017 14:49:05 +0300
Message-ID: <1491652147-19794-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35431 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751841AbdDHLtB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sat, 8 Apr 2017 07:49:01 -0400
Received: by mail-wm0-f66.google.com with SMTP id d79so2191145wmi.2
        for <linux-unionfs@vger.kernel.org>; Sat, 08 Apr 2017 04:49:01 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-unionfs@vger.kernel.org

Miklos,

This series fixes the append-only violations found by the new
xfstest overlay/030.

I addressed your comments on v2 and removed the patch to vfs_truncate()
because d_real() already takes cares of IS_APPEND().

Amir.

v3:
- address comments by Miklos
- discard unneeded patch to vfs_truncate()

v2:
- move open check to ovl_d_real()
- discard wrong patch to file_start_write() in ftruncate()

v1:
- fix checks in [f]truncate and vfs_open()

Amir Goldstein (2):
  vfs: ftruncate check IS_APPEND() on real upper inode
  ovl: check IS_APPEND() on real upper inode

 fs/open.c            |  3 ++-
 fs/overlayfs/super.c | 28 +++++++++++++++++++++++++---
 2 files changed, 27 insertions(+), 4 deletions(-)

-- 
2.7.4
