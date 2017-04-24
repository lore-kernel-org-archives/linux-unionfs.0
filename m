From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v2 00/11] overlayfs constant inode numbers
Date: Mon, 24 Apr 2017 12:14:05 +0300
Message-ID: <1493025256-27188-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wr0-f193.google.com ([209.85.128.193]:33367 "EHLO
        mail-wr0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1167611AbdDXJOJ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 24 Apr 2017 05:14:09 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

Following your comments on the 'stable inodes' series from last week,
this series fixes constant inode numbers for stat(2) with any layer
configuration.

For the case of all *lower* layers on same fs that supports NFS export,
redirect by file handle will be used to optimize the lookup of the copy
up origin of non-dir inode.

For the case of *all* layers on same fs, overlayfs also gains:
- Persistent inode numbers for directories
- Correct results for du -x

Consistcy of stat(2) st_ino with readdir(3) d_ino is NOT addressed by
this series. It will be addressed for the 'samefs' configuration by the
follow up 'stable inode' work, which is also going to address preserving
hardlinks on copy up.

This series is available for testing on [1].
unionmount-testsuite needs a small fix patch for layers_check() [2].
Tested the following layer configurations:
 ./run --ov{,=0,=10} {,--samefs}

Tested constant inode numbers with xfstest overlay/017 and added a check
for persistent directory inode numbers across mount cycle [3].

Most of the patches in this series you already reviewed at one time or another
and have your comments already addressed. Some other patches are trivial.
Probably the only patches you need to take a closer look at are the 2 lookup
patches (5-6).

The implementation of lookup of a merged dir with a combination of redirect
by fh from upper and redirect by name in mid layer is more complicated.
Because this case is not strictly needed for this series, I simplified
things a bit and restricted lookup by fh to those cases:
1. Non directory (lookup of copy up origin)
2. Merge directory when ofs->numlower == 1

This restriction may be relaxed later on if we want to handle lookup by fh
with fallback to lookup by path for merge dirs.

What do you say? ... Too late for v4.12?

Amir.

[1] https://github.com/amir73il/linux/commits/ovl-constino
[2] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
[3] https://github.com/amir73il/xfstests/commits/overlayfs-devel

Amir Goldstein (11):
  ovl: store path type in dentry
  ovl: cram opaque boolean into type flags
  ovl: check if all layers are on the same fs
  ovl: store file handle of lower inode on copy up
  ovl: lookup redirect by file handle
  ovl: lookup non-dir inode copy up origin
  ovl: set the COPYUP type flag for non-dirs
  ovl: redirect non-dir by path on rename
  ovl: constant st_ino/st_dev across copy up
  ovl: persistent inode number for directories
  ovl: fix du --one-file-system on overlay mount

 fs/overlayfs/copy_up.c   |  98 +++++++++++++++++++++
 fs/overlayfs/dir.c       |  28 +++++-
 fs/overlayfs/inode.c     |  21 ++++-
 fs/overlayfs/namei.c     | 216 +++++++++++++++++++++++++++++++++++++++++------
 fs/overlayfs/overlayfs.h |  23 +++++
 fs/overlayfs/ovl_entry.h |   9 +-
 fs/overlayfs/super.c     |  21 +++++
 fs/overlayfs/util.c      |  83 ++++++++++++++++--
 8 files changed, 461 insertions(+), 38 deletions(-)

-- 
2.7.4
