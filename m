From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v8 0/9] Overlayfs: constant st_ino/d_ino for non-samefs
Date: Tue,  7 Nov 2017 18:58:00 +0200
Message-ID: <1510073889-11657-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:57192 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752713AbdKGQ5c (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 7 Nov 2017 11:57:32 -0500
Received: by mail-wm0-f67.google.com with SMTP id z3so5318714wme.5
        for <linux-unionfs@vger.kernel.org>; Tue, 07 Nov 2017 08:57:31 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Chandan Rajendra <chandan@linux.vnet.ibm.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

Miklos,

This version provides a solution for some interesting non-samefs cases:
- All the ext* family
- Many other fs with default encode_fh
- xfs that is not huge with overlay 'xino' mount option
- tmpfs that is not on a machine with jurassic uptime with 'xino'

I tested this with Chandan's upstream overlay/041 xfstest for
consistent d_ino in non-samefs setup. Results are:
- Test passes for ext4
- Test fails for xfs
- Test fails for xfs with OVERLAY_MOUNT_OPTIONS=-oxino,
  but this is because of a test bug
- With the test bug fix available at [2] test passes
  with xfs and OVERLAY_MOUNT_OPTIONS=-oxino

All the exportfs tests also pass with these changes and
either ext4 or xfs with OVERLAY_MOUNT_OPTIONS=-oxino.

Changes since v7:
- Drop patches for building impure cache for non-samefs subdirs
- Dropped patch "update cache version of impure parent on rename"
  because it is not relevant to this series
- Remap lower inode numbers for 32bit inode file systems
- Add mount option 'xino' for opting-in to use high inode bits

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-nonsamefs-v8
[2] https://github.com/amir73il/xfstests/commits/overlayfs-devel

Amir Goldstein (8):
  ovl: move include of ovl_entry.h into overlayfs.h
  ovl: allocate anonymous devs for lowerdirs
  ovl: factor out ovl_map_dev_ino() helper
  ovl: return anonymous st_dev for lower inodes
  ovl: relax same fs constraint for constant st_ino
  ovl: constant st_ino for non-samefs with xino
  ovl: consistent d_ino for non-samefs with xino
  ovl: add support for 'xino' mount option

Chandan Rajendra (1):
  ovl: re-structure overlay lower layers in-memory

 fs/overlayfs/copy_up.c   |   1 -
 fs/overlayfs/inode.c     |  91 +++++++++++++++++++++++++--------
 fs/overlayfs/namei.c     |  42 +++++++--------
 fs/overlayfs/overlayfs.h |   9 ++--
 fs/overlayfs/ovl_entry.h |  19 ++++++-
 fs/overlayfs/readdir.c   |  49 +++++++++++++++---
 fs/overlayfs/super.c     | 129 +++++++++++++++++++++++++++++++++--------------
 fs/overlayfs/util.c      |  39 ++++++++++++--
 8 files changed, 277 insertions(+), 102 deletions(-)

-- 
2.7.4
