Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PFC][PATCH 0/4] Overlayfs SHUTDOWN ioctl
Date: Mon, 15 Jul 2019 16:38:35 +0300
Message-Id: <20190715133839.9878-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-fsdevel@vger.kernel.org, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

I was trying to think of a way forward w.r.t container runtime
mount leaks and overlayfs mount failures, see [1][2][3].

It does not seem reasonable to expect they will fix all the mount
leaks and that new ones will not show up. It's a hard problem to
solve.

I posted a fix patch to mitigate the recent regression with
index=off [2], but it does not seem reasonable to hold index=on feature
hostage for eternity or until all mount leaks are fixed.

The proposal I have come up with is to provide an API for containers
to shutdown the instance before unmount, so the leaked mounts become
"zombies" with no ability to do any harm beyond hogging resources.

The SHUTDOWN ioctl, used by xfs/ext4/f2fs to stop any access to
underlying blockdev is implemented in overlayfs to stop any access
to underlying layers. The real objects are still referenced, but no
vfs API can be called on underlying layers.

Naturally, SHUTDOWN releases the inuse locks to mitigate the mount
failures.

I wrote an xfstest to verify SHUTDOWN solves the mount leak issue [5].

Thoughts?

Thanks,
Amir.

[1] https://github.com/containers/libpod/issues/3540
[2] https://github.com/moby/moby/issues/39475
[3] https://github.com/coreos/linux/pull/339
[4] https://github.com/amir73il/linux/commits/ovl-overlap-detect-regression-fix
[5] https://github.com/amir73il/xfstests/commit/a56d5560e404cc8052a8e47850676364b5e8c76c

Amir Goldstein (4):
  ovl: support [S|G]ETFLAGS ioctl for directories
  ovl: use generic vfs_ioc_setflags_prepare() helper
  ovl: add pre/post access hooks to underlying layers
  ovl: add support for SHUTDOWN ioctl

 fs/overlayfs/copy_up.c   |  10 +-
 fs/overlayfs/dir.c       |  26 +++--
 fs/overlayfs/file.c      | 200 ++++++++++++++++++++++++++-------------
 fs/overlayfs/inode.c     |  64 +++++++++----
 fs/overlayfs/namei.c     |  15 ++-
 fs/overlayfs/overlayfs.h |  15 ++-
 fs/overlayfs/ovl_entry.h |   7 ++
 fs/overlayfs/readdir.c   |  17 +++-
 fs/overlayfs/super.c     |   9 +-
 fs/overlayfs/util.c      |  75 +++++++++++++--
 10 files changed, 318 insertions(+), 120 deletions(-)

-- 
2.17.1
