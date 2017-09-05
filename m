From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 0/3] overlayfs: vfs fixes
Date: Tue,  5 Sep 2017 09:46:33 +0200
Message-ID: <1504597596-17994-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f47.google.com ([74.125.82.47]:34907 "EHLO
        mail-wm0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751167AbdIEHqj (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 5 Sep 2017 03:46:39 -0400
Received: by mail-wm0-f47.google.com with SMTP id h144so1111893wme.0
        for <linux-unionfs@vger.kernel.org>; Tue, 05 Sep 2017 00:46:38 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: linux-fsdevel@vger.kernel.org
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, linux-unionfs@vger.kernel.org

Following patches fix overlayfs bugs.  The patches impact vfs code, so
posting for review to a wider audience.

They can also be found on the overlayfs-next branch:

 git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

Hoping to get these bugfixes into 4.14.

Thanks,
Miklos
---

Miklos Szeredi (3):
  vfs: add flags to d_real()
  ovl: fix relatime for directories
  ovl: don't allow writing ioctl on lower layer

 Documentation/filesystems/Locking |  2 +-
 Documentation/filesystems/vfs.txt |  2 +-
 fs/inode.c                        |  3 +-
 fs/internal.h                     |  2 ++
 fs/namespace.c                    | 64 +++++++++++++++++++++++++++++++++++++--
 fs/open.c                         |  8 ++---
 fs/overlayfs/super.c              | 10 ++++--
 fs/xattr.c                        |  9 +++---
 include/linux/dcache.h            | 15 ++++++---
 include/linux/fs.h                |  2 +-
 10 files changed, 95 insertions(+), 22 deletions(-)

-- 
2.5.5
