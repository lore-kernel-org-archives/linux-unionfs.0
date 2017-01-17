From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v4 0/6] ovl: concurrent copy up
Date: Tue, 17 Jan 2017 06:34:51 +0200
Message-ID: <1484627697-17262-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:34474 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751127AbdAQEg0 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 16 Jan 2017 23:36:26 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

Here is v4. Only change from v3 is in patch 1.
Since I only saw your replies for patches 1,2,6,
I assume the the rest are ok?

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

v4:
- Remove redundant dir argument from vfs_tmpfile()

v3:
- Move more code into vfs_tmpfile() helper
- Address Miklos' review comments on patch 6

v2:
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

 fs/namei.c               | 68 +++++++++++++++++++++++--------------
 fs/overlayfs/copy_up.c   | 88 +++++++++++++++++++++++++++++++++++-------------
 fs/overlayfs/overlayfs.h | 11 ++++++
 fs/overlayfs/ovl_entry.h |  3 ++
 fs/overlayfs/super.c     | 11 ++++++
 fs/overlayfs/util.c      | 30 +++++++++++++++++
 include/linux/fs.h       |  3 ++
 7 files changed, 165 insertions(+), 49 deletions(-)

-- 
2.7.4
