From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 0/8] overlayfs:  fix ro/rw fd data inconsistecies
Date: Thu,  1 Dec 2016 11:14:55 +0100
Message-ID: <1480587303-25088-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wj0-f171.google.com ([209.85.210.171]:35553 "EHLO
        mail-wj0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752406AbcLAKPG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Dec 2016 05:15:06 -0500
Received: by mail-wj0-f171.google.com with SMTP id v7so199895501wjy.2
        for <linux-unionfs@vger.kernel.org>; Thu, 01 Dec 2016 02:15:06 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

Hi Al,

I'd like to hear your opinion on this patchset before queuing up for 4.10.

Here's the problem:

A file is opened for read-only, opened read-write (resulting in a copy up)
and modified.  The data read back from the the read-only fd will be stale
in this case (the read-only file descriptor still refers to the lower,
unmodified file).

This patchset fixes issues related to this corner case.

The VFS impact is minimal and performance in the non-corner cases shouldn't
suffer.

Git tree is here:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #overlayfs-rorw

Pathset is against #overlayfs-next.

Thanks,
Miklos

---
Miklos Szeredi (8):
  vfs: allow overlayfs to intercept file ops
  vfs: export filp_clone_open()
  mm: ovl: copy-up on MAP_SHARED
  ovl: add infrastructure for intercepting file ops
  ovl: intercept read_iter
  ovl: intercept mmap
  ovl: intercept fsync
  Revert "ovl: Warn on copy up if a process has a R/O fd open to the
    lower file"

 fs/internal.h            |   1 -
 fs/open.c                |   2 +-
 fs/overlayfs/copy_up.c   |  34 -------
 fs/overlayfs/inode.c     | 227 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/overlayfs/overlayfs.h |   2 +
 fs/overlayfs/super.c     |   1 +
 include/linux/fs.h       |   1 +
 mm/util.c                |  22 +++++
 8 files changed, 254 insertions(+), 36 deletions(-)

-- 
2.5.5
