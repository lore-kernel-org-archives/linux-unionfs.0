From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v7 0/8] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Thu,  2 Nov 2017 22:38:03 +0200
Message-ID: <1509655091-13630-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f194.google.com ([209.85.128.194]:49843 "EHLO
        mail-wr0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934115AbdKBUh2 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 2 Nov 2017 16:37:28 -0400
Received: by mail-wr0-f194.google.com with SMTP id g90so724218wrd.6
        for <linux-unionfs@vger.kernel.org>; Thu, 02 Nov 2017 13:37:28 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

Miklos,

This version is cleaner and better tested.
I have a WIP for xfstest for the new cases, will clean it up and post
it later.

Changes since v6:
- Reorganize d_ino patches to: 1. merge dir cache and 2. impure dir cache
- Explain better why we need to return pseudo st_dev for lower
- Fix crash on building impure cache for pure lower
- Reset cache on change of dir from is_real to !is_real

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-nonsamefs-v7

Amir Goldstein (5):
  ovl: move include of ovl_entry.h into overlayfs.h
  ovl: relax same fs constraint for constant st_ino
  ovl: recalc d_ino for dir cache in non-samefs case
  ovl: update cache version of impure parent on rename
  ovl: ovl_iterate_real() for all pure upper/lower in non-samefs case

Chandan Rajendra (3):
  ovl: re-structure overlay lower layers in-memory
  ovl: allocate anonymous devs for lowerdirs
  ovl: return anonymous st_dev for lower inodes

 fs/overlayfs/copy_up.c   |  1 -
 fs/overlayfs/dir.c       | 16 ++++++----
 fs/overlayfs/inode.c     | 51 +++++++++++++++++++++---------
 fs/overlayfs/namei.c     | 53 ++++++++++++++++++-------------
 fs/overlayfs/overlayfs.h |  7 +++--
 fs/overlayfs/ovl_entry.h | 14 +++++++--
 fs/overlayfs/readdir.c   | 64 +++++++++++++++++++++++++++-----------
 fs/overlayfs/super.c     | 81 ++++++++++++++++++++++++++++++------------------
 fs/overlayfs/util.c      | 17 +++++++---
 9 files changed, 202 insertions(+), 102 deletions(-)

-- 
2.7.4
