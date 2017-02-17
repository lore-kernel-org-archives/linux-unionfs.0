From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 0/9] overlay: fix inconsistency of ro file after copy-up
Date: Fri, 17 Feb 2017 17:09:29 +0100
Message-ID: <1487347778-18596-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:36705 "EHLO
        mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934163AbdBQQJn (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 17 Feb 2017 11:09:43 -0500
Received: by mail-wm0-f48.google.com with SMTP id c85so19390412wmi.1
        for <linux-unionfs@vger.kernel.org>; Fri, 17 Feb 2017 08:09:42 -0800 (PST)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org

A file is opened for read-only, opened read-write (resulting in a copy up)
and modified.  The data read back from the the read-only fd will be stale
in this case (the read-only file descriptor still refers to the lower,
unmodified file).

This patchset fixes issues related to this corner case.  This is a
requirement from various parties for accepting overlayfs as a "POSIX"
filesystem.

When an operation (read, mmap, fsync) is done on an overlay fd opened
read-only that is referring to a lower file, check if it has been copied up
in the mean time.  If so, open the upper file and use that for the operation.

To make the performance impact minimal for non-overlay case, use a flag in
file->f_mode to indicate that this is an overlay file.

Git tree is here:

git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #overlay-ro-rw-fix

Miklos Szeredi (9):
  vfs: extract common parts of {compat_,}do_readv_writev()
  vfs: pass type instead of fn to do_{loop,iter}_readv_writev()
  vfs: use helpers for calling f_op->{read,write}_iter()
  vfs: intercept reads to overlay files
  mm: ovl: copy-up on MAP_SHARED
  mm: use helper for calling f_op->mmap()
  ovl: intercept mmap on overlay files
  vfs: use helper for calling f_op->fsync()
  vfs: intercept fsync on overlay files

 drivers/block/loop.c                   |   4 +-
 drivers/gpu/drm/i915/i915_gem_dmabuf.c |   2 +-
 drivers/gpu/drm/vgem/vgem_drv.c        |   2 +-
 fs/Makefile                            |   2 +-
 fs/aio.c                               |   4 +-
 fs/coda/file.c                         |   2 +-
 fs/open.c                              |   2 +
 fs/overlay_util.c                      |  77 +++++++++++++++++++++
 fs/read_write.c                        | 121 +++++++++++++--------------------
 fs/splice.c                            |   2 +-
 fs/sync.c                              |   2 +-
 include/linux/fs.h                     |  42 ++++++++++++
 include/linux/overlay_util.h           |  17 +++++
 ipc/shm.c                              |   4 +-
 mm/mmap.c                              |   5 +-
 mm/nommu.c                             |   4 +-
 mm/util.c                              |  22 ++++++
 17 files changed, 227 insertions(+), 87 deletions(-)
 create mode 100644 fs/overlay_util.c
 create mode 100644 include/linux/overlay_util.h

-- 
2.5.5
