From: Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 0/3] overlayfs: allow moving directory trees
Date: Tue, 25 Oct 2016 09:34:44 +0200
Message-ID: <1477380887-21333-1-git-send-email-mszeredi@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-unionfs@vger.kernel.org
Cc: Guillem Jover <guillem@debian.org>, Raphael Hertzog <hertzog@debian.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

This allows overlayfs to move directory trees (residing on lower layer)
without having to recursively copy up the whole tree first.

This series is available in git at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git#redirect

And is on top of the overlayfs-next branch.

---
Miklos Szeredi (3):
  ovl: check fs features
  vfs: export vfs_path_lookup()
  ovl: redirect on rename-dir

 Documentation/filesystems/overlayfs.txt | 33 ++++++++++-
 fs/internal.h                           |  2 -
 fs/overlayfs/copy_up.c                  | 20 ++-----
 fs/overlayfs/dir.c                      | 86 +++++++++++++++++++---------
 fs/overlayfs/namei.c                    | 99 ++++++++++++++++++++++++++++++---
 fs/overlayfs/overlayfs.h                |  5 ++
 fs/overlayfs/ovl_entry.h                |  4 ++
 fs/overlayfs/super.c                    | 56 +++++++++++++++++--
 fs/overlayfs/util.c                     | 19 +++++++
 include/linux/namei.h                   |  2 +
 10 files changed, 268 insertions(+), 58 deletions(-)

-- 
2.5.5
