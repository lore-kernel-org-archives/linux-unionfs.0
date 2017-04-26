From: Amir Goldstein <amir73il@gmail.com>
Subject: [PATCH v3 00/16] overlayfs constant inode numbers
Date: Thu, 27 Apr 2017 00:35:02 +0300
Message-ID: <1493242518-15266-1-git-send-email-amir73il@gmail.com>
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36721 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1030837AbdDZVfK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 26 Apr 2017 17:35:10 -0400
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, linux-unionfs@vger.kernel.org, linux-fsdevel@vger.kernel.org

Miklos,

This is v3 series of redirect by file handle and constant inode numbers.
this series fixes constant inode numbers for stat(2) with any layer
configuration.

For the case of all *lower* layers on same fs that supports NFS export,
redirect by file handle will be used to optimize the lookup of the copy
up origin of non-dir inode.

For the case of *all* layers on same fs, overlayfs also gains:
- Persistent inode numbers for directories
- Consistent st_dev for all overlay objects

Consistcy of stat(2) st_ino with readdir(3) d_ino is NOT addressed by
this series. It will be addressed for the 'samefs' configuration by the
follow up 'stable inode' work, which is also going to address preserving
hardlinks on copy up.

This series is available for testing on [1].
unionmount-testsuite was instrumented to verify constant inode numbers
after rename/link and mount cycle [2].

Tested the following layer configurations:
 ./run --ov{,=0,=1} {,--samefs}

The following test fails the constant inode number verification of upper
hardlink in the non-same-lower-fs configuration:
 ./run --ov=1 hard-link

xfstest overlay/017 was added a check for constant and persistent inode
numbers across rename and mount cycle [3].
Tested also ./check -overlay -g quick.

Changes since v2:
- Storing uuid of lower origin (and root fh for now)
- Re-factor ovl_lookup_single() (per your comment)
- Verify uuid of same_lower_sb (allow zero uuid)
- Find layer by root fh (see how you feel about that)
- d_drop() ovl_link() target (please comment on that)
- Updated overlayfs.txt

Amir.

[1] https://github.com/amir73il/linux/commits/ovl-constino
[2] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
[3] https://github.com/amir73il/xfstests/commits/overlayfs-devel

Amir Goldstein (16):
  ovl: store path type in dentry
  ovl: cram opaque boolean into type flags
  ovl: check if all layers are on the same fs
  ovl: store file handle of lower inode on copy up
  ovl: use an auxiliary var for overlay root entry
  ovl: factor out ovl_lookup_data()
  ovl: lookup redirect by file handle
  ovl: validate lower layer uuid and root on redirect by fh
  ovl: lookup non-dir inode copy up origin
  ovl: set the COPYUP type flag for non-dirs
  ovl: redirect non-dir by path on rename
  ovl: constant st_ino/st_dev across copy up
  ovl: persistent inode number for directories
  ovl: fix du --one-file-system on overlay mount
  ovl: persistent inode numbers for hardlinks
  ovl: update documentation w.r.t. constant inode numbers

 Documentation/filesystems/overlayfs.txt |  19 +-
 fs/overlayfs/copy_up.c                  | 142 +++++++++++++++
 fs/overlayfs/dir.c                      |  31 +++-
 fs/overlayfs/inode.c                    |  21 ++-
 fs/overlayfs/namei.c                    | 311 ++++++++++++++++++++++++++++----
 fs/overlayfs/overlayfs.h                |  37 ++++
 fs/overlayfs/ovl_entry.h                |   9 +-
 fs/overlayfs/super.c                    |  24 +++
 fs/overlayfs/util.c                     |  83 ++++++++-
 9 files changed, 622 insertions(+), 55 deletions(-)

-- 
2.7.4
