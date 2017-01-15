From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/6] ovl: concurrent copy up
Date: Sun, 15 Jan 2017 15:57:26 +0200
Message-ID: <1484488652-611-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:35680 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750991AbdAON5u (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 15 Jan 2017 08:57:50 -0500
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

This is my 2nd attempt to implement concurrent copy up
in overlayfs (3rd if you count the DCACHE_DELETE_LOCK flop).

It's not tagged as V2, because there is nothing in common
between the previous attempt and this one.

This work is based on Al's suggestion to use O_TMPFILE
for regular files and your very helpful waitqueue patch.

Patches 1-4 implement copy up of regular file using O_TMPFILE.
Since there is more common then different code wrt O_TMPFILE
vs. workdir+rename, I opted to keep ovl_copy_up_one() and
copy_up_one_locked() functions with a few 'if (tmpfile) else'
sprinkled around. It may be better to clone copy_up_one_locked()?

Patch 5 is the waitqueue patch you sent me. My only additions are
init_waitqueue_head() and wake_up_lock(), so I kept you as author.

Patch 6 puts it all together. Once again, in an attempt to keep
more common code, I added a few 'if (tmpfile)' and kept the locking
code generic, by assigning workdir = upperdir. I thought you may not
approve with this trick, but couldn't resist trying.

Beyond this simple test:
$ touch /lower/{empty,4g}
$ truncate -s 4g /lower/4g
$ touch /mnt/4g &  # takes a while
$ touch /mnt/empty # exits immediately
$ touch /mnt/4g    # blocks until %1 completes and can be interrupted

I also wrote xfstest overlay/021 which exercises concurrent copy up
using 8 processes on 4 directories and 4K files.

Amir.

Amir Goldstein (5):
  vfs: create vfs helper vfs_tmpfile()
  ovl: check if upperdir fs supports O_TMPFILE
  ovl: rearrange code in ovl_copy_up_locked()
  ovl: copy up regular file using O_TMPFILE
  ovl: concurrent copy up of regular files

Miklos Szeredi (1):
  ovl: introduce copy up waitqueue

 fs/namei.c               | 26 +++++++++-------
 fs/overlayfs/copy_up.c   | 78 +++++++++++++++++++++++++++++++++++-------------
 fs/overlayfs/overlayfs.h | 13 ++++++++
 fs/overlayfs/ovl_entry.h |  3 ++
 fs/overlayfs/super.c     | 11 +++++++
 fs/overlayfs/util.c      | 68 +++++++++++++++++++++++++++++++++++++++++
 include/linux/fs.h       |  1 +
 7 files changed, 170 insertions(+), 30 deletions(-)

-- 
2.7.4
