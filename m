Return-Path: <amir73il@gmail.com>
Return-Path: <amir73il@gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH 0/4] Assorted overlayfs fixes for 4.19-rc5
Date: Tue, 18 Sep 2018 16:34:30 +0300
Message-Id: <20180918133434.27437-1-amir73il@gmail.com>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

Miklos,

Found one memory leak that needs a fix for stable and
two missing freeze protections in stacked f_ops.

Last patch is not a bugfix, but it fixes a trap that we set
for developers back in v4.10 - and you happened to step into.

The series passed xfstests -g quick with overlayfs over
xfs and ext4 and the usual unionmount testsuite torture.

The memory leak was detected with tests overlay/051,053
after I enabled kmemleak on my test setup.

Thanks,
Amir.

Amir Goldstein (4):
  ovl: fix memory leak on unlink of indexed file
  ovl: fix freeze protection bypass in ovl_write_iter()
  ovl: fix freeze protection bypass in ovl_clone_file_range()
  vfs: swap names of {do,vfs}_clone_file_range()

 fs/ioctl.c             |  2 +-
 fs/nfsd/vfs.c          |  3 ++-
 fs/overlayfs/copy_up.c |  2 +-
 fs/overlayfs/file.c    |  2 ++
 fs/overlayfs/util.c    |  3 ++-
 fs/read_write.c        | 17 +++++++++++++++--
 include/linux/fs.h     | 17 +++--------------
 7 files changed, 26 insertions(+), 20 deletions(-)

-- 
2.17.1
