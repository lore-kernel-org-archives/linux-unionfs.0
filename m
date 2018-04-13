From: Miklos Szeredi <miklos@szeredi.hu>
Subject: [GIT PULL] overlayfs update for 4.17
Date: Fri, 13 Apr 2018 10:47:13 +0200
Message-ID: <20180413084713.GD19579@veci.piliscsaba.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org

Hi Linus,

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git overlayfs-linus

In addition to bug fixes and cleanups there are two new features from Amir:

 - Consistent inode number support for the case when layers are not all on
   the same filesystem (feature is dubbed "xino").

 - Optimize overlayfs file handle decoding.  This one touches the exportfs
   interface to allow detecting the disconnected directory case.

Most of the code has been sitting in -next for a while now, but was rebased
due to a bug fix coming in yesterday.  I decided in favor of rebasing on
top of that fix to allow automatic stable backporting.

Thanks,
Miklos

---
Amir Goldstein (13):
      ovl: set i_ino to the value of st_ino for NFS export
      ovl: fix lookup with middle layer opaque dir and absolute path redirects
      ovl: set lower layer st_dev only if setting lower st_ino
      ovl: disambiguate ovl_encode_fh()
      ovl: do not try to reconnect a disconnected origin dentry
      ovl: lookup in inode cache first when decoding lower file handle
      ovl: factor out ovl_map_dev_ino() helper
      ovl: allocate anon bdev per unique lower fs
      ovl: constant st_ino for non-samefs with xino
      ovl: consistent i_ino for non-samefs with xino
      ovl: consistent d_ino for non-samefs with xino
      ovl: add support for "xino" mount and config options
      ovl: update documentation w.r.t "xino" feature

Miklos Szeredi (2):
      ovl: add WARN_ON() for non-dir redirect cases
      ovl: cleanup ovl_update_time()

Vivek Goyal (4):
      ovl: Set d->last properly during lookup
      ovl: Do not check for redirect if this is last layer
      ovl: set d->is_dir and d->opaque for last path element
      ovl: cleanup setting OVL_INDEX

---
 Documentation/filesystems/overlayfs.txt |  39 ++++++-
 fs/exportfs/expfs.c                     |   9 ++
 fs/overlayfs/Kconfig                    |  17 +++
 fs/overlayfs/copy_up.c                  |   6 +-
 fs/overlayfs/export.c                   |  75 +++++++------
 fs/overlayfs/inode.c                    | 188 ++++++++++++++++++++------------
 fs/overlayfs/namei.c                    |  67 ++++++++----
 fs/overlayfs/overlayfs.h                |  19 +++-
 fs/overlayfs/ovl_entry.h                |  21 +++-
 fs/overlayfs/readdir.c                  |  45 +++++++-
 fs/overlayfs/super.c                    | 157 ++++++++++++++++++++++----
 fs/overlayfs/util.c                     |  39 ++++++-
 12 files changed, 510 insertions(+), 172 deletions(-)
