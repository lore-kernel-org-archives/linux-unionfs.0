From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [RFC PATCH v2 0/3] fix overlayfs locks and leases
Date: Thu, 21 Jul 2016 15:53:33 +0200
Message-ID: <1469109216-24353-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jeff Layton <jlayton@poochiereds.net>, "J. Bruce Fields" <bfields@fieldses.org>, Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-unionfs@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

I've split out the writecount handling and changed it around so that
underlying layers are consistent and yet leases work correctly on
overlayfs.

Also pushed to the tip of

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-next

Thanks,
Miklos
---

Miklos Szeredi (3):
  locks: fix file locking on overlayfs
  vfs: make argument of d_real_inode() const
  vfs: do get_write_access() on upper layer of overlayfs

 fs/locks.c              | 53 ++++++++++++++++++++++++++++---------------------
 fs/namespace.c          |  2 +-
 fs/open.c               | 17 +++++++++++++---
 fs/overlayfs/super.c    |  2 +-
 include/linux/dcache.h  |  5 +++--
 include/linux/fs.h      | 16 +++++++++++++--
 include/uapi/linux/fs.h |  1 +
 7 files changed, 64 insertions(+), 32 deletions(-)

-- 
2.5.5
