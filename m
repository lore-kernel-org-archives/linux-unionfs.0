From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.14
Date: Wed, 13 Sep 2017 16:05:28 +0200
Message-ID: <20170913140528.GA19278@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:35938 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751062AbdIMOFg (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 13 Sep 2017 10:05:36 -0400
Received: by mail-wr0-f193.google.com with SMTP id g50so172674wra.3
        for <linux-unionfs@vger.kernel.org>; Wed, 13 Sep 2017 07:05:36 -0700 (PDT)
Content-Disposition: inline
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

This fixes d_ino correctness in readdir, which brings overlayfs on par with
normal filesystems regarding inode number semantics, as long as all layers are
on the same filesystem.

There are also some bug fixes, one in particular (random ioctl's shouldn't be
able to modify lower layers) that touches some vfs code, but of course no-op for
non-overlay fs.

Thanks,
Miklos

---
Amir Goldstein (2):
      ovl: constant d_ino across copy up
      ovl: fix false positive ESTALE on lookup

Miklos Szeredi (7):
      ovl: check snprintf return
      ovl: fix readdir error value
      ovl: constant d_ino for non-merge dirs
      ovl: cleanup d_real for negative
      vfs: add flags to d_real()
      ovl: fix relatime for directories
      ovl: don't allow writing ioctl on lower layer

---
 Documentation/filesystems/Locking |   2 +-
 Documentation/filesystems/vfs.txt |   2 +-
 fs/inode.c                        |  21 ++-
 fs/internal.h                     |   2 +
 fs/namespace.c                    |  64 ++++++-
 fs/open.c                         |   8 +-
 fs/overlayfs/dir.c                |  11 +-
 fs/overlayfs/inode.c              |  14 +-
 fs/overlayfs/overlayfs.h          |   8 +-
 fs/overlayfs/readdir.c            | 383 ++++++++++++++++++++++++++++++++++----
 fs/overlayfs/super.c              |  11 +-
 fs/overlayfs/util.c               |  24 ++-
 fs/xattr.c                        |   9 +-
 include/linux/dcache.h            |  14 +-
 include/linux/fs.h                |   2 +-
 15 files changed, 496 insertions(+), 79 deletions(-)
