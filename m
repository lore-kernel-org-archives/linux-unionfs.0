From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 0/6] ovl: concurrent copy up
Date: Mon, 16 Jan 2017 19:45:59 +0200
Message-ID: <1484588765-9397-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33127 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750770AbdAPRqV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 12:46:21 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

Your comments about vfs_tmpfile() were very valuable.
This patchset looks more neat than v1.

Patches 1 is the vfs_tmpfile() helper.

Patches 2-4 implement copy up of regular file with the helper.

Patch 5 is the waitqueue patch you sent me.

Patch 6 puts the pieces together for concurrent copy up.

Tested concurrent copy up with this simple test:
$ touch /lower/{empty,4g}
$ truncate -s 4g /lower/4g
$ touch /mnt/4g &  # takes a while
$ touch /mnt/empty # exits immediately
$ touch /mnt/4g    # blocks until %1 completes and can be interrupted

Tested vfs_tmpfile() with generic/004 and generic/389.

Tested with the new overlay/021 which exercises concurrent copy up
using 8 processes on 4 directories and 4K files.

v2:
- Move more code into vfs_tmpfile() helper
- Withdraw the workdir = upperdir hack

v1:
- Initial version


Amir Goldstein (6):
  vfs: create vfs helper vfs_tmpfile()
  ovl: check if upperdir fs supports O_TMPFILE
  ovl: rearrange code in ovl_copy_up_locked()
  ovl: copy up regular file using O_TMPFILE
  ovl: introduce copy up waitqueue
  ovl: concurrent copy up of regular files

 fs/namei.c               | 66 +++++++++++++++++++++++-------------
 fs/overlayfs/copy_up.c   | 88 +++++++++++++++++++++++++++++++++++-------------
 fs/overlayfs/overlayfs.h | 11 ++++++
 fs/overlayfs/ovl_entry.h |  3 ++
 fs/overlayfs/super.c     | 11 ++++++
 fs/overlayfs/util.c      | 30 +++++++++++++++++
 include/linux/fs.h       |  3 ++
 7 files changed, 165 insertions(+), 47 deletions(-)

-- 
2.7.4
